import assert from "node:assert/strict";
import { test } from "node:test";
import { monitorSession } from "./monitor.mjs";
import { createResumeReporter, refreshResumeContext } from "./resume.mjs";
import { createStatusTracker } from "./status.mjs";

function event(type, requestId, agentId) {
    return {
        type,
        data: {
            requestId,
        },
        agentId,
    };
}

test("recovers missed attention prompts and responses without live notifications", async () => {
    const prompts = [
        ["user_input.requested", "user_input.completed", "question"],
        ["elicitation.requested", "elicitation.completed", "question"],
        ["mcp.oauth_required", "mcp.oauth_completed", "permission"],
        ["exit_plan_mode.requested", "exit_plan_mode.completed", "permission"],
        ["auto_mode_switch.requested", "auto_mode_switch.completed", "permission"],
        ["session_limits_exhausted.requested", "session_limits_exhausted.completed", "question"],
    ];

    for (const [requested, completed, kind] of prompts) {
        const reports = [];
        const batches = [
            [event("assistant.turn_start"), event(requested, "prompt", "child")],
            [event(completed, "prompt", "child")],
            [event("session.shutdown")],
        ];
        let reads = 0;
        const session = {
            rpc: {
                eventLog: {
                    async read(options) {
                        assert.equal(options.cursor, reads === 0 ? undefined : String(reads));
                        assert.equal(options.waitMs, reads === 0 ? 0 : 30000);
                        assert.equal(options.agentScope, "all");
                        assert.equal(options.includeEphemeral, true);
                        const events = batches[reads].filter((value) => {
                            return options.types.includes(value.type);
                        });
                        reads += 1;
                        return {
                            events,
                            cursor: String(reads),
                            hasMore: false,
                        };
                    },
                },
                permissions: {
                    async pendingRequests() {
                        return {
                            items: [],
                        };
                    },
                },
            },
        };

        await monitorSession({
            session,
            tracker: createStatusTracker(),
            report(value) {
                reports.push(value);
            },
            onError(error) {
                throw error;
            },
        });
        const changes = reports.filter((value, index) => {
            return index === 0 || value !== reports[index - 1];
        });
        assert.deepEqual(changes, [
            `state=blocked:kind=${kind}:app=copilot`,
            "state=working:app=copilot",
            "state=clear",
        ], requested);
    }
});

test("unrelated subagent activity does not discard an in-flight permission snapshot", async () => {
    const tracker = createStatusTracker();
    const reports = [];
    const errors = [];
    let deliverEvents;
    let deliverPermissions;
    let observedWorking;
    let observedBlocked;
    const working = new Promise((resolve) => {
        observedWorking = resolve;
    });
    const blocked = new Promise((resolve) => {
        observedBlocked = resolve;
    });
    let reads = 0;
    const session = {
        rpc: {
            eventLog: {
                async read() {
                    reads += 1;
                    if (reads === 1) {
                        return {
                            events: [event("assistant.turn_start")],
                            cursor: "start",
                            hasMore: false,
                        };
                    }
                    return new Promise((resolve) => {
                        deliverEvents = resolve;
                    });
                },
            },
            permissions: {
                async pendingRequests() {
                    return new Promise((resolve) => {
                        deliverPermissions = resolve;
                    });
                },
            },
        },
    };
    const monitoring = monitorSession({
        session,
        tracker,
        report(value) {
            reports.push(value);
            if (reports.length >= 2 && value === "state=working:app=copilot") {
                observedWorking();
            }
            if (value === "state=blocked:kind=permission:app=copilot") {
                observedBlocked();
            }
        },
        onError(error) {
            errors.push(error);
        },
    });

    await Promise.resolve();
    deliverEvents({
        events: [
            event("assistant.turn_start", undefined, "child"),
            event("tool.execution_start", undefined, "child"),
            event("session.idle", undefined, "child"),
        ],
        cursor: "busy",
        hasMore: false,
    });
    await working;
    deliverPermissions({
        items: [{
            requestId: "missed",
        }],
    });
    await blocked;
    deliverEvents({
        events: [event("session.shutdown")],
        cursor: "shutdown",
        hasMore: false,
    });
    await monitoring;
    assert.equal(tracker.report(), "state=clear");
    assert.deepEqual(errors, []);
});

test("refreshes resume context only after replay and main-session context changes", async () => {
    const batches = [
        { events: [event("session.shutdown")], hasMore: true },
        { events: [event("session.resume")], hasMore: false },
        { events: [event("session.context_changed", undefined, "child")], hasMore: false },
        { events: [event("assistant.turn_start")], hasMore: false },
        { events: [event("session.context_changed")], hasMore: false },
        { events: [event("session.shutdown")], hasMore: false },
    ];
    const refreshedAt = [];
    const reports = [];
    let reads = 0;
    const session = {
        rpc: {
            eventLog: {
                async read({ types }) {
                    const batch = batches[reads++];
                    return {
                        ...batch,
                        events: batch.events.filter((value) => types.includes(value.type)),
                        cursor: String(reads),
                    };
                },
            },
            permissions: {
                async pendingRequests() {
                    return { items: [] };
                },
            },
        },
    };
    await monitorSession({
        session,
        tracker: createStatusTracker(),
        report(value) {
            reports.push(value);
        },
        async onContextChange() {
            refreshedAt.push(reads);
        },
        onError(error) {
            throw error;
        },
    });
    assert.deepEqual(refreshedAt, [2, 5]);
    assert.equal(reports.at(-1), "state=clear");
});

test("initial hydration publishes resume context even without lifecycle events", async () => {
    let reads = 0;
    let refreshed = 0;
    await monitorSession({
        session: {
            rpc: {
                eventLog: {
                    async read() {
                        return {
                            events: reads++ === 0 ? [] : [event("session.shutdown")],
                            hasMore: false,
                            cursor: String(reads),
                        };
                    },
                },
                permissions: {
                    async pendingRequests() {
                        return { items: [] };
                    },
                },
            },
        },
        tracker: createStatusTracker(),
        report() {},
        async onContextChange() {
            refreshed += 1;
        },
        onError(error) {
            throw error;
        },
    });
    assert.equal(refreshed, 1);
});

test("retries snapshot and terminal failures while reporting status during a long poll", async () => {
    for (const failure of ["snapshot", "write"]) {
        let deliverEvents;
        let attempts = 0;
        const attemptTimes = [];
        let writes = 0;
        let resolvePublished;
        const published = new Promise((resolve) => { resolvePublished = resolve; });
        const reports = [];
        const reporter = createResumeReporter({
            token: "test-token-with-at-least-22-characters",
            pid: 1234,
            write() {
                if (failure === "write" && writes++ === 0) {
                    throw new Error("terminal unavailable");
                }
                resolvePublished();
            },
        });
        let reads = 0;
        const session = {
            rpc: {
                eventLog: {
                    async read() {
                        if (reads++ === 0) {
                            return { events: [event("assistant.turn_start")], hasMore: false };
                        }
                        return new Promise((resolve) => { deliverEvents = resolve; });
                    },
                },
                permissions: { async pendingRequests() { return { items: [] }; } },
            },
        };
        const monitoring = monitorSession({
            session,
            tracker: createStatusTracker(),
            report: (value) => reports.push(value),
            onContextChange: (isCurrent) => refreshResumeContext({
                resume: reporter,
                async snapshot() {
                    attempts += 1;
                    attemptTimes.push(Date.now());
                    if (failure === "snapshot" && attempts === 1) {
                        throw new Error("metadata unavailable");
                    }
                    return { sessionId: "session", workingDirectory: "/tmp", isRemote: false };
                },
                isCurrent,
                onError() {},
            }),
            onError(error) { throw error; },
        });
        const timeout = setTimeout(() => resolvePublished(new Error("retry timed out")), 4000);
        const result = await published;
        clearTimeout(timeout);
        assert.equal(result, undefined);
        assert.equal(attempts, 2);
        assert.ok(attemptTimes[1] - attemptTimes[0] >= 900);
        assert.ok(reports.includes("state=working:app=copilot"));
        deliverEvents({ events: [event("session.shutdown")], hasMore: false });
        await monitoring;
    }
});

test("discards in-flight snapshots after context changes and shutdown", async () => {
    let deliverEvents;
    const snapshots = [];
    const writes = [];
    const reports = [];
    const reporter = createResumeReporter({
        token: "test-token-with-at-least-22-characters",
        pid: 1234,
        write: (value) => writes.push(value),
    });
    let reads = 0;
    const monitoring = monitorSession({
        session: {
            rpc: {
                eventLog: {
                    async read() {
                        if (reads++ === 0) {
                            return { events: [], hasMore: false };
                        }
                        return new Promise((resolve) => { deliverEvents = resolve; });
                    },
                },
                permissions: { async pendingRequests() { return { items: [] }; } },
            },
        },
        tracker: createStatusTracker(),
        report: (value) => reports.push(value),
        onContextChange: (isCurrent) => refreshResumeContext({
            resume: reporter,
            snapshot: () => new Promise((resolve) => snapshots.push(resolve)),
            isCurrent,
            onError() {},
        }),
        onError(error) { throw error; },
    });
    await Promise.resolve();
    assert.equal(snapshots.length, 1);
    deliverEvents({ events: [event("session.context_changed"), event("assistant.turn_start")], hasMore: false });
    await new Promise((resolve) => setImmediate(resolve));
    assert.ok(reports.includes("state=working:app=copilot"));
    snapshots[0]({ sessionId: "old", workingDirectory: "/tmp" });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(writes.length, 0);
    assert.equal(snapshots.length, 2);
    deliverEvents({ events: [event("session.shutdown")], hasMore: false });
    await monitoring;
    snapshots[1]({ sessionId: "new", workingDirectory: "/tmp" });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(writes.length, 0);
});

test("rejected remote context is not retried until the context changes", async () => {
    let deliverEvents;
    let attempts = 0;
    let resolvePublished;
    const published = new Promise((resolve) => { resolvePublished = resolve; });
    const reporter = createResumeReporter({
        token: "test-token-with-at-least-22-characters",
        pid: 1234,
        write: () => resolvePublished(),
    });
    let reads = 0;
    const monitoring = monitorSession({
        session: {
            rpc: {
                eventLog: {
                    async read() {
                        if (reads++ === 0) {
                            return { events: [], hasMore: false };
                        }
                        return new Promise((resolve) => { deliverEvents = resolve; });
                    },
                },
                permissions: { async pendingRequests() { return { items: [] }; } },
            },
        },
        tracker: createStatusTracker(),
        report() {},
        onContextChange: (isCurrent) => refreshResumeContext({
            resume: reporter,
            snapshot: async () => ({
                sessionId: "session",
                workingDirectory: "/tmp",
                isRemote: ++attempts === 1,
            }),
            isCurrent,
            onError() {},
        }),
        onError(error) { throw error; },
    });
    await new Promise((resolve) => setTimeout(resolve, 1100));
    assert.equal(attempts, 1);
    deliverEvents({ events: [event("session.context_changed")], hasMore: false });
    await published;
    assert.equal(attempts, 2);
    deliverEvents({ events: [event("session.shutdown")], hasMore: false });
    await monitoring;
});

test("refreshes again if a snapshot finishes while replay is catching up", async () => {
    let deliverEvents;
    const snapshots = [];
    const writes = [];
    const reporter = createResumeReporter({
        token: "test-token-with-at-least-22-characters",
        pid: 1234,
        write: (value) => writes.push(value),
    });
    let reads = 0;
    const monitoring = monitorSession({
        session: {
            rpc: {
                eventLog: {
                    async read() {
                        if (reads++ === 0) {
                            return { events: [], hasMore: false };
                        }
                        return new Promise((resolve) => { deliverEvents = resolve; });
                    },
                },
                permissions: { async pendingRequests() { return { items: [] }; } },
            },
        },
        tracker: createStatusTracker(),
        report() {},
        onContextChange: (isCurrent) => refreshResumeContext({
            resume: reporter,
            snapshot: () => new Promise((resolve) => snapshots.push(resolve)),
            isCurrent,
            onError() {},
        }),
        onError(error) { throw error; },
    });
    await Promise.resolve();
    deliverEvents({ events: [], hasMore: true });
    await new Promise((resolve) => setImmediate(resolve));
    snapshots[0]({ sessionId: "session", workingDirectory: "/tmp" });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(writes.length, 0);
    deliverEvents({ events: [], hasMore: false });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(snapshots.length, 2);
    snapshots[1]({ sessionId: "session", workingDirectory: "/tmp" });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(writes.length, 1);
    deliverEvents({ events: [event("session.shutdown")], hasMore: false });
    await monitoring;
});

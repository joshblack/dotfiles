import assert from "node:assert/strict";
import { test } from "node:test";
import { monitorSession } from "./monitor.mjs";
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

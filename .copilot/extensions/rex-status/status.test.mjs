import assert from "node:assert/strict";
import { test } from "node:test";
import { createStatusTracker } from "./status.mjs";

function event(type, data = {}, agentId) {
    return {
        type,
        data,
        agentId,
    };
}

test("startup attention requests return to idle without a user turn", () => {
    const prompts = [
        ["permission.requested", "permission.completed"],
        ["user_input.requested", "user_input.completed"],
        ["elicitation.requested", "elicitation.completed"],
        ["mcp.oauth_required", "mcp.oauth_completed"],
        ["exit_plan_mode.requested", "exit_plan_mode.completed"],
        ["auto_mode_switch.requested", "auto_mode_switch.completed"],
        ["session_limits_exhausted.requested", "session_limits_exhausted.completed"],
    ];

    for (const [requested, completed] of prompts) {
        const tracker = createStatusTracker();
        tracker.handle(event(requested, {
            requestId: "startup",
        }));
        assert.match(tracker.report(), /^state=blocked:/, requested);
        tracker.handle(event(completed, {
            requestId: "startup",
        }));
        assert.equal(tracker.report(), "state=idle:app=copilot", completed);
    }
});

test("startup permission snapshots return to idle when approvals are resolved", () => {
    const tracker = createStatusTracker();
    tracker.reconcilePermissions([{
        requestId: "startup",
    }]);
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");
    tracker.reconcilePermissions([]);
    assert.equal(tracker.report(), "state=idle:app=copilot");
});

test("stays working between model turns and finishes only when the session is idle", () => {
    const tracker = createStatusTracker();

    assert.equal(tracker.report(), "state=idle:app=copilot");
    tracker.handle(event("user.message"));
    assert.equal(tracker.report(), "state=working:app=copilot");
    tracker.handle(event("assistant.turn_start"));
    tracker.handle(event("tool.execution_complete"));
    assert.equal(tracker.report(), "state=working:app=copilot");
    tracker.handle(event("assistant.turn_end"));
    assert.equal(tracker.report(), "state=working:app=copilot");
    tracker.handle(event("session.idle"));
    assert.equal(tracker.report(), "state=done:app=copilot");
});

test("unrelated tool completions and prompts cannot overwrite pending approvals", () => {
    const tracker = createStatusTracker();

    tracker.handle(event("assistant.turn_start"));
    tracker.handle(event("permission.requested", {
        requestId: "first",
    }));
    tracker.handle(event("permission.requested", {
        requestId: "second",
    }));
    tracker.handle(event("tool.execution_complete"));
    tracker.handle(event("user.message"));
    tracker.handle(event("permission.completed", {
        requestId: "first",
    }));
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.handle(event("permission.completed", {
        requestId: "second",
    }));
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("tracks questions and elicitation independently from permissions", () => {
    const tracker = createStatusTracker();
    tracker.handle(event("assistant.turn_start"));

    tracker.handle(event("user_input.requested", {
        requestId: "shared-id",
    }));
    tracker.handle(event("elicitation.requested", {
        requestId: "shared-id",
    }));
    tracker.handle(event("permission.requested", {
        requestId: "shared-id",
    }));
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.handle(event("permission.completed", {
        requestId: "shared-id",
    }));
    tracker.handle(event("user_input.completed", {
        requestId: "shared-id",
    }));
    assert.equal(tracker.report(), "state=blocked:kind=question:app=copilot");

    tracker.handle(event("elicitation.completed", {
        requestId: "shared-id",
    }));
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("ignores permissions already resolved by another hook", () => {
    const tracker = createStatusTracker();

    tracker.handle(event("assistant.turn_start"));
    tracker.handle(event("permission.requested", {
        requestId: "resolved",
        resolvedByHook: true,
    }));
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("repeated requests and unknown completions do not lose pending requests", () => {
    const tracker = createStatusTracker();
    tracker.handle(event("assistant.turn_start"));

    tracker.handle(event("permission.requested", {
        requestId: "pending",
    }));
    tracker.handle(event("permission.requested", {
        requestId: "pending",
    }));
    tracker.handle(event("permission.completed", {
        requestId: "unknown",
    }));
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.handle(event("permission.completed", {
        requestId: "pending",
    }));
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("subagent lifecycle events cannot finish or reset the main session", () => {
    const tracker = createStatusTracker();

    tracker.handle(event("assistant.turn_start"));
    tracker.handle(event("assistant.turn_end", {}, "child"));
    tracker.handle(event("session.idle", {}, "child"));
    tracker.handle(event("session.shutdown", {}, "child"));
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("subagent approvals remain visible between main-agent model turns", () => {
    const tracker = createStatusTracker();

    tracker.handle(event("assistant.turn_start"));
    tracker.handle(event("permission.requested", {
        requestId: "approval",
    }, "child"));
    tracker.handle(event("assistant.turn_end"));
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.handle(event("permission.completed", {
        requestId: "approval",
    }, "child"));
    assert.equal(tracker.report(), "state=working:app=copilot");
    tracker.handle(event("session.idle"));
    assert.equal(tracker.report(), "state=done:app=copilot");
});

test("aborting a subagent removes only that agent's pending requests", () => {
    const tracker = createStatusTracker();
    tracker.handle(event("assistant.turn_start"));

    tracker.handle(event("permission.requested", {
        requestId: "approval",
    }));
    tracker.handle(event("user_input.requested", {
        requestId: "question",
    }, "child"));
    tracker.handle(event("abort", {}, "child"));
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.handle(event("permission.completed", {
        requestId: "approval",
    }));
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("cancellation and session idle clear requests left behind by interrupted tools", () => {
    for (const type of ["abort", "session.idle"]) {
        const tracker = createStatusTracker();

        tracker.handle(event("permission.requested", {
            requestId: "interrupted",
        }));
        tracker.handle(event(type));
        assert.equal(tracker.report(), "state=done:app=copilot");
        tracker.handle(event("assistant.turn_start"));
        assert.equal(tracker.report(), "state=working:app=copilot");
    }
});

test("shutdown clears the status and a replacement tracker starts idle", () => {
    const tracker = createStatusTracker();

    tracker.handle(event("permission.requested", {
        requestId: "old-session",
    }));
    tracker.handle(event("session.shutdown"));
    tracker.handle(event("tool.execution_start"));
    assert.equal(tracker.report(), "state=clear");
    assert.equal(createStatusTracker().report(), "state=idle:app=copilot");
});

test("reconciles pending approvals when live permission events are missing", () => {
    const tracker = createStatusTracker();

    tracker.reconcilePermissions([]);
    assert.equal(tracker.report(), "state=idle:app=copilot");

    tracker.reconcilePermissions([{
        requestId: "missed",
    }]);
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.handle(event("tool.execution_start"));
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    tracker.reconcilePermissions([]);
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("reconciling approvals preserves questions and known subagent ownership", () => {
    const tracker = createStatusTracker();

    tracker.handle(event("user_input.requested", {
        requestId: "question",
    }));
    tracker.handle(event("permission.requested", {
        requestId: "approval",
    }, "child"));
    tracker.reconcilePermissions([{
        requestId: "approval",
    }]);
    tracker.handle(event("abort", {}, "child"));
    assert.equal(tracker.report(), "state=blocked:kind=question:app=copilot");

    tracker.reconcilePermissions([{
        requestId: "missed",
    }]);
    tracker.reconcilePermissions([]);
    assert.equal(tracker.report(), "state=blocked:kind=question:app=copilot");
});

test("reconciliation cannot resurrect approvals after cancellation or shutdown", () => {
    for (const type of ["abort", "session.idle", "session.shutdown"]) {
        const tracker = createStatusTracker();

        tracker.handle(event("assistant.turn_start"));
        tracker.handle(event(type));
        const report = tracker.report();
        tracker.reconcilePermissions([{
            requestId: "stale",
        }]);
        assert.equal(tracker.report(), report);
    }
});

test("tracks sign-in, plan, mode-switch, and usage-limit prompts independently", () => {
    const prompts = [
        ["mcp.oauth_required", "mcp.oauth_completed", "permission"],
        ["exit_plan_mode.requested", "exit_plan_mode.completed", "permission"],
        ["auto_mode_switch.requested", "auto_mode_switch.completed", "permission"],
        ["session_limits_exhausted.requested", "session_limits_exhausted.completed", "question"],
    ];

    for (const [requested, completed, kind] of prompts) {
        const tracker = createStatusTracker();
        tracker.handle(event("assistant.turn_start"));
        tracker.handle(event("user_input.requested", {
            requestId: "shared",
        }));
        tracker.handle(event(requested, {
            requestId: "shared",
        }, "child"));
        assert.equal(tracker.report(), `state=blocked:kind=${kind}:app=copilot`);

        tracker.reconcilePermissions([]);
        assert.equal(tracker.report(), `state=blocked:kind=${kind}:app=copilot`);

        tracker.handle(event(completed, {
            requestId: "shared",
        }, "child"));
        assert.equal(tracker.report(), "state=blocked:kind=question:app=copilot");

        tracker.handle(event("user_input.completed", {
            requestId: "shared",
        }));
        assert.equal(tracker.report(), "state=working:app=copilot");
    }
});

test("permission reconciliation survives streaming and unrelated subagent activity", () => {
    const tracker = createStatusTracker();
    tracker.handle(event("assistant.turn_start"));
    const revision = tracker.permissionRevision;

    tracker.handle(event("assistant.message_delta"));
    tracker.handle(event("assistant.turn_start", {}, "child"));
    tracker.handle(event("tool.execution_start", {}, "child"));
    tracker.handle(event("session.idle", {}, "child"));
    tracker.reconcilePermissions([{
        requestId: "missed",
    }], revision);
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");
});

test("stale permission snapshots cannot overwrite newer requests or completions", () => {
    const tracker = createStatusTracker();
    tracker.handle(event("assistant.turn_start"));
    const beforeRequest = tracker.permissionRevision;

    tracker.handle(event("permission.requested", {
        requestId: "new",
    }));
    tracker.reconcilePermissions([], beforeRequest);
    assert.equal(tracker.report(), "state=blocked:kind=permission:app=copilot");

    const beforeCompletion = tracker.permissionRevision;
    tracker.handle(event("permission.completed", {
        requestId: "new",
    }));
    tracker.reconcilePermissions([{
        requestId: "new",
    }], beforeCompletion);
    assert.equal(tracker.report(), "state=working:app=copilot");
});

test("resuming a session resets old lifecycle state before replaying current prompts", () => {
    const tracker = createStatusTracker();
    tracker.handle(event("session.shutdown"));
    tracker.handle(event("session.resume"));
    tracker.handle(event("elicitation.requested", {
        requestId: "current",
    }));
    assert.equal(tracker.report(), "state=blocked:kind=question:app=copilot");
});

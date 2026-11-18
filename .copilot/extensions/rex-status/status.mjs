export function createStatusTracker() {
    let state = "idle";
    let permissionRevision = 0;
    const pending = new Map();

    function handle(event) {
        if (!event.agentId && (event.type === "session.start" || event.type === "session.resume")) {
            pending.clear();
            state = "idle";
            permissionRevision += 1;
            return;
        }
        if (state === "clear") {
            return;
        }

        const data = event.data;
        const family = event.type.split(".")[0];

        switch (event.type) {
            case "user.message":
            case "assistant.turn_start":
                if (!event.agentId) {
                    state = "working";
                    permissionRevision += 1;
                }
                break;

            case "tool.execution_start":
                state = "working";
                break;

            case "permission.requested":
            case "user_input.requested":
            case "elicitation.requested":
            case "mcp.oauth_required":
            case "exit_plan_mode.requested":
            case "auto_mode_switch.requested":
            case "session_limits_exhausted.requested":
                if (data.resolvedByHook) {
                    break;
                }
                pending.set(`${family}:${data.requestId}`, {
                    kind: ["permission", "mcp", "exit_plan_mode", "auto_mode_switch"].includes(family)
                        ? "permission"
                        : "question",
                    agentId: event.agentId,
                });
                if (family === "permission") {
                    permissionRevision += 1;
                }
                break;

            case "permission.completed":
            case "user_input.completed":
            case "elicitation.completed":
            case "mcp.oauth_completed":
            case "exit_plan_mode.completed":
            case "auto_mode_switch.completed":
            case "session_limits_exhausted.completed":
                pending.delete(`${family}:${data.requestId}`);
                if (family === "permission") {
                    permissionRevision += 1;
                }
                break;

            case "abort":
                permissionRevision += 1;
                if (event.agentId) {
                    for (const [key, request] of pending) {
                        if (request.agentId === event.agentId) {
                            pending.delete(key);
                        }
                    }
                    break;
                }
                pending.clear();
                state = "done";
                break;

            case "session.idle":
                if (!event.agentId) {
                    permissionRevision += 1;
                    pending.clear();
                    state = "done";
                }
                break;

            case "session.shutdown":
                if (!event.agentId) {
                    permissionRevision += 1;
                    pending.clear();
                    state = "clear";
                }
                break;
        }
    }

    function reconcilePermissions(requests, revision = permissionRevision) {
        if (state === "clear" || state === "done" || revision !== permissionRevision) {
            return;
        }

        const requestIds = new Set(requests.map((request) => {
            return request.requestId;
        }));
        for (const key of pending.keys()) {
            if (key.startsWith("permission:") && !requestIds.has(key.slice("permission:".length))) {
                pending.delete(key);
            }
        }
        for (const request of requests) {
            const key = `permission:${request.requestId}`;
            if (!pending.has(key)) {
                pending.set(key, {
                    kind: "permission",
                });
            }
        }
    }

    function report() {
        if (state === "clear") {
            return "state=clear";
        }

        for (const request of pending.values()) {
            if (request.kind === "permission") {
                return "state=blocked:kind=permission:app=copilot";
            }
        }
        if (pending.size > 0) {
            return "state=blocked:kind=question:app=copilot";
        }
        return `state=${state}:app=copilot`;
    }

    return {
        handle,
        reconcilePermissions,
        report,
        get permissionRevision() {
            return permissionRevision;
        },
    };
}

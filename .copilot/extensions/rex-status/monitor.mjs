import { setTimeout } from "node:timers/promises";

const eventTypes = [
    "session.start",
    "session.resume",
    "user.message",
    "assistant.turn_start",
    "tool.execution_start",
    "permission.requested",
    "permission.completed",
    "user_input.requested",
    "user_input.completed",
    "elicitation.requested",
    "elicitation.completed",
    "mcp.oauth_required",
    "mcp.oauth_completed",
    "exit_plan_mode.requested",
    "exit_plan_mode.completed",
    "auto_mode_switch.requested",
    "auto_mode_switch.completed",
    "session_limits_exhausted.requested",
    "session_limits_exhausted.completed",
    "abort",
    "session.idle",
    "session.shutdown",
];

export async function monitorSession({ session, tracker, report, onError }) {
    const controller = new AbortController();
    const { signal } = controller;
    let cursor;
    let hydrated = false;
    let caughtUp = false;
    let polling;

    async function pause() {
        try {
            await setTimeout(1000, undefined, {
                signal,
                ref: false,
            });
        } catch (error) {
            if (!signal.aborted) {
                throw error;
            }
        }
    }

    async function refreshPermissions() {
        while (!signal.aborted) {
            const revision = tracker.permissionRevision;
            try {
                const { items } = await session.rpc.permissions.pendingRequests();
                if (!signal.aborted && caughtUp) {
                    tracker.reconcilePermissions(items, revision);
                    report(tracker.report());
                }
            } catch (error) {
                if (!signal.aborted) {
                    onError(error);
                }
            }
            await pause();
        }
    }

    try {
        while (!signal.aborted) {
            try {
                const page = await session.rpc.eventLog.read({
                    cursor,
                    view: "replay",
                    types: eventTypes,
                    agentScope: "all",
                    includeEphemeral: true,
                    max: 1000,
                    waitMs: hydrated ? 30000 : 0,
                });
                cursor = page.cursor;
                caughtUp = !page.hasMore;
                for (const event of page.events) {
                    tracker.handle(event);
                }
                if (caughtUp) {
                    report(tracker.report());
                    if (tracker.report() === "state=clear") {
                        break;
                    }
                    if (!hydrated) {
                        hydrated = true;
                        polling = refreshPermissions();
                    }
                }
            } catch (error) {
                onError(error);
                await pause();
            }
        }
    } finally {
        controller.abort();
        await polling;
    }
}

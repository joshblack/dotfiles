import { setTimeout } from "node:timers/promises";

const eventTypes = [
    "session.start",
    "session.resume",
    "session.context_changed",
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

export async function monitorSession({ session, tracker, report, onError, onContextChange }) {
    const controller = new AbortController();
    const { signal } = controller;
    let cursor;
    let hydrated = false;
    let caughtUp = false;
    let polling;
    let contextRevision = 1;
    let refreshedRevision = 0;
    let contextRefresh;

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

    function refreshContext() {
        if (!onContextChange || contextRefresh || signal.aborted || !caughtUp ||
            tracker.report() === "state=clear" || refreshedRevision === contextRevision) {
            return;
        }
        const revision = contextRevision;
        const isCurrent = () => !signal.aborted && caughtUp &&
            tracker.report() !== "state=clear" && revision === contextRevision;
        contextRefresh = (async () => {
            let outcome;
            try {
                outcome = await onContextChange(isCurrent);
            } catch (error) {
                if (!signal.aborted) {
                    onError(error);
                }
                outcome = false;
            }
            if (outcome !== false && isCurrent()) {
                refreshedRevision = revision;
            } else if (outcome === false && revision === contextRevision) {
                await pause();
            }
        })().finally(() => {
            contextRefresh = undefined;
            refreshContext();
        });
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
                    if (!event.agentId && [
                        "session.start",
                        "session.resume",
                        "session.context_changed",
                    ].includes(event.type)) {
                        contextRevision += 1;
                    }
                }
                if (caughtUp) {
                    refreshContext();
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

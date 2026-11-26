import { closeSync, openSync, writeSync } from "node:fs";
import { joinSession } from "@github/copilot-sdk/extension";
import { monitorSession } from "./monitor.mjs";
import { createResumeReporter, refreshResumeContext } from "./resume.mjs";
import { createStatusTracker } from "./status.mjs";

if (process.env.REX_SESSION && process.env.REX_BLOCK) {
    const terminal = openSync("/dev/tty", "w");
    const tracker = createStatusTracker();
    let lastReport = "";
    let lastMonitorError = "";
    let resume;

    function clearResume() {
        try {
            resume?.clear();
        } catch (error) {
            console.error(`[rex-status] Failed to clear resume command: ${error.message}`);
        }
    }

    function report(value) {
        if (value === "state=clear") {
            clearResume();
        }
        if (value === lastReport) {
            return;
        }

        try {
            writeSync(terminal, `\x1b]7501;${value}\x1b\\`);
            lastReport = value;
            console.error(`[rex-status] ${value}`);
        } catch (error) {
            console.error(`[rex-status] Failed to report status: ${error.message}`);
        }
    }

    process.once("exit", () => {
        report("state=clear");
        closeSync(terminal);
    });
    process.once("SIGTERM", () => {
        process.exit(0);
    });
    process.once("SIGINT", () => {
        process.exit(0);
    });

    // Extension startup happens on /clear, before the next prompt's sessionStart hook.
    report(tracker.report());

    const session = await joinSession({
        requestedEnvironmentVariables: ["OSC7577_TOKEN"],
    });
    if (process.env.OSC7577_TOKEN) {
        try {
            resume = createResumeReporter({
                token: process.env.OSC7577_TOKEN,
                pid: process.ppid,
                write(value) {
                    writeSync(terminal, value);
                },
            });
        } catch (error) {
            console.error(`[rex-status] Failed to initialize resume reporting: ${error.message}`);
        }
    }
    void monitorSession({
        session,
        tracker,
        report,
        onContextChange(isCurrent) {
            return refreshResumeContext({
                resume,
                snapshot: () => session.rpc.metadata.snapshot(),
                isCurrent,
                onError: (message) => console.error(`[rex-status] ${message}`),
            });
        },
        onError(error) {
            if (error.message !== lastMonitorError) {
                console.error(`[rex-status] Failed to monitor status: ${error.message}`);
                lastMonitorError = error.message;
            }
        },
    });
} else {
    await joinSession();
}

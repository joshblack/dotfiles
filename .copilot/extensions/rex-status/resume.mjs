import { createHash } from "node:crypto";

export class InvalidResumeContextError extends Error {}

export async function refreshResumeContext({ resume, snapshot, isCurrent, onError }) {
    if (!resume) {
        return;
    }
    try {
        const metadata = await snapshot();
        if (isCurrent()) {
            resume.report(metadata);
        }
    } catch (error) {
        if (!isCurrent()) {
            return;
        }
        try {
            resume.clear();
        } catch (clearError) {
            onError(`Failed to clear resume command: ${clearError.message}`);
        }
        onError(`Failed to report resume command: ${error.message}`);
        return error instanceof InvalidResumeContextError;
    }
}

export function createResumeReporter({ token, pid, write }) {
    if (!/^[A-Za-z0-9_-]{22,64}$/.test(token)) {
        throw new Error("Invalid OSC7577_TOKEN");
    }
    if (!Number.isSafeInteger(pid) || pid <= 0) {
        throw new Error("Invalid Copilot process ID");
    }

    let lastReport = "";

    function sequence(value) {
        const body = `pid=${pid}:time=${Math.floor(Date.now() / 1000)}:${value}`;
        const mac = createHash("sha256").update(`${body}:${token}`).digest("hex");
        return `\x1b]7577;${body}:mac=${mac}\x1b\\`;
    }

    function clear() {
        if (lastReport) {
            write(sequence("clear=1"));
            lastReport = "";
        }
    }

    function report(metadata) {
        try {
            if (!metadata || typeof metadata !== "object") {
                throw new InvalidResumeContextError("Missing Copilot session metadata");
            }
            const { sessionId, workingDirectory, isRemote } = metadata;
            if (isRemote) {
                throw new InvalidResumeContextError("Remote Copilot sessions cannot be reported for Rex resume");
            }
            if (typeof sessionId !== "string" || !sessionId) {
                throw new InvalidResumeContextError("Missing Copilot session ID");
            }
            if (typeof workingDirectory !== "string" || !workingDirectory.startsWith("/")) {
                throw new InvalidResumeContextError("Copilot working directory must be an absolute path");
            }

            const argv = ["copilot", "--experimental", `--resume=${sessionId}`];
            const encode = (value) => {
                if (/[\u0000-\u001f\u007f-\u009f]/u.test(value) || !value.isWellFormed()) {
                    throw new InvalidResumeContextError("Resume arguments and directory must be UTF-8 text without control characters");
                }
                return Buffer.from(value, "utf8").toString("base64");
            };
            const value = `argv=${argv.map(encode).join(",")}:cwd=${encode(workingDirectory)}`;
            if (value === lastReport) {
                return;
            }
            const output = sequence(value);
            if (Buffer.byteLength(output) > 2048) {
                throw new InvalidResumeContextError("Copilot resume report exceeds Rex's 2048-byte limit");
            }
            write(output);
            lastReport = value;
        } catch (error) {
            clear();
            throw error;
        }
    }

    return { report, clear };
}

import { createHash } from "node:crypto";

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

    function report({ sessionId, workingDirectory, isRemote }) {
        try {
            if (isRemote) {
                throw new Error("Remote Copilot sessions cannot be reported for Rex resume");
            }
            if (typeof sessionId !== "string" || !sessionId) {
                throw new Error("Missing Copilot session ID");
            }
            if (typeof workingDirectory !== "string" || !workingDirectory.startsWith("/")) {
                throw new Error("Copilot working directory must be an absolute path");
            }

            const argv = ["copilot", "--experimental", `--resume=${sessionId}`];
            const encode = (value) => {
                if (/[\u0000-\u001f\u007f-\u009f]/u.test(value) || !value.isWellFormed()) {
                    throw new Error("Resume arguments and directory must be UTF-8 text without control characters");
                }
                return Buffer.from(value, "utf8").toString("base64");
            };
            const value = `argv=${argv.map(encode).join(",")}:cwd=${encode(workingDirectory)}`;
            if (value === lastReport) {
                return;
            }
            const output = sequence(value);
            if (Buffer.byteLength(output) > 2048) {
                throw new Error("Copilot resume report exceeds Rex's 2048-byte limit");
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

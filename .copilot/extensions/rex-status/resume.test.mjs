import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { test } from "node:test";
import { createResumeReporter, refreshResumeContext } from "./resume.mjs";

const token = "test-token-with-at-least-22-characters";
const metadata = {
    sessionId: "0cb916db-26aa-40f2-86b5-1ba81b225fd2",
    workingDirectory: "/Users/test/project with spaces",
    isRemote: false,
};

function setup() {
    const output = [];
    const reporter = createResumeReporter({
        token,
        pid: 1234,
        write(value) {
            output.push(value);
        },
    });
    return { reporter, output };
}

function decode(sequence) {
    assert.ok(sequence.startsWith("\x1b]7577;"));
    assert.ok(sequence.endsWith("\x1b\\"));
    const body = sequence.slice(7, -2);
    const macIndex = body.lastIndexOf(":mac=");
    assert.equal(body.slice(macIndex + 5), createHash("sha256")
        .update(`${body.slice(0, macIndex)}:${token}`).digest("hex"));
    assert.ok(!sequence.includes(token));
    const fields = Object.fromEntries(body.split(":").map((pair) => {
        const separator = pair.indexOf("=");
        return [pair.slice(0, separator), pair.slice(separator + 1)];
    }));
    assert.equal(fields.pid, "1234");
    assert.ok(Math.abs(Number(fields.time) - Date.now() / 1000) < 60);
    return fields;
}

test("reports an authenticated resume command and the session directory", () => {
    const { reporter, output } = setup();
    reporter.report(metadata);
    assert.equal(output.length, 1);
    const fields = decode(output[0]);
    assert.deepEqual(fields.argv.split(",").map((arg) => {
        return Buffer.from(arg, "base64").toString("utf8");
    }), ["copilot", "--experimental", `--resume=${metadata.sessionId}`]);
    assert.equal(Buffer.from(fields.cwd, "base64").toString("utf8"), metadata.workingDirectory);
});

test("deduplicates unchanged commands, updates context, and clears the owner's record", () => {
    const { reporter, output } = setup();
    reporter.clear();
    reporter.report(metadata);
    reporter.report(metadata);
    reporter.report({ ...metadata, workingDirectory: "/tmp/another-project" });
    reporter.report({ ...metadata, sessionId: "replacement-session" });
    reporter.clear();
    reporter.clear();
    assert.equal(output.length, 4);
    const cleared = decode(output[3]);
    assert.equal(cleared.clear, "1");
    assert.equal(cleared.argv, undefined);
    assert.equal(cleared.cwd, undefined);
    reporter.report(metadata);
    assert.equal(output.length, 5);
});

test("rejects remote sessions and invalid text, clearing any previous command", () => {
    const invalid = [
        { isRemote: true },
        { sessionId: "" },
        { sessionId: "session\ninjection" },
        { workingDirectory: "relative/path" },
        { workingDirectory: "/tmp/\u0085control" },
        { workingDirectory: "/tmp/\ud800" },
    ];
    for (const change of invalid) {
        const { reporter, output } = setup();
        reporter.report(metadata);
        assert.throws(() => reporter.report({ ...metadata, ...change }));
        assert.equal(output.length, 2);
        assert.equal(decode(output[1]).clear, "1");
    }
});

test("preserves Unicode and shell metacharacters as literal base64 arguments", () => {
    const { reporter, output } = setup();
    const workingDirectory = "/tmp/caf\u00e9/$(echo nope); project";
    reporter.report({ ...metadata, workingDirectory });
    assert.equal(Buffer.from(decode(output[0]).cwd, "base64").toString("utf8"), workingDirectory);
});

test("enforces the full 2048-byte sequence limit and clears stale oversized context", () => {
    const { reporter, output } = setup();
    reporter.report(metadata);
    const overhead = Buffer.byteLength(output[0]) -
        Buffer.byteLength(Buffer.from(metadata.workingDirectory).toString("base64"));
    const length = Math.floor((2048 - overhead) / 4) * 3;
    reporter.report({ ...metadata, workingDirectory: `/${"a".repeat(length - 1)}` });
    assert.ok(Buffer.byteLength(output[1]) <= 2048);
    assert.ok(Buffer.byteLength(output[1]) > 2044);
    assert.throws(() => reporter.report({
        ...metadata,
        workingDirectory: `/${"a".repeat(length)}`,
    }), /2048-byte limit/);
    assert.equal(output.length, 3);
    assert.equal(decode(output[2]).clear, "1");
});

test("validates the authentication token and owner PID", () => {
    for (const invalid of ["short", "a".repeat(65), `${"a".repeat(22)}!`, undefined]) {
        assert.throws(() => createResumeReporter({
            token: invalid,
            pid: 1234,
            write() {},
        }), /Invalid OSC7577_TOKEN/);
    }
    for (const pid of [0, -1, 1.5, Number.MAX_SAFE_INTEGER + 1]) {
        assert.throws(() => createResumeReporter({
            token,
            pid,
            write() {},
        }), /Invalid Copilot process ID/);
    }
});

test("failed terminal writes do not suppress a later retry", () => {
    const output = [];
    let failed = false;
    const reporter = createResumeReporter({
        token,
        pid: 1234,
        write(value) {
            if (!failed) {
                failed = true;
                throw new Error("terminal unavailable");
            }
            output.push(value);
        },
    });
    assert.throws(() => reporter.report(metadata), /terminal unavailable/);
    reporter.report(metadata);
    assert.equal(output.length, 1);
    assert.ok(decode(output[0]).argv);
});

test("classifies snapshot and write failures separately from rejected contexts", async () => {
    let failWrite = false;
    const reporter = createResumeReporter({
        token,
        pid: 1234,
        write() {
            if (failWrite) {
                throw new Error("terminal unavailable");
            }
        },
    });
    const errors = [];
    const refresh = (snapshot) => refreshResumeContext({
        resume: reporter,
        snapshot,
        isCurrent: () => true,
        onError: (message) => errors.push(message),
    });
    assert.equal(await refresh(async () => { throw new Error("metadata unavailable"); }), false);
    failWrite = true;
    assert.equal(await refresh(async () => metadata), false);
    failWrite = false;
    assert.equal(await refresh(async () => metadata), undefined);
    for (const invalid of [null, { ...metadata, isRemote: true }, { ...metadata, sessionId: "" }]) {
        assert.equal(await refresh(async () => invalid), true);
    }
    assert.equal(errors.length, 5);
});

test("retries a rejected context if clearing the previous report fails", async () => {
    let failClear = false;
    const reporter = createResumeReporter({
        token,
        pid: 1234,
        write() {
            if (failClear) {
                throw new Error("terminal unavailable");
            }
        },
    });
    reporter.report(metadata);
    failClear = true;
    const errors = [];
    const result = await refreshResumeContext({
        resume: reporter,
        snapshot: async () => ({ ...metadata, isRemote: true }),
        isCurrent: () => true,
        onError: (message) => errors.push(message),
    });
    assert.equal(result, false);
    assert.equal(errors.length, 2);
    failClear = false;
    assert.equal(await refreshResumeContext({
        resume: reporter,
        snapshot: async () => ({ ...metadata, isRemote: true }),
        isCurrent: () => true,
        onError() {},
    }), true);
});

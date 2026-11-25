# Copilot integration for Rex

Copy this directory to `~/.copilot/extensions/rex-status/` and enable Copilot's
experimental extensions (`copilot --experimental` or `/settings experimental on`).
The extension reports Copilot's activity and attention requests to Rex.

In Rex terminals that provide `OSC7577_TOKEN`, it also reports local sessions using
the [program resume protocol](https://www.superlogical.com/rex/docs/build/program-resume).
Rex can restore the CLI with `copilot --experimental --resume=<session-id>` in the
session's working directory. Reports use the parent CLI's PID, update when the
session context changes, and clear on session shutdown or extension exit.
Older Rex versions without the token retain status reporting only.

If Copilot asks for access to `OSC7577_TOKEN`, approve it to enable resume reporting.
The token is used only to authenticate terminal reports; it is never logged.
Remote sessions are not reported because their connection context cannot be
reconstructed from a local session ID. Other command-line flags and environment
overrides are not saved; restored sessions use the current CLI configuration.

Run the tests with `node --test .copilot/extensions/rex-status/*.test.mjs`.

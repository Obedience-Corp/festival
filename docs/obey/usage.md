---
title: "Use Obey and ob"
description: "Track agent sessions, send prompts, inspect results, and use ob for everyday development."
weight: 3
---

# Use Obey and ob

Run these examples inside an existing camp after
[setting up a provider]({{< ref "/obey/getting-started" >}}).

## Track agents you start yourself

Festival setup configures bridge hooks and terminal integration for supported
provider CLIs. Open a new terminal, then use your authenticated `claude`,
`codex`, or `grok` command normally. Inspect the resulting ledger with:

```sh
obey bridge status
obey session list
obey top
```

To discover sessions that were already running:

```sh
obey bridge reconcile --dry-run
obey bridge reconcile
```

Reconciliation can record an existing session. It cannot retrofit terminal
input control into that process. Sessions outside a camp are unassigned and
do not appear in the current camp's `obey top` view.

A bridged session can be observed without being fully controllable. On Linux
and macOS, terminal integration through `obey wrap` gives supported sessions an
input path. Other operations, including approval and restart, depend on the
session's capabilities. If a session has no verified input channel,
`obey session send` records an undelivered note rather than claiming the agent
received it.

## Start a session through Obey

For an authenticated Claude Code installation, for example:

```sh
obey launch claude-code
```

Or create a session with one operator prompt:

```sh
obey run --provider claude-code --model sonnet "Summarize this project's structure"
```

Choose a provider and model configured on your machine. Obey-owned sessions can
run agent work in their working directory. Use the returned session ID to inspect
the result or continue the conversation:

```sh
obey session list --all
obey session info id:SESSION_ID
obey session transcript id:SESSION_ID
obey session send id:SESSION_ID "Explain the test layout"
obey session stop id:SESSION_ID
```

Replace `SESSION_ID` with a real ID from the list or command output. For scripts,
`obey session list --json` and `obey session transcript id:SESSION_ID --json`
provide structured output. See the [session reference]({{< ref "/cli-reference/obey/obey_session" >}})
for selectors, filtering, approvals, and lifecycle commands.

## Use ob for developer tasks

`ob` renders a prompt template and sends it to the same daemon. Common commands
are:

| Command | Input and purpose |
| --- | --- |
| `ob plan spec.md` | Plan an implementation from a specification file. |
| `ob impl spec.md` | Request implementation patches from a specification. |
| `ob review` | Review unstaged Git changes. |
| `ob review main` | Review changes relative to a Git reference. |
| `ob debug path/to/file.go` | Analyze a source file for debugging. |
| `ob testgen path/to/file.go` | Generate tests for a source file. |
| `ob commit` | Generate a message from the staged diff. |

Preview a prompt without contacting the daemon:

```sh
ob plan spec.md --show-prompt
ob commands show plan
ob templates show plan
```

For a commit message, stage the intended changes first:

```sh
git add path/to/changed-file
git diff --cached
ob commit
```

`ob commit` generates the message; it does not make the Git commit. In a camp
project, use `camp p commit` to make the commit with your reviewed message.

## Continue across prompts

An ordinary `ob` prompt command is one-shot: it creates a session, sends the
prompt, and stops the session. Keep it running when you want a follow-up:

```sh
ob --keep-session --print-session-id plan spec.md
ob --reuse-session id:SESSION_ID impl spec.md
```

Use the ID printed by the first command. `--print-session-id` alone does not keep
a session alive. Stop a kept session when finished with
`obey session stop id:SESSION_ID`.

## Customize a prompt for one camp

```sh
ob templates init --campaign
ob commands list
ob commands show plan
ob templates status
```

Camp templates live in `.campaign/ob/templates/`. They take precedence over a
configured `templates_dir` and installed system templates. This is a different
directory from `.ob/config.yaml`, which holds camp preferences.

Inspect a template before adopting an update. `ob templates update` manages
template defaults; `ob config reset` overwrites the global settings file and
is not a template-update command.

## Festival execution and judging

`ob fest execute` runs Festival tasks through the daemon. Check
`ob fest execute --help` before starting an execution run.

`ob judge` is normally called by Fest with a structured checkpoint request on
stdin. It is not a free-form chat command. To configure the hook in the
festival's `.festival/config.yaml`:

```yaml
hooks:
  definitions:
    approval_judge:
      command: ob judge
```

Then use `fest workflow judge` at the appropriate checkpoint. The verdict is
JSON; a successful judge call can return either `approve` or `reject`.

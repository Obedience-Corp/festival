---
title: "ob CLI"
description: "Developer commands, configuration, templates, and session flags in the public Obey v0.2.3 package."
weight: 55
---

# ob CLI

`ob` renders developer prompts and sends them to the Obey daemon. Install it
with `festival install obey`; this installs both commands. See
[setup]({{< ref "/obey/getting-started" >}}),
[configuration]({{< ref "/obey/configuration" >}}), and
[examples]({{< ref "/obey/usage" >}}).

This reference follows the **Obey v0.2.3 public package**. Its `ob --version`
reports `0.1.0`; use the Festival package receipt to identify the release.
Run `ob COMMAND --help` for command-specific details.

## Prompt commands

| Syntax | Input and behavior |
| --- | --- |
| `ob commit` | Generate a commit message from staged Git changes; does not commit. |
| `ob plan <spec-file>` | Generate an implementation plan from a specification. |
| `ob impl <spec-file>` | Generate implementation patches from a specification. |
| `ob review [ref]` | Review unstaged Git changes, or a diff against the given reference. |
| `ob debug <file> [files...]` | Analyze errors and debug source files. |
| `ob testgen <file> [files...]` | Generate tests for source files. |

These commands accept:

| Flag | Meaning |
| --- | --- |
| `--show-prompt` | Print the rendered prompt and exit without calling the daemon. |
| `--timeout DURATION` | Total daemon wait; `0` disables this deadline. |
| `--idle-timeout DURATION` | Fail after this much silence; each daemon event resets it. `0` waits indefinitely. |
| `--queue-timeout DURATION` | Total wait for capacity. `0` fails on the first refusal. |

Durations use values such as `30s` or `5m`. The default is `0` for all three
deadlines except `ob commit`, whose idle timeout is `3m` and queue timeout is `10m`.
`ob commit --amend` generates a message for the complete prospective amended
commit; it still does not create or amend a Git commit.

```sh
ob plan spec.md --show-prompt
ob --provider claude-code --model sonnet plan spec.md --timeout 10m
```

## Configuration and providers

| Command | Purpose |
| --- | --- |
| `ob settings` | Open the interactive settings editor. |
| `ob settings get [key]` | Read effective settings. |
| `ob settings set <key> <value>` | Persist a global setting; add `--campaign` for the current camp. |
| `ob config show` | Show merged configuration and where values came from. |
| `ob config reset` | Replace the global configuration with defaults. |
| `ob providers` | Open the provider profile manager. |
| `ob doctor` | Diagnose configuration and daemon connectivity. |
| `ob status` | Show daemon status and summary. |

Supported settings keys are `provider`, `model`, `theme`, `socket_path`,
`templates_dir`, `max_context_files`, `max_context_bytes`, and `quiet`.
Global preferences live in `~/.obey/ob.yaml`; camp preferences live in
`<camp>/.ob/config.yaml`. Provider profiles and managed credentials belong to
the daemon and are configured through `ob providers`.

## Commands and templates

| Command | Purpose |
| --- | --- |
| `ob commands list` | List configured prompt commands. |
| `ob commands show <command>` | Inspect the winning template, shadowed files, and resolved provider/model. |
| `ob templates init` | Seed system templates; add `--campaign` for the current camp. |
| `ob templates show <name>` | Print template source. |
| `ob templates render <command> [args...]` | Preview a command's prompt without contacting the daemon. |
| `ob templates status` | Inspect installed templates and available updates. |
| `ob templates update [template...]` | Adopt available defaults, preserving edited templates by default. |

Use `ob templates update --dry-run` to inspect proposed changes, `--diff` to
see a diff, or `--campaign` to target camp templates. `--force` also replaces
edited templates after writing timestamped backups.

Templates resolve from `.campaign/ob/templates/` in the current camp, then
`templates_dir`, then `~/.obey/ob/templates/`, with embedded defaults as a
fallback. Template frontmatter can select a provider and model; inspect
`ob commands show COMMAND` when command-specific settings differ from your
ordinary defaults.

## Session and global flags

| Flag | Meaning |
| --- | --- |
| `--provider NAME` | Override the provider. |
| `--model NAME` | Override the model. |
| `--reasoning-effort LEVEL` | Request `none`, `low`, `medium`, `high`, `xhigh`, or `max`; refused when the provider cannot apply it. |
| `--socket PATH` | Override the daemon endpoint. |
| `--keep-session` | Keep the session running for follow-up prompts. |
| `--print-session-id` | Write `session_id=<id>` to stderr. Does not keep a session alive. |
| `--reuse-session ID` | Use an existing session; accepts a bare ID or `id:ID`. |
| `--quiet` | Suppress progress output on stderr. |
| `--verbose` | Report execution placement, context tier, and cold-load information after a turn. |
| `--help`, `-h` | Show help. |
| `--version`, `-v` | Show the internal `ob` binary version. |

Ordinary prompt commands create a session, run the prompt, and stop the session.
Use `--keep-session` on the first command before reusing its ID. Stop a kept
session with `obey session stop id:SESSION_ID`.

## Festival commands

`ob fest execute [festival-selector]` starts the daemon-driven task loop. It
accepts `--festival NAME_OR_ID`, `--once` to run only the next task, `--dry-run`
to inspect bootstrap information, and `--json` for a JSON bootstrap snapshot.
A linked project is used when available; otherwise execution uses the festival
directory. A project link is not required.

`ob judge` reads a `fest.approval.judge/v1` request from stdin and writes a JSON
verdict. It is normally invoked by `fest workflow judge` through the configured
approval hook. `--render` previews its prompt without contacting the daemon;
`--timeout` sets the model wait. A `reject` verdict can still exit successfully:
callers must read the verdict, not treat exit status zero as approval.

## Completion and exit status

`ob completion bash`, `ob completion zsh`, `ob completion fish`, and
`ob completion powershell` generate shell completion scripts. Each subcommand's
help includes installation instructions for that shell.

Prompt commands return `0` on completion, `75` when the daemon is unreachable,
and `1` for other failures. Exit `75` means the prompt has not run.

`ob` normally tries to start the default local daemon, preferring an installed
service. An explicit endpoint pointing elsewhere disables that automatic start.
Set `OB_NO_AUTOSTART` to any value to disable automatic startup. See
[troubleshooting]({{< ref "/obey/troubleshooting" >}}) for connection checks.

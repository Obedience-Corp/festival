---
title: "Claude Code"
weight: 15
---

# Claude Code

Claude Code runs Festival through a plugin. The plugin does not replace the loop: the loop is still `fest next`, do the task, `fest task completed`, `fest commit`. What the plugin adds is that the methodology skills are already loaded, the `fest` and `camp` verbs have slash-command shortcuts, and two agents are available for planning and execution.

Order matters. Install the binaries first, then open a camp, then install the plugin.

## 1. Install Festival

Pick one:

```bash
# Homebrew
brew install --cask Obedience-Corp/tap/festival

# npm, pnpm, or bun
npm install -g @obedience-corp/festival

# Shell script
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

Then check all three binaries answer:

```bash
fest --version
camp --version
festival --version
```

If either one is missing or resolves somewhere you did not expect, `festival doctor` reports the installer's view of your PATH, sources, and receipts. Full install options are on the [installation page](../installation/).

The plugin's session-start hook installs both binaries for you ([section 5](#5-the-install-hook)), so this step is belt and braces. Do it anyway: your shell has `fest` and `camp` before the first session starts, and you can confirm where they resolve from rather than finding out mid-loop.

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout, initializes git, and creates the festivals tree. It also writes two context files, or rather one file and one link:

```bash
$ ls -l AGENTS.md CLAUDE.md
-rw-r--r--  AGENTS.md
lrwxr-xr-x  CLAUDE.md -> AGENTS.md
```

That symlink is the point. Claude Code reads `CLAUDE.md`, Festival writes `AGENTS.md`, and the link means one file serves both. Edit `AGENTS.md`; your Claude Code sessions see the same content.

`camp init` also links the camp skills into `.claude/skills` and `.agents/skills`. Those are camp's own skills for working in a camp, and they are separate from the plugin bundle described below.

If you are scripting `camp init` rather than running it in a terminal, it needs a description and a mission up front:

```bash
camp init -d "what this camp is" -m "what it is for"
```

## 3. Install the Festival plugin

Two spellings for the same thing.

From inside a Claude Code session:

```text
/plugin marketplace add Obedience-Corp/festival
/plugin install festival@festival
```

From a shell:

```bash
claude plugin marketplace add Obedience-Corp/festival
claude plugin install festival@festival
```

The shell form is the one that was exercised while writing this page, against Claude Code 2.1.235. The in-session slash-command form is the one the plugin bundle documents; it cannot be driven from a script, so it was not run here.

Add `--yes` to the shell install when you are running it from a script rather than a terminal. Claude Code requires it whenever stdin or stdout is not a TTY.

Both spellings resolve the same thing: a marketplace manifest at the repository root whose single entry points at the `claude-plugin/` subdirectory.

## 4. What the plugin ships

Counted from the bundle, not from a README:

- **12 skills**, one `SKILL.md` each, covering camp navigation, camp structure, commit discipline, festival planning, festival execution, standalone workflows, and work intake.
- **11 slash commands**, which are shortcuts to the CLI verbs you would otherwise type: `/fest-next`, `/fest-commit`, `/festival-plan`, and eight more.
- **2 agents**: `fest-executor` and `fest-planner`.
- **2 hooks**: a `SessionStart` installer and a `PreToolUse` commit guard, described in sections 5 and 6.

Claude Code is one of two harnesses that carries every one of these surfaces. Other agents get a subset: Codex takes the skills and the hook but not the commands or agents, and Gemini takes the skills as context imports. The [section index](../) covers the differences.

One thing to know when you inspect the plugin yourself: `claude plugin details festival` reports a single count of 23 for skills. That is the 12 skills and the 11 commands added together under one label. There are 12 skills.

## 5. The install hook

The plugin's `SessionStart` hook runs `ensure-festival.sh`, which downloads `fest` and `camp` if they are missing, checksum-verifies the archive, installs them, and checks for updates once a day. It is idempotent, so it does nothing when the binaries are already current.

Both hooks load, and the plugin reports itself enabled:

```text
$ claude plugin list
Installed plugins:

  ❯ festival@festival
    Version: 1.3.1
    Scope: user
    Status: ✔ enabled
```

`claude plugin details festival@festival` lists them as `Hooks (2)  SessionStart, PreToolUse`, marked harness-only, so neither costs you model context. The hook fix ships in plugin 1.3.1.

Earlier bundles shipped a hook manifest that Claude Code rejected: the plugin installed, then reported `Status: failed to load` with `Hook load failed: hooks: Invalid input: expected record, received undefined`, and both hooks were silently lost while skills, commands, and agents kept working. If you see that on an older install, update the plugin (`claude plugin update festival@festival`); the fix is in the bundle, not in your configuration.

## 6. The commit guard

A `PreToolUse` hook on `Bash` blocks a raw `git commit` inside a camp. Camps have their own commit verbs, and they exist so that work stays traceable: `camp commit` at the camp root, `camp p commit` inside `projects/*`, and `fest commit` during a festival.

Because a plugin hook fires in every session, the guard self-scopes. It blocks a command only when all three of these hold:

- the command has a raw `git commit` segment, and
- the session is inside a camp, and
- both `camp` and `jq` are available.

Outside a camp, in repositories without `camp`, or on machines without `jq`, it exits without interfering. To override it deliberately for a single command, set `CAMP_ALLOW_RAW_GIT=1`.

The guard splits a compound command on `;`, `&&`, `||`, and newlines and checks each segment from its start, so a raw commit hidden after a wrapper is still caught. It is a discipline guard rather than a security control: it does not try to defeat `bash -c`, aliases, or `eval`.

## 7. The loop

Give the agent the loop once and it repeats it:

```text
fest intro
fest next
<do exactly the task fest next prints>
fest task completed
fest commit -m "<message>"
fest validate
fest next
```

`fest next` only works inside a festival directory, not at the camp root. An agent that starts at the root will get `not inside a festival` and should navigate into `festivals/active/<festival>` before retrying.

The plugin's slash commands are shortcuts to these same verbs. `/fest-next` and `fest next` do the same work; nothing about the loop changes when you use one or the other.

Phase gates are checkpoints for a human. The agent submits a gate and stops. You run `fest workflow approve` when you have looked at what it did.

## 8. Going further

[Claude Code project management](/use-cases/claude-code-project-management/) covers the session-instructions pattern: what to put in front of the agent so it drives the loop without being told each step. The [quickstart](../quickstart/) is the agent-agnostic version of this page.

## What was verified

The shell install flow was exercised against Claude Code 2.1.235 on 2026-08-19, at plugin version 1.3.1, in an isolated configuration directory, from a local marketplace path pointing at the branch that carries the hook fix (the `Obedience-Corp/festival` shorthand serves it once that release is out). `claude plugin list` reported `enabled`, `claude plugin details` reported both hooks, and a session's debug log showed `Registered 2 hooks from 1 plugins` followed by `Hook SessionStart:startup (SessionStart) success` with the installer's own output. The older failure quoted in section 5 was reproduced side by side from a fixture carrying the previous manifest shape. Component counts were taken from the plugin tree on the same date. The in-session slash-command form is documented by the plugin bundle and was not exercised from a script.

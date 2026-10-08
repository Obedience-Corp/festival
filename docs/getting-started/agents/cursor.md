---
title: "Cursor"
weight: 17
---

# Cursor

Cursor's plugin system, which shipped in Cursor 2.5, carries every Festival surface: skills, commands, agents, and hooks. This is the fullest bundle after Claude Code. The loop is unchanged: `fest next`, do the task, `fest task completed`, `fest commit`.

Order matters. Install the binaries first, then open a camp, then add the plugin.

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

The plugin's install hook does this for you as well, in the way section 5 describes. Doing it by hand first means the agent's first `fest` command never races the download.

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` at the root describing all of it. That file is the context every agent reads.

## 3. Add the Festival plugin

The plugin lives in the Festival repository at `cursor-plugin/`, a self-contained plugin directory with its manifest at `cursor-plugin/.cursor-plugin/plugin.json`. The repository root carries `.cursor-plugin/marketplace.json`, which lists that one plugin.

Cursor's public channel is the Cursor Marketplace, and getting listed there is a manual submission of the public git repository, reviewed by Cursor. The Festival listing has not been submitted yet, so there is no marketplace entry to search for today. Once it is listed, you will install it from **Customize** in the Cursor sidebar: find Festival, select **Install**, and choose a project or user scope.

Until then, install it as a local plugin. Cursor loads plugins from `~/.cursor/plugins/local/<name>`, so copy the directory there:

```bash
git clone https://github.com/Obedience-Corp/festival.git
mkdir -p ~/.cursor/plugins/local
cp -R festival/cursor-plugin ~/.cursor/plugins/local/festival
```

Then restart Cursor or run **Developer: Reload Window**, and open **Customize** to check that the Festival skills, commands, and agents are listed. Copy the directory; do not symlink it. Cursor skips a symlink in that folder when its target is outside the folder. On Teams and Enterprise plans, local plugins load only when an admin allows local plugin imports.

For a single Cursor CLI session, you can point the CLI at the clone instead:

```bash
agent --plugin-dir /path/to/festival/cursor-plugin
```

On a Teams or Enterprise plan, an admin can make the plugin available to everyone: **Dashboard -> Plugins & MCPs**, **Add Marketplace** under **Team Marketplaces**, then **Import from Repo** with `https://github.com/Obedience-Corp/festival`. Cursor reads `.cursor-plugin/marketplace.json` from the repository root and finds the plugin at `cursor-plugin/`.

An earlier version of this page pointed at an in-editor `/add-plugin` command. Cursor's current plugin documentation describes no such command; use one of the paths above.

## 4. What the plugin ships

Counted from the bundle:

- **12 skills**, one `SKILL.md` each, covering camp navigation, camp structure, commit discipline, festival planning, festival execution, standalone workflows, and work intake.
- **11 commands**, the same `fest-*` and `camp-*` verbs available as slash commands.
- **2 agents**: `fest-executor` and `fest-planner`.
- **1 hook**, the installer described in the next section.

Cursor and Claude Code are the two harnesses that carry all four surfaces. If you have read the [Codex page](../codex/) and noticed it is shorter, that is why: Codex takes the skills and the hook, and its commands and agents live elsewhere. The [section index](../) compares them.

## 5. How the CLIs get installed

Like the Codex and Gemini bundles, the Cursor bundle installs the tools from a session start hook. The details below explain why it does not use a shell-command hook instead.

The bundle runs the installer from a `sessionStart` hook, which fires when a new agent session starts. The hook command is `bash "${CURSOR_PLUGIN_ROOT}/hooks/scripts/cursor-install-hook.sh"` with a 120 second timeout, and Cursor replaces `${CURSOR_PLUGIN_ROOT}` with the plugin's install path.

`cursor-install-hook.sh` is a small wrapper. It reads and discards the hook payload, runs `ensure-festival.sh` with all of that script's output sent to stderr, then prints `{}` and exits 0, even when the install fails.

The installer is deliberately not a permission hook such as `beforeShellExecution`. A permission hook has to answer allow, deny, or ask for every shell command, and Cursor's documentation does not say whether an allow answer also skips your normal approval prompt. An installer should never be in that position, so it stays out of the command path entirely.

The trade-off: Cursor does not wait for `sessionStart`, so on a machine without the tools the agent's first `fest` command in the very first session can run before the download finishes and fail with `command not found`. It works once the install completes, and every later session starts with the tools present. The installer is idempotent, does nothing when the binaries are current, and checks for a newer release at most once a day.

The tools install to `~/.local/bin`, which has to be on the `PATH` of the shell Cursor runs commands in. Two environment variables change the installer's paths if they are set where Cursor runs hooks: `INSTALL_DIR` for the binaries and `FESTIVAL_CACHE_DIR` for the once-a-day update check stamp. Nothing else needs configuring; the plugin declares no variables.

## 6. AGENTS.md

`camp init` writes `AGENTS.md` at the camp root, and it is the file to keep as your context. Edit it as the camp grows; do not replace it with an editor-specific context file, or your sessions stop seeing the camp instructions.

Start Cursor at the camp root. Projects inside a camp are usually their own git repositories, and a session started inside one may resolve a different context file, or none.

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

Phase gates are checkpoints for a human. The agent submits a gate and stops. You run `fest workflow approve` when you have looked at what it did.

## What was verified

On 2026-10-08 the plugin was loaded with the Cursor CLI (`agent` 2026.10.01) using `agent -p --plugin-dir <clone>/cursor-plugin` in an empty git directory, with the installer's cache and install directories pointed at scratch paths. The agent's context listed the 12 skills from `cursor-plugin/skills/` and the 2 agents from `cursor-plugin/agents/`, and a test `echo` ran. In a second run, with the installer replaced by a stub that records each call, the `sessionStart` hook ran once at session start, with the plugin directory as its working directory.

Not verified: the Cursor editor itself (the steps in section 3 that use **Customize**, the local plugin folder, and team marketplaces come from Cursor's documentation), the 11 slash commands (the CLI's `-p` mode did not show them, and their registration was not observed in the editor), and a first install that actually downloads `fest` and `camp` from inside Cursor.

`just plugin check` enforces the bundle's structure: the manifest parses, every path it references stays inside `cursor-plugin/` and exists, the hook command runs from `${CURSOR_PLUGIN_ROOT}` and points at a file that exists, the repository-root `.cursor-plugin/` holds only `marketplace.json` and its entry resolves to `cursor-plugin/`, the hook is a `sessionStart` hook and no permission hook is registered, and the wrapper prints `{}` and exits 0 when the installer is missing, fails, or succeeds.

Everything else about how Cursor behaves, including the fire-and-forget `sessionStart` and the marketplace submission process, comes from Cursor's documentation (cursor.com/docs/hooks, cursor.com/docs/plugins, cursor.com/docs/reference/plugins) as read on 2026-10-07. If Cursor has changed since then, the bundle README at `cursor-plugin/README.md` is the next place to look.

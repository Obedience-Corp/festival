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

The plugin's install hook does this for you as well, in the way section 5 describes. Doing it by hand first means your first shell command in a session does not pause.

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` at the root describing all of it. That file is the context every agent reads.

## 3. Add the Festival plugin

The plugin bundle lives in the Festival repository at `.cursor-plugin/`.

Cursor installs plugins from the Cursor Marketplace, and getting listed there is a manual submission of the public git repository, reviewed by Cursor. The Festival listing has not been submitted yet, so there is no marketplace entry to search for today.

Until it is live, work from a local clone:

```bash
git clone https://github.com/Obedience-Corp/festival.git
```

Then add the plugin from that clone with Cursor's in-editor `/add-plugin`. The exact prompt flow depends on your Cursor version, so follow what the editor asks rather than a command line copied from here.

That is deliberately all this page shows. Cursor's documented install surface is the marketplace and the in-editor verb; there is no documented shell command for adding a plugin from a path, and inventing one would be worse than saying so.

## 4. What the plugin ships

Counted from the bundle:

- **12 skills**, one `SKILL.md` each, covering camp navigation, camp structure, commit discipline, festival planning, festival execution, standalone workflows, and work intake.
- **11 commands**, the same `fest-*` and `camp-*` verbs available as slash commands.
- **2 agents**: `fest-executor` and `fest-planner`.
- **1 hook**, the installer described in the next section.

Cursor and Claude Code are the two harnesses that carry all four surfaces. If you have read the [Codex page](../codex/) and noticed it is shorter, that is why: Codex takes the skills and the hook, and its commands and agents live elsewhere. The [section index](../) compares them.

## 5. How the CLIs get installed

This is the one place where the Cursor bundle differs in shape from the others, and the reason is worth knowing.

Cursor's `sessionStart` hook is fire and forget: the agent loop does not wait for it. An installer started there is not guaranteed to have finished before the agent tries to run `fest`, which would produce a confusing `command not found` on the first task of a session and then work fine afterwards.

So the Festival bundle does not use `sessionStart`. It runs the installer from a blocking `beforeShellExecution` hook instead. The practical effect is that the first shell command of a session may pause briefly while `fest` and `camp` install. After that the hook is effectively free: the script is idempotent, so it does nothing when the binaries are current, it rate-limits its update check to once a day, and it writes only to stderr.

The fire-and-forget behavior of `sessionStart` comes from Cursor's hooks documentation as captured in the Festival plugin survey on 2026-06-16.

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

No Cursor CLI was installed on the machine this page was written on, so nothing on this page was run against Cursor. Saying that plainly matters more than the page looking authoritative.

What was verified is structural, and it was verified on 2026-08-19. The generated bundle parses, every path its manifest references resolves, and the hook wiring is exactly what section 5 describes: `.cursor-plugin/hooks/hooks.json` declares one `beforeShellExecution` entry running the installer script, and the manifest declares all four component directories. `just plugin check` enforces that structure and passes. The component counts in section 4 were taken from the bundle tree on the same date.

Everything about how Cursor behaves, including the fire-and-forget `sessionStart` and the marketplace submission process, comes from Cursor's own documentation as captured in the Festival plugin survey on 2026-06-16. If Cursor has changed since then, this page has not caught up, and the bundle README under `.cursor-plugin/` is the next place to look.

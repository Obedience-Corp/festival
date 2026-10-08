---
title: "opencode"
weight: 20
---

# opencode

Skills are native in opencode, and plugin code runs at load, so Festival's bundle here is small: a short JavaScript plugin plus the skills tree. The plugin has two jobs: at load, make sure `fest` and `camp` exist, and before each shell command, stop a raw `git commit` inside a camp. Everything else is opencode's own discovery doing the work.

The loop is unchanged: `fest next`, do the task, `fest task completed`, `fest commit`.

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

The plugin tries to do this for you at load. It is best effort by design, as section 5 explains, so doing it once by hand is the reliable path.

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` at the root describing all of it.

## 3. Install the Festival plugin

There are three places opencode will find it.

### Project

A checkout of the Festival repository already carries `.opencode/plugins/festival.js`, and opencode picks it up automatically for work inside that repository. This is how the repo's own contributors get it. It does nothing for your own project, so it is listed for completeness rather than as a path to follow.

### Global

Copy the three directories into your opencode config:

```bash
git clone https://github.com/Obedience-Corp/festival.git
mkdir -p ~/.config/opencode
cp -R festival/.opencode/plugins festival/.opencode/scripts festival/.opencode/skills ~/.config/opencode/
```

This is the path to use if you want Festival available everywhere.

### Declared in opencode.json

Reference it from the `plugin` array in your `opencode.json`. opencode accepts an npm package, a scoped package, or a git URL there:

```json
{
  "plugin": ["https://github.com/Obedience-Corp/festival.git"]
}
```

The git URL is the path today. There is no published npm package for the opencode plugin, and no official curated marketplace for opencode plugins at all, so a package name is not something this page can honestly give you. If one is published later it will be documented in the repository's `.opencode/INSTALL.md`.

## 4. Skills

The 12 Festival skills ship under `.opencode/skills/`, and opencode's native skill auto-discovery picks them up. There is no registration step and no config edit.

One detail worth knowing if you work in camps: opencode also auto-discovers `.claude/skills/<name>/SKILL.md` and `.agents/skills/`. `camp init` writes camp skills into both of those directories, and `camp` projects them into worktrees as well. So a session started inside a camp or a camp worktree already sees those skills without any opencode-specific copy.

## 5. How the CLIs get installed

The plugin is a single exported async function, and opencode runs its body once at load, handing it a Bun shell. The body uses that shell to run `ensure-festival.sh`, which downloads `fest` and `camp` if they are missing, checksum-verifies the archive, and installs them.

Two properties of that, both deliberate:

- **It is idempotent.** When the binaries are already current it does nothing.
- **It never blocks plugin load, and it swallows failures.** If the install cannot run, opencode still starts normally.

The second one is the tradeoff to be aware of. A failed install does not announce itself; it looks like nothing happened, and then `fest` is missing when the agent first reaches for it. That is why section 1 tells you to install the binaries yourself. If you ever land in that state, the fallback is the same one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

## 6. The commit guard

Camps have their own commit verbs so that work stays traceable: `camp commit` at the camp root, `camp p commit` inside `projects/*`, and `fest commit` during a festival. The plugin registers a `tool.execute.before` hook, and before every `bash` tool call it runs `scripts/commit-guard.sh`, the same script the Claude Code plugin ships, with the command and the directory the command will run in: the call's `workdir` resolved against the session directory, or the session directory itself.

The guard blocks only when both of these hold:

- the command has a raw `git commit` segment, including one after `;`, `&&`, or `||`, and
- `camp id` succeeds in that directory, so the command runs inside a camp.

On a block the hook throws with the guard's reason, which names the right verb. opencode does not run the command, marks the `bash` call as an error, and hands that reason to the model as the tool result. The hook runs before opencode's permission check and can only throw or return, so it never approves anything. Everything else passes untouched: commands outside a camp, a machine without `camp` or `jq`, and a guard that fails to start or exits with anything but its block code. To make one raw commit deliberately, set `CAMP_ALLOW_RAW_GIT=1`.

A global install fires the hook in every opencode session, and it stays quiet outside a camp.

## 7. AGENTS.md

`camp init` writes `AGENTS.md` at the camp root, and it is the file to keep as your context. Start opencode at the camp root so the session picks it up. Projects inside a camp are usually their own git repositories, and a session started inside one may resolve a different context file, or none.

## 8. The loop

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

On 2026-10-08, opencode 1.18.35 was run through `npx` with an isolated home and config directory, the generated `.opencode/` bundle copied into a scratch camp as a project plugin, and a local stand-in model endpoint configured as a custom provider, so no credentials were involved. `opencode run` was scripted to make one `bash` call, `git commit --allow-empty -m test`. The call came back with status `error` and the guard's reason as its text, that same text reached the model as the tool result, and the scratch repository stayed at zero commits. The same run with `CAMP_ALLOW_RAW_GIT=1` committed. The plugin's load-time install ran in those sessions. Native skills auto-discovery and the global and `opencode.json` install paths were not exercised.

`just plugin check` also imports the generated plugin under Node with a stub shell and calls its `tool.execute.before` hook with the `bash` tool's input and output shapes. A raw `git commit` in a temp camp throws with the guard's reason, including through a `workdir` that points into a camp, while `fest commit`, `git status`, a commit outside a camp, a non-`bash` tool, malformed arguments, `CAMP_ALLOW_RAW_GIT=1`, and a guard that crashes all pass. That the hook runs before the permission check was read from the opencode 1.18.35 source rather than observed.

What was verified, on 2026-08-19: the generated plugin parses and the path it references resolves, which `just plugin check` enforces and which passes; the skills tree under `.opencode/skills/` holds 12 skills generated from the same source as every other harness; and there is no published npm package for this plugin, checked against the registry directly.

The behavior described in sections 3 through 5, including the three install locations, the extra `.claude/skills/` and `.agents/skills/` discovery, and the Bun shell available to a plugin at load, comes from opencode's documentation as captured in the Festival plugin survey on 2026-06-16. If opencode has changed since then, `.opencode/INSTALL.md` in the repository is the next place to look.

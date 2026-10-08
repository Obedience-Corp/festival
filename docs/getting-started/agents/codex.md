---
title: "Codex"
weight: 16
---

# Codex

Codex runs Festival through a plugin that carries the skills, a session-start hook, and a commit guard. The loop is the same `fest next` loop it is everywhere else. The plugin's job is narrow: make sure the `fest` and `camp` CLIs exist, make sure the agent knows the vocabulary, and stop a raw `git commit` inside a camp.

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

The plugin's session-start hook installs these too, so this step is belt and braces. Doing it by hand means your first session works before the hook has run once.

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` at the root. That last file is the one Codex reads as persistent instructions, which is why section 6 is worth reading before you start editing it.

## 3. Install the Festival plugin

From a shell, which is the form verified for this page:

```bash
codex plugin marketplace add Obedience-Corp/festival
codex plugin add festival@festival
codex plugin list
```

From inside a Codex session, `/plugins` opens the plugin browser, where you can add the marketplace and install Festival.

Note the verb. It is `codex plugin add`; there is no `codex plugin install`.

Then trust the hooks. Codex skips plugin-bundled hooks until you review and trust them, and it records trust against each hook's current definition, so this comes up again after an update that changes a hook. Open `/hooks` in a Codex session and trust the Festival entries. Until you do, neither the installer nor the commit guard runs.

Here is the real output of that last shell command, after the install:

```text
Marketplace `festival`
.../marketplaces/festival/.agents/plugins/marketplace.json

PLUGIN             STATUS              VERSION  PATH
festival@festival  installed, enabled  1.3.1    .../marketplaces/festival/plugins/festival
```

Festival self-hosts its marketplace inside the repository, at `.agents/plugins/marketplace.json`, which is what the `Obedience-Corp/festival` shorthand resolves. Per the Codex plugin survey verified 2026-06-16, OpenAI's curated directory had no self-serve publishing at that time, so self-hosting is the available channel rather than a preference.

## 4. What the plugin ships

- **12 skills**, one `SKILL.md` each, covering camp navigation, camp structure, commit discipline, festival planning, festival execution, standalone workflows, and work intake.
- **A `SessionStart` hook** that installs and updates the CLIs. See section 7.
- **A `PreToolUse` hook** on `Bash` that blocks a raw `git commit` inside a camp. See section 8.

Skills are Codex's recommended primitive for this kind of capability, so a skills-plus-hook bundle is the native shape on this harness rather than a stripped-down one. What the next section describes is not missing functionality; it is the same functionality reached through a different door.

## 5. What it does not ship, and why

Festival's slash commands do not ship as Codex plugin components. Codex custom prompts are deprecated in favor of skills, and the plugin manifest spec lists no `commands` field, so there is nowhere to put them. This costs you nothing in practice: the slash commands are thin wrappers around `fest` and `camp` verbs, and those CLIs are exactly what the hook installs. Type `fest next` instead of `/fest-next`.

Festival's two agents do not ship either. Codex subagents are configuration scope, defined as TOML under `~/.codex/agents/` or `.codex/agents/`, rather than bundled through a plugin manifest. If you want a planner or executor subagent you can write that TOML yourself; Festival does not ship the file, so this page does not walk you through one.

Both of these are harness capability facts recorded in the Festival plugin survey, verified 2026-06-16, and confirmed against the shipped bundle. Neither is a defect in Codex or in Festival.

## 6. AGENTS.md

Codex reads `AGENTS.md` as persistent instructions, resolved through a precedence chain, with a 32 KiB cap (survey, verified 2026-06-16). `camp init` writes one at the camp root describing the camp layout and the commands to use.

Two consequences:

- **Start Codex at the camp root** so it picks that file up. A session started inside a project subdirectory may resolve a different `AGENTS.md`, or none.
- **Keep it lean.** Past the cap Codex truncates rather than failing, so an overgrown `AGENTS.md` loses its tail silently. Put durable camp instructions in it and let festival documents carry the detail.

## 7. The install hook

The plugin's `SessionStart` hook runs `ensure-festival.sh` from the plugin root on every session start. It downloads `fest` and `camp` if they are missing, checksum-verifies the archive, and installs them, and it checks for updates once a day. It is idempotent, so it does nothing when the binaries are already current.

That is why there is no manual step after `codex plugin add`.

Codex nests hook events under a top-level `hooks` object, the same shape Claude Code wants. Bundles before this release put the events at the top level; the generated Codex manifest now carries the wrapper.

Codex also refuses a plugin hooks file with any other top-level key. Earlier bundles carried a `_generated` provenance key there, and Codex CLI 0.161.0 rejected the whole file with ``unknown field `_generated`, expected `description` or `hooks` ``, so no Festival hook loaded at all. The generated file now holds only `description` and `hooks`.

## 8. The commit guard

Camps have their own commit verbs so that work stays traceable: `camp commit` at the camp root, `camp p commit` inside `projects/*`, and `fest commit` during a festival. The plugin's `PreToolUse` hook on `Bash` runs `commit-guard.sh`, the same script the Claude Code plugin ships, before every shell command Codex runs. Codex hands it the command as `tool_input.command` and the session directory as `cwd`, the input the script already reads.

It blocks only when both of these hold:

- the command has a raw `git commit` segment, including one after `;`, `&&`, or `||`, and
- `camp id` succeeds in the session directory, so the session is inside a camp.

A block exits 2 with the reason on stderr. Codex does not run the command and hands the model `Command blocked by PreToolUse hook:` followed by that reason, which names the right verb. Every other path exits 0 with no output, so the guard never interferes outside a camp, on a machine without `camp` or `jq`, or on input it cannot parse, and it never answers an approval prompt. To make one raw commit deliberately, set `CAMP_ALLOW_RAW_GIT=1`.

The guard sees the session directory, not a per-command working directory, so start Codex inside the camp. A session started outside a camp that commits into one is not stopped.

## 9. The loop

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

On 2026-10-08, with Codex CLI 0.161.0, an isolated `CODEX_HOME` and home directory, the Festival worktree added as a local marketplace, and a local stand-in model endpoint configured as a custom provider so no credentials were involved, `codex exec` was scripted to run `git commit --allow-empty -m test` in a scratch camp. With the hooks trusted for the run (`--dangerously-bypass-hook-trust`), the command never ran, the scratch repository stayed at zero commits, and the model received `Command blocked by PreToolUse hook: raw git commit is forbidden inside a camp; ...`. The same run with `CAMP_ALLOW_RAW_GIT=1` committed. A run without the trust flag also committed, which is the trust gate in section 3 at work. The `PreToolUse` input Codex sent was captured and matches the fields listed in section 8. Before the `_generated` key was removed, the same setup reported `failed to parse plugin hooks config` and ran neither hook; after, the session-start hook ran as well. The in-session `/hooks` trust flow was not exercised.

The shell install flow was run against Codex CLI 0.147.0 on 2026-08-19 with an isolated `CODEX_HOME`, using both the `Obedience-Corp/festival` shorthand and a local repository path. Both produced `installed, enabled` at plugin version 1.3.1, and the `codex plugin list` excerpt in section 3 is from that run. Component counts were taken from the plugin tree on the same date.

The in-session slash-command spelling is documented by the plugin bundle and was not exercised from a script. In that 2026-08-19 run the session-start hook was not observed firing on Codex, because an isolated `CODEX_HOME` carries no credentials and the run stopped at authentication. The same hook was observed firing on Claude Code (see that page's verification note). The commands and agents gap in section 5 comes from the Festival plugin survey, verified 2026-06-16.

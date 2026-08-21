---
title: "Codex"
weight: 16
---

# Codex

Codex runs Festival through a plugin that carries the skills and a session-start hook. The loop is the same `fest next` loop it is everywhere else. The plugin's job is narrow: make sure the `fest` and `camp` CLIs exist, and make sure the agent knows the vocabulary.

Order matters. Install the binaries first, then open a campaign, then install the plugin.

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

## 2. Open a campaign

A campaign is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-campaign && cd my-campaign
camp init
```

`camp init` writes the campaign layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` at the root. That last file is the one Codex reads as persistent instructions, which is why section 6 is worth reading before you start editing it.

## 3. Install the Festival plugin

From a shell, which is the form verified for this page:

```bash
codex plugin marketplace add Obedience-Corp/festival
codex plugin add festival@festival
codex plugin list
```

From inside a Codex session, which is the form the plugin bundle documents:

```text
/plugin marketplace add Obedience-Corp/festival
/plugin install festival
```

Note the verb. Non-interactively it is `codex plugin add`; there is no `codex plugin install`. The in-session slash command is spelled `/plugin install`. Both are correct in their own context.

Here is the real output of that last shell command, after the install:

```text
Marketplace `festival`
.../marketplaces/festival/.agents/plugins/marketplace.json

PLUGIN             STATUS              VERSION  PATH
festival@festival  installed, enabled  1.3.1    .../marketplaces/festival/plugins/festival
```

Festival self-hosts its marketplace inside the repository, at `.agents/plugins/marketplace.json`, which is what the `Obedience-Corp/festival` shorthand resolves. Per the Codex plugin survey verified 2026-06-16, OpenAI's curated directory had no self-serve publishing at that time, so self-hosting is the available channel rather than a preference.

## 4. What the plugin ships

- **12 skills**, one `SKILL.md` each, covering campaign navigation, campaign structure, commit discipline, festival planning, festival execution, standalone workflows, and work intake.
- **A `SessionStart` hook** that installs and updates the CLIs. See section 7.

Skills are Codex's recommended primitive for this kind of capability, so a skills-plus-hook bundle is the native shape on this harness rather than a stripped-down one. What the next section describes is not missing functionality; it is the same functionality reached through a different door.

## 5. What it does not ship, and why

Festival's slash commands do not ship as Codex plugin components. Codex custom prompts are deprecated in favor of skills, and the plugin manifest spec lists no `commands` field, so there is nowhere to put them. This costs you nothing in practice: the slash commands are thin wrappers around `fest` and `camp` verbs, and those CLIs are exactly what the hook installs. Type `fest next` instead of `/fest-next`.

Festival's two agents do not ship either. Codex subagents are configuration scope, defined as TOML under `~/.codex/agents/` or `.codex/agents/`, rather than bundled through a plugin manifest. If you want a planner or executor subagent you can write that TOML yourself; Festival does not ship the file, so this page does not walk you through one.

Both of these are harness capability facts recorded in the Festival plugin survey, verified 2026-06-16, and confirmed against the shipped bundle. Neither is a defect in Codex or in Festival.

## 6. AGENTS.md

Codex reads `AGENTS.md` as persistent instructions, resolved through a precedence chain, with a 32 KiB cap (survey, verified 2026-06-16). `camp init` writes one at the campaign root describing the campaign layout and the commands to use.

Two consequences:

- **Start Codex at the campaign root** so it picks that file up. A session started inside a project subdirectory may resolve a different `AGENTS.md`, or none.
- **Keep it lean.** Past the cap Codex truncates rather than failing, so an overgrown `AGENTS.md` loses its tail silently. Put durable campaign instructions in it and let festival documents carry the detail.

## 7. The install hook

The plugin's `SessionStart` hook runs `ensure-festival.sh` from the plugin root on every session start. It downloads `fest` and `camp` if they are missing, checksum-verifies the archive, and installs them, and it checks for updates once a day. It is idempotent, so it does nothing when the binaries are already current.

That is why there is no manual step after `codex plugin add`.

Codex nests hook events under a top-level `hooks` object, the same shape Claude Code wants. Bundles before this release put the events at the top level; the generated Codex manifest now carries the wrapper.

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

`fest next` only works inside a festival directory, not at the campaign root. An agent that starts at the root will get `not inside a festival` and should navigate into `festivals/active/<festival>` before retrying.

Phase gates are checkpoints for a human. The agent submits a gate and stops. You run `fest workflow approve` when you have looked at what it did.

## What was verified

The shell install flow was run against Codex CLI 0.147.0 on 2026-08-19 with an isolated `CODEX_HOME`, using both the `Obedience-Corp/festival` shorthand and a local repository path. Both produced `installed, enabled` at plugin version 1.3.1, and the `codex plugin list` excerpt in section 3 is from that run. Component counts were taken from the plugin tree on the same date.

The in-session slash-command spelling is documented by the plugin bundle and was not exercised from a script. The session-start hook's corrected manifest parses and the plugin loads enabled; the hook was not observed firing on Codex, because an isolated `CODEX_HOME` carries no credentials and the run stopped at authentication. The same hook was observed firing on Claude Code (see that page's verification note). The commands and agents gap in section 5 comes from the Festival plugin survey, verified 2026-06-16.

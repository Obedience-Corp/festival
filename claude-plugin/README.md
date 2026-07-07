# Festival Plugin for Claude Code

## What this is

A domain plugin that teaches Claude Code to drive the `fest` and `camp` CLIs and
the Festival methodology. It bundles slash commands, methodology skills,
specialized agents, a session hook that keeps the CLIs installed, and a
commit-discipline guard.

It is not a generic engineering-process library. Its scope is the Festival
methodology and the fest/camp toolchain. For the methodology itself, see the
docs linked at the end.

## Layout

```
claude-plugin/
  .claude-plugin/plugin.json    plugin manifest (name, version, description)
  skills/                       8 skills, one SKILL.md each
  commands/                     10 fest-* and camp-* slash commands
  agents/                       fest-executor, fest-planner
  hooks/
    hooks.json                  SessionStart + PreToolUse hook wiring
    scripts/ensure-festival.sh  installs and updates fest and camp
    scripts/commit-guard.sh     blocks raw `git commit` inside a campaign
    scripts/commit-guard.test.sh  unit tests for the guard (run by the gate)
    scripts/sync-check.sh       checks plugin command refs against the CLIs
```

The marketplace manifest lives at the festival repo root, not inside this
directory:

```
.claude-plugin/marketplace.json   repo-root marketplace entry; source points at ./claude-plugin
```

Claude Code discovers a marketplace manifest only at
`<repo-root>/.claude-plugin/marketplace.json`, and each entry's `source`
resolves relative to the repo root. Because the plugin bundle is the
`claude-plugin/` subdirectory, the manifest sits at the repo root with
`source: "./claude-plugin"`.

## Install

Two paths.

Marketplace flow. Add the festival repo as a marketplace, then install the
plugin:

```
/plugin marketplace add Obedience-Corp/festival
/plugin install festival@festival
```

This resolves the repo-root `marketplace.json`, whose single entry points at the
in-repo bundle (`source: "./claude-plugin"`).

Direct subdirectory add:

```
claude plugin add --source git-subdir --url Obedience-Corp/festival --path claude-plugin
```

On first session the `SessionStart` hook (`hooks/scripts/ensure-festival.sh`)
downloads `fest` and `camp` if they are missing, checksum-verifies the archive,
and installs them. It also checks for updates once per day and notifies you when
a new release is available.

## Commit guard

A `PreToolUse` (Bash) hook (`hooks/scripts/commit-guard.sh`) enforces campaign
commit discipline: commits must route through `camp commit` (campaign root),
`camp p commit` (inside `projects/*`), or `fest commit` (during festivals) so
festival traceability and campaign bookkeeping are preserved.

Because a plugin hook fires in every session, the guard self-scopes. It blocks a
Bash command only when all of the following hold, and otherwise exits without
interfering:

- the command has a raw `git commit` segment, and
- the session is inside a campaign (detected via `camp id`), and
- `camp` and `jq` are both available.

The command is split on `;`, `&&`, `||`, and newlines and each segment is
matched start-anchored, so a raw commit hidden after a wrapper in a compound
command (`fest commit ...; git commit ...`) is still caught, and a `git commit`
appearing only inside a wrapper's quoted message is not a false positive.
Detection is a discipline guard, not a security control: it does not defeat
deliberate obfuscation (`bash -c`, aliases, `eval`).

Outside a campaign, in repos without `camp`, or on machines without `jq`, it
fails open. Set `CAMP_ALLOW_RAW_GIT=1` to override deliberately for one command.
`commit-guard.test.sh` encodes the detection matrix and runs in the plugin gate.

## Local development gate

From the festival repo root:

- `just plugin check` runs `scripts/test_claude_plugin.sh`: JSON parse of both
  manifests, plugin semver and metadata, component frontmatter, in-bundle hook
  references, the CLI sync-check, and the install-hook smoke test.
- `just plugin list` lists the bundled commands, skills, and agents.
- `just plugin bump <version>` rewrites the `version` in `plugin.json` and
  `marketplace.json` together and rejects a non-semver argument.

`just test all` now includes the `plugin` gate, so plugin breakage surfaces on
every local default test run, not only in the release workflow.

## Skill-authoring conventions

- Descriptions are trigger-style. Lead with "Use when ..." and name concrete
  cues (commands, directory names, user intents). Keep them to one or two
  sentences. Do not claim a skill "auto-activates"; the description is the only
  signal Claude uses to load the skill. No emdashes (house style).
- Supporting-file pattern. Keep `SKILL.md` short (when to use, core loop, key
  commands) and move heavy reference into sibling files loaded just in time.
  Split a skill when its `SKILL.md` crosses roughly 100 lines or carries a large
  reference table. The current 8 skills are short and stay single-file.

## Methodology docs

This README covers the plugin bundle only. For the Festival methodology itself:

- `festivals/README.md` in a campaign workspace (the agent entry point)
- Full docs at https://docs.fest.build

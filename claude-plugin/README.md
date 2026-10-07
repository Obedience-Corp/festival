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
  .claude-plugin/plugin.json    plugin manifest (name, version, planningTakeover option, types)
  tsconfig.json                 type-check config for the mod (extends the engine-generated one)
  types/index.d.ts              types for the mod's `$.state` atoms
  skills/                       12 skills, one SKILL.md each
  commands/                     11 fest-* and camp-* slash commands
  agents/                       fest-executor, fest-planner
  hooks/
    hooks.json                  SessionStart + PreToolUse hook wiring, plus the `modules` entry for the mod
    mod/register.tsx            the live festival view and planning takeover (Claude Code 2.1.290+)
    mod/fest.ts                 pure helpers that shape `fest` JSON into the band and tree rows
    mod/camp.ts                 camp-root lookup for @-mentions
    mod/*.test.ts               tests, run by `claude plugin test`
    scripts/ensure-festival.sh  installs and updates fest and camp
    scripts/ensure-festival.test.sh  unit tests for local-version parsing (run by the gate)
    scripts/commit-guard.sh     blocks raw `git commit` inside a camp
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

A `PreToolUse` (Bash) hook (`hooks/scripts/commit-guard.sh`) enforces camp
commit discipline: commits must route through `camp commit` (camp root),
`camp p commit` (inside `projects/*`), or `fest commit` (during festivals) so
festival traceability and camp bookkeeping are preserved.

Because a plugin hook fires in every session, the guard self-scopes. It blocks a
Bash command only when all of the following hold, and otherwise exits without
interfering:

- the command has a raw `git commit` segment, and
- the session is inside a camp (detected via `camp id`), and
- `camp` and `jq` are both available.

The command is split on `;`, `&&`, `||`, and newlines and each segment is
matched start-anchored, so a raw commit hidden after a wrapper in a compound
command (`fest commit ...; git commit ...`) is still caught, and a `git commit`
appearing only inside a wrapper's quoted message is not a false positive.
Detection is a discipline guard, not a security control: it does not defeat
deliberate obfuscation (`bash -c`, aliases, `eval`).

Outside a camp, in repos without `camp`, or on machines without `jq`, it
fails open. Set `CAMP_ALLOW_RAW_GIT=1` to override deliberately for one command.
`commit-guard.test.sh` encodes the detection matrix and runs in the plugin gate.

## Live festival view (mod)

The plugin ships an in-process hooks module, `hooks/mod/register.tsx`, that
Claude Code loads from the `modules` key in `hooks/hooks.json`. It needs Claude
Code 2.1.290 or newer. Older versions ignore the module and keep everything
else in this plugin working.

What it draws:

- A one-line band above the prompt with the current position, for example
  `festival FA0031 | 003_SIDECAR > 01_release > 01_baseline | 19/103 (18%)`,
  or the current step of a standalone workflow. It refreshes at session start,
  after each turn, and after any Bash call that runs `fest` or `camp`.
- A pane that shows the festival tree with finished branches collapsed and the
  current branch expanded, headed by the task count and percentage. It
  refreshes every five seconds while open.

When the session has no interactive surface the module does no band or pane
work. When `fest` is missing, exits non-zero, or prints something it cannot
read, the module draws nothing and leaves the normal screen alone.

Commands the module registers (the markdown commands `fest-next` and
`fest-status` are separate and unchanged):

- `/fest-watch` opens or closes the pane.
- `/fest-task` prints the text of `fest next`.
- `/fest-progress` prints the text of `fest progress`.

Camp-root mentions: inside a camp, an `@path` mention that does not exist
relative to the current directory is retried against the camp root. This lets
you mention `@docs/guide.md` from inside a project directory. These mentions
have no autocomplete; you type the whole path.

Planning takeover is an option, `planningTakeover`, set when you enable the
plugin. It is off by default. When on, and only when the session directory is
inside a camp (a `.campaign` directory in it or an ancestor), the module hides
the `Plan` agent, denies `EnterPlanMode`, denies `TodoWrite` and `TaskCreate`,
and drops todo reminders, so planning and task tracking go through Festival.
Outside a camp the option does nothing.

What the module reads and runs, and nothing else: `fest next --json`,
`fest show --json`, `fest progress`, and file existence checks for @-mentions.
It makes no network calls and never asks you a question. Every process it
starts has a timeout (5 seconds for JSON, 10 seconds for text). Every hook that
can refuse something has a `.catch` that lets the original action through, so a
fault in the module cannot block a tool call or a mention.

`claude plugin validate claude-plugin` lists the module's hooks and the `$`
calls it makes, so you can audit it without reading the source.

## Local development gate

From the festival repo root:

- `just plugin check` runs `scripts/test_claude_plugin.sh`: JSON parse of both
  manifests, plugin semver and metadata, component frontmatter, in-bundle hook
  references, the CLI sync-check, the install-hook smoke test, and the mod
  check: `claude plugin validate`, `claude plugin test`, and a `tsc` type-check
  against the typings the engine writes to `.claude-plugin/types/` (git-ignored;
  the gate produces them with one `claude -p` load when absent).
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
  reference table. The current 12 skills are short and stay single-file.

## Privacy and network access

The plugin does not collect conversation content, chat history, memory, or
uploaded files. Nothing in the bundle sends user data to Obedience Corp.

The only network use is the `SessionStart` hook, which talks to GitHub for
the `Obedience-Corp/festival` repository: `releases/latest`, the release
checksum file, and the platform archive. Downloads are checksum-verified
before install. Update checks are rate-limited to once per day. When `fest`
and `camp` are already on PATH and current, the hook does not download
anything.

The mod described above makes no network calls either.

The `PreToolUse` commit guard does not make network calls. It only inspects
the Bash command line, and only when the session is inside a camp and
`camp` and `jq` are available.

## Methodology docs

This README covers the plugin bundle only. For the Festival methodology itself:

- `festivals/README.md` in a camp (the agent entry point)
- Full docs at https://docs.fest.build

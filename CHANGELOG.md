# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Claude Code plugin marketplace manifest (`.claude-plugin/marketplace.json` at the repo root, `source: "./claude-plugin"`) so the plugin is installable through the Claude Code marketplace flow, plus a version-consistency check and a `just plugin bump <version>` recipe that keeps `plugin.json` and `marketplace.json` aligned.
- `claude-plugin/README.md` documenting the bundle layout, install paths, the local dev gate, and the skill-authoring conventions.
- Component frontmatter validation and in-bundle hook-reference resolution in `scripts/test_claude_plugin.sh` (every skill, command, and agent must have well-formed frontmatter; every `${CLAUDE_PLUGIN_ROOT}` reference in `hooks/hooks.json` must resolve).
- `festival-intake` skill, the plugin's front door. Every other skill description gates on festival vocabulary a new user does not have, so a prompt like "help me rebuild the auth system" matched nothing. This one triggers on outcome language and carries the routing contract: size the work out loud, show the plan shape before scaffolding, plan through the `fest next` loop, plan full scope, write tutorial-grade tasks.
- `/festival:plan` command, the explicit entry point for the same path.
- `workflows/audit-tasks.js`, the first bundled dynamic workflow. Enumerates every task document via `fest deps --all --json`, fans out one agent per task to judge whether it is tutorial-grade, and has independent agents refute each finding before it is reported. Covers what `fest validate` cannot: validate scores structure, not substance, so a festival of one-line tasks scores 100.
- `camp-workitems` and `cross-campaign` skills, which shipped in camp's scaffold bundle but were missing here, so plugin users had a smaller surface than `camp init` users.
- `camp project rename` in the `camp-projects` skill and the campaigns methodology page. New in camp v0.4.0; it migrates a project's campaign references in one transaction and takes `--remote-url` when origin should move with it.
- A lifecycle hooks section in `fest-execution`. fest v0.6.0 added the `task_start` verb and its `start:` binding stage, and made `task_complete` bindings run on every completion surface, so an agent can no longer assume a status change is inert. Points at `fest hooks list` for the resolved set.
- The deferred commit queue in `campaign-commit`: `camp jobs`, the `stalled` state, and `camp jobs drop --running`, which is the only way to end a wait on a commit message writer that stopped answering (camp v0.4.0).
- `fest commit`'s linked-project behavior in `campaign-commit` and the `/festival:fest-commit` command. From fest v0.6.0 one `fest commit` inside a festival also commits the linked project, so agents should no longer pair it with `camp p commit`.
- `fest create festival --dry-run` in the `/festival:fest-create` command, a no-write preview of the file tree as of fest v0.6.0.
- POSIX sh shell integration in the README, the installation page, the shell setup page, and the installer's own setup hint. `camp shell-init sh` and `fest shell-init sh` are new in camp v0.4.0 and fest v0.6.0; there is no packaged `festival.sh` helper file, so those users take the dynamic fallback, and no tab completion is installed because POSIX sh has no mechanism to install into.

### Changed

- `just test all` now includes the `plugin` gate, so plugin bundle breakage surfaces on every local default test run, not only in the release workflow.
- Audited all 8 plugin skill descriptions for trigger accuracy and removed the `fest-methodology` "auto-activates" claim.
- Updated bundled CLI release pins to `camp` v0.2.10 and `fest` v0.4.4.
- Bumped the plugin manifests to 1.1.0.
- Fixed `campaign-commit`, which told agents to run `git commit` for campaign root files. That is wrong (`camp commit` is correct) and it is the exact action the bundle's own `commit-guard.sh` hook blocks.
- Taught `sync-check.sh` about `camp workitem`, `camp list`, `camp switch` and `camp transfer`, all of which exist but had no validator entries.
- Bumped the plugin manifests to 1.2.0 for the components added above. v0.2.14 shipped a new skill, command, and workflow while the manifests still read 1.1.0.
- Updated bundled CLI release pins to `camp` v0.4.0 and `fest` v0.6.0.
- Fixed `campaign-workflows`, which taught `camp flow status`, `camp flow move` and `camp flow sync`. There is no `camp flow` command in camp; the real surface is `camp workflow`, whose subcommands are `create`, `doctor`, `list`, `shortcut`, `show` and `sync`. All four generated plugin targets shipped those three dead commands.
- Fixed `sync-check.sh`, whose CLI existence check could never fail. It ran `<cli> help <subcmd>`, and both CLIs answer an unknown help topic with the parent's help and exit 0, so every command passed and the dead `camp flow` entry above sat in the validator's own allowlist undetected. The check now looks each command up in the table its parent prints, validates multi-word paths such as `camp project rename` and `camp jobs drop`, and resolves cobra aliases (`camp p`, `camp intent`, `camp wi`) at the top level. Reading the table into a variable first also removes a `grep -q` and `pipefail` race that failed lookups for commands that do exist.
- Taught `sync-check.sh` about `camp jobs`, `camp workflow` and `fest hooks`, and dropped its `camp flow` entry.
- Fixed the `/festival:fest-commit` command, which still told agents to fall back to raw `git commit` for campaign root changes. `camp commit` is correct, and raw `git commit` is what the bundle's own `commit-guard.sh` hook blocks. The same wording was fixed in the `campaign-commit` skill earlier but missed here.
- Bumped the plugin manifests to 1.3.0 for the capabilities added above.

## [0.1.0] - 2026-03-04

### Added

- **fest CLI** — Festival planning and execution engine: create festivals, phases, sequences, and tasks; drive agent workflows with `fest next`; track progress with `fest status`
- **camp CLI** — Campaign workspace management: initialize workspaces, manage project submodules, navigate with `cgo`/`csw` shell shortcuts, commit with auto-sync
- Hugo documentation site with custom `festival` theme — methodology guides, CLI reference, tutorials, and quick start
- Multi-platform binary releases via GoReleaser (macOS, Linux, Windows) with `.tar.gz`, `.deb`, `.rpm`, `.apk`, and `.zip` packages
- Homebrew tap (`Obedience-Corp/tap/festival`), Scoop bucket, and AUR package (`festival-bin`)
- Shell completion scripts for bash, zsh, fish, and PowerShell (both CLIs)
- Install script (`install.sh`) for quick binary setup on macOS and Linux
- GitHub Actions release workflow for tag-triggered builds and publishing
- Modular justfile build system for development, testing, docs, and release workflows

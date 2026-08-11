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

### Changed

- `just test all` now includes the `plugin` gate, so plugin bundle breakage surfaces on every local default test run, not only in the release workflow.
- Audited all 8 plugin skill descriptions for trigger accuracy and removed the `fest-methodology` "auto-activates" claim.
- Updated bundled CLI release pins to `camp` v0.2.10 and `fest` v0.4.4.
- Bumped the plugin manifests to 1.1.0.
- Fixed `campaign-commit`, which told agents to run `git commit` for campaign root files. That is wrong (`camp commit` is correct) and it is the exact action the bundle's own `commit-guard.sh` hook blocks.
- Taught `sync-check.sh` about `camp workitem`, `camp list`, `camp switch` and `camp transfer`, all of which exist but had no validator entries.
- Bumped the plugin manifests to 1.2.0 for the components added above. v0.2.14 shipped a new skill, command, and workflow while the manifests still read 1.1.0.

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

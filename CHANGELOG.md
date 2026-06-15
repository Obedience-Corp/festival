# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Claude Code plugin marketplace manifest (`.claude-plugin/marketplace.json` at the repo root, `source: "./claude-plugin"`) so the plugin is installable through the Claude Code marketplace flow, plus a version-consistency check and a `just plugin bump <version>` recipe that keeps `plugin.json` and `marketplace.json` aligned.
- `claude-plugin/README.md` documenting the bundle layout, install paths, the local dev gate, and the skill-authoring conventions.
- Component frontmatter validation and in-bundle hook-reference resolution in `scripts/test_claude_plugin.sh` (every skill, command, and agent must have well-formed frontmatter; every `${CLAUDE_PLUGIN_ROOT}` reference in `hooks/hooks.json` must resolve).

### Changed

- `just test all` now includes the `plugin` gate, so plugin bundle breakage surfaces on every local default test run, not only in the release workflow.
- Audited all 8 plugin skill descriptions for trigger accuracy and removed the `fest-methodology` "auto-activates" claim.
- Bumped the plugin manifests to 1.1.0.

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

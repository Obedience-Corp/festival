# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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

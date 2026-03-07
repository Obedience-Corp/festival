# CLAUDE.md — Festival Repository

## Purpose

This is the public distribution repository for the Festival Methodology CLI tools. It bundles `fest` and `camp` as git submodules and hosts release artifacts, documentation, and methodology guides.

## Repository Structure

- `fest/` — Git submodule for the fest CLI (festival planning and execution)
- `camp/` — Git submodule for the camp CLI (campaign workspace management)
- `content/` — Hugo documentation content (markdown)
- `themes/festival/` — Custom Hugo theme matching festui design system
- `.justfiles/` — Modular justfile system
- `.github/workflows/` — CI/CD release pipeline

## Build System

Use `just` for all operations:

```bash
just              # Show available commands
just build all    # Build both CLIs
just test all     # Run all tests
just docs serve   # Serve documentation locally
just release dry-run  # Test GoReleaser config
just sub status   # Check submodule status
```

## Submodules

Both `fest` and `camp` are git submodules. After cloning:

```bash
just sub init     # Initialize submodules
```

## Documentation

The site uses Hugo with a custom `festival` theme. Content lives in `content/docs/`. CLI reference docs are auto-generated:

```bash
just docs all     # Generate CLI reference docs
just docs serve   # Serve at localhost:1313
just docs build   # Build for production
```

## Releases

Releases are tag-triggered via GitHub Actions:

1. Pin submodules to release commits
2. `just release tag <version>`
3. `git push origin v<version>`
4. CI builds and publishes via GoReleaser

## License

FSL-1.1-ALv2 (Functional Source License)

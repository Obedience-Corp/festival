# Installation

<!-- TODO: Expand with platform-specific instructions, troubleshooting, and verification steps -->

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

## Homebrew

```bash
brew install lancekrogers/tap/festival
```

This installs both `fest` and `camp`.

## From Source

Requires Go 1.25+:

```bash
go install github.com/Obedience-Corp/fest/cmd/fest@latest
go install github.com/obediencecorp/camp/cmd/camp@latest
```

## Verify Installation

```bash
fest --version
camp --version
```

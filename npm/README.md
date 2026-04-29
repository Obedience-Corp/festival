# @obedience-corp/festival

NPM installer for the Festival CLI suite.

Festival includes two commands:

- `fest` - Festival planning and execution workflow CLI
- `camp` - Campaign workspace management CLI

## Install

```bash
npm install -g @obedience-corp/festival
```

You can also use another npm-compatible package manager:

```bash
pnpm add -g @obedience-corp/festival
bun add -g @obedience-corp/festival
```

## Verify

```bash
fest version
camp version
```

## Supported Platforms

- macOS: Intel and Apple Silicon, distributed as a universal archive
- Linux: x64 and arm64

Windows npm installation is paused until the Festival Windows release artifacts
are re-enabled.

## How It Works

This package downloads the matching Festival GitHub release archive for your
platform, verifies it against the release `checksums.txt`, and exposes `fest`
and `camp` on your PATH.

## Maintainer Notes

The npm package intentionally exposes the same binary set as the Festival release
archive. If a future release adds or removes CLI binaries, update `BINARIES` in
`install.js`, the `bin` map in `package.json`, the wrapper files in `bin/`, and
the GoReleaser archive `ids:` in `../.goreleaser.yaml` together.

See <https://fest.build> for docs and the full installation guide.

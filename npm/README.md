# @obedience-corp/festival

NPM installer for the Festival CLI suite.

Festival includes three commands:

- `fest` - Festival planning and execution workflow CLI
- `camp` - Campaign workspace management CLI
- `festival` - installer and launcher for the suite

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
festival version
```

## Supported Platforms

- macOS: Intel and Apple Silicon, distributed as a universal archive
- Linux: x64 and arm64

Windows npm installation is paused until the Festival Windows release artifacts
are re-enabled.

## How It Works

This package downloads the matching Festival GitHub release archive for your
platform, verifies it against the release `checksums.txt`, exposes `fest`,
`camp`, and `festival` on your PATH, and keeps the release completion and
shell-helper assets under `share/festival/` inside the installed npm
package.

The npm installer does not edit shell startup files. Source the packaged helper
(not `camp shell-init` / `fest shell-init`):

```bash
source "$(npm root -g)/@obedience-corp/festival/share/festival/shell/festival.zsh"
```

Do not run `festival install` (that plants a second copy under `~/.obey/installer`).
Upgrade with: `npm install -g @obedience-corp/festival@latest`

## Maintainer Notes

The npm package intentionally exposes the same binary set as the Festival release
archive. If a future release adds or removes CLI binaries, update `BINARIES` in
`install.js`, the `bin` map in `package.json`, the wrapper files in `bin/`, and
the GoReleaser archive `ids:` in `../.goreleaser.yaml` together.

See <https://fest.build> for docs and the full installation guide.

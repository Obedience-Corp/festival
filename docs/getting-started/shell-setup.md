---
title: "Shell Setup"
weight: 13
---

# Shell Setup

Enable shell integration for directory navigation and tab completion.

## Setup

If your installer created Festival helper files, source the helper for your
shell from your shell config.

```bash
# install.sh default location
source ~/.local/share/festival/shell/festival.zsh

# Homebrew
source "$(brew --prefix)/share/festival/shell/festival.zsh"

# Linux packages
source /usr/share/festival/shell/festival.zsh
```

For bash, use `festival.bash`. For fish, use `festival.fish`.

If you do not have an installed helper file, use the dynamic fallback:

```bash
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"
```

For bash, replace `zsh` with `bash`. For fish, use:

```fish
camp shell-init fish | source
fest shell-init fish | source
```

## Shell Functions

### fest shell functions

- `fgo` - Navigate to festival directories
- `fls` - List festivals

### camp shell functions

- `cgo` - Navigate between campaign projects with fuzzy finding

## Finding the installed binaries

Shell integration defines `camp` and `fest` as **shell functions** so
navigation commands can `cd` in your current shell. Because of that, plain
`which camp` / `which fest` usually prints the function body, not a filesystem
path.

```bash
# zsh — path of the external binary (skips shell functions)
whence -p camp
whence -p fest
# or: which -p camp / which -p fest

# bash
type -P camp
type -P fest

# show the function plus every binary on PATH
type -a camp
type -a fest

# resolve symlinks to the real install
realpath "$(whence -p camp)"   # zsh
realpath "$(type -P camp)"     # bash
```

To run a binary without the wrapper (scripts, debugging): `command camp version`
or `command fest version`.

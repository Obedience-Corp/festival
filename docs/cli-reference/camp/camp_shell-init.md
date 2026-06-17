---
title: "camp shell-init"
linkTitle: "camp shell-init"
description: "Output shell initialization code"
---

## camp shell-init

Output shell initialization code

### Synopsis

Output shell initialization code for your shell config.

Add to your shell config:
  zsh:  eval "$(camp shell-init zsh)"
  bash: eval "$(camp shell-init bash)"
  fish: camp shell-init fish | source

This provides:
  - A camp shell function that wraps the camp binary
  - cgo function for navigation
  - Tab completion for camp commands
  - Category shortcuts (p, c, f, etc.)

IMPORTANT: this defines a shell function named 'camp' that wraps the camp
binary. The function intercepts 'camp switch' and 'camp go' to perform
directory changes in the current shell session.

The following shell aliases and functions are also installed:
  cr     camp run (run a just recipe in a project)
  csw    camp switch (shorthand)
  cint   camp intent add (quick idea capture)
  cnote  camp intent note (add a note to an existing intent)
  cie    camp intent explore (interactive intent browser)

The cgo function enables quick navigation:
  cgo                 Interactive picker or jump to campaign root
  cgo p               Jump to projects/
  cgo p api           Fuzzy find "api" in projects/
  cgo -c p ls         Run "ls" in projects/ directory

```
camp shell-init <shell> [flags]
```

### Examples

```
  # Add to ~/.zshrc
  eval "$(camp shell-init zsh)"

  # Add to ~/.bashrc
  eval "$(camp shell-init bash)"

  # Add to ~/.config/fish/config.fish
  camp shell-init fish | source
```

### Options

```
  -h, --help   help for shell-init
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces

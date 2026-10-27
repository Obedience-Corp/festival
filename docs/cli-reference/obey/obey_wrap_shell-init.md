---
title: "obey wrap shell-init"
linkTitle: "obey wrap shell-init"
description: "Print optional shell functions for grok, claude, and codex"
---

## obey wrap shell-init

Print optional shell functions for grok, claude, and codex

### Synopsis

Print shell functions that wrap interactive provider launches. Add eval "$(obey wrap shell-init zsh)" to ~/.zshrc (bash: ~/.bashrc); for fish use 'obey wrap shell-init fish | source'. Noninteractive and already-wrapped invocations bypass the wrapper.

```
obey wrap shell-init <bash|zsh|fish> [flags]
```

### Options

```
  -h, --help   help for shell-init
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey wrap](../obey_wrap/)	 - Run an interactive command with an Obey-owned PTY

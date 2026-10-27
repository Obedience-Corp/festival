---
title: "obey wrap"
linkTitle: "obey wrap"
description: "Run an interactive command with an Obey-owned PTY"
---

## obey wrap

Run an interactive command with an Obey-owned PTY

### Synopsis

Run a command in a PTY so installed provider bridge hooks can enable session send and interrupt in any terminal on Linux or macOS.

Arguments after the command are passed through unchanged. Install bridge hooks with 'obey bridge install all --scope user'.

```
obey wrap <command> [args...] [flags]
```

### Options

```
  -h, --help   help for wrap
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey wrap shell-init](../obey_wrap_shell-init/)	 - Print optional shell functions for grok, claude, and codex

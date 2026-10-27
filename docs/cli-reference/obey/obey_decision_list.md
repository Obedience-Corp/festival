---
title: "obey decision list"
linkTitle: "obey decision list"
description: "List named decisions and the file each was loaded from"
---

## obey decision list

List named decisions and the file each was loaded from

### Synopsis

List the decisions defined in decisions.yaml next to daemon.yaml and in
<campaign>/.obey/decisions.yaml. A campaign definition replaces a user
definition with the same name; the SOURCE column shows which file won, with
the home directory shortened to ~ in messages and tables (--json keeps absolute paths). A PROVIDER of
(default) means the call picks one: decisions.default_provider, or the single
enabled decision provider.

```
obey decision list [flags]
```

### Options

```
      --campaign string   campaign root for .obey/decisions.yaml (default: detected from the working directory)
  -h, --help              help for list
      --json              emit the list as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey decision](../obey_decision/)	 - Ask a decision provider typed questions about some state

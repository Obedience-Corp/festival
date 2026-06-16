---
title: "camp intent rename"
linkTitle: "camp intent rename"
description: "Rename an intent"
---

## camp intent rename

Rename an intent

### Synopsis

Rename an intent: update its title and regenerate its human-readable
filename. The intent's stable id is preserved, so references and lookups survive
the rename.

Resolution is by exact id (run 'camp intent list' to copy one).

Examples:
  camp intent rename add-dark-mode-20260119-153412 "Add a dark mode toggle"

```
camp intent rename <id> <new title> [flags]
```

### Options

```
  -h, --help        help for rename
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](../camp_intent/)	 - Manage campaign intents

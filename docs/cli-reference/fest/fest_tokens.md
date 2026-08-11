---
title: "fest tokens"
linkTitle: "fest tokens"
description: "Count planning-corpus tokens for a festival or the whole workspace"
---

## fest tokens

Count planning-corpus tokens for a festival or the whole workspace

### Synopsis

Count tokens in festival planning documents using tcount.

With no arguments, counts the festival containing the current directory.
With --all, counts the entire festivals workspace (every status).
With a path, counts that file or directory directly.

Counting matches the tcount CLI: recursive, .gitignore-aware, and the
reported number is tcount's primary method for the selected model.

```
fest tokens [path] [flags]
```

### Examples

```
  fest tokens                    # Current festival's planning corpus
  fest tokens --all              # Entire festivals workspace
  fest tokens 001_PLAN           # One phase directory
  fest tokens --all --json       # Machine-readable totals
```

### Options

```
      --all            count the entire festivals workspace
  -h, --help           help for tokens
      --json           output in JSON format
      --model string   model whose tokenizer to use (tcount default when empty)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents

---
title: "obey count-tokens"
linkTitle: "obey count-tokens"
description: "Estimate token counts for a file or directory"
---

## obey count-tokens

Estimate token counts for a file or directory

### Synopsis

Estimate token counts for a campaign-scoped file or directory using tcount.

The daemon resolves the path against the registered campaign root. Results
are cached under .campaign/cache/tcount/ so unchanged files are not recounted.

Without a path, counts the campaign root. For directories, --recursive walks
the full tree; without it, only immediate child files are counted.

```
obey count-tokens [path] [flags]
```

### Examples

```
  obey count-tokens README.md
  obey count-tokens --recursive ./src
  obey count-tokens --model gpt-4o doc.md
  obey count-tokens --json ./project
```

### Options

```
      --all            alias for --recursive
  -h, --help           help for count-tokens
      --json           output in JSON format
      --model string   model whose tokenizer to use (tcount default when empty)
  -r, --recursive      count nested files under a directory (immediate children only without this flag)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization

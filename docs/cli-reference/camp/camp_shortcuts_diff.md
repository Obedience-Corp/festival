---
title: "camp shortcuts diff"
linkTitle: "camp shortcuts diff"
description: "Show differences between current and default shortcuts"
---

## camp shortcuts diff

Show differences between current and default shortcuts

### Synopsis

Compare your campaign's shortcuts against the current defaults.

Shows:
  + Missing    defaults not in your config (available to add)
  - Stale      auto-generated shortcuts no longer in defaults
  ~ Modified   shortcuts where path or concept differs from default
  = Up to date shortcuts matching defaults (count only)
  * Custom     user-defined shortcuts (always preserved)

Run 'camp shortcuts reset' to apply missing defaults and remove stale entries.

```
camp shortcuts diff [flags]
```

### Examples

```
  camp shortcuts diff
```

### Options

```
  -h, --help   help for diff
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp shortcuts](../camp_shortcuts/)	 - List all available shortcuts

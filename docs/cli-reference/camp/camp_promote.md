---
title: "camp promote"
linkTitle: "camp promote"
description: "Promote any intent, workitem, or festival (universal front door)"
---

## camp promote

Promote any intent, workitem, or festival (universal front door)

```
camp promote [id] [flags]
```

### Options

```
      --dest string     Destination override (doc/festival targets)
      --dry-run         Preview without making changes
      --force           Skip readiness checks
      --goal string     Festival goal override
  -h, --help            help for promote
      --json            Machine-readable output; implies non-interactive
      --keep            Keep the source (festival/doc targets)
      --no-commit       Skip auto-commit
      --target string   Promote target (kind-specific); required in non-interactive mode
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces

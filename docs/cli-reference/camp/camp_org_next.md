---
title: "camp org next"
linkTitle: "camp org next"
description: "Switch to the next camp in the current camp's org"
---

## camp org next

Switch to the next camp in the current camp's org

### Synopsis

Switch to the next camp in the current camp's org.

Members are ordered by name, so the cycle is stable and predictable
(a -> b -> c -> a). By default only active camps are cycled; use --all to
include inactive and reference camps.

Use with the corg shell function for instant navigation:
  corg        # cd to the next camp in this org

The --print flag outputs just the target path for shell integration, and --json
emits the resolved source and target camps.

```
camp org next [flags]
```

### Examples

```
  camp org next            # Print cd to the next org camp
  camp org next --print    # Print the target path only
  camp org next --all      # Include inactive/reference camps
  camp org next --json
```

### Options

```
      --all     Include inactive and reference camps in the cycle
  -h, --help    help for next
      --json    Output the resolved source and target camps as JSON
      --print   Print the target path only (for shell integration)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group camps into orgs

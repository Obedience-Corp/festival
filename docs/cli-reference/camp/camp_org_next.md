---
title: "camp org next"
linkTitle: "camp org next"
description: "Switch to the next campaign in the current campaign's org"
---

## camp org next

Switch to the next campaign in the current campaign's org

### Synopsis

Switch to the next campaign in the current campaign's org.

Members are ordered by name, so the cycle is stable and predictable
(a -> b -> c -> a). By default only active campaigns are cycled; use --all to
include inactive and reference campaigns.

Use with the corg shell function for instant navigation:
  corg        # cd to the next campaign in this org

The --print flag outputs just the target path for shell integration, and --json
emits the resolved source and target campaigns.

```
camp org next [flags]
```

### Examples

```
  camp org next            # Print cd to the next org campaign
  camp org next --print    # Print the target path only
  camp org next --all      # Include inactive/reference campaigns
  camp org next --json
```

### Options

```
      --all     Include inactive and reference campaigns in the cycle
  -h, --help    help for next
      --json    Output the resolved source and target campaigns as JSON
      --print   Print the target path only (for shell integration)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group campaigns into orgs

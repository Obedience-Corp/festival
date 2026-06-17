---
title: "camp switch"
linkTitle: "camp switch"
description: "Switch to a different campaign"
---

## camp switch

Switch to a different campaign

### Synopsis

Switch to a registered campaign by name or ID.

Without arguments, opens an interactive picker to select a campaign.
With an argument, looks up the campaign by name or ID prefix.

Use with the cgo shell function for instant navigation:
  cgo switch                 # Interactive campaign picker
  cgo switch my-campaign     # Switch by name
  cgo switch a1b2             # Switch by ID prefix

The --print flag outputs just the path for shell integration:
  cd "$(camp switch --print)"

Use campaign@tab to navigate to a specific location in the target campaign:
  camp switch obey-campaign@p    # Switch and navigate to projects/
  camp switch obey-campaign@f    # Switch and navigate to festivals/

```
camp switch [campaign] [flags]
```

### Examples

```
  camp switch                        # Interactive picker
  camp switch obey-campaign          # Switch by name
  camp switch a1b2                   # Switch by ID prefix
  camp switch --print                # Picker, output path only
  camp switch obey-campaign@p        # Switch and navigate to projects/
```

### Options

```
  -h, --help    help for switch
      --print   Print path only (for shell integration)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces

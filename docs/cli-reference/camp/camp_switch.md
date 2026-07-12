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
Use --org or org/campaign to resolve inside one organization.

Use with the cgo shell function for instant navigation:
  cgo switch                 # Interactive campaign picker
  cgo switch my-campaign     # Switch by name
  cgo switch a1b2             # Switch by ID prefix
  cgo switch obey/platform    # Switch by org-scoped selector

The --print flag outputs just the path for shell integration:
  cd "$(camp switch --print)"

Use campaign@tab to navigate to a specific location in the target campaign:
  camp switch obey-campaign@p    # Switch and navigate to projects/
  camp switch obey/platform@f    # Switch inside org and navigate to festivals/

Use machine:campaign to resolve a campaign on a machine registered in
~/.obey/machines.yaml (via the csw shell wrapper, which hops there over ssh):
  csw devbox:obey-campaign       # Resolve and hop to obey-campaign on devbox

Remote resolution runs the far machine's own 'camp switch' through a login
shell (sh -lc) so PATH entries a login profile exports (~/.profile, etc.) are
picked up. If camp still can't be found there, set CAMP_REMOTE_CAMP_PATH to
its exact path on that machine.

```
camp switch [campaign] [flags]
```

### Examples

```
  camp switch                        # Interactive picker
  camp switch obey-campaign          # Switch by name
  camp switch --org obey platform    # Switch by name within an org
  camp switch obey/platform          # Switch by scoped selector
  camp switch a1b2                   # Switch by ID prefix
  camp switch --print                # Picker, output path only
  camp switch obey-campaign@p        # Switch and navigate to projects/
  camp switch --all old-reference    # Include inactive/reference campaigns
  camp switch --org obey platform --json
```

### Options

```
      --all             Include inactive and reference campaigns
  -h, --help            help for switch
      --json            Output selected campaign and target path as JSON
      --org string      Only switch among campaigns in this org
      --print           Print path only (for shell integration)
      --status string   Only switch among campaigns with this lifecycle status
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces

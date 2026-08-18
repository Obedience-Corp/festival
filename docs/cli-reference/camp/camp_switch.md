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

Use with the shell-init wrappers for instant navigation (recommended):
  eval "$(camp shell-init zsh)"   # or bash / sh, once per shell
  camp shell-init fish | source   # fish
  csw                            # Interactive picker (local + remote machines)
  csw my-campaign                # Switch by name
  csw a1b2                       # Switch by ID prefix
  csw obey/platform              # Switch by org-scoped selector
  csw archdtop:lance-arch        # Hop to a remote campaign over ssh
  csw -                          # Hop back to the machine/campaign this session came from

'camp switch -' (csw -) is the hop-back gesture: it returns to the origin
encoded in CAMP_HOP_ORIGIN by the outbound hop. It is registration-independent
— the origin need not be in this machine's machines.yaml. Like other remote
targets it refuses --print/--json. '-' is reserved and is no longer a fuzzy
campaign query.

The --print flag outputs just the path for shell integration (local only):
  cd "$(camp switch --print)"

Use campaign@tab to navigate to a specific location in the target campaign:
  camp switch obey-campaign@p    # Switch and navigate to projects/
  camp switch obey/platform@f    # Switch inside org and navigate to festivals/

Use machine:campaign to resolve a campaign on a machine registered in
~/.obey/machines.yaml. The interactive picker also lists remote campaigns when
machines are configured (locals open instantly; remotes append as they load).
Bare 'command camp switch machine:…' resolves without hopping — use the csw
shell wrapper (or --shell-connect under shell-init) to hop.

Remote resolution runs the far machine's own 'camp switch' through that
account's configured login shell ($SHELL -lc) so its login-profile PATH is
picked up; when that PATH has no camp, the far side falls back to camp's usual
install locations (~/.local/bin, $GOBIN, $GOPATH/bin, ~/go/bin, Homebrew) before
giving up. If camp lives somewhere else, set CAMP_REMOTE_CAMP_PATH to its exact
path on that machine. 'camp machine diagnose' shows which binary a hop would run.

```
camp switch [campaign] [flags]
```

### Examples

```
  eval "$(camp shell-init zsh)"
  csw                                # Interactive picker (local + remotes)
  csw obey-campaign                  # Switch by name
  csw archdtop:lance-arch            # Hop to remote campaign
  csw -                              # Hop back via CAMP_HOP_ORIGIN
  camp switch --org obey platform    # Switch by name within an org
  camp switch obey/platform          # Switch by scoped selector
  camp switch a1b2                   # Switch by ID prefix
  camp switch --print                # Picker, output path only (local)
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

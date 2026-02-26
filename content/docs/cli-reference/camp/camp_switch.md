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

```
camp switch [campaign] [flags]
```

### Examples

```
  camp switch                    # Interactive picker
  camp switch obey-campaign      # Switch by name
  camp switch a1b2               # Switch by ID prefix
  camp switch --print            # Picker, output path only
```

### Options

```
  -h, --help    help for switch
      --print   Print path only (for shell integration)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces


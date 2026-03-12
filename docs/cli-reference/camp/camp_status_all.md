## camp status all

Show git status of all submodules

### Synopsis

Show a visual overview of git status for all submodules in the campaign.

Displays a table with each submodule's name, branch, clean/dirty state,
and push status. Results are cached for quick subsequent lookups.

Examples:
  camp status all               # Show all submodule statuses
  camp status all --remote-url  # Show remote URLs instead of names
  camp status all --json        # Output as JSON
  camp status all --no-cache    # Skip cache, refresh all

```
camp status all [flags]
```

### Options

```
  -h, --help         help for all
      --json         Output as JSON
      --no-cache     Skip cache and refresh
      --no-recurse   Only list top-level submodules
      --remote-url   Show remote URLs instead of remote names
      --view         Open interactive TUI viewer
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp status](camp_status.md)	 - Show git status of the campaign


## camp skills status

Show the current state of projected skill bundle symlinks

### Synopsis

Show projection status for campaign skill bundles across tool targets.

Reports whether each tool's skills directory has projected entries from
.campaign/skills/, is partially projected, missing, broken, or blocked.

Examples:
  camp skills status          Show projection states in table format
  camp skills status --json   Machine-readable JSON output

```
camp skills status [flags]
```

### Options

```
  -h, --help     help for status
      --json     Output as JSON
      --strict   Return non-zero exit code when links need attention (for CI)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp skills](camp_skills.md)	 - Manage campaign skill directory links


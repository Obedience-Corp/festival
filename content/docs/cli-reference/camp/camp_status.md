## camp status

Show git status of the campaign

### Synopsis

Show git status of the campaign root directory.

Works from anywhere within the campaign - always shows the status
of the campaign root repository.

Use --sub to show status of the submodule detected from your current directory.
Use --project/-p to show status of a specific project.

Examples:
  camp status           # Full status
  camp status -s        # Short format (git flag)
  camp status --short   # Short format (git flag)
  camp status --sub     # Status of current submodule
  camp status -p projects/camp  # Status of camp project

```
camp status [flags]
```

### Options

```
  -h, --help   help for status
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp status all](camp_status_all.md)	 - Show git status of all submodules


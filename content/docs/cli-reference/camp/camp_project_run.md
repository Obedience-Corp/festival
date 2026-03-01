## camp project run

Run a command inside a project directory

### Synopsis

Run any shell command inside a project directory from anywhere in the campaign.

The project is resolved in this order:
  1. --project / -p flag (explicit project name)
  2. Auto-detect from current working directory
  3. Interactive fuzzy picker (if neither above applies)

Use -- to separate camp flags from the command to execute.

Examples:
  # Interactive project picker, then run command
  camp project run -- ls -la

  # Specify project explicitly
  camp project run -p fest -- just build
  camp project run --project camp -- go test ./...

  # Auto-detect from cwd (inside projects/fest/)
  camp project run -- just test all

  # Simple commands (no -- needed when no flags)
  camp project run make build

```
camp project run [--project <name>] [--] <command> [args...] [flags]
```

### Options

```
  -h, --help   help for run
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects


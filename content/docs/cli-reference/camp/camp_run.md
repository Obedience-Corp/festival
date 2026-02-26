## camp run

Execute command from campaign root, or just recipe in a project

### Synopsis

Execute any command from the campaign root directory, or run just recipes
in a project directory.

If the first argument exactly matches a project name (a directory in projects/
with a git repo), camp dispatches to 'just' in that project's directory.
Any remaining arguments are passed as the recipe and arguments to just.

If the first argument does not match a project, it is treated as a shell command
and executed from the campaign root directory.

Use @shortcut prefix to run from a shortcut's directory instead of root.
Only navigation shortcuts (those with paths) can be used.

All arguments after 'run' (or '@shortcut') are passed directly to the shell.

```
camp run [project | @shortcut] [command | recipe] [args...] [flags]
```

### Examples

```
  # Project just dispatch (first arg matches a project name):
  camp run fest              # Show just recipes for fest project
  camp run fest build        # Run 'just build' in projects/fest/
  camp run camp test all     # Run 'just test all' in projects/camp/

  # Raw command from campaign root (first arg is not a project):
  camp run ls -la            # List campaign root contents
  camp run just --list       # Show just recipes from root

  # Shortcut-based execution:
  camp run @p ls             # List projects/ directory
  camp run @f make test      # Run make from festivals/
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

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces


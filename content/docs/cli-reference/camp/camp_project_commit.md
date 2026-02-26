## camp project commit

Commit changes in a project submodule

### Synopsis

Commit changes within a project submodule.

Auto-detects the current project from your working directory,
or use --project to specify a project by name.

Examples:
  # From within a project directory
  cd projects/my-api
  camp project commit -m "Fix bug"

  # Specify project by name
  camp project commit --project my-api -m "Update deps"

```
camp project commit [flags]
```

### Options

```
  -a, --all              Stage all changes (default true)
      --amend            Amend the previous commit
  -h, --help             help for commit
  -m, --message string   Commit message (required)
  -p, --project string   Project name (auto-detected from cwd if not specified)
      --sync             Auto-commit submodule ref in campaign root (default true)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects


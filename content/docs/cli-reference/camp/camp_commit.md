## camp commit

Commit changes in the campaign root

### Synopsis

Commit changes in the campaign root directory.

Automatically stages all changes and creates a commit. Handles
stale lock files from crashed processes.

Use --sub to commit in the submodule detected from your current directory.
Use -p/--project to commit in a specific project (e.g., -p projects/camp).

Examples:
  camp commit -m "Add new feature"
  camp commit --amend -m "Fix typo"
  camp commit -a -m "Stage and commit all"
  camp commit --sub -m "Commit in current submodule"
  camp commit -p projects/camp -m "Commit in camp project"

```
camp commit [flags]
```

### Options

```
  -a, --all              Stage all changes before committing (default true)
      --amend            Amend the previous commit
  -h, --help             help for commit
  -m, --message string   Commit message (required)
  -p, --project string   Operate on a specific project/submodule path
      --sub              Operate on the submodule detected from current directory
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces


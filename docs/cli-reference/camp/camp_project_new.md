## camp project new

Create a new project in campaign

### Synopsis

Create a new local project as a git submodule in the campaign.

The project is initialized as a git repository with an initial commit,
then added as a submodule under projects/. No remote repository is required.

You can add a remote later:
  cd projects/<name>
  git remote add origin git@github.com:org/<name>.git

Examples:
  camp project new my-service             # Create new project
  camp project new my-service --no-commit # Skip auto-commit to campaign

```
camp project new <name> [flags]
```

### Options

```
  -h, --help          help for new
      --no-commit     Skip automatic git commit
  -p, --path string   Override destination path (defaults to projects/<name>)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects


## camp copy

Copy a file or directory within the campaign

### Synopsis

Copy a file or directory within the current campaign.

Paths are resolved relative to the current directory, matching standard
'cp' behavior and tab completion.

Use @ prefix for campaign shortcuts (e.g., @p/fest, @f/active/).
Available shortcuts are defined in campaign config.

If the destination is an existing directory or ends with '/', the source
is placed inside it with the same basename. Directories are copied
recursively.

```
camp copy <src> <dest> [flags]
```

### Examples

```
  camp copy myfile.md ../docs/
  camp cp @f/active/my-fest/OVERVIEW.md @d/
  camp cp @w/design/active/ @w/explore/backup/
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for copy
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces


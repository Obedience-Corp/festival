## camp move

Move a file or directory within the campaign

### Synopsis

Move a file or directory within the current campaign.

Paths are resolved relative to the current directory, matching standard
'mv' behavior and tab completion.

Use @ prefix for campaign shortcuts (e.g., @p/fest, @f/active/).
Available shortcuts are defined in campaign config.

If the destination is an existing directory or ends with '/', the source
is placed inside it with the same basename.

```
camp move <src> <dest> [flags]
```

### Examples

```
  camp move mydir/ ../docs/mydir/
  camp mv @f/active/old-fest @f/completed/
  camp mv draft.md @w/design/
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for move
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces


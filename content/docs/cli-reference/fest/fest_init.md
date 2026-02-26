## fest init

Initialize a new festival directory structure

### Synopsis

Initialize a new festival directory structure in the current or specified directory.

This command copies the festival template structure from your local cache
(populated by 'fest sync') and creates initial checksum tracking.

Workspace Registration:
  Use --register to mark an existing festivals/ directory as your active workspace.
  This enables 'fest go' to navigate directly to it from anywhere in the project.

  Use --unregister to remove the workspace marker, making the festivals/
  directory invisible to 'fest go' (useful for source repositories).

```
fest init [path] [flags]
```

### Examples

```
  fest init                      # Initialize in current directory
  fest init ./my-project         # Initialize in specified directory
  fest init --force              # Overwrite existing festival
  fest init --minimal            # Create minimal structure only
  fest init --register           # Register existing festivals as workspace
  fest init --unregister         # Remove workspace registration
```

### Options

```
      --force          overwrite existing festival directory
      --from string    source directory (default: ~/.obey/fest)
  -h, --help           help for init
      --minimal        create minimal structure only
      --no-checksums   skip checksum generation
      --register       register existing festivals as active workspace
      --unregister     remove workspace registration
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents


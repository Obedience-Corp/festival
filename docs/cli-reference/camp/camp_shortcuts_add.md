## camp shortcuts add

Add a shortcut (campaign-level or project sub-shortcut)

### Synopsis

Add a shortcut for quick navigation.

Campaign-level shortcut (2 args):
  Adds a navigation shortcut to .campaign/settings/jumps.yaml.
  Usage: camp shortcuts add <name> <path>

Project sub-shortcut (3 args):
  Adds a sub-directory shortcut within a project.
  Usage: camp shortcuts add <project> <name> <path>

With no arguments, launches an interactive TUI for entering
shortcut details.

```
camp shortcuts add [name] [path] or [project] [name] [path] [flags]
```

### Examples

```
  camp shortcuts add                                  Interactive TUI mode
  camp shortcuts add api projects/api-service/        Campaign shortcut
  camp shortcuts add api projects/api/ -d "API svc"   With description
  camp shortcuts add cfg "" -c config                 Concept-only shortcut
  camp shortcuts add camp default cmd/camp/            Project sub-shortcut
```

### Options

```
  -c, --concept string       Command group for expansion
  -d, --description string   Help text for the shortcut
  -h, --help                 help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp shortcuts](camp_shortcuts.md)	 - List all available shortcuts


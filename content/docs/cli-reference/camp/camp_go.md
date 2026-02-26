## camp go

Navigate to campaign directories

### Synopsis

Navigate within the campaign using shortcuts.

Usage patterns:
  camp go           Toggle between campaign root and last location
  camp go --root    Jump to campaign root (ignore toggle)
  camp go t         Jump to last visited location (cd - equivalent)
  camp go p         Jump to projects/
  camp go f         Jump to festivals/
  camp go p api     Fuzzy search projects/ for "api"

Toggle behavior (no args):
  - From anywhere: jump to campaign root, save current location
  - From campaign root: jump back to saved location

Toggle keyword (t / toggle):
  - Jump to the last visited location regardless of where you are
  - Repeated calls alternate between two locations (like cd -)

The --print flag outputs just the path for shell integration:
  cd "$(camp go p --print)"

The -c flag runs a command from the directory without changing to it:
  camp go p -c ls           List contents of projects/
  camp go f -c fest status  Run fest status from festivals/

Or use the cgo shell function for instant navigation:
  cgo               Toggle between root and last location
  cgo p             Equivalent to: cd "$(camp go p --print)"
  cgo p -c ls       Run ls in projects/ without changing directory

```
camp go [shortcut] [query...] [flags]
```

### Examples

```
  camp go               # Toggle: root ↔ last location
  camp go --root        # Force jump to campaign root
  camp go t             # Jump to last visited location (cd -)
  camp go p             # Jump to projects/
  camp go p api         # Fuzzy find "api" in projects/
  camp go p --print     # Print path (for shell scripts)
  camp go f -c ls       # List festivals/ without cd
```

### Options

```
  -c, --command stringArray   Run command from directory (can be repeated for args)
  -h, --help                  help for go
  -l, --list                  List available sub-shortcuts for a project
      --print                 Print path only (for shell integration)
      --root                  Jump to campaign root (ignore last location)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces


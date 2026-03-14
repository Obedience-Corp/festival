---
title: "fest create festival"
linkTitle: "fest create festival"
description: "Create a new festival scaffold under festivals/planning"
---

## fest create festival

Create a new festival scaffold under festivals/planning

```
fest create festival [flags]
```

### Options

```
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --dest string           Destination under festivals/: planning or ritual (use 'fest promote' to advance to active) (default "planning")
      --dry-run               Show template markers without creating file
      --goal string           Festival goal
  -h, --help                  help for festival
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name string           Festival name (required)
  -p, --project string        Project directory path (auto-links to festival)
      --skip-markers          Skip REPLACE marker processing
      --tags string           Comma-separated tags
      --type string           Festival type (standard, implementation, research, quick, ritual)
      --vars-file string      JSON file with variables
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest create](../fest_create/)	 - Create festivals, phases, sequences, or tasks (TUI)

---
title: "fest create phase"
linkTitle: "fest create phase"
description: "Insert a new phase and render its goal file"
---

## fest create phase

Insert a new phase and render its goal file

```
fest create phase [flags]
```

### Options

```
      --after int             Insert after this phase number (-1 or omit to append at end) (default -1)
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --description string    Phase objective (auto-fills Primary Goal marker)
      --dry-run               Show template markers without creating file
      --festival string       Path to festival directory (use when not inside a festival)
  -h, --help                  help for phase
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name string           Phase name (required)
      --path string           Path to festival root (directory containing numbered phases) (default ".")
      --skip-markers          Skip REPLACE marker processing
      --type string           Phase type (planning|implementation|research|review|ingest|non_coding_action) (default "planning")
      --vars-file string      JSON vars for rendering
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

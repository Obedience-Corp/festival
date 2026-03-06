## camp intent promote

Promote an intent through the pipeline

### Synopsis

Promote an intent to the next pipeline stage.

TARGETS:
  ready      Move from inbox to ready (reviewed/enriched)
  festival   Move from ready to active + create festival (default)
  design     Move from ready to active + create design doc

The intent moves to active status when promoted to festival or design,
because work is just beginning. Use --force to bypass status checks.

Examples:
  camp intent promote add-dark                       Promote ready → festival
  camp intent promote add-dark --target design       Promote ready → design doc
  camp intent promote add-dark --target ready         Promote inbox → ready
  camp intent promote add-dark --force                Force promote from any status

```
camp intent promote <id> [flags]
```

### Options

```
      --dry-run         Preview promotion without making changes
      --force           Promote even if not in expected status
  -h, --help            help for promote
      --no-commit       Don't create a git commit
      --target string   Promote target: ready, festival, design (default "festival")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents


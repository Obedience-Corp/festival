---
title: "fest ritual convert"
linkTitle: "fest ritual convert"
description: "Convert a festival into a reusable ritual template"
---

## fest ritual convert

Convert a festival into a reusable ritual template

### Synopsis

Copy an existing festival into ritual/ as a repeatable ritual template.

The source festival is preserved by default. The copy is placed in ritual/
with an RI-XX0001 ID suffix, its fest.yaml metadata.festival_type is set to
"ritual", and a ritual_config block with run_count: 0 is added.

Progress artifacts and task completion state are stripped from the copy by
default so fest ritual run starts clean. Pass --reset-progress=false to keep them.

Use --move-source to archive the original after conversion.

```
fest ritual convert <festival-name-or-id> [flags]
```

### Options

```
      --dry-run            Show what would change without writing
      --frequency string   Ritual frequency hint (e.g. weekly, quarterly); stored in ritual_config.schedule
  -h, --help               help for convert
      --json               output as JSON
      --move-source        Move the source festival to dungeon/archived after conversion (default: preserve source)
      --name string        Override the festival name in the new ritual template (defaults to source name)
      --reset-progress     Strip progress artifacts and task completion state from the copy (default true)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest ritual](../fest_ritual/)	 - Manage repeatable ritual festivals

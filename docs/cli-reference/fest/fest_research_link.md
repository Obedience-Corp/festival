---
title: "fest research link"
linkTitle: "fest research link"
description: "Link research findings to implementation phases/tasks"
---

## fest research link

Link research findings to implementation phases/tasks

### Synopsis

Link a research document to phases, sequences, or tasks.

This creates references in the research document's frontmatter that indicate
which implementation work is informed by this research. With --bidirectional,
it also adds a reference in the target documents.

```
fest research link <research-doc> [flags]
```

### Examples

```
  fest research link api-auth.md --phase 002_IMPLEMENT
  fest research link db-choice.md --sequence 002_IMPLEMENT/01_core
  fest research link spec.md --task 002_IMPLEMENT/01_core/03_design.md --bidirectional
```

### Options

```
  -b, --bidirectional      Create bidirectional references
  -h, --help               help for link
      --json               Output in JSON format
      --phase strings      Phase to link (can be repeated)
      --sequence strings   Sequence to link (can be repeated)
      --task strings       Task to link (can be repeated)
  -u, --unlink             Remove the specified links
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest research](../fest_research/)	 - Manage research phase documents

---
title: "fest research summary"
linkTitle: "fest research summary"
description: "Generate summary/index of research documents"
---

## fest research summary

Generate summary/index of research documents

### Synopsis

Generate a summary of all research documents in a research phase or festival.

The summary includes document counts by type and status, and a list of all
research documents with their metadata.

```
fest research summary [flags]
```

### Examples

```
  fest research summary
  fest research summary --phase 001_RESEARCH
  fest research summary --festival
  fest research summary --format json --output research_index.json
```

### Options

```
  -f, --festival        Summarize entire festival
      --format string   Output format (markdown|json) (default "markdown")
  -h, --help            help for summary
      --json            Output in JSON format (shorthand for --format json)
  -o, --output string   Write to file (default: stdout)
  -p, --phase string    Phase to summarize
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

---
title: "camp workflow create"
linkTitle: "camp workflow create"
description: "Create a custom workflow collection"
---

## camp workflow create

Create a custom workflow collection

### Synopsis

Create a custom workflow collection under workflow/<type>/.

The command creates the workflow directory, terminal dungeon directories,
.gitkeep files, and an OBEY.md guide, then registers the collection in
campaign configuration through a concept and navigation shortcut. A shortcut is
required. Use --dry-run to inspect planned writes and --json for
machine-readable planning or apply results.

```
camp workflow create <type> [flags]
```

### Options

```
      --category string   workflow category for filtering (default plan; must exist under workflows.categories in campaign.yaml)
      --dry-run           report planned writes without modifying the filesystem
  -h, --help              help for create
      --json              emit a structured JSON result
      --replace           replace an existing shortcut or concept with the same name
      --shortcut string   navigation shortcut for this workflow
      --title string      human-readable workflow title
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workflow](../camp_workflow/)	 - Manage workflow collections

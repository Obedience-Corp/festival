---
title: "camp workitem create"
linkTitle: "camp workitem create"
description: "Create workitem tracking metadata"
---

## camp workitem create

Create workitem tracking metadata

### Synopsis

Create tracking metadata for a new workitem (directory + .workitem marker).

This command does NOT create the substantive work scaffold (no design docs,
explore notes, or festival structure). It only:

  1. Creates workflow/<type>/<slug>/ (or --dir/<slug>/)
  2. Writes a .workitem marker (id, type, title, ref, optional quest)

Agents and humans must still add real content afterward. For explore/design
types, the recommended structured-workflow scaffold is:

  cd workflow/<type>/<slug> && fest create workflow <slug>

For other types (feature, bug, chore, …), no festival scaffold is implied;
populate campaign-governed content under the new directory as needed.

Use "camp workitem adopt" to attach a marker to an existing directory.
Use --json for machine-readable identity. next.command is set only for
explore/design (recommended scaffold); otherwise it is empty/omitted.

```
camp workitem create <slug> [flags]
```

### Options

```
      --dir string     parent dir override (default: workflow/<type>)
  -h, --help           help for create
      --id string      override the generated id
      --json           emit a structured JSON result
      --quest string   quest ID to associate (requires dev-profile camp; forward-compatible flag)
      --title string   human-readable title
      --type string    workitem type (feature, bug, chore, or custom) (default "feature")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items

---
title: "camp workitem create"
linkTitle: "camp workitem create"
description: "Create workitem tracking metadata"
---

## camp workitem create

Create workitem tracking metadata

### Synopsis

Create tracking metadata for a new workitem (directory + .workitem marker).

Without --type, the type comes from where the workitem is created. Run from
anywhere under workflow/<type>/, including inside another workitem, and the
new item gets that type and is created at workflow/<type>/<slug>/, a sibling
of the items already there. --dir workflow/<type>[/...] and
--file workflow/<type>/<name>.md infer the type the same way. Everywhere else
the type defaults to feature. An explicit --type always wins.

This command does NOT create the substantive work scaffold (no design docs,
explore notes, or festival structure). It only:

  1. Creates workflow/<type>/<slug>/ (or --dir/<slug>/)
  2. Writes a .workitem marker (id, type, title, ref, optional quest, optional
     tags, optional related projects)

Agents and humans must still add real content afterward. For explore/design
types, the recommended structured-workflow scaffold is:

  cd workflow/<type>/<slug> && fest create workflow <slug>

For other types (feature, bug, chore, …), no festival scaffold is implied;
populate camp-governed content under the new directory as needed.

Use "camp workitem adopt" to attach a marker to an existing directory.
Use --json for machine-readable identity. next.command is set only for
explore/design (recommended scaffold); otherwise it is empty/omitted.

```
camp workitem create <slug> [flags]
```

### Options

```
      --dir string            parent dir override (default: workflow/<type>)
      --file string           create a new markdown file with kind: workitem frontmatter instead of a directory workitem (relative paths are from the current directory)
  -h, --help                  help for create
      --id string             override the generated id
      --json                  emit a structured JSON result
      --project stringArray   add a related project path (repeatable, e.g. projects/camp)
      --quest string          capture quest_id from this quest (defaults to CAMP_QUEST env var if set)
      --tag stringArray       add a tag (repeatable, normalized to lowercase kebab-case)
      --title string          human-readable title
      --type string           workitem type (feature, bug, chore, or custom); when omitted, inferred from a workflow/<type>/ cwd, --dir, or --file (default "feature")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active camp work items

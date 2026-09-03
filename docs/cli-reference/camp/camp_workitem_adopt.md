---
title: "camp workitem adopt"
linkTitle: "camp workitem adopt"
description: "Adopt an existing directory or file as a workitem"
---

## camp workitem adopt

Adopt an existing directory or file as a workitem

### Synopsis

Attach workitem metadata to an existing camp directory or markdown file.

With a directory argument, writes a .workitem marker (the directory must exist
and must not already contain a .workitem). With --file <path.md>, stamps a
kind: workitem frontmatter block onto an existing markdown file without ever
rewriting its body: it prepends a block when the file has none, merges camp's
keys into a foreign block (refusing an ambiguous foreign tags: key without
--force), and updates tags/projects when the file is already a workitem. In all
cases it sets the selected type, title, generated or supplied id, optional quest
link, optional tags, and optional related projects.

```
camp workitem adopt [dir] [flags]
```

### Options

```
      --file string           stamp kind: workitem frontmatter onto a markdown file instead of adopting a directory
      --force                 with --file, take ownership of an existing foreign tags: key (union conforming values, drop and report non-conforming ones)
  -h, --help                  help for adopt
      --id string             override the generated id
      --project stringArray   add a related project path (repeatable, e.g. projects/camp)
      --quest string          quest ID to associate (requires dev-profile camp; forward-compatible flag)
      --tag stringArray       add a tag (repeatable, normalized to lowercase kebab-case)
      --title string          human-readable title
      --type string           workitem type (feature, bug, chore, or custom) (default "feature")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active camp work items

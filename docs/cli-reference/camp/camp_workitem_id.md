---
title: "camp workitem id"
linkTitle: "camp workitem id"
description: "Print the identifier of a workitem"
---

## camp workitem id

Print the identifier of a workitem

### Synopsis

Print the durable single-segment identifier of a workitem.

With no argument, the workitem is detected from the current context using the
same tiered resolution as `camp workitem resolve` (explicit selector, cwd
ancestor, linked scope, festival, current-workitem pointer). With an argument,
the workitem is resolved through the shared selector family: workitem ref,
stable id, key, campaign-relative path, directory slug, festival id, or intent
frontmatter id. A filesystem path (absolute or relative to the current directory)
is accepted and translated to the campaign-relative form the selector expects.

Stdout is the bare durable id for shell scripting — stable .workitem id when
present, otherwise a source-declared id (festival fest.yaml id or intent
frontmatter id), otherwise the path-derived key. It is the id sibling of
`camp workitem --print`, which prints a path. Use --key for the
path-derived key instead, or --json for a structured object (id_kind is
stable / festival / intent / key).

Examples:
  camp workitem id                       # id of the workitem for the cwd
  camp workitem id design-x-2026-05-24   # echoes back the stable id
  camp workitem id ./workflow/design/x   # resolves a filesystem path
  camp workitem id --key                 # print the <type>:<path> key form
  camp workitem id --json SC0001         # structured object for a festival

```
camp workitem id [selector-or-path] [flags]
```

### Options

```
  -h, --help   help for id
      --json   emit a structured JSON result
      --key    print the path-derived key instead of the stable id
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items

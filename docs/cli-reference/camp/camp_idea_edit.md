---
title: "camp idea edit"
linkTitle: "camp idea edit"
description: "Edit an existing idea"
---

## camp idea edit

Edit an existing idea

### Synopsis

Edit an idea in your preferred editor or programmatically via flags.

If no programmatic flags are given, opens the idea in $EDITOR.
If any programmatic flag is present, applies the update directly and
emits an audit event; no editor is launched.

PICKER / EDITOR PATH:
  If ID is provided, opens the idea directly (supports partial matching).
  If no ID is provided, shows a fuzzy picker to select an idea.

PROGRAMMATIC FLAGS (skip $EDITOR):
  --title            Set a new title
  --body             Replace the body with a literal string
  --body-file        Replace the body from a file (- for stdin)
  --append-body      Append text to the existing body
  --append-body-file Append text from a file (- for stdin)
  --set-type         Change the idea type
  --set-status       Change the idea status
  --set-concept      Change the concept field
  --priority         Change priority (low, medium, high)
  --horizon          Change horizon (now, next, later, someday)
  --author           Override the author attribution

MUTUAL EXCLUSIVITY:
  --body vs --body-file
  --append-body vs --append-body-file
  --body/--body-file vs --append-body/--append-body-file (replace vs append)

FILTER FLAGS (for picker only, not update targets):
  -s/--status        Filter picker by status
  -t/--type          Filter picker by type
  -p/--project       Filter picker by project/concept

Examples:
  camp idea edit                                Interactive picker + $EDITOR
  camp idea edit retry-logic                    Direct edit by partial ID
  camp idea edit --status active                Picker filtered by status
  camp idea edit retry --title "Retry with backoff"
  camp idea edit retry --body "New description"
  camp idea edit retry --append-body "Additional note"
  camp idea edit retry --set-type feature --priority high
  echo "details" | camp idea edit retry --body-file -

```
camp idea edit [id] [flags]
```

### Options

```
      --append-body string        Append text to the existing body
      --append-body-file string   Append text from file (- for stdin, 10 MiB cap)
      --author string             Override the author attribution
      --body string               Replace the idea body
      --body-file string          Replace body from file (- for stdin, 10 MiB cap)
  -h, --help                      help for edit
      --horizon string            Change horizon (now, next, later, someday)
      --no-commit                 Don't create a git commit
      --priority string           Change priority (low, medium, high)
  -p, --project string            Filter picker by project
      --set-concept string        Change the concept field
      --set-status string         Change the idea status
      --set-type string           Change the type (idea, feature, bug, research, chore)
  -s, --status string             Filter picker by status
      --tag stringArray           Replace the idea's tags (repeatable)
      --title string              Set a new title
  -t, --type string               Filter picker by type
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas

---
title: "camp event add"
linkTitle: "camp event add"
description: "Record an explicit campaign ledger event"
---

## camp event add

Record an explicit campaign ledger event

### Synopsis

Record an explicit campaign ledger event for an out-of-band action.

Scope is inferred from the current directory (the workitem or festival you are
in); flags override inference. Evidence may be a campaign-relative path, a URL,
or a repo@sha commit reference, and may be repeated.

Examples:
  # A media-production decision, with the produced file as evidence
  camp event add --type decided "chose H.265 for the trailer" \
    --why "smaller files, target players all support it" \
    --evidence renders/trailer_final_v3.mp4

  # A quick note-to-trail from inside a workitem directory
  camp event add --type created "kicked off the color grade pass"

```
camp event add <title> [flags]
```

### Options

```
      --action string          join an existing action id (default: a fresh action per invocation)
      --evidence stringArray   evidence ref: <path> | <url> | <repo>@<sha> (repeatable)
      --festival string        festival id to scope the event (overrides cwd inference)
  -h, --help                   help for add
      --json                   emit a structured JSON result
      --quest string           quest id to scope the event
      --type string            event kind (required): created, transitioned, completed, decided, evidence_attached, reconciled, repaired
      --why string             the reason for the action (rendered prominently)
      --workitem string        workitem selector to scope the event (overrides cwd inference)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp event](../camp_event/)	 - Record and inspect campaign ledger events

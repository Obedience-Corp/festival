---
title: "camp quest create"
linkTitle: "camp quest create"
description: "Create a new quest"
---

## camp quest create

Create a new quest

### Synopsis

Create a new working context within a camp.

A quest is a long-lived scope of work: not a single feature or task, but a
broader initiative that may span projects, sessions, and festivals.

CAPTURE MODES:
  TUI (default)         Step-through form (name, purpose, description, tags)
  Non-interactive       Provide --no-editor or --description for agent use
  Deep (--edit)         Full YAML template in $EDITOR

A quest may optionally be bound to a workitem at creation time. Pass
--workitem <selector> to bind non-interactively (the selector accepts a
workitem ref, stable id, key, path, directory slug, or festival id), or pick
one from the optional binding step in the interactive TUI. The binding is
stored exactly as "camp quest link" would store it, so it renders through
"camp quest show" and "camp quest links" with no extra steps.

Examples:
  camp quest create                                    Interactive TUI
  camp quest create q2-reliability                     TUI with name pre-filled
  camp quest create q2-reliability --no-editor --purpose "harden platform"
  camp quest create data-pipeline --description "..."  Non-interactive
  camp quest create -e customer-onboarding             Deep capture with $EDITOR
  camp quest create launch --no-editor --workitem SC0001  Bind a festival workitem
  camp quest create launch --json --no-editor          Structured create result
  camp quest create launch --no-editor --open          Optional bounded app reveal

```
camp quest create [name] [flags]
```

### Options

```
      --description string   Full description
  -e, --edit                 Open in $EDITOR for deep capture
  -h, --help                 help for create
      --json                 Output structured creation result (non-interactive)
      --no-commit            Don't create a git commit
      --no-editor            Skip editor and create directly from flags
      --open                 Optionally reveal the created quest in an already running app
      --purpose string       Short purpose statement
      --tags string          Comma-separated tags
      --workitem string      Bind a workitem by selector (ref, id, key, path, slug, or festival id)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp

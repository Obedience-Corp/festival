---
title: "camp quest checklist"
linkTitle: "camp quest checklist"
description: "List the checklist for a quest"
---

## camp quest checklist

List the checklist for a quest

### Synopsis

List the checklist (workitem-aware todos) owned by a quest.

A checklist is the thin layer between a quest and its workitems: an ordered set
of work units, each optionally linked to a workitem, so an initiative can be
divided across agents and sessions without promoting everything into a festival.

Examples:
  camp quest checklist samantha
  camp quest checklist samantha --open
  camp quest checklist samantha --json

```
camp quest checklist <quest> [flags]
```

### Options

```
  -h, --help   help for checklist
      --json   Emit JSON output
      --open   Show only open items (not done or dropped)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp

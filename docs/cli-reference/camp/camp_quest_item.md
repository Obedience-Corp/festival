---
title: "camp quest item"
linkTitle: "camp quest item"
description: "Manage checklist items on a quest"
---

## camp quest item

Manage checklist items on a quest

### Synopsis

Manage the ordered checklist items owned by a quest.

Items are the thin unit of work under a quest. Each item may optionally link a
workitem so one design/explore packet can back several slices of work.

Examples:
  camp quest item add samantha "Ship meeting recorder" --workitem samantha-meeting-recorder
  camp quest item done samantha 01eedb
  camp quest item rank samantha 01eedb 15
  camp quest item link-workitem samantha 01eedb samantha-remote-access

```
camp quest item [flags]
```

### Options

```
  -h, --help   help for item
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp
* [camp quest item add](../camp_quest_item_add/)	 - Add a checklist item to a quest
* [camp quest item done](../camp_quest_item_done/)	 - Mark a checklist item done
* [camp quest item edit](../camp_quest_item_edit/)	 - Edit a checklist item's title, notes, or status
* [camp quest item link-workitem](../camp_quest_item_link-workitem/)	 - Link a workitem to a checklist item
* [camp quest item rank](../camp_quest_item_rank/)	 - Set a checklist item's sort rank
* [camp quest item reopen](../camp_quest_item_reopen/)	 - Reopen a completed checklist item
* [camp quest item unlink-workitem](../camp_quest_item_unlink-workitem/)	 - Remove the workitem link from a checklist item

---
title: "camp dungeon move"
linkTitle: "camp dungeon move"
description: "Move dungeon items between statuses"
---

## camp dungeon move

Move dungeon items between statuses

### Synopsis

Move items within the dungeon or from the parent directory into the dungeon.

By default, moves an item already in the dungeon root to a status directory.
When the item exists in the parent directory and not in the dungeon root, the
command automatically treats it as triage work and moves it into the dungeon.
Use --triage to force a parent-directory move.
With --triage and --to-docs, routes items to an existing campaign-root docs/<subdirectory>.
With --workitem, resolves a campaign workitem from anywhere and moves its directory
into the workitem type's local dungeon.
Moves are always auto-committed so dungeon history remains auditable.

Statuses: completed, archived, someday

Batch: pass several items followed by one shared status to move them together
(default, --triage, and --to-docs modes). Every item is validated before any
move is applied, so an invalid item aborts the whole sweep. --workitem accepts a
single item per invocation.

Dry run: --dry-run resolves and validates exactly as a real move would, prints
the source -> destination for each item, and exits without touching the
filesystem or creating a commit. Add --json for a machine-readable plan.

Examples:
  camp dungeon move old-feature archived         Move dungeon item to archived
  camp dungeon move stale-doc completed          Move dungeon item to completed
  camp dungeon move a b c archived               Move three items to archived (batch)
  camp dungeon move a b c completed --dry-run    Preview the sweep, change nothing
  camp dungeon move old-project --triage         Move parent item into dungeon root
  camp dungeon move old-project archived --triage Move parent item directly to archived
  camp dungeon move stale-note.md --triage --to-docs architecture/api Route to docs subdirectory
  camp dungeon move feature-slug archived --workitem Move workitem directory to its local archive

```
camp dungeon move <item>... [status] [flags]
```

### Options

```
      --dry-run          Preview the move(s) without touching the filesystem or creating a commit
  -h, --help             help for move
      --json             Emit the dry-run plan as JSON (requires --dry-run)
      --to-docs string   Route triage item into an existing campaign-root docs/<subdir> (requires --triage)
      --triage           Move from parent directory (not from dungeon root)
      --workitem         Resolve item as a campaign workitem and move its directory to the local dungeon
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp dungeon](../camp_dungeon/)	 - Manage the campaign dungeon

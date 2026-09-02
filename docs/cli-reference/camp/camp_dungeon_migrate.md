---
title: "camp dungeon migrate"
linkTitle: "camp dungeon migrate"
description: "Convert every camp dungeon to the hidden .dungeon spelling"
---

## camp dungeon migrate

Convert every camp dungeon to the hidden .dungeon spelling

### Synopsis

Convert every dungeon in this camp from "dungeon" to ".dungeon".

New camps hide the dungeon so it stops being the first thing newcomers ask
about. This converts a camp made before that change. A camp uses one
spelling throughout, so the sweep covers every dungeon at once: the camp
root, festivals/, .campaign/intents/, .campaign/quests/, and each workflow
type. Dungeons are discovered on disk, so locations added since this command
was written are included too.

The move goes through git, so history and rename detection survive, and lands
as a single commit you can revert.

projects/ is never touched. Projects own their own trees, and a source
directory named "dungeon" inside one is not a camp dungeon.

Release ordering matters when a camp contains festivals/: this command
also renames festivals/dungeon. Do not run it against a camp used by a
fest build that does not understand .dungeon. Land fest#274 and ship a fest
release with the matching support before making this migration available to
users.

Nothing is moved unless everything can be: if any location holds both
spellings, or a .dungeon is already in the way, the command reports it and
exits without changing anything.

```
camp dungeon migrate [flags]
```

### Examples

```
  camp dungeon migrate            Convert and commit
  camp dungeon migrate --dry-run  Show what would move, change nothing
  camp dungeon migrate --no-commit  Convert, leave the changes staged
```

### Options

```
      --dry-run     Show what would move without changing anything
  -h, --help        help for migrate
      --no-commit   Move the directories but do not commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp dungeon](../camp_dungeon/)	 - Manage the camp dungeon

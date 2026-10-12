---
title: "camp notify"
linkTitle: "camp notify"
description: "Review, dismiss, and restore camp state notices"
---

## camp notify

Review, dismiss, and restore camp state notices

### Synopsis

Review the advisory notices camp surfaces on commands you already run.

Notices describe camp state you may not know is true, such as a declared
artifact root that has never synced. Run bare in a terminal to open the notice
browser: live notices first, then the ones you have dismissed. The selected
notice shows its fix command and id; d dismisses it, r restores a dismissed
one, y copies the fix, and ? lists every key.

Off a terminal, or with --plain, bare camp notify prints the same two lists.
--json emits them for scripts and agents. The dismiss, restore, and list
subcommands act on one id at a time.

Dismissals are stored in .campaign/notices.yaml, which is committed: a
dismissal you make on one machine travels to your others, the same way the
artifact declarations it concerns do.

```
camp notify [flags]
```

### Examples

```
  camp notify                 # browse notices in a terminal; plain list otherwise
  camp notify --plain         # always print the plain list
  camp notify --json          # the same, for scripts and agents
  camp notify dismiss <id>    # dismiss one notice by id
  camp notify restore <id>    # show a dismissed notice again
```

### Options

```
  -h, --help    help for notify
      --json    Emit live and dismissed notices as JSON
      --plain   Print the plain list even when stdout is a terminal
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp notify dismiss](../camp_notify_dismiss/)	 - Stop showing a notice
* [camp notify list](../camp_notify_list/)	 - List dismissed notices
* [camp notify restore](../camp_notify_restore/)	 - Show a dismissed notice again

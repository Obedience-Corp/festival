---
title: "camp quest use"
linkTitle: "camp quest use"
description: "Activate a quest for the current terminal"
---

## camp quest use

Activate a quest for the current terminal

### Synopsis

Activate a quest as the working context for the current terminal.

This prints shell code that sets CAMP_QUEST for the current shell, so
child processes (including camp itself) inherit the quest. It is terminal-local:
other terminals in the same camp keep their own context.

The shell wrapper installed by 'camp shell-init' evaluates this automatically.
To activate without the wrapper:

  eval "$(camp quest use billing --shell bash)"

Examples:
  camp quest use billing
  camp quest use billing --allow-dungeon

```
camp quest use <quest> [flags]
```

### Options

```
      --allow-dungeon   Allow activating a completed or archived quest
  -h, --help            help for use
      --shell string    Shell dialect: posix (bash/zsh) or fish (default posix)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp

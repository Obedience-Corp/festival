---
title: "camp quest clear"
linkTitle: "camp quest clear"
description: "Clear the current terminal's quest context"
---

## camp quest clear

Clear the current terminal's quest context

### Synopsis

Clear the terminal-local quest context by unsetting CAMP_QUEST.

The shell wrapper installed by 'camp shell-init' evaluates this automatically.
Without the wrapper:

  eval "$(camp quest clear --shell bash)"

```
camp quest clear [flags]
```

### Options

```
  -h, --help           help for clear
      --shell string   Shell dialect: posix (bash/zsh) or fish (default posix)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp

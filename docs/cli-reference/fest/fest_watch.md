---
title: "fest watch"
linkTitle: "fest watch"
description: "Watch a festival's in-progress work"
---

## fest watch

Watch a festival's in-progress work

### Synopsis

Watch the in-progress state of a festival.

With a selector, fest watch resolves a festival by directory name or logical ID.
Without a selector, it watches the current festival when run from a festival
directory, the linked festival when run from a linked project directory, or a
standalone WORKFLOW.md from that workflow directory.

From a campaign or festivals workspace in an interactive terminal, fest watch
opens a festival picker. Watch mode refreshes in place until you press Ctrl+C.
It does not change your shell directory.

```
fest watch [festival-selector] [flags]
```

### Examples

```
  fest watch
  fest watch my-festival
  fest watch GS0001
```

### Options

```
      --collapsed   show collapsed tree with counters only
      --goals       show goals for phases and sequences
  -h, --help        help for watch
      --summary     show aggregate summary instead of tree view
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents

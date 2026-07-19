---
title: "camp idea convert"
linkTitle: "camp idea convert"
description: "Convert a note into an idea"
---

## camp idea convert

Convert a note into an idea

### Synopsis

Promote a note into the idea lifecycle.

A note lives outside the inbox → ready → active lifecycle. Converting it moves
the note into inbox/ and attaches an idea type, after which it behaves like
any other idea. This is the only bridge from a note into the lifecycle.

Examples:
  camp idea convert check-daemon-socket --type idea
  camp idea convert check-daemon-socket -t feature

```
camp idea convert <id> [flags]
```

### Options

```
  -h, --help          help for convert
      --no-commit     Don't create a git commit
  -t, --type string   Type to attach (idea, feature, bug, research, chore) (default "idea")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas

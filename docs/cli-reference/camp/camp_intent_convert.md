---
title: "camp intent convert"
linkTitle: "camp intent convert"
description: "Convert a note into an intent"
---

## camp intent convert

Convert a note into an intent

### Synopsis

Promote a note into the intent lifecycle.

A note lives outside the inbox → ready → active lifecycle. Converting it moves
the note into inbox/ and attaches an intent type, after which it behaves like
any other intent. This is the only bridge from a note into the lifecycle.

Examples:
  camp intent convert check-daemon-socket --type idea
  camp intent convert check-daemon-socket -t feature

```
camp intent convert <id> [flags]
```

### Options

```
  -h, --help          help for convert
      --no-commit     Don't create a git commit
  -t, --type string   Intent type to attach (idea, feature, bug, research, chore) (default "idea")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](../camp_intent/)	 - Manage campaign intents

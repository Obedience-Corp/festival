---
title: "camp intent note"
linkTitle: "camp intent note"
description: "Capture a quick note"
---

## camp intent note

Capture a quick note

### Synopsis

Capture a freeform note. Notes are a separate category from intents: they
are stored in .campaign/intents/notes/ and do not flow through the
inbox → ready → active lifecycle. A note carries no type or concept; tags
organize them.

Fast capture skips the TUI. Interactive capture uses the same title/body/tag
flow as intent add, but skips the type wheel and concept picker.

Examples:
  camp intent note "check the daemon socket path"   Capture a note immediately
  camp intent note "follow up" --body "details..."  Note with a longer body
  echo "body" | camp intent note "idea" --body-file -
  camp intent note                                  Note TUI (title + body)

```
camp intent note [text] [flags]
```

### Options

```
      --author string      Override the default author attribution
      --body string        Set note body as a literal string
      --body-file string   Read note body from file (- for stdin, 10 MiB cap)
  -h, --help               help for note
      --no-commit          Don't create a git commit
  -t, --tag stringArray    Add a tag (repeatable)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp intent](../camp_intent/)	 - Manage campaign intents

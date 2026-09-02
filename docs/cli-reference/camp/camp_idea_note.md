---
title: "camp idea note"
linkTitle: "camp idea note"
description: "Capture a quick note"
---

## camp idea note

Capture a quick note

### Synopsis

Capture a freeform note. Notes are a separate category from ideas: they
are stored in .campaign/intents/notes/ and do not flow through the
inbox → ready → active lifecycle. A note carries no type or concept; tags
organize them.

Fast capture skips the TUI. Interactive capture uses the same title/body/tag
flow as idea add, but skips the type wheel and concept picker.

Examples:
  camp idea note "check the daemon socket path"   Capture a note immediately
  camp idea note "follow up" --body "details..."  Note with a longer body
  echo "body" | camp idea note "idea" --body-file -
  camp idea note                                  Note TUI (title + body)

```
camp idea note [text] [flags]
```

### Options

```
      --author string      Override the default author attribution
      --body string        Set note body as a literal string
      --body-file string   Read note body from file (- for stdin, 10 MiB cap)
      --create-folder      Create --folder path if missing
      --folder string      Note folder under notes/ (must exist unless --create-folder)
  -h, --help               help for note
      --no-commit          Don't create a git commit
  -t, --tag stringArray    Add a tag (repeatable)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas

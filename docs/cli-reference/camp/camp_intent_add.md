---
title: "camp intent add"
linkTitle: "camp intent add"
description: "Create a new intent"
---

## camp intent add

Create a new intent

### Synopsis

Create a new intent with fast or deep capture mode.

CAPTURE MODES:
  Ultra-fast          Title provided as argument → immediate creation
  Fast TUI (default)  Step-through form (title, type, concept)
  Full TUI (--full)   Step-through form including body textarea
  Deep (--edit)       Full template in $EDITOR

Fast capture is optimized for speed - ideas are saved immediately.
Use --full when you want to add a body description in the form.
Use --edit when you need the complete template in your editor.

Examples:
  camp intent add "Add dark mode"        Ultra-fast capture
  camp intent add -c obey-campaign "Add dark mode"
  camp intent add                        Fast TUI (3-step form)
  camp intent add --campaign             Pick a target campaign interactively
  camp intent add --full                 Full TUI (includes body)
  camp intent add -e "Complex feature"   Deep capture with editor
  camp intent add -t feature "New API"   Set type explicitly

```
camp intent add [title] [flags]
```

### Options

```
  -c, --campaign string   Target campaign by name or ID; omit value to pick interactively
  -e, --edit              Open in $EDITOR for deep capture
  -f, --full              Full TUI mode with body textarea
  -h, --help              help for add
      --no-commit         Don't create a git commit
  -t, --type string       Intent type (idea, feature, bug, research, chore) (default "idea")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](../camp_intent/)	 - Manage campaign intents

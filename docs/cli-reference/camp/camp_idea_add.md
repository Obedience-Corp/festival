---
title: "camp idea add"
linkTitle: "camp idea add"
description: "Create a new idea"
---

## camp idea add

Create a new idea

### Synopsis

Create a new idea with fast or deep capture mode.

CAPTURE MODES:
  Ultra-fast          Title provided as argument → immediate creation
  Fast TUI (default)  Step-through form (title, type, concept)
  Full TUI (--full)   Step-through form including body textarea
  Deep (--edit)       Full template in $EDITOR

Fast capture is optimized for speed - ideas are saved immediately.
Use --full when you want to add a body description in the form.
Use --edit when you need the complete template in your editor.

PROGRAMMATIC (agent) FLAGS:
  --body              Set idea body from a literal string
  --body-file         Read idea body from a file (- for stdin)
  --concept           Set the concept field (e.g., "projects/camp")
  --note              Create a note instead of a lifecycle idea
  --author            Override the default author attribution

  --body and --body-file are mutually exclusive.
  --full + body flags is a usage error.
  --edit + body flags pre-fills the editor template.

Examples:
  camp idea add "Add dark mode"        Ultra-fast capture
  camp idea add -c obey-campaign "Add dark mode"
  camp idea add                        Fast TUI (3-step form)
  camp idea add --campaign             Pick a target campaign interactively
  camp idea add --full                 Full TUI (includes body)
  camp idea add --note                 Note TUI (title + body, no type/concept)
  camp idea add --note "Meeting note" --body "Follow up next week"
  camp idea add -e "Complex feature"   Deep capture with editor
  camp idea add -t feature "New API"   Set type explicitly
  camp idea add "Fix login" --body "The login page returns 500"
  camp idea add "Migrate DB" --body-file spec.md --concept projects/camp
  echo "body" | camp idea add "Idea" --body-file -

```
camp idea add [title] [flags]
```

### Options

```
      --author string      Override the default author attribution
      --body string        Set idea body as a literal string
      --body-file string   Read idea body from file (- for stdin, 10 MiB cap)
  -c, --campaign string    Target campaign by name or ID; omit value to pick interactively
      --concept string     Set the concept field (e.g., projects/camp)
  -e, --edit               Open in $EDITOR for deep capture
      --full               Full TUI mode with body textarea
  -h, --help               help for add
      --json               emit a structured JSON result
      --no-commit          Don't create a git commit
      --note               Create a note instead of a lifecycle idea
      --tag stringArray    Add a tag (repeatable)
  -t, --type string        Type (idea, feature, bug, research, chore) (default "idea")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas

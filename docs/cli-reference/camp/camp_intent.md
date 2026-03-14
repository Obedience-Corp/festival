---
title: "camp intent"
linkTitle: "camp intent"
description: "Manage campaign intents"
---

## camp intent

Manage campaign intents

### Synopsis

Manage intents for ideas and features not yet ready for full planning.

Intents capture ideas, bugs, features, and research topics that depend on work
not yet completed. They serve as structured storage for ideas that aren't ready
to become Festivals but need to be tracked.

CAPTURE MODES:
  Fast (default)    Quick capture with minimal fields
  Deep (--edit)     Open in editor for full context

INTENT LIFECYCLE:
  inbox  → Captured, not yet reviewed
  ready  → Reviewed/enriched, ready for promotion
  active → Promoted to festival/design doc, work in progress
  dungeon/* → Terminal statuses (done, killed, archived, someday)

Examples:
  camp intent add "Add dark mode toggle"         Fast capture to inbox
  camp intent add -e "Refactor auth system"      Deep capture with editor
  camp intent list                               List all intents
  camp intent list --status active               List active intents
  camp intent edit add-dark                      Edit intent (fuzzy match)
  camp intent show 20260119-153412-add-dark      Show intent details
  camp intent move add-dark ready                Mark as ready
  camp intent promote add-dark                   Promote to active via festival
  camp intent archive add-dark                   Archive intent

```
camp intent [flags]
```

### Options

```
  -h, --help   help for intent
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp intent add](../camp_intent_add/)	 - Create a new intent
* [camp intent archive](../camp_intent_archive/)	 - Archive an intent
* [camp intent count](../camp_intent_count/)	 - Count intents by status directory
* [camp intent edit](../camp_intent_edit/)	 - Edit an existing intent
* [camp intent explore](../camp_intent_explore/)	 - Interactive intent explorer
* [camp intent find](../camp_intent_find/)	 - Search for intents by title or content
* [camp intent gather](../camp_intent_gather/)	 - Gather related intents into a unified document
* [camp intent list](../camp_intent_list/)	 - List intents in the campaign
* [camp intent move](../camp_intent_move/)	 - Move intent to a different status
* [camp intent promote](../camp_intent_promote/)	 - Promote an intent through the pipeline
* [camp intent show](../camp_intent_show/)	 - Show detailed intent information

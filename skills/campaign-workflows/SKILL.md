---
name: campaign-workflows
description: Manage a camp's intents, dungeons, and workflow collections with `camp`. Use when capturing ideas, promoting intents to festivals, archiving work, or moving workflow items between statuses.
version: "1.3.1"
author: Obedience Corp
license: Apache-2.0
metadata:
  hermes:
    tags:
      - camp
      - intents
      - workflow
      - lifecycle
    category: camp
---

# Camp Workflows

A camp was previously called a campaign; these commands work the same either way.

All workflow commands here are `camp`, not `fest`.

Use `camp` for intents, dungeons, and workflow collections. `fest` is for
festival planning and execution.

## Intents

```bash
camp intent add "idea"
camp intent list
camp intent move <id> active
camp intent promote <id>
camp intent archive <id>
```

## Dungeon

```bash
camp dungeon crawl
```

`crawl` is interactive/TTY-oriented.

## Workflow Collections

A workflow collection is a camp directory under `workflow/<type>/` with its
own navigation config and workitem types.

```bash
camp workflow list                 # user-created collections
camp workflow show <name>          # config and recent workitems
camp workflow create <name>        # create a custom collection
camp workflow doctor               # report workflow surface inconsistencies
camp workflow sync                 # repair auto-fixable doctor findings
```

Item status moves are `camp intent move <id> <status>`, not a workflow command.

## Common Mistakes

- Running `fest` commands for intent or workflow-collection operations.
- Deleting old work instead of moving it to dungeon statuses.
- Promoting intents before they are sufficiently shaped.
- Reaching for a `camp flow` command: the surface is `camp workflow`.

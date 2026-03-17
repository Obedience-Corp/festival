---
name: campaign-workflows
description: Manage campaign intents, dungeons, and flow transitions with `camp`. Use when capturing ideas, promoting intents to festivals, archiving work, or moving workflow items between statuses.
---

# Campaign Workflows

All workflow commands here are `camp`, not `fest`.

Use `camp` for intents/dungeons/flows. `fest` is for festival planning/execution.

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

## Flow

```bash
camp flow status
camp flow move <item> <status>
camp flow sync
```

## Common Mistakes

- Running `fest` commands for intent/flow operations.
- Deleting old work instead of moving it to dungeon statuses.
- Promoting intents before they are sufficiently shaped.

---
name: campaign-workflows
description: Manage a camp's intents, dungeons, and workflow collections with `camp`. Use when capturing ideas, promoting intents to festivals, archiving work, or moving workflow items between statuses.
version: "1.4.2"
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

Capture the whole intent in one command. Put the body on stdin:

```bash
camp intent add "Login returns 500 after password reset" \
  --type bug --concept projects/my-api --tag auth --body-file - <<'EOF'
What is wrong or wanted, in a few sentences.

Where it came from: the task, festival, PR or session that surfaced it.

Done when: the observable result that closes it.
EOF
```

| Flag | Sets |
| --- | --- |
| `--body-file -` / `--body "text"` | Description (markdown) |
| `--type` | `idea`, `feature`, `bug`, `research`, `chore` |
| `--concept` | Owning area, for example `projects/my-api` |
| `--tag` | Tag, repeatable |
| `--json` | Print the new intent's `id` and `path` |

Run `camp intent add --help` for the other metadata flags your camp version
supports.

A title alone is still a valid capture: `camp intent add "idea"`. Write the body
when you have the context, because the reader will not.

Without a terminal, `add` needs the title argument. `--body-file -` reads stdin
until it closes, so always give it a heredoc or a pipe.

```bash
camp intent list
camp intent show <id>
camp intent edit <id> --append-body "New evidence"
camp intent move <id> ready
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
- Capturing a title and nothing else when you hold the context that explains it.
- Reaching for a `camp flow` command: the surface is `camp workflow`.

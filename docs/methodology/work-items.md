---
title: "Work Items"
weight: 27
---

# Work Items

## One Model for Every Kind of Work

A campaign accumulates work in several forms. Ideas land as intents. Design
documents grow under `workflow/design/`. Exploratory research collects under
`workflow/explore/`. Larger efforts become festivals. Each of these is "work in
progress," but each used to have its own shape, its own location, and its own way
of being tracked.

Work items give all of them one normalized model. An intent, a design doc, an
explore note, and a festival are all surfaced the same way: you can list them in a
single dashboard, link them to the code they touch, mark one as the thing you are
currently working on, and commit changes scoped to it. You stop thinking about four
different filing systems and start thinking about one stream of work.

This is the organizational primitive underneath a campaign. Campaigns give a mission
a workspace; work items give the work inside that workspace a shared identity.

## What Is a Work Item?

A work item is any tracked unit of work in a campaign. It has a type, a stable id, a
title, and a location on disk. `camp` discovers work items across the campaign and
presents them through one interface.

There are two categories of type:

- **Builtin types** are discovered automatically: `intent`, `design`, `explore`, and
  `festival`. You do not have to mark these. `camp` knows where they live and surfaces
  them as work items wherever they appear.
- **Custom types** are anything else you want to track: `feature`, `bug`, `chore`, or
  any slug-safe name your team uses. A custom work item lives under
  `workflow/<type>/<slug>/` and is identified by a `.workitem` marker file in its
  directory.

## The Dashboard

`camp workitem` (aliases `wi`, `workitems`) is the entry point. With no arguments it
opens an interactive dashboard across every work item in the campaign. For agents and
scripts, the same data is available as JSON:

{{< terminal-demo src="/images/demos/tui-workitems.gif" title="camp wi" alt="The camp wi dashboard: intents, designs, explores, and festivals in one unified list, narrowed by search" max="720" >}}

```bash
camp workitem                          # interactive dashboard
camp workitem --json                   # machine-readable output
camp workitem --json --type design     # filter by type
camp workitem --json --type intent --limit 5
camp workitem --stage active           # filter by lifecycle stage
camp workitem --query auth             # search by text
camp workitem --print                  # select one and print its path
```

`--print` is built for shell integration: it resolves to a single path you can `cd`
into or feed to another command.

## The `.workitem` Marker

Custom work items carry a `.workitem` file in their directory. It is a small YAML
document that gives the work item its identity:

```yaml
version: v1alpha5
kind: workitem
id: feature-timeline-redesign-2026-05-20
type: feature
title: Timeline Redesign
```

You rarely write this by hand. `camp` manages the `version` line and backfills
internal fields (a short reference used in commit tags, and the quest id active when
the item was created) as the schema evolves. Builtin work items (intents and
festivals) are discovered without a marker, because `camp` already knows their layout.

Two commands create the marker for you:

```bash
camp workitem create my-feature --type feature --title "My feature"   # new directory
camp workitem adopt workflow/design/existing-spike --title "Spike"    # existing directory
```

`create` scaffolds a new work item under `workflow/<type>/`. `adopt` attaches a
marker to a directory that already exists.

## Lifecycle Stages

Some work item types move through stages, which map directly to directories:

| Type | Stages | Location |
| ---- | ------ | -------- |
| `intent` | inbox, active, ready | `.campaign/intents/<stage>/` |
| `festival` | planning, ready, active | `festivals/<stage>/<festival>/` |
| `design`, `explore`, custom | single location | `workflow/<type>/<slug>/` |

When a stage-bearing item finishes, it moves into a terminal dungeon
(`workflow/<type>/dungeon/completed/`, `archived/`, or `someday/`). Dungeon items are
preserved but are not treated as active work. See
[Campaigns]({{< ref "/methodology/campaigns" >}}) for the surrounding directory layout.

## The Current Work Item

You can mark one work item as the thing you are working on right now. Later commands
use it as the default context.

```bash
camp workitem current                          # show the current selection
camp workitem current feature-timeline-redesign # set it
camp workitem current --clear                  # clear it
```

When `camp` needs to know which work item a command applies to, it resolves context in
order: an explicit selector you pass, then the nearest `.workitem` marker above your
current directory, then a matching link in the registry, then the current selection.
`camp workitem resolve --explain` prints the full resolution trace so you can see
exactly which tier won and why.

## Links

A work item rarely lives in one place. A feature might touch a project repo, a
worktree, and a festival plan. Links connect a work item to those targets so the
relationship is recorded and reusable.

```bash
camp workitem link my-feature --project api-service   # link to a project
camp workitem link my-feature --festival api-MR0001   # link to a festival
camp workitem link my-feature --cwd                   # link to the current directory
camp workitem links                                   # list links
camp workitem unlink <link-id>                        # remove a link
```

Each link has a role. A `primary` link marks the active work item for a scope, and
commit tooling picks it up automatically. `related`, `blocked_by`, and `supersedes`
roles record context without affecting commit routing. Links are stored in
`.campaign/workitems/links.yaml`, which is committed with the campaign so the whole
team shares the same graph.

## Scoped Commits

`camp workitem commit` commits the changes that belong to a work item and nothing
else. The staging plan is computed from the resolved context and printed before the
commit runs. It never silently widens to `git add .` at the campaign root.

```bash
camp workitem commit -m "implement timeline grouping"
```

The commit carries a short work item reference inside its campaign tag, so every
commit can be traced back to the work item it served. To retrieve that history later,
across the campaign root and every linked repo:

```bash
camp workitem commits my-feature      # all commits attributed to this work item
```

## Keeping the Registry Healthy

As work moves, links can point at directories that no longer exist or a current
selection can go stale. `camp workitem doctor` reports these issues, and `--fix`
repairs the auto-fixable ones (broken links, stale selections, missing references):

```bash
camp workitem doctor          # report health issues
camp workitem doctor --fix    # repair what can be repaired automatically
```

## Why It Matters

Work items are how a campaign stays navigable as it grows. Instead of remembering
which folder a design doc lives in or which branch a feature is on, you ask the
campaign: what work exists, what am I on, and what does it touch. The answer is the
same shape whether the work is an intent, a research note, or a multi-phase festival.

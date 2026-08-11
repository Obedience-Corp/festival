---
title: "camp workitem split"
linkTitle: "camp workitem split"
description: "Split a workitem into successors with lineage"
---

## camp workitem split

Split a workitem into successors with lineage

### Synopsis

Split an umbrella workitem into the focused successors that replace it.

A workitem that accumulated three years of scope is not one decision, and
retiring it whole loses the parts still live. Split names the successors,
creates or adopts them, and records the lineage in both directions so the trail
is readable from either end.

  --into <name>[:<type>]    create a successor under the type root
  --adopt <path>[:<type>]   declare an existing workitem or directory as one

Type defaults to the parent's. At least one successor is required.

No content is moved. Deciding which part of a parent's scope belongs in which
successor is judgment, and a tool that guessed would produce successors nobody
trusts. Each created successor gets a README seeded with the back-link and an
empty scope section for the author to fill.

Lineage is stamped into the markers, not links.yaml: that registry attaches
workitems to scopes, not to each other.

Splitting arms the retirement gate. The parent then refuses terminal promotion
until every declared successor exists, which is the successors-before-archive
rule made mechanical rather than remembered.

```
camp workitem split <selector> [flags]
```

### Options

```
      --adopt stringArray   Declare an existing workitem or directory as a successor: <path>[:<type>] (repeatable)
      --dry-run             Print what the split would do, change nothing
  -h, --help                help for split
      --into stringArray    Create a successor: <name>[:<type>] (repeatable)
      --json                Output result as a single JSON object
      --no-commit           Skip the auto-commit
      --undo                Reverse a split: unstamp lineage, delete only untouched successors
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items

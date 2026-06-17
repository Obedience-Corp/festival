---
title: "Loops & Orchestration"
weight: 34
---

# Loops & Orchestration

A campaign runs as loops inside loops. The same `fest next` engine that walks a
five-step checklist also drives a multi-phase festival, and the same work-item
dashboard that tells you where you left off can be handed to an agent as a queue
to work through. This guide shows how to match the loop to the work, and how to
build orchestrations that pull context in from outside the campaign and turn it
into work an agent can loop through.

## Match the loop to the work

| The work is... | Build | The loop |
|---|---|---|
| A fixed, ordered process you repeat | a standalone **WORKFLOW.md** | `fest next` to read the step, `fest workflow advance` to move on |
| Complex work that needs decomposition and verification | a **festival** | `fest next` to get the task, `fest commit` to record it |
| A stream of work arriving from outside the campaign | an **ingestion pipeline** that lands work items, then a loop over them | `just <pipeline>`, then loop over `camp workitem --json` |

Each rung reuses the one below it. A festival's planning phases are themselves
WORKFLOW.md loops. An orchestration's queue is filled with intents and festivals.
Start at the lowest rung the work actually needs.

## Simple structured loops: a WORKFLOW.md

A `WORKFLOW.md` is an ordered list of steps. Each step carries a goal, the actions
to take, the expected output, and an optional `APPROVAL REQUIRED` checkpoint that
blocks until a human signs off. You do not need a festival to use one.

Outside a festival, `fest create workflow` writes a `WORKFLOW.md` in the current
directory, initializes its runtime state, and starts a tracked run so `fest next`
works immediately:

```bash
fest create workflow release-check     # standalone WORKFLOW.md + tracked run
fest next                              # print the current step
fest workflow advance                  # complete the step, move to the next
fest workflow approve                  # clear an APPROVAL REQUIRED checkpoint
fest workflow reject                   # send a checkpoint back for revision
fest workflow status                   # where am I in the workflow
```

This is a real loop, not just a list. A checkpoint holds the loop until you
`approve`, and a `reject` routes back to an earlier step. The step list is the
loop body; the checkpoints are its conditions.

Agents and scripts can generate a workflow instead of writing it by hand. Pass the
definition as inline JSON or a file:

```bash
fest create workflow triage --steps '{"title":"Triage","steps":[ ... ]}'
fest create workflow triage --steps-file steps.json
```

Reach for a standalone workflow when the **steps are known and fixed**: a review
process, a research sweep, an onboarding sequence, a release checklist, any
repeatable ordered process. The same `WORKFLOW.md` mechanism runs the INGEST,
PLAN, and REVIEW phases inside a festival, so learning it once pays off at both
scales. See [Workflows & Gates]({{< ref "/methodology/workflows-and-gates" >}}).

## Complex structured loops: a festival

When the work needs decomposition, parallel tracks, and enforced verification, use
a festival. A festival organizes work as phases, sequences, and tasks. `fest next`
walks that structure by dependency and progress; `fest commit` records each step
with a traceability tag and advances the loop:

```bash
fest next                  # the next actionable task, by dependency and progress
# the agent does the work the task describes
fest commit -m "..."       # commit with the FE-<id> tag, then loop
```

What keeps the loop honest is the verification built into the structure. Every
implementation sequence ends in a `testing -> review -> iterate` tail, and every
phase ends in a gate. A failing review keeps the loop cycling inside the same
sequence instead of advancing past broken code. For an unattended run, wrap the
loop and bound it:

```bash
i=0
until fest next --short | grep -q "Festival complete"; do
    [ $((i+=1)) -gt 50 ] && { echo "hit iteration cap"; break; }
    # the agent executes the task fest next printed
    fest commit -m "<what the task accomplished>"
done
```

For when to choose a festival over a lighter artifact, see
[Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}}). For
keeping enough festivals queued, see
[Work Pipeline]({{< ref "/guides/work-pipeline" >}}).

## How intents, workflows, festivals, and work items relate

These are not competing systems. They are the same idea at four levels of loop
structure:

- An **intent** is a captured seed. It lives in the intent funnel and costs
  seconds to create. Most intents are triaged out; the ones that survive become
  real work.
- A **WORKFLOW.md** is an ordered step loop. It runs a known process, standalone
  or as a phase inside a festival.
- A **festival** is the full structured loop: phases, sequences, tasks, and gates,
  for work too large or too risky for a single pass.
- **Work items** are the unifying view across all of the above. An intent, a
  design doc, an explore note, and a festival are all surfaced the same way.

The escalation path is `intent -> workflow -> festival`, but you only climb as far
as the work requires. An already-actionable intent gets executed directly; a fixed
process becomes a workflow; only genuinely complex work becomes a festival.

## Work items: the loop you orchestrate over

Work items exist for two reasons, and both are about loops.

The first is **resuming**: when you come back to a campaign, `camp workitem` tells
you what exists and what you were on, so you do not have to reconstruct it from
memory or the git log.

The second is **orchestration**: `camp workitem --json` is a machine-readable
queue. You can hand it to an agent and have it loop through the work, picking the
next item, acting on it, and moving on.

```bash
camp workitem                                   # interactive dashboard: what exists, what am I on
camp workitem --json                            # the queue, machine-readable
camp workitem --json --type intent --stage ready
camp workitem current <id>                      # mark the active item (your resume anchor)
```

The orchestration loop has one shape:

```
camp workitem --json  ->  pick the next item  ->  execute it (workflow or festival)  ->  commit  ->  repeat
```

Because the queue lives on disk, the loop survives a stopped session. You can walk
away and pick it back up, and so can a different agent.

## Orchestrating external context

The highest-leverage loops start outside the campaign: pull context from an
external source, land it in the campaign as a structured checklist of work, loop
over that work, and optionally write the results back to the source.

The mechanism is a `just` recipe that triggers a pipeline script. A common, real
case is pulling AI code-review findings, for example a GitHub Copilot PR review,
into the campaign so an agent can work through them:

1. **Pull.** A `just` recipe calls the source's API or CLI and collects the units
   of work. With the GitHub CLI that is `gh api .../pulls/<n>/reviews` and
   `.../comments`, filtered to the reviewer you care about.
2. **Land it as a checklist.** The script writes one structured Markdown file per
   source unit under `workflow/pipelines/<source>/`, with one `- [ ]` checkbox per
   finding, a code-location heading, and a `> Notes:` block for the response. A
   stable per-item marker (an HTML comment carrying the source id) lets re-runs
   dedupe and append only what is new.
3. **Loop.** An agent reads the file, fixes each item, checks the box, and records
   what it did in the Notes block. The checklist is the loop body; the unchecked
   boxes are the remaining work.
4. **Write back (optional).** A second `just` recipe parses the annotated file and
   posts each response back to the source, then resolves the thread. The loop now
   closes at the external system, not just inside the campaign.

```just
# justfiles/pipelines.just  (the shape of the pattern)
ingest-reviews repo pr:
    ./scripts/pull_reviews.sh {{repo}} {{pr}}    # -> workflow/pipelines/reviews/{{repo}}/{{pr}}.md
reply-reviews repo pr:
    ./scripts/reply_reviews.sh {{repo}} {{pr}}   # parse checked items, post replies, resolve threads
```

```bash
just ingest-reviews api 1234        # pull and land as a checklist
# the agent loops the checklist in workflow/pipelines/reviews/api/1234.md
just reply-reviews api 1234         # write the resolutions back to the PR
```

You have two ways to land the pulled units, and they serve different needs:

- **As a checklist file** (above) when the units are fine-grained and you just need
  to loop through and resolve them. Lightweight, with no campaign bookkeeping.
- **As work items** when a unit is real planned work. `camp intent add` captures it
  into the funnel, or `camp workitem create --type <source> --json` lands a typed
  work item under `workflow/<source>/`. Either one then appears in `camp workitem`
  and can be promoted to a festival.

The shipped reference for the second form is `camp gather`, which imports external
data into the intent system as trackable intents with checkboxes:

```bash
camp gather feedback     # import festival feedback observations into intents
```

Today the built-in gather source is festival feedback; other sources (a GitHub
project, a Jira board, an internal API) are a short `just` recipe and script away,
following the same shape.

Landing external context this way, rather than processing it inline, buys four
things: the work survives the session so you can stop and resume; the same
dashboard shows external work next to everything else; an agent can be pointed at
the checklist or queue and loop autonomously; and each unit gains traceability once
it is executed.

## Choosing the loop

| You have | Build | The loop |
|---|---|---|
| A repeatable ordered process | a standalone `WORKFLOW.md` | `fest create workflow`, then `fest next` / `fest workflow advance` |
| Complex multi-step work | a festival | `fest next` / `fest commit` |
| A backlog arriving from outside | an ingestion pipeline | `just <pipeline>`, then loop over `camp workitem --json` |

## See also

- [Workflows & Gates]({{< ref "/methodology/workflows-and-gates" >}})
- [Work Items]({{< ref "/methodology/work-items" >}})
- [Work Pipeline]({{< ref "/guides/work-pipeline" >}})
- [Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}})

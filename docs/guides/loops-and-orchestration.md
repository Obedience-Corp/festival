---
title: "Loops & Orchestration"
weight: 34
---

# Loops & Orchestration

The festival system is built to run as loops, and most loops start with something
you say to an agent. This guide covers the kinds of loops you can build, the
prompts that start them, and how one campaign acts as a shared planning substrate
for orchestrating work across many projects at once.

## Two kinds of loop

It helps to separate two things that both get called "the loop":

- **Tool-driven loops (`fest next`).** `fest next` reads on-disk structure and
  hands you the next step: a step in a `WORKFLOW.md`, or a task in a festival plan
  under `festivals/`. The tool computes the next move from state; you or an agent
  execute it and commit. Deterministic and structured. `fest next` only knows about
  workflows and festival plans, so it only drives those.
- **Agent-driven orchestration loops.** Here the agent is the loop. You prompt it
  to read the work-item queue, pull items down, fan them out across projects with
  subagents and worktrees, and drive each one to completion (often via its own
  `fest next` loop). `fest next` does not drive this outer loop. The agent does.

Both run on one shared substrate: the campaign, which holds your intents, designs,
explore notes, and festivals, and spans every project in the workspace.

## Loops start with a prompt

A loop begins with an instruction you give an agent, and the first thing that
instruction does is point the agent at the right working directory. This matters: a
festival does its work in its **linked project or worktree**, not in the festival
folder, so the loop runs from there. The bracketed paths below are where you point
the agent (in most agent harnesses, with path autocomplete).

Start a festival, when you know where it is linked:

> Navigate to `<linked project or worktree path>` and run the fest next loop: run
> `fest next`, do the task it prints, then `fest commit`, and repeat until the
> festival is complete. Stop at any approval gate and ask me before continuing.

Start a festival, when you are not sure where it is linked:

> Navigate to `<festival path>`, run `fest go project` to jump to its linked working
> directory, then run the fest next loop there.

`fest go project` (alias `fgo project`) moves from a festival to its linked project
or worktree, and `fest go fest` goes back. Links are created with `fest link` from
inside a festival and listed with `fest links`; if a festival has no link yet,
`fest link` attaches one.

Walk a standalone WORKFLOW.md (outside a festival):

> Open `<path to the WORKFLOW.md>` and run the fest next loop: `fest next`, do the
> step, then `fest workflow advance`, and repeat until the workflow is done.

Orchestrate work items across projects:

> List the ready work items with `camp workitem --json`. For each one, create a
> worktree for its project, dispatch a subagent to implement it there, then open a
> PR. Work through the queue until it is empty, and report what landed.

## Tool-driven loops

### Simple: a standalone WORKFLOW.md

A `WORKFLOW.md` is an ordered list of steps, each with a goal, the actions to take,
and the expected output. Outside a festival, `fest create workflow` writes one in
the current directory, initializes its runtime state, and starts a tracked run so
`fest next` works immediately:

```bash
fest create workflow release-check     # standalone WORKFLOW.md + tracked run
fest next                              # print the current step
fest workflow advance                  # complete the step, move to the next
fest workflow status                   # where am I in the workflow
```

Standalone workflows advance **linearly**. They do not yet support blocking
approval checkpoints: `fest workflow approve` and `reject` are festival-scoped, so
a standalone `WORKFLOW.md` cannot hold for human sign-off. When you need an
approval gate inside the loop, use a festival phase workflow (below).

Agents and scripts can generate a workflow instead of writing it by hand:

```bash
fest create workflow triage --steps '{"title":"Triage","steps":[ ... ]}'
fest create workflow triage --steps-file steps.json
```

Reach for a standalone workflow when the **steps are known, fixed, and linear**: a
research sweep, a release checklist, an onboarding sequence, any repeatable ordered
process.

### Gated: a festival phase workflow

Inside a festival, the planning phases (INGEST, PLAN, REVIEW) use the same
`WORKFLOW.md` format, but with `APPROVAL REQUIRED` checkpoints that block until a
human signs off. This is where the human-gated loop behavior lives:

```bash
fest workflow status      # the current step or gate
fest workflow advance     # complete a step
fest workflow approve     # clear an APPROVAL REQUIRED checkpoint
fest workflow reject      # send it back for revision
```

A `reject` routes the loop back to an earlier step, so PRESENT to reject to
DECOMPOSE to forward again is a real cycle. See
[Workflows & Gates]({{< ref "/methodology/workflows-and-gates" >}}).

### Complex: a festival

When the work needs decomposition, parallel tracks, and enforced verification, use
a festival. It organizes work as phases, sequences, and tasks. Run the loop from
the festival's linked project or worktree (`fest go project` gets you there).
`fest next` walks that structure by dependency and progress; `fest commit` records
each step with a traceability tag and advances the loop:

```bash
fest next                  # the next actionable task, by dependency and progress
# the agent does the work the task describes
fest commit -m "..."       # commit with the FE-<id> tag, then loop
```

Verification is built into the structure: every implementation sequence ends in a
`testing -> review -> iterate` tail, and every phase ends in a gate. A failing
review keeps the loop cycling inside the same sequence instead of advancing past
broken code. For an unattended run, wrap the loop and bound it:

```bash
i=0
until fest next --short | grep -q "Festival complete"; do
    [ $((i+=1)) -gt 50 ] && { echo "hit iteration cap"; break; }
    # the agent executes the task fest next printed
    fest commit -m "<what the task accomplished>"
done
```

For when to choose a festival over a lighter artifact, see
[Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}}). The
escalation path is `intent -> workflow -> festival`, and you only climb as far as
the work requires.

## Work items: the shared planning substrate

Work items unify intents, designs, explore notes, and festivals into one model with
a stable id, a type, and a location. They are the substrate both kinds of loop run
on, and they span every project in the campaign.

They exist for two reasons, both about loops:

- **Resuming.** When you come back to a campaign, `camp workitem` tells you what
  exists and what you were on, so you do not reconstruct it from memory or the git
  log.
- **Orchestration.** `camp workitem --json` is a machine-readable queue. You hand it
  to an agent and it loops through the work, picking the next item, acting, and
  moving on.

```bash
camp workitem                                   # dashboard: what exists, what am I on
camp workitem --json                            # the queue, machine-readable
camp workitem --json --type intent --stage ready
camp workitem current <id>                      # mark the active item (your resume anchor)
```

Because the queue lives on disk, the loop survives a stopped session. You can walk
away and pick it back up, and so can a different agent.

## Multi-project orchestration

A campaign is not a single repository. It holds many projects (`projects/*` and
their worktrees) and one shared planning layer over all of them. Intents, work
items, and festivals can reference work in any project, which makes the campaign a
**shared planning substrate for orchestrating multiple projects at once**.

This is the agent-driven loop in its fullest form. You point an agent at the work
queue and let it fan work out across projects:

```
camp workitem --json
  -> pick the next item
  -> camp p worktree add <name> --project <p>     # isolate the target project
  -> dispatch a subagent to implement it in that worktree
  -> commit / open a PR
  -> repeat until the queue is empty
```

The commands that support it:

```bash
camp workitem link <id> --project <name>     # attach a work item to a project
camp workitem link <id> --festival <id>      # or to a festival plan
camp p worktree add <name> --project <p>     # isolated worktree at projects/worktrees/<p>/<name>/
cr just <recipe>                             # run a project's own just recipe from anywhere
```

Each work item carries its own links and traceability, so an agent can run several
in parallel, in separate worktrees, without losing track of which change belongs to
which project. The shared substrate is what makes this coherent: one queue across
the whole portfolio, resumable as a unit, with every change traceable back to its
project and its plan. Festivals can also run fully in parallel, one agent session
each. See [Work Pipeline]({{< ref "/guides/work-pipeline" >}}).

## Feeding the substrate from outside

The queue does not have to be filled by hand. A `just` recipe can run a script that
pulls context from an external source (open issues, review findings, an API export)
and lands each unit as a work item the loops above can pick up:

```bash
camp intent add "<one captured unit>"                    # land it in the funnel
camp workitem create <slug> --type <source> --json       # or as a typed work item
```

The shipped primitive for this shape is `camp gather`, which imports external data
into the intent system as trackable intents with checkboxes:

```bash
camp gather feedback     # import festival feedback observations into intents
```

Today the built-in gather source is festival feedback. Other sources are a short
`just` recipe and script away, following the same shape: pull, land as work items,
then loop over the queue. Landing external context as work items rather than
processing it inline means the work survives the session, shows up next to
everything else in `camp workitem`, and can be handed to an agent to loop through
autonomously.

## Choosing the loop

| You have | Build | Driver |
|---|---|---|
| A repeatable, linear process | a standalone `WORKFLOW.md` | `fest next` |
| A process that needs human approval gates | a festival phase workflow | `fest next` + `fest workflow approve`/`reject` |
| Complex multi-step work | a festival | `fest next` + `fest commit` |
| A queue of work spanning projects | an agent orchestration loop | the agent (work items + worktrees + subagents) |
| An external signal to ingest | a `just` pipeline into work items | `just` + `camp` |

## See also

- [Workflows & Gates]({{< ref "/methodology/workflows-and-gates" >}})
- [Work Items]({{< ref "/methodology/work-items" >}})
- [Work Pipeline]({{< ref "/guides/work-pipeline" >}})
- [Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}})

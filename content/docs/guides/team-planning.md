---
title: "Work Pipeline"
weight: 32
---

# Work Pipeline

How to keep the work pipeline full when AI agents execute faster than you can plan.

---

## The Pipeline Problem

AI agents execute festivals fast. Work that would take a team days finishes in hours. A well-structured festival with clear tasks and acceptance criteria runs through `fest next` loops at a pace that surprises even experienced users.

This creates a new bottleneck: **keeping enough planned work queued so there's always something ready to execute when capacity opens up.** The coordination challenge isn't within a single festival -- it's maintaining a pipeline of ideas, designs, and planned festivals so agent sessions never sit idle.

---

## The Work Pipeline

Work flows through a pipeline from raw idea to completed festival:

```
Idea -> Intent -> Design -> Festival -> Done
```

Each stage refines the work. Not every item passes through every stage -- a simple bug fix can go from intent straight to festival. Complex work benefits from design time before festival creation.

### Intents

Intents are the entry point. Capture ideas, bugs, features, and research topics as they come -- don't lose them while executing other work.

```bash
camp intent add "Add WebSocket support to chat"        # Fast capture
camp intent add -e "Refactor auth system"              # Deep capture with editor
camp intent list                                        # See the pipeline
camp intent list --status ready                         # What's promotion-ready
```

Intents have a lifecycle:

| Status | Meaning |
|--------|---------|
| `inbox` | Captured, not yet reviewed |
| `active` | Being enriched with details and context |
| `ready` | Fully scoped, ready to become a festival |
| `done` | Promoted to festival or resolved |
| `killed` | Abandoned |

Related intents can be gathered into a single unified work item:

```bash
camp intent gather auth-refactor token-rotation session-mgmt
```

This combines scattered ideas into a coherent scope before promotion.

### Design Docs

`workflow/design/` holds architectural thinking, specs, and decisions. Not everything needs a design doc. Simple features go straight from intent to festival. Complex work -- multi-system changes, API redesigns, platform migrations -- benefits from design time first.

Design docs are freeform. Create a directory for the topic, add markdown files, diagrams, and notes. When the design is solid, it feeds directly into festival creation.

### Festival Promotion

When an intent is ready, promote it to a festival:

```bash
camp intent promote auth-refactor    # Creates festival in planning/
```

The intent moves to `done` status with a reference to the created festival. The festival starts in `festivals/planning/` and progresses through the lifecycle:

```bash
fest promote    # planning -> ready -> active -> completed
```

Keep festivals in `planning/` and `ready/` so there's always queued work.

---

## Running Festivals in Parallel

Each festival is self-contained. One agent session runs one festival via `fest next`. Run N festivals by running N agent sessions. No coordination needed between them -- each festival has its own goal, phases, tasks, and rules.

```bash
fest list              # See all festivals in current campaign
fgo <name>             # Jump to a specific festival
fest status            # Check progress on current festival
```

Three active festivals means three agent sessions running independently. Five means five. Scale is limited by token budget, not methodology.

---

## Across Campaigns

Campaigns are independent workspaces -- different projects, different domains, different teams. Each campaign has its own festivals, intents, projects, and design docs.

```bash
camp list              # See all registered campaigns
camp switch <name>     # Switch active campaign
```

One campaign might have three active festivals while another has one. The portfolio spans campaigns. `camp list` shows the full picture.

---

## Keeping the Pipeline Full

These patterns prevent the bottleneck:

**Capture constantly.** Run `camp intent add` whenever an idea hits. Mid-festival, between sessions, during code review. Intents are cheap -- creating one takes seconds. Losing an idea because you were busy executing costs more.

**Gather related intents.** Small ideas accumulate. `camp intent gather` combines them into coherent work items that are large enough to become festivals. Three intents about auth improvements become one "auth system overhaul" festival.

**Promote in batches.** When a festival completes and capacity opens, check what's ready: `camp intent list --status ready`. Promote the highest-priority item to a festival and move it through planning.

**Use `ready/` as a buffer.** Fully planned festivals waiting in `ready/` mean zero delay when agent capacity opens up. One `fest promote` and the next session can start immediately.

**Check the queue regularly.** `fest list` shows festivals by lifecycle status. `camp intent list` shows the upstream pipeline. If `ready/` is empty and `active/` is finishing, you're about to hit the bottleneck.

---

## Within a Festival

When a single festival is large enough to benefit from internal parallelism, sequences provide it.

### Parallel Sequences

Sequences within a phase that share the same number prefix can run simultaneously:

- `01_backend/` and `01_frontend/` -- same prefix, no dependency, run in parallel
- `02_integration/` -- depends on both, runs after

Within a single sequence, tasks with the same number are also parallel:

```
01_backend/
├── 01_user_model.md         # Parallel
├── 01_api_endpoints.md      # Parallel
├── 02_integration.md        # After all 01_ tasks
├── 03_testing.md            # Quality gate
├── 04_review.md             # Quality gate
└── 05_iterate.md            # Quality gate
```

### Quality Gates

The testing-review-iterate gates at the end of each sequence are sync points. If a sequence fails its review gate, fix the issues before starting dependent sequences. Gates exist to catch problems early -- skipping them moves the cost downstream where fixes are harder.

---

## Festival Rules for Teams

`FESTIVAL_RULES.md` matters more when multiple agents or humans work on the same festival. It codifies quality standards, coding conventions, and process requirements that all workers follow. Without it, different agents make inconsistent decisions about code style, error handling, test coverage, and what "done" means.

Write festival rules before execution starts. Every agent reads them before its first `fest next`. The rules template in `.festival/templates/` can be customized to match your team's standards -- see [Agent Workflows]({{< ref "/docs/guides/agent-workflows#customizing-templates" >}}) for details.

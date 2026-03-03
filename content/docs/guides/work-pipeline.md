---
title: "Work Pipeline"
weight: 32
---

# Work Pipeline

How to keep the work pipeline full when AI agents execute faster than you can plan.

---

## The Pipeline Problem

AI agents execute festivals fast. Work that would take a team months finishes in hours. A well-structured festival with clear tasks and acceptance criteria runs through `fest next` loops at a pace that keeps surprising even experienced users -- and it compounds. A single template tweak, a model upgrade, or a better workflow pattern can collapse what took two weeks into thirty minutes. Your capacity to finish work is constantly and unpredictably improving.

This creates a new bottleneck: **keeping enough planned work queued so there's always something ready to execute when capacity opens up.** The coordination challenge isn't within a single festival -- it's maintaining a steady flow of work so agent sessions never sit idle. And because execution speed keeps accelerating, you need more planned work in the pipeline than you think.

Three complementary workflows feed the pipeline. You pick the right one based on the nature of the work.

---

## Three Ways to Generate Work

### Quick Capture: Intents

Intents are fast idea capture. Bugs, features, research topics -- grab them as they come so nothing gets lost while you're executing other work.

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
| `ready` | Fully scoped, ready to act on |
| `done` | Completed, promoted, or resolved |
| `killed` | Abandoned |

Many intents are actionable on their own -- an agent can pick up a well-scoped intent and execute it directly without any festival structure. Not everything needs a festival. Festivals are for work that's too complex for an agent to reliably implement in a single session, or where you need a specific process followed.

Related intents can be gathered into a single unified work item:

```bash
camp intent gather auth-refactor token-rotation session-mgmt
```

This combines scattered ideas into a coherent scope. If the combined scope is complex enough to warrant a festival, promote it:

```bash
camp intent promote auth-refactor    # Creates festival in planning/
```

**Best for:** things you notice while doing other work, small scoped items, backlog management. Often executable directly by an agent without further structure.

### Structured Design: Design Docs

`workflow/design/` holds architectural thinking that needs exploration. Ask an agent to design something out -- architecture, API specs, system analysis -- and the output is often enough for an agent to execute directly. A design doc can also feed a festival's INGEST phase if the work turns out to be complex enough to warrant one.

Design docs are freeform. Create a directory for the topic, add markdown files, diagrams, and notes. The output stands alone as a reference, guides direct agent execution, or becomes input for a festival -- whatever the work calls for.

**Best for:** architectural decisions, API design, system analysis that needs exploration. Often sufficient on its own for agent execution without a festival.

### Complex Execution: Festivals

Festivals are for work that agents can't reliably implement in a single session, or where you need a specific process followed with quality gates and traceability. If an agent can handle the work from an intent or design doc alone, you don't need a festival.

The power feature is structured planning. Festivals with INGEST and PLAN phases include `WORKFLOW.md` files that guide agents through rigorous thinking:

**INGEST phase workflow:**
- Read all input documents and context
- Extract requirements, constraints, and goals
- Structure output specifications
- Present findings for approval before proceeding

**PLAN phase workflow:**
- Review ingested inputs
- Gap analysis -- what's missing, what needs clarification
- Decompose work into phases, sequences, and tasks
- Make architecture and design decisions
- Scaffold the full festival structure with `fest` CLI
- Validate the plan against requirements

This structured approach produces detailed, executable plans faster than freeform planning. The agent follows a defined thinking process rather than improvising, which means fewer missed requirements and more consistent output.

```bash
fest create festival --type standard         # INGEST + PLAN phases (default)
fest create festival --type implementation   # Skip planning -- requirements already exist
fest create festival --type research         # INGEST + RESEARCH + SYNTHESIZE phases
fest create festival --type ritual           # Repeatable processes, custom structure
```

**Best for:** work too complex for a single agent session, multi-system changes, anything needing enforced process and quality gates. Don't reach for a festival when an intent or design doc is enough.

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

Each workflow feeds the pipeline differently. Use all three to prevent the bottleneck:

**Capture intents constantly.** Run `camp intent add` whenever an idea hits. Mid-festival, between sessions, during code review. Intents are cheap -- creating one takes seconds. Losing an idea because you were busy executing costs more.

**Use design docs when something needs thinking.** If you need to explore architecture, compare approaches, or work through an API design, put it in `workflow/design/`. Often the design doc is enough for an agent to execute from directly. If the work turns out to be too complex, the design doc becomes high-quality input for a festival.

**Use festival planning phases to produce execution plans fast.** The INGEST and PLAN phase workflows guide agents through structured thinking -- reading inputs, extracting requirements, gap analysis, decomposition. This produces detailed plans faster than freeform planning because the agent follows a defined process instead of improvising.

**Gather and promote when complexity warrants it.** When intents accumulate into something too complex for a single agent session, use `camp intent gather` to combine them and `camp intent promote` to create a festival. Not every intent needs promotion -- many are directly actionable.

**Keep `ready/` stocked.** Fully planned festivals waiting in `ready/` mean zero delay when agent capacity opens up. One `fest promote` and the next session can start immediately.

**Check the queue regularly.** `fest list` shows festivals by lifecycle status. `camp intent list` shows upstream ideas. If `ready/` is empty and `active/` is finishing, you're about to hit the bottleneck.

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

---
title: "Overview"
weight: 21
---

# Festival Methodology Overview

Festival Methodology is a collaborative, step-oriented planning system built for
human-AI development workflows. It replaces traditional project management
constructs -- sprints, story points, velocity tracking, time estimates -- with a
model that thinks in **steps to goals**. Every unit of work is defined by what
must be accomplished and what completion looks like, not by how long someone
guesses it will take.

AI-human collaboration operates at a fundamentally different speed than
traditional teams. When an AI agent executes implementation steps at 30x-100x
the pace of manual development, duration-based planning becomes noise. Festival
Methodology strips that noise out. What remains is a clean focus on logical
steps, dependencies between those steps, opportunities for parallel execution,
and unambiguous completion criteria.

The result is a planning system that works for a solo developer driving an AI
agent through a complex build, a team coordinating multi-phase projects, or an
AI agent operating autonomously across long-running sessions.

---

## Core Principles

1. **Goal-Oriented Step Planning** -- Every festival exists to achieve a specific, measurable goal. Planning starts by identifying the steps required to reach that goal, not by estimating calendars.
2. **Human-AI Collaborative Planning** -- Humans provide goals, requirements, architectural decisions, and validation. AI agents identify steps, structure them, create task specifications, and execute autonomously.
3. **Requirements-Driven Implementation** -- Implementation sequences can only be created after requirements are defined. No guessing. No premature coding.
4. **Just-in-Time Sequence Creation** -- Sequences are designed when a phase is ready for execution, not months in advance. Plans stay grounded in current understanding.
5. **Hyper-Efficient AI Execution** -- The methodology feeds work to AI agents in structured, unambiguous units that maximize autonomous execution at unprecedented speed.
6. **Step-Based Progression** -- Progress is measured by completed steps with verified outcomes, not by hours logged or percentage-of-time-elapsed.
7. **Context Preservation** -- Documentation is read just-in-time. Festival structure preserves context across sessions so agents resume work without re-reading the entire project history.
8. **Quality Gates** -- Every implementation sequence ends with mandatory quality verification steps (testing, review, iteration). Quality is structural, not optional.
9. **Extensible Methodology** -- The core hierarchy is fixed, but phase types, festival types, quality gate configurations, and workflow patterns are all extensible.

---

## Step-Based vs Time-Based Thinking

Traditional PM and Festival Methodology solve the same problem but start from
opposite assumptions.

**Traditional PM focuses on:** time estimates and schedules, duration-based sprint
planning, resource allocation over calendar periods, velocity and burndown charts.

**Festival Methodology focuses on:** logical steps toward goal achievement,
completion criteria for each step, dependencies between steps, parallel execution
opportunities.

When planning work, the key questions are:

- **What steps are needed?** -- Identify every step required to reach the goal.
- **What is the logical order?** -- Determine which steps depend on others.
- **What can be done in parallel?** -- Steps with the same numeric prefix execute concurrently.
- **How do we know each step is complete?** -- Define verification criteria, not deadlines.

"How long will this take?" is replaced by "What steps will achieve this goal?" --
a question that produces actionable structure instead of speculative estimates.

---

## Human-AI Collaborative Workflow

Festival Methodology is not about AI pre-planning entire projects in isolation.
It is a collaborative model with clear responsibilities.

**Human provides:** goals and success criteria, requirements and specifications,
architectural decisions and technology choices, feedback and iteration guidance,
scope decisions and priority calls.

**AI agent provides:** step identification from requirements, logical structure
and sequencing, detailed task specifications with completion criteria, autonomous
execution of implementation steps, progress documentation and tracking.

Humans define *what* needs to be achieved. AI agents structure *how* to get there
and execute the work. Humans validate results and provide course corrections.
Neither side works in isolation -- the methodology enforces this interaction
through its structure.

---

## The Three-Level Hierarchy

```
Festival
└── Phase       (3-digit prefix: 001_, 002_, 003_)
    └── Sequence    (2-digit prefix: 01_, 02_, 03_)
        └── Task        (2-digit prefix: 01_, 02_, 03_)
```

**Phases** are major stages of work representing significant milestones --
planning, implementation, review. Each phase has a type that determines its
internal structure. Phases execute sequentially unless they share the same
numeric prefix, which signals parallel execution.

**Sequences** are ordered groups of related tasks within a phase. A sequence
represents a cohesive unit of work -- "build the authentication system" or
"define the API contracts." Implementation sequences always end with quality
gate tasks.

**Tasks** are the atomic units of work. Each task is a single markdown file with
clear instructions, acceptance criteria, and a concrete deliverable. Tasks are
what AI agents execute.

See: [Phases]({{< ref "/docs/methodology/phases" >}}) | [Sequences]({{< ref "/docs/methodology/sequences" >}}) | [Tasks]({{< ref "/docs/methodology/tasks" >}})

---

## Festival Types

| Type | Purpose | Auto-Generated Phases | When to Use |
|------|---------|----------------------|-------------|
| **standard** | Full planning + implementation | INGEST, PLAN | Most projects, including the beginner path. Gather requirements, then plan. |
| **implementation** | Execution-only | IMPLEMENT | Requirements already defined. Use when you only need execution scaffolding. |
| **research** | Investigation and exploration | INGEST, RESEARCH, SYNTHESIZE | Exploring a problem space, evaluating options. |
| **ritual** | Recurring processes | Custom structure | Code reviews, releases, recurring maintenance. |

```bash
fest create festival --name "my-project" --type standard
fest types festival                    # discover all types
fest types festival show <type>        # see type details
```

For a first festival, use `--type standard` explicitly. When you use flags, `fest create festival --help` expects the festival name via `--name`.

---

## Festival Lifecycle

Festivals move through status directories representing their current state.
Movement is explicit -- a festival is physically moved from one directory to
another.

```
planning/  -->  ready/  -->  active/  -->  dungeon/completed/
                                     -->  dungeon/archived/
                                     -->  dungeon/someday/
```

| Directory | Description |
|-----------|-------------|
| `planning/` | Being designed. Structure is created and refined. |
| `ready/` | Fully planned, reviewed, and approved for execution. |
| `active/` | Currently being executed by humans or AI agents. |
| `dungeon/completed/` | Successfully finished. All goals achieved. |
| `dungeon/archived/` | Preserved for reference but no longer active. |
| `dungeon/someday/` | Deprioritized. May be revisited later. |

---

## When to Use Festival Methodology

Festival Methodology is the right fit when:

- You have a **clear goal** and want structured steps to get there.
- You want to **minimize process overhead** -- no standups, sprints, or retros unless you explicitly add them.
- The work has **natural dependencies** where some steps must complete before others begin.
- You need **flexible scope** -- the ability to add, remove, or reorder steps as understanding evolves.
- Team members (human or AI) can **work independently** on well-defined units.
- You are working **solo with AI agents** or **collaboratively** across a team.

---

## Key Advantages

**No process overhead.** No mandatory ceremonies. No standups, no sprint
planning, no retrospectives -- unless you decide they add value and create a
ritual festival for them.

**Clear dependencies.** Sequential directory numbering makes dependencies obvious.
`001_PLAN` completes before `002_IMPLEMENT`. `01_foundation` completes before
`02_features`. The filesystem *is* the dependency graph.

**Flexible scope.** Sequences are created just-in-time. If requirements change,
add new sequences, reorder existing ones, or remove work that is no longer
needed. The structure adapts to the project.

**Goal achievement focus.** Every element in the hierarchy has a goal document
defining what success looks like. Work is complete when the goal is met, not
when a calendar date arrives.

**Deep understanding required upfront.** The methodology front-loads thinking.
Requirements must be defined before implementation sequences are created. The
investment in understanding pays off in fewer false starts and less rework.

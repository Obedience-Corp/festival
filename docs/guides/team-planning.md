# Team Planning

How teams -human, AI agent, or mixed -use the Festival Methodology to coordinate work.

---

## Sequences as Units of Assignment

Sequences are the natural unit for assigning work. Each sequence is a cohesive set of 3-6 tasks that one person or agent can own end-to-end. Assign sequences to team members, not individual tasks.

Why sequences and not tasks? A single task lacks enough context to be meaningful on its own. A full phase is too large for one owner to manage. Sequences hit the sweet spot: enough scope to make autonomous progress, small enough to finish and hand off cleanly.

---

## Parallel Sequences

Sequences within a phase can run in parallel when they don't depend on each other. The numbering prefix signals dependency order:

- `01_backend/` and `01_frontend/` share the same prefix -they can run simultaneously.
- `02_integration/` depends on both and runs after.

Within a single sequence, tasks with the same number can also run in parallel:

```
01_backend/
├── 01_user_model.md         # Parallel
├── 01_api_endpoints.md      # Parallel
├── 01_database_schema.md    # Parallel
├── 02_integration.md        # After all 01_ tasks
├── 03_testing.md
├── 04_review.md
└── 05_iterate.md
```

This gives you two levels of parallelism: across sequences and within them. Use both when your team has the capacity.

---

## Quality Gates as Sync Points

The `testing -> review -> iterate` quality gates at the end of each sequence serve as natural sync points. Before starting the next sequence, verify the previous one passed its gates. This prevents compounding errors across dependent work.

If sequence `01_backend/` fails its review gate, do not start `02_integration/`. Fix the issues in the iterate step first. Quality gates exist to catch problems early -skipping them defeats the entire purpose of structured planning.

---

## Multi-Agent Workflows

When using multiple AI agents:

- **Assign each agent a sequence to own.** One agent, one sequence. Clear ownership eliminates coordination overhead.
- **Agents work autonomously within their sequence** using `fest next` to progress through tasks.
- **Quality gates force review before proceeding.** No agent skips testing or review, regardless of how confident it is.
- **`fest status` shows the coordinator which sequences are complete.** The team lead (human or lead agent) uses this to track overall progress.
- **Phase-level `PHASE_GOAL.md` gives each agent context** about the broader objective without requiring them to read every other sequence.

---

## Coordination Patterns

### Sequential Handoff

Agent A completes sequence `01_setup/`, Agent B picks up sequence `02_implement/`. Each agent gets a clean, tested starting point from the previous sequence's quality gates.

### Parallel Execution

Agents A and B work on `01_backend/` and `01_frontend/` simultaneously. Neither blocks the other. Both must pass their quality gates before `02_integration/` begins.

### Specialist Assignment

A research agent handles the entire `RESEARCH` phase. An implementation agent handles `IMPLEMENT`. Each agent operates in its area of strength across the full phase rather than splitting phases across generalists.

### Review Cycles

One agent implements tasks within a sequence. A different agent handles the review and iterate tasks at the end. This separation catches blind spots that self-review misses.

---

## Festival Rules for Teams

`FESTIVAL_RULES.md` is especially important for teams. It codifies the quality standards, coding conventions, and process requirements that all team members must follow. Without it, different agents or humans will make inconsistent decisions about:

- Code style and patterns
- Error handling conventions
- Testing requirements
- Commit message format
- What "done" means for a task

Write your festival rules before assigning sequences. Every team member reads the rules before starting work. If a quality gate fails because someone ignored the rules, that is a rules enforcement problem, not a planning problem.

---

## Putting It Together

A typical team workflow:

1. **Plan the festival.** Define phases, sequences, and tasks. Write `FESTIVAL_RULES.md`.
2. **Assign sequences.** Each team member gets one or more sequences to own.
3. **Execute in parallel** where numbering allows, sequentially where it doesn't.
4. **Gate at every boundary.** Quality gates between sequences, phase goals between phases.
5. **Track with `fest status`.** The coordinator monitors progress and unblocks dependencies.
6. **Iterate when gates fail.** Fix issues before moving forward. Never skip gates.

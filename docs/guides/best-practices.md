---
title: "Best Practices"
weight: 33
---

# Best Practices

Patterns and recommendations for getting the most out of Festival Methodology. Follow these to avoid common mistakes and keep your festivals productive.

---

## Planning

**Start with whatever you have.** A festival goal can be rough -- "overhaul the auth system" is enough to start. INGEST and PLAN phase workflows exist precisely to take rough ideas and refine them into concrete requirements, architecture decisions, and detailed task breakdowns. You don't need a polished spec to create a festival; you need a direction. The structured planning phases produce the specificity.

**Use standard festivals when requirements are unclear.** Standard festivals include INGEST and PLAN phases with WORKFLOW.md files that guide agents through structured thinking -- extracting requirements, gap analysis, decomposition. Let the planning phases do their job rather than trying to front-load all the specificity into the festival goal.

**Choose the right festival type:**

- **Standard** (default) - Full planning and implementation. Auto-scaffolds INGEST and PLAN phases that refine rough ideas into detailed execution plans.
- **Implementation** - Execution-only. Specs already exist externally. Skips ingestion, goes straight to building.
- **Research** - Investigation and exploration. Auto-scaffolds INGEST, RESEARCH, and SYNTHESIZE phases. Output is findings and analysis, not code.
- **Ritual** - Repeatable processes like releases, audits, or maintenance cycles. No default phases -- structure comes from the ritual template. Lives in `ritual/` instead of moving through the standard lifecycle.

**Know the phase types.** Each phase has a type that determines its structure and workflow:

- **ingest** - Transform unstructured input into structured specs. Uses WORKFLOW.md with `input_specs/` and `output_specs/`.
- **planning** - Architecture decisions, requirements decomposition, task breakdown. Uses WORKFLOW.md with `inputs/`, `decisions/`, `plan/`.
- **implementation** - Building features. Numbered sequences with task files and auto-appended quality gates.
- **research** - Investigation and exploration. Uses WORKFLOW.md with `sources/` and `findings/`.
- **review** - Validation and sign-off on completed work. Freeform with review criteria and checklists.
- **non_coding_action** - Documentation, releases, configuration, process changes. Freeform with action items.

**Start with the simplest structure that works.** A single phase with one or two sequences is fine for small goals. Don't create three phases because the template has three sections. Structure serves the work, not the other way around.

**Write FESTIVAL_RULES.md early.** Codify quality standards before implementation starts - test coverage thresholds, linting requirements, review criteria. This prevents arguments later about what "done" means.

---

## Writing Tasks

Every task must be **implementation-ready**. An agent should be able to read the task document and start coding immediately without asking clarifying questions.

**Include specific file paths, not descriptions.**

```
# Good
Create `internal/auth/jwt.go` with SignToken and VerifyToken functions

# Bad
Create a JWT utility module somewhere in the auth package
```

**Include actual commands to run.**

```
# Good
Run: `go test ./internal/auth/... -run TestJWT -v`

# Bad
Test the JWT implementation
```

**Include code snippets and schemas where applicable.** If the task involves a database migration, include the SQL. If it involves an API endpoint, include the request/response shape. Remove ambiguity.

**List exact deliverables with file paths.** Every task should end with a checklist of files created or modified. This makes review straightforward and completion unambiguous.

**Litmus test:** Can someone copy-paste from your task document and get working results? If not, add more detail.

---

## Execution

**Complete sequences before starting the next one.** Sequences define a unit of work with internal dependencies. Jumping between sequences creates half-finished work and broken assumptions.

**Use `fest commit` for git commits.** It tracks festival context in commit metadata, making it possible to trace changes back to specific tasks and sequences. Raw `git commit` loses this traceability.

**Run quality gates at the end of every implementation sequence.** The pattern is: implement, test, review, iterate. Don't skip the review step - bugs caught here are 10x cheaper than bugs caught in integration.

**Move completed sequences to `completed/`.** This keeps the active workspace clean and provides a clear record of progress. Use `fest status` to verify the move was tracked correctly.

**Check `fest status` regularly.** It gives you a real-time view of overall progress - what's done, what's in flight, and what's blocked. Losing awareness of festival state leads to duplicate work and missed tasks.

---

## Organization

**Festivals handle big, complex goals.** A festival decomposes a high-level goal into phases, sequences, and tasks -- all the way down to individual file changes. Think Jira epics, not tickets. You could gather a dozen related intents into one festival and plan them together, or build an entire product feature end-to-end. The only real requirement is that the work is complex enough to warrant the structure. If a single agent plan covers it, you don't need a festival. If it would take a dozen or more chained plans, a festival is the right tool.

**Use `dungeon/` for lifecycle management:**

- `dungeon/completed/` - Finished festivals (reference and metrics)
- `dungeon/archived/` - Shelved but preserved (might resume later)
- `dungeon/someday/` - Deprioritized indefinitely (ideas, not commitments)

**Keep FESTIVAL_RULES.md current.** Update it as you learn what standards actually matter for this festival. Rules written before implementation are guesses; rules updated during implementation are knowledge.

**Use `fest validate` to catch structural issues early.** Missing required files, malformed task documents, and broken sequence references are easier to fix before execution than during it.

**Link festivals to project directories with `fest link`.** This enables `fgo` navigation between the festival workspace and the project codebase - eliminates context-switching friction.

---

## Anti-Patterns

These are the failure modes that come up repeatedly. Learn to recognize them.

**Sequences without requirements.** The single biggest anti-pattern. Never create implementation sequences before requirements are defined. You will build the wrong thing and waste an entire execution cycle discovering that.

**Vague tasks.** "Implement user management" gives an agent nothing actionable. What models? What endpoints? What validation rules? What tests? A vague task produces vague output.

**Skipping quality gates.** The testing-review-iterate cycle exists because implementation sequences reliably produce bugs and gaps. Skipping review doesn't save time - it moves the cost to integration, where fixes are harder.

**Planning without structure.** Freeform planning misses requirements and produces inconsistent results. Use INGEST and PLAN phase workflows to guide structured thinking -- they exist precisely to front-load the planning work so execution phases run clean. The hierarchy (phases → sequences → tasks) handles complexity at any scale.

**Giant sequences.** Keep sequences at 3-6 tasks. If you have more than 8, the sequence covers too much scope and should be split. Large sequences are harder to track, harder to review, and harder to recover from when something goes wrong.

**Mixing work types.** Don't put frontend, backend, and DevOps tasks in the same sequence. Group by concern. A sequence that jumps between React components and Terraform configs has no coherent review criteria.

**Single-task sequences.** If your sequence contains exactly one task, it probably doesn't need to be a sequence. Either combine it with an adjacent sequence or make it a standalone task within the phase.

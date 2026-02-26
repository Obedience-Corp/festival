# Best Practices

Patterns and recommendations for getting the most out of Festival Methodology. Follow these to avoid common mistakes and keep your festivals productive.

---

## Planning

**Set concrete, outcome-focused goals.** A festival goal like "implement JWT auth with 7-day expiry and refresh token rotation" gives agents and collaborators something to verify against. "Add authentication" does not. If you can't tell when the goal is done, rewrite it.

**Don't pre-plan phases.** Start with a single phase covering the immediate work. Add phases as requirements emerge during execution. Trying to design the entire festival upfront leads to speculative structure that gets rewritten anyway.

**Choose the right festival type:**

- **Implementation** — Specs already exist. You know what to build.
- **Standard** — You need a planning phase before implementation.
- **Research** — Investigation with uncertain outcomes. Deliverables are findings, not code.

**Start with the simplest structure that works.** A single phase with one or two sequences is fine for small goals. Don't create three phases because the template has three sections. Structure serves the work, not the other way around.

**Write FESTIVAL_RULES.md early.** Codify quality standards before implementation starts — test coverage thresholds, linting requirements, review criteria. This prevents arguments later about what "done" means.

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

**Run quality gates at the end of every implementation sequence.** The pattern is: implement, test, review, iterate. Don't skip the review step — bugs caught here are 10x cheaper than bugs caught in integration.

**Move completed sequences to `completed/`.** This keeps the active workspace clean and provides a clear record of progress. Use `fest status` to verify the move was tracked correctly.

**Check `fest status` regularly.** It gives you a real-time view of overall progress — what's done, what's in flight, and what's blocked. Losing awareness of festival state leads to duplicate work and missed tasks.

---

## Organization

**One festival per goal.** If you find yourself writing "and also" in the festival description, split it into two festivals. A festival that tries to "add auth and redesign the dashboard" will deliver neither well.

**Use `dungeon/` for lifecycle management:**

- `dungeon/completed/` — Finished festivals (reference and metrics)
- `dungeon/archived/` — Shelved but preserved (might resume later)
- `dungeon/someday/` — Deprioritized indefinitely (ideas, not commitments)

**Keep FESTIVAL_RULES.md current.** Update it as you learn what standards actually matter for this festival. Rules written before implementation are guesses; rules updated during implementation are knowledge.

**Use `fest validate` to catch structural issues early.** Missing required files, malformed task documents, and broken sequence references are easier to fix before execution than during it.

**Link festivals to project directories with `fest link`.** This enables `fgo` navigation between the festival workspace and the project codebase — eliminates context-switching friction.

---

## Anti-Patterns

These are the failure modes that come up repeatedly. Learn to recognize them.

**Sequences without requirements.** The single biggest anti-pattern. Never create implementation sequences before requirements are defined. You will build the wrong thing and waste an entire execution cycle discovering that.

**Vague tasks.** "Implement user management" gives an agent nothing actionable. What models? What endpoints? What validation rules? What tests? A vague task produces vague output.

**Skipping quality gates.** The testing-review-iterate cycle exists because implementation sequences reliably produce bugs and gaps. Skipping review doesn't save time — it moves the cost to integration, where fixes are harder.

**Over-planning upfront.** Designing all phases before starting the first one is speculative architecture. You don't have enough information yet. Plan the current phase in detail, sketch the next one loosely, and leave the rest undefined.

**Giant sequences.** Keep sequences at 3-6 tasks. If you have more than 8, the sequence covers too much scope and should be split. Large sequences are harder to track, harder to review, and harder to recover from when something goes wrong.

**Mixing work types.** Don't put frontend, backend, and DevOps tasks in the same sequence. Group by concern. A sequence that jumps between React components and Terraform configs has no coherent review criteria.

**Single-task sequences.** If your sequence contains exactly one task, it probably doesn't need to be a sequence. Either combine it with an adjacent sequence or make it a standalone task within the phase.

---
title: "Your First Festival"
weight: 41
---

# Your First Festival

You are going to create a festival from scratch, add phases and sequences, write tasks, execute them with `fest next`, run quality gates, and mark the festival complete.

## Choose Your Festival Type

| Type | When to Use |
|------|-------------|
| **standard** | Requirements need discovery before implementation. |
| **implementation** | Requirements fully defined. Skip planning, start building. |
| **research** | Exploring a problem space, evaluating options. |
| **ritual** | Recurring processes like code reviews or releases. |

For this tutorial, use `implementation` -- you already know what you are building.

```bash
fest create festival --type implementation add-user-auth
```

This creates `FESTIVAL_GOAL.md`, `FESTIVAL_OVERVIEW.md`, `FESTIVAL_RULES.md`, `fest.yaml`, and an auto-scaffolded `001_IMPLEMENT/` phase ready for sequences.

## Write FESTIVAL_GOAL.md

Open `FESTIVAL_GOAL.md` and write a concrete goal. Every task you create should trace back to this document.

```markdown
# Festival Goal

## Objective
Add email/password authentication to the API service.

## Success Criteria
- [ ] Users can register with email and password
- [ ] Users can log in and receive a JWT token
- [ ] Protected endpoints require valid JWT
- [ ] All endpoints have integration tests
```

Keep it specific. "Improve authentication" is not a goal. "Add email/password authentication with JWT tokens" is.

## Review the Phase, Then Design a Sequence

The `001_IMPLEMENT/` directory was created automatically with its own `PHASE_GOAL.md`. For a single-phase implementation festival, the phase goal mirrors the festival goal at execution-level detail.

Now think about the first cohesive unit of work. For authentication, it is the user model and database -- nothing else proceeds until the user table exists.

```bash
fest create sequence
```

The TUI guides you through naming and placement. Name it `01_user_model_and_database`. A good sequence contains 3-6 related tasks that build on each other and can be executed in a focused session.

## Write Task Documents

Create task files inside the sequence directory using 2-digit numbering: `01_name.md`, `02_name.md`. Each task is a comprehensive work unit with objective, requirements, steps, and verification. Create `01_create_user_table.md`:

```markdown
# Create User Table

## Objective
Create the users table with authentication fields.

## Requirements
- [ ] Table: users (id, email, password_hash, created_at, updated_at)
- [ ] email: VARCHAR(255), UNIQUE, NOT NULL, indexed
- [ ] password_hash: VARCHAR(255), NOT NULL

## Implementation Steps
1. Create migration file: `migrations/001_create_users_table.sql`
2. Define schema with constraints and index on email
3. Run migration: `just db migrate`

## Testing
    just db migrate && just db verify

## Deliverables
- [ ] Migration file created at `migrations/001_create_users_table.sql`
- [ ] Table exists with correct schema
```

What makes this implementation-ready: file paths are real, commands are copy-pasteable, types are explicit, every requirement is verifiable. No placeholders. Create the remaining tasks the same way -- `02_create_user_model.md`, `03_add_password_hashing.md`, etc.

## Add Quality Gates

Every implementation sequence ends with mandatory quality gate tasks:

- **`04_testing.md`** -- Run the full test suite, verify coverage targets.
- **`05_review.md`** -- Code review checklist against `FESTIVAL_RULES.md`.
- **`06_iterate.md`** -- Address findings from testing and review, re-verify.

These are auto-appended when you use `fest create sequence`, or add them manually. Your final structure:

```
01_user_model_and_database/
├── 01_create_user_table.md
├── 02_create_user_model.md
├── 03_add_password_hashing.md
├── 04_testing.md
├── 05_review.md
├── 06_iterate.md
└── results/
```

The `results/` directory holds test output, review notes, and iteration logs.

## Validate the Structure

```bash
fest validate
fest validate --fix  # Auto-fix common issues
```

This checks for missing goal documents, improper numbering, and sequences without quality gates. Always validate before starting execution.

## Execute with fest next

`fest next` returns the next incomplete task with full inline context -- task document, phase goal, and festival goal in one output. Read the task, do the work, then mark it done:

```bash
fest next
# ... do the work ...
fest task completed
fest commit -m "create users table with auth fields"
```

`fest commit` stages changes and includes festival metadata for traceability. Use it instead of raw `git commit`. Run `fest next` again to advance to the next task. This loop is the entire execution model:

```
fest next → work → fest task completed → fest commit → repeat
```

## Run Quality Gates

When `fest next` serves a quality gate task, execute it thoroughly.

**Testing**: Run your test suite, verify coverage, document results in `results/testing_output.md`.
**Review**: Check error handling, naming, file sizes, test quality. Record findings in `results/review_notes.md`.
**Iterate**: Fix every issue found, re-run tests, document changes in `results/iteration_log.md`.

## Track Progress

```bash
fest status    # Overall progress and completion percentages
fest progress  # Task-by-task breakdown across the entire festival
```

## Complete the Festival

When all phases, sequences, and quality gates are done:

```bash
fest promote
```

This moves the festival from `active/` to `dungeon/completed/`. The work is preserved for reference but no longer appears in active listings.

## What You Learned

- Created a festival with type selection (`--type implementation`)
- Wrote a concrete goal with measurable success criteria
- Designed a sequence as a cohesive unit of work
- Wrote implementation-ready tasks with verification steps
- Added quality gates for testing, review, and iteration
- Executed with the loop: `fest next` / work / `fest task completed` / `fest commit`
- Tracked progress and promoted the festival to completed

## Next Steps

- [Methodology Overview]({{< ref "/docs/methodology/overview" >}}) -- Phases, sequences, and task design in depth
- [Campaign Setup]({{< ref "/docs/tutorials/campaign-setup" >}}) -- Organizing projects within a campaign workspace
- [Agent Workflows]({{< ref "/docs/guides/agent-workflows" >}}) -- Using festivals with AI agents for autonomous sessions

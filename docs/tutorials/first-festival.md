---
title: "Your First Festival"
weight: 41
---

# Your First Festival

You are going to create a festival from scratch, prepare it correctly for first execution, and reach a clean first `fest next` without falling into missing-marker or wrong-type confusion.

## Choose Your Festival Type

| Type | When to Use |
|------|-------------|
| **standard** | Requirements need discovery before implementation. This is the first-run path. |
| **implementation** | Requirements fully defined. Skip planning and start building. |
| **research** | Exploring a problem space, evaluating options. |
| **ritual** | Recurring processes like code reviews or releases. |

For this tutorial, use `standard`. It gives you the ingest and planning scaffolding a new user needs before implementation.

```bash
fest create festival --name "add-user-auth" --type standard
```

This creates `FESTIVAL_GOAL.md`, `FESTIVAL_OVERVIEW.md`, `FESTIVAL_RULES.md`, `fest.yaml`, and the scaffolded `001_INGEST/` and `002_PLAN/` phases for the beginner path.

## Fill the Required Markers

Open the generated files and replace every `REPLACE` marker with real content. Do this before you try to execute anything.

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

## Validate the Structure

```bash
fest validate
fest validate --fix  # Auto-fix common issues when available
```

This checks for missing goal documents, unfinished markers, improper numbering, and other structural problems. Always validate before the first execution step.

## Start with `fest next`

On a first-run `standard` festival, `fest next` should take you into `001_INGEST` rather than straight into implementation tasks.

```bash
fest next
```

From there, follow the workflow step exactly as written. When the festival eventually reaches implementation, tasks live directly inside the sequence directory and the quality gates are applied explicitly with:

```bash
fest gates apply --approve
```

Implementation task files live directly in the sequence directory:

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

- Created a festival with explicit type selection (`--type standard`)
- Filled required markers before execution
- Validated the structure before the first `fest next`
- Entered the correct first-run workflow instead of jumping straight to implementation
- Saw where implementation tasks and explicit quality gates fit later in the lifecycle

## Next Steps

- [Methodology Overview]({{< ref "/methodology/overview" >}}) -- Phases, sequences, and task design in depth
- [Campaign Setup]({{< ref "/tutorials/campaign-setup" >}}) -- Organizing projects within a campaign workspace
- [Agent Workflows]({{< ref "/guides/agent-workflows" >}}) -- Using festivals with AI agents for autonomous sessions

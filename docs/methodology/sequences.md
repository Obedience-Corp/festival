# Sequences

A sequence is an ordered group of related tasks within a phase. Sequences use 2-digit numbering (`01_`, `02_`) within their parent phase directory. Each sequence represents a cohesive unit of work — like "user authentication" or "API endpoints" — that can be assigned to one person or agent for focused execution.

Sequences are the primary unit of assignment. When you hand off work, you hand off a sequence.

## When to Create Sequences

Create sequences when you have concrete requirements to implement.

**Create when:**

- Human provides specific requirements or specifications
- Planning phase completed with clear deliverables
- External planning documents define what needs to be built
- Human explicitly asks for implementation of specific functionality

**Don't create when:**

- No requirements have been provided
- Planning phase hasn't been completed
- You're guessing what might need to be implemented
- You're making assumptions about user needs

Creating sequences without requirements is the single biggest anti-pattern in the methodology. A sequence built on assumptions wastes effort and produces work that gets thrown away.

## Design Guidelines

A good sequence contains 3-6 related tasks that:

- Build on each other logically
- Share common setup or dependencies
- Form a cohesive unit of work
- Can be assigned to one person or agent for focused execution
- Are derived from specific requirements

Keep sequences focused. If you find yourself context-switching between unrelated concerns, you need to split into separate sequences.

## Anti-Patterns

- **Single task per sequence** — Just make it a standalone task in the phase.
- **Unrelated tasks grouped arbitrarily** — Each sequence should have a clear theme.
- **Sequences with >8 tasks** — Break into multiple sequences. Large sequences lose focus.
- **Mixing work types** — Don't combine frontend, backend, and DevOps in one sequence. Separate by domain.
- **Creating sequences without requirements** — The biggest anti-pattern. No specs, no sequence.

## Example Sequence

```
01_user_authentication/
├── 01_create_user_model.md
├── 02_add_password_hashing.md
├── 03_implement_login_endpoint.md
├── 04_add_jwt_tokens.md
├── 05_testing_and_verify.md       ← Quality gate
├── 06_code_review.md              ← Quality gate
├── 07_review_results_iterate.md   ← Quality gate
└── results/                       ← Testing results and review documents
```

Tasks execute in numbered order. Each task builds on the output of the previous one. The sequence ends with quality gates that validate the entire body of work.

## Quality Gates

Every implementation sequence must end with quality gate tasks:

- `XX_testing.md` — Run tests, verify behavior, confirm coverage targets.
- `XX+1_review.md` — Code review against project standards.
- `XX+2_iterate.md` — Address review findings, fix issues, re-verify.

Create a `results/` subdirectory within the sequence for testing output, review documents, and iteration notes. This keeps artifacts co-located with the work that produced them.

Quality gates are not optional. Skipping them means shipping unreviewed work.

## Parallel Tasks

Tasks sharing the same number execute in parallel:

```
01_user_model.md          # These three run simultaneously
01_api_endpoints.md
01_database_migrations.md
02_integration_layer.md   # Waits for all 01_ tasks to complete
```

Use parallel numbering when tasks are genuinely independent — they share no outputs, no dependencies, and no conflicting file modifications. If two tasks might touch the same files, they are not parallel.

## Sequence Numbering

Sequences are numbered within their parent phase:

```
phase_01_setup/
├── 01_project_scaffold/
├── 02_ci_pipeline/
└── 03_dev_environment/
```

The numbering defines execution order. `01_` completes before `02_` begins. If two sequences are truly independent, give them the same number — but this is rare. Most sequences within a phase have at least an implicit ordering.

## Sequence Completion

When all tasks in a sequence are finished and quality gates pass, move the sequence directory to the phase's `completed/` subdirectory:

```
phase_02_implementation/
├── 03_api_endpoints/        ← Active work
├── completed/
│   ├── 01_data_models/      ← Done
│   └── 02_auth_layer/       ← Done
└── results/
```

This keeps the active workspace clean. You see only what still needs attention.

## Assignment

A sequence is the natural unit of delegation. When assigning work to an agent or developer:

1. Point them at the sequence directory.
2. They execute tasks in order, top to bottom.
3. They complete quality gates before marking the sequence done.
4. They move the sequence to `completed/` when finished.

One sequence, one assignee, one focused thread of work. That's the model.

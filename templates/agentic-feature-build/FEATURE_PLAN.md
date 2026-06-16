# Agentic Feature Build Plan

## Outcome

[REPLACE: What user-visible or operator-visible outcome should exist when this feature is done?]

## Why This Matters

[REPLACE: What pain does this remove, or what capability does this unlock?]

## Existing Context To Inspect First

- [REPLACE: File, package, command, or doc the agent should read before editing]
- [REPLACE: Existing test or workflow that defines expected behavior]
- [REPLACE: Related issue, PR, design note, or release constraint]

## Constraints

- Follow existing repository patterns before adding abstractions.
- Keep changes scoped to the behavior being requested.
- Preserve cancellation, error handling, and observability semantics.
- Do not introduce new external services unless the plan explicitly requires them.

## Task Breakdown

### 1. Discovery

Objective: understand the current implementation path before editing.

Acceptance criteria:

- Relevant files and integration points are identified.
- Risks or unknowns are recorded in `CONTEXT.md`.
- No production behavior is changed.

Validation:

```bash
git diff --check
```

### 2. Implementation

Objective: implement the smallest coherent version of the feature.

Acceptance criteria:

- The feature works through the existing public path.
- Error paths are handled explicitly.
- User-facing or operator-facing behavior is documented when needed.

Validation:

```bash
just test
```

### 3. Review Hardening

Objective: close gaps before handoff or PR review.

Acceptance criteria:

- Tests cover the changed behavior.
- Docs or examples match the implemented behavior.
- The final diff contains no unrelated cleanup.

Validation:

```bash
just build
just test
git diff --check
```

## Handoff Notes

[REPLACE: Decisions, tradeoffs, and next-session notes go here.]

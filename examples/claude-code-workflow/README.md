# Resumable Claude Code Workflow

This tiny example shows the difference between an ad hoc AI coding session and a Festival-backed workflow.

The scenario is intentionally small: add API rate limiting to a service. The point is not the feature; the point is how the work survives across sessions.

## Before Festival

See [before/SESSION_NOTES.md](before/SESSION_NOTES.md).

The plan lives in chat notes. A new Claude Code session has to rediscover the project, infer progress, and ask what to do next.

## After Festival

See [after/](after/).

The work has a camp-level agent instruction file, an active festival, task documents, and a context handoff file. A new Claude Code session can run:

```bash
fest next
```

and resume with the current task, surrounding context, and completion expectations.

## What To Copy

- [after/CLAUDE.md](after/CLAUDE.md) gives Claude Code a simple Festival operating rule.
- [after/festivals/active/api-rate-limit/CONTEXT.md](after/festivals/active/api-rate-limit/CONTEXT.md) captures decisions between sessions.
- [after/festivals/active/api-rate-limit/001_IMPLEMENT/01_build-rate-limit/](after/festivals/active/api-rate-limit/001_IMPLEMENT/01_build-rate-limit/) shows task-sized work an agent can execute and mark complete.

Use this as a shape, not a strict template. Real Festival projects are created with `camp init` and `fest create`.

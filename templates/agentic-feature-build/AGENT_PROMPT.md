# Agent Prompt

Use this prompt at the start of an AI coding session:

```text
Use Festival for this project. Start by running `fest next`.

Work on the returned task only. Before editing, inspect the files named in the task and identify existing patterns. Preserve context cancellation, error semantics, and repository conventions.

When the task is complete, run the validation commands listed in the task. If they pass, mark the task complete with `fest task completed` and commit with `fest commit -m "..."`

If anything is ambiguous, write the question or decision to the festival CONTEXT.md file before continuing.
```

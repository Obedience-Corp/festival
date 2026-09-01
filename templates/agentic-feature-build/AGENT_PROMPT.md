# Agent Prompt

Use this prompt at the start of an AI coding session:

```text
Use Festival for this project. Start by resolving the current camp work:

1. Run `camp workitem current`.
2. If no current work item is set, run `camp workitem --json --stage active` and ask the operator which item to use.
3. If the current work item is an active festival, run `fest next`.
4. If the current work item is an intent, design doc, explore note, or custom work item, read that work item before editing.

If `fest next` returns a task, work on that returned task only. Otherwise, work from the resolved work item scope. Before editing, inspect the relevant files and identify existing patterns. Preserve context cancellation, error semantics, and repository conventions.

When the work is complete, run the validation commands listed in the task or work item. If festival validation passes, mark the task complete with `fest task completed` and commit with `fest commit -m "..."`. If this is not festival task execution, commit with `camp workitem commit -m "..."`.

If anything is ambiguous, write the question or decision to the work item notes, or to the festival `CONTEXT.md` when executing a festival.
```

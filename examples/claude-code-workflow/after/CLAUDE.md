# Agent Instructions

Use Festival for this project.

At the start of a camp session, confirm the current work:

```bash
camp workitem current
```

If no current work item is set, use the work item dashboard before choosing work:

```bash
camp workitem
```

When the current work item is an active festival, get the next executable step:

```bash
fest next
```

Work only on the returned task unless the operator redirects you. When the task is done, run the validation commands listed in the task, mark it complete, and commit with Festival:

```bash
fest task completed
fest commit -m "short message"
```

If context is missing, inspect the active festival files before making assumptions.

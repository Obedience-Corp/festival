---
name: festival-plan
description: Turn one sentence of intent into a structured plan, sized correctly and planned through the loop
---

# Plan This

The user described work in `$ARGUMENTS`. Route it and plan it. Do not skip
straight to creating things.

## 1. Size it out loud

Say which gear this is and why, in one line, before doing anything else.

| Signal | Route |
| --- | --- |
| One file, one session, reversible | Answer in chat. Create nothing. |
| Linear, a handful of steps, one repo | `fest create workflow <name>` |
| Multi-phase, multi-repo, needs review gates, or outlives a session | `fest create festival` |

Most requests are the first row. Reaching for a festival on small work is a
failure mode, not thoroughness. If it is genuinely between two rows, pick the
smaller one and say it can be promoted later.

## 2. Show the shape, then ask

Present the proposed phases and the sequences under each. Get a yes before
anything is written to disk. You already have what you need to do this, so it
costs nothing, and it is the user's one chance to redirect.

## 3. Plan through the loop

```bash
fest create festival --type standard --name <name>
fest next     # answer what it asks, repeat
fest validate
```

Do not scaffold every phase and sequence up front and fill the `[REPLACE]`
markers afterward. That writes hundreds of unfilled markers, drops
`fest validate` from 100 to 0, and makes filling them with plausible filler the
score-restoring move. The loop is the planning process.

## 4. Plan the full scope

Plan the whole thing. Do not trim scope to make the plan look achievable or
defer the hard parts to an invented later phase. Scaling down is the user's
call, made against a complete plan.

## 5. Write tutorial-grade tasks

Each task is read by an agent with none of this conversation's context. Name the
files it touches, state error paths as well as the happy path, and cite
`file:line` anchors you have actually opened. `fest validate` scores structure,
not substance, so nothing else will catch a thin task.

## 6. Hand off

End by showing `fest status` and telling the user how to start execution
(`fest next`) or hand it to an agent.

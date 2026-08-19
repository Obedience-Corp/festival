---
name: campaign-commit
description: Choose the correct commit command in a campaign workspace. Use when you are about to commit and need to select `camp commit`, `camp p commit`, `fest commit`, or intentional root pointer sync via `camp refs-sync`.
version: "1.3.0"
author: Obedience Corp
license: Apache-2.0
metadata:
  hermes:
    tags:
      - camp
      - commit
      - git
      - traceability
    category: camp
---

# Campaign Commit Decision

## Decision

- Project change (submodule, linked project, or worktree): `camp p commit -m "msg"`
- Festival task execution: `fest commit -m "msg"`
- Campaign root files: `camp commit -m "msg"` (stages all root-level changes; submodule refs excluded by default)
- Campaign root, scoped to specific paths: `git add <paths>` then `camp commit --all=false -m "msg"` (commits only what is staged)
- Intentional root pointer sync: `camp refs-sync [submodule...]`

## Festival Commits Cover the Linked Project

When a festival or sequence has a linked project, `fest commit` makes up to two
commits even when you run it from inside the festival:

- a project commit staging the project's changes, skipped when the project is
  clean
- a campaign root commit staging only festival-scoped files, the campaign's
  `.campaign/fest/` state, and the submodule pointer

So during festival execution do not run `camp p commit` first and `fest commit`
after. One `fest commit` covers both sides. Use `--no-root` to skip the campaign
root commit.

A festival with no linked project makes the single campaign root commit only.

## Deferred Commit Queue

Camp defers its own bookkeeping commits so they do not hold the terminal. The
queue is machine-local and disposable; git is the record.

```bash
camp jobs                       # what is queued, running, or failed
camp jobs --json                # same, for agents
camp jobs retry all             # requeue everything that failed
camp jobs drop <id>             # give up on a failed job, keeping its content
camp jobs drop --running <id>   # a stalled job, and the worker holding it
camp jobs drain                 # wait for every lane, then exit
```

Dropping a job never discards work: the content stays uncommitted in the working
tree for the next ordinary commit. If `camp jobs` reports a job as `stalled`, a
commit message writer stopped answering; `--running` is what ends that wait.

## Rules

- Never run raw `git commit` anywhere in a campaign workspace; staging with `git add` is fine.
- Keep submodule commits and root pointer sync as separate, explicit actions.
- Do not bypass hooks with `--no-verify` without clear justification.
- Do not add agent co-author trailers unless explicitly requested.

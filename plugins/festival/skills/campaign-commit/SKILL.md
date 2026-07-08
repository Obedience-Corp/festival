---
name: campaign-commit
description: Choose the correct commit command in a campaign workspace. Use when you are about to commit and need to select `camp p commit`, `fest commit`, root `git commit`, or intentional root pointer sync via `camp refs-sync`.
---

# Campaign Commit Decision

## Decision

- Project submodule change: `camp p commit -m "msg"`
- Festival task execution: `fest commit -m "msg"`
- Campaign root files: `git commit -m "msg"`
- Intentional root pointer sync: `camp refs-sync [submodule...]`

## Rules

- Keep submodule commits and root pointer sync as separate, explicit actions.
- Avoid raw `git commit` in submodules when campaign tooling is available.
- Do not bypass hooks with `--no-verify` without clear justification.

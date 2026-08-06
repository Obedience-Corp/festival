---
name: campaign-commit
description: Choose the correct commit command in a campaign workspace. Use when you are about to commit and need to select `camp commit`, `camp p commit`, `fest commit`, or intentional root pointer sync via `camp refs-sync`.
---

# Campaign Commit Decision

## Decision

- Project change (submodule, linked project, or worktree): `camp p commit -m "msg"`
- Festival task execution: `fest commit -m "msg"`
- Campaign root files: `camp commit -m "msg"` (stages all root-level changes; submodule refs excluded by default)
- Campaign root, scoped to specific paths: `git add <paths>` then `camp commit --all=false -m "msg"` (commits only what is staged)
- Intentional root pointer sync: `camp refs-sync [submodule...]`

## Rules

- Never run raw `git commit` anywhere in a campaign workspace; staging with `git add` is fine.
- Keep submodule commits and root pointer sync as separate, explicit actions.
- Do not bypass hooks with `--no-verify` without clear justification.
- Do not add agent co-author trailers unless explicitly requested.

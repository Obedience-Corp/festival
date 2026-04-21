---
title: "Festival vs Paperclip"
weight: 47
---

# Festival vs Paperclip

[Paperclip](https://github.com/paperclipai/paperclip) is an orchestrator for autonomous AI companies. It is built for coordinating many agents, tracking heartbeats, auditing work, and managing budgets.

Festival is not an orchestrator. It does not spawn agents, supervise processes, or manage budgets. Festival gives agents a local mission workspace and an execution plan they can read.

## At a glance

| If you mostly need | Better fit |
|---|---|
| Agent supervision and org-level orchestration | Paperclip |
| Local mission state and resumable execution plans | Festival |
| Heartbeats, budgets, and runtime control | Paperclip |
| Repos, docs, plans, and commits tied together on disk | Festival |

## Use Paperclip when

- you want to coordinate many autonomous agents
- you need runtime visibility and supervision
- you care about budgets and process-level governance

## Use Festival when

- you want the filesystem layer for long-running AI coding work
- one mission spans repos, docs, reviews, and handoffs
- you want `camp` and `fest` to keep work organized and traceable

## They can work together

Paperclip-managed agents can still use Festival as their durable project-memory layer.

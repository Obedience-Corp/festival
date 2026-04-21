---
title: "Festival vs Agent Methodologies"
weight: 52
---

# Festival vs Agent Methodologies

[Superpowers](https://github.com/obra/superpowers), [BMAD](https://github.com/bmad-code-org/BMAD-METHOD), and [gstack](https://github.com/garrytan/gstack) focus on improving agent behavior through roles, workflows, skills, and process.

Festival is not primarily an agent-behavior package. It is the persistent workspace and execution ledger those behaviors can operate inside.

## At a glance

| If you mostly need | Better fit |
|---|---|
| Stronger in-agent behavior and role guidance | Superpowers, BMAD, or gstack |
| Persistent mission state across tools and sessions | Festival |
| Methodology inside the agent prompt or skill system | Superpowers, BMAD, or gstack |
| Local files that tie repos, plans, tasks, and commits together | Festival |

## Use Superpowers, BMAD, or gstack when

- you want a stronger process inside the agent itself
- you want role separation or specialized agent instructions
- your main pain is how the agent behaves, not where the mission state lives

## Use Festival when

- you want the mission state to survive across sessions and repos
- you need tasks, docs, decisions, and commits tied together on disk
- you want any agent to resume with `fest next`

## They can work together

Festival gives those methodologies a durable workspace to operate inside.

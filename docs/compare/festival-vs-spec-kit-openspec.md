---
title: "Festival vs Spec Kit and OpenSpec"
weight: 49
---

# Festival vs Spec Kit and OpenSpec

[Spec Kit](https://github.com/github/spec-kit) is GitHub's toolkit for spec-driven development. [OpenSpec](https://github.com/Fission-AI/OpenSpec) is a lightweight spec layer for AI coding assistants.

Festival is broader than a feature-spec layer. It keeps the whole mission coherent across repos, docs, research, plans, tasks, lifecycle state, reviews, handoffs, and commits.

## At a glance

| If you mostly need | Better fit |
|---|---|
| Better feature specs before implementation | Spec Kit or OpenSpec |
| Durable execution state during long-running work | Festival |
| Requirements that do not live only in chat | Spec Kit or OpenSpec |
| A workspace that survives planning, execution, and handoff | Festival |

## Use Spec Kit or OpenSpec when

- the main problem is agreeing on what to build
- you want a spec-driven workflow before implementation starts
- your execution process is already covered elsewhere

## Use Festival when

- the main problem is keeping long-running work coherent after planning
- you need next tasks, lifecycle state, and commit traceability
- one mission spans multiple repos and multiple sessions

## They can work together

Specs can live inside a Festival workspace, and Festival can drive execution after those specs are ready.

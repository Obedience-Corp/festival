---
title: "Infrastructure Changes and Recovery Rehearsals"
linkTitle: "Infrastructure Changes"
description: "Plan infrastructure changes with explicit checks, rollback steps, and recovery rehearsal evidence before a human approves execution."
weight: 43
---

# Infrastructure Changes and Recovery Rehearsals

Infrastructure work is easier to review when the change, the checks, and the recovery path live together. Festival gives an agent a durable plan for a migration, configuration change, dependency update, or recovery rehearsal, while the operator keeps control of live systems.

## Before, during, and after

Start with a clear outcome and an inventory of the systems in scope. A festival can separate preparation, implementation, verification, and review into phases. A recurring rehearsal can use a ritual festival or a standalone workflow when its steps are known and linear.

Before execution, capture the current state, dependencies, expected signals, approval point, and rollback trigger. During the work, the agent can update checklists, edit infrastructure files, run validation in an approved environment, and record evidence. Afterward, it can compare expected and observed results, document gaps, and prepare the next rehearsal.

{{< agent-prompt >}}
In [camp or project path], plan [infrastructure change or recovery rehearsal] for [approved environment].

Produce a change plan, dependency and risk list, pre-change checks, verification checks, explicit rollback steps, and a recovery rehearsal record. Use only the configuration, fixtures, and access described in [approved paths]. Stop at the human approval gate before any live change. If a check fails, record the evidence and return to the rollback or remediation step.
{{< /agent-prompt >}}

## The review gate

The operator reviews the blast radius, maintenance window, backup or restore evidence, rollback feasibility, and success criteria. A second reviewer can inspect the plan and rehearsal output before execution. Keep the final decision and observed results in the festival, then link any durable operational follow-up to the team’s issue tracker. The [Quick Start]({{< ref "/getting-started/quickstart" >}}) shows how to hand off a goal and stop at approval points. [Loops & Orchestration]({{< ref "/guides/loops-and-orchestration" >}}) explains when a festival phase workflow is preferable to a simpler workflow.

## External systems remain external

Cloud consoles, deployment systems, monitoring, alerting, backups, secrets, access control, and scheduling are provided and operated outside Festival. Festival does not watch infrastructure, run cron jobs, store credentials, or guarantee a safe change. The agent may work on approved files and non-production environments, or inspect operator-provided exports. A human controls production access, approval, rollback, incident communications, and the decision to continue. Keep the scope narrow enough that the checks and recovery path can be inspected before execution.

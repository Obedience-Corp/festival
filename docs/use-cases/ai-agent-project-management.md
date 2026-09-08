---
title: "AI Agent Project Management"
description: "Plan and review a cross-repository feature with an AI agent, a Festival work record, and clear human approval points."
weight: 35
---

# AI Agent Project Management

Use a festival when one outcome crosses more than one repository and needs a
human-reviewed plan before implementation. An account-deletion flow, for
example, can require an API change, a web interface, documentation, and a
verification plan. Plan the repositories, their contract, the checks, and the
decisions that need review before implementation.

Start with the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to
create a camp and bring the repositories into it. Keep each repository in its
own project directory or worktree. The festival records the shared goal; it does
not merge the repositories into one checkout.

## Give the agent an outcome it can plan

State what should be true when the work is done, the repositories in scope, and
the review boundary. This example asks for a plan first, rather than asking the
agent to start changing code.

{{< agent-prompt >}}
In this camp, plan a cross-repository feature: [outcome]. The affected projects
are [API project], [web project], and [other project or docs location]. Success
means [observable behavior and verification evidence].

Read the camp instructions and inspect the relevant code, tests, interfaces, and
existing documentation. Create a Festival plan that identifies work by project,
the API or data contract between projects, migration or compatibility concerns,
test and documentation changes, and unresolved decisions. Link the festival to
the primary implementation project or worktree, and identify the working
directory for each remaining project.

Do not change source code, deploy, contact anyone, or create external tickets.
Stop after presenting the plan, risks, and verification approach for my review.
{{< /agent-prompt >}}

The agent can use `fest intro` and `fest understand` while planning. A standard
festival gives the planning work a place to record findings, decisions, phases,
and tasks. The plan should make dependency order visible. For instance, an API
contract decision may need approval before a web task can safely start.

## Review the plan before the changes

Review the goal against the plan, then check three practical points:

- Every repository has a named responsibility, rather than a vague "update
  clients" task.
- The plan names compatibility, migration, privacy, or rollout questions that
  could change the implementation.
- Each implementation task has evidence to produce: tests, a manual check,
  documentation review, or another agreed check.

Ask for revisions while the work is still a plan. Once it is approved, tell the
agent which project or worktree to use first. It should run `fest next` from the
active festival or from its linked project or worktree. The task output supplies
the next planned step; it is not a reason to scan every repository or invent a
new order of work.

As work reaches another repository, the agent changes to the directory named by
the plan and performs the scoped task there. Keep review points for contract
changes and live-system decisions. A festival can record the implementation and
verification trail, while your repository hosting, deployment tooling, and
access controls continue to govern code review, releases, and credentials.

For task execution after approval, see [Agent Workflows]({{< ref
"/guides/agent-workflows" >}}). For parallel changes in one repository, see
[Everyday Development]({{< ref "/guides/everyday-development" >}}).

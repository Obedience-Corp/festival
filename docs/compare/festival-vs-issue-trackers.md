---
title: "Using Festival with Your Issue Tracker"
linkTitle: "Festival & Issue Trackers"
description: "Keep GitHub Issues, Linear, or Jira for team coordination. Use Festival for agent execution plans, review gates, and context, connected through scripts or justfiles."
weight: 39
---

# Using Festival with Your Issue Tracker

Keep the issue where your team already discusses it. Use Festival to organize the work your agent needs to do to resolve it.

An issue might request a new permission model. Delivering it may require decisions, changes to several repositories, migration checks, documentation, and review. A festival connects those steps to the outcome. The issue remains the place to agree on priority and communicate the result.

## Connect the request to the work

A useful handoff keeps both records linked:

| Record | What to keep there |
| --- | --- |
| Issue or ticket | Request, discussion, priority, owner, and links to the result |
| Camp intent or research | Source URL, initial questions, evidence, and constraints |
| Festival | Approved plan, task criteria, dependencies, review gates, and progress |
| Pull request | Implementation diff, verification summary, and links back to the issue and festival |

For a small fix, you may need only the issue and a branch. A festival becomes useful when the work needs decomposition, a lasting decision record, or coordination across projects.

## Bring an issue into a camp

Ask your agent to read the issue through the tracker CLI or API you already use. It can capture the source URL and relevant requirements in an intent, research work item, or festival plan.

For repeated use, put that step in a script or justfile. Decide what to copy, where it belongs, and how to recognize an issue that has already been imported. Keep credentials in your existing credential system and include only the data the work needs.

Festival stores work in files, so the integration can use your preferred language and tooling. The tracker adapter is a script or integration you supply; Festival does not include native synchronization with every tracker.

## Give the agent a bounded goal

{{< agent-prompt >}}
Read [issue URL] using the configured tracker tool. Capture its source link, requirements, and open questions in this camp.

Plan the work in [project] with Festival, including acceptance criteria and verification. Ask me about missing requirements and show the plan before implementation.

Keep the issue's discussion and priority in the tracker. When the work is ready, prepare a summary with the pull request and verification results for me to review before posting it.
{{< /agent-prompt >}}

If your team wants automated updates, define the allowed fields and posting rules in the script. A local task completing does not necessarily mean an issue should close: there may still be a deployment, review, or customer confirmation to do.

## Return a useful result

At review time, ask for the implementation, checks run, unresolved concerns, and links back to the work record. Your agent can prepare those from the festival and repository.

That leaves the team with its familiar issue workflow and gives the next agent session a specific place to continue. Follow the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to try one issue, or read [Loops & Orchestration]({{< ref "/guides/loops-and-orchestration" >}}) for recurring intake.

---
title: "Use Cases"
description: "Use Festival for cross-repo development, long-running agent work, incident investigation, research, support escalation, and infrastructure changes."
weight: 35
hideChildList: true
---

Give your agent a goal you can review, then let it work while you focus elsewhere. Festival keeps the plan, decisions, checks, and progress together so the next session can continue the work.

Start with the kind of result you need.

<div class="doc-index__list">
  <a class="doc-index__item" href="{{< ref "/use-cases/ai-agent-project-management" >}}">
    <strong>Ship a change across repositories</strong>
    <span>Coordinate implementation, tests, documentation, and review around one goal.</span>
  </a>
  <a class="doc-index__item" href="{{< ref "/use-cases/long-running-ai-coding-sessions" >}}">
    <strong>Keep long-running work moving</strong>
    <span>Hand off execution and resume from the saved plan when a session ends.</span>
  </a>
  <a class="doc-index__item" href="{{< ref "/use-cases/incident-investigation" >}}">
    <strong>Investigate an incident</strong>
    <span>Build an evidence trail, test explanations, and turn findings into follow-up work.</span>
  </a>
  <a class="doc-index__item" href="{{< ref "/use-cases/research-and-analysis" >}}">
    <strong>Research a decision or analyze data</strong>
    <span>Keep sources, scripts, assumptions, and the recommendation in the same work record.</span>
  </a>
  <a class="doc-index__item" href="{{< ref "/use-cases/support-escalation" >}}">
    <strong>Take a support case through to a fix</strong>
    <span>Connect reproduction, investigation, implementation, and a reviewed response.</span>
  </a>
  <a class="doc-index__item" href="{{< ref "/use-cases/infrastructure-changes" >}}">
    <strong>Plan infrastructure changes and recovery</strong>
    <span>Keep the change plan, rehearsal, rollback criteria, and verification connected.</span>
  </a>
</div>

## Pick up work across sessions and tools

[Agent handoff]({{< ref "/use-cases/ai-agent-handoff" >}}) covers what to save before a session ends and how the next agent resumes. For a Claude Code-specific path, see [Claude Code project management]({{< ref "/use-cases/claude-code-project-management" >}}).

These are workflows you can build with Festival and your existing tools. The agent runs commands and calls external services through the access you provide. Festival records the plan and progress; monitoring, credentials, data access, and scheduling stay with your chosen tools.

## Get value from the camp every day

A camp is also useful for ordinary development: jump between repositories with `cgo`, give parallel changes separate worktrees, and prepare for the next branch after a merge with `camp fresh`.

[Explore everyday development]({{< ref "/guides/everyday-development" >}}) and [the installer and plugin manager]({{< ref "/getting-started/festival-manager" >}}).

## Start with one outcome

Choose something whose result you can check. In the [Quick Start]({{< ref "/getting-started/quickstart" >}}), you create a camp, bring in a project, and give your agent a goal. It plans the work for your review before implementation starts.

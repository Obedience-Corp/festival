---
title: "Why Festival"
description: "Hand goals to agents while you focus on other work. Festival keeps the plan, decisions, verification, and next steps available across sessions and projects."
weight: 20
---

# Why Festival

**Festival is a vibe engineering framework.**

When you work with agents at scale, the bottleneck moves from doing the work to reviewing, understanding, and tracking it. That takes time away from thinking about the right thing to do.

Festival uses the filesystem and Git. You configure it to your workflows and processes. When it plans and executes, the work is done the way you want it done.

## Hand off the outcome, then review the result

You might ask for a feature across three repositories, an investigation into a recurring failure, or a recommendation backed by research. Your agent uses Festival to break the goal into steps, record completion criteria, and work through the plan.

You review the scope and important decisions. After approval, the agent follows the `fest next` loop and performs the work with its own tools. While it runs, you can work on a different goal. At a gate or blocker, it brings the decision back to you.

A review has something concrete to inspect: what changed, which checks ran, what passed, what remains uncertain, and how those results relate to the goal.

[Walk through your first handoff]({{< ref "/getting-started/quickstart" >}}).

## Give each part of your work its own camp

Everything lives in a workspace called a camp: the skills, planning documents, one-off scripts, and projects for a related context. That context might be your job, a side project, or a hobby.

A festival is an ambitious goal inside that camp. Structured specs, other workflows, and ideas you intend to execute are tracked as workitems.

You can create as many camps as you need and specialize each with its own skills, workflows, and processes. As you refine them over time, agents work differently in each camp. Switch between camps with `camp switch` (`csw`) to pick up that workspace's context and way of working.

You can use a camp before you need a large plan. Link your repositories, use `cgo` to move between them, and use worktrees when changes need separate working directories. After a merge, `camp fresh` handles the next branch cycle.

[See the everyday development workflow]({{< ref "/guides/everyday-development" >}}).

## Keep the reasoning with the work

A commit tells you what changed. The plan and task record explain what the change was intended to accomplish and how it was checked.

Festival keeps those records in files you can read, diff, and version with Git. A later agent or human reviewer can inspect the decisions and continue from recorded progress. The quality of that handoff depends on recording what happened, including partial work and failed checks.

The files belong to the work. You can switch between Claude Code, Codex, Grok Build, Cursor, or another agent that can read them and run the CLI.

## Use the amount of structure the goal needs

For a known sequence of steps, a standalone workflow can guide an agent through a recurring process. A festival adds a goal, phases, dependencies, and review gates when the work needs a fuller plan.

The hierarchy forms a graph of work. `fest next` reads its state and supplies the next actionable step; the agent executes that step and records the result. For work across several projects, the agent can coordinate multiple loops and worktrees.

With workflows tracked and everything organized, you can orchestrate parallel loops across many projects. Over time, camps function more like custom agents, where small seeds of your intentions trigger hundreds or thousands of individual actions.

[Learn about loops and orchestration]({{< ref "/guides/loops-and-orchestration" >}}).

## Keep the tools you already use

Your issue tracker can remain the place for team discussion and priorities. Your scripts and justfiles can bring external work into a camp and return a summary or link when it is ready for review.

Festival provides the local work structure. Your agent, services, and existing tools provide execution, access to external systems, and any scheduled triggers you choose to build.

[Find a use case]({{< ref "/use-cases" >}}), or [start with your own goal]({{< ref "/getting-started/quickstart" >}}).

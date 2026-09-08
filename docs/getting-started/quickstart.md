---
title: "Quick Start"
description: "Create a camp, hand a goal to your agent, and review the work as it progresses. A video-led first run with Festival."
weight: 12
---

# Quick Start

**Hand off a goal. Keep working on what matters to you.**

Festival gives your agent a plan to follow and a lasting record of the work. You set the goal and review the important decisions. Your agent plans, executes, and checks the work while you focus elsewhere.

This guide takes you from a fresh install to your first handoff. The recordings show what to look for along the way.

1. [Install the tools](#install)
2. [Create a camp](#create-a-camp)
3. [Hand off a goal](#hand-off-a-goal)
4. [Run, review, and resume](#run-review-and-resume)

## 1. Install the tools {#install}

Choose one method. Both install `camp`, `fest`, and the `festival` suite manager.

**Homebrew on macOS**

```bash
brew install --cask Obedience-Corp/tap/festival
```

**npm with Node.js installed**

```bash
npm install -g @obedience-corp/festival
```

For Linux packages, other install methods, or troubleshooting, see [Installation]({{< ref "/getting-started/installation" >}}).

Check that the tools are available:

```bash
festival doctor
```

Then choose an [agent setup guide]({{< ref "/getting-started/agents" >}}) for your existing coding agent. Claude Code, Codex, Cursor, Grok Build, and other agents that can read files and run commands can use Festival. Agent-specific skills are optional; the CLI includes guidance your agent can read.

**Ready when:** the tools are installed and your agent can run `camp` and `fest` in its terminal.

## 2. Create a camp {#create-a-camp}

A **camp** holds the context for one part of your life: your job, a side project, or a hobby. Each camp can contain several projects, with shared plans, research, and decisions. Start with one.

From a directory where you keep your work:

```bash
camp init my-camp
cd my-camp
```

This creates `projects/`, `festivals/`, `docs/`, and instructions for your agent in `AGENTS.md`.

Bring in a repository you already work on. Replace the example path with its full local path:

```bash
camp project link /path/to/your-existing-repo
```

This links the project into the camp without moving it, and adds a `.camp` attachment file to the project. To clone a repository into the camp instead, use [`camp project add`]({{< ref "/cli-reference/camp/camp_project_add" >}}).

{{< terminal-demo src="/images/demos/tui-setup.gif" poster="/images/demos/tui-setup-poster.png" title="Camp setup" alt="A terminal session initializes a camp, adds a local project, and scaffolds a standard festival." width="860" height="500" max="760" caption="Watch a sample camp take shape. The recording uses camp project add --local; the command above links an existing repository. Your agent will create your own festival in the next step." >}}

**Ready when:** your project is accessible under `projects/`. Open your agent at the camp root, `my-camp/`, so it can read both the camp instructions and the project.

## 3. Hand off a goal {#hand-off-a-goal}

A **festival** is the structured plan and work record for a goal. Choose a real outcome you can review, such as adding a feature with tests or investigating a problem and delivering a recommendation.

Tell your agent what you want, which project to use, and what a good result looks like. Replace the bracketed text in this starter prompt:

{{< agent-prompt >}}
Read AGENTS.md and run fest intro to learn this camp's workflow.

In [project name], I want [specific outcome].
Success means [what I should be able to verify].
Constraints: [scope, compatibility, or other requirements].

Use the fest CLI to create and plan a standard festival for this goal. Ask me about missing requirements, follow the planning workflow, and stop at approval gates. Fill required markers, validate the plan, and link the festival to the project or worktree where you will implement it.

Show me the plan and its location before starting implementation.
{{< /agent-prompt >}}

{{< terminal-demo src="/images/demos/tui-delegate.gif" poster="/images/demos/tui-delegate-poster.png" title="Planning with Grok Build" alt="Grok Build receives a goal, reads Festival guidance, and creates a design work item and an eight-phase festival plan." width="860" height="556" max="760" caption="A real Grok Build session planning a sample app feature. Your agent's interface and the size of your plan will vary with the goal." >}}

**Review before execution:** does the plan describe the outcome you want, stay within scope, and include checks that will demonstrate it works? Ask for changes here, then approve the plan when you are ready.

## 4. Run, review, and resume {#run-review-and-resume}

After reviewing the plan, give your agent the go-ahead:

{{< agent-prompt >}}
The plan is approved. Work on this festival from its linked project or worktree. Run fest next, follow the instructions it returns, record progress, and repeat. Run the planned checks and review the results before marking work complete.

Continue until the goal is complete or you reach an approval gate, a blocker, or a decision that needs me. Ask me at those points. Finish with a summary of what changed, the verification results, and anything I should review.
{{< /agent-prompt >}}

`fest next` supplies the next step and its context. Your agent runs the loop; you can work on something else and return at a review point. Keep the agent's own permission settings appropriate for the work you have authorized.

To check progress yourself, open another terminal in the festival directory your agent showed you:

```bash
fest watch
```

{{< terminal-demo src="/images/demos/tui-fest-watch.gif" poster="/images/demos/tui-fest-watch-poster.png" title="Progress with fest watch" alt="The fest watch terminal interface updates a festival tree as sample task progress advances." width="860" height="513" max="760" caption="The progress view you can open alongside your agent. This recording demonstrates fest watch with scripted progress updates in a sample festival." >}}

**If the session ends:** open your agent in the same camp and point it to the saved festival. Ask it to read the current state and continue the `fest next` loop from the linked project. The plan, recorded progress, and decisions stay in files between sessions.

**Your first handoff is complete when:** you have reviewed the result against your success criteria, checked the verification evidence, and can find the plan and work record in the camp. That gives the next session a starting point for whatever comes next.

## Keep going

- [Shell integration]({{< ref "/getting-started/shell-setup" >}}): add `cgo` and `fgo` navigation shortcuts.
- [First Festival tutorial]({{< ref "/tutorials/first-festival" >}}): walk through the scaffolding and task structure yourself.
- [Loops & Orchestration]({{< ref "/guides/loops-and-orchestration" >}}): build repeatable loops and coordinate work across projects.
- [Work items]({{< ref "/cli-reference/camp/camp_workitem" >}}): find your intents, designs, and festivals as the camp grows.

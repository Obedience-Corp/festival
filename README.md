# Festival

![Festival Banner](docs/images/festival_banner.png)

<p align="center"><a href="https://github.com/Obedience-Corp/festival"><img src="https://img.shields.io/github/stars/Obedience-Corp/festival?style=social" alt="Star Festival on GitHub"></a></p>

**Festival is a vibe engineering framework.**

It uses the filesystem and Git. You configure it to your workflows and processes. When agents plan and execute, the work is done the way you want it done.

I was working with agents at scale, and the bottleneck moved from doing the work to reviewing, understanding, and tracking it. That was draining the time I wanted for thinking about the right thing to do.

Everything lives in a camp workspace: your skills, planning documents, one-off scripts, and projects. A festival is an ambitious goal inside that camp. Specs, smaller workflows, and ideas you intend to execute are tracked as work items.

You can create as many camps as you need and specialize each with its own skills, workflows, and processes. As you refine them over time, agents work differently in each camp. Switch between camps with `camp switch` (`csw`) to pick up that workspace's context and way of working.

You describe a goal in a sentence. Your agent plans that goal inside the workflows you set up, and `fest next` shows it the next step. The plan, the checks, and the commits stay in files and Git when the session ends.

Use it with Claude Code, Codex, Grok Build, Cursor, OpenCode, or another agent that can read files and run commands.

[Get started](#get-started) · [Explore the demos](#explore-the-tools) · [Video quick start](https://docs.fest.build/getting-started/quickstart/) · [Website](https://fest.build/) · [Discord](https://discord.gg/Rt7dDY6VqD) · [简体中文](README.zh-CN.md)

## See Festival in action

Three completed festivals built the [CodeSignal Practice Simulator](https://github.com/Festival-Examples/codesignal-practice-simulator).
Agents followed the `fest next` loop, with testing and review gates feeding
findings back into fixes. The demo repository includes the plans, tasks,
review findings, and verification evidence for each build.

<p align="center">
  <a href="https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals/codesignal-browser-assessment-simulator-CB0001"><img src="https://raw.githubusercontent.com/Festival-Examples/codesignal-practice-simulator/main/festivals/codesignal-browser-assessment-simulator-CB0001/codesignal-browser-assessment-simulator-CB0001.gif" alt="Festival execution replay: six phases advance to completion." width="440"></a>
</p>

[Explore the demo](https://github.com/Festival-Examples/codesignal-practice-simulator) ·
[Inspect the three festivals](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals) ·
[Watch all three replays](https://github.com/Festival-Examples/codesignal-practice-simulator#how-this-was-built)

[Try it on one real goal](#get-started), or star this repository to keep it handy.

## What would you hand off?

Start with a real outcome that you can review. For example:

- **A feature across repositories:** “Add account deletion to the API and web app. Cover it with tests and document how existing users are affected.”
- **An investigation before a build:** “Investigate why this service slows down under load. Save the evidence, compare the options, and bring me a recommendation before changing production.”
- **A recurring review:** “Review this week's dependency changes, flag compatibility risks, and prepare the updates for my approval.”

The goal, constraints, and success criteria come from you. Your agent works through the plan and returns when it reaches a review point or a decision that needs you.

[Explore the use cases](https://docs.fest.build/use-cases/) · [See example camps and festivals](https://github.com/Obedience-Corp/examples)

## Get started

**Try it on one real goal.** Start with one repository and one goal you already want to finish. Use your existing coding agent to plan the work, execute it, and leave the results ready for review.

### 1. Set up with your agent

Replace the brackets and paste this into your coding agent. It will install Festival if needed, create one camp, and link your existing repository. Git is required.

```text
Help me set up Festival for this goal: [what you want done and how you'll know it worked].
My existing repository is at: [full local path].

If `camp`, `fest`, or `festival` is missing, install Festival. On macOS with Homebrew, use `brew install --cask Obedience-Corp/tap/festival`. On macOS or Linux with Node.js, use `npm install -g @obedience-corp/festival`. Run `festival doctor` to check the install.

To update camp, fest, and festival together, run `festival update`. Do not pass `--force`.

Ask me for a camp name, a one-line description, and a mission. Create the camp with `camp create <name> -d "<description>" -m "<mission>"`. Read `camp create --help` before adding flags. Use `camp create` for this. Do not run `camp init` or `festival setup`. Use the camp path printed by the command (by default, `~/campaigns/<name>`).

Set up navigation for my shell, adding the following lines to its config only if they are missing. For zsh or bash, use `eval "$(camp shell-init <shell>)"` and `eval "$(fest shell-init <shell>)"`, replacing `<shell>` with `zsh` or `bash`. For fish, use `camp shell-init fish | source` and `fest shell-init fish | source`. Tell me to open a new terminal and run `csw <name>`; you can keep working from the camp root.

From the camp root, run `camp project link <full-local-repo-path> --yes`. This leaves the repository in place, links it under `projects/`, and adds a `.camp` attachment file to it.

Read the camp and project instructions, then use `fest understand` to learn the workflow. Skills are optional. Create a festival for my goal, link it to the project with `fest link` from the festival directory, and run the `fest next` loop. Ask me when you need a decision. Show me the festival path so I can follow progress, and leave the results and verification evidence ready for review.
```

The [agent setup guides](https://docs.fest.build/getting-started/agents/) cover optional skills and integrations for your tool.

<details>
<summary>Prefer to set up manually?</summary>

Choose one method. Both install `camp`, `fest`, and the `festival` manager.

**macOS with Homebrew**

```bash
brew install --cask Obedience-Corp/tap/festival
```

**macOS or Linux with Node.js**

```bash
npm install -g @obedience-corp/festival
```

Check the install and create one camp:

```bash
festival doctor
camp create my-camp
```

`camp create` asks for a description and mission. By default, it creates your camp at `~/campaigns/my-camp`. Enter the path printed by the command and link a repository you already use:

```bash
cd ~/campaigns/my-camp
camp project link /path/to/your-existing-repo
```

Replace the repository path with its full local path. Your repository stays where it is. Camp links it under `projects/` and adds a `.camp` attachment file to the repository. You can also [clone a project into the camp](https://docs.fest.build/cli-reference/camp/camp_project_add/).

Open your coding agent at the camp root, then give it a goal below. Add the [shell integration](https://docs.fest.build/getting-started/shell-setup/) to enable navigation shortcuts such as `csw`.

[Linux packages, WSL2, and other install methods](https://docs.fest.build/getting-started/installation/). Native Windows support is being hardened; use WSL2 for now.

</details>

### 2. Give your agent a goal

If you used the setup prompt, your agent already has your first goal. For manual setup or your next goal, tell it:

> I want [what you want done]. Success means [what you will check]. Create a festival for it, link it to the project, and run the `fest next` loop. Show me the festival path and leave the results ready for review.

<p align="center">
  <img src="docs/images/demos/tui-delegate.gif" alt="Grok Build receives a goal, reads Festival guidance, and creates a design work item and festival plan." width="700">
</p>

A real Grok Build session planning a sample app feature. The agent handles the planning commands; you review the proposed work.

### 3. Follow progress and review the result

Your agent handles planning and execution, asking you when it reaches an approval point or needs a decision. You can focus on other work and review the results when they're ready.

To check progress along the way, open another terminal at the festival path your agent gives you and run `fest watch`.

When the work is ready, ask your agent to show you:

- The result against your original goal and success criteria.
- The changed files and commits in your project.
- The test and review evidence, including failures, unresolved questions, and decisions that still need you.

Use the saved festival plan and work records together with your project's Git history to review what happened before accepting the result.

<p align="center">
  <img src="docs/images/demos/tui-fest-watch.gif" alt="The fest watch terminal view updates a festival tree as scripted sample tasks advance." width="700">
</p>

The progress view you can open alongside your agent. This recording demonstrates the real `fest watch` interface with scripted progress updates in a sample festival.

**If the session ends:** point your next agent at the saved festival and ask it to continue from the linked project. The recorded plan, progress, and decisions give it a starting point.

[Follow the video quick start](https://docs.fest.build/getting-started/quickstart/) to see setup, planning with Grok Build, and the progress view.

## Share a festival replay

`fest gif` turns recorded festival progress into a GIF you can send and share:

```bash
fest gif my-festival -o replay.gif
fest gif --festival MF0001 --speed 2
```

When a festival moves to completed, Fest creates `festival-replay.gif` and embeds
it in `FESTIVAL_OVERVIEW.md`, with both files included in the completion commit.
Use `fest gif --embed` to refresh it or add a replay to an older festival.

See the [replay guide](https://docs.fest.build/guides/festival-replays/) for
examples, sharing, and recovery.

## How the work stays coherent

A festival is a **graph of work**, organized into phases, sequences, and tasks. Each task has context and completion criteria. Your agent uses `fest next` to find the next actionable step, does the work, checks the result, and records progress before continuing.

That is the basis for **loop engineering** with Festival: repeatable planning, execution, review, and handoff loops. You can start with a lightweight `WORKFLOW.md`, build a full festival for a larger goal, or run separate festivals with agents in separate worktrees.

The camp holds the context around those goals over the life of the work. Research can inform a design; that design can become a festival; its results and decisions remain available for the next goal.

You can work on many projects at once. Over time, camps function more like custom agents, where small seeds of your intentions trigger hundreds or thousands of individual actions.

Each camp has its own context and workflows, so switching camps changes how your agents work.

Quality gates provide places to test and review. `fest validate` checks plan structure, and `fest commit` links commits to festival tasks. You review the actual output and verification evidence before accepting the result.

[Loops & orchestration](https://docs.fest.build/guides/loops-and-orchestration/) · [Festival methodology](https://docs.fest.build/methodology/overview/) · [Work items](https://docs.fest.build/methodology/work-items/)

### Three tools, one work system

| Tool | What it handles |
| --- | --- |
| [camp](https://github.com/Obedience-Corp/camp) | Projects, context, navigation, and the work queue across your camp. |
| [fest](https://github.com/Obedience-Corp/fest) | Goal-based plans, the next-step loop, progress, and review checkpoints. |
| `festival` | Installing and updating the suite, browsing CLI plugins, and checking your installation. |

Run `festival browse` to explore available CLI plugins. See [suite and plugin management](https://docs.fest.build/getting-started/festival-manager/) for installation, updates, and how CLI plugins differ from agent integrations.

## Useful between the big goals, too

- **Jump straight to the work.** `cgo p api` finds a matching project; `cgo f` takes you to festivals. Add the [shell integration](https://docs.fest.build/getting-started/shell-setup/) to enable these shortcuts.
- **Switch camps.** `camp switch` moves between registered camps. `csw` is the shorthand.
- **Find the next thing to pick up.** `camp workitem` brings intents, research, designs, and festivals into one work queue.
- **Start fresh after a merged PR.** `camp fresh` syncs a project to its default branch and prunes merged branches. Preview with `camp fresh --dry-run` from that project first, including any configured branch creation or follow-up commands.

[Everyday development with cgo and camp fresh](https://docs.fest.build/guides/everyday-development/)

## Explore the tools

The GIFs play on this page at a readable size.

<details>
<summary>Create specialized camps and switch between them</summary>

Once you have a camp for your first goal, you can add others for your job, side projects, or hobbies. Give each its own skills, workflows, and processes so your agents work the way you want in that context.

```bash
camp create work
csw work
csw my-camp
```

`csw` is the shorthand for `camp switch`. It requires the [shell integration](https://docs.fest.build/getting-started/shell-setup/). With no name, it opens the camp picker.

<p align="center">
  <img src="docs/images/demos/tui-camp-create.gif" alt="One session creates two camps, answering the description and mission prompts, then csw switches the shell from my-camp to work." width="700">
</p>

This recording shows both camps being created in a fresh demo home, then switching between them. By default, the camps are at `~/campaigns/my-camp` and `~/campaigns/work`.

</details>

<details open>
<summary>Move between projects, plans, and camps</summary>

`cgo` jumps to a project or planning directory. `camp switch` moves between camps, and `csw` is the shorthand.

<p align="center">
  <img src="docs/images/demos/cgo-navigation.gif" alt="cgo jumps between projects, festivals, and design directories, then csw, the shorthand for camp switch, changes camps." width="700">
</p>

</details>

<details open>
<summary>See your camps and the projects inside one</summary>

`camp list` browses registered camps by org. Move through them, change a camp's status, and filter down to the active ones.

<p align="center">
  <img src="docs/images/demos/tui-camp-list.gif" alt="camp list groups camps by org, marks one inactive, then filters to active camps." width="700">
</p>

`camp project list` browses the projects in the current camp, grouped by type.

<p align="center">
  <img src="docs/images/demos/tui-project-list.gif" alt="camp project list shows projects grouped by type, with search and a jump into the selected project." width="700">
</p>

</details>

<details open>
<summary>Find work, capture an idea, and sort the inbox</summary>

**Find work across the camp.** `camp workitem` brings intents, research, designs, and festivals into one searchable list.

<p align="center">
  <img src="docs/images/demos/tui-workitems.gif" alt="The camp workitem dashboard shows work across the camp, with search and a preview pane." width="700">
</p>

**Capture an idea.** `camp intent add` saves it to the inbox for later.

<p align="center">
  <img src="docs/images/demos/tui-intent-add.gif" alt="The camp intent add form captures an idea and saves it to the inbox." width="700">
</p>

**Sort the inbox.** `camp intent explore` lets you browse intents by status and read their details.

<p align="center">
  <img src="docs/images/demos/tui-intent-explore.gif" alt="The camp intent explore interface groups intents by status with fuzzy search and a live preview." width="700">
</p>

</details>

<details open>
<summary>See which festivals are active and inspect a plan</summary>

`fest list` groups festivals by status, so you can see what's active, ready, or still being planned.

<p align="center">
  <img src="docs/images/demos/tui-fest-list.gif" alt="fest list groups festivals into active, ready, and planning states." width="700">
</p>

`fest show` opens the structure of a plan, from its phases down to individual tasks.

<p align="center">
  <img src="docs/images/demos/tui-fest-show.gif" alt="fest show displays a festival's phase, sequence, and task tree and switches between plans." width="700">
</p>

</details>

<details open>
<summary>Start fresh after a merged change</summary>

`camp fresh configure` sets the follow-up commands that run after a project syncs.

<p align="center">
  <img src="docs/images/demos/tui-fresh-configure.gif" alt="camp fresh configure adds a follow-up command for one project, including what happens if that command fails." width="700">
</p>

`camp fresh` checks out the default branch, pulls, prunes merged branches, and runs those follow-ups.

<p align="center">
  <img src="docs/images/demos/tui-fresh.gif" alt="camp fresh syncs main, deletes merged branches, runs a follow-up, and reports a work item it left in place." width="700">
</p>

</details>

<details open>
<summary>Add testing and review gates to a plan</summary>

`fest gates apply` previews the quality gates it will add before applying them with approval.

<p align="center">
  <img src="docs/images/demos/tui-fest-gates-apply.gif" alt="fest gates apply previews quality gates for the plan's sequences, then applies them with approval." width="700">
</p>

</details>

<details open>
<summary>Review old work and clear space for what's next</summary>

`camp dungeon crawl` walks through stale work so you can choose what to keep or archive.

<p align="center">
  <img src="docs/images/demos/tui-dungeon-crawl.gif" alt="camp dungeon crawl offers keep, archive, and skip choices for stale work, then records the result." width="700">
</p>

</details>

<details open>
<summary>Reach a camp on another machine</summary>

`camp machine` lists computers camp can hop to, and can add one from your Tailscale network.

<p align="center">
  <img src="docs/images/demos/tui-machine.gif" alt="camp machine explains hops, then picks a computer from the Tailscale network to add." width="700">
</p>

</details>

<details open>
<summary>Open the Festival installer</summary>

`festival` opens the suite manager: install the tools, check the setup, and launch camp and fest.

<p align="center">
  <img src="docs/images/demos/tui-festival.gif" alt="The festival installer home, with setup steps and menus for install, doctor, and the camp and fest launchpad." width="700">
</p>

</details>

<details>
<summary>Watch a longer Festival session <strong>(click to expand video preview)</strong></summary>

An earlier Festival workflow recording at 16× playback speed. Use the setup instructions above for the current first-run path.

<p align="center">
  <a href="https://youtu.be/FY6vm74oa8o"><img src="docs/images/demo_video_thumb.jpg" alt="Watch a longer Festival workflow session on YouTube." width="700"></a>
</p>

</details>

[More video walkthroughs and demos](https://docs.fest.build/videos/)

## Fits the tools you already use

**Can I keep my issue tracker?**

Yes. Keep issues where your team coordinates, and use Festival for the agent's plan and work record. Intents and other work items live in files, so scripts or justfiles can connect them to an external service's API. Ask your agent to help build the connection you need. [See the workflow](https://docs.fest.build/compare/festival-vs-issue-trackers/).

**Can I change agents partway through?**

Yes. The next agent can read the same saved plan, decisions, and progress. Give it the festival location and access to the linked project. [Agent handoff guide](https://docs.fest.build/use-cases/ai-agent-handoff/).

**Do I need a Festival account?**

The CLI tools are free to use and run locally without a Festival account. Your agent's account, model costs, and permissions remain with the provider you choose.

## Keep going

- [Join the Obedience Corp Discord](https://discord.gg/Rt7dDY6VqD): get help with Festival, compare workflows, and share what you build.
- [Documentation](https://docs.fest.build/): guides, use cases, and CLI reference.
- [First festival tutorial](https://docs.fest.build/tutorials/first-festival/): a hands-on walkthrough of the plan structure.
- [Examples](examples/) and [templates](templates/): work you can inspect and adapt.
- [Plugin authoring](https://docs.fest.build/guides/plugin-authoring/): extend `camp` and `fest` with your own commands.
- [Report a bug or request a feature](https://github.com/Obedience-Corp/festival/issues): tell us what happened or what would help.
- [Give feedback](https://fest.build/feedback/) or [read the blog](https://fest.build/blog/).

**Festival App is in development.** The CLI tools are available now. [See what's coming](https://fest.build/#app).

If Festival is useful to you, **star this repository** to help other developers discover it. A bug report, a workflow you share, or an example of work you've handed off helps us improve it.

[Apache License 2.0](LICENSE) · Built by [Obedience Corp](https://obediencecorp.com/).

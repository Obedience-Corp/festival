---
title: "Campaign Setup"
weight: 42
---

# Campaign Setup

Set up a campaign workspace from scratch. You will create the workspace, add shell integration, bring in your projects as submodules, navigate efficiently with shortcuts, and connect festival planning to your codebase.

---

## Create a Campaign

Start by initializing a new campaign workspace:

```bash
camp init my-startup
cd my-startup
```

This creates the following directory structure:

```
my-startup/
├── projects/          # Git submodules for all your codebases
├── festivals/         # Festival Methodology workspace
├── docs/              # Human-authored documentation
├── ai_docs/           # AI research and documentation
├── workflow/           # Workflow management (reviews, pipelines, design)
├── dungeon/           # Archived and deprioritized work
├── justfile           # Command runner recipes
└── CLAUDE.md          # Agent memory document
```

## Shell Integration

Add camp and fest shell functions to your shell config:

```bash
# Add to ~/.zshrc
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"
```

Reload your shell:

```bash
source ~/.zshrc
```

This gives you two navigation commands:

- **`cgo`** - campaign navigation (directories, projects, categories)
- **`fgo`** - festival navigation (jump to festivals, toggle between planning and code)

## Navigate Your Campaign

Use `cgo` with category shortcuts to move around your workspace instantly:

```bash
cgo              # Campaign root
cgo p            # projects/
cgo f            # festivals/
cgo d            # docs/
cgo a            # ai_docs/
cgo w            # workflow/
cgo wt           # worktrees/
```

No more typing long paths. Every important directory is one shortcut away.

## Add Projects

Bring your codebases into the campaign as git submodules:

```bash
camp project add https://github.com/you/api-service
camp project add https://github.com/you/web-app
camp project list  # See all projects
```

Projects live under `projects/` as git submodules. They retain their own git history, branches, and remotes while staying tracked by the campaign.

Navigate to any project with fuzzy matching:

```bash
cgo p api        # Jump to projects/api-service
```

## Navigate Between Projects

Switch between projects and the campaign root without thinking about paths:

```bash
cgo p api        # Jump to projects/api-service
cgo p web        # Jump to projects/web-app
cgo              # Back to campaign root
```

Fuzzy matching means you only need to type enough characters to uniquely identify the project.

## Create Your First Festival

A festival is a goal-oriented project plan with phases, sequences, and tasks:

```bash
fest create festival --name "my-first-feature" --type standard
```

Navigate to it with either command:

```bash
fgo my-first-feature   # Jump directly to the festival
cgo f                  # Jump to the festivals directory
```

Fill the generated `REPLACE` markers, then run `fest validate` before your first `fest next`.

## Link Festival to Project

Connect your festival to the project it plans work for:

```bash
fest link
```

Now `fgo` toggles between the festival directory and the linked project directory. Jump back and forth between planning and code without losing context.

## Planning Tools

Camp provides lightweight planning tools to capture and prioritize work:

```bash
camp intent          # Capture ideas and goals
camp leverage        # Score projects by impact
camp dungeon         # Archive deprioritized work
```

Use these to decide what deserves a festival and what belongs in the dungeon.
If you are unsure whether to start with an intent, a design doc in `workflow/design/`, or a festival, use [Intent vs Design vs Festival]({{< ref "/docs/guides/intent-design-festival" >}}) as the canonical decision guide.

## Health Check

Keep your campaign in good shape:

```bash
camp doctor          # Diagnose campaign issues
camp sync            # Sync all submodules
```

Run `camp doctor` periodically to catch stale submodules, broken links, or structural problems before they slow you down.

## Register Globally

If you work across multiple campaigns, register them for quick switching:

```bash
camp register        # Add current campaign to global registry
camp list            # See all registered campaigns
camp switch          # Switch between campaigns
```

This lets you manage several campaign workspaces from anywhere in your terminal.

## What You Built

You now have a fully structured campaign workspace with:

- **Projects** tracked as git submodules under `projects/`
- **Festival planning** initialized and ready for structured execution
- **Shell navigation** via `cgo` and `fgo` for instant movement
- **Global registration** for multi-campaign workflows

## Next Steps

- [Your First Festival]({{< ref "/docs/tutorials/first-festival" >}}) - create phases, sequences, and tasks
- [Methodology Overview]({{< ref "/docs/methodology/overview" >}}) - understand the festival lifecycle
- [Agent Workflows]({{< ref "/docs/guides/agent-workflows" >}}) - run autonomous agent sessions with festivals

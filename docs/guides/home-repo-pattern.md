---
title: "The Home Repo Pattern with Camp"
linkTitle: "Home Repo Pattern"
description: "Set up a Home Repo for coding agents with camp: one repo for skills, AGENTS.md and shared docs, with every other repo one directory away."
weight: 28
---

# The Home Repo Pattern with Camp

The **Home Repo** is a way to run coding agents across many repositories. Matt
Pocock named and described it in
[The Home Repo Pattern](https://www.aihero.dev/the-home-repo-pattern) and in a
[video walkthrough](https://youtu.be/hWe-j78vNpc). Read his article for the
reasoning behind it. This guide shows how to set one up with camp.

In short: one repository holds your skills, your `AGENTS.md`, and the docs every
session should see. You always start your agent there. From there the agent can
reach every other repo you work in. You never copy the same skills into 30 repos,
and nothing important lives only in `~/.claude`, where your team can't see it and
it goes stale.

A camp is a Home Repo. `camp init` creates the repo, `camp project add` connects
your other repos, and `camp clone` sets the whole thing up on a new machine.

## How the pattern maps to camp

| Home Repo | In a camp |
| --- | --- |
| One repo the agent always starts in | The camp root, a normal git repo |
| `AGENTS.md` / `CLAUDE.md` loaded every session | Created by `camp init`. `CLAUDE.md` is a symlink to `AGENTS.md` |
| Skills shared across every repo | `.campaign/skills/`, projected into `.claude/skills/` and `.agents/skills/` |
| Pointers to your other repos | `projects/<name>`, one entry per repo |
| Clone the repos on a new machine | `camp clone <home-repo-url>` |
| Worktrees so several agents can work in one repo | `camp project worktree add`, under `projects/worktrees/` |
| Shared docs and a small wiki | `docs/` and `workflow/` |

## Set one up

[Install Festival]({{< ref "/getting-started/installation" >}}) to get `camp` and
`fest`. Then create the Home Repo. In a terminal, `camp init` asks for a short
description and mission:

```bash
camp init acme-home
cd acme-home
```

The new repo already has `AGENTS.md`, a `CLAUDE.md` symlink to it, a
`projects/` directory and a first commit.

### Connect your other repos

Add each repo you work in. Camp records it as a git submodule under
`projects/`:

```bash
camp project add git@github.com:acme/storefront.git
camp project add git@github.com:acme/payments-api.git
camp project list
```

Each repo keeps its own history, remote, issues and `AGENTS.md`. The Home Repo
only records where to find it.

### Write the pointers

An agent that starts in the camp root can see every repo by listing
`projects/`. What it can't see is when to use each one. Add a line per repo
under `## Projects` in `AGENTS.md`, in the same style as the article:

```markdown
## Projects

- Storefront: `projects/storefront`. Customer-facing web app. Read its AGENTS.md before changing it.
- Payments API: `projects/payments-api`. Billing and refunds. Read its AGENTS.md before changing it.
```

Once you have dozens of repos, group these lines by area (front end, back end,
internal tools) so the agent reads one short list at a time.

### Share your skills

Put the skills every session should have in `.campaign/skills/`, one directory
per skill with a `SKILL.md`. Then project them into the directories each harness
reads:

```bash
camp skills link --tool claude   # .claude/skills/
camp skills link --tool agents   # .agents/skills/
camp skills status
```

The projections are symlinks, so there is still only one copy of each skill,
versioned with the Home Repo. Camp also ships skills that teach agents its own
commands, and those show up in the same place.

### Run your agent from home

```bash
cd acme-home
claude        # or codex, cursor-agent, gemini
```

The agent loads `AGENTS.md` and your skills, then works in whichever repo the
task needs: `projects/storefront` for the checkout bug,
`projects/payments-api` for the refund endpoint, both in one session if the
change crosses them.

## Run several agents at once

When two agents need the same repo, give each one a worktree:

```bash
camp project worktree add refund-fix --project payments-api
camp project worktree add currency-bug --project payments-api
camp project worktree list --project payments-api
```

Worktrees live under `projects/worktrees/<project>/<name>/`, and camp copies the
skill links into each new one, so a session started inside a worktree still has
your skills. If you add a skill later, run `camp skills link --worktrees` to
link it into worktrees that already exist. Remove a worktree when its branch
merges:

```bash
camp project worktree remove refund-fix --project payments-api
```

## Set up a new machine or teammate

Push the Home Repo like any other repo. On a new machine, one command clones it
and every repo it points to:

```bash
camp clone git@github.com:acme/acme-home.git
```

`camp clone` initializes the submodules, checks that each one matches what the
Home Repo recorded, and registers the camp so `cgo` can find it.

## Submodules or plain pointers?

The article says submodules are fine for 5 to 10 repos, but that plain path
pointers do the same job without them. Camp supports both:

- **`camp project add`** records a submodule. This is what lets
  `camp clone` rebuild everything on a new machine with one command. Use it
  for repos you want every machine and teammate to have.
- **`camp project link <path>`** points at a checkout that is already on
  your machine, without a submodule. The link is a local shortcut and doesn't
  record a remote, so a fresh clone of the Home Repo won't fetch it. Use it
  for repos that live somewhere else on this machine only.

One difference from the article: the article has the agent clone a repo the
first time its path turns out to be missing. Camp does that setup up front, in
`camp clone`, instead.

## One home or several

The article describes a single Home Repo, which a whole team can share. Camp
is built for one camp per mission: your job, a side project, the open-source
library you maintain. Each camp is a Home Repo with its own repos, skills and
docs, and `camp list` shows them all. If one home fits how you work, make one
camp and add everything to it.

## What a camp adds

Everything above is the Home Repo pattern. A camp also gives you:

- **Navigation.** `cgo p api` jumps to a project by fuzzy match. See
  [Everyday Development]({{< ref "/guides/everyday-development" >}}).
- **A place for work in progress.** Capture ideas with `camp intent add`,
  research in `workflow/explore/`, and decisions in `workflow/design/`. See
  [Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}}).
- **Plans that span repos and sessions.** A festival breaks a change into
  phases and tasks that the next session can pick up. See
  [One Change Across Sessions]({{< ref "/guides/one-change-across-sessions" >}}).

## Related

- [Festival Camp Workspaces]({{< ref "/methodology/campaigns" >}}): the
  directory layout in full
- [Camp Setup]({{< ref "/tutorials/campaign-setup" >}}): a longer walkthrough
  of shell integration and navigation

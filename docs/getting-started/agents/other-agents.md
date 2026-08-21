---
title: "Other agents"
weight: 21
---

# Other agents

Festival is two CLIs and a directory of files: `fest` and `camp`, installed and kept current by a third tool, `festival`. Any agent that can run shell commands and read files can drive it, and the agents on this page do exactly that with no plugin and no adapter.

This page is the path for all of them, followed by what is specifically known about a few by name.

## The universal path

**1. Install `fest`, `camp`, and `festival`.** Pick one:

```bash
# Homebrew
brew install --cask Obedience-Corp/tap/festival

# npm, pnpm, or bun
npm install -g @obedience-corp/festival

# Shell script
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

Then check all three answer:

```bash
fest --version
camp --version
festival --version
```

Full install options are on the [installation page](../installation/).

**2. Open a campaign.** In a new directory:

```bash
mkdir my-campaign && cd my-campaign
camp init
```

This writes the campaign layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` describing all of it.

**3. Point the agent at `AGENTS.md`.** Most agents read it by convention. If yours reads a differently named file, symlink it rather than maintaining two copies that drift:

```bash
ln -s AGENTS.md YOUR_AGENT.md
```

**4. Optionally install the skills.**

```bash
npx skills add Obedience-Corp/festival
```

That reaches the agents behind [skills.sh](https://skills.sh/Obedience-Corp/festival). Add `--list` to see the skill names first, or `--all` to take the whole set.

**5. Give the agent the loop.**

```text
fest intro
fest next
<do exactly the task fest next prints>
fest task completed
fest commit -m "<message>"
fest validate
fest next
```

`fest next` only works inside a festival directory, not at the campaign root. An agent that starts at the root will get `not inside a festival` and should navigate into `festivals/active/<festival>` before retrying.

Phase gates are checkpoints for a human. The agent submits a gate and stops. You run `fest workflow approve` when you have looked at what it did.

## Grok Build

Festival ships no Grok bundle, and there is nothing Grok-specific to install. The universal path above is the whole setup.

The one thing worth knowing is that camp may have already done the skills step for you. When camp creates a project worktree it projects the campaign's skill bundles into that worktree as `.agents/skills` and `.claude/skills`, and then links `.grok/skills` to `.agents/skills` so Grok discovers the same set. A Grok Build session started inside a camp worktree therefore sees the campaign skills with no install step. camp reports this in its own output when it creates the worktree:

```text
Skills: projected campaign skill bundles into worktree (.agents/.claude/.grok)
```

Note that this happens in worktrees. At a campaign root, `camp init` projects into `.agents/skills` and `.claude/skills`, and there is no `.grok` alias there.

Outside a camp worktree, use the universal path.

## Aider

Festival ships no Aider bundle. Aider edits files and runs commands, which is everything the loop needs.

Use the universal path, and put the loop where Aider will read it: in your prompt, or in a conventions file that Aider loads for the repository. There is no skills channel to install from.

## Crush

Festival ships no Crush bundle, and Crush has not been surveyed or exercised by this project. It is listed here because it is an agent that can run shell commands, which is all the loop requires.

Use the universal path.

## OpenClaw

Festival ships no OpenClaw bundle, and OpenClaw has not been surveyed or exercised by this project either.

Use the universal path.

## Custom tooling

If you are writing your own harness, the contract is small:

1. Run `fest next`. It prints a task document.
2. Read that document and do exactly what it says.
3. Run `fest task completed`, or `fest task blocked --reason "..."`.
4. Run `fest commit -m "<message>"`.
5. Repeat.

Most `fest` and `camp` commands accept `--json` where structured output is more useful than text, which is usually what you want when a program rather than a person is reading the result.

For the methodology itself, `fest understand` is the entry point. For the vocabulary the bundled agents get, the [skills tree](https://github.com/Obedience-Corp/festival/tree/main/skills) is the same set every harness receives, in plain `SKILL.md` files.

## What was verified

On 2026-08-19, on the machine this page was written on: `grok` 1.0.5 and `aider` 0.84.0 were present, and their help output was read. Grok Build's top-level help exposes a `plugin` subcommand with a full marketplace surface, but Festival publishes no Grok plugin for it to install, which is why this page tells Grok Build users to use the universal path.

`crush` was not installed, and neither Crush nor OpenClaw has a survey document in this repository. Nothing on their sections is a claim about their capabilities beyond running shell commands.

The camp worktree skills projection described under Grok Build was taken from camp's own source and its printed output, not observed in a live worktree. The `.grok/skills` link is implemented in camp's worktree projection, where it is created as a symlink to `.agents/skills`.

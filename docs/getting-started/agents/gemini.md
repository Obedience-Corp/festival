---
title: "Gemini CLI"
weight: 18
---

# Gemini CLI

Gemini CLI installs Festival as an extension straight from GitHub, in one command. The extension carries a context file that imports every Festival skill, and a session-start hook that installs the `fest` and `camp` CLIs.

The loop is unchanged: `fest next`, do the task, `fest task completed`, `fest commit`.

## 1. Install Festival

Pick one:

```bash
# Homebrew
brew install --cask Obedience-Corp/tap/festival

# npm, pnpm, or bun
npm install -g @obedience-corp/festival

# Shell script
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

Then check all three binaries answer:

```bash
fest --version
camp --version
festival --version
```

If either one is missing or resolves somewhere you did not expect, `festival doctor` reports the installer's view of your PATH, sources, and receipts. Full install options are on the [installation page](../installation/).

The extension's session-start hook installs these too, so this step is belt and braces. Doing it by hand means your first session works before the hook has run once.

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout, initializes git, creates the festivals tree, and writes an `AGENTS.md` at the root describing all of it.

## 3. Install the extension

```bash
gemini extensions install Obedience-Corp/festival
```

To pin a specific ref rather than tracking the default branch:

```bash
gemini extensions install Obedience-Corp/festival --ref=v0.2.16
```

And to update an installed extension later:

```bash
gemini extensions update festival
```

The install reads the extension manifest at the repository root, which is why the extension is the whole repository rather than a subdirectory. Other harnesses get a generated subdirectory bundle; Gemini gets the root.

## 4. What the extension ships

- **`gemini-extension.json`**, which names the extension `festival` at version 1.3.1 and points `contextFileName` at `GEMINI.md`.
- **`GEMINI.md`**, which describes Festival and `@`-imports each of the **12 skills** directly.
- **`hooks/hooks.json`** at the repository root, carrying the `SessionStart` hook described in section 6.

Skills reach Gemini as context imports rather than as a bundled skills directory. Festival's 11 slash commands and 2 agents are not shipped to Gemini; the same workflows run through the `fest` and `camp` CLIs, which is what those commands call anyway.

## 5. The one-level import rule

Gemini expands `@`-imports one level from the context file. It does not expand imports found inside an imported file. That is documented upstream and was closed as not planned rather than treated as a bug, so plan around it rather than waiting for it to change.

`GEMINI.md` imports each skill's `SKILL.md` directly, so every Festival skill lands one level down and loads correctly. You will not hit this limit with the bundled set, because every Festival skill is a single file.

It matters when you add your own. A skill you write that splits itself across a `SKILL.md` plus supporting files, and `@`-imports those from inside the `SKILL.md`, will load only the top file. The supporting content silently does not arrive. Keep a skill you want Gemini to read in one file.

This non-recursive behavior comes from the Gemini CLI documentation and the upstream issue it cites, as captured in the Festival plugin survey on 2026-06-16.

## 6. How the CLIs get installed

The `SessionStart` hook runs an idempotent install script. In Gemini CLI, `SessionStart` fires at startup, on resume, and on clear, and there is no first-install-only event, so the hook re-fires constantly. That is why the script leads with a fast "already installed and current" check and does nothing the vast majority of the time.

If the hook cannot run, install the binaries by hand:

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

## 7. AGENTS.md and GEMINI.md

Two files, two jobs, and they do not conflict.

`GEMINI.md` ships with the extension. It describes Festival to Gemini and imports the skills. You do not write or edit it; it is generated.

`AGENTS.md` sits at your camp root and describes your camp: what the projects are, what the conventions are, what you want an agent to do. `camp init` writes the first version and you grow it from there.

Keep both.

## 8. The loop

Give the agent the loop once and it repeats it:

```text
fest intro
fest next
<do exactly the task fest next prints>
fest task completed
fest commit -m "<message>"
fest validate
fest next
```

`fest next` only works inside a festival directory, not at the camp root. An agent that starts at the root will get `not inside a festival` and should navigate into `festivals/active/<festival>` before retrying.

Phase gates are checkpoints for a human. The agent submits a gate and stops. You run `fest workflow approve` when you have looked at what it did.

## What was verified

Gemini CLI is not installed on the machine this page was written on. The extension install, the hook running, and the context imports loading were not observed.

What was verified, on 2026-08-19, is structural. The manifest parses and its `contextFileName` resolves to `GEMINI.md`. All 12 `@`-imported paths in `GEMINI.md` exist, checked one by one. The hook command's script path resolves. `just plugin check` enforces the generated Gemini target and its referenced paths, and it passes.

Everything about how Gemini CLI behaves, including the extension install verbs, the `SessionStart` firing model, and the one-level import rule, comes from the Gemini CLI documentation as captured in the Festival plugin survey on 2026-06-16. That survey also flags that the extension hooks surface is actively evolving, so pin a tested Gemini CLI version if you depend on the hook rather than installing the binaries yourself.

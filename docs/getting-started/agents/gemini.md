---
title: "Gemini CLI"
weight: 18
---

# Gemini CLI

Gemini CLI installs Festival as an extension straight from GitHub, in one command. The extension carries a context file that imports every Festival skill, a session-start hook that installs the `fest` and `camp` CLIs, and a `BeforeTool` hook that stops a raw `git commit` inside a camp.

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
gemini extensions install https://github.com/Obedience-Corp/festival
```

This installs from the latest Festival release. To pin a specific release instead:

```bash
gemini extensions install https://github.com/Obedience-Corp/festival --ref=v0.3.19
```

And to update an installed extension later:

```bash
gemini extensions update festival
```

The install reads the extension manifest at the repository root, which is why the extension is the whole repository rather than a subdirectory. Other harnesses get a generated subdirectory bundle; Gemini gets the root.

The install asks you to acknowledge the risks of a third-party extension before it adds Festival; `gemini extensions install` and `gemini extensions link` both accept `--consent` to answer that prompt up front. In the check recorded at the end of this page, the extension's hooks then ran with no further prompt.

## 4. What the extension ships

- **`gemini-extension.json`**, which names the extension `festival` at version 1.3.1 and points `contextFileName` at `GEMINI.md`.
- **`GEMINI.md`**, which describes Festival and `@`-imports each of the **12 skills** directly.
- **`hooks/hooks.json`** at the repository root, carrying the `SessionStart` hook described in section 6 and the `BeforeTool` commit guard described in section 7.

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

## 7. The commit guard

Camps have their own commit verbs so that work stays traceable: `camp commit` at the camp root, `camp p commit` inside `projects/*`, and `fest commit` during a festival. The extension's `BeforeTool` hook, matched to `^run_shell_command$`, runs `hooks/scripts/gemini-commit-guard.sh` before every shell command. That adapter hands the call to `commit-guard.sh`, the same script the Claude Code plugin ships.

Gemini sends the command as `tool_input.command` and the session directory as `cwd`, which is what the guard reads. When the model sets `dir_path` on the call, the adapter checks that directory instead, so a commit aimed into a camp from outside one is caught too. The guard blocks only when both of these hold:

- the command has a raw `git commit` segment, including one after `;`, `&&`, or `||`, and
- `camp id` succeeds in the directory the command runs in, so it is inside a camp.

A block exits 2 with the reason on stderr. Gemini does not run the command and returns `Tool execution blocked:` followed by that reason to the model as the tool error, which names the right verb. This happens before Gemini's own approval step, so it holds in YOLO mode too.

Every other path exits 0 with no output. That matters on Gemini: it treats an exit code other than 0 and 1 that comes with text as a denial, so the adapter turns any failure inside the guard, and a missing `camp` or `jq`, into a silent exit 0 rather than a blocked command. The hook never prints a decision, so it never approves anything. To make one raw commit deliberately, set `CAMP_ALLOW_RAW_GIT=1`.

## 8. AGENTS.md and GEMINI.md

Two files, two jobs, and they do not conflict.

`GEMINI.md` ships with the extension. It describes Festival to Gemini and imports the skills. You do not write or edit it; it is generated.

`AGENTS.md` sits at your camp root and describes your camp: what the projects are, what the conventions are, what you want an agent to do. `camp init` writes the first version and you grow it from there.

Keep both.

## 9. The loop

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

On 2026-10-08, with Gemini CLI 0.63.0 run through `npx` in an isolated home directory, `gemini extensions validate` accepted the extension, and `gemini extensions install https://github.com/Obedience-Corp/festival` installed it from the v0.3.19 release and listed it as enabled. The hook running and the context imports loading were not observed in that run.

Later the same day, the commit guard was checked against a local checkout linked with `gemini extensions link --consent`, again in an isolated home directory, with the CLI's canned-response mode standing in for the model so no key or network call was involved. The scripted `run_shell_command` call `git commit --allow-empty -m test` in a scratch camp, under `--approval-mode=yolo`, came back as a `policy_violation` tool error reading `Tool execution blocked: raw git commit is forbidden inside a camp; ...`, and the scratch repository stayed at zero commits. The same call with `CAMP_ALLOW_RAW_GIT=1` committed. A session started outside the camp with `dir_path` pointing into it was blocked. The session-start hook ran in those sessions as well.

Earlier, Gemini CLI was not installed on the machine this page was written on, so the checks below were structural only.

What was verified, on 2026-08-19, is structural. The manifest parses and its `contextFileName` resolves to `GEMINI.md`. All 12 `@`-imported paths in `GEMINI.md` exist, checked one by one. The hook command's script path resolves. `just plugin check` enforces the generated Gemini target and its referenced paths, and it passes.

Everything about how Gemini CLI behaves, including the extension install verbs, the `SessionStart` firing model, and the one-level import rule, comes from the Gemini CLI documentation as captured in the Festival plugin survey on 2026-06-16. That survey also flags that the extension hooks surface is actively evolving, so pin a tested Gemini CLI version if you depend on the hook rather than installing the binaries yourself.

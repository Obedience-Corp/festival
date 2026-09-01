---
title: "Hermes Agent"
weight: 19
---

# Hermes Agent

Hermes Agent runs Festival with no adapter and no plugin. It finds `fest` and `camp` on your PATH, reads the camp's `AGENTS.md`, and drives the loop with its terminal tool. This page is the shortest path from a machine with Hermes on it to a festival executing.

Order matters. Install the binaries first: a Hermes skills tap teaches the agent the vocabulary, but it does not install the CLIs.

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

## 2. Open a camp

A camp is the directory Festival works in. Create one and stay at its root:

```bash
mkdir my-camp && cd my-camp
camp init
```

`camp init` writes the camp layout and an `AGENTS.md` describing it. That file is what tells Hermes where festivals live and which commands to use.

## 3. Add the skills tap

Festival publishes its 12 skills as a Hermes tap. Subscribe once, then install what you want:

```bash
hermes skills tap add Obedience-Corp/festival
hermes skills install Obedience-Corp/festival/skills/festival-intake --yes
hermes skills install Obedience-Corp/festival/skills/fest-planning --yes
hermes skills install Obedience-Corp/festival/skills/fest-execution --yes
hermes skills install Obedience-Corp/festival/skills/campaign-commit --yes
```

Add `--category festival` to any install line if you want them grouped in `hermes skills list`.

Install lines are spelled out here on purpose. A tap contributes nothing to `hermes skills browse` and nothing to `hermes skills search`, so you cannot discover these by browsing; you install them by name. The full list of names is in the tap's own [README](https://github.com/Obedience-Corp/festival/tree/main/skills), and the four above are enough to start.

Skills installed this way land in `~/.hermes/skills/` and need no trust step and no config edit. `hermes skills trust` is a different thing: it is for project-local skills that live inside a repo, such as a camp's own `.agents/skills` directory. Trust that only if you want a camp's local skills loaded, and only once per repository root.

Every skill in the tap carries a `SAFE` verdict from the install-time security scanner.

## 4. Keep AGENTS.md, and do not add .hermes.md

`AGENTS.md` at the camp root is the context file Festival writes and every agent reads. Hermes loads exactly one project-context type per session, and `.hermes.md` outranks `AGENTS.md`. Adding a `.hermes.md` therefore does not layer on top of your camp context, it replaces it, and your Hermes sessions stop seeing the camp instructions entirely.

Leave `AGENTS.md` as the only context file.

## 5. Start Hermes from the camp root

Hermes builds its context chain from the git root of your working directory. A camp root is a git repository, so starting there gives the agent the camp's `AGENTS.md`.

Projects inside a camp are usually their own git repositories. A session started inside `projects/<something>` has its own git root and does not inherit the camp's `AGENTS.md`. Start at the camp root and let the agent move around from there.

## 6. Drive it

Interactively:

```bash
cd my-camp
hermes chat
```

Or with a single instruction, from anywhere:

```bash
hermes --in /path/to/my-camp chat -q "Run fest next and do the task it gives you"
```

`--in` is a global option, so it goes before the `chat` subcommand. `hermes chat` honors both your working directory and `--in`. Do not use `hermes -z` for camp work: its terminal tool runs in your home directory and ignores both the working directory and `--in`, so a festival command issued that way runs in the wrong place.

## 7. The loop

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

Here is a real Hermes run of that loop, one instruction from the camp root, trimmed:

```text
Festival hermes-spike-HS0001 is blocked on an operator checkpoint. I did not run
`fest workflow approve`.

Progress: 6/6 sequence tasks done. Implementation phase gate is step 1 of 4
(PHASE GOAL), submitted, waiting on you.

Task 01_write_hello_file
  printf 'hello\n' > hello.txt && cat hello.txt
  fest task completed --yes
  fest commit -m "write hello.txt with hello"   Hash 4392571
...
Need from you
  fest workflow approve
```

That last part is the important one. Phase gates are checkpoints for a human. The agent submits the gate and stops; it does not approve its own work. You run `fest workflow approve` when you have looked at what it did.

## 8. Optional: block raw git commits

Camps have their own commit verbs (`camp commit`, `camp p commit`, `fest commit`) so that work stays traceable. If you want Hermes to be stopped rather than corrected when it reaches for `git commit`, wire the commit guard in as a shell hook. The script is the same one the Festival plugin ships for other agents; download it from the repo and make it executable:

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/claude-plugin/hooks/scripts/commit-guard.sh -o ~/.hermes/commit-guard.sh
chmod +x ~/.hermes/commit-guard.sh
```

It only enforces inside a camp (it checks the command's working directory with `camp`), so it is safe to leave on for unrelated work.

Add to your Hermes profile's `config.yaml`:

```yaml
hooks:
  pre_tool_call:
    - matcher: "terminal"
      command: "~/.hermes/commit-guard.sh"
      timeout: 15
      fail_closed: true
hooks_auto_accept: true
```

Then run Hermes once with `--accept-hooks`:

```bash
hermes chat --accept-hooks -q "..."
```

The config setting alone does not allowlist the hook; the first run has to accept it. After that, a raw `git commit` inside a camp exits with the guard's message and the commit never happens.

## 9. Sandboxed backends

If you switch Hermes's terminal backend to `docker`, the agent runs commands inside a container, and the default image (`nikolaik/python-nodejs:python3.11-nodejs20`) has neither `fest` nor `camp`. Every Festival command fails with `command not found`. Bake the binaries into your own image, or stay on the local backend for camp work.

## 10. Hermes Desktop

Desktop works the same way. Create a Project whose primary folder is the camp root, so the session starts where `AGENTS.md` and the festivals live, and use the same loop. The context and skill rules above apply unchanged.

---
title: "Festival vs YAGNI"
description: "How Festival differs from YAGNI, a hosted agent workspace that ships its own coding CLI."
weight: 40
---

# Festival vs YAGNI

[YAGNI](https://yagni.app) sells a hosted workspace for agent work, together with its own coding CLI (`@yagni-app/code`) that its homepage positions as a drop-in replacement for frontier coding agents.

Festival is not that. Festival is the planning and verification layer for long-running agent work. It sits beside the agent you already run and keeps the record in files you own.

Both products answer the same complaint: agent work loses the thread when a session ends. They answer it differently. YAGNI replaces the harness and routes the model. Festival keeps your harness and keeps the record on your disk.

## Short Version

Use YAGNI if you want one vendor to supply the coding agent, the shared memory, and the bill.

Use Festival if you already have an agent you like, and you want the plan, the context, and the proof to live in your own repository.

## Comparison

| Dimension | YAGNI | Festival |
|---|---|---|
| Where the work record lives | Hosted workspace on their infrastructure | Files in a campaign directory on your machine, versioned with git |
| Coding agent | Their CLI and desktop app | Whatever you already run: Claude Code, Codex, Cursor, Aider, OpenCode |
| Model access | Routed through their workspace; their product pages describe metered credits rather than your own API keys | Not in the loop. Festival never calls a model and never sees a token |
| Unit of continuity | Workspace memory and their published playbook and receipt surfaces | Phases, sequences, tasks, intents, and git history |
| Verification | Their review flow, ending in a receipt against a stated number | Task completion criteria, `fest validate`, quality gates at the end of an implementation sequence, and `fest commit` traceability |
| Cost of entry | Sign up, then a quote or a subscription | `npm install -g @obedience-corp/festival`. No account |
| Leaving | Export from the vendor | Copy the directory. It is already yours |

Statements about YAGNI describe their public site and npm package as of August 2026. Check their site for current details before making a decision.

## What This Is Not About

This is not an argument that hosted workspaces are wrong. If your team wants one throat to choke for agent memory, agent execution, and billing, a hosted product is a reasonable purchase.

The distinction worth understanding before you pick either one is ownership:

- With a hosted workspace, continuity is an account. It is portable to the degree the vendor supports export.
- With Festival, continuity is a directory. It is a campaign of Markdown, YAML, and git history that you can read, diff, branch, back up, or walk away with.

The same question applies to the model. Festival does not sit between you and a provider, so switching models, or running local ones, is a decision you make in your own harness.

## Try It

```bash
camp init my-workspace
cd my-workspace
fest create festival --name my-first-feature --type standard
fest next
```

Next: read [Festival vs Issue Trackers]({{< ref "/compare/festival-vs-issue-trackers" >}}) or start with the [Quick Start]({{< ref "/getting-started/quickstart" >}}).

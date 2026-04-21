---
title: "Festival vs GSD"
weight: 46
---

# Festival vs GSD

[GSD](https://github.com/gsd-build/get-shit-done) is a meta-prompting, context-engineering, and spec-driven workflow for Claude Code and other coding agents. It focuses on preventing context rot inside coding sessions.

Festival solves a different layer of the problem. It is a persistent multi-repo workspace and execution plan for long-running work. It stores repos, docs, research, plans, task state, completion criteria, and commits in local files.

## At a glance

| If you mostly need | Better fit |
|---|---|
| Better in-session agent behavior | GSD |
| Durable mission state across repos and days | Festival |
| Specs and prompts that reduce context rot | GSD |
| A local workspace that survives handoffs | Festival |

## Use GSD when

- you want a lighter-weight coding workflow layer
- your biggest pain is agent drift inside active sessions
- you want prompt and spec patterns more than workspace structure

## Use Festival when

- one mission spans multiple repos, docs, and sessions
- you need `fest next` to tell the next agent what to do
- you want commits tied back to the plan that caused them

## They can work together

GSD can improve how the agent behaves inside a session, while Festival provides the durable workspace and mission state that session operates inside.

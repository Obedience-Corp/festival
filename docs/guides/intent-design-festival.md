# Intent vs Design vs Festival

Use this guide when you're about to create planning work and you're not sure which artifact to start with.

The beginner default is simple:

- If the work is still fuzzy, start with an intent or a design doc.
- If the work needs structured planning and multi-step execution, create a standard festival.
- If a single agent can probably finish it from a short description, do not reach for a festival yet.

---

## Use an Intent for Fast Capture and Small Actionable Work

Use `camp intent add` when the main job is to capture something quickly or queue a small piece of work without losing it.

This is the right starting point when:

- You can describe the work in a few sentences
- The work might be directly actionable by one agent session
- You noticed it while doing something else and do not want to break flow
- You are not ready to fully plan it yet

Examples:

- "Fix the typo in the onboarding docs"
- "Add copy button to API key screen"
- "Investigate flaky login test"

```bash
camp intent add "Add copy button to API key screen"
camp intent list
```

If the intent grows into a larger change later, you can gather or promote it then. Starting with an intent is cheap.

---

## Use a Design Doc When the Work Needs Thinking Before Execution

Use `workflow/design/` when the main problem is not capture but clarification. You need to think through the solution before you should ask an agent to implement it.

This is the right starting point when:

- You need to compare approaches
- You need to define an API, architecture, or data model
- The work touches multiple systems but the shape is still unclear
- You want a durable technical reference even if no festival follows

Examples:

- "Should auth use JWT or session tokens?"
- "What should the plugin API look like?"
- "How should sync conflicts resolve between desktop and server?"

A good design doc captures the problem, constraints, options, and recommendation. Sometimes that is enough for direct execution. If the work later proves too large or too risky for a single session, use the design doc as input to a festival.

---

## Use a Festival for Structured, Multi-Step Execution

Use `fest create festival --name "..." --type standard` when the work needs explicit planning and execution structure.

This is the right starting point when:

- The work will span multiple agent sessions
- You need INGEST and PLAN phases to turn rough input into executable tasks
- You want sequence/task tracking, quality gates, and resumable handoff through `fest next`
- The change touches multiple subsystems or has enough risk that process matters

Examples:

- "Ship first-run onboarding polish across camp, fest, and festival"
- "Refactor auth across API, UI, and docs with staged rollout"
- "Plan and execute a release process with explicit verification steps"

```bash
fest create festival --name "first-run-onboarding-polish" --type standard
```

For beginners, `standard` is the default choice when requirements are still rough. Use an `implementation` festival only when the requirements and design already exist.

---

## Quick Decision Table

| If this is your situation | Start with |
|---|---|
| "I just need to capture this so I don't lose it." | Intent |
| "I know the problem, but I need to think through the solution." | Design doc |
| "I need a tracked execution plan with multiple steps and handoffs." | Festival |

---

## These Artifacts Are Meant to Escalate

They are not competing systems.

- Start with an **intent** when the work is small or still forming.
- Move to a **design doc** when the work needs architectural thinking.
- Move to a **festival** when the work needs structured execution.

That means a normal path can look like this:

`intent -> design doc -> standard festival`

But not every piece of work needs every layer. If an intent is already actionable, execute it. If a design doc is enough, stop there. Reach for a festival when structure is what the work actually needs.

---
title: "One Change Across Sessions"
description: "Follow a dependency migration from a scoped goal through plan review, a failed check, a fresh session, and a reviewable result."
weight: 29
---

# One Change Across Sessions

Start with one piece of work you already need to finish. This walkthrough uses an
**illustrative dependency migration** across an API and a web app. It shows what
to ask your agent, what stays in files, and when you review.

For a completed build with public plans and verification records, inspect the
[practice simulator's three festivals](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals).

## Choose the amount of structure

A typo fix or a small, understood change can stay in a single agent session.
Capture it as an intent if you need to queue it. A known, repeatable checklist can
use a standalone workflow. This migration merits a festival because it crosses
two projects, needs compatibility checks, and may span sessions.

[Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}})
covers the choice. Standalone workflows are linear; use a festival phase workflow
when you need a blocking approval checkpoint inside the loop.

## 1. Keep the context beside the code

Follow the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to create a
camp and link your existing repositories. Each repository keeps its own Git
history. The camp holds the work around them:

```text
my-camp/                         # Camp Git repository
├── AGENTS.md                    # How to work in this camp
├── docs/                        # Decisions and reusable knowledge
├── workflow/design/             # Designs for work you intend to build
├── festivals/                   # Plans, task state, and review evidence
└── projects/
    ├── api -> /your/code/api    # Existing repository, separate Git history
    └── web -> /your/code/web    # Existing repository, separate Git history
```

Camp adds a `.camp` attachment file when it links a project. Your personal scripts,
workflow templates, and planning can live in the camp. Shared project requirements
and architecture still belong with the project so collaborators can use them.
See [how agents find context]({{< ref "/methodology/campaigns#how-agents-find-context" >}}).

## 2. Describe an outcome you can check

Open your existing agent at the camp root. Replace the brackets:

{{< agent-prompt >}}
Read the camp and project instructions. In projects/api and projects/web,
upgrade [dependency] from [current version] to [target version].

Keep the existing API behavior and web user journeys working. Do not add
features or deploy anything. Check the dependency's migration guidance and
the projects' existing tests before proposing changes.

Use fest to plan a standard festival for the migration. Include compatibility
checks for both projects and a review of the resulting diffs. Show me the plan,
its location, and any unresolved decisions before starting implementation.
{{< /agent-prompt >}}

Review the scope and checks. If the plan introduces unrelated refactoring or
cannot explain how compatibility will be checked, ask for a revision before
approving it. Use a separate project worktree for changes that need isolation;
the [everyday development guide]({{< ref "/guides/everyday-development" >}})
explains the commands.

## 3. Execute and keep failures visible

Once the plan is approved, ask the agent to run the `fest next` loop from the
festival or its linked working directory. `fest next` reads the recorded state
and returns the next step. The agent performs the work and runs the checks; the
command itself does not implement or validate the migration.

If a compatibility check fails, the work remains unfinished. Have the agent
record the failure, investigate it, make a scoped fix, and rerun the relevant
checks. If the fix requires changing approved behavior, bring that decision back
to you. A passing test alone does not authorize a new scope.

For example, the review record might contain:

| Record | Illustrative entry |
| --- | --- |
| Goal | Upgrade the dependency while preserving API and web behavior |
| Finding | An API error response changed; the web client no longer shows the expected message |
| Correction | Preserve the response contract and cover the affected client path |
| Verification | Record the exact checks run and their results after the correction |
| Remaining decision | Ask for approval if preserving the contract requires a different migration approach |

The real record must contain the actual findings and results. Review gates help
you inspect evidence; their usefulness depends on the checks and decisions you
put into them. [Workflows & Gates]({{< ref "/methodology/workflows-and-gates" >}})
explains the approval mechanism.

## 4. Continue in a fresh session

Before stopping, ask the agent to save the current step, decisions, failed or
passing checks, unfinished changes, and the next action in the festival's work
record. Commit appropriate changes using the camp or festival commit commands.

Open another session in the same camp, using the same agent or a different one:

{{< agent-prompt >}}
Resume the festival at [saved festival path]. Read the camp instructions,
relevant project instructions, plan, and latest work record. Inspect the working
trees and run fest status and fest next from the festival directory.

Tell me what remains, which checks have passed or failed, and whether the files
match the recorded state. Continue the approved migration. Preserve unfinished
work and stop for decisions outside the approved scope.
{{< /agent-prompt >}}

The new session has files to inspect, including your way of working and the
migration's state. It does not inherit the previous chat automatically. If a
note conflicts with the code or a check, resolve that mismatch before continuing.
See [AI Agent Handoff]({{< ref "/use-cases/ai-agent-handoff" >}}).

## 5. Review the result and reuse what worked

Ask for the resulting diffs, the behavior checked, verification results, and any
remaining decisions. Verify the outcome against the original goal before
accepting it. A completed task label is a pointer to the evidence, not a substitute
for reviewing it.

If the migration revealed a useful check, add it to the relevant project or
workflow template. On the next migration, have the agent read that check before
planning. You choose and review these process changes; Festival does not
promise automatic self-improvement.

Once work is finished, use the appropriate lifecycle commands to move it out of
the active queue while keeping its record. In an explore or design collection,
`camp dungeon crawl` walks you through keep/archive decisions. It asks you what
to do with each item. Read about [work items]({{< ref "/methodology/work-items" >}})
and [camp cleanup]({{< ref "/methodology/campaigns#planning-tools" >}}).

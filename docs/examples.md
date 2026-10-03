---
title: "Examples"
weight: 15
---

# Examples

Real example camps and festivals you can clone, read, and run. Browse them all
in the [examples repo](https://github.com/Obedience-Corp/examples); the project
repos live in the [Festival-Examples](https://github.com/Festival-Examples)
organization.

## Camps

A camp is a workspace that holds the projects, plans, and context for a mission.

### Example Camp

**Repository:** <https://github.com/Festival-Examples/example-campaign>

A public example workspace for learning the `camp` and `fest` CLIs. It preserves the
full planning, execution, review, and ritual structure around its example projects,
including a fully worked Go todo CLI as the golden path.

## A working application built with Festival

### CodeSignal Practice Simulator

**Repository:** <https://github.com/Festival-Examples/codesignal-practice-simulator>

<img src="https://raw.githubusercontent.com/Festival-Examples/codesignal-practice-simulator/main/docs/assets/practice-simulator.png" alt="The practice simulator's browser IDE with its prompt, code editor, timer, and test controls" width="800">

A local coding practice app with timed four-level assessments, a browser IDE,
and a CLI that share one attempt lifecycle. Two original exercises work offline;
a third assessment is fetched separately. Saved attempts can be reviewed and
retried without losing earlier work.

The outcome is an app you can run. The same repository also contains the
completed festivals that explain how the agents built and verified it.

| Festival | Delivered outcome | Build records |
| --- | --- | --- |
| CP0001 | Python CLI, timed attempts, and scoring | [Plan, tasks, and results](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals/codesignal-practice-simulator-CP0001) |
| CB0001 | Local browser IDE on the shared Python engine | [Plan, tasks, and results](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals/codesignal-browser-assessment-simulator-CB0001) |
| CP0002 | Original exercises, fresh attempts, restart, history, and submission review | [Plan, tasks, and results](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals/codesignal-practice-library-CP0002) |

**How it was built:** agents worked through the `fest next` loop, recording task
completion, testing, reviews, fixes, and traceable commits. The browser build
used six phases covering intake, planning, backend, IDE, browser verification,
and release review. Its evidence includes unit and HTTP tests, browser journeys,
offline checks, and installed-package verification.

<img src="https://raw.githubusercontent.com/Festival-Examples/codesignal-practice-simulator/main/festivals/codesignal-browser-assessment-simulator-CB0001/codesignal-browser-assessment-simulator-CB0001.gif" alt="Recorded CB0001 progress across the six phases of the browser IDE build" width="480">

The animation replays recorded build progress. [Watch all three festival replays](https://github.com/Festival-Examples/codesignal-practice-simulator#how-this-was-built)
and [run the simulator locally](https://github.com/Festival-Examples/codesignal-practice-simulator#quick-start).

To follow the work yourself, open a festival's `FESTIVAL_OVERVIEW.md`, read its
planning decisions, follow a task into its results, and inspect the review and
verification evidence. The [archive index](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals)
explains how the records were sanitized for public sharing.

## More festivals

A festival is a structured plan and work record for a goal. These additional
examples show other kinds of work you can inspect.

### Camp Hardening Festival (CH0001)

**Repository:** <https://github.com/Festival-Examples/example-camp-hardening-festival>

<img src="/images/fest-show.gif" alt="Animated fest watch tree for the camp-hardening CH0001 festival" width="480">

A complete, worked example festival that hardens the `camp` CLI with safer
destructive commands, more consistent JSON output contracts, and stronger git-backed
workflows. Planned and executed end to end as 4 phases, 12 sequences, and 145 tasks,
then promoted to `dungeon/completed`.

**How it was built:** roughly four days of real work across three different agents,
drafted in Fathom, built with Grok, and finished in Codex. The festival plan carried
context and progress across all three, so each agent resumed where the last left off,
a real demonstration of the agent-agnostic, resumable execution Festival is built for.

More examples are added over time in the
[Festival-Examples](https://github.com/Festival-Examples) organization.

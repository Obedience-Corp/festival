---
title: "Recurring Research and Analysis"
linkTitle: "Research and Analysis"
description: "Make recurring research reproducible with dated sources, scripts, review checkpoints, and a durable record of conclusions."
weight: 41
---

# Recurring Research and Analysis

Research becomes expensive when every run starts with a blank document. A useful analysis leaves behind the sources, extraction steps, scripts, assumptions, and limits that let someone else inspect the conclusion later.

## A repeatable research desk

Use a research festival for an investigation that needs framing, source collection, analysis, and synthesis. Use a standalone `WORKFLOW.md` when the process is known, fixed, and linear, such as a weekly source review or a release-readiness sweep. Each tracked run can keep its own progress history. The process still needs a person or an external scheduler to start it.

Give the agent a question, a cutoff date, a source policy, and an output format. Ask it to save source URLs or file paths with access dates, preserve raw inputs where permitted, and keep analysis scripts next to the result. A strong deliverable includes:

- the question and decision it informs
- a dated source list with citations
- a reproducible script or command sequence
- tables or findings with assumptions shown
- limitations, negative findings, and the next decision

{{< agent-prompt >}}
In [camp or project path], answer [research question] for the decision [decision to inform]. Use sources dated through [cutoff date] and save the source list, citations, scripts, and generated outputs in [approved paths].

Do not invent missing values. Record conflicting evidence, sampling limits, and any step that could not be reproduced. Produce a concise findings memo and a review checklist. Stop before publishing the memo or changing the decision record.
{{< /agent-prompt >}}

## Review the method, not only the result

The reviewer checks whether the sources answer the stated question, whether the script actually produced the tables, whether dates and versions are recorded, and whether the conclusion outruns the evidence. A failed or inconclusive run is still useful when the reason is captured. The [Agent Workflows]({{< ref "/guides/agent-workflows" >}}) guide explains the file-based handoff, while [Loops & Orchestration]({{< ref "/guides/loops-and-orchestration" >}}) covers choosing a workflow, festival, or work-item queue.

## External tools and permission boundaries

Browsers, databases, APIs, credentials, rate limits, data licensing, and scheduled execution belong to the tools and operators that provide them. Festival does not fetch data on a timer, guarantee deterministic outputs, or grant access to private systems. The agent can run approved scripts against supplied or explicitly authorized inputs. A human approves source use, sensitive-data handling, interpretation, and publication. Keep personal and confidential data to the minimum needed for the question.

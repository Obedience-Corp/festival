---
title: "Incident Investigation with Festival"
linkTitle: "Incident Investigation"
description: "Turn an incident record into a reviewed timeline, evidence-backed findings, and a postmortem with owned follow-up work."
weight: 40
---

# Incident Investigation with Festival

An incident investigation often begins with fragments: an alert summary, a few log exports, a support report, and several people remembering the same hour differently. The useful outcome is a reviewable record of what happened, what the evidence supports, what remains uncertain, and which follow-up work is approved.

## From fragments to a postmortem

Create a research festival when the investigation needs several passes. Put the incident brief, approved exports, relevant code or configuration, and the review criteria in the camp. The agent can then:

1. build a dated timeline and identify gaps
2. separate observations from hypotheses
3. run a reproduction or a safe fixture test when one is available
4. compare mitigation and remediation options
5. draft a postmortem and turn accepted actions into follow-up work

The camp gives the investigation a durable home. A new session can pick up the next documented step instead of reconstructing the case from chat.

{{< agent-prompt >}}
In [project or camp path], investigate [incident or failure] using only the approved evidence in [paths or exports].

Produce a dated timeline, evidence table, competing cause hypotheses, reproduction or validation steps, and a postmortem draft. Mark every inference and unresolved question. Propose follow-up tasks with owners and verification criteria, but do not change production systems or contact anyone.

Stop for human review before publishing the postmortem, accepting a root-cause claim, or creating work outside the approved scope.
{{< /agent-prompt >}}

## What the reviewer checks

Review the timeline against source timestamps, the difference between cause and correlation, the quality of any reproduction, and whether the proposed actions address the failure rather than its symptoms. The postmortem should also state what the evidence cannot establish. Link accepted remediation to the team’s issue tracker if that is where ownership and discussion belong. Festival remains the execution record; see [using Festival with your issue tracker]({{< ref "/compare/festival-vs-issue-trackers" >}}).

## Boundaries

Alerting, logs, traces, paging, retention, redaction, and ticketing remain the responsibility of the systems that provide them. Festival does not monitor services, page responders, schedule investigations, or provide a secrets vault. The agent may inspect files and run approved local checks or scripts. A human controls access to sensitive evidence, production changes, severity decisions, external communications, and final approval. Start with the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to set those permissions before the work begins.

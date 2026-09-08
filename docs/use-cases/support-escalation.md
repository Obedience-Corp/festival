---
title: "Support Escalation to a Reproducible Fix"
linkTitle: "Support Escalation"
description: "Move a difficult support case from intake to a reproducible bug, reviewed fix, or approved customer response."
weight: 42
---

# Support Escalation to a Reproducible Fix

A hard support case needs more than a reply draft. The team needs to know what the customer saw, whether the behavior can be reproduced, which version is affected, and what can safely be promised next.

## The handoff

Keep the support system as the intake and customer-facing record. When a case needs engineering work, create a Festival plan with a redacted case summary, reproduction inputs, affected versions, and the desired outcome. The agent can turn that material into a short chain of evidence:

| Stage | Result to review |
| --- | --- |
| Triage | Reproduction question, scope, and missing facts |
| Reproduce | A fixture, test case, or documented inability to reproduce |
| Diagnose | Evidence, suspected change, and competing explanations |
| Fix or explain | Patch and checks, workaround, or a clear reason no fix is proposed |
| Respond | A customer-safe draft with known limits and next action |

{{< agent-prompt >}}
In [camp or project path], investigate support case [redacted case ID] using the supplied reproduction details in [approved paths].

Determine whether the behavior can be reproduced without customer credentials or production data. If it can, propose the smallest fix and verification checks. If it cannot, document what was tried and what evidence is missing. Draft an accurate reply for human approval. Do not send the reply, change customer data, promise a date, or expand the scope without asking.
{{< /agent-prompt >}}

## What the team reviews

The support lead reviews the redaction and the customer wording. The engineer reviews the reproduction, test coverage, compatibility impact, and rollback or workaround. The product owner decides whether the issue becomes a backlog item, a festival, or a documented limitation. If the team uses GitHub Issues, Linear, or Jira, keep that system for prioritization and discussion, then link the resulting work back to the execution plan. [Using Festival with your issue tracker]({{< ref "/compare/festival-vs-issue-trackers" >}}) describes that division.

## Keep the boundary clear

The agent works from approved files, fixtures, and repositories. It can inspect code, run local tests, and prepare a patch or reply draft. It does not own the helpdesk, CRM, outbound messaging, refunds, account changes, or production access. Those systems, credentials, customer identity checks, and notification policies remain external responsibilities. A human approves any customer-facing statement and any action that affects a live account. Use the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to establish the review points before handing over the case.

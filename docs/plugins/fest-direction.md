---
title: "Fest Direction"
description: "Preview Fest Direction, an unreleased plugin that fingerprints written festival plans and records their relationship to Git commits."
weight: 40
---

Record which written plan was in force for a commit, even as tasks are checked off. Fest Direction computes a direction hash that stays stable when execution status changes and changes when the written instructions change.

**Host:** Fest · **Command:** `fest direction` · **Availability:** unreleased, source build only

As of October 9, 2026, Fest Direction is listed in the official marketplace but has no published release archive. A catalog listing does not make it installable through Festival. The commands below describe the source-build preview and may change before release.

## Build the preview

The [Fest Direction repository](https://github.com/Obedience-Corp/fest-direction) contains the source and current build instructions. It requires Go 1.25.6 or newer and `just`.

```bash
git clone https://github.com/Obedience-Corp/fest-direction.git
cd fest-direction
just install
```

The executable is named `fest-direction`. Ensure its install location is on your PATH, then check discovery with `fest plugins`.

## Fingerprint a plan

Run from your camp and replace the example path with a festival in your workspace:

```bash
fest direction hash festivals/active/example-EX0001
```

The output includes two hashes:

| Hash | What it tracks |
| --- | --- |
| Direction | The written plan, with execution state removed. Checking off a task leaves it unchanged; editing instructions changes it. |
| Snapshot | The work unit's content including execution state. Checking off a task changes it. |

Normalization version 2 rejects unknown `fest_*` fields instead of silently deciding whether they belong in the plan. See the [normalization rules](https://github.com/Obedience-Corp/fest-direction/blob/main/docs/normalization.md).

## Connect the plan to Git

The preview supports three ways to record a direction:

- `fest direction anchor .` records the plan at `HEAD` under `.direction/anchors/`, intended for a `pre_task_start` hook. It refuses uncommitted plan changes.
- `fest direction hook install` writes a Git `commit-msg` shim that adds `Festival-Direction` and `Festival-Normalization` trailers.
- `fest direction attest` writes an in-toto statement beside the work unit. `fest direction verify` recomputes the hashes to check it.

Follow the [anchoring guide](https://github.com/Obedience-Corp/fest-direction/blob/main/docs/anchoring.md) before wiring hooks into a festival, and the [statement reference](https://github.com/Obedience-Corp/fest-direction/blob/main/docs/predicate.md) for attestation details.

A matching direction hash establishes that the written plan matches the recorded plan. It does not prove that the work fulfilled the plan or capture instructions given outside the tree. See the [claims and limits](https://github.com/Obedience-Corp/fest-direction/blob/main/docs/claims.md).

## Follow the release

Check [Fest Direction releases](https://github.com/Obedience-Corp/fest-direction/releases) for published builds. For plugins with available downloads today, return to the [Plugin Marketplace]({{< ref "/plugins" >}}).

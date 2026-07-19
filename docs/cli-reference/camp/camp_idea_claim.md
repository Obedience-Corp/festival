---
title: "camp idea claim"
linkTitle: "camp idea claim"
description: "Claim an intent for an agent or session"
---

## camp idea claim

Claim an intent for an agent or session

### Synopsis

Assign an intent to an agent so the campaign tracks who is working it.

Stamps assigned_to and assigned_at, and merges any --ref values (a PR URL,
branch, or festival path) into work_ref. Calling claim again on an
already-claimed intent re-stamps assigned_at and merges in new refs without
dropping ones already recorded -- this is the expected way to record a PR URL
once one is opened, after an initial claim at the start of work.

Use 'camp intent release' to clear the assignment, and 'camp intent sync' to
auto-close intents once their tracked PR merges.

Examples:
  camp intent claim add-dark --agent claude-code-session-1
  camp intent claim add-dark --agent claude-code-session-1 \
    --ref https://github.com/Obedience-Corp/camp/pull/123

```
camp idea claim <id> [flags]
```

### Options

```
      --agent string      Agent or session name claiming the intent (required)
  -h, --help              help for claim
      --no-commit         Don't create a git commit
      --ref stringArray   Work reference: PR URL, branch, or festival path (repeatable)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas

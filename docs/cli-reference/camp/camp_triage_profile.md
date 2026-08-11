---
title: "camp triage profile"
linkTitle: "camp triage profile"
description: "Show the resolved triage profile"
---

## camp triage profile

Show the resolved triage profile

### Synopsis

Print the profile a run would use, fully merged.

Resolution is: the campaign's .campaign/triage/profile.yaml when it exists,
otherwise the named built-in. Keys the file omits inherit the built-in default.
A type's policy is types/<type>.yaml, else types/_default.yaml, else camp's
built-in — and a type policy that declares dispositions replaces the inherited
vocabulary rather than adding to it, so a type can genuinely restrict what it
may be decided into.

This is the same object embedded in every run manifest, which is what keeps a
verdict explainable after the profile moves on.

```
camp triage profile [flags]
```

### Options

```
  -h, --help             help for profile
      --json             Output result as a single JSON object
      --profile string   Resolve a named built-in instead of the campaign's: default, sweep, or deep
      --resolved         Print the fully merged profile (the default and only mode today)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session

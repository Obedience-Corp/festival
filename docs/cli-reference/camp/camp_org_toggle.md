---
title: "camp org toggle"
linkTitle: "camp org toggle"
description: "Toggle back to the last-visited camp in the current org"
---

## camp org toggle

Toggle back to the last-visited camp in the current org

### Synopsis

Toggle back to the most recently visited other camp in the current org.

"Most recently visited" is tracked by last-access time, which camp updates on
every 'camp switch' and 'camp org next'/'toggle'. Paired with 'camp org next',
this gives a natural A <-> B toggle within an org. By default only active
camps are considered; use --all to include inactive and reference camps.

Use with the corg shell function for instant navigation:
  corg t      # cd back to the last org camp you were in

```
camp org toggle [flags]
```

### Examples

```
  camp org toggle          # Print cd to the last-visited org camp
  camp org toggle --print  # Print the target path only
  camp org toggle --json
```

### Options

```
      --all     Include inactive and reference camps in the cycle
  -h, --help    help for toggle
      --json    Output the resolved source and target camps as JSON
      --print   Print the target path only (for shell integration)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group camps into orgs

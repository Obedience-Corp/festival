---
title: "camp artifacts resolve"
linkTitle: "camp artifacts resolve"
description: "Resolve an artifact conflict kept by no-clobber protection"
---

## camp artifacts resolve

Resolve an artifact conflict kept by no-clobber protection

### Synopsis

Resolve one reported artifact conflict.

A sync never overwrites a local file whose bytes differ from the last state
agreed with a peer, and that protection is sticky: it survives every later
sync. This is how you clear it deliberately, instead of deleting the local
file to make the protection go away.

  --list          show the open conflicts with a peer (changes nothing)
  --take-local    keep your copy; that path is then pinned local for this
                  peer, so later peer changes to it will not arrive on their
                  own. Run resolve --take-peer if you want them.
  --take-peer     fetch the peer's copy of that one path, install it, and
                  record it as agreed

There is no --all: resolving in bulk is exactly what the sticky conflict
exists to prevent. Loop the per-path form if you really mean it.

```
camp artifacts resolve [path] [flags]
```

### Options

```
      --from string   Machine id the conflict is with (required; conflicts are per peer)
  -h, --help          help for resolve
      --json          Output as JSON
      --list          List open conflicts with the peer and change nothing
      --take-local    Keep your copy; pins that path local for this peer
      --take-peer     Fetch the peer's copy of that path and record it as agreed
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp artifacts](../camp_artifacts/)	 - Manage declared artifact roots (.campaign/artifacts.yaml)

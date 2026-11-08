---
title: "camp sync"
linkTitle: "camp sync"
description: "Safely synchronize submodules"
---

## camp sync

Safely synchronize submodules

### Synopsis

Synchronize submodules with pre-flight safety checks.

The sync command performs three critical operations:

  1. PRE-FLIGHT CHECKS
     Verifies no uncommitted changes or unpushed commits that could
     be lost during synchronization.

  2. URL SYNCHRONIZATION
     Copies URLs from .gitmodules to .git/config, fixing URL mismatches
     that occur when remote URLs change.

  3. SUBMODULE UPDATE
     Preserves existing local branches, fast-forwards them safely when
     behind a recorded gitlink, and discovers children after checkout.

Orphaned gitlinks are reported without removing them from the index.
Normal output shows failed paths and original errors. JSON results include
ordered module results, nested child paths, owners, errors, and counts.
Initialized counts verified top-level checkouts; failed excludes skips.
After a partial clone, 'camp sync --dry-run' checks local work before retry.
'camp sync projects/<path>' retries one module; a final 'camp sync' checks all.
Use 'camp status --show-refs' to see root gitlink changes separately. A broken
machine-local project link is optional and can be previewed with
'camp project repair <name>'. See docs/guides/clone-sync-recovery.md.

This order is critical: sync-before-update prevents silent code deletion
when URLs change on remote repositories.

EXIT CODES:
  0  Success
  1  Runtime failure (including pre-flight, sync, or update failure)
  2  Usage error (bad flags or args)
  3  Validation-only failure (updates completed)

EXAMPLES:
  # Sync all submodules (recommended default)
  camp sync

  # Preview what would happen without making changes
  camp sync --dry-run

  # Sync a specific submodule only
  camp sync projects/camp

  # Force sync despite uncommitted changes (dangerous!)
  camp sync --force

  # Detailed output for each submodule
  camp sync --verbose

  # JSON output for scripting
  camp sync --json

  # Accelerate over a peer machine from ~/.obey/machines.yaml: for each
  # already-initialized submodule, fetch objects from that machine first
  # (LAN/tailnet), then run the normal origin-based update, then pull
  # declared artifact roots (policy=always) from the same machine.
  # Uninitialized submodules skip the peer step and init from origin.
  # Preflight, origin URLs, validation, and exit codes are unchanged; an
  # unreachable peer degrades to a warning.
  camp sync --from studio-mac

  # Peer git objects only, skip artifacts / artifacts only, skip git phases
  camp sync --from studio-mac --git-only
  camp sync --from studio-mac --artifacts-only

  # Check artifact roots against last-transfer snapshots, no transfer
  camp sync --verify-artifacts
  camp sync --verify-artifacts --from studio-mac

On Windows, peer transfer via --from is unavailable in this release. Use
'camp sync' without --from for origin-backed git. --verify-artifacts --from
still reads local snapshots and does not contact a peer.

```
camp sync [submodule...] [flags]
```

### Options

```
      --artifacts-only     With --from: pull declared artifact roots only, skip git phases
  -n, --dry-run            Show what would happen without making changes
  -f, --force              Skip safety checks (uncommitted changes warning still shown)
      --from string        Fetch objects for already-initialized submodules (and declared artifact roots) from this machine (id from ~/.obey/machines.yaml)
      --git-only           With --from: move git objects only, skip artifact roots
  -h, --help               help for sync
      --json               Output results as JSON for scripting
      --no-drain           Do not wait for camp's queued commits first
      --no-fetch           Skip fetching from remote (use local refs only)
      --no-probe-cache     Re-probe the rsync engine on both machines instead of using the cached 24h verdict
  -p, --parallel int       Maximum update workers; operations sharing a superproject are serialized to avoid Git config/index contention (default 4)
  -v, --verbose            Show detailed output for each submodule
      --verify-artifacts   Check artifact roots against last-transfer snapshots (no transfer)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them

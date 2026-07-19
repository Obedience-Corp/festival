---
title: "camp clone"
linkTitle: "camp clone"
description: "Clone a campaign with full submodule setup"
---

## camp clone

Clone a campaign with full submodule setup

### Synopsis

Clone a campaign repository and initialize all submodules.

This command provides a single-step setup for new devices:

  1. CLONE REPOSITORY
     Clones the campaign repository with recursive submodules.

  2. SYNCHRONIZE URLs
     Copies URLs from .gitmodules to .git/config, ensuring
     URL consistency across all submodules.

  3. UPDATE SUBMODULES
     Fetches and checks out the correct commits for all submodules.

  4. VALIDATE SETUP
     Verifies all submodules are initialized, at correct commits,
     and have matching URLs.

  5. REGISTER CAMPAIGN
     If .campaign/campaign.yaml exists, registers the campaign
     in the global registry for navigation and discovery.

EXIT CODES:
  0  Success
  1  Runtime failure (clone failed before usable campaign)
  2  Usage error (bad flags or args)
  3  Partial success or validation failed

EXAMPLES:
  # Clone a campaign (default: SSH)
  camp clone git@github.com:Obedience-Corp/obey-campaign.git

  # Clone with HTTPS
  camp clone https://github.com/Obedience-Corp/obey-campaign.git

  # Clone to a specific directory
  camp clone git@github.com:org/repo.git my-campaign

  # Clone a specific branch
  camp clone git@github.com:org/repo.git --branch develop

  # Shallow clone (latest commit only)
  camp clone git@github.com:org/repo.git --depth 1

  # Clone without submodules
  camp clone git@github.com:org/repo.git --no-submodules

  # Clone without validation
  camp clone git@github.com:org/repo.git --no-validate

  # Clone without auto-registration
  camp clone git@github.com:org/repo.git --no-register

  # JSON output for scripting
  camp clone git@github.com:org/repo.git --json

  # Seed from a peer machine in ~/.obey/machines.yaml: root repo and
  # submodules clone from that machine's copy (LAN/tailnet), then origin is
  # re-pointed to the URL above and the delta fetched. The result is an
  # origin replica that arrived over the fast path; peer failures fall back
  # to plain origin cloning.
  camp clone git@github.com:org/repo.git --from studio-mac

```
camp clone <url> [directory] [flags]
```

### Options

```
  -b, --branch string   Clone specific branch (default: repository default branch)
      --depth int       Shallow clone depth (0 = full history)
      --from string     Seed git objects from this machine (id from ~/.obey/machines.yaml), then fetch the delta from origin
  -h, --help            help for clone
      --json            Output results as JSON for scripting
      --no-register     Skip auto-registration in global campaign registry
      --no-submodules   Skip submodule initialization
      --no-validate     Skip post-clone validation
  -p, --parallel int    Number of parallel submodule initializations (default 4)
  -v, --verbose         Show detailed output for each operation
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces

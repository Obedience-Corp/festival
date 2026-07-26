---
title: "camp skills"
linkTitle: "camp skills"
description: "Manage campaign skill directory links"
---

## camp skills

Manage campaign skill directory links

### Synopsis

Manage campaign skill bundle projection for tool interoperability.

Skills are centralized in .campaign/skills/ and projected into tool ecosystems
(Claude, agents, Grok, etc.) as per-bundle symlinks. This keeps a single source
of truth while preserving existing provider-native skills directories.

Project worktrees under projects/worktrees/<project>/<name>/ are also supported:
'camp project worktree add' projects skills into each new worktree automatically,
and 'camp skills link --worktrees' repairs all of them. That way harnesses whose
git root is the worktree (not the campaign root) still discover campaign skills.
Only git checkouts are projected (directory must contain .git). A loose git root
at projects/worktrees/<name>/ is accepted; package subdirs under it are not.

Commands:
  link     Project per-skill symlinks into a tool-specific skills directory
  status   Show projection status for tool-specific skills directories
  unlink   Remove projected skill symlinks

Examples:
  camp skills link --tool claude    Project skills into .claude/skills/
  camp skills link --tool agents    Project skills into .agents/skills/
  camp skills link --worktrees      Project into tools and every project worktree
  camp skills link --worktrees-only Project into project worktrees only
  camp skills status                Show all skill projection states
  camp skills unlink --tool claude  Remove projected symlinks from .claude/skills/

```
camp skills [flags]
```

### Options

```
  -h, --help   help for skills
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp skills link](../camp_skills_link/)	 - Project campaign skill bundles into tool-specific skills directories
* [camp skills status](../camp_skills_status/)	 - Show the current state of projected skill bundle symlinks
* [camp skills unlink](../camp_skills_unlink/)	 - Remove projected skill bundle symlinks

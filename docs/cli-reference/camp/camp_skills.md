## camp skills

Manage campaign skill directory links

### Synopsis

Manage campaign skill bundle projection for tool interoperability.

Skills are centralized in .campaign/skills/ and projected into tool ecosystems
(Claude, agents, etc.) as per-bundle symlinks. This keeps a single source of
truth while preserving existing provider-native skills directories.

Commands:
  link     Project per-skill symlinks into a tool-specific skills directory
  status   Show projection status for tool-specific skills directories
  unlink   Remove projected skill symlinks

Examples:
  camp skills link --tool claude    Project skills into .claude/skills/
  camp skills link --tool agents    Project skills into .agents/skills/
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
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp skills link](camp_skills_link.md)	 - Project campaign skill bundles into tool-specific skills directories
* [camp skills status](camp_skills_status.md)	 - Show the current state of projected skill bundle symlinks
* [camp skills unlink](camp_skills_unlink.md)	 - Remove projected skill bundle symlinks


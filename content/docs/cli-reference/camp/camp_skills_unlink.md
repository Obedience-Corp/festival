## camp skills unlink

Remove projected skill bundle symlinks

### Synopsis

Remove managed skill bundle symlinks created by 'camp skills link'.

Only removes projected symlink entries created from .campaign/skills bundles.
It never removes non-symlink files/directories or foreign symlinks.

Examples:
  camp skills unlink --tool claude       Remove projected entries in .claude/skills/
  camp skills unlink --tool agents       Remove projected entries in .agents/skills/
  camp skills unlink --path custom/dir   Remove projected entries in custom/dir
  camp skills unlink --tool claude -n    Dry run — show what would happen

```
camp skills unlink [flags]
```

### Options

```
  -n, --dry-run       Show what would happen without making changes
  -h, --help          help for unlink
  -p, --path string   Custom destination directory to unlink
  -t, --tool string   Tool to unlink: claude, agents
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp skills](camp_skills.md)	 - Manage campaign skill directory links


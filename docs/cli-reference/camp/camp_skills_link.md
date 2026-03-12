## camp skills link

Project campaign skill bundles into tool-specific skills directories

### Synopsis

Project campaign skill bundles from .campaign/skills/ into tool-specific
skills directories.

This command creates one symlink per skill bundle. It does not replace entire
provider skills directories, so existing user skills remain intact.

Examples:
  camp skills link --tool claude       Project skills into .claude/skills/
  camp skills link --tool agents       Project skills into .agents/skills/
  camp skills link --path custom/dir   Project skills into custom/dir
  camp skills link --tool claude -n    Dry run — show what would happen
  camp skills link --tool claude -f    Replace conflicting symlink entries

```
camp skills link [flags]
```

### Options

```
  -n, --dry-run       Show what would happen without making changes
  -f, --force         Replace conflicting symlink entries (never files/directories)
  -h, --help          help for link
  -p, --path string   Custom destination directory
  -t, --tool string   Tool to link: claude, agents
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp skills](camp_skills.md)	 - Manage campaign skill directory links


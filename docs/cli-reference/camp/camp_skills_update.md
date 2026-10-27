---
title: "camp skills update"
linkTitle: "camp skills update"
description: "Refresh shipped skill bundles to this camp version"
---

## camp skills update

Refresh shipped skill bundles to this camp version

### Synopsis

Refresh the skill bundles camp ships in .campaign/skills/ to the content
this camp version ships. With no slug, every shipped bundle is checked.

Each shipped file is compared with this version's content and with
.campaign/skills/.shipped.yaml, the record of what camp last wrote. Camps
created before that record existed have none, so for a file it does not cover
camp reads git history instead: a file whose only commit is camp init's or
camp repair's, unchanged since, still holds what camp wrote and is replaced
without --force. A file first committed any other way stays unknown.

  missing    written
  current    left alone
  outdated   unchanged since camp wrote it, per the record or git, so it is replaced
  modified   changed locally, so it is preserved unless --force
  unknown    differs and neither the record nor git shows what camp wrote;
             preserved unless --force
  symlink    a symlinked file or directory that differs; never replaced, even with --force

Every preserved file is reported with the command that replaces it. A file
replaced on git evidence alone is reported with the command that restores it,
'git checkout HEAD -- <file>...'. With --force, camp first secures a
one-command undo per bundle and prints it:
'git checkout HEAD -- .campaign/skills/<slug>' when the bundle is committed and
unchanged, otherwise a copy of the replaced files under .campaign/skills/.backup/.

Files camp does not ship, such as references/ or local bundles, are never touched.

```
camp skills update [slug...] [flags]
```

### Examples

```
  camp skills update                          Refresh every shipped bundle
  camp skills update --dry-run                Show what would change
  camp skills update campaign-commit          Refresh one bundle
  camp skills update --force campaign-commit  Replace local changes in one bundle
```

### Options

```
  -n, --dry-run   Show what would change without writing anything
  -f, --force     Also replace locally modified files, after printing an undo
  -h, --help      help for update
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp skills](../camp_skills/)	 - Manage camp skill bundles and their directory links

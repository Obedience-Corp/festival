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

A plugin can offer skill bundles too. Naming one, such as festival-app, asks
the camp-app plugin on PATH for it ('camp-app skill --json', with a 5 second
limit) and writes it the same way, recording the camp-app version that wrote
it. camp-app is asked only when a request names a bundle camp does not ship;
a refresh with no slug never asks it. A bundle written by a newer camp-app
than this machine has is left alone (ahead). 'camp skills decline <slug>'
removes a plugin bundle and keeps it out of this camp.

  --auto   an automatic request: adds or refreshes, leaves a declined bundle
           alone, cannot be combined with --force, and never fails because
           camp-app is missing or too old
  --link   then links the named bundles into .claude/skills and .agents/skills
           where those folders already hold camp's links; never creates one
  --json   prints one result, schema skills-update/v1alpha1

```
camp skills update [slug...] [flags]
```

### Examples

```
  camp skills update                          Refresh every shipped bundle
  camp skills update --dry-run                Show what would change
  camp skills update campaign-commit          Refresh one bundle
  camp skills update --force campaign-commit  Replace local changes in one bundle
  camp skills update festival-app             Add or refresh the Festival app skill from camp-app
  camp skills update festival-app --auto --link --json
                                              What the Festival app runs on camp open
```

### Options

```
      --auto      Automatic request: leave declined bundles alone; refuses --force
  -n, --dry-run   Show what would change without writing anything
  -f, --force     Also replace locally modified files, after printing an undo
  -h, --help      help for update
      --json      Print one result as JSON
      --link      Link the named bundles into tool folders that already hold camp's links
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp skills](../camp_skills/)	 - Manage camp skill bundles and their directory links

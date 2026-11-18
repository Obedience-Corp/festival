---
title: "camp skills decline"
linkTitle: "camp skills decline"
description: "Remove a plugin skill bundle and keep it out of this camp"
---

## camp skills decline

Remove a plugin skill bundle and keep it out of this camp

### Synopsis

Remove a skill bundle a plugin offered, such as festival-app from camp-app,
together with the links camp projected for it, and record in
.campaign/skills/.shipped.yaml that this camp declined it. The record travels
with the camp, so an automatic request ('camp skills update --auto') never adds
the bundle again, on any machine. Naming it in 'camp skills update <slug>'
adds it back.

A bundle with files camp did not write is refused unless --force, which first
secures an undo: 'git checkout' when the bundle is committed and clean,
otherwise a copy under .campaign/skills/.backup/. A bundle that is, or holds, a
symlink is always refused. Bundles camp ships cannot be declined.

```
camp skills decline <slug> [flags]
```

### Examples

```
  camp skills decline festival-app          Remove the Festival app skill from this camp
  camp skills decline festival-app --force  Remove it even though it was edited
  camp skills decline festival-app --json   Machine-readable result
```

### Options

```
  -f, --force   Also remove a bundle with local changes, after securing an undo
  -h, --help    help for decline
      --json    Print one result as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp skills](../camp_skills/)	 - Manage camp skill bundles and their directory links

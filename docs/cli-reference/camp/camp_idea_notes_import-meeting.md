---
title: "camp idea notes import-meeting"
linkTitle: "camp idea notes import-meeting"
description: "Import a meeting bundle into notes/meetings/"
---

## camp idea notes import-meeting

Import a meeting bundle into notes/meetings/

### Synopsis

Import a festival-voice (or compatible) meeting bundle as a note under
notes/meetings/ with a transcript sidecar in .transcripts/.

Re-importing the same bundle updates the existing note in place.

Examples:
  camp idea notes import-meeting ~/.obey/agents/voice/.../foo.meeting
  camp idea notes import-meeting ./bundle --summary-file summary.md --json
  camp idea notes import-meeting ./bundle --adopt-intent misfiled-id

```
camp idea notes import-meeting <bundle-path> [flags]
```

### Options

```
      --adopt-intent string      Delete this lifecycle intent after successful import
      --author string            Author attribution
  -h, --help                     help for import-meeting
      --json                     emit a structured JSON result
      --summary string           Literal summary body
      --summary-file string      Path to summary markdown (overrides bundle summary.md)
      --title string             Override note title
      --transcript-file string   Path to transcript file
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea notes](../camp_idea_notes/)	 - Manage the note store (folders, moves, meetings)

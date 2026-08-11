---
title: "camp triage evidence template"
linkTitle: "camp triage evidence template"
description: "Print an evidence record with the known facts filled in"
---

## camp triage evidence template

Print an evidence record with the known facts filled in

### Synopsis

Print an evidence record for one row with everything camp can establish
already filled in, and the judgment fields left empty.

The split is deliberate. Anchors and signals are facts camp measured - the
row's stage, its age, its content hash, its workflow status. The empty fields
are what a person or an agent has to decide. Nothing here guesses at what was
delivered; a template that did would produce a record asserting a conclusion
nobody reached.

No pull-request anchor is ever pre-filled: camp cannot observe a PR without
asking a remote, and an anchor claiming a state nobody checked would make a
verdict look verified when it is not.

Fill it in and submit it:
  camp triage evidence template <id> > /tmp/record.json
  camp triage evidence set <id> --file /tmp/record.json

```
camp triage evidence template <stable-id> [flags]
```

### Options

```
  -h, --help         help for template
      --run string   Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage evidence](../camp_triage_evidence/)	 - Submit or draft evidence for a row

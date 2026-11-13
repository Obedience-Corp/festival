---
title: "camp approvals"
linkTitle: "camp approvals"
description: "See what in this camp is waiting on your approval"
---

## camp approvals

See what in this camp is waiting on your approval

### Synopsis

List everything in this camp that is waiting on a human to approve.

Agents stop for a human in several places: a festival workflow checkpoint, a
phase gate, a checkpoint in a standalone WORKFLOW.md. Each one records a request
in the camp's approvals ledger when it starts waiting and a resolution when it
stops, so this is the one place to look.

Run bare to browse the list, read what each request asks, and approve or reject
it. Approving hands your terminal to the source's own command, run from the
source's directory and pinned to the step you were shown; camp never records an
approval itself. Agents can read this list with --json. They cannot approve
through it: the source's command requires a person at a terminal.

The ledger lives in .campaign/approvals and is committed, so a request made on
one machine shows up on your others after a push and pull. Recording an event
does not commit it: events are committed with the camp's next ordinary commit,
and listing commits any still outstanding (pass --no-commit to skip that;
--json never commits). A request
whose source is not on this machine, or has moved on, is still listed and
marked as not actionable here.

Examples:
  camp approvals                   # interactive browser in a TTY; table otherwise
  camp approvals --plain           # always print the table
  camp approvals --json            # the same, for scripts and agents
  camp approvals show <id>         # one request in full
  camp approvals path <id>         # the source directory, to cd into
  camp approvals withdraw <id> --reason "..."   # clear a request whose source is gone
  camp approvals withdraw --stale               # clear every request whose source moved past it

```
camp approvals [flags]
```

### Options

```
  -h, --help          help for approvals
  -i, --interactive   Open the interactive approvals browser (prints the table when stdout is not a terminal)
      --json          Emit a structured JSON result
      --no-commit     Do not commit uncommitted approval events
      --plain         Print the table even when stdout is a terminal
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp approvals commit](../camp_approvals_commit/)	 - Commit approval events that are not committed yet
* [camp approvals path](../camp_approvals_path/)	 - Print the directory of a request's source
* [camp approvals show](../camp_approvals_show/)	 - Show one approval request in full
* [camp approvals withdraw](../camp_approvals_withdraw/)	 - Clear a request whose source is no longer waiting

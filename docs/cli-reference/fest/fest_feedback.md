---
title: "fest feedback"
linkTitle: "fest feedback"
description: "Manage structured feedback collection"
---

## fest feedback

Manage structured feedback collection

### Synopsis

Collect and manage structured feedback during festival execution.

Feedback allows agents to record observations based on defined criteria
for later aggregation and analysis.

Examples:
```bash
  fest feedback init --criteria "Code quality" --criteria "Performance"
  fest feedback criteria add --criteria "Onboarding friction, especially copied commands"
  fest feedback add --criteria "Code quality" --observation "Found duplication"
  fest feedback view
  fest feedback export --format markdown
```

### Options

```
  -h, --help   help for feedback
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest feedback add](../fest_feedback_add/)	 - Add a feedback observation
* [fest feedback criteria](../fest_feedback_criteria/)	 - Manage feedback criteria
* [fest feedback export](../fest_feedback_export/)	 - Export collected feedback
* [fest feedback init](../fest_feedback_init/)	 - Initialize feedback collection
* [fest feedback view](../fest_feedback_view/)	 - View collected feedback

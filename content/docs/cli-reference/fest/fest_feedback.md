## fest feedback

Manage structured feedback collection

### Synopsis

Collect and manage structured feedback during festival execution.

Feedback allows agents to record observations based on defined criteria
for later aggregation and analysis.

Examples:
```bash
  fest feedback init --criteria "Code quality" --criteria "Performance"
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
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest feedback add](fest_feedback_add.md)	 - Add a feedback observation
* [fest feedback export](fest_feedback_export.md)	 - Export collected feedback
* [fest feedback init](fest_feedback_init.md)	 - Initialize feedback collection
* [fest feedback view](fest_feedback_view.md)	 - View collected feedback


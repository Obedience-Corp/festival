---
name: fest-validate
description: Validate festival structure and find issues
---

# Validate Festival

Run validation to catch structural issues, missing files, and unfilled markers.

```bash
fest validate
```

If issues are found, present them clearly and offer to fix automatically:

```bash
fest validate --fix
```

Common issues:
- Missing `SEQUENCE_GOAL.md` files
- Unfilled `REPLACE` markers in generated files
- Non-compliant naming patterns
- Missing quality gate tasks

---
name: fest-create
description: Create a new festival, phase, sequence, or task
arguments:
  - name: type
    description: "What to create: festival, phase, sequence, or task (default: festival)"
    required: false
---

# Create Festival Structure

Help the user create festival methodology structures.

## Gather Requirements

Ask the user for:

1. **What to create**: festival, phase, sequence, or task (use the `type` argument if provided, default to festival)
2. **Name**: A descriptive kebab-case name
3. For festivals: **Type** — standard, implementation, research, or ritual
   - `standard`: Full planning + implementation (recommended for most work)
   - `implementation`: Execution-only (use when requirements already exist)
   - `research`: Investigation and exploration
   - `ritual`: Recurring processes

## Create

Based on user input, run the appropriate command:

```bash
# Festival
fest create festival --name "<name>" --type <type>

# Phase (run from within a festival directory)
fest create phase --name "<NNN_NAME>" --type <phase-type>

# Sequence (run from within a phase directory)
fest create sequence

# Task (run from within a sequence directory)
fest create task
```

## Post-Creation

After creation, run `fest validate` to verify the structure is correct. Remind the user to fill any `REPLACE` markers in generated files.

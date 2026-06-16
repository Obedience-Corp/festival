---
name: fest-understand
description: Learn about the Festival Methodology — concepts, structure, rules, and workflows
arguments:
  - name: topic
    description: "Topic to learn about: methodology, structure, tasks, rules, types, or gates"
    required: false
---

# Learn Festival Methodology

Run `fest understand` commands to teach the user (or yourself) about the methodology.

If no topic specified, start with the overview:

```bash
fest understand methodology
```

For a specific topic:

```bash
fest understand {{topic}}
```

Available topics:
- `methodology` — Core principles and philosophy
- `structure` — Three-level hierarchy (phases, sequences, tasks)
- `tasks` — How to write and execute tasks
- `rules` — Naming conventions and structural rules
- `types` — Festival and phase types
- `gates` — Quality gates at sequence boundaries

Present the output clearly. If the user has follow-up questions, use additional `fest understand` commands or read the methodology docs directly.

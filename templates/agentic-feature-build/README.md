# Agentic Feature Build Template

Copy this folder when you want a lightweight, stealable plan for an AI-assisted feature before you are ready to design a full custom Festival structure.

It is intentionally blunt:

1. Define the user-facing outcome.
2. Capture what the agent must inspect first.
3. Split implementation into task-sized steps.
4. List validation commands before work starts.
5. Preserve handoff notes so the next session can resume.

For a real Festival workflow, create the plan with:

```bash
fest create festival --name "feature-name" --type standard
```

Then adapt the sections in [FEATURE_PLAN.md](FEATURE_PLAN.md) into the generated festival, phase, sequence, and task files.

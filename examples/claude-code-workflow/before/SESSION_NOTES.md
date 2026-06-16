# Before Festival: Chat-Only Plan

Goal: add rate limiting to the API service.

Rough plan from the last AI session:

- Find the existing request middleware.
- Decide where rate-limit config should live.
- Add middleware for per-IP limits.
- Add tests.
- Update docs.

Open questions:

- Is Redis already available in production?
- Should local development use memory-only limits?
- What status code and response shape do existing errors use?

Current uncertainty:

- The previous session may have started middleware changes, but progress is not recorded anywhere durable.
- The next session needs to inspect git status, reread old chat notes, and reconstruct the plan before doing useful work.
- There is no explicit completion checklist for the feature.

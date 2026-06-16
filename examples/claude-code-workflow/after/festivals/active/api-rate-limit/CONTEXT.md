# API Rate Limit Context

## Decisions

- Use memory-backed limits for local development.
- Keep a Redis-backed store as the production path.
- Match the existing API error envelope instead of introducing a new response shape.

## Handoff Notes

- Start with middleware discovery before implementation.
- Do not add a new configuration package unless existing config loading cannot support the feature.
- Preserve cancellation and request context propagation in middleware tests.

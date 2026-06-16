# Task: Add Rate Limit Middleware

## Objective

Implement rate limiting at the selected middleware boundary.

## Requirements

- Support disabled, memory-backed, and Redis-backed modes.
- Preserve request context cancellation.
- Return the existing API error envelope when a request is limited.
- Keep configuration names explicit and documented.

## Validation

```bash
just test
git diff --check
```

## Completion

When implementation and validation pass, run:

```bash
fest task completed
fest commit -m "add rate limit middleware"
```

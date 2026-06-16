# Task: Discover Middleware and Error Shape

## Objective

Find the existing request middleware and API error response conventions before adding rate limiting.

## Steps

1. Search for middleware registration and request context handling.
2. Find the existing JSON error envelope and status-code conventions.
3. Identify the best insertion point for rate limiting.
4. Record any implementation constraints in `CONTEXT.md`.

## Validation

```bash
git diff --check
```

## Completion

When the discovery notes are captured, run:

```bash
fest task completed
```

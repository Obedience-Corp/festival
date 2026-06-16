# Task: Document Rate Limit Configuration

## Objective

Document how operators configure and verify API rate limiting.

## Requirements

- Explain disabled, local memory, and production Redis modes.
- Show the expected limited response.
- Include the validation command used before release.

## Validation

```bash
git diff --check
```

## Completion

When the docs are updated, run:

```bash
fest task completed
fest commit -m "document rate limit configuration"
```

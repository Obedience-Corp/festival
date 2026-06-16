# API Rate Limit Festival Goal

Add API rate limiting without changing existing successful request behavior.

## Success Criteria

- Requests above the configured limit return the same JSON error shape as other API errors.
- Local development works without Redis.
- Production can use Redis-backed counters.
- Unit or integration tests cover allowed, limited, and configuration-disabled paths.
- Documentation explains configuration and expected responses.

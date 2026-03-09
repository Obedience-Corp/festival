# CI Integration

How to keep the public Festival release path aligned with the same beginner smoke check local contributors run.

## Release Smoke Ownership

The release-facing Festival repo owns the canonical beginner-path smoke entrypoint:

```bash
just test beginner-path-smoke
```

That command runs `scripts/smoke_beginner_path.sh`, which exercises the audited no-network launch path:

1. Create a temporary campaign with `camp init`
2. Add one local git repo with `camp project add --local`
3. Create a standard festival with `fest create festival --name ... --type standard --markers-file ...`
4. Run `fest validate`
5. Run `fest next` and confirm it enters `001_INGEST`

## Where It Runs

- Local contributors can run `just test beginner-path-smoke`
- `just release preflight` runs the same smoke before any release tag flow proceeds
- `.github/workflows/release.yaml` runs the same smoke before the GoReleaser step

This keeps release automation and local verification on one path. Do not add a separate CI-only beginner smoke.

## Why This Matters

The launch risk is not just build failure. It is first-run confusion. This smoke exists to catch drift in:

- `camp init`
- `camp project add --local`
- `fest create festival --name ... --type standard --markers-file ...`
- `fest validate`
- `fest next`

If the smoke fails, the step label tells you which part of the beginner path broke and the temp workspace path is left behind for inspection.

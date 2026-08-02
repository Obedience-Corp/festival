# Contributing

Contributions are welcome. By contributing you agree that your contribution is
licensed under the [Apache License 2.0](LICENSE), the same license as the
project.

Most changes belong in the component repos rather than this bundle:
[camp](https://github.com/Obedience-Corp/camp) and
[fest](https://github.com/Obedience-Corp/fest). This repo owns the release
bundle, packaging, docs site, and release tooling.

## Developer Certificate of Origin

Every commit must be signed off:

```bash
git commit -s
```

The sign-off certifies the [Developer Certificate of Origin 1.1](https://developercertificate.org/):
that you wrote the change, or otherwise have the right to submit it under the
project's license. Pull requests with unsigned commits will be asked to rebase
with sign-offs before merge.

## Practical notes

- Run `just release preflight <mode>` and `just test release-operator` before
  release-tooling PRs.
- Match the surrounding code's conventions; see the README for layout.

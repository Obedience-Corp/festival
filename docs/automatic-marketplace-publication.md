# Automatic marketplace availability

Registered dynamic plugins and Obey resolve new releases from their signed
`release_source` contracts. Static camp-app and Festival manifests are promoted
by `marketplace-reconcile.yml` after all required release assets validate. The
workflow runs every half hour and accepts an exact package/version dispatch.
`camp-app`'s existing publish recipe dispatches it and waits for public readback.
Suite publication uploads its generated manifest as a release asset and invokes
the same reconciler. Retry with `just release marketplace camp-app 0.1.1` or
`just release marketplace festival <version>`; no rebuild is needed.

The existing `MARKETPLACE_PUBLISH_TOKEN` opens a generated metadata PR. The
marketplace signs it using its own secret. Promotion waits for signatures and
the required `verify` check on the final commit, validates that the PR contains
only the exact prepared metadata/signatures, and uses a SHA-pinned protected
merge. It then verifies signed main and reads back the version. Failed runs
remain visible in Actions; retries reuse an existing generated branch/PR or
regenerate against changed main. Older events never downgrade the catalog.

`component-reconcile.yml` checks published stable Camp, Fest and Installer
releases every half hour, on manual dispatch, or a `component-released`
repository dispatch. It passes explicit released tags to the existing suite
release operator. The operator retains pin PRs, preflight, builds and the normal
release gates. Clients continue receiving one co-tested bundle. Duplicate runs
do nothing when the published bundle already contains those commits; an
interrupted pin-to-tag handoff can resume. A tagged but unpublished suite blocks
another bundle and names the release workflow to inspect/retry.

The suite handoff uses the existing publisher credential and requires write
access to Festival plus permission to inspect its publisher-secret names. It
does not copy secret values, change branch protections, or bypass required
checks. If that credential lacks access, its Actions failure is the deployment
blocker; the marketplace reconciler remains independent.

Validation: run `just test marketplace-publish` and `just test release-operator`
inside a disposable container. Changes to release tooling also require
`just release preflight stable` in that container and the repository's required
PR checks. Never count an open metadata PR as public availability.

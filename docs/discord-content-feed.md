# Discord project feed

The `Discord project feed` workflow publishes concise updates to a dedicated
Discord `#project-feed` webhook. It reads public GitHub metadata only from the
explicit allowlist: `Obedience-Corp/festival`, `Obedience-Corp/fest`, and
`Obedience-Corp/camp`. A repository is checked for public visibility before any
release or pull request contents are fetched.

The weekly job runs Monday and includes stable releases published in the last
seven days plus merged pull requests from the same period. A PR qualifies when
its title starts with conventional `feat:` or `fix:` (optional scope/bang), or
it has the `community` label. Bot authors, dependency-labeled PRs, and other
PRs are omitted. Releases include only a short name/tag and source URL; release
bodies are never forwarded. Output neutralizes Discord mentions and does not
use mass mentions. Each weekly post contains at most five repository items and
one visual spotlight, and is kept below Discord's 2,000-character content
limit. GitHub source links are wrapped to suppress noisy unfurls; only the
curated spotlight image URL is left bare for a visual preview.

Set the repository variable `DISCORD_FEED_RELEASES_ONLY=true` to omit PRs and
spotlights from the weekly scan. Locally, use `--releases-only` with `--mode weekly`.
The scan selects from the latest 20 releases and 50 recently updated closed PRs
per repository. It is a curated digest, not an exhaustive changelog. Items that
do not fit are not marked delivered, but can age out of the seven-day window.
Each reviewed spotlight is used once; add new IDs to `docs/discord-spotlights.json`
through a PR to introduce more. The catalog accepts project documentation and
asset hosts plus the explicitly listed public GitHub repositories.

Manual dispatch defaults to a dry run. Live sends require both the repository
variable `DISCORD_FEED_ENABLED=true` and the secret
`DISCORD_PROJECT_FEED_WEBHOOK`. The script itself also defaults to dry-run when
`--send` is omitted, so local testing cannot post accidentally.

The workflow keeps seen release, PR, weekly, and spotlight IDs in a dedicated
`discord-feed-state` branch, which is updated only after a successful send. The
workflow is serialized to avoid concurrent state updates, and a dry run never
changes delivery state. A webhook POST can still be
ambiguous if the network fails after Discord accepts it; because Discord
webhooks do not provide an idempotency key, a retry in that narrow window can
duplicate one message. A failure while pushing the state branch after Discord
confirms the message has the same narrow recovery ambiguity. The state and
concurrency controls prevent ordinary reruns from spamming.

The release trigger is immediate for releases published in this Festival
repository. The Monday poll covers releases and merged PRs in the other two
allowlisted repositories. Current Discord channels and curated guide content
are live; webhook and workflow activation remain pending operator setup.

## Enable after reviewing the PR

1. Merge this change into the Festival repository's default branch.
2. In Discord, open [#project-feed](https://discord.com/channels/1476362567864684554/1548804117147815948)
   → Edit Channel → Integrations → Webhooks. Create an incoming webhook for that
   channel, named **Festival updates**. Keep its URL private.
3. In the Festival repository, open Settings → Secrets and variables → Actions.
   Save the URL as a repository secret named `DISCORD_PROJECT_FEED_WEBHOOK`.
4. Run **Discord project feed** manually with **Send to Discord** unchecked.
   Inspect the preview in the Actions log. It does not consume delivery history.
5. Set the repository variable `DISCORD_FEED_ENABLED` to `true`, then manually
   run once with **Send to Discord** checked. Confirm the post appears in the
   intended channel and the run persists `discord-feed-state` successfully.
6. Run the same weekly feed again to confirm it reports `NO_MESSAGES`.

Turning `DISCORD_FEED_ENABLED` back to `false` stops posting. No separate bot
account, model API, or paid service is required. GitHub Actions must be allowed
to write the dedicated state branch; do not apply a rule requiring PRs to that
branch. Source and default-branch protection can stay in place.

For an ambiguous send or a state-push failure, disable posting and inspect the
last Discord message and workflow log before retrying. The message may already
exist even though the run failed. Do not delete the state branch to recover:
that would discard deduplication history. The workflow fails closed if it cannot
read an existing state branch or its JSON is invalid.

[#guides-and-demos](https://discord.com/channels/1476362567864684554/1548803526652862575)
already contains a pinned introduction and four captioned GIFs. Both resource
channels are read-only; discussion belongs in general and troubleshooting in help.

## Check and preview

```sh
just community check
just community preview
```

Example local dry run:

```sh
python3 scripts/discord_content_feed.py --mode weekly --state-file /tmp/discord-feed-state.json
```

For a release-only invocation, provide an allowlisted repository and tag:

```sh
python3 scripts/discord_content_feed.py --mode release \
  --repo Obedience-Corp/festival --tag v0.3.9
```

No webhook URL or credential belongs in the repository or in logs.

The workflow uses `wait=true` on Discord webhook requests and requires the
returned message ID before persisting state. This follows Discord’s webhook
contract; see the [Execute Webhook documentation](https://docs.discord.com/developers/resources/webhook#execute-webhook).

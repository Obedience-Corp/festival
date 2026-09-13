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
limit.

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

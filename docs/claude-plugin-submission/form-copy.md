---
title: "Form copy"
weight: 2
---

# Form copy

Paste these answers into the in-app submission form. Field names change;
match on meaning. The process is in the
[submission guide]({{< ref "/claude-plugin-submission" >}}).

Verified against plugin version **1.3.1** on 2026-08-25.
`claude plugin validate ./claude-plugin --strict` passed on Claude Code 2.1.245.

Fill **Primary contact email** yourself. Do not invent one.

## Identity

**Plugin name**

```text
festival
```

**Display name** (if asked)

```text
Festival
```

**Author / organization**

```text
Obedience Corp
```

**Company / organization URL**

```text
https://obediencecorp.com
```

**License**

```text
Apache-2.0
```

**Version**

```text
1.3.1
```

**Categories / keywords** (if asked)

```text
project-management, ai-workflows, methodology, productivity, development
```

**Who is this for** (if asked)

```text
Claude Code
```

Also check Cowork if the form allows both. The community catalog feeds
both surfaces. Festival is built and verified for Claude Code.

## Links

**GitHub repository** (preferred)

```text
https://github.com/Obedience-Corp/festival
```

**Plugin subdirectory** (if the form has a path / git-subdir field)

```text
claude-plugin
```

**Homepage**

```text
https://fest.build
```

**Documentation URL**

```text
https://docs.fest.build/getting-started/agents/claude-code/
```

**Support / issues**

```text
https://github.com/Obedience-Corp/festival/issues
```

**Privacy disclosure** (if a privacy-policy URL is required)

```text
https://github.com/Obedience-Corp/festival/blob/main/claude-plugin/README.md#privacy-and-network-access
```

**Source of the plugin bundle inside the repo**

```text
https://github.com/Obedience-Corp/festival/tree/main/claude-plugin
```

## In-app description

Use this as the directory listing description. It is 82 words.

```text
Festival is a local planning and verification layer for long-running Claude Code work. The plugin teaches Claude the Festival methodology and drives the fest and camp CLIs: plan through the loop, then execute with fest next, fest task completed, and fest commit. It ships 12 skills, 11 slash commands, planner and executor agents, a checksum-verified GitHub Releases installer, and a campaign-scoped commit guard. State lives in files you own. It does not replace Claude Code; the next turn starts from fest next.
```

Shorter tagline, if the form has a 55-character field:

```text
Local planning and verification for Claude Code work.
```

(53 characters including spaces.)

## What the plugin includes

Paste if the form asks for components or a capabilities list.

```text
- 12 skills: festival-intake, fest-methodology, fest-planning, fest-execution, fest-standalone-workflows, campaign-structure, campaign-workflows, campaign-commit, camp-navigation, camp-projects, camp-workitems, cross-campaign
- 11 slash commands: /festival-plan, /fest-next, /fest-create, /fest-commit, /fest-validate, /fest-status, /fest-show, /fest-list, /fest-understand, /camp-init, /camp-intent
- 2 agents: fest-planner, fest-executor
- 2 hooks: SessionStart (install/update fest and camp from GitHub Releases with checksum verification); PreToolUse Bash (campaign-scoped commit guard)
- No MCP server, no LSP server, no remote account
```

## Network, data, and hooks

Paste if the form asks about data collection, remote services, or permissions.

```text
The plugin does not collect conversation content, chat history, or uploaded files. It does not send user data to Obedience Corp.

The SessionStart hook talks only to GitHub for the Obedience-Corp/festival repository (releases/latest, checksums, and the release archive). Downloads are checksum-verified and installed into ~/.local/bin. The hook is idempotent when fest and camp are already current, and rate-limits update checks to once per day.

The PreToolUse hook inspects Bash commands for a raw `git commit` only when the session is inside a Festival campaign and camp and jq are available. Otherwise it exits without interfering. Override with CAMP_ALLOW_RAW_GIT=1. It is a discipline guard, not a security control.
```

## Example prompts

Directory policy asks for at least three working examples.

**1. Size and plan new work**

```text
I need to add rate limiting to our API. Plan this as a festival.
```

Expected: the `festival-intake` skill / `/festival-plan` command sizes the
work out loud, proposes phases and sequences, asks before writing files,
then drives `fest create festival` and `fest next` rather than scaffolding
every sequence up front.

**2. Execute the next task**

```text
Run fest next and do exactly that task. When it is done, mark it completed and commit with fest commit.
```

Expected: `/fest-next` or `fest next` prints the next task with context;
the executor loop does the work, then `fest task completed` and
`fest commit`.

**3. Start a campaign and capture an intent**

```text
Initialize a campaign in this directory, then capture an intent to migrate auth off server sessions.
```

Expected: `/camp-init` / `camp init` writes the campaign layout;
`/camp-intent` / `camp intent add` captures the idea without jumping
straight to a festival.

## Reviewer setup

Paste if the form asks how to test, or for a test account.

```text
No hosted account. The plugin is local.

1. Clone https://github.com/Obedience-Corp/festival
2. Run: claude plugin validate ./claude-plugin --strict
3. Load: claude --plugin-dir ./claude-plugin
4. In a scratch directory: camp init -d "review sandbox" -m "try the plugin"
5. Ask Claude: "Plan a one-phase festival to add a README section, then run fest next"

Optional: /plugin marketplace add Obedience-Corp/festival && /plugin install festival@festival
```

## Compliance short answers

Use if the form has yes/no policy acknowledgments.

| Question | Answer |
| --- | --- |
| Public source | Yes |
| Collects conversation data | No |
| Connects to a third-party API you do not own | No. GitHub Releases for this repo only. |
| Transfers money or crypto | No |
| Standalone image/video/audio generation | No |
| Advertisements or sponsored content | No |
| Interferes with other tools | Commit guard is campaign-scoped and fail-open. Documented override: `CAMP_ALLOW_RAW_GIT=1`. |
| MCP / OAuth | Not applicable. No MCP server. |

## After publish

Do not re-submit this form for later commits. CI pins the community catalog
to new SHAs automatically. Confirm listing by searching
[marketplace.json](https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json)
for `festival` the day after approval.

---
title: "Claude Plugin Directory"
weight: 1
---

# Submit Festival to Anthropic's community plugin directory

This is the maintainer guide for listing the Festival Claude Code plugin on
Anthropic's **community** marketplace
([anthropics/claude-plugins-community](https://github.com/anthropics/claude-plugins-community)).

Paste-ready form answers live in [form copy]({{< ref "/claude-plugin-submission/form-copy" >}}).

The plugin bundle this listing points at is `claude-plugin/` in this repository.
User install for Claude Code is documented in
[Claude Code]({{< ref "/getting-started/agents/claude-code" >}}).

## Two marketplaces

| Marketplace | Catalog | How Festival gets on it |
| --- | --- | --- |
| Community (`claude-community`) | [anthropics/claude-plugins-community](https://github.com/anthropics/claude-plugins-community) | Submit the in-app form below. This is the listing this guide covers. |
| Official (`claude-plugins-official`) | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Anthropic curates this at their discretion. The form does **not** add plugins here. There is no public application. |

The community repo is a **read-only nightly mirror** of Anthropic's internal
review pipeline. Every plugin in it was submitted through claude.ai / Console,
passed automated validation and safety screening, and was approved.

Do **not** open a pull request against `anthropics/claude-plugins-community`.
Those PRs are closed automatically.

The short URL [clau.de/plugin-directory-submission](https://clau.de/plugin-directory-submission)
redirects at the current form.

## What Festival already has

Checked against plugin version `1.3.1` in this repo:

| Piece | Location |
| --- | --- |
| Plugin root | `claude-plugin/` |
| Manifest | `claude-plugin/.claude-plugin/plugin.json` |
| Repo-root marketplace | `.claude-plugin/marketplace.json` (`source: "./claude-plugin"`) |
| Public GitHub | [Obedience-Corp/festival](https://github.com/Obedience-Corp/festival) |
| License | Apache-2.0 |
| User docs | [Claude Code setup]({{< ref "/getting-started/agents/claude-code" >}}) |
| Bundle README | [`claude-plugin/README.md`](https://github.com/Obedience-Corp/festival/blob/main/claude-plugin/README.md) |

The bundle currently ships **12 skills**, **11 slash commands**, **2 agents**
(`fest-planner`, `fest-executor`), and **2 hooks** (`SessionStart` installer,
`PreToolUse` commit guard).

Festival is **not** in the community catalog yet. Confirm later by searching
the [community marketplace.json](https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json)
for `"name": "festival"` or `Obedience-Corp`.

## Pre-submit checks

Run these from the festival repo root before opening the form.

```bash
claude plugin validate ./claude-plugin
claude plugin validate ./claude-plugin --strict
just plugin check
```

Anthropic's review pipeline runs the same check as `claude plugin validate`,
plus automated safety screening. Warnings do not fail review unless you pass
`--strict`.

Recorded on 2026-08-25 against Claude Code **2.1.245** and plugin **1.3.1**:

```text
claude plugin validate ./claude-plugin --strict
# ✔ Validation passed
```

`just plugin check` is the stricter in-repo gate (manifests, generated
harness targets, hook script tests, CLI sync). Anthropic does not run it.
It is still the right local check before you claim the bundle is shippable.

If `claude plugin validate` fails, fix the bundle and re-run. Do not submit a
red validation.

## Who can submit

Both forms require a signed-in Anthropic account with enough permission:

- **Console** (individuals, no Team/Enterprise org): Developer, Admin, or
  Owner on a Console organization. Sign up at
  [platform.claude.com](https://platform.claude.com) if you do not have one.
  Form: [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit).
- **claude.ai** (Team or Enterprise): directory management access.
  Organization Owners have this by default. On Enterprise, an Owner can
  delegate it through a custom role with the Directory or Libraries
  permission. Form:
  [claude.ai/admin-settings/directory/submissions/plugins/new](https://claude.ai/admin-settings/directory/submissions/plugins/new).

Use Console unless Obedience Corp already has a Team/Enterprise org with
directory access. The same plugin is submitted either way.

By submitting you agree to the
[Software Directory Terms](https://support.claude.com/en/articles/13145338-anthropic-software-directory-terms)
and
[Software Directory Policy](https://support.claude.com/en/articles/13145358-anthropic-software-directory-policy).

## How to fill the form

The in-app form is the only submission path. Have the
[form copy]({{< ref "/claude-plugin-submission/form-copy" >}}) open in another
window and paste.

Required facts, whatever the field names are this week:

1. **GitHub URL:** `https://github.com/Obedience-Corp/festival`
   The repo must stay public. Closed-source plugins are rejected.
2. **Plugin path, if the form has a subdirectory field:** `claude-plugin`
   The catalog's `git-subdir` source type is how other listed plugins live
   inside a larger repo. If the form only takes a repo URL, the repo-root
   `marketplace.json` already points at `./claude-plugin`, which is what
   makes that URL resolve to the bundle.
3. **Name:** `festival`
   Must match `plugin.json`. Do not rename it after listing; updates pin
   the same name.
4. **Description:** use the in-app description in the form copy. Keep it
   accurate. Policy requires descriptions to match real behavior.
5. **Homepage / docs:** `https://docs.fest.build/getting-started/agents/claude-code/`
6. **Support:** `https://github.com/Obedience-Corp/festival/issues`
7. **Company:** Obedience Corp / `https://obediencecorp.com`
8. **Three example prompts:** in the form copy.

Do not submit a zip of the whole festival repo. If a zip option appears, it
must be the `claude-plugin/` directory only, and GitHub is still preferred.

## What review will look at

Festival is a skills + commands + agents + hooks plugin with **no MCP
server**. That is allowed. The likely review points are the hooks, not the
markdown.

### SessionStart installer

`claude-plugin/hooks/scripts/ensure-festival.sh` downloads `fest` and `camp`
from GitHub Releases into `~/.local/bin` when they are missing, checksums
the archive, and checks for updates once a day.

Directory policy treats community plugins as able to install additional
local software. Be explicit in the listing that:

- the only network destination is `api.github.com` / GitHub Releases for
  `Obedience-Corp/festival`
- archives are checksum-verified
- the hook is idempotent when the binaries are already current
- no conversation content is sent to Obedience Corp

### PreToolUse commit guard

`claude-plugin/hooks/scripts/commit-guard.sh` blocks a raw `git commit`
inside a campaign so commits go through `camp commit`, `camp p commit`, or
`fest commit`.

Policy forbids interfering with other tools unless the user intended it.
The guard is written to fail open. It only blocks when all of these hold:

- the command has a raw `git commit` segment
- the session is inside a campaign (`camp id` succeeds)
- `camp` and `jq` are both available

Override for one command: `CAMP_ALLOW_RAW_GIT=1`. It does not try to defeat
`bash -c`, aliases, or `eval`. State that in the listing so it is not read
as a sandbox escape or as a global git interceptor.

### Skill and command descriptions

Descriptions must say what the component does and when to use it, and must
not claim features the bundle does not ship. Current skill descriptions
already lead with "Use when ...". Do not rewrite them for the form in a way
that overclaims (for example "auto-activates on every session").

### Developer requirements that apply

From the Software Directory Policy:

| Requirement | Festival answer |
| --- | --- |
| Public source | Yes. |
| Documented purpose and troubleshooting | Plugin README + Claude Code setup page. |
| Support channel | GitHub issues. |
| Three working example prompts | Form copy. |
| Privacy policy if you collect user data or connect to a remote service | The plugin does not collect chat data. The installer fetches our own GitHub Releases. The Privacy section in the plugin README is the disclosure. |
| Test account with sample data | Not applicable. There is no hosted account. Reviewers can `camp init` locally. |
| You own the endpoints the plugin talks to | GitHub Releases for `Obedience-Corp/festival`. |
| No financial transactions, no standalone generative media, no ads | Holds. |

A reviewer who clones the repo should be able to:

```bash
claude plugin validate ./claude-plugin
claude --plugin-dir ./claude-plugin
```

then run `/fest-next` after `camp init` and `fest create festival` in a
scratch campaign. The SessionStart hook will try to install the CLIs if
they are missing.

## After you submit

On claude.ai, status is at
[claude.ai/admin-settings/directory/submissions](https://claude.ai/admin-settings/directory/submissions).
Review time varies with queue volume.

If approved:

- The community catalog pins a specific commit SHA.
- CI bumps that pin as you push to the GitHub repo. You do **not**
  re-submit the form for ordinary updates.
- The public `marketplace.json` syncs **nightly**, so approval and
  appearance can be a day apart.
- Confirm by searching the
  [community catalog](https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json).

Expected catalog shape, once listed:

```json
{
  "name": "festival",
  "source": {
    "source": "git-subdir",
    "url": "Obedience-Corp/festival",
    "path": "claude-plugin",
    "ref": "main",
    "sha": "<pinned commit>"
  }
}
```

Users then install with:

```text
/plugin marketplace add anthropics/claude-plugins-community
/plugin install festival@claude-community
```

or from a shell:

```bash
claude plugin marketplace add anthropics/claude-plugins-community
claude plugin install festival@claude-community
```

The existing self-hosted marketplace
(`/plugin marketplace add Obedience-Corp/festival`) keeps working. Community
listing is extra discovery, not a replacement.

After it appears, update
[Claude Code]({{< ref "/getting-started/agents/claude-code" >}})
and `claude-plugin/README.md` to mention the `@claude-community` install
path alongside the self-hosted one.

## Official marketplace

`claude-plugins-official` is separate. Anthropic decides what goes there.
The community form will not put Festival on it.

The CLI install-hint protocol
(`<claude-code-hint … value="festival@claude-plugins-official" />`) only
fires for official-marketplace plugins. Do not emit that hint until
Anthropic lists Festival there. If you have an Anthropic partner contact,
that is the path for an official listing, not this form.

## Checklist

Do these in order:

1. `claude plugin validate ./claude-plugin --strict` prints `✔ Validation passed`.
2. `just plugin check` is green, or you know why it is not and it is not a
   bundle-manifest problem.
3. `claude-plugin/.claude-plugin/plugin.json` `version` matches
   `.claude-plugin/marketplace.json`.
4. Repo is public at `https://github.com/Obedience-Corp/festival`.
5. Plugin README Privacy section is current.
6. You are signed in as Console Developer/Admin/Owner, or as a claude.ai
   Owner (or delegated Directory role) on a Team/Enterprise org.
7. Paste the [form copy]({{< ref "/claude-plugin-submission/form-copy" >}})
   into [the Console form](https://platform.claude.com/plugins/submit) or
   [the claude.ai form](https://claude.ai/admin-settings/directory/submissions/plugins/new).
8. After submit, record the date and the account that submitted in the
   release notes or this page's git history. Do not re-submit for later
   commits.

## References

- [Create plugins: submit to the community marketplace](https://code.claude.com/docs/en/plugins#submit-your-plugin-to-the-community-marketplace)
- [Submitting your plugin](https://claude.com/docs/plugins/submit)
- [Discover plugins](https://code.claude.com/docs/en/discover-plugins)
- [Plugin manifest schema](https://code.claude.com/docs/en/plugins-reference#plugin-manifest-schema)
- [Software Directory Policy](https://support.claude.com/en/articles/13145358-anthropic-software-directory-policy)
- [Software Directory Terms](https://support.claude.com/en/articles/13145338-anthropic-software-directory-terms)

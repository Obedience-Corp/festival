# Survey: Hermes Agent skills (verified 2026-08-17)

Verdict: STRONG fit for skills, NARROW surface otherwise. Hermes Agent (Nous Research, MIT) has no
plugin manifest we can ship components through, so the target emits a skills tap only: one
`skills/<name>/SKILL.md` tree at the repo root that Hermes and skills.sh both read.

## Manifest
- NONE. A Hermes tap is a directory layout, not a manifest: any GitHub repo laid out as
  `skills/<name>/SKILL.md` (plus optional `references/`, `templates/`, `scripts/`) is installable.
- Optional repo-page config: `skills.sh.json` at the repo root (`$schema`
  `https://skills.sh/schemas/skills.sh.schema.json`, required `groupings` array of
  `{title, description?, skills[]}`, optional `notGrouped`). Schema fetched and verified 2026-08-18;
  it sets `additionalProperties: false`, so the file carries no `_generated` banner key.
- SKILL.md frontmatter Hermes recognizes: `name`, `description`, `version`, `author`, `license`,
  `platforms`, `metadata.hermes.{tags, category, related_skills, requires_toolsets, requires_tools,
  fallback_for_toolsets, fallback_for_tools, config, blueprint}`, `required_environment_variables`,
  `required_credential_files`.
- Source: https://github.com/NousResearch/hermes-agent `website/docs/user-guide/features/skills.md` ;
  `website/docs/developer-guide/creating-skills.md`

## Capability surface
- Skills: YES. `~/.hermes/skills/` is the store; hub, tap, `well-known` and direct-URL installs all
  land there with no trust step and no config edit. Compatible with the agentskills.io open
  standard, so the source SKILL.md files port as-is; `metadata.hermes.*` is additive and ignored by
  other tools.
- Commands: NO. Hermes has no command concept outside its plugin system; a skill is invoked as
  `/skill-name` (up to 5 stacked) or by natural language. Festival's slash commands do not bundle.
  Source: `website/docs/user-guide/features/skills.md`
- Agents: NO. Delegation is a built-in tool (`delegate_task`), not a bundle of agent definitions, so
  Festival's agents do not ship here either.
  Source: `website/docs/user-guide/features/delegation.md`
- Hooks: NOT from a skill. Shell hooks live in the user's `config.yaml` and native hooks live in a
  Python plugin; neither travels with an installed skill, and a skill cannot run code at load. So
  there is no session-start auto-install equivalent to the Codex/Gemini `SessionStart` hook. The
  documented substitute is an install snippet the user runs once (`install.sh`, brew, npm).
  Source: `website/docs/user-guide/features/hooks.md` ; `website/docs/user-guide/features/plugins.md`
- Context file: YES, `AGENTS.md` is read. Precedence is winner-take-one
  (`.hermes.md` > `AGENTS.override.md` > `AGENTS.md` > `CLAUDE.md` > `.cursorrules`): only the first
  match loads, so a `.hermes.md` would REPLACE the campaign's `AGENTS.md`, never supplement it.
  Source: `website/docs/user-guide/features/context-files.md`
- PATH: the default `local` terminal backend passes `PATH` through (only named Hermes secrets are
  stripped), so `fest` and `camp` are reachable with zero config. The five sandboxed backends
  (docker, singularity, modal, daytona, vercel_sandbox) use the container's `PATH`, so binaries must
  be baked into the image there.
  Source: `website/docs/user-guide/security.md`

## Install decision
NO auto-install. Every other target installs the CLIs from a session-start-style hook; Hermes gives
a skill no such hook, so the docs carry an install snippet instead and each generated skill states
that a tap ships instructions, not binaries. `skills/README.md` (generated) leads with the CLI
install and the three channels.

## Distribution decision
GitHub tap plus skills.sh, from one tree:
- `hermes skills tap add Obedience-Corp/festival` then
  `hermes skills install Obedience-Corp/festival/skills/<name>`, or a single-skill install without
  subscribing to the tap. No server, no marketplace account, no review queue.
- The same `skills/<name>/SKILL.md` layout is what skills.sh reads, so
  `npx skills add Obedience-Corp/festival` reaches non-Hermes agents from the identical tree;
  `skills.sh.json` only controls how the repo page groups them.
- Optional later: publish `/.well-known/skills/index.json` on fest.build so
  `hermes skills search https://fest.build --source well-known` resolves. Not generated yet.
- Project-local skills (`<repo>/.agents/skills`, which `camp init` already writes) are a different
  path: they need `hermes skills trust` once per repo root and are never auto-trusted on
  non-interactive surfaces (cron, API, ACP). The tap avoids that step entirely.

## Flags
- Every non-official install runs a security scanner (data exfiltration, prompt injection,
  destructive commands, shell injection). `--force` overrides a `caution` verdict but never a
  `dangerous` one. The shell-heavy Festival skills have not been scanned yet; the release plan's
  acceptance criteria require a recorded verdict per skill.
- Hermes house style asks for descriptions under 60 characters and a fixed body order
  (`When to Use`, `Quick Reference`/`Procedure`, `Pitfalls`, `Verification`). The target keeps the
  source descriptions and body verbatim on purpose: whether `hermes skills check` rejects or merely
  warns is an open spike question (Q4 in the design workitem), and shortening descriptions would
  degrade trigger accuracy for every other harness that shares the source.
- Context-file precedence is the sharpest user-facing hazard: a user who drops a `.hermes.md` next
  to a campaign `AGENTS.md` silently loses the campaign instructions.
- Headless approvals (`approvals.single_query_mode`, `approvals.cron_mode`) default to `deny`, so an
  unattended `hermes -z` run refuses flagged shell commands rather than escalating. Matters for
  anyone scripting the loop, not for the tap itself.

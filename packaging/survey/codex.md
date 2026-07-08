# Survey: OpenAI Codex CLI plugins (verified 2026-06-16)

Verdict: STRONG fit. Codex shipped a real plugin system (~March 2026).

## Manifest
- `plugins/festival/.codex-plugin/plugin.json` for the generated repo-local plugin bundle (legacy `.claude-plugin/marketplace.json` honored).
- Required: `name` (kebab), `version` (semver), `description`.
- Optional: `author`, `homepage`, `repository`, `license`, `keywords`, `skills` (e.g. `"./skills/"`),
  `mcpServers`, `apps`, `hooks` (path/array/inline), `interface` (displayName, shortDescription,
  category, capabilities, defaultPrompt, brandColor, logo, screenshots).
- Source: https://developers.openai.com/codex/plugins/build ; https://github.com/openai/plugins

## Capability surface
- Skills: YES. `"skills": "./skills/"` -> `skills/<name>/SKILL.md`. Recommended primitive.
- Commands: NOT clearly plugin-bundled. Standalone custom prompts (`~/.codex/prompts/*.md`) are
  DEPRECATED in favor of skills; the manifest spec lists no `commands` field. Do not depend on
  bundling Festival's 10 slash commands as Codex plugin components.
  Source: https://developers.openai.com/codex/custom-prompts ; .../cli/slash-commands
- Agents: config scope only (`~/.codex/agents/`, `.codex/agents/` TOML); no manifest `agents` field
  confirmed. Don't depend on bundling Festival's 2 agents.
  Source: https://developers.openai.com/codex/subagents
- Hooks: YES. `SessionStart` event; handler `type: "command"` runs any executable, with `cwd`,
  `PLUGIN_ROOT`/`PLUGIN_DATA`. Wired via `"hooks": "./hooks/hooks.json"`.
  Source: https://developers.openai.com/codex/hooks
- AGENTS.md: YES, read as persistent instructions (precedence chain, 32 KiB cap).
  Source: https://developers.openai.com/codex/guides/agents-md

## Install decision
AUTO-INSTALL via a `SessionStart` command hook running the `fest`/`camp` installer (idempotent
"already installed?" guard; runs every session-start; respects Codex sandbox). Same shape as the
Claude Code `ensure-festival.sh` hook.

## Distribution decision
Self-hosted marketplace: repo-root `marketplace.json` (`$REPO_ROOT/.agents/plugins/marketplace.json`
or legacy `.claude-plugin/marketplace.json`) + users run `/plugin marketplace add Obedience-Corp/festival`,
`/plugin install festival@...`. OpenAI's official curated directory exists but SELF-SERVE PUBLISHING IS
NOT OPEN YET ("coming soon"). The Superpowers `prime-radiant-inc/openai-codex-plugins` fork-PR flow is
UNVERIFIED / uncorroborated by current OpenAI docs -- do NOT build sync tooling around it.
Source: https://developers.openai.com/codex/plugins/build ; community: https://codex.danielvaughan.com/2026/04/11/codex-marketplace-plugin-distribution/

## Flags
- Plugin-bundled `commands/` and `agents/` dirs appear in the openai/plugins repo structure but are
  not in the manifest spec; verify against a live example before relying on them.

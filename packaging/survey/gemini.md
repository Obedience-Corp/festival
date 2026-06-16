# Survey: Gemini CLI extensions (verified 2026-06-16)

Verdict: STRONG fit (auto-install IS possible -- reverses the planning assumption). Source:
google-gemini/gemini-cli docs + geminicli.com.

## Manifest: gemini-extension.json
- Required: `name`, `version`.
- Optional: `description`, `contextFileName` (defaults to `GEMINI.md`), `mcpServers`, `excludeTools`,
  `settings` (name/description/envVar/sensitive), `themes`, `migratedTo`, `plan`.
- Note: `contextFiles` (plural) is NOT a field; the singular `contextFileName` is real. Several
  capabilities come by directory convention, not manifest keys.
- Source: https://geminicli.com/docs/extensions/reference/ ; docs/extensions/writing-extensions.md

## Context + @-imports
- `GEMINI.md` (or `contextFileName`) loads as context at session start; modularize with `@path.md`
  import lines (relative or absolute, `.md` only).
- CAVEAT: recursive/nested imports are NOT supported (issue #15544 closed as not planned). So
  `GEMINI.md` can `@`-import each skill's `SKILL.md` directly (one level), but those SKILL.md files
  cannot `@`-import deeper and expect expansion.
- Source: docs/cli/gemini-md.md ; issue #15544

## Capability surface
- Commands: YES, TOML in `commands/` (can run shell via `!{...}`, but USER-triggered + confirmation).
- MCP servers: YES (`mcpServers`). Skills (`skills/`), agents (`agents/*.md`), themes, policies.
- Hooks: YES -- `hooks/hooks.json`, `type: "command"`, runs arbitrary shell at the `SessionStart`
  event (startup/resume/clear). THIS is the auto-install mechanism.
  Source: docs/hooks/index.md ; docs/hooks/reference.md

## Install decision
AUTO-INSTALL via a `SessionStart` command hook in `hooks/hooks.json` running an idempotent
install/check script. (Synchronous -> gate with a fast "already installed?" check; re-fires on every
startup/resume/clear; no first-install-only event.) This REVERSES the earlier "Gemini = documented
manual install" assumption.

## Distribution decision
`gemini extensions install <org>/<repo>` (GitHub shorthand) with `--ref=` pinning; plain-git or
GitHub-Releases modes; `gemini extensions update`. Auto-indexed gallery at geminicli.com/extensions
(add the `gemini-cli-extension` repo topic + manifest at archive root).
Source: https://geminicli.com/docs/extensions/releasing/ ; .../extensions/

## Flags
- Hooks/extension-hooks surface is actively evolving; pin to a tested Gemini CLI version.

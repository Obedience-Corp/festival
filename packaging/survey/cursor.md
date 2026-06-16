# Survey: Cursor plugins (verified 2026-06-16)

Verdict: STRONG fit (one install caveat). Native plugin system shipped Cursor 2.5 (2026-02-17),
distinct from VS Code extensions.

## Manifest
- `.cursor-plugin/plugin.json` at the plugin root (matches the Superpowers snapshot).
- Required: `name` (lowercase kebab).
- Optional: `description`, `version`, `author`, `homepage`, `repository`, `license`, `keywords`,
  `logo`, and component-path fields: `rules`, `agents`, `skills`, `commands`, `hooks`, `mcpServers`.
- Auto-discovery defaults: `rules/`, `skills/<dir>/SKILL.md`, `agents/`, `commands/`,
  `hooks/hooks.json`, `mcp.json` (override via manifest field).
- Source: https://cursor.com/docs/reference/plugins ; https://github.com/cursor/plugins README

## Capability surface (all four bundle)
- Skills/rules: YES (`skills/<name>/SKILL.md`; rules `.mdc`).
- Commands: YES (`commands/*.md`).
- Agents: YES (`agents/*.md`).
- Hooks: YES (`hooks/hooks.json`). MCP servers: YES (`mcp.json`).
- Source: https://cursor.com/docs/reference/plugins ; https://cursor.com/docs/hooks
- Note: Superpowers' `hooks-cursor.json` is a non-default filename (valid via explicit `hooks`
  path override); the spec default is `hooks/hooks.json`.

## Install decision
AUTO-INSTALL, but NOT via `sessionStart` (it is fire-and-forget; the agent loop does not wait, so a
binary install is not guaranteed complete before use). Use a BLOCKING hook instead
(`beforeShellExecution`/`preToolUse`, which can block via permission decisions), or ship the install
as an MCP server, or an explicit install command. Hook `command` accepts an arbitrary shell string.
Source: https://cursor.com/docs/hooks

## Distribution decision
Cursor Marketplace (cursor.com/marketplace). Submit the public Git repo at
cursor.com/marketplace/publish (MANUAL REVIEW). In-editor install `/add-plugin`. Multi-plugin repos:
`.cursor-plugin/marketplace.json` at repo root. Team Marketplaces (private) added in 2.6. Community:
cursor.directory.
Source: https://cursor.com/docs/plugins ; https://cursor.com/changelog/2-5

## Flags
- No documented BLOCKING "install + wait" at session start; the install pattern is the one weak spot.

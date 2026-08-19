# Festival plugin distribution

How each generated target reaches users. Every decision cites the verified survey under
`packaging/survey/` (decision D006, revised: publish where a real channel exists, document the
in-repo surface where it does not). No fork-PR sync exists; the Superpowers
`openai-codex-plugins` flow was unverified and is not used.

## Codex

- **Channel**: self-hosted marketplace. The generator emits `.agents/plugins/marketplace.json`
  pointing at `plugins/festival/`.
- **Install**: `/plugin marketplace add Obedience-Corp/festival` then `/plugin install festival`.
- **Note**: OpenAI's official curated directory has no self-serve publishing yet ("coming soon").
- **Surface**: `plugins/festival/` + `.agents/plugins/marketplace.json` (generated, drift-covered).
- Source: `packaging/survey/codex.md`.

## Cursor

- **Channel**: Cursor Marketplace. Submit the public git repo at `cursor.com/marketplace/publish`
  (MANUAL review); in-editor install is `/add-plugin`. This is a one-time human web submission, not a
  scriptable sync. Multi-plugin repos may add a `.cursor-plugin/marketplace.json`; Festival is a
  single plugin, so `.cursor-plugin/plugin.json` is the distribution unit.
- **Surface**: the in-repo `.cursor-plugin/` (generated, drift-covered).
- Source: `packaging/survey/cursor.md`.

## opencode

- **Channel**: no official curated marketplace. Distribute as an npm package
  (`npm publish` / `bun publish`) or a git URL referenced in a user's `opencode.json` `plugin` array;
  list on the community `awesome-opencode` repo. No review pipeline, so nothing to script here.
- **Surface**: the in-repo `.opencode/` (plugin js + skills + INSTALL.md, generated, drift-covered).
- Source: `packaging/survey/opencode.md`.

## Gemini

- **Channel**: `gemini extensions install Obedience-Corp/festival` (GitHub shorthand) installs the
  repo directly, with `--ref=` pinning; `gemini extensions update` updates it. The gallery at
  `geminicli.com/extensions` auto-indexes repos carrying the `gemini-cli-extension` topic, so
  publishing is "add the repo topic," not a scripted push.
- **Surface**: the repo root itself (`gemini-extension.json` + `GEMINI.md`, generated, drift-covered).
- Source: `packaging/survey/gemini.md`.

## Hermes Agent

- **Channel**: GitHub skills tap. A tap is any repo laid out as `skills/<name>/SKILL.md`, so the
  generated root `skills/` tree IS the distribution artifact; there is no manifest, no server, and
  no review queue. `skills.sh.json` (also generated) only controls how skills.sh groups the repo
  page.
- **Install**: `hermes skills tap add Obedience-Corp/festival` then
  `hermes skills install Obedience-Corp/festival/skills/<name>`, or a single-skill install without
  subscribing to the tap. Skills land in `~/.hermes/skills/` and need no trust step.
- **Also reaches non-Hermes agents**: the same tree is what skills.sh reads, so
  `npx skills add Obedience-Corp/festival` installs the identical 12 skills elsewhere.
- **Note**: a tap ships instructions, not binaries. Hermes has no hook an installed skill can use,
  so users install `fest` and `camp` themselves (`install.sh`, Homebrew, npm). Optional later: a
  `/.well-known/skills/index.json` on fest.build for `hermes skills search --source well-known`.
- **Surface**: root `skills/` + `skills.sh.json` (generated, drift-covered).
- Source: `packaging/survey/hermes.md`.

## Summary

Only Codex needs a generated distribution artifact (`marketplace.json`). Cursor is a manual web
submission, and opencode, Gemini, and Hermes install straight from the git repo, so for those four
the distribution surface is the in-repo generated target plus its INSTALL notes. The acceptance sweep
(sequence 08) proves each path with a `--dry-run` or no-push check and captures the output.

# Festival plugin distribution

How each generated target reaches users. Every decision cites the verified survey under
`packaging/survey/` (decision D006, revised: publish where a real channel exists, document the
in-repo surface where it does not). No fork-PR sync exists; the Superpowers
`openai-codex-plugins` flow was unverified and is not used.

## Codex

- **Channel**: self-hosted marketplace. The generator emits `.agents/plugins/marketplace.json`
  pointing at `plugins/festival/`.
- **Install**: `codex plugin marketplace add Obedience-Corp/festival` then `codex plugin add festival@festival`
  (in a session, `/plugins` opens the plugin browser).
- **Note**: OpenAI's official curated directory has no self-serve publishing yet ("coming soon").
- **Surface**: `plugins/festival/` + `.agents/plugins/marketplace.json` (generated, drift-covered).
- Source: `packaging/survey/codex.md`.

## Cursor

- **Channel**: Cursor Marketplace. Submit the public git repo at `cursor.com/marketplace/publish`
  (MANUAL review). This is a one-time human web submission, not a scriptable sync. Once listed,
  users install from **Customize** in the Cursor sidebar (project or user scope). Cursor documents
  no `/add-plugin` command. The Cursor CLI (2026.10.01) has `agent plugin marketplace add <gitUrl>`,
  which needs a login, clones the URL, and registers the marketplace on the Cursor account; its
  plugins then install from the CLI's interactive `/plugins` view.
- **Layout**: Cursor loads the directory that contains `.cursor-plugin/` as the plugin root, so the
  plugin is the self-contained `cursor-plugin/` (`cursor-plugin/.cursor-plugin/plugin.json`), and the
  repo root carries only `.cursor-plugin/marketplace.json`, whose one entry points at
  `source: "./cursor-plugin"`.
- **Other channels**: local install by copying `cursor-plugin/` to `~/.cursor/plugins/local/festival`
  (a symlink to a clone elsewhere is skipped by Cursor); one CLI session with
  `agent --plugin-dir <clone>/cursor-plugin`; Teams and Enterprise admins can use
  **Dashboard -> Plugins & MCPs -> Add Marketplace -> Import from Repo** with the repo URL, which
  reads `.cursor-plugin/marketplace.json`.
- **Surface**: `cursor-plugin/` + `.cursor-plugin/marketplace.json` (generated, drift-covered).
- Source: `packaging/survey/cursor.md`; current Cursor plugin reference at
  `cursor.com/docs/reference/plugins` and `cursor.com/docs/plugins`.

## opencode

- **Channel**: no official curated marketplace. Distribute as an npm package
  (`npm publish` / `bun publish`) or a git URL referenced in a user's `opencode.json` `plugin` array;
  list on the community `awesome-opencode` repo. No review pipeline, so nothing to script here.
- **Surface**: the in-repo `.opencode/` (plugin js + skills + INSTALL.md, generated, drift-covered).
- Source: `packaging/survey/opencode.md`.

## Gemini

- **Channel**: `gemini extensions install https://github.com/Obedience-Corp/festival` installs from
  the latest release (Gemini CLI documents the full URL, not owner/repo shorthand), with `--ref=`
  pinning; `gemini extensions update` updates it. The gallery at `geminicli.com/extensions` indexes
  public repos with `gemini-extension.json` at the root and the `gemini-cli-extension` topic, crawled
  daily, so publishing is "add the repo topic," not a scripted push. Festival is listed there
  (checked 2026-10-08) although the repo does not currently carry the topic.
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

Codex and Cursor each have a generated marketplace manifest (`.agents/plugins/marketplace.json`,
`.cursor-plugin/marketplace.json`). Cursor's public listing is still a manual web submission, and
opencode, Gemini, and Hermes install straight from the git repo, so for those three the distribution
surface is the in-repo generated target plus its INSTALL notes. The acceptance sweep
(sequence 08) proves each path with a `--dry-run` or no-push check and captures the output.

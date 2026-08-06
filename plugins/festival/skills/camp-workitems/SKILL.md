---
name: camp-workitems
description: Find, filter, choose, create, or adopt campaign work items with `camp workitem`, `camp wi`, or `camp workitems`. Use when a user wants current active work across intents, designs, explore notes, festivals, or tracked workflow directories; when agents need safe `camp workitem --json` output; or when creating/adopting tracked workflow folders.
---

# Camp Workitems

Use `camp workitem` to find current campaign work across intents, workflow
design/explore docs, festivals, and tracked workflow directories.

`camp workitem` is canonical. `camp wi` and `camp workitems` are aliases.

## Discover

Agents and scripts should prefer JSON:

```bash
camp workitem --json
camp workitem --json --type design --query auth
camp workitem --json --type intent --stage ready --limit 5
```

Use path output only when shell integration needs a destination:

```bash
camp workitem --print --type festival
```

Non-interactive use requires `--json` or `--print`.

Useful filters:

- `--type intent|design|explore|festival|<custom>`
- `--stage inbox|active|ready|planning`
- `--query <text>`
- `--limit <n>`

## Interactive

```bash
camp workitem
```

Use the TUI for human browsing, prioritization, and selection.

## Create Or Adopt

Use custom workitems for `workflow/<type>/<slug>` directories that should
appear in discovery.

```bash
camp workitem create <slug> --type feature --title "Human title"
camp workitem adopt workflow/feature/existing-dir --type feature --title "Human title"
```

Slug and type values must be path-safe: no `/`, `\`, whitespace, or control
characters; no leading `.` or `-`; max 80 characters.

## Avoid

- Running the interactive TUI from an agent session instead of using `--json`.
- Hand-writing tracking metadata for custom workitems. Use
  `camp workitem create` or `camp workitem adopt` so discovery state stays
  compatible.
- Editing `.campaign/settings/workitems.json` manually. It is tool-managed
  priority state, not the work-item source of truth.

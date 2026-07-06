---
title: "Plugin Authoring"
---

# Plugin Authoring

Festival and Camp can be extended by installable plugins. A plugin may be a
single executable, or it may be an executable plus support files such as scripts,
schemas, static web assets, templates, or default config.

## Runtime Asset Directory

Obedience Corp plugins should store managed runtime assets under:

```text
~/.obey/plugins/<plugin-name>/
```

Use a normalized plugin name: lowercase, hyphen-separated, and stable across
releases. For example, the Camp Timeline plugin uses:

```text
~/.obey/plugins/camp-timeline/
```

This is the first-class location for plugin-owned files that need to be
discoverable after installation. It keeps plugin assets in the same ecosystem
tree as `~/.obey/campaign`, `~/.obey/fest`, and other Obedience Corp state.

## Recommended Layout

A plugin that needs support assets should use a predictable layout:

```text
~/.obey/plugins/<plugin-name>/
|-- bin/                 # optional plugin-local executables
|-- config/              # optional packaged or user-editable config
|-- data/                # generated plugin data
|-- output/              # generated reports or artifacts
|-- scripts/             # Python, shell, or helper runtime files
|-- schemas/             # JSON schemas or runtime specs
`-- web/                 # static browser assets, if any
```

Only create the directories the plugin actually needs.

## Binary Behavior

Plugin binaries should not require the user to run them from the source repo.
When a plugin needs support files, its CLI should resolve an asset root in a
clear order:

1. an explicit CLI flag
2. a plugin-specific environment variable, such as `CAMP_TIMELINE_ROOT`
3. the source checkout, for local development
4. an executable-adjacent package layout, such as `share/<plugin-name>`
5. `~/.obey/plugins/<plugin-name>`

Executable-adjacent `share/<plugin-name>` layouts are useful for Homebrew,
Linux packages, and archives, but they are packaging fallbacks. The Obedience
Corp plugin install convention remains `~/.obey/plugins/<plugin-name>`.

## Install and Doctor Commands

Plugins that ship assets should provide a command or installer step that copies
those assets into the managed directory. For example:

```bash
camp timeline install-assets
```

Plugins should also expose a doctor check that reports:

- the selected runtime asset root
- the source of that selection, such as an environment variable or default path
- missing required files
- the command or environment variable needed to repair the install

## Relationship To Command Plugins

Camp and Fest also support git-style command plugins discovered from `PATH`,
such as `camp-<name>` or `fest-<name>`. That executable discovery mechanism is
separate from the runtime asset convention.

If a command plugin has no support files, installing the executable on `PATH`
may be enough. If it has support files, those files should still live under
`~/.obey/plugins/<plugin-name>`.

---
title: "camp settings get"
linkTitle: "camp settings get"
description: "Print camp settings"
---

## camp settings get

Print camp settings

### Synopsis

Print camp settings non-interactively.

With no key, prints all settings including the effective theme. With a key,
prints just that value.

Keys:
  global.theme               Color theme in ~/.obey/campaign/config.json
  global.editor              Preferred editor
  global.campaigns_dir       Where camp create places new campaigns
  global.verbose             Verbose output
  global.no_color            Disable colored output
  local.theme_override       Campaign-local theme override (requires a campaign)
  local.campaign.name        Campaign name in .campaign/campaign.yaml
  local.campaign.description Campaign description
  local.campaign.mission     Campaign mission
  local.campaign.type        Campaign type (product, research, tools, personal)
  local.campaign.commit_hook Commit-message hook command

The campaign.yaml list and tree fields (intents.tags, concepts) have no flat
key and are edited only through the interactive 'camp settings' TUI.

```
camp settings get [key] [flags]
```

### Examples

```
  camp settings get
  camp settings get global.theme
  camp settings get --json
```

### Options

```
  -h, --help   help for get
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings](../camp_settings/)	 - Manage camp configuration

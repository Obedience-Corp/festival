---
name: cross-campaign
description: Discover and reference other campaigns, projects, and files across campaign boundaries. Use when the user mentions another campaign by name, references work done "in another project/campaign", or needs to find/copy/compare code across campaigns.
---

# Cross-Campaign Operations

When the user references another campaign or a project that isn't in the current campaign, use these commands to locate and access it.

## Discovery

```bash
camp list                    # Show all registered campaigns with paths
camp list --format json      # JSON output for scripting
camp list --format simple    # Names only
```

## Navigation

```bash
camp switch <name>           # Switch to campaign (interactive if no name)
camp switch <name> --print   # Print path only (for cd or scripting)
cd "$(camp switch --print <name>)"  # Navigate without shell init
```

## Reading From Another Campaign

Use the path from `camp list` to read files directly:

```bash
# Get the path
camp list --format json | jq -r '.[] | select(.name=="My_Tools") | .path'

# Or just read camp list output and use the path
cat "$(camp switch --print My_Tools)/projects/samantha/main.go"
```

## Transferring Files Between Campaigns

```bash
camp transfer other-campaign:docs/design.md docs/          # Pull file here
camp transfer docs/plan.md other-campaign:docs/plan.md     # Push file there
camp transfer other:festivals/F001/ festivals/reference/    # Pull directory
```

Syntax: `campaign-name:relative/path`. Paths without a prefix resolve to the current campaign.

## Common User Phrases That Trigger This Skill

- "In the X campaign, there's a project called..."
- "We implemented this in another campaign..."
- "Check how Y was done in Z campaign"
- "Pull/copy that file from the other campaign"
- "Find which campaign has project X"

## Workflow

1. Run `camp list` to find the target campaign
2. Use the path to read/explore the referenced code
3. If the user wants to copy something, use `camp transfer`
4. If you need extended work in the other campaign, use `camp switch`

## Common Mistakes

- Asking the user for the campaign path instead of running `camp list`
- Forgetting that `camp transfer` copies, never moves
- Using `camp switch` when you only need to read a file (just use the path from `camp list`)
- Not checking `camp list` when the user says "the other campaign" or references a project you can't find locally

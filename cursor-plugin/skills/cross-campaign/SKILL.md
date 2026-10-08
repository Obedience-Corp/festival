---
name: cross-campaign
description: Discover and reference other camps, projects, and files across camp boundaries. Use when the user mentions another camp or campaign by name, references work done "in another project/camp", or needs to find/copy/compare code across camps.
---

# Cross-Camp Operations

A camp was previously called a campaign; treat the two words as the same thing
whenever the user says either one.

When the user references another camp or a project that isn't in the current
camp, use these commands to locate and access it.

## Discovery

```bash
camp list                    # Show all registered camps with paths
camp list --format json      # JSON output for scripting
camp list --format simple    # Names only
```

## Navigation

```bash
camp switch <name>           # Switch to a camp (interactive if no name)
camp switch <name> --print   # Print path only (for cd or scripting)
cd "$(camp switch --print <name>)"  # Navigate without shell init
```

## Reading From Another Camp

Use the path from `camp list` to read files directly:

```bash
# Get the path
camp list --format json | jq -r '.[] | select(.name=="My_Tools") | .path'

# Or just read camp list output and use the path
cat "$(camp switch --print My_Tools)/projects/samantha/main.go"
```

## Transferring Files Between Camps

```bash
camp transfer other-camp:docs/design.md docs/          # Pull file here
camp transfer docs/plan.md other-camp:docs/plan.md     # Push file there
camp transfer other:festivals/F001/ festivals/reference/    # Pull directory
```

Syntax: `camp-name:relative/path`. Paths without a prefix resolve to the
current camp.

## Common User Phrases That Trigger This Skill

- "In the X camp, there's a project called..." (or "in the X campaign...")
- "We implemented this in another camp..."
- "Check how Y was done in Z camp"
- "Pull/copy that file from the other camp"
- "Find which camp has project X"

## Workflow

1. Run `camp list` to find the target camp
2. Use the path to read/explore the referenced code
3. If the user wants to copy something, use `camp transfer`
4. If you need extended work in the other camp, use `camp switch`

## Common Mistakes

- Asking the user for the camp path instead of running `camp list`
- Forgetting that `camp transfer` copies, never moves
- Using `camp switch` when you only need to read a file (just use the path from `camp list`)
- Not checking `camp list` when the user says "the other camp" (or "campaign") or references a project you can't find locally

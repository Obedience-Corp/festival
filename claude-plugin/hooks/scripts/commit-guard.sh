#!/usr/bin/env bash
# PreToolUse (Bash) guard: block raw `git commit` inside a campaign workspace.
#
# Ships with the Festival Claude Code plugin. Unlike a campaign-local hook, this
# fires in every session the plugin is enabled in, so it self-scopes: it only
# enforces when the Bash command is a raw `git commit` AND the session is inside
# a campaign (detected via `camp id`). Outside a campaign, when `camp` or `jq`
# is missing, or when the command is not a raw commit, it exits 0 (fails open)
# so it never blocks unrelated repositories.
#
# Commit discipline: commits must route through the camp/fest wrappers so
# festival traceability and campaign bookkeeping are preserved. See the
# campaign-commit skill.
set -u

# jq parses the tool payload safely. If it is absent, fail open rather than
# guessing at JSON with a regex and risking a false block.
command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)"
[ -z "$command" ] && exit 0

# Deliberate escape hatch.
[ "${CAMP_ALLOW_RAW_GIT:-}" = "1" ] && exit 0

# Cheap check first so the common case (any non-commit Bash call) exits without
# spawning `camp`. `git` followed (past any global options) by the `commit`
# subcommand; command separators (; & |) bound the match so `git add && camp
# commit` stays safe.
printf '%s' "$command" | grep -Eq '(^|[^[:alnum:]])git[[:space:]]+([^;&|]* )?commit([[:space:]]|$)' || exit 0

# Wrapper invocations are allowed.
case "$command" in
  *"camp commit"*|*"camp p commit"*|*"fest commit"*) exit 0 ;;
esac

# Only enforce inside a campaign. Without `camp`, or outside a campaign, this is
# some other repository and the rule does not apply.
command -v camp >/dev/null 2>&1 || exit 0
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)"
if [ -n "$cwd" ]; then
  ( cd "$cwd" 2>/dev/null && camp id >/dev/null 2>&1 ) || exit 0
else
  camp id >/dev/null 2>&1 || exit 0
fi

echo "raw git commit is forbidden inside a campaign; use \`camp commit\` (campaign root), \`camp p commit\` (inside projects/*), or \`fest commit\` (during festivals); see the campaign-commit skill. Set CAMP_ALLOW_RAW_GIT=1 to override deliberately." >&2
exit 2

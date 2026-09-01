#!/usr/bin/env bash
# PreToolUse (Bash) guard: block raw `git commit` inside a camp.
#
# Ships with the Festival Claude Code plugin. Unlike a camp-local hook, this
# fires in every session the plugin is enabled in, so it self-scopes: it only
# enforces when the Bash command is a raw `git commit` AND the session is inside
# a camp (detected via `camp id`). Outside a camp, when `camp` or `jq`
# is missing, or when the command is not a raw commit, it exits 0 (fails open)
# so it never blocks unrelated repositories.
#
# Commit discipline: commits must route through the camp/fest wrappers so
# festival traceability and camp bookkeeping are preserved. See the
# campaign-commit skill.
#
# Scope: this is a discipline guard, not a security control. It catches direct
# raw commits, including ones hidden after a wrapper in a compound command
# (`fest commit ...; git commit ...`). It does not defeat deliberate
# obfuscation (`bash -c '...'`, aliases, `eval`); `CAMP_ALLOW_RAW_GIT=1` is the
# supported escape hatch. Detection is intentionally conservative: it may block
# an unusual wrapper command whose quoted message literally contains
# `&& git commit` (split as a separator), which the escape hatch covers.
set -u

# is_raw_git_commit COMMAND -> 0 if any segment invokes a raw `git commit`.
#
# The command is split on the `;`, `&&`, `||`, and newline separators, then each
# segment is matched start-anchored: optional leading whitespace and env
# assignments, then the `git` executable, then any options/args, then the
# `commit` subcommand as a whole word. A wrapper (`camp commit`, `fest commit`)
# starts with a different executable and so never matches; a `git commit` string
# appearing only inside a wrapper's quoted message is not at a segment start and
# is not flagged either.
is_raw_git_commit() {
  local cmd="$1" segment
  # Cheap reject: no `commit` token anywhere means nothing to check.
  case "$cmd" in *commit*) ;; *) return 1 ;; esac
  # Normalize command separators to newlines with pure bash (no sed/tr quirks).
  cmd="${cmd//&&/$'\n'}"
  cmd="${cmd//||/$'\n'}"
  cmd="${cmd//;/$'\n'}"
  while IFS= read -r segment; do
    if printf '%s' "$segment" | grep -Eq '^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*git[[:space:]]+([^[:space:]]+[[:space:]]+)*commit([[:space:]]|$)'; then
      return 0
    fi
  done <<< "$cmd"
  return 1
}

# in_campaign CWD -> 0 if the session is inside a camp. Prefers the hook
# payload's cwd, falling back to the hook process cwd.
in_campaign() {
  local cwd="$1"
  command -v camp >/dev/null 2>&1 || return 1
  if [ -n "$cwd" ]; then
    ( cd "$cwd" 2>/dev/null && camp id >/dev/null 2>&1 )
  else
    camp id >/dev/null 2>&1
  fi
}

main() {
  # jq parses the tool payload safely. If it is absent, fail open rather than
  # guessing at JSON with a regex and risking a false block.
  command -v jq >/dev/null 2>&1 || exit 0

  local input command cwd
  input="$(cat)"
  command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)"
  [ -z "$command" ] && exit 0

  # Deliberate escape hatch.
  [ "${CAMP_ALLOW_RAW_GIT:-}" = "1" ] && exit 0

  is_raw_git_commit "$command" || exit 0

  # Only enforce inside a camp. Elsewhere this is some other repository and
  # the rule does not apply.
  cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)"
  in_campaign "$cwd" || exit 0

  echo "raw git commit is forbidden inside a camp; use \`camp commit\` (camp root), \`camp p commit\` (inside projects/*), or \`fest commit\` (during festivals); see the campaign-commit skill. Set CAMP_ALLOW_RAW_GIT=1 to override deliberately." >&2
  exit 2
}

# Run main only when executed, not when sourced by the test harness.
if [ "${BASH_SOURCE[0]:-$0}" = "$0" ]; then
  main "$@"
fi

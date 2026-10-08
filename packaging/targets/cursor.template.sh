#!/usr/bin/env bash
# Cursor sessionStart hook: install or update fest and camp when a session starts.

cat >/dev/null
bash "$(dirname "$0")/ensure-festival.sh" </dev/null >&2 || true
printf '%s\n' '{}'
exit 0

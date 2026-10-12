#!/usr/bin/env bash
# After an edit: remember the file, so the agent can log what changed before it finishes.
source "$(dirname "$0")/lib.sh"
file="$(field file_path)"
[ -z "$file" ] && file="$(field notebook_path)"
[ -z "$file" ] && exit 0
root="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -n "$root" ] && file="${file#"$root"/}"
state="$(state_file)"
grep -qxF "$file" "$state" 2>/dev/null || printf '%s\n' "$file" >> "$state"
exit 0

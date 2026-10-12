#!/usr/bin/env bash
# Before Claude finishes on a task branch with edits not yet logged: one reminder to log them (never twice in a row).
source "$(dirname "$0")/lib.sh"
printf '%s' "$INPUT" | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
state="$(state_file)"
[ -s "$state" ] || exit 0
key="$(task_key)"
if [ -z "$key" ]; then rm -f "$state"; exit 0; fi
count="$(wc -l < "$state" | tr -d ' ')"
files="$(head -n 30 "$state" | paste -sd ',' - | sed 's/,/, /g')"
[ "$count" -gt 30 ] && files="$files, and $((count - 30)) more"
rm -f "$state"
reason="Datablush: before you finish, log your work on $key with log_work: a files step listing what you changed ($files), with a line on what it does; and if the work is done, a short summary step. Then stop."
printf '{"decision":"block","reason":"%s"}\n' "$(json_escape "$reason")"

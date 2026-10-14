#!/usr/bin/env bash
# Before Claude finishes: Spec Kit files it changed go to Datablush (the sync script reads them from disk, so no
# tokens are spent on them), with anything that needs doing next; and on a task branch with edits not yet logged,
# one reminder to log them. Never twice in a row.
source "$(dirname "$0")/lib.sh"
printf '%s' "$INPUT" | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
state="$(state_file)"
[ -s "$state" ] || exit 0
root="$(git rev-parse --show-toplevel 2>/dev/null)"
notes=""
add() { notes="${notes:+$notes

}$1"; }

if [ -n "$root" ] && [ -d "$root/.specify" ]; then
  sync="$(dirname "$0")/datablush.sh"
  command="$(cat "$state.speckit" 2>/dev/null)"
  current="$(cd "$root" && [ -f .specify/feature.json ] && grep -oE '"feature_directory"[[:space:]]*:[[:space:]]*"[^"]*"' .specify/feature.json | sed -E 's/.*"([^"]*)"$/\1/; s#^\./##; s#/+$##')"
  folders="$( { grep -oE '^(.*/)?specs/[^/]+/' "$state" | sed -E 's#/$##'; [ -n "$current" ] && grep -q "^$current/" "$state" && printf '%s\n' "$current"; } | sort -u)"
  constitution=""
  grep -qxE '(.*/)?\.specify/memory/constitution\.md' "$state" && constitution=1
  unsent=""
  for folder in $folders; do
    out="$(cd "$root" && bash "$sync" sync --feature "$folder" --brief ${command:+--command "$command"} 2>&1)"
    case $? in
      0) [ -n "$out" ] && add "$out" ;;
      2) unsent="$unsent $folder" ;;
      *) add "Datablush: couldn't sync $folder: $out" ;;
    esac
  done
  if [ -n "$constitution" ]; then
    out="$(cd "$root" && bash "$sync" sync --constitution --brief 2>&1)"
    case $? in
      0) [ -n "$out" ] && add "$out" ;;
      2) unsent="$unsent .specify/memory" ;;
      *) add "Datablush: couldn't sync the constitution: $out" ;;
    esac
  fi
  [ -n "$unsent" ] && add "Datablush: the Spec Kit files you changed (${unsent# }) aren't in Datablush yet. Send them now with sync_spec, and tell the person that /datablush:connect (once) makes them sync by themselves, without spending tokens."
  rm -f "$state.speckit"
fi

key="$(task_key)"
if [ -n "$key" ]; then
  count="$(wc -l < "$state" | tr -d ' ')"
  files="$(head -n 30 "$state" | paste -sd ',' - | sed 's/,/, /g')"
  [ "$count" -gt 30 ] && files="$files, and $((count - 30)) more"
  add "Datablush: before you finish, log your work on $key with log_work: a files step listing what you changed ($files), with a line on what it does; and if the work is done, a short summary step. Then stop."
fi
rm -f "$state"
[ -z "$notes" ] && exit 0
printf '{"decision":"block","reason":"%s"}\n' "$(json_escape "$notes")"

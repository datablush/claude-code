#!/usr/bin/env bash
# At the start of a session in a git repo: load the team's rules, and say which task this branch is for.
source "$(dirname "$0")/lib.sh"
git rev-parse --git-dir >/dev/null 2>&1 || exit 0
repo="$(repository)"
key="$(task_key)"
text="Datablush: before starting any work here, call the get_rules tool${repo:+ (repository: $repo)} and follow the team's rules."
[ -n "$key" ] && text="$text This branch is for task $key: if you work on it, start with start_task $key (no plan, no code)."
# Right after the conversation was compacted: make sure nothing decided was lost with it.
if [ "$(field source)" = "compact" ]; then
  text="$text The conversation was just compacted: if you were in a Datablush discussion, call discuss to see what's saved, and save anything decided, dropped or left open that's missing with update_discussion."
fi
say SessionStart "$text"

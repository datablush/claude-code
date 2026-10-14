#!/usr/bin/env bash
# At the start of a session in a git repo: load the team's rules, and say which task this branch is for.
source "$(dirname "$0")/lib.sh"
git rev-parse --git-dir >/dev/null 2>&1 || exit 0
repo="$(repository)"
key="$(task_key)"
text="Datablush: before starting any work here, call the get_rules tool${repo:+ (repository: $repo)} and follow the team's rules."
[ -n "$key" ] && text="$text This branch is for task $key: if you work on it, start with start_task $key (no plan, no code)."
# A Spec Kit repository: its spec files go to Datablush by themselves once this computer is connected.
if [ -d "$(git rev-parse --show-toplevel)/.specify" ]; then
  if bash "$(dirname "$0")/datablush.sh" status >/dev/null 2>&1; then
    text="$text This repository uses GitHub Spec Kit: the spec files you change are sent to Datablush by themselves when you finish (don't send them with sync_spec), and Datablush tells you then what needs doing next."
  else
    text="$text This repository uses GitHub Spec Kit: after each /speckit command, send the files it wrote with sync_spec. Tell the person once that /datablush:connect makes them sync by themselves, without spending tokens."
  fi
fi
# Right after the conversation was compacted: make sure nothing decided was lost with it.
if [ "$(field source)" = "compact" ]; then
  text="$text The conversation was just compacted: if you were in a Datablush discussion, call discuss to see what's saved, and save anything decided, dropped or left open that's missing with update_discussion."
fi
say SessionStart "$text"

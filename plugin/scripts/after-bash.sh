#!/usr/bin/env bash
# After a shell command: commits, test runs and new pull requests belong in the task's work log.
source "$(dirname "$0")/lib.sh"
key="$(task_key)"
on="$key"
[ -z "$on" ] && on="the task you are working on"
if printf '%s' "$INPUT" | grep -qE 'git[^"]* commit'; then
  last="$(git log -1 --format='%h %s' 2>/dev/null)"
  [ -n "$last" ] && say PostToolUse "Datablush: log this commit on $on with log_work (kind: commit, sha: ${last%% *}, text: the message)."
elif printf '%s' "$INPUT" | grep -qE 'gh pr create'; then
  say PostToolUse "Datablush: log the pull request on $on with log_work (kind: pull_request, with its number and url)."
elif printf '%s' "$INPUT" | grep -qE '((npm|pnpm|yarn|bun)( run)? test|vitest|jest|pytest|go test|playwright test|cargo test|rspec|mvn test|gradle test)'; then
  say PostToolUse "Datablush: log this test run on $on with log_work (kind: tests, with how many passed and failed)."
fi
exit 0

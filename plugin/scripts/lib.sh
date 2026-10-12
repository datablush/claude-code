#!/usr/bin/env bash
# Shared helpers for the Datablush hooks. They never call Datablush themselves: they remind the agent, which logs
# through the Datablush tools it's connected with.

# The hook's JSON input (stdin).
INPUT="$(cat)"

# A field's string value from the input ("session_id", "file_path"…), without needing jq. Handles escaped quotes.
field() {
  printf '%s' "$INPUT" \
    | grep -oE "\"$1\"[[:space:]]*:[[:space:]]*\"(\\\\.|[^\"\\\\])*\"" \
    | head -n1 \
    | sed -E 's/^"[^"]+"[[:space:]]*:[[:space:]]*"(.*)"$/\1/; s/\\"/"/g; s/\\\\/\\/g'
}

# The task this branch is for: "gen-42-refunds" or "feature/GEN-42-refunds" → GEN-42.
task_key() {
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || return 0
  printf '%s' "$branch" | grep -oiE '(^|[/_])[a-z][a-z0-9]*-[0-9]+' | head -n1 | sed -E 's#^[/_]##' | tr '[:lower:]' '[:upper:]'
}

# "owner/name" from the origin remote.
repository() {
  git remote get-url origin 2>/dev/null | sed -E 's#\.git$##; s#/+$##' | grep -oE '[^/:]+/[^/:]+$'
}

json_escape() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | awk 'BEGIN{ORS=""} NR>1{print "\\n"} {print}'; }

# Text the model sees after this hook.
say() { printf '{"hookSpecificOutput":{"hookEventName":"%s","additionalContext":"%s"}}\n' "$1" "$(json_escape "$2")"; }

STATE_DIR="${TMPDIR:-/tmp}/datablush-claude"
state_file() {
  local id
  id="$(field session_id | tr -cd 'A-Za-z0-9_-')"
  mkdir -p "$STATE_DIR"
  printf '%s/%s.files' "$STATE_DIR" "${id:-default}"
}

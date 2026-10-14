#!/usr/bin/env bash
# Before a prompt: remember which Spec Kit command is running (/speckit-plan, /speckit.tasks…), so the spec's
# sync can say what wrote it.
source "$(dirname "$0")/lib.sh"
command="$(field prompt | grep -oiE '^[[:space:]]*/speckit[.-][a-z-]+' | head -n1 | sed -E 's#^[[:space:]]*/speckit[.-]##' | tr '[:upper:]' '[:lower:]')"
[ -n "$command" ] && printf '%s' "$command" > "$(state_file).speckit"
exit 0

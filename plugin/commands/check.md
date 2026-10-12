---
description: Check your work against what was agreed, confirm it, then open the pull request
argument-hint: "[GEN-42, or nothing for this branch's task]"
---

Let's check my work on "$ARGUMENTS" before the pull request (if that's empty: the task this branch is for, from the branch name, like gen-42-…).

1. Call start_check. It lists what to check against: the acceptance criteria, the plan, the decisions, the rules, and what the work log says.
2. Make sure everything is committed, then check every item against the changes (git diff against the base branch): met, not met, or unclear, with where in the code (file:line) and a note when it isn't met.
3. Show me the result, not met first, and let me ask about anything or look closer.
4. If anything isn't met, don't open the pull request. Save it with save_check once I confirm, and tell me to run /datablush:work to fix it.
5. If everything is met and I confirm, save it with save_check, then open the pull request with the evidence line it gives you, log it with log_work, and move the task to In review.

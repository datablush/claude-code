---
description: Work on a Datablush task, plan it, get the plan approved, then build it
argument-hint: "[GEN-42 | a sentence describing new work | nothing for your next task]"
---

Let's work on this with Datablush. What to work on: "$ARGUMENTS"

- If that's a task key (like GEN-42), start it with start_task.
- If it's a sentence, there's no task yet: create one with create_task (assigned to me, with a clear title), then start it with start_task.
- If it's empty, call next_task to find my next task, tell me which one it is, and start it with start_task.

Then:

1. Read the task, the team's rules, its decisions and any plan that start_task returns. If the rules weren't loaded yet, call get_rules with this repository (from `git remote get-url origin`). Before planning, look for earlier decisions about the same thing elsewhere with search_memory (kinds: decision, rule, note) and follow them.
2. If something important is unclear, ask me first, each question with why it matters, the options and your recommendation. Record what I answer with record_decisions. Whatever I can't answer, post with ask_questions (never pick who should answer it) and wait for those answers before building what depends on them.
   If I ask for something that goes against a decision (check find_decisions), don't refuse and don't quietly do it: tell me who decided what and when, and let me choose: keep it, change it for everyone (change_decision, with my reason), or an exception for this task only (record_decisions with overridesId).
3. No plan, no code. If there's no approved plan, draft one sized to the task: a short summary, what will change (one line each), and how we'll know it's done (checks). Show it to me and ask: approve, or ask someone to review?
   - If I approve it, call submit_plan with decision "approve".
   - If I want a review, call submit_plan with decision "review" (with reviewers if I name anyone), then stop and tell me it's waiting.
   - If the plan is waiting or has changes requested, call get_plan. Answer each open comment by revising the plan, and call submit_plan with replies. Never approve on anyone's behalf.
4. Only once the plan is approved, build it, following the plan and the rules. If start_task listed things a check or review found not met, fix those. Name the branch as start_task says. Log your work as you go with log_work: the files you change, test runs, commits, notes on choices and why. If you notice something worth doing that's outside the plan, don't do it: save it as an idea for me with save_idea.
5. When it's built and committed, add a short summary with log_work and stop: don't open the pull request. Tell me to run /datablush:check; it checks the work against what was agreed and opens the pull request once I confirm.

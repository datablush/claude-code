---
description: For PR reviewers, review a pull request against its criteria, plan, decisions, rules and best practices
argument-hint: "<GEN-42>"
---

Let's review the pull request for "$ARGUMENTS".

1. Call start_review first. If Datablush refuses (only PR reviewers can review, and nobody reviews their own work), stop right there and tell me what it said. Don't review anything.
2. Otherwise, read the pull request's changes (`gh pr diff` with its number) and check each item: the acceptance criteria; that it does the plan and nothing beyond it; the decisions; the rules; and best practices (security, error handling, tests, readability). Note whether the self-check covers the pull request's latest commit.
3. Show me every item (not met first, with file:line and a note), and let me look closer or disagree.
4. Once I confirm, save it with save_review. Don't approve the pull request on GitHub; I do that myself.

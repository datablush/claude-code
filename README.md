# Datablush for Claude Code

A Claude Code plugin: it connects Datablush, adds `/datablush:work`, and keeps each task's work log up to date.

## What's in it

| Part | What it does |
|---|---|
| `plugin/.mcp.json` | Connects the Datablush MCP server (`DATABLUSH_MCP_URL`, default `https://api-dev.datablush.com/mcp` while Datablush is in development). Sign in with `/mcp` → datablush → Authenticate. |
| `plugin/commands/init.md` | `/datablush:init`: a short interview about what the workspace builds, for whom and how; saved as its brief, which every agent reads. |
| `plugin/commands/discuss.md` | `/datablush:discuss refunds`: brainstorm; the project's discussion keeps what's decided, dropped and left open, and becomes tasks with plans when it settles. |
| `plugin/commands/ask.md` | `/datablush:ask how do refunds work?`: answers from the project's memory (decisions, discussions, plans, work logs, reviews, rules), with sources; says what isn't decided yet. |
| `plugin/commands/check.md` | `/datablush:check`: the implementer checks the work against the acceptance criteria, plan, decisions and rules, confirms it, and only then the pull request is opened (with the evidence in its description). |
| `plugin/commands/review.md` | `/datablush:review GEN-42`: for PR reviewers only (Datablush refuses everyone else, and their own work): reviews the pull request against its criteria, plan, decisions, rules and best practices. |
| `plugin/commands/idea.md` | `/datablush:idea retry failed pages`: saves a thought to your private Ideas, for later (agents never act on ideas on their own). |
| `plugin/commands/work.md` | `/datablush:work [GEN-42 \| "fix the button colour" \| nothing]`: start or create the task, ask first and record decisions, plan and get it approved, build, log the work. |
| `plugin/hooks/hooks.json` | Reminders at the right moments, so logging doesn't depend on the agent remembering. |

The hooks never call Datablush themselves (they have no sign-in); they tell Claude what to log, and Claude logs it
through the Datablush tools:

- **SessionStart**: read the team's rules (`get_rules` with this repo); if the branch is for a task (`gen-42-…`), say so. Right after a compaction, check the discussion kept everything decided.
- **After a shell command**: a commit, a test run or `gh pr create` → log it on the branch's task.
- **After edits**: remember the files changed.
- **Stop**: on a task branch with edits not yet logged, one reminder to log the files and a summary (never twice in a row).

## Install

Published as the [`datablush/claude-code`](https://github.com/datablush/claude-code) repository (a copy of
`integrations/claude-code` in the Datablush monorepo, where it's developed):

```bash
claude plugin marketplace add datablush/claude-code
claude plugin install datablush@datablush
```

## Releasing

1. Change the plugin here (a normal PR to the monorepo).
2. Raise `version` in `plugin/.claude-plugin/plugin.json` **and** `.claude-plugin/marketplace.json` (the same
   number). Claude Code updates a plugin when its version changes, so a change under the same version never reaches
   users; publishing refuses it.
3. Merge. `.github/workflows/publish-plugin.yml` publishes this folder to `datablush/claude-code` as one commit.

Users update with `claude plugin marketplace update datablush` and `claude plugin update datablush@datablush`, then
start a new session. (Changes to the MCP server's tools need no plugin release: they ship with the API.)

The workflow pushes with the `PLUGIN_REPO_TOKEN` secret: a fine-grained token with access to `datablush/claude-code`
only, and Contents: Read and write. Until that secret exists, the workflow skips with a warning and the plugin is
published by hand (the same files, as one commit to `datablush/claude-code`).

## Develop

Load it from this folder for one session, pointed at a local API:

```bash
DATABLUSH_MCP_URL=http://localhost:4000/mcp claude --plugin-dir integrations/claude-code/plugin
```

The hook scripts are plain bash (no jq, Node or Python needed): each reads the hook's JSON on stdin and prints what
Claude should see.

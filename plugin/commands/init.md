---
description: Write this workspace's brief (what it builds, for whom, how); every agent reads it
argument-hint: "[workspace]"
---

Let's write the brief for "$ARGUMENTS" (if that's empty: this workspace) in Datablush: what we build, for whom and how. Every agent reads it before working here.

1. Call get_brief first: if there is one, show it and ask what to change.
2. Otherwise ask me, one question at a time, and keep my words: what are we building; who is it for and what do they need; how is it built (look at this repository first and propose an answer: languages, frameworks, services, where it runs); what must hold (deadlines, compliance, things we don't do); which links matter.
3. Show me the brief, short and plain, and save it with set_brief once I'm happy.
4. Then offer to suggest rules from this repository's conventions; rules are added by an admin in Settings → Agents → Rules.

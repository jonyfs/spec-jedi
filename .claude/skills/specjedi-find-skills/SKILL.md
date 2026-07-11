---
name: specjedi-find-skills
description: Finds and suggests installable agent skills when a user's request touches a domain the current skill set doesn't cover well — triggers on "how do I do X", "is there a skill for X", "find a skill that...", or general requests to extend capabilities. Use both while developing Spec Jedi itself and inside any project that has installed the Spec Jedi skill pack.
compatibility: Requires Node.js (for `npx skills`) and network access to skills.sh / GitHub. No API key needed.
---

# 🔍 Spec Jedi Find Skills

*Adapted from [vercel-labs/skills](https://github.com/vercel-labs/skills)'
`find-skills` (MIT License, per its `package.json`), renamed and reframed under
Constitution [Principle XV](../../../.specify/memory/constitution.md) (naming) and
[Principle XVII](../../../.specify/memory/constitution.md) (skill discovery &
gap-filling).*

## When to use this skill

- The user asks "how do I do X" and X sounds like a common, already-solved task.
- The user says "find a skill for X" or "is there a skill for X."
- The user asks "can you do X" and X is a specialized capability outside what's
  currently installed.
- The user is stuck on a domain this skill set doesn't cover — testing frameworks,
  a specific cloud provider, a design system, etc.
- **Never** trigger this for something already well-handled by an installed
  `specjedi-*` skill — check the installed skill list first.

## What it does

Searches the open agent-skills ecosystem (via the `npx skills` CLI and the
[skills.sh](https://skills.sh/) leaderboard) for a skill that fills the gap, then
presents it — it does not install anything without explicit confirmation.

## Step-by-step

1. **Identify the gap.** Extract: the domain (e.g., React, testing, deployment),
   the specific task, and whether this is common enough that a skill likely exists.
2. **Check the leaderboard first.** Look at [skills.sh](https://skills.sh/) for an
   established skill before running a search — it ranks by install count, so it
   surfaces battle-tested options first. Known strong sources: `vercel-labs/agent-skills`
   (React, Next.js, web design), `anthropics/skills` (frontend design, document
   processing).
3. **Search if the leaderboard doesn't cover it:**
   ```bash
   npx skills find [query] [--owner <owner>]
   ```
   Example: user asks "can you help me with PR reviews?" → `npx skills find pr review`
4. **Verify before recommending — do not suggest a skill on search results alone:**
   - Install count: prefer 1K+; treat anything under 100 with skepticism.
   - Source reputation: official/well-known owners (`vercel-labs`, `anthropics`,
     `microsoft`) outrank unknown authors.
   - GitHub stars on the source repo: under 100 stars, flag it as unverified when
     you present it, don't hide the caveat.
5. **Present the option(s)** — name, what it does, install count + source, the
   install command, and a skills.sh link. Multiple candidates: rank by the
   Step 4 criteria, present the top 1-2, not a long list.
6. **Install only on explicit confirmation** (Constitution Principle VIII's
   suggest-then-confirm pattern — proactively surfacing an option is autonomous;
   running the install is not):
   ```bash
   npx skills add <owner/repo@skill> -g -y
   ```

## Example

> 🌱 Found something that might fill the gap: **react-best-practices** — React/
> Next.js performance guidelines from Vercel Engineering (185K installs, official
> source). Want me to install it?
>
> `npx skills add vercel-labs/agent-skills@react-best-practices`
> Learn more: https://skills.sh/vercel-labs/agent-skills/react-best-practices

## When nothing is found

Say so plainly, offer to help directly with general capabilities, and mention
`npx skills init my-xyz-skill` if this looks like a recurring need worth turning
into a proper skill. Don't pad the "nothing found" response — a short, honest
answer beats an invented recommendation.

## Always / Never

- **Always** verify install count + source before recommending (Step 4) — never
  recommend from raw search output alone.
- **Always** ask before installing — never run `npx skills add` without the user
  explicitly saying yes to that specific skill.
- **Never** claim a skill will solve the problem you haven't actually checked the
  skill's description against — if uncertain, say so and let the user decide.

## Verifiable success criteria

- The presented install command is copy-pasteable and matches the exact
  `owner/repo@skill` format `npx skills add` expects.
- Every recommendation states its install count and source explicitly — a
  recommendation missing either is incomplete, not just under-detailed.

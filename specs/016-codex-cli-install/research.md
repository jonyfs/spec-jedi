# Research: Codex CLI Install Path

**Feature**: 016-codex-cli-install

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) —
Principle III's "at least twenty highest-usage harnesses" compatibility
commitment already exists; this feature is the first real install-path
build beyond Claude Code, so the relevant Principle II question is
narrower than a full 10-tool benchmark: does building a Codex CLI install
path duplicate or conflict with any existing mechanism, and what makes
this the right harness to build second.

## Why Codex CLI, verified not assumed

Two direct facts, both fetched from Codex CLI's own official documentation
(`learn.chatgpt.com/docs/build-skills`, fetched 2026-07-12) rather than
inferred from `references/harness-capability-notes.md`'s earlier desk
research alone:

1. **Frontmatter compatibility**: "The `SKILL.md` file must include `name`
   and `description`." This is the exact same minimal requirement
   `specjedi-*` skills already satisfy (Principle XIX's own frontmatter
   standard requires `name`, `description`, plus optional
   compatibility/environment fields) — no reformatting needed.
2. **Directory convention**: "Codex reads skills from repository, user,
   admin, and system locations. For repositories, Codex scans
   `.agents/skills` in every directory from your current working directory
   up to the repository root." This is structurally the same shape as
   Claude Code's `.claude/skills/*/SKILL.md` convention — a directory of
   named skill folders, not a single flat file — just a different root
   directory name.

An earlier, less authoritative web search had surfaced a third-party
blog's mention of `.codex/skills/` as the directory — cross-checked
against the official `learn.chatgpt.com` source and found to be
inconsistent with it. The official docs (`.agents/skills/`) are treated as
authoritative here, per Principle XX's grounding discipline: prefer the
primary source over a secondary blog post when they disagree.

## Content-compatibility verification (not assumed)

Before writing `spec.md`, ran a direct grep audit across all 23 shipped
`specjedi-*` `SKILL.md` files for two patterns:

```bash
grep -rl "Claude Code" .claude/skills/specjedi-*/SKILL.md          # 0 matches
grep -rlE "\bRead tool\b|\bWrite tool\b|\bBash tool\b|\bTodoWrite\b|\bAskUserQuestion\b" \
  .claude/skills/specjedi-*/SKILL.md                                # 0 matches
```

Zero hits on both. Every skill's instructional content is already
harness-agnostic — no hardcoded "Claude Code" references, no
Claude-Code-specific tool names. This is the concrete finding that makes
this feature a **same-content, different-target-directory** install path
rather than a content-rewrite effort — a materially smaller, lower-risk
scope than porting content itself would have been.

## What this feature does NOT attempt

- **Running Codex CLI itself to observe the skills load correctly.**
  Codex CLI isn't installed in this environment. Verification is
  structural — the same class of check the existing Claude Code
  `install-test` CI job already performs (file placement, frontmatter
  validity) — not a behavioral end-to-end run inside the actual harness.
  Documented explicitly rather than silently assumed equivalent to a real
  Codex CLI test.
- **Re-benchmarking against the original ten Principle II competitors.**
  That research already exists (`specs/001-specjedi-pipeline/research.md`)
  and isn't specific to "which harness to build an install path for next"
  — a question `references/harness-capability-notes.md` already answered
  by naming Codex CLI as one of the easiest AGENTS.md-family candidates.
  This document extends that prior research with the two verified facts
  above, it doesn't repeat the whole competitor survey.

## Decision

Extend `scripts/install.sh`/`.ps1` with a second harness branch
(`codex-cli` → `.agents/skills/`), reusing the exact same copy-then-
validate logic already proven for `claude-code` → `.claude/skills/`, and
add a matching CI job pair. No new content transformation logic needed —
confirmed by the grep audit above.

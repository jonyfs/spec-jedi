# Research: OpenCode Harness Support

**Feature**: 017-opencode-support

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md).
This feature's relevant question isn't "which competitor SDD tool does
this" (irrelevant here — this is a harness-compatibility question, not a
new mechanism) but "does OpenCode's own documented convention actually
match what already exists" — verified precisely below, not assumed.

## What OpenCode actually scans, verified from its own docs

Fetched via `WebSearch` against `opencode.ai/docs/skills/` (2026-07-12).
OpenCode scans **six** locations for skills, at both project and global
scope:

| Scope | Location |
|---|---|
| Project (native) | `.opencode/skills/<name>/SKILL.md` |
| Global (native) | `~/.config/opencode/skills/<name>/SKILL.md` |
| Project (Claude-compatible) | `.claude/skills/<name>/SKILL.md` |
| Global (Claude-compatible) | `~/.claude/skills/<name>/SKILL.md` |
| Project (agent-compatible) | `.agents/skills/<name>/SKILL.md` |
| Global (agent-compatible) | `~/.agents/skills/<name>/SKILL.md` |

Two of these six — the Claude-compatible and agent-compatible project
paths — are **exactly** the two locations this project's own installer
already writes to: `.claude/skills/` (feature 001's original
`--harness claude-code`) and `.agents/skills/` (feature 016's
`--harness codex-cli`). This means OpenCode support requires zero new
install-path code, only verification and documentation — a materially
different, smaller-scoped feature than feature 016's own build.

Project-local scanning also walks up from the current working directory
to the git worktree root, per OpenCode's own docs — consistent with how
this project's installer places skills at the target's own root, not a
subdirectory.

## SKILL.md format compatibility, verified not assumed

OpenCode's own docs state directly: "The format is identical to Claude
Code. A folder containing a SKILL.md file with YAML frontmatter and
markdown instructions. Skills written for Claude Code work in OpenCode
without modification." Recognized frontmatter fields: `name` (required),
`description` (required), `license` (optional), `compatibility`
(optional), `metadata` (optional). Every `specjedi-*` skill already
carries `name` and `description` per Principle XIX — no gap.

## Naming rule, verified against all 23 skills before writing spec.md

OpenCode's `name` requirement: 1-64 characters, lowercase alphanumeric
with single-hyphen separators, no leading/trailing/consecutive hyphens,
and **must match the directory name containing `SKILL.md`**. Ran a direct
audit across all 23 `specjedi-*` skills before writing this feature's
spec:

```bash
for dir in .claude/skills/specjedi-*/; do
  name="$(basename "$dir")"
  frontmatter_name="$(grep -m1 '^name:' "$dir/SKILL.md" | sed -E 's/^name:[[:space:]]*//' | tr -d '[:space:]"'"'"'')"
  [ "$name" != "$frontmatter_name" ] && echo "MISMATCH: $name / $frontmatter_name"
  echo "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || echo "INVALID FORMAT: $name"
done
```

Zero output — all 23 skills already satisfy the rule exactly (this
project's own Principle XV naming convention and `specjedi-new-skill`'s
collision-detection step already enforce a compatible shape,
coincidentally or not).

## Decision

No new installer branch. This feature adds a CI job that installs via
the existing `claude-code` and `codex-cli` paths and asserts the result
against OpenCode's own documented rules specifically (not just re-running
the existing generic frontmatter check), then updates README to state
OpenCode is satisfied by those existing paths — explicitly not implying a
new `--harness opencode` flag exists.

## What this feature does NOT attempt

Running OpenCode itself to observe skill discovery — not available in
this environment. Verification is structural, the same honest scoping
established in feature 016's own research.

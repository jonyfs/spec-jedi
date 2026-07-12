# Data Model: OpenCode Harness Support

**Feature**: 017-opencode-support

No persisted entities and no new install-target mapping — this feature
extends feature 016's Harness Target concept with a *satisfaction*
relationship rather than a new target.

## Harness Satisfaction

| Harness | Install target it needs | Already satisfied by | New code needed |
|---|---|---|---|
| Claude Code | `.claude/skills/` | `--harness claude-code` (feature 001) | — |
| Codex CLI | `.agents/skills/` | `--harness codex-cli` (feature 016) | — |
| OpenCode | `.claude/skills/` **or** `.agents/skills/` (either satisfies it) | Both existing paths, verified this feature | **None** |

OpenCode is the first harness in this table whose own requirement is a
strict subset of what already exists — every future harness researched
should be checked against this table first (does its own discovery
convention already match `.claude/skills/` or `.agents/skills/`?) before
assuming a new installer branch is needed.

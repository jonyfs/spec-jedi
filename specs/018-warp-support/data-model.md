# Data Model: Warp Harness Support

**Feature**: 018-warp-support

Extends feature 017's Harness Satisfaction table with a second entry.

## Harness Satisfaction (updated)

| Harness | Install target it needs | Already satisfied by | New code needed |
|---|---|---|---|
| Claude Code | `.claude/skills/` | `--harness claude-code` (feature 001) | — |
| Codex CLI | `.agents/skills/` | `--harness codex-cli` (feature 016) | — |
| OpenCode | `.claude/skills/` or `.agents/skills/` | Both existing paths (feature 017) | None |
| Warp (Agent Mode, Skills) | any of 10 directory names including `.claude/skills/` and `.agents/skills/` | Both existing paths (feature 018) | None |

Note the explicit scope boundary: this row covers Warp's **Skills**
capability only. Warp's separate **Rules** mechanism
(`AGENTS.md`/`WARP.md`, a flat single-file convention) is a genuinely
different, unaddressed capability — not satisfied by anything this
project has built, and not claimed as satisfied by this feature.

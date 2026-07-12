# Phase 1 Data Model: Trae Harness Support

## Entity: Harness Target

The installer's internal mapping from a `--harness` value to its
install-location convention. This feature adds one new row.

| Harness | Install target it needs | Already satisfied by | New code needed |
|---|---|---|---|
| Claude Code | `.claude/skills/` | `--harness claude-code` (feature 001) | — |
| Codex CLI | `.agents/skills/` | `--harness codex-cli` (feature 016) | — |
| OpenCode | `.claude/skills/` or `.agents/skills/` | Both existing paths (feature 017) | None |
| Warp (Agent Mode, Skills) | any of 10 directory names including `.claude/skills/` and `.agents/skills/` | Both existing paths (feature 018) | None |
| **Trae** | `.trae/skills/` | **New** `--harness trae` (this feature) | **Yes — new branch** |

Unlike OpenCode and Warp (satisfied by existing install targets), Trae's
`.trae/skills/` convention is genuinely new — this feature is the second
(after Codex CLI, feature 016) to require an actual new installer
branch rather than only a documentation/CI update.

## Frontmatter contract (unchanged)

Every `SKILL.md` file installed to `.trae/skills/<name>/SKILL.md` keeps
the same required frontmatter fields already enforced by the installer's
post-copy validation for every other harness:

```yaml
---
name: specjedi-<skill-name>
description: <one-line description>
---
```

No Trae-specific field is required beyond what Claude Code, Codex CLI,
OpenCode, and Warp already share — confirmed by Trae's own official
Skills documentation and community documentation (see `research.md`).

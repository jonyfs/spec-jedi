---
name: caveman-mode
description: Compress every reply to tight caveman-speak, dropping filler, keeping code/commands/errors exact. 65% fewer output tokens per session. Six levels—lite, full, ultra, wenyan—pick at any time.
compatibility: Requires caveman plugin (JuliusBrussee/caveman) installed globally in ~/.claude/. This skill configures SessionStart hook to auto-activate level ultra on session start. Does not install caveman itself—assumes global install complete.
---

# ⛏️ Caveman Mode

**Persona**: Token efficiency personified. No fluff. Brain stays big, mouth gets small.

## What It Does

Configures this project to speak in caveman-speak (ultra level) every session. Output shrinks ~65% on average. Same answers, fewer words. Code byte-for-byte exact. Commands, error messages, technical content untouched — only the *phrasing* compresses.

## How It Works

1. **Caveman global install** (already present): `~/.claude/plugins/cache/caveman/caveman/`
2. **This skill**: wires `.claude/settings.json` SessionStart hook to run `/caveman ultra` on session start
3. **Result**: every session begins at ultra compression level; persists for the entire session

## Levels

| Level | Compression | Example |
|-------|-------------|---------|
| `lite` | ~30% | Object needs `useMemo`. Re-render each time, new ref. |
| `full` *(default)* | ~50% | New ref each render. Wrap in `useMemo`. |
| `ultra` *(this project's default)* | ~65% | New ref/render. `useMemo` it. |
| `wenyan` | ~70% | Classical Chinese, most meaning per token. |

## Commands (Always Available)

- `/caveman [lite\|full\|ultra\|wenyan]` — change level for this session
- `/caveman-stats` — show token savings this session + lifetime + USD cost
- `/caveman-commit` — format a conventional commit message (≤50 char subject, why over what)
- `/caveman-review` — compress a PR review into one-line comments per finding
- `/caveman-compress <file>` — rewrite a memory file (CLAUDE.md, etc.) into caveman-speak, cuts ~46% input tokens *every session after*

## Pre-flight Check

Before this skill activates:
- **Verify caveman installed**: `~/.claude/plugins/cache/caveman/caveman/` must exist
- **Verify caveman plugin registered**: `~/.claude/settings.json` contains `"caveman@caveman": true` in `plugins` section
- **If missing**: run caveman's own install — it finds all agents on your machine and configures them:
  ```bash
  # macOS/Linux/WSL
  curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
  
  # Windows PowerShell
  irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
  ```

## SessionStart Hook

This skill configures `.claude/settings.json` to include a SessionStart hook that sends `/caveman ultra` at the moment your session begins. The hook:
- Runs once per session start
- Does not block if caveman is unavailable (graceful degradation)
- Level persists for the entire session; change anytime with `/caveman [level]`
- Survives across multiple messages in the same session

## Honest Numbers

- **Output tokens**: ~65% average reduction across real tasks (measured; benchmarks in repo)
- **Input tokens**: +1–1.5k per turn (caveman skill overhead), but compressed files save ~46% input *every session after*
- **Net savings**: whole-session win when using caveman-compress on memory files; output-only win for one-off tasks
- **Quality**: no technical content lost; only phrasing shrinks. A March 2026 paper found brief answers actually improve accuracy by ~26 points on some benchmarks

## Language Preservation

Caveman preserves your language. Write Portuguese, caveman replies in Portuguese—compressed. Spanish, French, Japanese, same. Only `wenyan` mode is a translation (classical Chinese packs the most meaning per token, and that's intentional).

## Integration

No conflicts with other skills or hooks. Caveman compresses *output only*, leaving analysis, planning, and code generation untouched. Pairs well with:
- **tdd-guide** — test-driven work stays clear; caveman shrinks the narration
- **code-reviewer** — findings stay precise; caveman compresses non-technical prose
- **planner** — plans read clearer when brief; caveman enforces rigor
- **specjedi-*** skills — reduce secondary output while keeping specs intact

## Maintenance

- Caveman updates from `JuliusBrussee/caveman` (external repo). This skill doesn't bundle caveman; it assumes global install.
- To disable: remove the SessionStart hook from `.claude/settings.json`, or run `/caveman` with no level to reset to default agent behavior (that session only)
- To change default level: edit `.claude/settings.json` SessionStart hook, replace `ultra` with desired level

## References

- **Main repo**: https://github.com/JuliusBrussee/caveman
- **Benchmarks**: `benchmarks/` directory in caveman repo
- **Honest analysis**: https://github.com/JuliusBrussee/caveman/blob/main/docs/HONEST-NUMBERS.md
- **Install matrix** (30+ agents): https://github.com/JuliusBrussee/caveman/blob/main/INSTALL.md

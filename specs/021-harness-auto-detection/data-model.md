# Phase 1 Data Model: Harness Auto-Detection

## Entity: Detection Signal

One `(harness, signal-type, evidence)` tuple, represented as a bash
string `"harness:signal-type:evidence"` (data-model chosen for bash 3.2
compatibility — see research.md).

| Harness | Signal type (priority order) | Evidence checked |
|---|---|---|
| `claude-code` | 1. target-dir | `<target>/.claude/` exists |
| `claude-code` | 2. path-binary | `command -v claude` succeeds |
| `claude-code` | 3. global-config | `~/.claude/` exists |
| `codex-cli` | 1. target-dir | `<target>/.agents/` exists |
| `codex-cli` | 2. path-binary | `command -v codex` succeeds |
| `codex-cli` | 3. global-config | `~/.codex/` exists |
| `trae` | 1. target-dir | `<target>/.trae/` exists |
| `trae` | 3. global-config | `~/.trae/` exists (no path-binary signal — research.md) |

## Entity: Detection Result

The outcome of evaluating all Detection Signals for one install run.

| Case | Condition | Behavior |
|---|---|---|
| Explicit | `--harness` was passed | No detection runs at all (FR-001) |
| Zero-match | No signal matched for any harness | Fallback to `claude-code`, stated explicitly (FR-007) |
| Single-match | Exactly one harness has ≥1 matching signal | Auto-install for it, state which signal matched (FR-003) |
| Multi-match, interactive | ≥2 harnesses match, `[ -t 0 ]` true, `--auto` not passed | Lettered prompt, Recommended marked, wait for choice (FR-005) |
| Multi-match, non-interactive | ≥2 harnesses match, `[ -t 0 ]` false OR `--auto` passed | Auto-select Recommended, state why (FR-006) |

**Recommended selection** (multi-match cases): among matched harnesses,
each harness's *best* (lowest-numbered) signal type is its rank. The
harness with the lowest rank number is Recommended; ties broken by fixed
harness priority order (`claude-code` > `codex-cli` > `trae`, matching
the README compatibility table's own listing order).

# Implementation Plan: Interactive Update Prompt & Loss-Safe Skill Update

**Branch**: `055-safe-skill-update-hook` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/055-safe-skill-update-hook/spec.md`

## Summary

Two parts: (1) `scripts/install.sh`/`.ps1`'s skill-copy and
template-copy loops gain an unconditional timestamped backup of the
existing directory/files before any overwrite — the simplest mechanism
that needs no content-hash tracking, satisfying FR-001/002/003/008
uniformly for both file classes; (2) `scripts/session-start.sh`/`.ps1`'s
existing freshness line changes from purely informational to a directive
prompt, and `CLAUDE.md`'s own Session-start orientation section gains an
instruction telling the agent to ask the user directly and, on "yes,"
invoke `bootstrap-install.sh`/`.ps1` — matching the exact hook-plus-
agent-render contract Constitution Principle XXI already established for
this same hook. This requires a small, direct Principle XXII amendment
(PATCH — clarifying the update path is now interactive-capable, not
redefining anything else) since XXII's current text says the check is
"advisory only" in a way that predates this feature.

## Technical Context

**Language/Version**: Bash + PowerShell (matching `install.sh`/
`session-start.sh`'s own existing dual implementation, Principle XIII).

**Primary Dependencies**: None new.

**Storage**: A new timestamped backup directory
(`.specify/backups/<timestamp>/`) created only when an update actually
overwrites differing content.

**Testing**: No CI job. Verified via a manual dry-run: hand-edit a
skill file locally, run `install.sh` again, confirm the edit is
backed up before being overwritten; confirm a first-ever install
(no marker) triggers zero backup activity.

**Constraints**: FR-009 (constitution/CLAUDE.md non-managed content
already safe) MUST NOT regress.

**Scale/Scope**: Amendments to `scripts/install.sh`/`.ps1`,
`scripts/session-start.sh`/`.ps1`, `CLAUDE.md`'s own Session-start
orientation section, and Constitution Principle XXII.

## Constitution Check

| Principle | Check | Status |
|---|---|---|
| II | Reuses the existing `bootstrap-install.sh`/`install.sh` mechanism entirely — no second update flow invented, matching Principle XXII's own existing "MUST NOT invent a second update flow" clause. | ✅ Pass |
| IX | No CI job; validated via manual dry-run (hand-edited skill file survives an update). | ✅ Pass |
| XIII | Both bash and PowerShell implementations gain identical logic. | ✅ Pass — enforced during implementation |
| XXII | This plan directly amends Principle XXII (PATCH) to reconcile its "advisory only" framing with this feature's own interactive trigger — reasoned through explicitly here, not silently contradicted. | ✅ Pass — enforced during implementation |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/055-safe-skill-update-hook/
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
scripts/
├── install.sh              # AMENDED — backup-before-overwrite for
│                              #   skills_dst and templates_dst
├── install.ps1              # AMENDED — identical logic
├── session-start.sh         # AMENDED — freshness line becomes a
│                              #   directive prompt
└── session-start.ps1        # AMENDED — identical logic

CLAUDE.md                    # AMENDED — Session-start orientation
                              #   section gains the ask-then-update
                              #   instruction

.specify/memory/constitution.md  # AMENDED — Principle XXII PATCH
```

### Implementation notes

1. **Backup mechanism** (User Story 1, FR-001/002/003/008): before the
   existing `rm -rf "${skills_dst:?}/$skill_name"` / template `cp`,
   check if `$skills_dst/$skill_name` (or the template file) already
   exists AND differs (`diff -q`) from the source about to replace it.
   If it exists and differs, copy it to
   `.specify/backups/<UTC-timestamp>/` before proceeding. Skip entirely
   on a fresh directory with nothing to compare (FR-003). Print one
   summary line naming what was backed up, if anything.
2. **Directive prompt** (User Story 2, FR-004/005/006): change
   `session-start.sh`'s `freshness_line` text from "Update available: X
   installed, Y published -- run scripts/bootstrap-install.sh/.ps1 to
   update." to a phrasing that names both the update AND that the agent
   should ask directly (e.g. "...— ask the user if they'd like to
   update now; on yes, run scripts/bootstrap-install.sh/.ps1.").
3. **`CLAUDE.md` instruction**: add one sentence to the existing
   Session-start orientation section: when a freshness/update line is
   present in the rendered payload, ask the user directly (yes/no)
   rather than just mentioning it; on yes, run the named script via
   Bash; on no, say nothing further and proceed normally.
4. **Constitution Principle XXII amendment** (PATCH): reconcile
   "Advisory only — never block, never fail loudly, never guess" with
   the new interactive trigger — clarify that "advisory" describes the
   check never blocking session start or forcing an update, not that it
   can never ask; explicitly confirm no second update flow is invented
   (still the same `bootstrap-install.sh`/`.ps1`).
5. **Validate**: manual dry-run — hand-edit a skill file, re-run
   `install.sh`, confirm backup + overwrite; confirm first install
   triggers no backup.

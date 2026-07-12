# Data Model: Session-Start Orientation Hook

**Feature**: 015-session-start-hook

No persisted entities — everything here is generated fresh each hook run
and never written to disk (spec.md's Session Orientation Payload is
explicitly ephemeral). This document describes the shape of that
in-memory/stdout payload, not a database or file-backed model.

## Session Orientation Payload

The full text block emitted as `additionalContext`. Three ordered parts:

| Part | Source | Shape |
|---|---|---|
| 1. ASCII banner | Static, embedded in the hook script | A fixed-width text block, ~8-12 lines, an original Spec Jedi wordmark/lightsaber rendering |
| 2. Status summary | Derived live from `specs/NNN-*/` (same logic as `specjedi-status`) | 1-3 lines: total feature count, counts per status bucket (complete/in-progress/planned/specified-only), optionally the most-recently-touched feature's name |
| 3. Yoda greeting line | Selected from `references/star-wars-lexicon.md`'s Master Yoda Persona rotation pool | 1 line, plain text, rotated per invocation |

Concatenated with blank-line separators, total payload MUST stay under
10,000 characters (FR-003) — in practice this payload is on the order of
a few hundred characters; the cap is a ceiling, not a design target.

## Status Bucket (derived, not stored)

Mirrors `specjedi-status`'s own categorization exactly — this is the same
logic, re-expressed here only to specify the *summary* rollup this
feature adds on top of it (a per-feature table is `specjedi-status`'s
job; a count-per-bucket rollup is this feature's job):

| Bucket | Derivation |
|---|---|
| `specified` | `spec.md` exists, no `plan.md` |
| `planned` | `spec.md` + `plan.md` exist, no `tasks.md` |
| `in_progress` | `tasks.md` exists, checkbox completion 1-99% |
| `complete` | `tasks.md` exists, checkbox completion 100% |
| `not_started` | `tasks.md` exists, checkbox completion 0% |

## Yoda Line Selection (stateless)

No new persistent "last shown" tracking file (FR-005 explicitly rules
this out — it would be a second tracking mechanism, the exact anti-
pattern Principle XXI's "no parallel status system" clause forbids
applied to greeting state too). Selection uses a cheap, available-at-
hook-run-time signal (e.g., current timestamp modulo the pool size) to
vary the pick run to run without needing to remember the previous choice.

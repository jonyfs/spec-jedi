# Implementation Plan: `specjedi-*` Pipeline Hook Dispatch

**Branch**: `047-specjedi-hook-dispatch` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/047-specjedi-hook-dispatch/spec.md`

## Summary

Closes the one real engineering blocker
`specs/044-speckit-parity-audit/PARITY-LEDGER.md` identified for a full
internal migration off `speckit-*`: extends all 9 core `specjedi-*`
pipeline skills (`specjedi-constitution`, `specjedi-specify`,
`specjedi-clarify`, `specjedi-plan`, `specjedi-tasks`,
`specjedi-implement`, `specjedi-analyze`, `specjedi-checklist`,
`specjedi-converge`) with the same `.specify/extensions.yml`
`hooks.before_<stage>`/`hooks.after_<stage>` dispatch check every
matching `speckit-*` skill already implements individually — matched
for exact behavioral parity, not redesigned.

## Technical Context

**Language/Version**: N/A — 9 existing Claude Code skills (`SKILL.md`
prompt files), extended in place. No new language, runtime, or script.

**Primary Dependencies**: None new. Mirrors `speckit-*`'s own
already-shipped hook-check reasoning (read YAML informally, skip
silently on parse failure, no tokenizer/parser library) — zero new
dependency, matching this project's own zero-`jq`/zero-parser
precedent already used everywhere else.

**Storage**: N/A — reads the existing `.specify/extensions.yml`; writes
nothing new.

**Testing**: No new CI job — every touched skill is reasoning-driven
(LLM judgment over a small YAML file), the same posture
`specjedi-govcheck`/`specjedi-constitution-audit` already established
(Principle IX satisfied via `scripts/validate.sh`'s existing structural
lint + a real dry-run of the mechanism against this project's own two
currently-registered hooks, `after_specify`/`after_plan` →
`speckit.agent-context.update`, before shipping).

**Target Platform**: N/A — no script is added or modified; Principle
XIII (cross-platform `.sh`/`.ps1` parity) does not apply.

**Project Type**: In-place enhancement of 9 existing `specjedi-*`
skills — no new skill, no new project structure.

**Performance Goals**: N/A — each check is a single, cheap YAML-glance
step added to an already-invoked skill's existing flow.

**Constraints**: Hook-checking behavior MUST match `speckit-*`'s own
already-shipped behavior exactly (FR-003) — missing/malformed
`extensions.yml`, disabled hooks, condition-field skipping, and the
optional-vs-mandatory dispatch format are copied, not reinvented. This
feature MUST NOT alter any of the 9 skills' own existing product
reasoning, judgment calls, or voice (FR-005) — purely additive. Per
Constitution Principle XIX (specs/045 precedent), no touched skill may
cross the 5,000-token hard cap as a result of this feature's own
additions — baseline token counts captured below (Project Structure)
before editing.

**Scale/Scope**: 9 skill files modified, zero new files beyond this
feature's own `specs/047-*/` documentation.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | No new mechanism is being invented — this feature matches an already-shipped, already-proven reference implementation (every `speckit-*` skill's own "Pre-Execution Checks"/"Mandatory Post-Execution Hooks" sections), confirmed by reading all 9 directly before writing this plan. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | No CI job, matching `specjedi-govcheck`/`specjedi-constitution-audit`'s own established precedent for reasoning-driven skills; validated via `scripts/validate.sh`'s existing lint plus a real dry-run against this project's own two live registered hooks before shipping. | ✅ Pass |
| XII (Star Wars-Flavored End-User Voice) | Each skill's own existing Persona/narration is untouched (FR-005) — the new hook-check step is short, procedural, and matches the plain, mechanical tone `speckit-*`'s own hook-check text already uses (it's a dispatch check, not end-user-facing narration). | ✅ Pass |
| XIX (Skill Authoring & Prompt Engineering Standard) | Every touched skill's real token count is checked before/after editing (baseline captured below; largest is `specjedi-implement` at ~2,854 tokens today, comfortably under the 5,000 hard cap with room for a ~150-250 token addition). | ✅ Pass — enforced during implementation |
| XX (AI Discipline: Grounded, Honest Output) | The mechanism's exact behavior is copied from `speckit-*`'s own real, currently-shipped text — nothing here is guessed or invented. | ✅ Pass |
| XV (`specjedi-` Skill Naming Convention) | Two distinct halves: the naming-convention half is Not Applicable (no new skill is created; all 9 existing names are unchanged). The bootstrap/product-distinction half — `speckit-*` as internal tooling, `specjedi-*` as the actual competitive product — is actively invoked: this feature exists specifically to close the one gap keeping `specjedi-*` from being a complete, migration-ready substitute for `speckit-*`, per specs/044's parity ledger. Each of the 9 touched skills cites this principle for that reason, not the naming rule. | ✅ Pass (bootstrap/product half) / N/A (naming half) |

No violations requiring Complexity Tracking.

### Token baseline (captured before any edit)

| Skill | Chars | ~Tokens (÷4) |
|---|---|---|
| `specjedi-constitution` | 7,648 | 1,912 |
| `specjedi-specify` | 8,733 | 2,183 |
| `specjedi-clarify` | 7,418 | 1,854 |
| `specjedi-plan` | 9,928 | 2,482 |
| `specjedi-tasks` | 6,826 | 1,706 |
| `specjedi-implement` | 11,417 | 2,854 |
| `specjedi-analyze` | 10,561 | 2,640 |
| `specjedi-checklist` | 7,358 | 1,839 |
| `specjedi-converge` | 7,388 | 1,847 |

All 9 sit well under the 500-token soft target already (these are
larger, mature pipeline skills) and far under the 5,000-token hard cap
— none is at risk of crossing it from a compact, two-step addition.

## Project Structure

### Documentation (this feature)

```text
specs/047-specjedi-hook-dispatch/
├── plan.md              # This file
├── research.md          # Phase 0 output — hook-check pattern decisions
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
specs/041/043/045/046: no entities, no interface contract, and
verification is a real dry-run against this project's own live hooks,
not a separate runnable scenario doc.

### Source Code (repository root)

```text
.claude/skills/
├── specjedi-constitution/SKILL.md   # MODIFIED: + before/after hook check
├── specjedi-specify/SKILL.md        # MODIFIED: + before/after hook check
├── specjedi-clarify/SKILL.md        # MODIFIED: + before/after hook check
├── specjedi-plan/SKILL.md           # MODIFIED: + before/after hook check
├── specjedi-tasks/SKILL.md          # MODIFIED: + before/after hook check
├── specjedi-implement/SKILL.md      # MODIFIED: + before/after hook check
├── specjedi-analyze/SKILL.md        # MODIFIED: + before/after hook check
├── specjedi-checklist/SKILL.md      # MODIFIED: + before/after hook check
└── specjedi-converge/SKILL.md       # MODIFIED: + before/after hook check
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**Insertion pattern, identical across all 9 skills** (research.md
Decision 1 covers why this exact shape, adapted to each skill's own
existing structural convention rather than `speckit-*`'s section
headings verbatim):

- **Before-hook check**: a new first action in the skill's own
  Step-by-step section (Step "0" conceptually, renumbering existing
  steps by one) — check `.specify/extensions.yml` for
  `hooks.before_<stage>`, using the exact same rules `speckit-<stage>`
  already documents: skip silently if the file is missing or
  unparseable; filter out hooks with `enabled: false`; skip (don't
  evaluate) any hook with a non-empty `condition`; for each remaining
  hook, surface an optional hook as a suggested command, or execute a
  mandatory hook (`EXECUTE_COMMAND:`) and wait for its result before
  continuing.
- **After-hook check**: a new final step, immediately before the
  skill's existing "offer the next step(s)" / completion-reporting
  step — same rules, checking `hooks.after_<stage>` instead.
- **Stage-key mapping** (each skill checks its own key only):
  `specjedi-constitution` → `before_constitution`/`after_constitution`;
  `specjedi-specify` → `before_specify`/`after_specify`;
  `specjedi-clarify` → `before_clarify`/`after_clarify`;
  `specjedi-plan` → `before_plan`/`after_plan`; `specjedi-tasks` →
  `before_tasks`/`after_tasks`; `specjedi-implement` →
  `before_implement`/`after_implement`; `specjedi-analyze` →
  `before_analyze`/`after_analyze`; `specjedi-checklist` →
  `before_checklist`/`after_checklist`; `specjedi-converge` →
  `before_converge`/`after_converge`.
- **Voice boundary**: the hook-check step's own text stays short and
  procedural (matching `speckit-*`'s own plain dispatch-check tone) —
  it does not need Principle XII Star Wars flavor, the same way
  `speckit-*`'s own hook sections don't carry `specjedi-*`'s voice
  either. This is infrastructure text, not end-user narration.

**Verification before shipping (Principle XIX + FR-006 gate)**: (1) run
`wc -c` against all 9 touched `SKILL.md` files before and after
editing, confirm none crosses the 5,000-token hard cap; (2) real
dry-run: temporarily simulate `specjedi-specify` and `specjedi-plan`
running against this project's own actual `.specify/extensions.yml`
(which has real `after_specify`/`after_plan` hooks registered) and
confirm both hooks are detected and surfaced exactly as
`speckit-specify`/`speckit-plan` would; (3) confirm a stage with no
registered hook (e.g. `before_tasks`) produces zero visible output
change.

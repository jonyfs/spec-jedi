# Implementation Plan: Skill Validation & Testing Framework Compliance Audit

**Branch**: `033-skill-validation-audit` | **Date**: 2026-07-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/033-skill-validation-audit/spec.md`

## Summary

A direct `grep` audit found zero of the 24 shipped `specjedi-*` skills
cite `references/skill-validation-testing-framework.md`, despite
Constitution Principle IX requiring every skill's dry-run coverage to
address the framework's four adopted categories wherever applicable. This
feature closes that gap in full: `research.md` states one single,
consistently-applied applicability rule per category and applies it to
all 24 skills (96 explicit findings, zero silent omissions), then adds a
`## Validation Coverage (Principle IX)` section to every skill's
`SKILL.md` stating each category's status — cross-referencing existing
`Example`/`Always-Never` content where it already demonstrates the
behavior (the common case), writing a new concrete scenario only where
genuinely missing. `specjedi-skill-review` gains this framework as an
explicit review dimension going forward (US3/FR-006), so the gap can't
silently reopen.

## Technical Context

**Language/Version**: N/A — `SKILL.md` prompt content (Markdown + YAML
frontmatter) only; no code, no new script files.

**Primary Dependencies**: None beyond the already-shipped
`references/skill-validation-testing-framework.md` this feature applies.

**Storage**: N/A.

**Testing**: Principle VI exemption — this feature's deliverable is
documentation content added to existing `SKILL.md` files, not application
code with a meaningful red/green cycle (same exemption class as every
prior `specjedi-*` skill-shipping/skill-revising feature). Verification
takes the form of `quickstart.md`'s scenarios: a structural check that
every skill carries the new section with all four categories present
(SC-001), a spot-check that Applicable cells carry concrete scenarios
rather than generic restatements (SC-002), and confirmation that
`specjedi-skill-review`'s own source now names the framework (SC-003).

**Target Platform**: N/A — documentation only, no harness-specific
behavior.

**Project Type**: Single project — a documentation-content audit and
revision across 24 existing skill files plus one skill extension.

**Performance Goals**: N/A.

**Constraints**: FR-003 — applicability must be determined by one single,
stated, consistently-applied rule per category, not 24 independent
judgment calls. FR-005 — cross-reference existing content before writing
new prose, never duplicate.

**Scale/Scope**: 24 existing `specjedi-*` `SKILL.md` files gain one new
section each; `specjedi-skill-review`'s own `SKILL.md` gains a new review
dimension; `CHANGELOG.md` gains one entry. No README/skill-count changes
(no new skill ships, no skill count changes).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I**: N/A — no README/localized-docs content touched.
- **Principle II**: Satisfied — see `research.md`'s Principle II note.
  This is an internal compliance audit against an already-adopted
  framework, not a claim requiring new external competitor research.
- **Principle III**: N/A — no installer/harness work.
- **Principle IV**: N/A — no new user-facing elicitation moment
  introduced; this feature documents existing skills' own elicitation
  behavior, doesn't change it.
- **Principle V**: Satisfied — `spec.md` carries zero open
  `NEEDS CLARIFICATION` markers.
- **Principle VI**: Exemption stated above in Technical Context.
- **Principle VII**: N/A.
- **Principle VIII**: N/A.
- **Principle IX**: This feature *is* Principle IX's own compliance
  mechanism catching up with itself — directly embodied, not just
  satisfied.
- **Principle X**: Standard feature-branch → PR → `ci-gate` → auto-merge
  flow, as always.
- **Principle XI**: N/A.
- **Principle XII**: N/A — the new sections are structured, factual audit
  content (status/reason per category), matching this project's existing
  exemption for precise generated-artifact content over narration voice.
- **Principle XIII**: Satisfied by construction — no new `.sh`/`.ps1`
  files in this diff.
- **Principle XIV**: N/A — no new skill invocation flow; existing
  next-step sections in each skill are untouched.
- **Principle XV**: N/A — no new skill named.
- **Principle XVI**: N/A — no diagram-worthy content; a flat audit table
  in `research.md` is sufficient.
- **Principle XVII**: N/A — this feature doesn't introduce a new
  domain-expertise gap.
- **Principle XVIII**: N/A.
- **Principle XIX**: Directly relevant — the new section itself must
  follow this project's own ruthless-literalness/no-generic-restatement
  discipline (FR-002), checked during implementation and by
  `specjedi-skill-review` going forward once US3 ships.
- **Principle XX**: Directly modeled — every Applicable/Not-Applicable
  finding in `research.md`'s table is grounded in that skill's actual
  step-by-step content (read during implementation), never assumed from
  the skill's name alone.
- **Principle XXI**: N/A.
- **Distribution & Ecosystem Standards**: N/A — no new skill, no badge/
  skill-count change.
- **Development Workflow**: This exact pipeline (research → specify →
  clarify → plan → tasks → implement → validation → PR) is being
  followed live for this feature.

No violations requiring justification. Complexity Tracking table is
empty by design.

## Project Structure

### Documentation (this feature)

```text
specs/033-skill-validation-audit/
├── plan.md              # This file
├── research.md          # Phase 0 output — the four applicability rules + full 24-skill table
├── quickstart.md         # Phase 1 output — structural + spot-check validation scenarios
└── tasks.md              # Phase 2 output (/speckit-tasks — not created by /speckit-plan)
```

`data-model.md` and `contracts/` are intentionally omitted: no data
entities, no external interface — this feature only adds documentation
content to existing files.

### Source Code (repository root)

```text
.claude/skills/
├── specjedi-onboard/SKILL.md         # MODIFIED — new Validation Coverage section
├── specjedi-constitution/SKILL.md    # MODIFIED
├── specjedi-specify/SKILL.md         # MODIFIED
├── specjedi-clarify/SKILL.md         # MODIFIED
├── specjedi-plan/SKILL.md            # MODIFIED
├── specjedi-tasks/SKILL.md           # MODIFIED
├── specjedi-implement/SKILL.md       # MODIFIED
├── specjedi-quick/SKILL.md           # MODIFIED
├── specjedi-analyze/SKILL.md         # MODIFIED
├── specjedi-checklist/SKILL.md       # MODIFIED
├── specjedi-converge/SKILL.md        # MODIFIED
├── specjedi-find-skills/SKILL.md     # MODIFIED
├── specjedi-explain/SKILL.md         # MODIFIED
├── specjedi-migrate/SKILL.md         # MODIFIED
├── specjedi-diagram/SKILL.md         # MODIFIED
├── specjedi-status/SKILL.md          # MODIFIED
├── specjedi-retro/SKILL.md           # MODIFIED
├── specjedi-security/SKILL.md        # MODIFIED
├── specjedi-docs/SKILL.md            # MODIFIED
├── specjedi-new-skill/SKILL.md       # MODIFIED
├── specjedi-release/SKILL.md         # MODIFIED
├── specjedi-skill-review/SKILL.md    # MODIFIED — also gains the new review-dimension step (US3/FR-006)
├── specjedi-tokencheck/SKILL.md      # MODIFIED
└── specjedi-govcheck/SKILL.md        # MODIFIED

CHANGELOG.md                           # MODIFIED — new entry
```

**Structure Decision**: No new skill, no new top-level directory. 24
existing skill files each gain one new, consistently-placed section;
`specjedi-skill-review` additionally gains one new step. This is a
documentation-content revision across the existing skill package, not a
structural change.

## Complexity Tracking

*No Constitution Check violations — this section is intentionally empty.*

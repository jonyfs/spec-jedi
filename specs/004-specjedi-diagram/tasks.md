---
description: "Task list for specjedi-diagram (Feature 004)"
---

# Tasks: `specjedi-diagram`

**Input**: `specs/004-specjedi-diagram/{spec.md, plan.md, research.md}`

**Scope**: single-skill feature, following the exact incremental-shipping
discipline established across features 001-003.

## Format: `[ID] [P?] [Story]`

## Phase 1: Setup

- [x] T001 Confirm `specs/004-specjedi-diagram/{research.md,spec.md,plan.md}`
  are complete and internally consistent (manual re-read).

## Phase 2: User Story 1 — Generate a diagram from an existing spec or plan (P1) 🎯 MVP

**Goal**: A user with a spec/plan gets a render-verified, correctly-typed
Mermaid diagram grounded in the actual content, presented alongside (never
instead of) the source prose.

**Independent test**: See spec.md User Story 1 → Independent Test.

- [x] T010 [P] [US1] Create `.claude/skills/specjedi-diagram/SKILL.md` per
  plan.md's Design section: persona, task, the three-signal diagram-type
  inference reasoned through explicitly every time, the validate-before-
  presenting step (render-check via the harness's Mermaid mechanism, with
  an explicit unverified-caveat fallback), the grounding discipline (no
  invented nodes/edges), `--auto` behavior, proactive gap-check hook.
- [x] T011 [US1] Add a full input → output worked example: a spec.md
  excerpt with prioritized user stories in, the resulting flowchart
  Mermaid source plus the "why this type, verified how" narration out.
- [x] T012 [US1] Add Always/Never guardrails and verifiable success
  criteria per the Skill Authoring Standard checklist — explicitly
  including "Never present a diagram that hasn't been render-verified (or
  explicitly caveated as unverified)" as a Never guardrail.
- [x] T013 [US1] Run `scripts/validate.sh` (and `.ps1` on Windows) —
  structural lint must pass.
- [x] T014 [US1] Manual scenario dry run: exercise against a real spec.md
  excerpt with clear story-flow content and confirm a flowchart is
  generated, every node traces to an actual story, and the worked
  example's own diagram source actually render-verifies (use the
  environment's Mermaid validation mechanism on the example's own
  output as the dry run's concrete check).

**Checkpoint**: `specjedi-diagram` is independently usable — a user can go
from a spec/plan to a correctly-typed, verified diagram in one request.

## Phase 3: User Story 2 — Ambiguous source content triggers a question (P2)

**Goal**: Source content with no dominant diagram-type signal produces a
clarifying question, never a silent guess, even in `--auto` mode.

**Independent test**: See spec.md User Story 2 → Independent Test.

- [x] T020 [US2] Manual scenario dry run: exercise against source content
  with comparably-present flow and data-model signals and confirm the
  skill's documented step sequence asks which type is wanted, including
  when `--auto` is set (per FR-002's explicit both-modes requirement).
- [x] T021 [US2] Review `specjedi-diagram/SKILL.md` against the full Skill
  Authoring Standard checklist in `references/skill-authoring-standard.md`
  before marking this story done.

**Checkpoint**: both user stories complete — `specjedi-diagram` is safe to
ship.

## Phase 4: Documentation & Ship

- [x] T030 Update README.md's skill table to add `specjedi-diagram`;
  update `references/skill-roadmap.md` to move it from "Proposed, not yet
  built" to "Shipped," renumbering the remaining backlog items.
- [x] T031 Update `.specify/memory/constitution.md`'s Sync Impact Report
  noting `specjedi-diagram` shipped (feature 004, third roadmap item
  beyond the core P1-P9 pipeline).
- [x] T032 Validate full repo (`scripts/validate.sh`), commit on this
  feature branch, open PR, verify `ci-gate` green, confirm auto-merge.

## Dependencies

- Phase 2 (US1) has no dependency on Phase 3 (US2) structurally — both
  live in the same SKILL.md file, so they ship together as one skill.
- Phase 4 (Documentation & Ship) depends on Phases 2 and 3 both being
  complete.

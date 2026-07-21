# Tasks: Agent Mapping for All specjedi-* Skills

**Input**: Design documents from `/specs/066-agent-mapping-all-skills/`

**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: Not applicable — classification + Markdown-authored skill/
agent edits, no automated runner.

**Organization**: Tasks grouped by user story. Story 3's artifact
requirement is satisfied by the same write Story 1 produces (both
target `orchestration-plan.md`) — noted explicitly in Dependencies
rather than duplicated as separate tasks.

## Path Conventions

`specs/065-orchestrate-pipeline-integration/orchestration-plan.md`
(extended), `.claude/agents/orchestrate-*.md` (0-N new),
`.claude/skills/specjedi-implement/SKILL.md`,
`.claude/skills/specjedi-orchestrate/SKILL.md`, per plan.md's Project
Structure.

---

## Phase 1: User Story 1 + 3 - Complete skill-to-agent mapping (Priority: P1) 🎯

**Goal**: All 32 installed `specjedi-*` skills get an explicit
disposition (existing agent / new agent / none), written to a durable,
consultable artifact.

**Independent Test**: Read `orchestration-plan.md`'s extended mapping
section — every one of the 32 skills has a row with a disposition and a
one-line reasoning traceable to that skill's own documented behavior.

### Implementation for User Story 1 + 3

- [x] T001 [US1] List all 32 installed skills (`ls .claude/skills |
  grep specjedi`) as the classification's input set — cross-check count
  against SC-001's 32.
- [x] T002 [US1] For each of the 26 skills not already covered by
  feature 065's 7-stage pipeline mapping, read its `SKILL.md`
  frontmatter `description` + Persona/Task sections and classify along
  three dimensions: read-only vs. write-capable, judgment-heavy vs.
  mechanical, per-diff/per-feature scope vs. whole-project scope.
- [x] T003 [US1] For each classified skill, assign a disposition:
  nearest existing `orchestrate-*` agent (with reasoning citing the
  classification dimensions from T002), a candidate for a new
  cluster (flagged, not yet assigned), or "no dedicated agent" (with
  reasoning — e.g. pure session-modifier, one-shot conversational,
  or a scaffolding skill whose output must stay in the main session for
  the user to review inline).
- [x] T004 [US1] Write the full 32-row mapping (26 new + 6 already-known
  from feature 065, restated for completeness in one place) as a new
  `## Skill-to-Agent Mapping` section appended to
  `specs/065-orchestrate-pipeline-integration/orchestration-plan.md` —
  the existing `## Roles`/`## Pipeline shape`/`## Governance constraint
  check` sections stay unchanged (FR-005).

**Checkpoint**: Every skill has a documented, grounded disposition in a
durable artifact — Story 1 and Story 3 both satisfied by this single
write.

---

## Phase 2: User Story 2 - New agent roles for genuine clusters (Priority: P2)

**Goal**: Any 2+-skill cluster T003 flagged as not fitting an existing
role gets exactly one new `orchestrate-*` agent, following feature 065's
own frontmatter/tiering/color discipline.

**Independent Test**: Every new agent file's own body cites at least 2
of the mapping's skills as its justification; no cluster of 1 skill
produces a new agent.

### Implementation for User Story 2

- [x] T005 [US2] Review T003's flagged-for-new-cluster skills; group by
  genuinely shared behavior (not just superficial name similarity) —
  reason through explicitly whether each candidate group is real (2+
  skills) or actually just one skill that doesn't fit anywhere and
  should fall back to "no dedicated agent" instead (FR-003).
- [x] T006 [US2] For each confirmed 2+-skill cluster, draft one new
  `.claude/agents/orchestrate-<cluster-name>.md` — real frontmatter
  fields only (`name`/`description`/`tools`/`model`/`color`, per FR-004
  and feature 065's own verified field set), tools tightened to the
  cluster's actual shared behavior, model tier reasoned the same way
  feature 065's 6 agents were (judgment load, not name).
- [x] T007 [US2] Present the full list of newly-drafted agent files for
  explicit confirmation before writing (FR-006, matching
  `specjedi-orchestrate`'s own Step 9 gate) — do not create any file
  until confirmed.
- [x] T008 [US2] Update T004's mapping table: replace each
  "flagged for new cluster" disposition with the actual new agent name
  now that T006/T007 resolved it.

**Checkpoint**: Every skill in the mapping now points to a real,
existing agent file (old or new) or an explicit "no dedicated agent" —
no skill left pointing at a placeholder.

---

## Phase 3: Principle XXIII wiring gap (folded in per explicit confirmation)

**Goal**: `specjedi-implement` and `specjedi-orchestrate` formally
self-invoke `specjedi-docs`'s drafting step, closing the gap
`specjedi-govcheck` flagged during feature 065 (Non-Compliant, advisory,
non-blocking).

- [x] T009 In `.claude/skills/specjedi-implement/SKILL.md`, add a new
  Step 6.7 (after existing 6.6's traceability self-invocation, before
  Step 7's PR-opening): self-invoke `specjedi-docs`'s drafting step per
  Constitution Principle XXIII — check README/CHANGELOG.md/CLAUDE.md
  freshness against what this run just shipped; surface any drafted
  entry in the PR-opening narration, never block on it (same
  non-blocking posture as Step 6.5/6.6).
- [x] T010 In `.claude/skills/specjedi-orchestrate/SKILL.md`, add the
  same self-invocation to Step 9 (artifact-drafting), triggered only
  when Step 9 actually writes a new agent file — checking whether that
  new agent should also appear in README/CLAUDE.md's own skill
  references.
- [x] T011 Update both files' Validation Coverage sections' Out-of-Bounds
  category to note the XXIII self-invocation is itself advisory (a
  failed/skipped doc-freshness check never blocks the skill's own primary
  action), matching Principle XXIII's own documented posture.

**Checkpoint**: The gap `specjedi-govcheck` flagged on feature 065 no
longer exists — both skills carry the discipline forward automatically.

---

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T012 [P] Verify SC-001: count mapping table rows equals 32.
- [x] T013 [P] Verify SC-002: every new agent file (if any) cites 2+
  skills in its own reasoning.
- [x] T014 Cross-check any new `orchestrate-*.md` file and both edited
  `SKILL.md` files against `references/skill-authoring-standard.md` —
  no placeholders, all required sections present.
- [x] T015 Verify `git status` shows changes only to
  `orchestration-plan.md`, any new `.claude/agents/orchestrate-*.md`
  files, the two edited `SKILL.md` files, and this feature's own
  `specs/066-.../` set.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (US1+3)**: No dependencies — can start immediately.
- **Phase 2 (US2)**: Depends on Phase 1's T003 flagging step — can't
  identify a cluster before the classification exists.
- **Phase 3 (XXIII wiring)**: Independent of Phases 1-2 — different
  files (`specjedi-implement`/`specjedi-orchestrate` SKILL.md vs.
  `orchestration-plan.md`/new agent files) — genuinely parallel with
  both.
- **Phase 4 (Polish)**: Depends on Phases 1-3 all being complete.

### Parallel Opportunities

- Phase 3 (T009-T011) can run fully in parallel with Phase 1 (T001-T004)
  and, once Phase 1's T003 lands, Phase 2 — no shared files.
- T012/T013 within Phase 4 are marked [P] — independent verification
  checks, no shared editing.

---

## Notes

- T003's "no dedicated agent" disposition is a first-class, valid
  outcome — not a fallback to avoid. Story 1's Acceptance Scenario 3
  explicitly requires it for pure session-modifiers and one-shot
  conversational skills.
- T007's confirmation gate is the one hard stop in this feature — no new
  agent file gets created before it, regardless of how obviously a
  cluster fits.

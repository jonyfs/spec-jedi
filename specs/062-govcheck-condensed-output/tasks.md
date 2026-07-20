# Tasks: specjedi-govcheck Prints Only Findings, Auto-Proceeds When Clean

**Input**: Design documents from `specs/062-govcheck-condensed-output/`

**Prerequisites**: plan.md (done), spec.md (done)

**Tests**: Not applicable — this feature edits a `SKILL.md` prose
instruction file, not executable code (Constitution Principle VI, plan.md
Constitution Check row). Verification uses the scenario-based dry run at
T007 below.

**Organization**: All edits land in one file
(`.claude/skills/specjedi-govcheck/SKILL.md`) across two behavioral
edit sites (Step 5, Step 6) and four documentation sections (Format,
Example, Always/Never, Verifiable success criteria) — the four
documentation sections are genuinely independent of each other (`[P]`),
but all depend on the two behavioral sites landing first, since they
describe that same behavior.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: None required — no new dependency, script, or scaffolding.

*(No tasks.)*

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: None — the four user stories share no prerequisite beyond
the target file already existing, which it does.

*(No tasks.)*

---

## Phase 3: User Story 1 - A clean governance check prints one line (Priority: P1) 🎯 MVP

**Goal**: An all-clean result collapses to one summary line plus the
next-step bullets — no per-principle table.

**Independent Test**: Given a diff where all 22 rows reason to N/A or
Compliant, running `specjedi-govcheck` produces one summary line and the
next-step bullets — zero table rows.

- [x] T001 [US1] [P] Extend Step 5 in
  `.claude/skills/specjedi-govcheck/SKILL.md` with the condensation
  branching logic (both the all-clean and findings-only paths — one
  coherent edit, since it's a single if/else): all-clean produces the
  one-line summary; findings produce a table with only those rows;
  either way, feed directly into Step 6's next-step bullets with no
  separate pause — exact text per plan.md's "Exact edit sites" §1
  (FR-001, FR-002, FR-004).

**Checkpoint**: Story 1 alone closes the exact, directly-observed waste
this session hit three times (specs/059/060/061's own full-table runs).

---

## Phase 4: User Story 2 - A non-clean check prints only what needs attention (Priority: P1)

**Goal**: Findings-only table — N/A and Compliant rows never printed
when something needs fixing.

**Independent Test**: Given 2 Non-Compliant rows among 22 reasoned
principles, the printed table contains exactly those 2 rows.

- [x] T002 [US2] Confirm Step 5's T001 edit already covers this story's
  behavior (same if/else, findings branch) — no additional Step 5 edit
  needed; this task exists to make the independent-test mapping
  explicit for Story 2, matching FR-003/FR-004.

**Checkpoint**: Stories 1+2 together mean the printed report's size now
tracks the number of *problems*, not the number of *principles checked*.

---

## Phase 5: User Story 3 - Internal reasoning stays complete (Priority: P1)

**Goal**: The condensation is presentation-only — every principle is
still reasoned about internally on every run, a guardrail against
"spend fewer tokens" being misread as "reason about fewer principles."

**Independent Test**: An on-request full report (Story 4) returns all 22
rows with genuine, non-fabricated statuses, proving internal reasoning
was never skipped.

- [x] T003 [US3] [P] Append to Step 6 in
  `.claude/skills/specjedi-govcheck/SKILL.md`: the on-request full-report
  note (also serves Story 4 — see T005's Format section, which this note
  points to) — exact text per plan.md's "Exact edit sites" §2 (FR-005).
- [x] T004 [US3] [P] Extend Always/Never with the reasoning-stays-complete
  guardrail pair: "Always reason through all 20 principles + 2 sections
  internally on every run, even when most rows never print" / "Never
  omit a row from the *internal* reasoning pass to save tokens — only
  the *printed* output condenses" — exact text per plan.md's "Exact
  edit sites" §5 (FR-001).

**Checkpoint**: The guardrail exists in two places (Always/Never +
Verifiable Success Criteria, T007) — this story's real value is
preventing a plausible-but-wrong future edit from silently narrowing
Step 3's own reasoning scope.

---

## Phase 6: User Story 4 - The full table is always available on request (Priority: P2)

**Goal**: Today's existing, unconditional table remains available,
unchanged in shape, whenever a user asks for it.

**Independent Test**: An explicit request for "the full report" produces
the complete 22-row table, identical in shape to today's existing
Format.

- [x] T005 [US1] [US2] [US4] [P] Rewrite the Format section in
  `.claude/skills/specjedi-govcheck/SKILL.md` with three labeled
  variants: (a) condensed CLEAN one-liner, (b) condensed findings-only
  table, (c) the existing full table relabeled "on request," content
  unchanged from today — exact text per plan.md's "Exact edit sites"
  §3 (FR-002, FR-003, FR-004, FR-005).
- [x] T006 [US1] [US2] [P] Rewrite the Example section with two short
  examples (condensed-CLEAN, condensed-findings), each grounded the same
  way today's existing example is (a realistic scratch-branch diff),
  replacing today's single "missing .ps1" example — exact text per
  plan.md's "Exact edit sites" §4.

**Checkpoint**: All four stories complete — the condensed default and
the full-report escape hatch both work, documented consistently across
every required `SKILL.md` section.

---

## Phase 7: Cross-Cutting: Verifiable Success Criteria (Story 3 + 4)

- [x] T007 [US3] [US4] [P] Reword the existing "Every one of the 20
  principles plus the 2 cross-cutting sections appears in the report
  with an explicit status — none silently omitted" bullet in Verifiable
  success criteria to distinguish "reasoned about internally" (still
  always true) from "printed by default" (no longer true for clean
  rows); add a new bullet: "A condensed clean report is under 10 printed
  lines; a condensed findings report's table row count equals exactly
  the finding count" — exact text per plan.md's "Exact edit sites" §6.
  This is the direct fix for the wording conflict plan.md's Constraints
  section identified.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Verification and landing the change per Trunk-Based
workflow (Principle X).

- [x] T008 Re-walk spec.md's acceptance scenarios (Stories 1-4) by hand
  against the actual edited file text (not the planned text) — confirm
  all still hold true post-edit.
- [x] T009 Confirm `.claude/skills/specjedi-govcheck/SKILL.md`'s
  frontmatter (`name: specjedi-govcheck`) still matches its directory
  name, and the file still parses as valid Markdown with YAML
  frontmatter (Principle IX battery item (a), same check as prior
  features this session).
- [x] T010 Confirm the edited file's word/token count stays well under
  Principle XIX's ~5,000-token ceiling (`wc -w`).
- [ ] T011 Commit the change set (`specs/062-govcheck-condensed-output/
  spec.md`, `plan.md`, `tasks.md`, `.claude/skills/specjedi-govcheck/
  SKILL.md`, plus `CLAUDE.md`'s already-updated plan pointer) on the
  `062-govcheck-condensed-output` branch — never commit directly to
  `main`.
- [ ] T012 Self-invoke `specjedi-govcheck` against the branch's diff
  before opening the PR — using *today's* full-report behavior, since
  this run predates the condensed-output change taking effect on itself
  (a real, small irony worth noting in the PR narration: the last
  full-table govcheck run this session, checking the very change that
  ends full-table runs).
- [ ] T013 Push and open a PR against `main`; request auto-merge.
- [ ] T014 Monitor the PR's CI status to a terminal state, diagnosing any
  real failure from actual job logs before pushing a fix.

**Checkpoint**: Feature complete, PR open, CI running or merged.

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → none, empty.
- **Phase 2 (Foundational)** → none, empty.
- **Phase 3 (US1, T001)** and **Phase 5 (US3, T003-T004)** are `[P]` —
  Step 5 and Step 6/Always-Never are different locations in the file,
  genuinely independent edits.
- **Phase 4 (US2, T002)** is a mapping/verification task against T001's
  own edit, not a separate code change — depends on T001.
- **Phase 6 (US4, T005-T006)** and **Phase 7 (T007)** depend on T001 and
  T003 both being complete — Format, Example, and Verifiable Success
  Criteria all describe the behavior T001/T003 implement, and must stay
  consistent with the final wording. T005, T006, and T007 are `[P]`
  relative to each other — three distinct sections of the same file, no
  shared state.
- **Phase 8 (Polish)** depends on **Phases 3-7** being complete: T008-T010
  verify the finished file; T011-T014 land it. T012 (govcheck) MUST run
  before T013 (open PR), matching this session's own established
  ordering for every prior feature.

## Implementation Strategy

### MVP First (User Story 1 Only)

T001 alone already delivers the core value (clean checks stop wasting
tokens) — but Story 2 is the same edit's other branch (no extra work),
Story 3 is the guardrail preventing a future regression of Step 3's own
reasoning scope, and Story 4 preserves the existing full-report
capability this feature must not silently remove. All four ship together
in one PR, matching this session's own established precedent (specs/059,
060, 061) for single-file, sequentially-dependent behavior changes.

### Incremental Delivery

Not warranted here for the same reason as this session's prior features:
one file, tightly-coupled sections describing one coherent behavior
change — fragmenting across PRs would add process overhead without
independent-deployability benefit.

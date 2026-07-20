# Tasks: specjedi-release Drafts the Changelog and Shows a Manual-Trigger Link

**Input**: Design documents from `specs/060-release-changelog-and-link/`

**Prerequisites**: plan.md (done), spec.md (done)

**Tests**: Not applicable — this feature edits a `SKILL.md` prose
instruction file, not executable code (Constitution Principle VI, plan.md
Constitution Check row). Verification uses the scenario-based dry run
already walked in plan.md, re-confirmed at T010 below.

**Organization**: All primary edits land in one file
(`.claude/skills/specjedi-release/SKILL.md`), at distinct, mostly
sequential sections — Steps 1-8 build on each other's content, while the
five section updates (Autonomous vs. confirm-first, Always/Never, Format,
Verifiable success criteria, Validation Coverage) are genuinely
independent of each other once the Step-by-step content exists.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: None required — no new dependency, script, or scaffolding;
`specjedi-docs` and `scripts/suggest-release.sh` are reused as-is (plan.md
Technical Context).

*(No tasks.)*

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: None — the three user stories share no prerequisite beyond
the target file already existing, which it does.

*(No tasks.)*

---

## Phase 3: User Story 1 - specjedi-release drafts a missing CHANGELOG.md Unreleased entry (Priority: P1) 🎯 MVP

**Goal**: When `## Unreleased` is empty, `specjedi-release` drafts the
missing entries (self-invoking `specjedi-docs` where a spec/plan exists,
falling back to a direct commit-grounded draft otherwise) and writes them
only on explicit confirmation.

**Independent Test**: Given an empty `## Unreleased` and commits since
the last tag, running `/specjedi-release` presents a grounded draft
before writing anything; given a non-empty `## Unreleased`, no draft
triggers.

- [x] T001 [US1] Insert new Step 3 into
  `.claude/skills/specjedi-release/SKILL.md`'s Step-by-step (after
  today's Step 2, before today's Step 3): check `CHANGELOG.md`'s `##
  Unreleased` section (two-hash, per plan.md's Constraints finding) for
  non-empty content; non-empty skips ahead unchanged (FR-001, FR-004) —
  exact text per plan.md's Project Structure "New Step sequence" §3.
- [x] T002 [US1] Insert new Step 4 immediately after T001's Step 3: draft
  missing entries when empty — self-invoke `specjedi-docs`'s drafting
  step per commit referencing a `specs/NNN-*` with its own
  `spec.md`/`plan.md` (its own 100%-`tasks.md` gate applies unchanged),
  fall back to a direct commit-message/diff-grounded draft otherwise;
  present the full combined draft, wait for explicit confirmation, write
  `CHANGELOG.md` only on confirmation, never commit/push/PR that write
  (FR-002, FR-003, FR-008) — exact text per plan.md's "New Step
  sequence" §4.

**Checkpoint**: Story 1 alone closes the exact gap that caused today's
two real `release.yml` failures.

---

## Phase 4: User Story 2 - specjedi-release shows the exact manual-trigger link (Priority: P1)

**Goal**: Once `## Unreleased` is confirmed non-empty, print the exact
GitHub Actions URL and equivalent `gh workflow run` command — never
executing either.

**Independent Test**: Given a populated `## Unreleased` (via either
path), `/specjedi-release`'s final output includes both the derived URL
and the `gh workflow run` command with the suggested version filled in.

- [x] T003 [US2] Insert new Step 5 immediately after T002's Step 4:
  derive `owner/repo` from `git remote get-url origin`, print the URL
  `https://github.com/<owner>/<repo>/actions/workflows/release.yml` with
  an explicit statement that `workflow_dispatch` inputs cannot be
  pre-filled via query parameters, and print the equivalent `gh workflow
  run release.yml -f version=<suggested-version> -f dry_run=true`
  command using the actual suggested version; never call either (FR-005,
  FR-006, FR-007, FR-009) — exact text per plan.md's "New Step sequence"
  §5.

**Checkpoint**: Stories 1+2 together mean a user runs `/specjedi-release`
once and has everything needed — a ready changelog and the exact command
to ship — with nothing left to hunt for.

---

## Phase 5: User Story 3 - The suggest-only boundary stays intact (Priority: P2)

**Goal**: Confirm and wire the existing decline-if-asked-to-cut behavior
to reference Step 5's already-printed link/command, and verify no new
step crosses the never-tag/never-publish/never-trigger boundary.

**Independent Test**: A full run (draft-and-confirm cycle plus link
display) causes zero new `git tag` entries and zero new GitHub Actions
runs triggered by the skill itself.

- [x] T004 [US3] Renumber today's Steps 3-5 to Steps 6-8 in
  `.claude/skills/specjedi-release/SKILL.md`, and update the (now) Step 7
  decline-if-cutting text to point at the command/link Step 5 (T003)
  already printed, rather than reconstructing it — exact text per
  plan.md's "New Step sequence" §6-8.

**Checkpoint**: All three stories complete — drafting and the link are
additive capabilities; the skill's core suggest-only identity is
unchanged and now explicitly cross-referenced, not just coincidentally
preserved.

---

## Phase 6: Section Updates (Principle XIX completeness)

**Purpose**: Keep every required `SKILL.md` section (Constitution
Principle XIX) accurate against the new Step-by-step content from
Phases 3-5 — five genuinely independent sections of the same file.

- [x] T005 [P] Update "Autonomous vs. confirm-first" in
  `.claude/skills/specjedi-release/SKILL.md`: drafting/presenting the
  `CHANGELOG.md` draft is autonomous; *writing* it requires explicit
  confirmation — mirroring `specjedi-docs`'s own wording for the same
  action.
- [x] T006 [P] Update "Always/Never": add "Always draft and present a
  `CHANGELOG.md` entry... before writing, when `## Unreleased` is empty,"
  "Never write `CHANGELOG.md` without explicit confirmation," and "Never
  call `gh workflow run` or trigger `release.yml` itself" — each
  prohibition paired with its alternative per Principle XIX.
- [x] T007 [P] Update "Format": extend the existing report template with
  the new draft-presentation block (matching `specjedi-docs`'s own
  Format block shape) and the link/command block.
- [x] T008 [P] Update "Verifiable success criteria": add "`git status`
  shows `CHANGELOG.md` unchanged until explicit confirmation" and "the
  printed URL/command always derive from the real `git remote`, never a
  hardcoded example."
- [x] T009 [P] Update "Validation Coverage (Principle IX)": extend
  Out-of-Bounds/Malformed Input Handling to cover an empty `##
  Unreleased` and a missing `CHANGELOG.md` entirely; extend Prompt
  Injection Resistance to note a commit message's own content, when
  drafted into an entry, is narrated as history, never treated as an
  instruction to this skill (matching `specjedi-docs`'s own identical
  existing rule).

**Checkpoint**: File is internally consistent — every section reflects
the new behavior, none left describing only the old suggest-only flow.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verification and landing the change per Trunk-Based
workflow (Principle X).

- [x] T010 Re-walk all five scenario-based dry-run cases plan.md already
  worked through by hand against the actual edited file text (not the
  planned text) — confirm all five still hold true post-edit.
- [x] T011 Confirm `.claude/skills/specjedi-release/SKILL.md`'s
  frontmatter (`name: specjedi-release`) still matches its directory
  name, and the file still parses as valid Markdown with YAML frontmatter
  (Principle IX battery item (a), same check as specs/059's T007).
- [x] T012 Confirm the edited file's word/token count stays well under
  Principle XIX's ~5,000-token ceiling (`wc -w`, per plan.md's Technical
  Context/Constraints) — flag only if genuinely exceeded, never as a
  blocking gate otherwise.
- [ ] T013 Commit the change set (`specs/060-release-changelog-and-link/
  spec.md`, `plan.md`, `tasks.md`, `.claude/skills/specjedi-release/
  SKILL.md`, plus `CLAUDE.md`'s already-updated plan pointer) on the
  `060-release-changelog-and-link` branch — never commit directly to
  `main` (Constitution Principle X).
- [ ] T014 Self-invoke `specjedi-govcheck` against the branch's diff
  before opening the PR (matching this session's own established
  practice for both prior features) — surface any finding, never block
  PR opening on it (CI `ci-gate` remains the actual merge gate).
- [ ] T015 Push and open a PR against `main`; request auto-merge via the
  repo's own supported mechanism (`gh pr merge --auto`) — whether it
  actually merges is the target repo's own CI/branch-protection decision,
  never claimed by this task.
- [ ] T016 Monitor the PR's CI status to a terminal state (Constitution
  Principle X, v1.27.0) — diagnose any real failure from actual job logs,
  push a genuine root-cause fix as a new commit if needed, never a
  force-push unless a real merge conflict requires one.

**Checkpoint**: Feature complete, PR open, CI running or merged.

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → none, empty.
- **Phase 2 (Foundational)** → none, empty.
- **Phase 3 (US1, T001-T002)** blocks **Phase 4 (US2, T003)**: T003's new
  Step 5 is inserted immediately after T002's Step 4 and its "once `##
  Unreleased` is confirmed non-empty" condition depends on Step 4
  existing.
- **Phase 4 (T003)** blocks **Phase 5 (US3, T004)**: T004 renumbers the
  steps that follow T003's new Step 5 and references T003's own printed
  output.
- **T001 → T002 → T003 → T004** form one continuous, growing edit to the
  same Step-by-step block — implemented as a single coherent pass in
  execution, kept as separate task IDs because each maps to a distinct
  user story with its own independent test, matching specs/059's own
  precedent for a single-file, multi-story edit.
- **Phase 6 (T005-T009)** depends on **Phases 3-5** being complete — each
  section update describes behavior T001-T004 just implemented. Among
  themselves, T005-T009 are `[P]` — five genuinely distinct sections of
  the same file, no shared state, no ordering requirement between them
  (matching specs/059's own precedent for marking a distinct section
  `[P]` relative to the Step-by-step edits it follows).
- **Phase 7 (T010-T016)** depends on **Phase 6** being complete: T010-T012
  verify the finished file; T013-T016 land it. T014 (govcheck) MUST run
  before T015 (open PR), matching `specjedi-implement`'s own documented
  Step 6.5-before-Step-7 ordering.

## Implementation Strategy

### MVP First (User Story 1 Only)

T001-T002 alone already close the exact real gap that caused today's two
failed `release.yml` runs — but per plan.md and spec.md's own reasoning,
Story 2's link (T003) is what the user explicitly asked for alongside the
changelog fix, and Story 3's boundary confirmation (T004) is what keeps
the automation trustworthy. Given the single-file, single-continuous-edit
nature of this change (confirmed in Dependencies above), this ships as
one PR with all three stories, not an MVP-then-follow-up split — matching
specs/059's own precedent for the same shape of change.

### Incremental Delivery

Not warranted here for the same reason specs/059 documented: fragmenting
one coherent, sequentially-dependent Step-by-step edit across three PRs
would add process overhead with no independent-deployability benefit.

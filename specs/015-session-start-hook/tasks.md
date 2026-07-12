# Tasks: Session-Start Orientation Hook

**Input**: Design documents from `/specs/015-session-start-hook/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's Technical
Context. `quickstart.md`'s 6 scenarios (including a real live session start)
serve as this feature's actual verification, run in Phase 5/6 below.

**Organization**: Tasks are grouped by user story (spec.md priorities P1/P1/P2)
to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

`scripts/session-start.sh` + `.ps1`, `.claude/settings.json`, `CLAUDE.md` —
matches plan.md's Structure Decision exactly.

---

## Phase 1: Setup

**Purpose**: Create the two script files this feature builds on

- [X] T001 [P] Create `scripts/session-start.sh` skeleton (shebang, `set -euo
      pipefail`-equivalent safety, structure comment) following
      `scripts/validate.sh`'s existing conventions in this repo
- [X] T002 [P] Create `scripts/session-start.ps1` skeleton following
      `scripts/validate.ps1`'s existing conventions in this repo

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The status-derivation logic every user story's summary output
depends on

**⚠️ CRITICAL**: US1's summary, US2's payload assembly, and US3's end-to-end
render all need this to exist and be correct first

- [X] T003 Re-read `.claude/skills/specjedi-status/SKILL.md`'s derivation
      logic (spec/plan/tasks presence, checkbox-completion percentage,
      status-bucket categorization) end to end and confirm
      `data-model.md`'s Status Bucket table matches it exactly — working
      understanding used directly by T004

**Checkpoint**: Foundation ready — Phase 3 status-summary implementation can
begin

---

## Phase 3: User Story 1 - Returning contributor sees exactly what's changed (Priority: P1) 🎯 MVP

**Goal**: A fresh session's opening reply states an accurate, on-disk-derived
project status with no user action required.

**Independent Test**: Run `scripts/session-start.sh` standalone; confirm its
status summary matches what a manual `specjedi-status` run would report for
the same repo state.

### Implementation for User Story 1

- [X] T004 [US1] Implement status-bucket counting (specified/planned/
      in_progress/complete/not_started) in `scripts/session-start.sh`, per
      `data-model.md`'s Status Bucket derivation table (depends on T001, T003)
- [X] T005 [US1] Implement the zero-features case ("no features yet," plain
      statement) matching `specjedi-status`'s own zero-state handling — never
      an empty/error output (depends on T004)
- [X] T006 [US1] Format the 1-3 line status summary per `data-model.md`'s
      Session Orientation Payload part 2 shape (total count + per-bucket
      counts, optionally the most-recently-touched feature) (depends on T004,
      T005)
- [X] T007 [P] [US1] Port T004-T006's status logic to
      `scripts/session-start.ps1` (depends on T002, T003)

**Checkpoint**: `scripts/session-start.sh` produces an accurate status
summary standalone — User Story 1 is independently satisfied.

---

## Phase 4: User Story 2 - A recognizable, in-voice greeting on every session (Priority: P2)

**Goal**: Every session shows an original ASCII banner and a rotating Master
Yoda-styled line, not the same one every time.

**Independent Test**: Run the script 5 times in a row; confirm the banner is
present each time and the Yoda line is not identical across all 5 runs.

### Implementation for User Story 2

- [X] T008 [P] [US2] Design and embed an original ASCII Spec Jedi banner
      (wordmark/lightsaber rendering, ~8-12 lines) in
      `scripts/session-start.sh` — explicitly verify it is not a
      reproduction of GitHub's actual `spec-kit` logo or any other real
      trademark, per Principle XXI's guardrail (depends on T001)
- [X] T009 [P] [US2] Implement stateless Yoda-line rotation in
      `scripts/session-start.sh` (a cheap, no-new-tracking-file selection
      signal, e.g. timestamp-modulo) reading
      `references/star-wars-lexicon.md`'s Master Yoda Persona rotation pool
      (depends on T001)
- [X] T010 [US2] Assemble the full three-part payload (banner + status
      summary + Yoda line) in `scripts/session-start.sh`, with blank-line
      separators, confirmed under the 10,000-character `additionalContext`
      cap (depends on T006, T008, T009)
- [X] T011 [P] [US2] Port T008-T010's banner/rotation/assembly logic to
      `scripts/session-start.ps1` (depends on T007, T002)

**Checkpoint**: Full three-part payload assembles correctly and stays under
the character cap — User Story 2 is independently satisfied.

---

## Phase 5: User Story 3 - The hook alone isn't enough; rendering is verified end-to-end (Priority: P1)

**Goal**: The greeting is actually visible in a real session's opening
reply, and a broken hook never blocks a session from starting.

**Independent Test**: Start a real fresh Claude Code session; confirm the
banner/status/Yoda content appears in the assistant's first chat message.

### Implementation for User Story 3

- [X] T012 [US3] Register `scripts/session-start.sh` (bash) /
      `scripts/session-start.ps1` (PowerShell, OS-conditional) under
      `SessionStart` in `.claude/settings.json`, emitting via
      `hookSpecificOutput.additionalContext` (depends on T010, T011)
- [X] T013 [US3] Add the render instruction to `CLAUDE.md`: when a
      `SessionStart` `additionalContext` block is present at the start of a
      session, render its content verbatim as the opening reply — per
      Principle XXI, this instruction is load-bearing, not optional
      (depends on T012)
- [X] T014 [US3] Implement graceful degradation in both scripts: a missing/
      unreadable `references/star-wars-lexicon.md`, a project with zero
      features, or any unexpected error MUST NOT prevent the session from
      starting — worst case is a shorter/plainer fallback greeting (depends
      on T010, T011)
- [X] T015 [US3] Real dry run (`quickstart.md` Scenario 4): temporarily
      rename `references/star-wars-lexicon.md`, run the script, confirm it
      still exits cleanly with a fallback greeting rather than an error;
      restore the file afterward (depends on T014)

**Checkpoint**: Hook registered, render instruction in place, degradation
verified — User Story 3 is satisfied, pending the live end-to-end check in
Phase 6.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Run every `quickstart.md` scenario for real, then update the
project's own bookkeeping

- [X] T016 [P] Run `quickstart.md` Scenario 1 (standalone output + character
      count) — confirm well under 10,000 chars
- [X] T017 [P] Run `quickstart.md` Scenario 2 (status count cross-check
      against a manual `specjedi-status`-equivalent count) — confirm they
      agree
- [X] T018 [P] Run `quickstart.md` Scenario 3 (5 consecutive runs) — confirm
      observable Yoda-line rotation
- [X] T019 Run `quickstart.md` Scenario 6 (PowerShell parity, if `pwsh`
      available on this machine) — confirm same three-part shape
- [X] T020 Run `quickstart.md` Scenario 5 (real end-to-end session start) —
      the single most important verification in this feature (SC-003).
      **Now completed, with cited evidence** (closed in
      `specs/022-session-start-verification/`, 2026-07-12): a real
      `SessionStart:compact` hook fired later in this same project's
      lifetime (a different, subsequent conversation from the one that
      built this feature), producing exactly the payload this feature
      specifies:
      ```text
      ┌──────────────────────────────────────────┐
      │   ⚔══════  S P E C   J E D I  ══════⚔     │
      │        Spec-Driven Development, sharpened   │
      └──────────────────────────────────────────┘

      18 feature(s): 15 complete, 3 in progress, 0 planned, 0 specified, 0 not started.

      A project with a plan, you have. Proceed, you may.
      ```
      Verified: the banner rendered correctly and uncorrupted, the status
      summary was a real, accurate count derived from on-disk `specs/*/`
      state (not a hardcoded string), and the Yoda line was correctly
      gated to the non-empty-project branch (matching the T-series bug
      fix this feature shipped). This was a `SessionStart:compact`
      firing (a context-compaction event) rather than a from-scratch
      `startup` firing — the same registered hook/script fires for
      either matcher, so this satisfies the mechanism-correctness
      question this task asks; a `startup`-specific firing was not
      separately observed. See
      `specs/022-session-start-verification/research.md` for the full
      analysis, including a separately-resolved render-instruction-
      precedence question this same observation surfaced.
- [X] T021 Run `bash scripts/validate.sh` and `pwsh scripts/validate.ps1`,
      confirm `PASSED` with zero unexpected WARN lines
- [X] T022 Update `references/principle-traceability.md`'s Principle XXI row
      — set to `🟡 Partial` (not `✅ Mechanized`), citing this feature and
      naming T020's live-render gap explicitly, per the honest status
      above rather than the originally-planned full-✅ close
- [X] T023 Add a new `## Unreleased` → `### Added` entry to `CHANGELOG.md`
      for this feature
- [X] T024 Review the README badge row per the Distribution & Ecosystem
      Standards section's "before opening any pull request" requirement —
      determine whether this feature warrants a new/updated badge (likely
      not, since it's an internal hook mechanism, not a shipped skill) and
      document that determination in the PR description. **Determination**:
      no badge change needed — this feature adds no skill/roadmap item/
      language; Skills (23), Pipeline (9/9), Roadmap (12/12), and
      Languages (11) counts are all unaffected.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all of Phase 3
- **User Story 1 (Phase 3)**: Depends on Foundational (T003)
- **User Story 2 (Phase 4)**: Depends only on Setup (T001/T002) — can run in
  parallel with Phase 3 (different concerns within the same file, but T010's
  assembly step depends on T006 from Phase 3 completing first)
- **User Story 3 (Phase 5)**: Depends on both Phase 3 and Phase 4 completing
  (T010/T011's assembled payload is what gets registered and rendered)
- **Polish (Phase 6)**: Depends on Phase 5 completing

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only
- **User Story 2 (P2)**: Depends on Setup only for its own banner/rotation
  work (T008/T009), but its assembly step (T010) depends on US1's T006
- **User Story 3 (P1)**: Depends on both US1 and US2's assembled output —
  genuinely sequential here, unlike feature 014's fully-decoupled stories,
  because "render the payload" requires the payload to exist first

### Parallel Opportunities

- T001/T002 (bash + PowerShell skeletons) in parallel
- T008/T009 (banner design, Yoda rotation) in parallel with each other and
  with Phase 3's T004-T006
- T016/T017/T018 (Polish verification scenarios) in parallel with each other

---

## Parallel Example: Setup + User Story 2's independent pieces

```bash
Task: "Create scripts/session-start.sh skeleton"
Task: "Create scripts/session-start.ps1 skeleton"
Task: "Design an original ASCII Spec Jedi banner"
Task: "Implement stateless Yoda-line rotation logic"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (T003)
3. Complete Phase 3: User Story 1 (T004-T007)
4. **STOP and VALIDATE**: run the script standalone, confirm the status
   summary is accurate
5. This alone isn't the full feature (no rendering yet), but it's the core
   data-correctness foundation everything else builds on

### Incremental Delivery

1. Setup + Foundational → derivation logic ready
2. Add User Story 1 → accurate status summary, standalone-verifiable
3. Add User Story 2 → full three-part payload assembles correctly
4. Add User Story 3 → hook registered, `CLAUDE.md` wired, degradation
   verified
5. Polish → all 6 quickstart scenarios run for real, including the live
   session-start check that actually proves this feature delivers value

---

## Notes

- [P] tasks = different files or independent concerns, no dependencies
- [Story] label maps task to specific user story for traceability
- T020 (the real live session-start check) was the single task this whole
  feature existed to satisfy — closed 2026-07-12 with cited evidence, see
  `specs/022-session-start-verification/`
- Commit after each phase, not after every single task

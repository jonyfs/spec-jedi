# Tasks: Simplify README Installation to Bootstrap-Only

**Input**: Design documents from `/specs/030-simplify-install-bootstrap/`

**Prerequisites**: plan.md, spec.md, research.md, quickstart.md

**Tests**: Not requested — Principle VI exemption stated in plan.md's
Technical Context: this feature's entire deliverable is `README.md`
prose, no executable logic. `quickstart.md`'s 6 scenarios serve as this
feature's actual verification, run in Polish.

**Organization**: Tasks grouped by user story (spec.md priorities P1, P2).

## Path Conventions

One file touched: `README.md`, `## Installation` section
(currently lines 239-340 — `### Claude Code (fully supported today)` at
241 through the line immediately before `### Supported harnesses` at
341, confirmed via `grep -n` this session). No other file changes.

---

## Phase 1: User Story 1 — Install with a single command, no clone (P1)

**Goal**: The Installation section presents exactly one path — a bash
command block and a PowerShell command block, both forwarding
`--harness`/`--auto` — with zero `git clone` commands anywhere in the
section.

**Independent Test**: Read only the Installation section top to bottom;
confirm a working install is reachable from the first command block
shown, no branching decision required first.

- [X] T001 [US1] In `README.md`: remove the `### Claude Code (fully
      supported today)` subsection in full (today's clone-and-open
      walkthrough, its Mermaid flowchart, and its four numbered steps) —
      this flow is for contributors developing Spec Jedi itself, not
      end-users installing into their own project (spec.md Edge Cases).
- [X] T002 [US1] In `README.md`: remove the "Using Spec Jedi in a
      project other than this one?" clone-and-run-`install.sh`
      subsection in full — fully superseded by the bootstrap one-liner.
- [X] T003 [US1] In `README.md`: write the single bash command block —
      `curl -fsSL .../bootstrap-install.sh | bash -s --
      /path/to/your-project --harness <harness>` — plus 1-2 lines of
      prose introducing it (no numbered step, per `/speckit-clarify`'s
      Session 2026-07-13 decision), reusing the exact command already
      documented in today's "Don't want to clone the repo at all?"
      subsection as the source text.
- [X] T004 [US1] In `README.md`: write the single PowerShell command
      block using the `&([scriptblock]::Create((iwr ...).Content))
      -TargetDir ... -Harness ...` form from `research.md` (not the bare
      `iwr | iex` form, which cannot forward parameters) — placed
      immediately after T003's bash block, same section, matching
      structure.
- [X] T005 [US1] In `README.md`: retain `--harness`/`--auto` usage
      guidance and the working link to `#supported-harnesses`
      immediately below the two command blocks from T003/T004 — reuse
      today's existing explanatory sentence about optional `--harness`
      and auto-detection, trimmed to fit the minimal format.
- [X] T006 [US1] In `README.md`: confirm the `## Installation` section
      now contains no `` ```mermaid `` code fence and no numbered list
      (`1.`, `2.`, ...) — only prose plus the two command blocks (SC-001,
      SC-003).

**Checkpoint**: A reader can install via one command per OS; zero
`git clone` commands remain in the section.

---

## Phase 2: User Story 2 — Honest behavior before the first release ships (P2)

**Goal**: Confirm the simplified section relies on
`scripts/bootstrap-install.sh`/`.ps1`'s own existing honest-failure
message rather than duplicating that guidance in README prose, and that
the message still fires correctly today.

**Independent Test**: Run the one-liner exactly as shown in the
simplified README against this repository's real (currently empty)
release list; confirm the terminal output alone tells the reader what to
do next, without consulting the README again.

- [X] T007 [P] [US2] Read the rewritten `## Installation` section
      (post-T001–T006) and confirm no line restates "no GitHub Release
      published yet" or a similar explanation in prose (FR-004) — the
      script's own printed message is the single source of truth.
- [X] T008 [P] [US2] Run `./scripts/bootstrap-install.sh` (no args, or
      `--help`) against this checkout for real; confirm the existing "no
      release found" message and `git clone` fallback command print
      correctly, unchanged — `scripts/bootstrap-install.sh`/`.ps1`
      themselves are not modified by this feature (quickstart.md
      Scenario 4).

**Checkpoint**: The "no release yet" case is fully covered by existing,
unmodified script behavior — no README prose duplicates it.

---

## Phase 3: Polish & Cross-Cutting Concerns

- [X] T009 Run `quickstart.md`'s 6 scenarios in order (bash one-liner
      correct, PowerShell forwards parameters, zero `git clone`, honest
      failure path unchanged, `scripts/validate.sh` passes, section reads
      as minimal format) — record any deviation and fix before proceeding.
- [X] T010 Badge-row review per the Distribution & Ecosystem Standards
      section (Principle X's pre-PR requirement): confirm no badge in
      `README.md`'s header needs updating — this feature changes neither
      skill count, roadmap status, nor any other badge-bearing fact:
      expected outcome is "nothing to update," confirmed rather than
      assumed.

---

## Dependencies & Execution Order

- **Phase 1 (US1)**: No dependencies — this is the feature's entire
  content change. T001 and T002 both edit the same section and MUST run
  sequentially (not `[P]`) to avoid conflicting edits to overlapping
  text. T003 → T004 → T005 → T006 are sequential for the same reason
  (each builds on the region the previous task just wrote).
- **Phase 2 (US2)**: Depends on Phase 1 being complete (T007 reads the
  post-rewrite section). T007 and T008 are independent of each other —
  one reads `README.md`, the other runs a script — genuinely parallel.
- **Phase 3 (Polish)**: Depends on both phases above. T009 exercises the
  finished section end-to-end; T010 is independent of T009 (different
  concern — badge accuracy, not install-flow correctness) but ordered
  last as this project's standing pre-PR convention.

## Notes

- No task in this feature required a failing-test-first task per
  Principle VI — the exemption is stated in `plan.md`'s Constitution
  Check and re-stated in this file's header.
- `scripts/bootstrap-install.sh`/`.ps1` are read but never modified —
  every task in this file touches `README.md` only, except T008 (runs
  the script, doesn't edit it).

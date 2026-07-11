# Feature Specification: The `specjedi-*` SDD Pipeline

**Feature Branch**: `001-specjedi-pipeline`

**Created**: 2026-07-11

**Status**: Draft

**Input**: User description: "Build the core specjedi-* SDD skill pipeline
(constitution, specify, clarify, plan, tasks, implement, analyze, checklist,
converge) that will replace the vendored speckit-* bootstrap tooling as Spec
Jedi's actual end-user product, per Constitution Principle XV and
TODO(SPECJEDI_PIPELINE)."

## Clarifications

### Session 2026-07-11

Run autonomously per explicit maintainer instruction to resolve what can
reasonably be judged and defer only genuine blockers. Each answer reflects
the "Recommended" option this skill would have proposed to a human, applying
research.md's findings rather than guessing.

- Q: Should `specjedi-*` skills support an explicit `--auto`/unattended flag
  from day one? → A: Yes, in minimal form from day one (research.md #7, GSD)
  — low-cost, directly serves autonomous-session use, no reason to defer.
- Q: When both `speckit-*` and `specjedi-*` skills are installed in the same
  project, should `specjedi-*` skills interoperate with `speckit-*`-produced
  artifacts, or treat them as separate namespaces? → A: Read-compatible —
  `specjedi-*` skills MAY read an existing `speckit-*`-produced
  `constitution.md`/`spec.md` if present, but every artifact a `specjedi-*`
  skill *writes* follows its own branding/format going forward. No forced
  separate namespace, no built migration tooling required for v1.
- Q: What should `specjedi-plan` (or later stages) do if no
  `constitution.md` exists yet? → A: Don't block with an error and don't
  silently proceed without one — surface a guided next-step suggestion
  (Principle XIV) recommending `specjedi-constitution` first, then let the
  user decide whether to proceed anyway.
- Q: How should Principle IV's bulleted clarifying questions degrade on a
  harness without native structured-question UI (e.g., no
  `AskUserQuestion`-equivalent)? → A: Fall back to plain numbered questions
  in chat text, following the same per-harness `<runtime_note>` mapping
  pattern found in GSD (research.md #7) rather than skipping clarification
  entirely.
- Q: Is a dedicated migration path needed for a `tasks.md` produced by the
  old `speckit-tasks` being read by `specjedi-implement`? → A: Out of scope
  for v1, resolved by the interop answer above — `specjedi-implement` only
  reads `specjedi-*`-produced `tasks.md`; no cross-pipeline task migration
  tooling is built in this cycle.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Establish a project's rules with `specjedi-constitution` (Priority: P1)

A user installs the Spec Jedi skill pack into their own project (not this
repo) and runs `specjedi-constitution` to establish that project's
non-negotiable principles — the same job `speckit-constitution` does today,
but branded as Spec Jedi's own product, and improved per this project's own
constitution (Star Wars voice per Principle XII, guided next-step suggestion
per Principle XIV, prompt-engineering discipline per Principle XIX).

**Why this priority**: Every other `specjedi-*` skill checks its output
against the constitution. Without it, nothing downstream has a foundation to
build on — this is the one story that unblocks all the others, mirroring why
`/speckit-constitution` is the first command spec-kit itself teaches.

**Independent Test**: In a fresh project (no prior Spec Jedi artifacts), run
`specjedi-constitution` with a plain-language description of project
principles. Verify it produces a valid `.specify/memory/constitution.md` with
no leftover placeholder tokens, a correct Sync Impact Report, and a
semantically-versioned version line — fully usable on its own even if no
other `specjedi-*` skill exists yet.

**Acceptance Scenarios**:

1. **Given** a fresh project with no constitution, **When** the user runs
   `specjedi-constitution` describing their project's rules, **Then** the
   skill produces a complete `constitution.md` (no bracketed placeholders)
   with a Sync Impact Report and a `1.0.0` initial version.
2. **Given** an existing `constitution.md`, **When** the user asks for an
   amendment, **Then** the skill applies semantic versioning correctly (MAJOR
   for incompatible principle changes, MINOR for additions, PATCH for
   clarifications) and updates the Sync Impact Report to match.
3. **Given** the user's request is ambiguous about scope or contradicts an
   existing principle, **When** `specjedi-constitution` runs, **Then** it asks
   a bulleted clarifying question (Principle IV) instead of guessing.

---

### User Story 2 - Turn an idea into a spec with `specjedi-specify` (Priority: P2)

A user with a feature idea — however unstructured — runs `specjedi-specify`
to get a prioritized, testable `spec.md`, welcoming a rougher starting point
than spec-kit's `speckit-specify` typically expects (research finding:
Superpowers' brainstorm-before-spec instinct, adapted).

**Why this priority**: Second-most foundational — nothing can be planned or
built without a spec, and this is the first place most users will actually
interact with the product day to day.

**Independent Test**: Given only a one-sentence feature idea, run
`specjedi-specify` and verify it produces a `spec.md` with prioritized (P1,
P2, P3...), independently-testable user stories, functional requirements, and
explicit `NEEDS CLARIFICATION` markers for anything genuinely ambiguous —
without needing `specjedi-constitution` to have produced anything beyond a
minimal or even placeholder constitution.

**Acceptance Scenarios**:

1. **Given** a one-sentence feature idea, **When** the user runs
   `specjedi-specify`, **Then** the resulting `spec.md` has at least one P1
   user story with an independent test and acceptance scenarios.
2. **Given** the idea leaves a requirement's behavior unclear, **When** the
   spec is generated, **Then** the unclear requirement is marked
   `NEEDS CLARIFICATION` rather than silently assumed.

---

### User Story 3 - Resolve ambiguity with `specjedi-clarify` (Priority: P3)

A user runs `specjedi-clarify` on a spec containing `NEEDS CLARIFICATION`
markers (or vaguer ambiguity) and gets asked up to 5 targeted, bulleted
questions whose answers get encoded back into the spec.

**Why this priority**: Directly protects Principle V (specs must be complete
enough for autonomous execution) — without this, ambiguity silently survives
into planning and implementation.

**Independent Test**: Given a spec with at least one `NEEDS CLARIFICATION`
marker, run `specjedi-clarify` and verify each marker is either resolved (with
the answer written back into the relevant section) or explicitly deferred
with a stated reason — never silently dropped.

**Acceptance Scenarios**:

1. **Given** a spec with 3 ambiguous requirements, **When**
   `specjedi-clarify` runs, **Then** the user is asked bulleted
   multiple-choice-style questions (Principle IV) for each, and answers are
   written back into `spec.md`.
2. **Given** a spec with no ambiguity, **When** `specjedi-clarify` runs,
   **Then** it reports nothing needs clarifying rather than inventing
   questions to ask.

---

### User Story 4 - Produce a technical plan with `specjedi-plan` (Priority: P4)

A user runs `specjedi-plan` against a clarified spec and gets a `plan.md`
(plus supporting `research.md`/`data-model.md` as applicable) detailed enough
that implementation never has to stop and search the codebase for a missing
convention (research finding: PRP's "golden rule," adopted).

**Why this priority**: The technical bridge between "what" (spec) and "how"
(tasks/implementation) — without it, task breakdown has nothing concrete to
decompose.

**Independent Test**: Given a clarified `spec.md`, run `specjedi-plan` and
verify the resulting `plan.md` passes a Constitution Check gate and captures
every project-specific convention/pattern a later implementation step would
otherwise need to search for.

**Acceptance Scenarios**:

1. **Given** a clarified spec, **When** `specjedi-plan` runs, **Then**
   `plan.md` includes a Constitution Check section referencing the actual
   installed `constitution.md`.
2. **Given** a plan violates a constitution principle without justification,
   **When** the Constitution Check runs, **Then** the violation is recorded in
   a Complexity Tracking table or the plan is simplified — never silently
   passed.

---

### User Story 5 - Break the plan into tasks with `specjedi-tasks` (Priority: P5)

A user runs `specjedi-tasks` against a plan and gets an ordered,
dependency-aware `tasks.md` organized by user story, so each story can be
implemented and tested independently.

**Why this priority**: Converts a plan into actionable, sequenced work —
required before autonomous implementation can proceed.

**Independent Test**: Given a `plan.md` with 2+ user stories, run
`specjedi-tasks` and verify tasks are grouped per story, dependency-ordered,
and each parallelizable task is marked `[P]`.

**Acceptance Scenarios**:

1. **Given** a plan with P1 and P2 stories, **When** `specjedi-tasks` runs,
   **Then** `tasks.md` groups tasks under each story so P1 alone is a
   completable slice.

---

### User Story 6 - Execute tasks with `specjedi-implement` (Priority: P6)

A user runs `specjedi-implement` against `tasks.md` and the skill executes
tasks in dependency order, test-first where applicable (Principle VI),
committing through the branch+PR+`ci-gate` pipeline (Principle X) rather than
directly to `main`.

**Why this priority**: The actual code-producing step — highest value once
everything upstream exists, but has the most prerequisites.

**Independent Test**: Given a `tasks.md` with a P1 story fully specified,
run `specjedi-implement` and verify it completes that story's tasks, runs
tests before marking them done where tests apply, and never commits directly
to a protected branch.

**Acceptance Scenarios**:

1. **Given** a task that produces code, **When** `specjedi-implement` runs it,
   **Then** a failing test is written first (Principle VI) unless the plan
   states tests don't apply and why.

---

### User Story 7 - Cross-check consistency with `specjedi-analyze` (Priority: P7)

A user runs `specjedi-analyze` at any point to verify `spec.md`, `plan.md`,
and `tasks.md` remain consistent with each other and with the constitution.

**Why this priority**: A safety net, not a blocker — valuable but not
required for the pipeline's first working slice.

**Independent Test**: Given intentionally inconsistent spec/plan/tasks (e.g.
a task referencing a requirement removed from the spec), run
`specjedi-analyze` and verify it surfaces the inconsistency without modifying
any file (non-destructive).

---

### User Story 8 - Generate a targeted checklist with `specjedi-checklist` (Priority: P8)

A user requests a custom checklist for the current feature (e.g., a security
review checklist) and gets one generated from the actual feature context
rather than a generic template.

**Why this priority**: Nice-to-have utility layered on an already-working
pipeline.

**Independent Test**: Given a feature spec, request a checklist for a named
concern and verify every generated item traces back to something in that
spec/plan, not boilerplate.

---

### User Story 9 - Reconcile drift with `specjedi-converge` (Priority: P9)

A user runs `specjedi-converge` after manual code changes to detect any gap
between the codebase and spec/plan/tasks, appending remaining work back into
`tasks.md`.

**Why this priority**: Handles the "reality drifted from the plan" case —
valuable for long-lived features, least critical for a first release.

**Independent Test**: Given a codebase with a manually-added feature not
reflected in `tasks.md`, run `specjedi-converge` and verify the gap is
appended to `tasks.md` as new tasks rather than silently ignored.

### Edge Cases

- `specjedi-implement` running against a `tasks.md` produced by the OLD
  `speckit-tasks` (mixed pipeline, mid-migration): out of scope for v1 — each
  `specjedi-*` skill only reads `tasks.md` its own pipeline produced (resolved,
  Clarifications Session 2026-07-11).
- A user runs `specjedi-plan` (or any later stage) before
  `specjedi-constitution` has ever run: the skill surfaces a guided next-step
  suggestion recommending `specjedi-constitution` first (Principle XIV) rather
  than blocking with a bare error or silently proceeding without one; the user
  still decides whether to continue anyway (resolved, Clarifications Session
  2026-07-11).
- A harness without `AskUserQuestion`-style structured prompts: falls back to
  plain numbered questions in chat text, using the same per-harness
  `<runtime_note>` mapping pattern GSD uses (resolved, Clarifications Session
  2026-07-11).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each `specjedi-*` pipeline skill MUST be independently usable —
  a user with only `specjedi-constitution` installed gets full value from it
  without the rest of the pipeline existing.
- **FR-002**: Every `specjedi-*` skill MUST check its own output against the
  installed project's `constitution.md` when one exists (mirroring spec-kit's
  Constitution Check gate).
- **FR-003**: Every `specjedi-*` skill MUST follow the Skill Authoring &
  Prompt Engineering Standard (Constitution Principle XIX): persona, explicit
  task, defined output format, at least one full input→output example, and
  chain-of-thought instruction for any non-deterministic judgment call.
- **FR-004**: Every `specjedi-*` skill MUST offer a guided next step at the
  end of its output (Principle XIV) as a bulleted, selectable list.
- **FR-005**: Every `specjedi-*` skill MUST proactively self-check for skill
  gaps via `specjedi-find-skills`' proactive contract (Principle XVII) when it
  notices a domain its own competence doesn't cover.
- **FR-006**: `specjedi-implement` MUST commit only through a feature branch
  and pull request, never directly to a protected branch (Principle X);
  actual merge behavior depends on the target repository's own CI/branch
  protection, which `specjedi-implement` does not control.
- **FR-007**: Each skill's end-user-facing output (not the literal content of
  generated `spec.md`/`plan.md`/`tasks.md` fields) MUST use Spec Jedi's voice
  (Principle XII) — bold, funny, Star Wars-flavored, core meaning surviving
  without the reference.
- **FR-008**: Every `specjedi-*` skill MUST support a minimal `--auto`
  unattended flag from day one (Clarifications, Session 2026-07-11): ask
  what it must up front, then proceed without further stops, per the pattern
  found in GSD (research.md #7).
- **FR-009**: `specjedi-*` skills MAY read an existing `speckit-*`-produced
  `constitution.md`/`spec.md` when one is present in the target project
  (read-compatible), but every artifact a `specjedi-*` skill *writes* MUST
  follow its own branding and format — no forced separate namespace, no
  cross-pipeline migration tooling required for v1 (Clarifications, Session
  2026-07-11).

### Key Entities

- **Pipeline skill**: one of the 9 `specjedi-*` skills (constitution, specify,
  clarify, plan, tasks, implement, analyze, checklist, converge), each a
  `SKILL.md` under `.claude/skills/specjedi-<subject>/`.
- **Project artifact**: `constitution.md`, `spec.md`, `plan.md`, `tasks.md` —
  the files a pipeline skill reads and/or writes, scoped to whatever project
  has Spec Jedi installed (this repo, or an end user's own project).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user with zero prior Spec Jedi experience can install the
  pack and produce a valid `constitution.md` via `specjedi-constitution`
  without reading external documentation first — the skill's own guided
  next-step output is sufficient.
- **SC-002**: Each shipped pipeline skill passes `scripts/validate.sh`'s
  structural lint and the Skill Authoring Standard's review checklist before
  merge.
- **SC-003**: The full P1→P6 slice (constitution → specify → clarify → plan →
  tasks → implement) is independently exercisable end-to-end on at least one
  trivial feature, proving the pattern before P7-P9 are built.
- **SC-004**: Zero `speckit-*` command names or branding leak into any
  `specjedi-*` skill's own user-facing output (Principle XV) — each
  `specjedi-*` skill's guided next-step suggestion (FR-004) always names
  another `specjedi-*` skill, never a `speckit-*` one.

## Assumptions

- Given the scale of building 9 full pipeline skills, this spec's P1
  (`specjedi-constitution`) and P2 (`specjedi-specify`) are targeted for
  implementation in this cycle; P3-P9 are fully specified here so a future
  cycle can implement them against the same validated pattern, per
  Constitution Principle IX (no skill ships without validation) — better to
  ship two rigorously-built skills than nine rushed ones.
- `specjedi-*` skills target the same harness Spec Jedi already supports
  today (Claude Code, Principle III) — multi-harness `<runtime_note>`-style
  mapping (research finding, adopted) is written into each skill from the
  start even though only one harness can be tested against right now.
- Existing `speckit-*` skills remain installed and untouched during this
  work — this feature adds `specjedi-*` skills alongside them, it does not
  remove or modify the bootstrap tooling (Principle XV's bootstrap-then-
  replace is a gradual transition, not a cutover in this cycle).

# Feature Specification: SDD Friction Reduction — Closing Researched Community Pain Points

**Feature Branch**: `045-sdd-friction-reduction`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "busque entender as dificuldades de quem usa SDD na internet e tente ver o que seria útil para deixar specjedi-* ainda mais eficientes" (research the difficulties people using SDD report online, and identify what would make specjedi-* skills even more efficient)

## Research Grounding

Before drafting requirements, real, current (2026) developer-reported pain
points with Spec-Driven Development were researched across GitHub
`spec-kit` issues/discussions, engineering blogs, and academic papers.
Three distinct, independently-corroborated gaps emerged as genuine,
unaddressed opportunities for this project's own `specjedi-*` pipeline
(cross-checked against what `specjedi-analyze`/`specjedi-retro` already
do, per Principle II, to avoid proposing something already solved):

1. **The "missing testing layer"** — the single most heavily-cited
   complaint across independent sources (a GitHub `spec-kit` design-
   concerns issue, a dedicated blog post literally titled "the missing
   testing layer," and academic work on the "attribution gap" in LLM
   requirements engineering): specs describe what code should do, but no
   step in the workflow checks that it actually did it. Teams report
   "test cases existed for features nobody specified" and other,
   explicitly-scoped features "missing entirely," with no traceable link
   from a requirement to verified, working evidence. Confirmed this is a
   real gap in this project too: `specjedi-analyze` already checks that
   an FR has a corresponding *task* (document-level cross-reference), and
   `specjedi-retro` already compares implementation against `plan.md`'s
   *technical approach* — but nothing checks that a requirement has
   actual verified evidence of correct behavior once shipped.
2. **Uncontrolled complexity escalation and context bloat** — a detailed,
   2-month non-technical-user experience report on `spec-kit` documented
   spec sizes nearly doubling between features with "no framework
   guidance on appropriate scope"; separately, `spec-kit`'s own
   maintainers have an open issue documenting that its commands alone
   consume roughly 18.6k tokens per invocation, degrading model recall
   even well inside the advertised context window. This project's own
   Constitution (Principle XIX) already sets a token budget for
   `specjedi-*` skill files (~500 target, 5,000 hard cap) but nothing
   currently measures or enforces it.
3. **No dedicated bug-fix path** — multiple independent sources describe
   SDD frameworks as "optimized for new features, not bugs": one
   documented case produced a 142-line specification that generated zero
   actionable tasks because the template had no shape for
   repro-root-cause-fix work. `specjedi-quick` already exists for small
   *features*, but its eligibility criteria and template shape were never
   evaluated against bug-fix work specifically.

## Clarifications

### Session 2026-07-18

- Q: Should the requirement-to-verification traceability check (US1) be a mandatory gate self-invoked before every PR (like `specjedi-govcheck`), or an on-demand-only tool (like `specjedi-constitution-audit`)? → A: Mandatory, self-invoked by `specjedi-implement` before every PR-open — same advisory-only posture as `specjedi-govcheck` (never blocks the PR itself, only reports), but never depends on the maintainer remembering to ask for it.
- Q: Should the context-budget check (US2 — spec/plan size and `SKILL.md` token limits) be CI-enforced (blocking, like `scripts/validate.sh`'s structural lint), self-invoked advisory (same posture as US1), or on-demand only? → A: Self-invoked advisory — automatically runs when `specjedi-skill-review` reviews a skill, or when `specjedi-plan` writes a new spec/plan — always reports, never blocks. Catches bloat at the moment it's introduced without risking a CI failure over a token limit that may have a legitimate reason to be exceeded.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Requirement-to-verification traceability check (Priority: P1)

A maintainer finishes implementing a feature and wants a trustworthy
answer to "did we actually verify every single thing this spec promised,
or are some requirements just... assumed done?" — not a re-read of
`tasks.md`'s checkboxes (which only prove a task was marked done, not
that it was verified against the requirement it was supposed to satisfy),
but a real cross-check between every Functional Requirement/Acceptance
Scenario in `spec.md` and actual, checkable evidence that it holds today.

**Why this priority**: This is the single most heavily-corroborated
complaint in the research — the "missing testing layer" gap exists in
every SDD tool surveyed, including this project's own pipeline today.
Closing it directly targets the complaint that most erodes trust in
AI-generated implementations: not knowing whether the output is actually
correct and complete.

**Independent Test**: Can be fully tested by taking a completed feature
with a known, deliberately-introduced gap (one Functional Requirement
with no corresponding passing test or explicit manual-verification note
anywhere in the actual codebase) and confirming the check flags exactly
that requirement, naming it specifically — never a vague "some things
might be missing."

**Acceptance Scenarios**:

1. **Given** a completed feature's `spec.md` and its actual shipped code/
   tests, **When** the check runs, **Then** every Functional Requirement
   and Acceptance Scenario is classified as Verified (real, checkable
   evidence exists), or Unverified (no such evidence found) — never
   silently skipped.
2. **Given** a Functional Requirement classified Unverified, **When** it
   is reported, **Then** the report names the specific requirement and
   states plainly what evidence was searched for and not found — never a
   vague "might be incomplete."
3. **Given** test cases or shipped code that don't trace back to any
   requirement in `spec.md` at all, **When** the check runs, **Then**
   that orphaned code/test is also flagged — the gap runs in both
   directions (spec-with-no-evidence, and evidence-with-no-spec-origin).
4. **Given** an existing on-disk artifact already documents a requirement
   as intentionally out of scope or deferred, **When** the check
   evaluates that requirement, **Then** it's classified Not Applicable,
   never miscounted as Unverified.

---

### User Story 2 - Spec and skill context-budget governance (Priority: P2)

A maintainer wants to know, before a spec/plan grows out of control or a
skill file bloats past what actually helps an AI agent reason well,
that something is tracking size against this project's own established
norms — not a hard word-count rule, but a comparison against what
"normal" has looked like for this project's own prior features and the
Constitution's own stated skill-file budget.

**Why this priority**: P2 — directly addresses two independently-
documented, real pain points (uncontrolled spec-size escalation with no
scope guidance, and unenforced skill-file token budgets degrading agent
performance even within the advertised context window) but is valuable
advisory tooling layered on top of User Story 1's more foundational
correctness question, not a blocker for it.

**Independent Test**: Can be fully tested by comparing a deliberately
oversized `spec.md`/`plan.md` (or an oversized `specjedi-*` `SKILL.md`)
against this project's own historical sizes, and confirming the check
flags it with a specific comparison — never a context-free "this file is
big."

**Acceptance Scenarios**:

1. **Given** a new or growing `spec.md`/`plan.md`/single User Story,
   **When** the check runs, **Then** its size is compared against this
   project's own historical median for equivalent artifacts, and
   flagged only when it's a genuine outlier — never flagging every
   artifact merely for being nonzero length.
2. **Given** a `specjedi-*` skill's `SKILL.md`, **When** the check runs,
   **Then** its token count is measured against Constitution Principle
   XIX's own stated budget (target and hard cap), and any skill over the
   hard cap is flagged explicitly, naming the actual count against the
   actual limit.
3. **Given** an artifact flagged as an outlier, **When** the finding is
   reported, **Then** it suggests a concrete next step (e.g., "consider
   splitting User Story 3 into its own follow-up feature") — never left
   as an unexplained warning.

---

### User Story 3 - Dedicated bug-fix fast path (Priority: P3)

A maintainer hits a real bug (not a new feature, however small) and
wants a path shaped for *that* — repro, root cause, fix, regression
test — rather than being forced through `specjedi-quick`'s existing
small-*feature* framing, or the full specify-through-tasks ceremony that
research shows commonly produces zero actionable tasks for bug-shaped
work.

**Why this priority**: P3 — a real, well-documented gap, but narrower in
scope than User Stories 1-2 and already partially mitigated today by
`specjedi-quick`'s existence for *some* small changes; this closes the
specific bug-shaped blind spot in that existing mitigation.

**Independent Test**: Can be fully tested by submitting a genuine bug
report (not a feature request) and confirming the path produces a
repro-root-cause-fix-regression-test artifact shape distinct from
`specjedi-quick`'s existing concrete-changes shape, without forcing the
user through unrelated feature-planning ceremony.

**Acceptance Scenarios**:

1. **Given** a genuine bug report, **When** the maintainer requests the
   fast path, **Then** the resulting artifact captures reproduction
   steps, root cause, the fix, and a regression test — never the generic
   small-feature shape `specjedi-quick` already produces.
2. **Given** a request that's actually a new feature disguised as a "bug"
   (no existing correct behavior to regress to), **When** eligibility is
   checked, **Then** it's declined and redirected to the appropriate
   existing path (`specjedi-quick` or the full pipeline) — never forced
   through the bug shape it doesn't fit.
3. **Given** a fix produced through this path, **When** it's complete,
   **Then** it still goes through the same quality gates every other
   path already requires (test-first, `specjedi-govcheck`, PR-only) —
   never a shortcut around governance, only around planning ceremony.

---

### Edge Cases

- What happens when User Story 1's check runs against a feature with no
  tests at all (a documentation-only or config-only change)? Requirements
  with no natural test shape are verified via an explicit manual-
  verification note instead — never forced into a fabricated test
  requirement that doesn't fit the actual change.
- What happens when User Story 2's historical-median comparison has too
  little history to be meaningful (e.g., this project's first ten
  features)? Degrades to a fixed, documented absolute threshold instead
  of a statistically meaningless median of two or three data points.
- What happens when a bug fix (User Story 3) turns out, mid-investigation,
  to actually require a real design change? Escalate to the full pipeline
  explicitly, carrying forward what's already been learned (repro, root
  cause) — never silently forcing an architectural change through the
  bug-fix shape.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The traceability check MUST classify every Functional
  Requirement and Acceptance Scenario in a completed feature's `spec.md`
  as Verified, Unverified, or Not Applicable, backed by named evidence
  for Verified/Unverified classifications.
- **FR-002**: The traceability check MUST also flag code or tests that
  don't trace back to any requirement in `spec.md` — the gap check runs
  in both directions.
- **FR-003**: The traceability check MUST be read-only — it reports
  gaps, it does not write tests or fix code itself.
- **FR-003a**: The traceability check MUST be self-invoked automatically
  before every PR-open, the same way `specjedi-govcheck` already is —
  never dependent on the maintainer remembering to request it. Like
  `specjedi-govcheck`, it stays advisory-only: a finding is surfaced
  prominently, but never blocks the PR from opening (the CI battery
  remains the actual merge-blocking mechanism, per Constitution
  Principle X).
- **FR-004**: The context-budget check MUST compare a spec/plan artifact's
  size against this project's own historical distribution for equivalent
  artifacts, flagging genuine outliers only.
- **FR-005**: The context-budget check MUST measure each `specjedi-*`
  skill's actual token count against Constitution Principle XIX's stated
  budget, flagging any skill over the documented hard cap by name, with
  the actual count and limit both stated.
- **FR-005a**: The context-budget check MUST run self-invoked and
  advisory-only — automatically as part of `specjedi-skill-review`'s
  existing audit of a skill, and as part of `specjedi-plan`'s own
  spec/plan authoring flow — never as a CI-enforced blocking gate, since
  a legitimate reason to exceed a size/token guideline may exist and
  should be a human judgment call, not an automatic failure.
- **FR-006**: Every outlier or over-budget finding MUST include a
  concrete suggested next step — never an unexplained size warning.
- **FR-007**: The bug-fix fast path MUST produce an artifact shaped
  around reproduction, root cause, fix, and regression test — distinct
  from `specjedi-quick`'s existing small-feature artifact shape.
- **FR-008**: The bug-fix fast path MUST decline and redirect requests
  that don't genuinely fit the bug shape (no prior correct behavior to
  regress to) rather than forcing them through it.
- **FR-009**: The bug-fix fast path MUST NOT skip any existing quality
  gate (test-first discipline, `specjedi-govcheck` self-invocation,
  PR-only delivery) — it only shortens planning ceremony, never
  governance, matching `specjedi-quick`'s own existing discipline.

### Key Entities *(include if feature involves data)*

- **Traceability Verdict**: the per-requirement classification (Verified/
  Unverified/Not Applicable) User Story 1 assigns, with its supporting
  evidence or the specific absence thereof.
- **Context-Budget Finding**: an artifact (spec/plan section, or a
  `specjedi-*` skill file) flagged by User Story 2 as an outlier, with
  its actual size/token count, the comparison baseline, and a suggested
  next step.
- **Bug-Fix Artifact**: the reproduction/root-cause/fix/regression-test
  record User Story 3 produces — a sibling to `specjedi-quick`'s existing
  `quick.md`, not a replacement for it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: For any completed feature, 100% of its Functional
  Requirements and Acceptance Scenarios receive an explicit traceability
  verdict — none left unclassified.
- **SC-002**: A deliberately-introduced unverified requirement is caught
  100% of the time in testing this feature's own delivery.
- **SC-003**: A `specjedi-*` skill file exceeding Principle XIX's hard
  token cap is flagged 100% of the time it occurs, with the actual count
  named.
- **SC-004**: A genuine bug report routed through the new fast path
  produces a complete repro-root-cause-fix-regression-test artifact in
  under the time the full specify-through-tasks pipeline would take for
  equivalent work — matching `specjedi-quick`'s own existing time-
  savings bar for small features.
- **SC-005**: Zero existing quality gates (test-first, governance
  self-invocation, PR-only delivery) are bypassed by the new bug-fix path
  — verified by the same checks already applied to every other delivery
  path.

## Assumptions

- User Story 1's traceability check is a new capability distinct from
  `specjedi-analyze` (document-level FR-to-task cross-referencing,
  pre-implementation) and `specjedi-retro` (implementation-vs-plan
  technical-approach comparison, post-implementation) — it closes the
  specific gap neither currently covers: requirement-to-verified-
  behavior evidence. Whether it ships as a new mode of an existing skill
  or a new sibling skill is a technical-planning decision, not fixed
  here.
- User Story 2's historical-median comparison uses this project's own
  prior `specs/*` artifacts as its baseline — no external benchmark or
  industry-average dataset is assumed or required.
- User Story 3's bug-fix path is additive to `specjedi-quick`, not a
  replacement — `specjedi-quick` continues to serve small *feature*
  requests exactly as it does today.
- This spec intentionally does not include a fourth, more ambitious idea
  surfaced during research (aggregating `specjedi-retro`'s per-feature
  logs into a cross-feature pattern digest that feeds back into
  `specjedi-plan`/`specjedi-clarify`'s own question banks) — that's a
  genuinely separate, larger capability better scoped as its own future
  feature once retro-log.md has accumulated enough entries to mine
  meaningful patterns from.

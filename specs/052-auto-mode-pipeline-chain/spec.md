# Feature Specification: `--auto` Mode Verification & Chained Pipeline Execution

**Feature Branch**: `052-auto-mode-pipeline-chain`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "verifique se o modo --auto está funcionando
em todas skills para selecionar a recomendacao do LLM e seguir até que a
nova especificacao esteja de agordo com governanca, constituicao, testes
e com qualidade" (verify that `--auto` mode works across all skills to
select the LLM's recommendation and keep going until the new
specification is in accordance with governance, constitution, tests, and
quality).

Grounding read before drafting: a full sweep of every
`.claude/skills/specjedi-*/SKILL.md` confirms all 28 currently-shipped
skills already have a `## \`--auto\` mode` section — no coverage gap at
the structural level. A content sample across roughly a third of the
catalog found each skill's own `--auto` text correctly scoped to that
skill's own real gates (e.g. `specjedi-release` never crosses its
never-tag-or-publish boundary even in `--auto`; `specjedi-quick` never
overrides a failed eligibility check; `specjedi-security`/
`specjedi-checklist`/`specjedi-onboard`/`specjedi-specify` all
explicitly still ask when a genuinely blocking question exists) — no
contradiction found in the sample. Only `specjedi-clarify` (Recommended/
Suggested answers) and `specjedi-master` (Recommended option among
competing candidates) actually have a literal "select the recommendation"
mechanic; most other skills' `--auto` only removes a
pause-before-presenting-the-report step, since most have no
recommendation to select in the first place. Constitution Principle IV
("Structured, Opinionated Elicitation — Ask, Don't Assume") and Principle
XX (grounded, honest output) are directly load-bearing here: no skill's
`--auto` mode silently resolves a genuine ambiguity a human is meant to
decide, and this feature cannot change that without contradicting both
principles.

## Clarifications

### Session 2026-07-18

- Q: Does "de acordo com governança, constituição, testes e qualidade"
  require NEW self-invocations of `specjedi-govcheck`/`specjedi-
  constitution-audit`/`specjedi-checklist` earlier in the pipeline than
  today's established timing, or is it satisfied by surfacing each
  artifact's own already-existing, already-mandatory quality gate as the
  chain moves? → A: The latter — visibility-only, no new self-invocation
  timing. This project's own Development Workflow sequencing (govcheck
  self-invoked only right before `specjedi-implement` opens a PR) is an
  established, deliberate pattern, not an oversight; changing when it
  fires is a much larger behavior change than this request's own
  "verify + chain" framing calls for. Every artifact this chain touches
  already has a mandatory quality gate of its own (`plan.md`'s
  Constitution Check, `spec.md`'s requirements checklist) — surfacing
  those existing, already-blocking gates satisfies the spirit of the
  request without altering established pipeline timing.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An evidence-backed answer to "does --auto mode actually hold together," not just "does the section exist" (Priority: P1)

A maintainer wants more than "yes, 28/28 skills have a `--auto mode`
heading" — they want confirmation that each skill's `--auto` text doesn't
quietly contradict that same skill's own Always/Never guardrails (e.g.
an `--auto` paragraph that reads as skipping a gate its own Always/Never
section calls non-negotiable). Today, `specjedi-skill-review`'s own Step
2 checks that a `--auto mode` section is *present*, and Step 3 checks its
content is *not generic* — but neither step names an explicit
cross-check against that same skill's own Always/Never text for a
contradiction.

**Why this priority**: This is the literal "verify it's working"
half of the request, and the only part of it that's genuinely new build
work — reusing and narrowly extending an already-shipped mechanism
(`specjedi-skill-review`, itself reused catalog-wide by
`specjedi-catalog-audit`, specs/049) rather than duplicating it, per this
project's own Principle II research-before-creation discipline.

**Independent Test**: Given the current 28-skill catalog, when the
extended per-skill check runs, then every skill's `--auto mode` section
is checked against its own Always/Never section for contradiction, and
each skill gets an explicit PASS or a named contradiction — none silently
skipped.

**Acceptance Scenarios**:

1. **Given** a skill whose `--auto mode` text and Always/Never section
   agree (the common case — e.g. `specjedi-release`'s "no `--auto` path
   crosses the never-tag-or-publish boundary" matching its own Always/
   Never entry), **When** checked, **Then** it's marked PASS with the
   specific matching language cited as evidence.
2. **Given** a hypothetical skill whose `--auto mode` text claimed to
   skip a gate its own Always/Never called non-negotiable, **When**
   checked, **Then** it's named as a specific contradiction — never
   silently passed.

---

### User Story 2 - Running the SDD pipeline's own `--auto` stages back-to-back without re-invoking each one by hand (Priority: P2)

A user who already trusts each individual stage's own `--auto` behavior
(`specjedi-specify --auto`, then `specjedi-clarify --auto`, then
`specjedi-plan --auto`, then `specjedi-tasks --auto`) wants to kick off
that sequence once and have it continue automatically from stage to
stage — stopping automatically, and only, at whatever point any single
stage's own already-documented `--auto` behavior already says it must
stop (a genuine `[NEEDS CLARIFICATION]`, a failed eligibility check, an
unanswerable blocking question) — never being silently pushed past that
point by the chain itself.

**Why this priority**: P2 — the literal "keep going" half of the
request, real value on its own, but strictly bounded by Principle IV/XX:
it orchestrates existing per-stage `--auto` behavior, it does not
redefine what any individual stage's `--auto` is allowed to silently
resolve.

**Independent Test**: Given a spec whose every stage would cleanly
proceed under `--auto` (no genuine ambiguity anywhere), when the chain is
run once from `specjedi-specify --auto`, then `spec.md` → `plan.md` →
`tasks.md` are all produced without the user re-invoking anything
between stages. Given a spec where one stage's own `--auto` mode would
normally stop (e.g. a genuinely blocking clarification), when the chain
reaches that stage, then it stops there and surfaces exactly what that
stage's own documented `--auto` behavior already says to surface —
never silently guessing past it.

**Acceptance Scenarios**:

1. **Given** a fully auto-resolvable feature idea, **When** the chain
   runs, **Then** `spec.md`, `plan.md`, and `tasks.md` are all produced
   in one continuous run.
2. **Given** a stage that hits its own documented `--auto` stopping
   condition, **When** the chain reaches it, **Then** the chain halts at
   that exact point and hands control back to the user — it never
   overrides that stage's own reservation of the decision for a human.
3. **Given** the chain is started against a feature that already has a
   `spec.md` but no `plan.md`, **When** it runs, **Then** it resumes from
   `specjedi-clarify`/`specjedi-plan` rather than re-drafting a spec that
   already exists.

---

### User Story 3 - Seeing each artifact's own already-established quality/governance status as the chain moves, without inventing new checkpoints (Priority: P3)

A user running the chain wants visibility into whether each artifact it
produces already meets this project's own existing quality bars — a
spec's own requirements-quality checklist criteria, a plan's own
Constitution Check gate (already mandatory today, per every `plan.md`'s
own template section) — surfaced automatically as the chain moves,
rather than needing a separate, manually-triggered
`specjedi-checklist`/`specjedi-analyze` run afterward to find out.

**Why this priority**: P3 — valuable, but scoped strictly to
*surfacing* checks this project already performs at each stage (a
plan.md's Constitution Check gate already exists and already blocks
per Always/Never in `specjedi-plan`); it does not invent new
self-invocations of `specjedi-govcheck`/`specjedi-constitution-audit`
earlier in the pipeline than this project's own established timing
(today, `specjedi-implement` self-invokes `specjedi-govcheck` right
before opening a PR — not at spec or plan time) unless FR-005 below
resolves that the timing itself should change.

**Independent Test**: Given the chain completing `plan.md`, confirm its
own Constitution Check section's pass/fail status is surfaced in the
chain's own summary output, without the user needing to open `plan.md`
themselves to find it.

**Acceptance Scenarios**:

1. **Given** a plan whose Constitution Check gate passed, **When** the
   chain reaches that stage, **Then** the pass is surfaced in the
   chain's own running summary.
2. **Given** a plan whose Constitution Check gate would fail, **When**
   the chain reaches that stage, **Then** the chain stops there (matching
   `specjedi-plan`'s own existing Always/Never rule already requiring
   this) and surfaces the specific failing gate — never proceeding to
   `specjedi-tasks` regardless.

### Edge Cases

- **What if the chain is asked to run past `specjedi-tasks` into
  `specjedi-implement`?** Out of scope for this feature's own User Story
  2 — `specjedi-implement` already has its own distinct branch/PR/test-
  first discipline (Constitution Principle X/VI) that this feature
  doesn't touch; whether the chain extends that far is a separate
  question, not assumed in scope here.
- **What if two consecutive stages disagree about the same open
  question** (e.g. `specjedi-plan`'s own Technical Context marks
  something `NEEDS CLARIFICATION` that `spec.md` had instead resolved
  via an Assumption)? The chain must surface this as its own stopping
  point too — a later stage re-opening a question an earlier stage
  thought was closed is exactly the kind of thing a human should see,
  not something the chain silently reconciles on its own.
- **What if a report/audit skill (e.g. `specjedi-analyze`,
  `specjedi-govcheck`) is asked to be "chained" the same way?** Out of
  scope — this feature's chain covers the artifact-producing pipeline
  stages only (specify, clarify, plan, tasks); audit/report skills are
  invoked at the checkpoints User Story 3 already defines, not treated
  as chain links themselves.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A check MUST confirm every currently-shipped `specjedi-*`
  skill's `--auto mode` section doesn't contradict that same skill's own
  Always/Never section — by extending `specjedi-skill-review`'s existing
  per-skill methodology (reused catalog-wide by `specjedi-catalog-audit`,
  specs/049) with this one additional named dimension, never by building
  a second, separate checking mechanism (Principle II).
- **FR-002**: The chained pipeline execution (User Story 2) MUST NOT
  auto-resolve a genuine `[NEEDS CLARIFICATION]` marker, a failed
  eligibility check, or any other judgment call an individual stage's own
  `--auto` mode already documents as reserved for the human — Constitution
  Principle IV and Principle XX take precedence over continuing
  unattended, unconditionally.
- **FR-003**: Chained `--auto` execution MUST reuse each stage's own
  already-existing `--auto` behavior unchanged — the chain is an
  orchestration layer on top of `specjedi-specify`/`specjedi-clarify`/
  `specjedi-plan`/`specjedi-tasks`'s own individual `--auto` modes, never
  a redefinition of what any one of them is allowed to do.
- **FR-004**: The chain MUST detect which pipeline artifacts already
  exist for a feature (e.g. a `spec.md` with no `plan.md` yet) and resume
  from the appropriate stage rather than re-doing already-complete work.
- **FR-005**: This feature MUST NOT add new self-invocations of
  `specjedi-govcheck`/`specjedi-constitution-audit`/`specjedi-checklist`
  earlier in the pipeline than today's established timing (resolved by
  the 2026-07-18 Clarification above) — it satisfies "de acordo com
  governança, constituição, testes e qualidade" by surfacing each
  artifact's own already-existing, already-mandatory quality gate (e.g.
  `plan.md`'s own Constitution Check section) as the chain moves.
- **FR-006**: Whether this chain ships as a new orchestrating skill or as
  an enhancement to `specjedi-specify`'s own `--auto` mode (the
  pipeline's natural entry point) is a technical design decision resolved
  during planning — matching this project's own established "new skill
  vs. extend" precedent (specs/043 Decision 1; specs/049 Decision 1;
  specs/050 similar deferral).

### Key Entities

*(Not applicable — this feature checks existing skill text and
orchestrates existing pipeline stages; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every one of the 28 currently-shipped `specjedi-*` skills
  gets an explicit PASS or a named contradiction for the
  `--auto`-mode-vs-Always/Never cross-check — none silently omitted.
- **SC-002**: A fully auto-resolvable feature can go from a one-sentence
  idea to a completed `tasks.md` in one continuous chained run, with zero
  manual re-invocations between `specjedi-specify`, `specjedi-clarify`,
  `specjedi-plan`, and `specjedi-tasks`.
- **SC-003**: A feature with at least one genuine ambiguity at any stage
  causes the chain to halt at exactly that stage, surfacing exactly what
  that stage's own existing `--auto` documentation already says to
  surface — verifiable by confirming the chain never produces a
  downstream artifact (e.g. `plan.md`) built on top of an unresolved
  upstream ambiguity.
- **SC-004**: Each artifact's own already-established quality/governance
  gate status (e.g. `plan.md`'s Constitution Check) is visible in the
  chain's own summary without the user opening the artifact file
  themselves.

## Assumptions

- The literal "verify --auto mode works... to select the LLM's
  recommendation" half of the request is, for most of the catalog,
  already answered by the pre-drafting sweep: 28/28 skills have a
  well-formed `--auto mode` section, and only `specjedi-clarify`/
  `specjedi-master` have an actual "select the recommendation" mechanic
  in the first place — this feature does not re-verify structural
  presence again (that's already `specjedi-catalog-audit`'s own,
  already-shipped job); it adds exactly one new, narrower dimension
  (FR-001) that wasn't explicitly named before.
- No skill's `--auto` mode can be made to silently resolve a genuine
  ambiguity without contradicting Constitution Principle IV/XX — this is
  treated as a hard constraint, not a design choice this feature could
  relax.
- Chain scope (User Story 2/3) is the artifact-producing SDD pipeline
  (`specify`/`clarify`/`plan`/`tasks`) only; `specjedi-implement` and
  beyond are explicitly out of scope per the Edge Cases section.
- This feature assumes `references/skill-authoring-standard.md` and
  `specjedi-skill-review`'s own Step 2/3 structure (both already read
  during this project's prior work) are the right place to hang FR-001's
  new dimension, rather than inventing a separate standard.

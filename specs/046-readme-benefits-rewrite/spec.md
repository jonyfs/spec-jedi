# Feature Specification: README Objectivity & Evidence-Based Benefits Rewrite

**Feature Branch**: `046-readme-benefits-rewrite`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "Reescrever o README.md do projeto para
explicar como as skills specjedi-* funcionam. Revisar todas as seções
para trazer mais objetividade (menos marketing, mais fatos
verificáveis) e demonstrar claramente os benefícios reais de usar essas
skills em vez do speckit-* vendored, com base em evidências já
documentadas no projeto (PARITY-LEDGER, principle-traceability, specs
shipped)." (Rewrite README.md to explain how the specjedi-* skills
work. Revise every section for more objectivity — less marketing, more
verifiable facts — and clearly demonstrate the real benefits of using
these skills instead of the vendored speckit-*, grounded in evidence
already documented in the project: PARITY-LEDGER, principle-traceability,
shipped specs.)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand what specjedi-* actually does (Priority: P1)

A reader who has never seen this project opens `README.md` and, from
the opening sections alone, needs to understand what Spec-Driven
Development is and how the `specjedi-*` skills implement it —
concretely, not through a narrative frame they have to translate into
facts themselves.

**Why this priority**: Every other story depends on the reader first
knowing what the product actually is. Without this, a benefit
comparison (US2) or an objectivity pass (US3) has nothing concrete to
attach to.

**Independent Test**: Give the rewritten README to someone with no
prior context. After reading only the sections through "How Spec Jedi
Implements SDD," they can state in one or two sentences what
`specjedi-*` does and name at least three real skills by name — without
needing to open any linked reference document first.

**Acceptance Scenarios**:

1. **Given** the rewritten README, **When** a new reader reads the
   opening sections, **Then** they can name the four core SDD artifacts
   (constitution, spec, plan, tasks) and at least three `specjedi-*`
   skills that produce them.
2. **Given** the rewritten README, **When** the same reader is asked
   "is this the same as spec-kit, or different?", **Then** they can
   answer correctly using only README content, without guessing.

---

### User Story 2 - See evidence-based benefits over speckit-* (Priority: P2)

A reader deciding whether to adopt `specjedi-*` instead of continuing
to use the vendored `speckit-*` pipeline directly needs concrete,
sourced comparison facts — not adjectives — so the decision can be
checked, not just trusted.

**Why this priority**: This is the specific ask driving this feature.
It is P2, not P1, because it depends on the reader already
understanding what each pipeline is (US1) — but it is independently
verifiable on its own once that grounding exists.

**Independent Test**: Given the rewritten README's comparison content,
a reader can pick any single benefit claim and verify it against a
named, existing project artifact (a file path, a `specs/NNN` directory,
or a merged PR number) without taking the claim on faith.

**Acceptance Scenarios**:

1. **Given** the rewritten README, **When** a reader reads the
   `specjedi-*` vs. `speckit-*` comparison, **Then** they see the exact
   parity ratio (8 of 11 pipeline commands at full parity, 1 favorable
   divergence, 2 with no equivalent — both already resolved, not open
   gaps) with a citation to `specs/044-speckit-parity-audit/PARITY-LEDGER.md`.
2. **Given** the rewritten README, **When** a reader asks "what does
   `specjedi-*` do that `speckit-*` doesn't at all?", **Then** the
   README names the real count of `specjedi-*`-only skills with no
   `speckit-*` counterpart (16, per the same ledger) rather than a vague
   "does more."
3. **Given** the rewritten README, **When** a reader checks the one
   favorable-divergence claim (`specjedi-implement`'s trunk-based PR
   discipline vs. `speckit-implement`'s silence on git workflow),
   **Then** the claim matches the ledger's own worded verdict, not a
   stronger or weaker claim invented for the README.

---

### User Story 3 - Trust every claim in every section (Priority: P3)

A reviewer scanning the whole rewritten document — not just the two
sections above — needs every remaining section (Who this is for,
Prerequisites, Installation, Supported harnesses, Honest assessment,
Contributing, License) to hold to the same standard: measurable facts
or a citation, not unverifiable marketing language, while the document
still carries the project's own required Star Wars-flavored voice
(Constitution Principle XII) rather than reading as a stripped, generic
tech README.

**Why this priority**: This is the broadest, lowest-priority story
because it is a polish pass across content that both prior stories
already made factual — it depends on US1/US2's rewritten sections
existing, and extends the same discipline project-wide.

**Independent Test**: A reviewer scans every section (not just the
two above) and finds zero superlatives ("the best," "seamless,"
"revolutionary," "effortless") without either a citation, a number, or
an explicit "not yet confirmed" qualifier attached — while confirming
at least one genuine Star Wars-flavored line still remains, per
Principle XII.

**Acceptance Scenarios**:

1. **Given** the rewritten README, **When** a reviewer greps for common
   marketing superlatives, **Then** every remaining match is either
   removed, replaced with a specific number, or attached to a citation.
2. **Given** the rewritten README's existing "Honest assessment"
   section, **When** a reviewer reads it, **Then** it still states at
   least one genuine current limitation next to the stated advantages —
   this feature sharpens objectivity, it does not turn the section into
   one-sided praise.
3. **Given** the rewritten README, **When** a reviewer looks for
   Star-Wars-flavored voice (Principle XII), **Then** at least one
   genuine reference tied to a specific SDD concept is still present,
   consistent with specs/037's own precedent for this exact document.

### Edge Cases

- **What happens to the "How Spec Jedi builds itself, in comic form"
  section?** Out of scope for this rewrite — specs/036 and specs/037
  already settled this exact question twice: it is explicitly labeled
  as a separate internal-bootstrap aside (Constitution Principle XV),
  not part of the home-page product narrative this feature tightens,
  and specs/037's own Amendment 2 already reasoned that removing a
  deliberately-commissioned illustrated feature would be a bigger,
  likely-unintended side effect of a general instruction not really
  targeting it. The same reasoning applies here: it stays as-is.
- **What happens to the opening epigraph line ("A letter, from one
  Master to whoever picks up this scroll next:")?** Stays, unchanged —
  specs/037 Amendment 1 already settled this per direct user
  instruction, scoped narrowly as a single evocative hook, not a
  sustained narrator. This feature's "more objectivity" instruction
  targets substantive claims (what the product does, how it compares),
  not a one-line epigraph already resolved as an intentional exception.
- **What if a claimed benefit has no hard evidence behind it (e.g.,
  "easier to use")?** Reword it as a specific, cited difference, or
  remove it — never leave an unverifiable adjective standing on its
  own (FR-004).
- **What if tightening objectivity would require deleting the Star
  Wars voice entirely?** It does not — Principle XII is a constitution
  requirement, not decoration; the fix is removing unverifiable claims,
  not removing thematic voice. At least one genuine Star-Wars-flavored
  reference remains (SC-004).
- **What if a number cited today (skill count, harness count, pipeline
  stage count) has drifted since it was last written?** Re-verify each
  number against the actual current project state before restating it
  (FR-007) — never carry forward a stale badge or count unchecked.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: README MUST explain, in its opening sections (before any
  narrative aside), what SDD is and what the `specjedi-*` skills
  concretely do — sufficient for a new reader to pass User Story 1's
  Acceptance Scenarios without opening a linked reference document
  first.
- **FR-002**: README MUST state the exact `specjedi-*`/`speckit-*`
  parity ratio (8/11 full parity, 1/11 favorable divergence, 2/11 no
  equivalent — both already resolved per the Resolution section) with
  a citation to `specs/044-speckit-parity-audit/PARITY-LEDGER.md`.
- **FR-003**: README MUST name the real count of `specjedi-*`-only
  skills with no `speckit-*` counterpart (16, per the same ledger) as a
  concrete, evidenced benefit rather than a vague capability claim.
- **FR-004**: Every comparative or capability claim in the README MUST
  either carry a citation (a file path, a `specs/NNN` directory, or a
  merged PR number), be restated as a specific measurable fact, or be
  removed — no unverifiable marketing adjective may stand alone.
- **FR-005**: README MUST preserve Constitution Principle XII's
  Star-Wars-flavored voice requirement — the fix scoped here is
  removing unverifiable claims, not stripping the document's required
  thematic voice.
- **FR-006**: README MUST leave the "How Spec Jedi builds itself, in
  comic form" section and the opening epigraph line unchanged, per the
  settled precedent from specs/036 and specs/037 (see Edge Cases).
- **FR-007**: Every badge, count, or status claim carried over from the
  current README (skill count, pipeline stage count, harness count,
  language count) MUST be re-verified against current project state
  before being restated — no stale number may be repeated unchecked.
- **FR-008**: README MUST NOT introduce any capability or comparison
  claim that is not traceable to an existing project artifact
  (`references/principle-traceability.md`, `PARITY-LEDGER.md`, a
  `specs/NNN` directory, or a merged PR) — consistent with Constitution
  Principle XX (grounded, honest output); this is a rewrite of existing
  evidence into a more objective form, not new capability invention.
- **FR-009**: README MUST retain the existing internal-bootstrap
  disclaimer distinguishing `speckit-*` (used to build this project)
  from `specjedi-*` (the actual shipped product) — this distinction is
  load-bearing per Constitution Principle XV and must not be blurred
  by newly-added benefit-comparison content.
- **FR-010**: README MUST preserve every existing internal anchor link
  and cross-reference target (`#how-spec-jedi-implements-sdd`,
  `#installation`, etc.) referenced by badges or other project
  documentation — restructuring content MUST NOT silently break an
  existing link.

### Key Entities

*(Not applicable — this feature revises existing documentation content;
no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every comparative benefit claim between `specjedi-*` and
  `speckit-*` in the rewritten README cites a specific evidence source
  (a file path, a PR number, or a `specs/NNN` directory) — verifiable
  by checking each claim against its cited source directly.
- **SC-002**: Zero unverifiable marketing superlatives ("the best,"
  "revolutionary," "seamless," "effortless," and similar) remain
  without an attached citation, number, or explicit qualifier —
  verifiable by a full-document scan.
- **SC-003**: A reader unfamiliar with the project can state, after
  reading only the opening two sections, what `specjedi-*` is and the
  exact parity ratio versus `speckit-*` (8/11 full parity) —
  verifiable by a direct read-through test with a new reader.
- **SC-004**: The rewritten README still contains at least one genuine
  Star-Wars-flavored reference tied to a specific SDD concept
  (Constitution Principle XII) — verifiable by manual review, the same
  bar specs/037's own Success Criteria already used for this document.
- **SC-005**: Zero functional or reference content is lost relative to
  today's README — every badge, the full harness table, all install
  commands, and both settled asides (comic section, opening epigraph)
  are still present — verifiable by a before/after content-preservation
  check, the same method specs/037 used for its own restructure.
- **SC-006**: All internal anchor links and cross-references from the
  current README still resolve after the rewrite — verifiable by
  grepping for every `#anchor` and relative-link target and confirming
  each still exists.

## Assumptions

- Scope is `README.md` only. This feature revises existing prose and
  adds evidence-based comparison content; it does not introduce new
  reference documents (unlike specs/037, which relocated content into
  new docs) — the evidence already exists in `PARITY-LEDGER.md` and
  `principle-traceability.md`, so this feature cites them rather than
  duplicating their content into the README.
- The "How Spec Jedi builds itself, in comic form" section and the
  single opening epigraph line are explicitly out of scope, per the
  settled precedent in specs/036 and specs/037 (Edge Cases) — revisiting
  either would re-litigate a decision already made twice for this exact
  document, which this feature's instruction ("revise every section")
  was not specifically aimed at overturning.
- "More objective" means every substantive claim is either a citable
  fact or removed — it does not mean stripping Constitution Principle
  XII's required thematic voice, which remains a project-wide,
  non-negotiable requirement independent of this feature.
- No specific target line-count or length reduction is assumed; length
  changes only as a byproduct of removing unverifiable claims, not as
  an explicit goal of this feature.
- The current parity/skill-count figures (8/11, 16 extra skills, 27
  total skills) are drawn from `specs/044-speckit-parity-audit/
  PARITY-LEDGER.md` as of 2026-07-18; if that ledger is updated by a
  future feature, this README's cited numbers should be re-verified
  against the ledger's then-current state, not assumed to remain fixed.

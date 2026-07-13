# Feature Specification: SDD Explainer + How Spec Jedi Skills Help

**Feature Branch**: `030-sdd-documentation`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description (Portuguese): "crie uma completa documentação
sobre SDD e depois outra documentação explicando como specjedi skills
pode ajudar nisso" (Create complete documentation about SDD, and then
another documentation explaining how specjedi skills can help with
that.)

## Problem

No document in this repository explains Spec-Driven Development (SDD)
itself, independent of Spec Jedi's own implementation of it. Existing
docs assume the reader already knows what SDD is: `specjedi-explain`
answers ad hoc questions at runtime but produces no durable reference;
`references/competitive-comparison.md` compares tools *within* SDD
without ever defining the practice; the constitution governs Spec Jedi's
own rules but doesn't teach the underlying methodology. A reader
genuinely new to SDD — the audience `specjedi-explain`'s own design
already commits to serving — has nowhere to go for a from-scratch,
durable explanation, and no document then bridges that explanation to
what Spec Jedi specifically contributes.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A newcomer learns what SDD actually is (Priority: P1)

A developer who has never heard of Spec-Driven Development wants a
complete, standalone explanation: what problem it solves, its core
artifacts (constitution/spec/plan/tasks), how it differs from writing
code first and documenting later, and why teams adopt it — without
needing to already know anything about Spec Jedi specifically.

**Why this priority**: The explicit first half of the user's request,
and a genuine documentation gap — nothing in this repo currently teaches
SDD from zero.

**Independent Test**: Give the document to someone with no prior SDD
exposure; confirm they can explain, in their own words afterward, what a
spec/plan/tasks/constitution each are for and why the discipline exists,
without consulting any other document.

**Acceptance Scenarios**:

1. **Given** the SDD explainer document, **When** a newcomer reads it,
   **Then** they can name the core SDD artifacts and what each is
   responsible for, without any Spec-Jedi-specific terminology required
   to understand the explanation.
2. **Given** the same document, **When** a reader asks "how is this
   different from just writing code," **Then** the document already
   answers that contrast directly, grounded in a concrete problem SDD
   solves (e.g., ambiguity caught before implementation, autonomous
   agents executing against complete artifacts) rather than an abstract
   claim.

---

### User Story 2 - A reader learns specifically how Spec Jedi helps with SDD (Priority: P1)

A developer who now understands SDD in general wants to know precisely
which Spec Jedi skill handles which part of the practice, and what Spec
Jedi adds beyond the general methodology (grounded in real, shipped
mechanisms — not aspirational claims).

**Why this priority**: The explicit second half of the user's request,
directly dependent on User Story 1 existing first (can't explain how a
tool helps with a practice the reader doesn't understand yet).

**Independent Test**: Give a reader both documents in order; confirm they
can name which specific `specjedi-*` skill they'd invoke for a given SDD
activity (e.g., "resolving ambiguity in a spec" → `specjedi-clarify`)
without consulting the full skill table separately.

**Acceptance Scenarios**:

1. **Given** the second document, **When** it describes how Spec Jedi
   helps with a specific SDD activity, **Then** it names the specific
   skill (not a vague "Spec Jedi handles this") and cites a real,
   currently-shipped mechanism — the same grounding bar
   `references/honest-assessment.md` already established for this
   project's self-description.
2. **Given** the second document, **When** it describes what's
   distinctive about Spec Jedi's approach to SDD (not just a restatement
   of generic SDD practice), **Then** it references genuine, cited
   contributions (e.g., render-verified diagrams, the constitution's own
   enforced versioning, `specjedi-govcheck`'s automated compliance
   check) rather than claiming credit for the general methodology itself.

### Edge Cases

- What happens when SDD terminology overlaps with Spec Jedi's own
  Star-Wars-flavored naming (e.g., "constitution")? → the SDD explainer
  uses plain, industry-standard terminology throughout (no Spec Jedi
  branding); the second document is where Spec-Jedi-specific names and
  voice are introduced, keeping the boundary between "the practice" and
  "this project's implementation of it" clear and testable.
- What happens if a claim about SDD's general adoption/history can't be
  independently verified? → stated with appropriate hedging (industry
  consensus, not a specific unverifiable statistic), consistent with
  Principle XX's hallucination-resistance discipline.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A new document, `references/what-is-sdd.md`, MUST explain
  Spec-Driven Development as a general practice: the problem it solves,
  its core artifact types (a project's non-negotiable rules, a
  specification, a technical plan, an ordered task breakdown), the
  typical phase sequence, and how it contrasts with code-first/
  document-later workflows — using no Spec-Jedi-specific terminology or
  branding.
- **FR-002**: `references/what-is-sdd.md` MUST NOT reference any
  `specjedi-*` skill by name — that mapping belongs entirely to the
  second document (FR-003), keeping "the practice" and "this project's
  implementation" cleanly separable.
- **FR-003**: A second new document, `references/specjedi-and-sdd.md`,
  MUST map each core SDD activity described in `what-is-sdd.md` to the
  specific `specjedi-*` skill(s) that handle it, each citation grounded
  in a real, currently-shipped mechanism (per `references/honest-
  assessment.md`'s own grounding bar) — never an aspirational or
  constitution-only claim.
- **FR-004**: `references/specjedi-and-sdd.md` MUST name at least 3
  genuine contributions Spec Jedi adds beyond generic SDD practice
  (e.g., render-verified diagrams, automated per-PR governance
  compliance, a versioned and enforced constitution) — not a restatement
  of the general methodology as if it were Spec Jedi's own invention.
- **FR-005**: Both documents MUST live under `references/` (not `docs/`)
  — consistent with `competitive-comparison.md`/`honest-assessment.md`'s
  established precedent of avoiding Constitution Principle I's
  ten-language localization mandate for researched-analysis reference
  docs rather than top-level onboarding material.
- **FR-006**: `README.md` MUST link to both documents from a discoverable
  location, mirroring the existing `competitive-comparison.md`/`honest-
  assessment.md` link pattern.

### Key Entities

- **SDD core artifact**: one of the four generic artifact types
  `what-is-sdd.md` defines (rules document, specification, technical
  plan, task breakdown) — deliberately undecorated, pre-Spec-Jedi
  terminology.
- **Skill mapping**: a single row in `specjedi-and-sdd.md` connecting one
  SDD activity to the specific skill(s) that perform it, plus its
  grounding citation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `references/what-is-sdd.md` contains zero references to
  any `specjedi-*` skill name or Spec Jedi branding — independently
  verifiable by grep.
- **SC-002**: Every SDD activity named in `what-is-sdd.md` has a
  corresponding entry in `specjedi-and-sdd.md`'s skill mapping — 100%
  coverage, no orphaned concept left unmapped.
- **SC-003**: 100% of skill citations in `specjedi-and-sdd.md` trace to a
  specific, currently-shipped mechanism — zero aspirational claims,
  matching `honest-assessment.md`'s own verified SC-001.
- **SC-004**: A reader with zero prior SDD exposure can, after reading
  both documents in order, correctly name all four core SDD artifacts
  and at least 3 specific `specjedi-*` skills mapped to specific
  activities, without consulting any other document.

## Assumptions

- **Two files, not one** — the user's phrasing ("crie X e depois outra
  documentação Y") explicitly asks for two documents; keeping them
  separate also directly enables FR-002's clean-separation requirement
  (a reader evaluating "is this SDD, or is this Spec Jedi" can tell at a
  glance which file they're in).
- **Scope**: `what-is-sdd.md` explains the general practice at the depth
  a newcomer needs to understand this project's own pipeline
  afterward — it is not a comprehensive academic literature review of
  every SDD tool or variant (that role already belongs to
  `references/competitive-comparison.md`).
- **This is a documentation feature**, not a new skill or structural
  pattern — Principle II's full ten-competitor benchmarking gate doesn't
  apply in the same way it would to a new skill; grounding instead comes
  from this project's own already-researched `competitive-comparison.md`
  and `research.md` history, per the same lighter documentation-feature
  bar features 014/027 already established.

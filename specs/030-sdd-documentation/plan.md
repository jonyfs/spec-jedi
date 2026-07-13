# Implementation Plan: SDD Explainer + How Spec Jedi Skills Help

**Branch**: `030-sdd-documentation` | **Date**: 2026-07-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/030-sdd-documentation/spec.md`

## Summary

Write two new reference documents: `references/what-is-sdd.md` (SDD
taught generically, zero Spec Jedi terminology) and `references/
specjedi-and-sdd.md` (maps each SDD activity to the specific skill that
handles it, grounded in shipped mechanisms, plus genuine contributions
beyond generic practice). Link both from README.

## Technical Context

**Language/Version**: Markdown — two new reference documents, no code.

**Primary Dependencies**: `references/competitive-comparison.md` and
`specs/001-specjedi-pipeline/research.md` (existing SDD-field research,
reused not re-derived per Principle II's documentation-feature bar),
`references/honest-assessment.md` (grounding-claim precedent),
`references/principle-traceability.md` (mechanism verification for each
skill citation).

**Storage**: Writes two new files under `references/`; edits `README.md`
to add two links.

**Testing**: Principle VI exemption — pure documentation. Verification:
(a) `scripts/validate.sh`, (b) grep-based check that `what-is-sdd.md`
contains zero `specjedi-` references (SC-001), (c) manual cross-check
that every activity named in `what-is-sdd.md` has a mapping row in
`specjedi-and-sdd.md` (SC-002) and that every citation there resolves to
a real file/mechanism (SC-003).

**Target Platform**: N/A — Markdown reference documents.

**Project Type**: Documentation (single project).

## Constitution Check

- **Principle I**: both documents live under `references/`, not `docs/`
  — same localization-scope-avoidance precedent as `competitive-
  comparison.md`/`honest-assessment.md`.
- **Principle II**: reuses this project's own already-researched SDD
  field survey (`specs/001-specjedi-pipeline/research.md`,
  `competitive-comparison.md`) rather than re-deriving it — appropriate
  for a documentation feature per the established features 014/027 bar.
- **Principle XX**: every skill citation in `specjedi-and-sdd.md` is
  cross-checked against `principle-traceability.md`/the actual skill
  file before being written, not asserted from memory.
- **Gate result**: PASS.

## Project Structure

```text
references/
├── what-is-sdd.md            # NEW
└── specjedi-and-sdd.md       # NEW
README.md                      # +2 links
specs/030-sdd-documentation/
├── spec.md
├── plan.md
└── tasks.md
```

No `research.md`/`data-model.md`/`contracts/` — reuses existing research
per Technical Context; no data entities, no external interface.

## Design

- **`what-is-sdd.md` structure**: Problem SDD solves → the four core
  artifacts (rules doc, spec, plan, tasks) → typical phase sequence →
  contrast with code-first workflows → why teams adopt it. Zero
  `specjedi-*` mentions (FR-002), verified by grep before finalizing.
- **`specjedi-and-sdd.md` structure**: a table mapping each `what-is-
  sdd.md` activity to the specific skill(s), each row citing a real
  mechanism; a "Genuine contributions" section (≥3, FR-004) reusing
  `honest-assessment.md`'s existing verified Advantages list rather than
  re-deriving new claims.

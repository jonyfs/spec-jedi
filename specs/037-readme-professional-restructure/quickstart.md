# Quickstart Validation: README Professional Restructure

**Feature**: `037-readme-professional-restructure` | **Date**: 2026-07-14

Validation scenarios proving the restructured `README.md` and its
relocated content satisfy spec.md's User Stories and Success Criteria.
No build/run step applies — this is a documentation feature; each
scenario is a manual read-and-verify pass against the shipped files.

## Prerequisites

- `README.md`, `CONTRIBUTING.md`, `references/quickstart-guide.md`, and
  `references/recommended-companions.md` all exist on the feature
  branch.
- A local checkout of `main` (pre-feature) available for a fact-diff,
  e.g. `git show main:README.md > /tmp/readme-before.md`.

## Scenario 1 — SDD literacy before any Spec-Jedi claim (US1, SC-001)

1. Read `README.md` from the top.
2. Confirm the "What Is Spec-Driven Development?" section appears
   before "How Spec Jedi Implements SDD."
3. Confirm "How Spec Jedi Implements SDD" appears before "Installation."

**Expected**: reading order is what-is-SDD → specjedi-mapping →
installation, with no Spec-Jedi-specific claim ahead of the SDD
explanation.

## Scenario 2 — Honest summaries keep their caveats (US2, SC-002)

1. Read the "Honest assessment" section's two teaser paragraphs.
2. Cross-reference each against `references/honest-assessment.md` and
   `references/harness-capability-notes.md`.

**Expected**: each teaser names at least one genuine limitation (not
just an advantage) — e.g. "most harness install paths are desk-
research-grounded, not hands-on-verified" for harness-capability-notes,
and one real disadvantage (e.g. no release cut yet, or heavier ceremony
for non-fast-path changes) for honest-assessment. A link to the full
document is present in both.

## Scenario 3 — Professional organization, Star Wars seasoning survives (US3, SC-004)

1. Skim the README's headings top to bottom.
2. Identify at least one Star Wars reference tied to a specific SDD
   concept (not a generic aside).

**Expected**: headings read as an organized product document (no
sustained first-person narrator body prose outside the single retained
FR-001 hook line). At least one reference drawn from
`references/star-wars-lexicon.md`'s curated pool (e.g. the constitution
↔ Jedi Code framing, or light/dark-side framing near `CONTRIBUTING.md`'s
relocated `letter-path.jpg`) is present.

## Scenario 4 — Zero fact loss (FR-008, SC-003)

1. Count badges in `README.md`: expect 10 (unchanged from before this
   feature).
2. Count skill-table rows in `references/quickstart-guide.md`: expect
   25.
3. Count harness-table rows in `README.md`'s Installation section:
   expect 20 (unchanged — this table is not relocated).
4. Diff every code block (install commands, `suggest-release.sh`/`.ps1`
   invocations) against the pre-feature `README.md`: expect identical
   content, only location may differ.

**Expected**: all four counts match; no code block's content changed,
only which file it lives in.

## Scenario 5 — Relocated content is verifiably complete, not a stub (FR-009, SC-005)

1. Open `references/quickstart-guide.md`: confirm the full 25-row skill
   table, the skills mindmap diagram, the pipeline flowchart diagram,
   the "Which path should I use?" table, and all 23 numbered Quickstart
   steps are present in full (not summarized, not a "see README" pointer
   pointing back at content that no longer exists there).
2. Open `references/recommended-companions.md`: confirm the full
   `rtk`/`graphify` content is present.
3. Open `CONTRIBUTING.md`: confirm a "## Versioning & releases" section
   exists with the same semver policy and `suggest-release.sh`/`.ps1`
   commands as before, and that `letter-path.jpg` now renders near
   "## How changes ship."

**Expected**: every relocated item's real content (not a stub) is
present in its new home.

## Scenario 6 — Comic section and Contributing/License untouched (Amendment 2, FR-007)

1. Confirm "## How Spec Jedi builds *itself*, in comic form" and its 8
   panels are still in `README.md`, unchanged, in their original
   position relative to Installation and Contributing.
2. Confirm "## Contributing" and "## License" are the final two
   sections of `README.md`, in that order.

**Expected**: both hold exactly as stated.

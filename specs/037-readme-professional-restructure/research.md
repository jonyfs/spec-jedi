# Research: Restructure README as an SDD Primer With a Professional-But-Themed Voice

**Feature**: `037-readme-professional-restructure` | **Date**: 2026-07-14

## Process note (FR-005)

FR-005 requires the README's overall organization to be produced using
the `/brainstorming` process before committing to a final layout. Per
this spec's own Assumptions section, `/brainstorming`'s role here is to
explore structural/ordering options and inform this `research.md` — it
does not replace the standard `/speckit-plan` artifact chain or hand off
to a separate `docs/superpowers/specs/*.md` design doc, since this
project's own established convention is `specs/NNN-name/research.md`.

The exploration happened as a single high-leverage structural question
(the one item spec.md itself deferred to planning — Amendment 2's "exact
target file(s)" for FR-009's relocated content), presented with two
concrete approaches and a recommendation, via `AskUserQuestion`:

- **Approach A (chosen)** — 3-way split: one new deep-dive reference doc
  for the skill catalog/diagrams/Quickstart steps, one new reference doc
  for "Recommended companions" (no existing doc fits its topic), and
  "Versioning & releases" folded into `CONTRIBUTING.md` (tightly coupled
  to the PR/release process that file already partially describes).
- **Approach B (rejected)** — same first doc, but "Recommended
  companions" and "Versioning & releases" each get their own standalone
  file instead of folding the latter into `CONTRIBUTING.md`.

The user selected Approach A. The remaining two open items from the
original brainstorming brief (exact README section order/headings, and
verbatim-vs-tightened treatment per relocated section) are resolved
below by direct reasoning grounded in the existing content — they don't
carry the same multi-way ambiguity Approach A/B did, so a second
interactive round would have re-litigated an already-narrow decision
rather than surfacing a genuine fork.

## Decision: exact relocation targets (Amendment 2's deferred "which file")

- **Decision**: `references/quickstart-guide.md` (new) receives the
  25-row skill catalog table, the skills mindmap diagram, the pipeline
  flowchart diagram (`### The pipeline, end to end`), the "Which path
  should I use?" table, and all 23 numbered Quickstart steps —
  everything a reader wants once they've decided to actually use Spec
  Jedi day to day. `references/recommended-companions.md` (new) receives
  the `rtk`/`graphify` content verbatim. `CONTRIBUTING.md` (existing)
  gains a new `## Versioning & releases` section, functionally unchanged
  from today's README content, plus `letter-path.jpg` relocated into its
  existing `## How changes ship` section (see next decision).
- **Rationale**: matches the user's selected Approach A. The skill
  catalog/diagrams/Quickstart steps are naturally one document — a
  reader wanting the full walkthrough wants all of it together, not
  split across files. `rtk`/`graphify` don't fit any existing doc's own
  topic (they're tooling recommendations, not SDD process or skill
  content), so a small dedicated doc is cleaner than force-fitting them
  elsewhere. Versioning is already partially covered by
  `CONTRIBUTING.md`'s own PR/release discipline — consolidating avoids a
  redundant standalone file for a topic that already has a natural home.
- **Alternatives considered**: Approach B (4-way split, standalone
  versioning doc) — rejected by the user; keeps `CONTRIBUTING.md`
  narrowly scoped at the cost of one more small file, which the user
  judged not worth it here.

## Decision: `letter-path.jpg` and its discipline-passage content

- **Decision**: the discipline passage's core idea (the constitution
  governs the project's own releases and PR-merge discipline — "no
  self-approval, the battery decides") already exists, in third person,
  in `CONTRIBUTING.md`'s `## How changes ship` section. Rather than
  manufacture a duplicate paragraph elsewhere, `letter-path.jpg` moves
  into `CONTRIBUTING.md` as an illustrative accompaniment to that
  existing section, with one short new caption line carrying the
  "right side of the Force, mechanized" framing as thematic seasoning
  (Principle XII) — not a restatement of the discipline itself, which
  `CONTRIBUTING.md` already states plainly.
- **Rationale**: reconciles two spec statements that pull in slightly
  different directions — Amendment 2's Q3 ("letter-path.jpg relocates
  with that content to wherever it lands") implies the content leaves
  the README, while the Assumptions section says the underlying idea is
  "preserved and re-expressed in the new third-person voice as part of
  the restructured flow" (implying it survives, just reworded). Since
  `CONTRIBUTING.md`'s `## How changes ship` section is the closest
  existing doc-level statement of that same idea, letting the image
  relocate there — paired with a one-line thematic caption rather than a
  full re-narrated passage — satisfies both: the sustained-narrator
  paragraph genuinely leaves the README (Q3), and the idea itself isn't
  duplicated or lost, just pointed at its natural existing home
  (Assumptions).
- **Alternatives considered**: keeping a short reworded version of the
  passage inline in the new README flow, paired with the image — rejected
  because Contributing already exists as its own section in the README
  (FR-007) and a second, competing discipline-passage there would be
  redundant with `CONTRIBUTING.md`'s own linked content one click away.

## Decision: final README section order and headings

- **Decision**, in order:
  1. Title, i18n banner, badges (unchanged, two badge links retargeted —
     see below)
  2. Epigraph quote (unchanged)
  3. `letter-open.jpg` + the retained hook line "**A letter, from one
     Master to whoever picks up this scroll next:**" (FR-001, FR-010),
     followed by 2-3 new third-person sentences bridging into the SDD
     primer (replacing the multi-paragraph first-person body)
  4. `## What Is Spec-Driven Development?` — condensed, third-person
     summary of `what-is-sdd.md` (FR-001), the small constitution
     flowchart kept here as its natural illustration, link to the full
     doc
  5. `## How Spec Jedi Implements SDD` — condensed, third-person summary
     of `specjedi-and-sdd.md`'s activity→skill mapping (FR-002), links
     to `references/quickstart-guide.md` (full skill catalog/diagrams/
     steps) and to `specjedi-and-sdd.md` itself for the full mapping
  6. `## Who this is for` (kept, tightened to third person — drops the
     one first-person "I'm describing" aside)
  7. `## Prerequisites` (kept, unchanged — FR-003)
  8. `## Installation` (kept, unchanged, including the Supported
     harnesses subsection, table, and flowchart — none of this is in
     FR-009's relocation list) (FR-003)
  9. `## Honest assessment` — condensed teasers of `honest-assessment.md`
     and `harness-capability-notes.md` (FR-004), each expanded from
     today's one-line teaser to 2-4 sentences naming one real advantage
     and one real limitation, plus the existing `competitive-comparison.md`
     link
  10. `## How Spec Jedi builds *itself*, in comic form` (kept exactly
      as-is — Amendment 2)
  11. `## Contributing` (kept, unchanged content)
  12. `## License` (kept, unchanged content)
  13. Closing "🌌 *This is the way.*" (unchanged)
- **Rationale**: this is FR-001→FR-004's own literal ordering
  (what-is-SDD → specjedi-mapping → installation → honest-assessment
  teasers) with the required bookends (letter hook, comic section,
  Contributing, License) placed exactly where the spec pins them
  (FR-001/FR-007, Amendment 2). Consolidating "What you get today" and
  "Quickstart" into the new "How Spec Jedi Implements SDD" section (with
  full depth moved to `quickstart-guide.md`) is what FR-005's "replace &
  consolidate, fewer and more purposeful sections" resolution calls for.
- **Alternatives considered**: keeping "Who this is for" ahead of the
  SDD primer (today's order) — rejected because FR-001 requires the SDD
  explanation before *any* Spec-Jedi-specific claim, and "Who this is
  for" already leans on SDD literacy the reader wouldn't have yet.
- **Badge retargeting**: the `Pipeline` and `Skills` badges currently
  link to `#what-you-get-today`, a heading that no longer exists after
  this restructure. Both retarget to `#how-spec-jedi-implements-sdd`,
  the new section that carries the equivalent content.

## Decision: verbatim vs. tightened per relocated/condensed section

- **Skill catalog table, both diagrams, 23 Quickstart steps** → verbatim
  into `references/quickstart-guide.md`. These are already tight,
  information-dense, and specific (exact skill names, file paths,
  principle citations) — tightening further risks losing the precision
  FR-008 requires being preserved. Only the surrounding prose framing
  ("Now, the practical part of this letter...") gets genuinely rewritten
  in third person; the numbered steps' own content is unchanged.
- **Recommended companions** → verbatim into
  `references/recommended-companions.md`. Already concise, no first-
  person narrator voice to dial back.
- **Versioning & releases** → verbatim into `CONTRIBUTING.md`. Same
  reasoning — already third-person, already precise.
- **What-is-SDD / specjedi-and-SDD summaries (FR-001/FR-002)** →
  genuinely new, shorter prose per the spec's own Assumptions
  ("'Resumido' means genuinely new, shorter prose... not simply
  copy-pasting"). Condensed to roughly one paragraph plus a short list
  each, sized to fit a home-page read rather than the full reference
  doc's depth.
- **Honest-assessment / harness-capability-notes teasers (FR-004)** →
  genuinely new 2-4 sentence prose per document, each keeping one
  concrete advantage and one concrete limitation verbatim-in-substance
  from the source (not reworded into something softer) — satisfying
  SC-002's cross-reference check.

## Fact-preservation check (FR-008, SC-003)

Before this feature ships, the same fact-preservation method used for
features 036/`readme-informal-voice` applies: badge count (10),
skill-table row count (25), harness-table row count (20), and every
code block in Installation/Prerequisites must be identical in count and
content before and after — reorganizing and relocating changes location,
never facts.

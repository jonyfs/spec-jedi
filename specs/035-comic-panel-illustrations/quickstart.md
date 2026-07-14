# Quickstart: Original Illustrations for the Internal-Bootstrap Comic

Validation scenarios proving the 8 panel illustrations exist, share one
visual identity, pass the Star-Wars-signature exclusion review, and
render correctly — without any runtime dependency on the external
image-generation service.

## Prerequisites

- A checkout of this repository on the feature branch, with
  `docs/comic/panel-*.jpg` already generated per `tasks.md` and
  `README.md` already edited to embed them.

## Scenario 1 — All 8 (or fewer, per the honest fallback) images exist

```bash
ls docs/comic/panel-*.jpg | wc -l
```

**Expected**: between 1 and 8 files exist. Fewer than 8 is an
acceptable, honest outcome only if the missing panel(s) hit the
2-regeneration-attempt bound (FR-003/Clarifications) and correctly fall
back to text-only in `README.md` — not a silent gap.

## Scenario 2 — Every committed image passes the Star-Wars-signature review

Manual review: open each `docs/comic/panel-N.jpg` and confirm none
depicts any item from FR-003's named list (glowing-blade weapon
silhouettes, X-wing/TIE-fighter/Star-Destroyer-shaped craft, twin-sun
desert-planet framing, Jedi-robe-specific silhouettes, the Star Wars
logo/wordmark).

**Expected**: zero violations across all committed images (SC-003).

## Scenario 3 — Visual consistency across the set

Manual review: view all committed images together (e.g., side by side
in a file browser or a scratch Markdown preview). Confirm a shared
palette (warm amber/teal), a shared flat-vector-with-cel-shading
rendering approach, and no image that reads as stylistically unrelated
to the others.

**Expected**: a viewer can tell all committed images belong to one set
without being told so (SC-002).

## Scenario 4 — README renders correctly on GitHub

```bash
git log -1 --format="%H"
```

Push the feature branch and view the rendered `README.md` on GitHub
(or a local Markdown preview that resolves relative image paths the
same way GitHub does); confirm each panel with a committed image shows
it immediately below that panel's existing text, and confirm any
fallback panel (Scenario 1) still shows its full existing text
unchanged.

**Expected**: images visible, text unchanged, no broken image links
(SC-001).

## Scenario 5 — No runtime dependency introduced

```bash
grep -c "image.pollinations.ai" README.md
```

**Expected**: `0` — the README references only committed local image
paths (`docs/comic/panel-N.jpg`), never a live URL to the generation
service itself (FR-006).

## Scenario 6 — Prompt record is durable and findable

```bash
grep -c "^[0-9]\+\. \*\*Panel [0-9]\+\*\*" specs/035-comic-panel-illustrations/research.md
```

**Expected**: `8` — every panel's prompt is recorded in `research.md`,
findable by a future maintainer without this session's own history
(FR-007, SC-004).

## Scenario 7 — Structural validation

```bash
./scripts/validate.sh
```

**Expected**: `PASSED` — confirms no regression elsewhere in the repo
(e.g., a broken anchor link from the README edit) and that the
constitution amendment (FR-008) leaves the file structurally valid.

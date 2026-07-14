# Quickstart: README as a Wise Jedi's Letter

## Scenario 1 — Fact preservation (SC-001, FR-002)

```bash
grep -c "img.shields.io" README.md          # expect 10, unchanged
grep -c "^| \`specjedi-" README.md          # expect 25, unchanged
sed -n '/^| Harness | Status |/,/^$/p' README.md | grep -c "✅ Supported"  # expect 20, unchanged
```

**Expected**: all three counts identical to the pre-feature README —
zero badges, skill-table rows, or harness-table rows lost to the letter
rewrite.

## Scenario 2 — Mermaid diagrams unchanged (SC-003, FR-004)

```bash
git diff main -- README.md | grep -E "^[-+]" | grep -E "flowchart|mindmap|sequenceDiagram|participant|-->|\-\.\->"
```

**Expected**: no output — none of the 5 existing Mermaid diagrams'
actual diagram syntax appears in the diff; only surrounding prose
changed.

## Scenario 3 — New images pass the Star-Wars-signature exclusion review (SC-002, FR-003)

Manual visual review of `docs/comic/letter-open.jpg` and
`docs/comic/letter-path.jpg` against Constitution Principle XII's named
exclusion list: no glowing-blade weapon, no X-wing/TIE-fighter/
Star-Destroyer-shaped craft, no twin-sun desert-planet framing, no
Jedi-robe-specific silhouette, no logo/wordmark.

**Expected**: both images pass on inspection; if either doesn't, revise
the prompt and regenerate (same bounded-retry discipline feature 035
established) before presenting.

## Scenario 4 — Exactly 2 new images, no duplicate comic-panel beat (FR-007, FR-008)

```bash
ls docs/comic/letter-*.jpg | wc -l   # expect 2
```

**Expected**: exactly 2 files, named distinctly from the `panel-N.jpg`
sequence — confirms no accidental over-generation past the approved
2-3 range, and no collision with the existing 8-panel naming.

## Scenario 5 — Letter voice present in narrative sections; reference sections unchanged in voice (FR-001, FR-005)

Manual read-through: confirm the opening pitch, "Who this is for,"
"What you get today" intro, and Quickstart's connective prose read as
an addressed letter (clear voice, opening/closing framing); confirm the
harness table, License, and Contributing sections read exactly as they
did after PR #100 (README-informal-voice) — no further voice change
applied there.

## Scenario 6 — Structural validation

```bash
./scripts/validate.sh
```

**Expected**: `PASSED`.

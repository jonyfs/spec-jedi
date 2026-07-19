# Constitution Mechanics

The exact mechanical detail behind writing or amending
`.specify/memory/constitution.md` — referenced by `specjedi-constitution`
rather than restated inline.

## Sync Impact Report format

Every amendment prepends a new HTML comment block at the very top of the
file (above any prior Sync Impact Report blocks, which stay as an
accurate historical record — never edited or removed):

```markdown
<!--
Sync Impact Report
- Version change: X.Y.Z → X'.Y'.Z'
- Modified principles: <Roman numeral>. <Name> — <MAJOR/MINOR/PATCH>
  bump, <one-line reason>.
  - <Why this was requested/needed, in the maintainer's own words when
    directly requested>.
  - <What specifically changed vs. what stayed the same — the core rule
    vs. the added/clarified detail>.
  - <Why this bump level, not a different one — an explicit rejection of
    the alternative classification, e.g. "Not a MAJOR bump: nothing
    redefined incompatibly">.
-->
```

Each block documents exactly one amendment. A single PR touching
multiple principles gets one block per principle changed, or one block
covering all of them if they're genuinely one coordinated change —
judgment call, but never silently merge two unrelated amendments into
one report.

## Propagation checklist for dependent templates

When a principle's own number, name, or referenced mechanism changes,
check these templates for a now-stale reference and update them in the
same amendment:

- `.specify/templates/checklist-template.md` — references specific
  principle numbers in its own quality-gate language.
- `.specify/templates/tasks-template.md` — references Principle VI
  (test-first) sequencing guidance.
- `.specify/templates/plan-template.md` — references the Constitution
  Check gate structure itself.
- `references/principle-traceability.md` — every principle's own row
  should reflect the amendment (new mechanism, changed status).

A renumbering (principle inserted/removed, changing every later Roman
numeral) requires checking all four; an in-place text amendment (like
this one) usually only touches `principle-traceability.md`, if that.

## Validation steps

Before considering an amendment complete:

1. Zero `[PLACEHOLDER]`-style bracketed tokens remain anywhere in the
   file.
2. The `**Version**` footer line's number matches the Sync Impact
   Report's own stated "Version change" target exactly.
3. Every date in the file (`**Ratified**`, `**Last Amended**`) is ISO
   format (`YYYY-MM-DD`).
4. `scripts/validate.sh` passes (structural lint covers frontmatter
   presence across the skill catalog, not constitution content
   specifically — this step confirms the amendment didn't break
   anything else in the same commit).

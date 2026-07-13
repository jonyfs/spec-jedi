# Quick: Ground the "How Spec Jedi builds itself" comic in real evidence

**Status**: Implemented

## What & why

README.md's "How Spec Jedi builds *itself*, in comic form" section
(the internal-bootstrap narrative: constitution → specify → clarify →
plan → tasks → implement → PR → `ci-gate` → auto-merge → shipped) reads
as a hypothetical illustration. It isn't — this exact loop just ran
for real, repeatedly, in this project's own git history (PRs #82-#87,
this same session). Ground the comic in that evidence with one added
line, so a reader can verify the story isn't aspirational.

## Concrete changes

- `README.md`: add one line after Panel 8 (before "### The same
  internal-bootstrap story, as a diagram") citing that this exact
  8-panel loop is not illustrative — it's the literal, repeated,
  observable process behind this project's own recent pull requests.

## Acceptance checks

- [x] The added line names at least one real, checkable PR number as
      evidence, not a vague "this really happens" assertion.
- [x] No other content in the comic panels or sequence diagram changes —
      scoped to one grounding addition, not a rewrite.
- [x] `scripts/validate.sh` still passes.

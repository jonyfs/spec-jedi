# Quickstart: Verifying Mandatory, Failure-Aware Render Verification

**Feature**: 026-mandatory-render-verify

## Prerequisites

- `.claude/skills/specjedi-diagram/SKILL.md` revised per `plan.md`'s
  Design section (unconditional verification, unified failure handling,
  bounded retry, honest fallback).
- Feature 025 landed first (research.md's ordering note) so this
  feature's revision builds on 025's already-updated Step 4 text.

## Scenario 1: Verification always runs, even for a trivial diagram

**Run**: Ask `specjedi-diagram` for a diagram of a small, obviously-fine
source (2-3 steps).

**Expected outcome**: the response still states a verification attempt
and its result — never presented as if "too simple to bother checking."

## Scenario 2: A syntax error triggers revision, not silent failure

**Setup**: Construct a request likely to produce a Mermaid syntax
mistake (or manually verify by reviewing a deliberately malformed
generated source).

**Expected outcome**: the skill catches the syntax failure, revises, and
re-checks — the final presented diagram is either fixed-and-verified, or
(if still failing after 2 attempts) presented with an explicit
"unverified" caveat, never silently shown as if checked.

## Scenario 3: A render-call failure (not a syntax error) triggers the same path

**Setup**: Request a diagram complex/large enough to plausibly risk an
oversized-output failure from the render-verification tool (this
session's own precedent: a 20-node, 3-subgraph flowchart previously
triggered exactly this).

**Expected outcome**: the skill treats the failed render call the same
as a syntax failure — attempts a size-driven revision (simplify, or
invoke feature 025's threshold/splitting mechanism once available),
re-checks, and states the outcome plainly either way.

## Scenario 4: Bounded retry — no infinite loop

**Setup**: A diagram engineered to keep failing verification even after
one revision.

**Expected outcome**: exactly 2 revision attempts, then an explicit stop
with an honest "could not produce a verified diagram" statement and the
last-attempted source shown with a caveat — never a third silent retry,
never an indefinite loop.

## Structural validation

```bash
./scripts/validate.sh
```

**Expected outcome**: passes — `specjedi-diagram/SKILL.md`'s frontmatter
and required sections remain structurally intact (spec.md SC-004).

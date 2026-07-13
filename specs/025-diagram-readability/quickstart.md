# Quickstart: Verifying Theme-Safe, Right-Sized Mermaid Diagrams

**Feature**: 025-diagram-readability

## Prerequisites

- `.claude/skills/specjedi-diagram/SKILL.md` revised per `plan.md`'s
  Design section (theme-safety + complexity-threshold self-checks folded
  into Step 4).
- `references/mermaid-diagram-catalog.md` revised with the new "Theme
  Safety" and "Complexity Threshold" sections.

## Scenario 1: A generated diagram contains no explicit color override

**Setup**: Ask `specjedi-diagram` for a diagram of any existing feature's
`spec.md` (e.g., `specs/025-diagram-readability/spec.md` itself — it has
three prioritized user stories, a natural flowchart candidate).

**Run**:
```
Invoke specjedi-diagram against specs/025-diagram-readability/spec.md
```

**Expected outcome**: the generated Mermaid source contains no
`style ...`, `classDef ...`, or `%%{init: {'theme'` line — verified with
`grep -E 'style |classDef |%%\{init' <generated source>` returning no
matches. The one-line type note explicitly states the theme-safety
self-check passed.

## Scenario 2: A large source gets split into multiple smaller diagrams

**Setup**: Ask `specjedi-diagram` for a diagram covering all 25 shipped
features' relationships (a deliberately oversized ask — 25+ nodes at
minimum), or any other source content that would naturally produce more
than 20 nodes in one diagram.

**Run**:
```
Invoke specjedi-diagram against a source with 20+ distinct steps/entities
```

**Expected outcome**: instead of one large diagram, the skill presents
multiple smaller diagrams (e.g., one per logical group), each individually
under 20 nodes, each carrying a one-line label naming which part of the
whole it covers. The skill states explicitly that the split happened
because the source exceeded the complexity threshold.

## Scenario 3: A small source is NOT force-split

**Setup**: Ask for a diagram of a small feature (e.g., a spec with 2-3
user stories and under 10 total steps/entities).

**Run**:
```
Invoke specjedi-diagram against a small, simple source
```

**Expected outcome**: a single diagram, exactly as before this feature —
confirming the threshold doesn't cause unnecessary splitting (spec.md
Acceptance Scenario US2/AS2).

## Scenario 4: Render-verification still runs (or the caveat still applies)

**Run**: Any of the above, in an environment without a live Mermaid
render-check tool available.

**Expected outcome**: the skill still performs the theme-safety and
complexity self-checks (they're static source inspection, not a
rendering capability) and still states explicitly that live
render-verification wasn't available — matching the skill's pre-existing
documented fallback, now explicitly confirmed to apply to the new checks
too (spec.md Edge Cases).

## Structural validation

```bash
./scripts/validate.sh
```

**Expected outcome**: passes — `specjedi-diagram/SKILL.md`'s frontmatter
and required sections remain structurally intact after the revision
(spec.md SC-004).

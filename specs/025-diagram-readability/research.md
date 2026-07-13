# Research: Theme-Safe, Right-Sized Mermaid Diagrams (feature 025)

## Principle II: competitive research before creation

This is a revision to an already-shipped skill (feature 004), not a new
structural pattern — Principle II's competitive-benchmarking gate applies
to *new* skills/workflows/patterns. The two rules this feature adds
(theme-safety, complexity threshold) are grounded directly in Mermaid's
own documentation and GitHub's documented rendering behavior (below),
consistent with Principle XX's grounding requirement, rather than in a
fresh SDD-tool competitive survey.

## Decision 1: Theme safety — never emit explicit color overrides

**Decision**: `specjedi-diagram` MUST NOT emit `style`/`classDef` fill,
stroke, or text-color directives, nor a `%%{init: {'theme': ...}}%%`
directive, in generated Mermaid source. Any status/category distinction
a diagram needs to convey MUST use shape, edge style, or label text/emoji
instead of color.

**Rationale**: Two independent, corroborating findings from live research
(2026-07-13):

1. GitHub auto-detects the viewer's `prefers-color-scheme` and renders
   the *same* Mermaid source as a light SVG or a dark SVG automatically
   — but only when the source doesn't itself set an explicit theme or
   colors. The moment a diagram hardcodes `style`/`classDef` colors or a
   `theme` directive, GitHub's own auto-switching breaks, because those
   values get baked into the rendered SVG regardless of the viewer's
   actual preference. This is a real, currently-open, widely-hit failure
   mode — [GitHub Community Discussion #35733, "Mermaid diagram becomes
   unreadable in dark mode"](https://github.com/orgs/community/discussions/35733)
   and [#12116, "Mermaid doesn't apply dark theme when using github dark
   mode"](https://github.com/orgs/community/discussions/12116) both
   document exactly this.
2. Mermaid itself confirms there is no safe, purely-static way to make a
   hardcoded color pair work in both light and dark simultaneously: "the
   theme of a Mermaid diagram cannot be changed after rendering" and
   "Mermaid doesn't automatically detect the system preference" for its
   own JS-level theme switching ([Mermaid Theme Configuration
   docs](https://mermaid.js.org/config/theming.html); open feature
   request [mermaid-js/mermaid#7144, "Support for Automatic Light/Dark
   Theme Switching in Exported
   Diagrams"](https://github.com/mermaid-js/mermaid/issues/7144),
   unresolved as of this research). Since Spec Jedi's diagrams are
   static, markdown-embedded output (specs, README) — not a live page
   with JS-level theme-switching infrastructure — there is no reliable
   middle ground: the only approach that's correct in *both* themes
   simultaneously is not overriding color at all and letting the
   rendering surface's own theme (GitHub's, or any harness's) apply.

**Alternatives considered**:
- *Pick a single "safe" hex pair that reads acceptably in both themes*
  — rejected: no such universal pair exists (a color with enough
  contrast against white typically fails against near-black, and vice
  versa, without per-theme adjustment the tooling here can't provide).
- *Emit two variants (light-theme diagram + dark-theme diagram)* —
  rejected as disproportionate: doubles every diagram's maintenance
  surface for a problem the "no explicit color" rule already solves for
  free, and GitHub markdown has no native mechanism to show one or the
  other conditionally (unlike a JS-rendered site, which is not Spec
  Jedi's target surface).
- *Use Mermaid's `theme: neutral`* — rejected: forces one specific
  additional visual identity choice unrelated to the actual problem
  (legibility across an *externally-controlled* light/dark toggle,
  which `theme: neutral` does not solve — it's still one fixed theme).

This resolves spec.md's FR-001/FR-002: FR-002's "theme-neutral approach"
is, concretely, "no color at all; encode the distinction structurally."

## Decision 2: Complexity threshold — 20 nodes, split along natural seams

**Decision**: a diagram exceeding **20 nodes**, or requiring more than
**one sentence to describe what it shows**, MUST be reconsidered as
multiple smaller diagrams split along a natural seam in the source
content (one per user story, one per phase, overview + detail, etc.).

**Rationale**: grounded in cited practitioner consensus (2026-07-13
research), specifically calibrated to this project's actual embedding
context (Markdown, GitHub-rendered specs/README, not a full-screen
diagramming tool): "keep diagrams under 15–20 nodes for readability on
small screens when embedding in Markdown (GitHub, GitLab, Notion)... if
it needs more than 30–40 nodes, split it into two or three focused
diagrams" ([Mermaid flowchart sizing and layout: best
practices](https://www.mermaidcreator.com/blog/mermaid-flowchart-sizing-layout-best-practices)).
20 is chosen as the single number (per spec.md's Assumption) at the top
of the cited 15–20 primary-readability band — generous enough not to
force splitting on every moderately-sized diagram, strict enough to stay
well clear of the 30–40 "must split" zone the same source names.

The qualitative "can't describe it in one sentence" signal from the same
source is retained alongside the numeric one as a self-check the model
can apply even to diagram *types* where "node count" isn't the most
natural unit (e.g., a Gantt chart's task count, a class diagram's class
count) — the numeric 20 is the primary, always-applicable check;
one-sentence-describability is the qualitative backstop for edge cases.

**Alternatives considered**:
- *A per-diagram-type table of different thresholds* — rejected per
  spec.md's own Assumption: adds real complexity for a marginal
  precision gain; the cited guidance itself doesn't differentiate by
  type, and a single number is easier for the model to apply
  consistently and for a future reader to verify.
- *No numeric threshold, "split when it feels too big"* — rejected:
  violates Principle XIX's "quantifiable, not vague" requirement — an
  unquantified instruction is exactly the kind of vague guidance that
  produces inconsistent behavior under real load (the same reasoning
  Principle XIX's own rationale states directly).
- *Subgraph count as the primary metric instead of node count* —
  rejected as primary (a diagram can have very few subgraphs and still
  be dense/illegible, or many small subgraphs and still be readable);
  kept as a secondary signal worth naming in the skill's guidance
  alongside node count, not the trigger itself.

## Enforcement mechanism (resolves spec.md User Story 3 / FR-006)

Both checks are static source inspection (grep-able patterns: presence
of `style `/`classDef `/`%%{init` in the generated source; a node-count
tally), not a rendering capability — they run as a self-check step folded
into the skill's existing Step 4 (render-verification), so they apply
identically whether or not a live Mermaid render-check tool is available
in the current harness (per spec.md's Edge Cases).

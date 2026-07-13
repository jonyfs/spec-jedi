# Research: Honest Advantages/Disadvantages Assessment (feature 027)

## Principle II: reuse existing research, extend only where needed

`references/competitive-comparison.md` (feature 014) already researched
11 tools (spec-kit, BMAD-METHOD, OpenSpec, Kiro, Tessl, Spec Kitty,
Superpowers, GSD, PRP, Traycer, codemyspec.com) with per-tool
adopted/rejected mechanisms and verifiability notes. This feature's
Phase 0 work is re-reading that table specifically for *improvement
points* — a different question than the original table answered — not
re-researching competitors from scratch.

## Finding 1: a design idea marked "Adopted" was never actually shipped

`competitive-comparison.md`'s BMAD-METHOD row states Spec Jedi
*"Adopted"*: *"The 'Quick Flow' lightweight-path idea — a way to skip
phases 1-3 for small, well-understood work."* A search of this session's
own observed skill set (all 23 shipped `specjedi-*` skills, per
`references/skill-roadmap.md`'s Shipped sections) turns up no
lightweight-path skill or flag — every feature, including small
documentation-only ones, currently goes through the full research →
specify → clarify → plan → tasks → implement pipeline (this session's
own work, including this very document, is a live example). This is a
genuine, concrete finding of exactly the kind FR-001's grounding
requirement is designed to catch: a claim recorded as "adopted" in
research isn't automatically a shipped advantage — it's currently a
**disadvantage and improvement point** (the idea was validated as worth
having, then never built), not the "no lightweight path" weakness
correctly attributed to spec-kit in the same table.

## Finding 2: genuine improvement points, competitor-grounded

Cross-referencing `competitive-comparison.md`'s per-tool descriptions
against what's actually shipped today surfaces concrete gaps:

- **No cross-project pattern registry** (vs. Tessl): the table describes
  Tessl as *"$125M raised, public Framework + Registry"* with *"a shared,
  cross-project registry of reusable patterns"* — loosely echoed in
  `specjedi-find-skills`, but that skill reasons about the current
  session's known ecosystem, not a persistent, shared index the way
  Tessl's Registry does.
- **No zero-setup, IDE-native experience** (vs. Kiro): the table
  describes Kiro as *"Full agentic IDE (AWS, GA since Nov 2025)"* with
  install-friction explicitly named as the thing Spec Jedi's own
  Principle III (harness portability) trades against IDE-lock-in. Even
  feature 024's no-clone bootstrap installer still requires running a
  command; there is no built-in, zero-action experience analogous to a
  pre-integrated IDE feature.
- **No lightweight path for small changes** (vs. OpenSpec, and per
  Finding 1, vs. Spec Jedi's own prior BMAD-derived intent): OpenSpec is
  described as *"Lightweight, brownfield-focused change management (3 AI
  commands)"* — genuinely lighter-weight than Spec Jedi's own full
  pipeline for a small, well-understood change.
- **Worktree-awareness stayed a documented option, not a mechanized
  feature** (vs. Spec Kitty): the table's own wording — *"as a documented
  option for parallel independent features — not required machinery"* —
  is itself the honest limitation; Spec Kitty's worktree-based parallel
  development is a real, working mechanism there.

## Finding 3: real, non-competitor-tied disadvantages (still required, per FR-002)

Not every genuine disadvantage needs a competitor citation (spec.md Edge
Cases explicitly allows this) — checked directly against this session's
own verified state:
- No `v0.1.0` (or any) release has been cut yet — `git tag -l` returns
  empty as of this session.
- Harness coverage (feature 023) reaches all 20 in
  `references/harness-capability-notes.md`'s original sense (a real
  install path exists and is CI-tested), but the *underlying per-harness
  documentation* for the 14 bridge-mode harnesses is desk-research-
  grounded (one WebSearch/WebFetch citation per harness) rather than
  hands-on-verified inside that actual product — the same honesty
  distinction `harness-capability-notes.md` itself already draws.
- Single-maintainer project, versus Tessl ($125M raised) and Kiro
  (AWS-backed) — a real scale/support-capacity gap worth stating plainly.

## Decision: document structure

Advantages, Disadvantages, and Improvement Points as three distinct
sections (matching spec.md's three user stories and Key Entities) rather
than one blended list — keeps FR-001's "every advantage traces to a
shipped mechanism" and FR-004's "every improvement point names a
competitor" independently auditable per section, rather than mixed
together where a reader can't tell which claims carry which grounding
bar.

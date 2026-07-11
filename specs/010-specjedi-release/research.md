# Research: `specjedi-release`

**Feature**: 010-specjedi-release

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

Principle XI ("Semantic-Versioned Releases with Proactive Cut
Suggestions") already mandates this project proactively suggest version
bumps from Conventional Commit history — and `scripts/suggest-release.sh`/
`.ps1` implement that logic correctly (verified: reads `git describe
--tags`, classifies commits by Conventional Commits prefix, suggests a
semver bump, never tags or publishes). But no `specjedi-*` skill gives
this a product surface — it's a bare script a user has to know to run,
with no narration, no voice, no integration into the rest of the
pipeline (e.g., suggesting a release check after `specjedi-docs` finishes
documenting a shipped feature). This is the same shape of gap
TODO(INSTALLER) closed for Principle XVIII: a principle mandates a
capability, a script implements the mechanism, but nothing wraps it as an
actual `specjedi-*` product experience.

## Internal-redundancy check (established discipline since feature 007)

Checked against every shipped `specjedi-*` skill: `specjedi-status`
(feature 005) reports feature-level completion state, not release/version
state — different target entirely. `specjedi-docs` (feature 008) drafts
`CHANGELOG.md` entries but explicitly does not suggest version numbers
(its own `plan.md` states this directly: "this skill doesn't suggest a
version number — that's `scripts/suggest-release.sh`'s job"). No shipped
skill wraps the release-suggestion script itself. No redundancy found —
and `specjedi-docs`'s own design already anticipated this skill's
existence by name.

## Genuine contribution beyond the researched field

None of the eleven tools researched across features 001-009 ship a
release-suggestion mechanism that is simultaneously (a) fully automatic
from commit history, (b) never tags or publishes without an explicit
human step, and (c) wrapped in the same project-voice/guided-next-step
product experience as the rest of the SDD pipeline. Most researched
tools either have no release-suggestion mechanism at all, or (where
semantic-release-style tooling exists in the broader ecosystem) automate
the *tag and publish* step too — this project's own Principle XI
explicitly requires a suggest-only, human-gated design, which is itself
already a deliberate divergence from typical semantic-release automation
(documented at the constitution level, not just this skill). The genuine
contribution here is narrower: turning an already-correct script into an
actual `specjedi-*` skill experience — the same "give the mandated
capability a real product surface" contribution the installer made for
Principle XVIII.

## Baseline: GitHub spec-kit

No release-suggestion command in its surface. **Adopt**: nothing (no
mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for release-suggestion tooling)

1. **BMAD-METHOD** — no release-suggestion mechanism found.
2. **OpenSpec** — no release-suggestion mechanism found.
3. **Kiro** — no release-suggestion mechanism found in its public surface.
4. **Tessl** — no release-suggestion mechanism found.
5. **Spec Kitty** — no release-suggestion mechanism found.
6. **Superpowers** (installed, inspected firsthand) — no release-
   suggestion mechanism in its skill set.
7. **GSD** (installed, inspected firsthand) — no release-suggestion
   mechanism found; its own versioning (if any) is out of scope for the
   installed command set inspected.
8. **PRP** (installed, inspected firsthand) — no release-suggestion
   mechanism found.
9. **codemyspec.com** — no comparable mechanism found.
10. **Traycer** — no release-suggestion mechanism found.

Broader ecosystem context (not one of the ten SDD-tool competitors, but
relevant prior art): `semantic-release` (npm) and similar tools
auto-tag-and-publish from Conventional Commits — this project's Principle
XI explicitly rejects that automation boundary in favor of
suggest-only. **Reject**: auto-tag-and-publish, by explicit constitutional
design, not oversight.

## Design implications for `specjedi-release`

- **Wrap, never reimplement** the existing `scripts/suggest-release.sh`/
  `.ps1` logic — those scripts are already correct and tested; this skill
  adds narration, voice, and pipeline integration around their output,
  not a second implementation of commit-parsing logic.
- **Never tag or publish** — the skill's own write surface is zero; it
  only runs the read-only script and presents its output, matching
  Principle XI's explicit "suggests, never cuts" boundary.
- **Proactive trigger candidate**: `specjedi-docs`, after drafting a
  `CHANGELOG.md` entry for a shipped feature, is a natural point to
  suggest checking for a release — but per this project's own precedent
  (Principle XVII's proactive contract requires a literal self-invoke
  line in the triggering skill's file, verified directly, not assumed),
  this needs an actual edit to `specjedi-docs/SKILL.md` to wire in for
  real, the same way `specjedi-plan` was edited for `specjedi-security`
  (feature 007).

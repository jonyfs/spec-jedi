# Research: Retire `speckit-*` Bootstrap Tooling

**Feature**: specs/048-retire-speckit
**Date**: 2026-07-18

No `NEEDS CLARIFICATION` markers remain in spec.md — the maintainer
already resolved the one real open question (retire the two
`agent-context` hooks rather than keep `speckit-agent-context-update`)
before this spec was written. This document resolves the remaining
*design* questions.

## Decision 1: Reuse `specjedi-migrate` for the constitution's live command references, don't hand-edit them

**Decision**: `.specify/memory/constitution.md`'s Development Workflow
and Governance sections' literal `/speckit-*` command references are
rewritten via `specjedi-migrate` (feature 003, already shipped) rather
than a manual find-and-replace.

**Rationale**: `specjedi-migrate` exists for exactly this operation —
its own Step 3 already implements the live-vs-historical judgment call
this feature needs (the constitution's Sync Impact Report entries
throughout the file are genuine historical records of past amendments,
distinct from the Development Workflow/Governance sections' current,
ongoing instructions), and its Always/Never guarantees zero change to
surrounding principle/requirement text — precisely the FR-009
guarantee this feature also needs. Re-implementing that judgment call
by hand risks missing a mention or, worse, rewriting a historical
Sync Impact Report entry and quietly falsifying project history.
Discovered by reading `specjedi-migrate/SKILL.md` directly before
writing this plan (Principle II applied to this project's own existing
tooling, not just external competitive research).

**Scope boundary**: `specjedi-migrate`'s own compatibility line reads
and rewrites only `constitution.md` and `specs/*/{spec,plan,tasks}.md`
— it does not touch `README.md` or `CONTRIBUTING.md`. Those two files'
`speckit-*` mentions are corrected manually in this feature instead
(FR-006/FR-007), since they fall outside that skill's designed scope.

**Alternatives considered**:
- Manually grepping and rewriting every constitution mention by hand.
  Rejected: duplicates work an already-shipped, already-tested skill
  does more reliably, and manual rewriting has no built-in guard
  against accidentally touching a historical Sync Impact Report entry.
- Extending `specjedi-migrate`'s own scope to also cover `README.md`/
  `CONTRIBUTING.md` in this same feature. Rejected: that skill's scope
  is deliberately narrow (its own frontmatter states it precisely);
  widening it is a separate design decision about that skill's own
  future capability, not something this removal-and-correction feature
  should decide as a side effect.

## Decision 2: Amend Principle XV via `specjedi-constitution`, not `speckit-constitution`

**Decision**: The constitution amendment this feature requires (FR-005)
is authored using `specjedi-constitution`, even though
`speckit-constitution` still exists at the time this feature begins
(it's deleted later in the same feature, per FR-002's ordering).

**Rationale**: The constitution's own Governance section states
amendments are proposed "through the `/speckit-constitution` command
(or an equivalent reviewed PR)" — the parenthetical already permits an
equivalent mechanism, and `specjedi-constitution` (feature 002) is a
full, already-shipped equivalent (per specs/044's own Full Parity
verdict). Using it here is not just permitted but fitting: this is the
last edit to the constitution before its own bootstrap tool is retired,
and demonstrating the successor tool handles real governance work
first is a more meaningful proof point than a symbolic "last hurrah"
for the tool being removed.

**Version bump**: PATCH, not MINOR or MAJOR. Principle XV's actual
*rule* — the `specjedi-` naming convention, and the requirement that
end-user-facing material present `specjedi-*` as the product and any
vendored bootstrap tooling as internal-only — is completely unchanged
by this feature. Only a factual claim within the principle's own prose
("this project currently uses spec-kit's own command skills to build
itself") is corrected to match the now-completed migration. The
constitution's own Versioning policy defines PATCH as exactly this:
"clarifications, wording, or typo fixes with no semantic change."

**Alternatives considered**:
- MINOR bump, reasoning that "removing a tool" is a significant enough
  event to warrant it. Rejected: the Versioning policy's own test is
  whether the principle's *guidance* materially expands or a
  *governance section* is added — neither applies here; the guidance
  itself (the rule) is identical before and after this amendment.
- Leaving Principle XV's prose untouched and only updating
  `principle-traceability.md`'s row instead. Rejected: the
  traceability index is explicitly a derived, secondary lookup
  document (per its own header) — the constitution itself is the
  authoritative source, and a false ongoing claim in the authoritative
  document is a real Principle XX (grounded/honest output) problem the
  traceability fix alone wouldn't resolve.

## Decision 3: Update the "comic form" README section in place, rather than reframing it as historical

**Decision**: README's "How Spec Jedi builds itself, in comic form"
section is updated to narrate the same 8-beat walkthrough using
`specjedi-*` command names, rather than being retitled/reframed as a
historical account of a bootstrap phase that has ended.

**Rationale**: The narrative arc itself (idea → constitution →
spec/clarify → plan/tasks → test-first implementation → PR → CI gate →
merge) remains identically true under `specjedi-*` — nothing about the
actual process this project follows changes; only which tool executes
each stage changes. Rewriting the command names preserves the
already-commissioned illustrations (feature 035) and the discipline
specs/036/037 already settled (professional-but-themed voice, epigraph
kept, comic section kept) while fixing the one thing that's now
factually wrong: the commands named. A "this used to be true" reframe
would be the honest fallback if the underlying process itself had
changed, but it hasn't — only the tool executing it has, which is a
smaller, more precise correction.

**Alternatives considered**:
- Reframe the whole section as an explicit historical account (e.g.,
  "In this project's early bootstrap phase, before feature 048..").
  Rejected as the *primary* approach: this would be true but
  needlessly diminishes a still-accurate process description to
  "history" when the actual walkthrough is exactly what happens today,
  just under a different command prefix — a case Decision 3's own
  reasoning distinguishes from genuinely historical content (e.g., the
  Sync Impact Report entries in Decision 1, which describe events, not
  an ongoing process).
- Delete the section entirely now that it no longer describes vendored
  incumbent tooling. Rejected: specs/036/037 already invested real
  commissioned artwork and narrative work here, and the section still
  serves its original purpose (showing the real pipeline end-to-end) —
  just as well, or better, once it accurately names the project's own
  tool instead of the incumbent's.

## Summary of touched files

| File | Change |
|---|---|
| `.specify/extensions.yml` | MODIFIED — `after_specify`/`after_plan` hook registrations removed (Decision-independent, FR-001) |
| `.claude/skills/speckit-*/` (11 dirs) | DELETED (FR-002) |
| `.specify/memory/constitution.md` | MODIFIED — `specjedi-migrate` run (Decision 1) + manual Principle XV prose amendment via `specjedi-constitution` (Decision 2), Sync Impact Report, PATCH version bump |
| `README.md` | MODIFIED — comic-form section's command names updated (Decision 3) |
| `CONTRIBUTING.md` | MODIFIED — "Voice and naming" section corrected |
| `references/principle-traceability.md` | MODIFIED — Principle XV row + Development Workflow row updated |
| `specs/044-speckit-parity-audit/PARITY-LEDGER.md` | MODIFIED — migration marked executed |
| `CHANGELOG.md` | MODIFIED — new `## Unreleased` entry for this feature |

No new scripts, no new reference files, no new dependencies. All
`specs/001-*` through `specs/047-*` files and all pre-existing
CHANGELOG entries are explicitly out of scope (FR-009).

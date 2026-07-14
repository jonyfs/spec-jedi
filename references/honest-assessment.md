# Honest Assessment: Advantages, Disadvantages, and Improvement Points

*Last reviewed: 2026-07-13 (updated: the "Quick Flow" gap this document
named as its top improvement point shipped the same day as
`specjedi-quick`, feature 028 — Disadvantage #1 and the corresponding
Improvement Point below were revised to reflect that. Also updated the
same day: worktree-awareness, previously Disadvantage #5 and another
Improvement Point below, shipped as `specjedi-worktree`, feature 032 —
both entries closed to reflect that, not left stale).*

A candid answer to "why would — or wouldn't — I use Spec Jedi's
`specjedi-*` skills today." This is not a marketing page: every
advantage below cites a specific, currently-shipped mechanism you can go
check yourself, and every disadvantage is stated plainly, not softened.
Built primarily on the research already done in
[`references/competitive-comparison.md`](competitive-comparison.md)
(11 SDD tools benchmarked against this project), re-read here
specifically for gaps rather than re-researched from scratch.

## Advantages

Each claim below is backed by something real in this repository, not an
aspiration — check `references/principle-traceability.md` for the
authoritative status of any principle these tie back to.

1. **All 20 harnesses in the target compatibility matrix have a real,
   CI-tested install path** — no researched competitor claims (let alone
   proves) this breadth of portability. See the README's "Supported
   harnesses" table and `.github/workflows/validate.yml`'s
   `install-test-*` job family.
2. **Diagrams get render-verified before they're shown to you.**
   `specjedi-diagram` runs generated Mermaid source through a live
   render-check and revises on failure — feature 004's original research
   found no comparable check in any of the 11 tools surveyed, and it's
   still true today.
3. **A per-PR governance compliance check against all 20 constitution
   principles**, not just a code-quality lint. `specjedi-govcheck`
   (feature 013) is proactively self-invoked before every PR opens.
4. **A project status dashboard with zero separately-maintained tracking
   system.** `specjedi-status` derives entirely from on-disk `spec.md`/
   `plan.md`/`tasks.md` state — nothing to forget to update by hand.
5. **A constitution that's actually a living, versioned document, not a
   one-time README section.** Real Sync Impact Reports trace every
   amendment back to v1.15.x; it's currently at v1.24.0 with a documented
   amendment procedure and semantic versioning policy.
6. **A CI-gated, self-validating PR workflow, tested cross-platform.**
   `ci-gate` aggregates the full validation battery across
   Linux/macOS/Windows, bash and native PowerShell — not asserted, run.

## Disadvantages

At least 5 genuine, currently-true limitations — each independently
checkable against this repository's real state, not a hedge.

1. **Heavier process ceremony than the lightest competitors, for changes
   that don't need the fast path.** `specjedi-quick` (feature 028,
   shipped 2026-07-13) now closes the "no lightweight path at all" gap
   this item used to describe — but its own eligibility checklist (one
   page of notes, single subsystem, no ambiguity) still routes anything
   bigger through the full research → specify → clarify → plan → tasks
   → implement pipeline, which remains real overhead for a solo
   developer's medium-sized change that doesn't clear the fast-path bar.
2. **No release has ever been cut.** `git tag -l` returns nothing as of
   this writing. The release mechanism (`.github/workflows/release.yml`)
   exists and works, but `v0.1.0` itself remains an outstanding,
   deliberate maintainer action (Principle XI), not something automated.
3. **Most harness install paths are desk-research-grounded, not
   hands-on-verified inside the real third-party product.** Of the 20
   supported harnesses, a real install path exists and is CI-tested for
   all of them — but for the 14 "bridge-file" harnesses (Cursor,
   Windsurf, GitHub Copilot, etc.), the underlying rules-file convention
   each install targets comes from one cited desk-research citation per
   harness (`references/harness-capability-notes.md`), not a hands-on
   session inside that actual product confirming the bridge file is
   read the way the citation says it should be.
4. **Single-maintainer project.** Compare Tessl ($125M raised) or Kiro
   (AWS-backed, GA product) — Spec Jedi has no comparable funding,
   dedicated team, or support capacity behind it.

## Improvement Points

The competitor-grounded subset of the disadvantages above — each names a
specific tool that already solves the gap, so these are concrete,
prioritizable roadmap signals, not vague aspirations.

- **A cross-project pattern/spec registry**, closer to Tessl's Framework
  + Registry model. `specjedi-find-skills` today only reasons about the
  current session's known ecosystem — there's no persistent, shared
  index of patterns across projects the way Tessl's Registry provides.
- **A lower-friction, closer-to-zero-setup install experience**, closer
  to Kiro's fully-integrated IDE model. Even feature 024's no-clone
  bootstrap installer (`curl | bash`) still requires the user to run a
  command; Kiro's AWS-backed IDE has no equivalent install step at all
  (at the real cost of Kiro locking you into one IDE, which Principle
  III explicitly trades away — this isn't a call to become an IDE, just
  a note that "no install step" is a real UX bar Spec Jedi hasn't hit).

## Maintenance

Update this document (not a new one) whenever a listed disadvantage is
resolved or a new, real gap is found — update the "Last reviewed" line
at the top whenever a substantive change is made, so staleness is
visible rather than silent.

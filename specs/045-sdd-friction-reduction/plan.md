# Implementation Plan: SDD Friction Reduction — Closing Researched Community Pain Points

**Branch**: `045-sdd-friction-reduction` | **Date**: 2026-07-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/045-sdd-friction-reduction/spec.md`

## Summary

Closes three real, independently-corroborated SDD community pain points
(researched via GitHub `spec-kit` issues/discussions, engineering blogs,
and academic papers — spec.md's own "Research Grounding" section) by
extending four existing skills, never adding new ones:

1. **Requirement-to-verification traceability** ("the missing testing
   layer") — a new step inside `specjedi-analyze` checking that every
   FR/Acceptance Scenario has real evidence (a passing test or an
   explicit manual-verification note), not just a task that claims it's
   done. Self-invoked by `specjedi-implement` before every PR-open,
   alongside its existing `specjedi-govcheck` self-invoke — same
   advisory-only posture, never blocks the PR.
2. **Context-budget governance** (spec-size escalation + skill-file token
   bloat) — a new step in `specjedi-skill-review` measuring a skill's own
   token count against Constitution Principle XIX's stated budget, and a
   new step in `specjedi-plan` comparing `spec.md`/`plan.md` size against
   this project's own historical median (193 lines today, computed
   directly, not assumed). Both self-invoked automatically as part of
   each skill's existing pass, both advisory-only, never a CI-blocking
   gate.
3. **Dedicated bug-fix path** — `specjedi-quick` gains a second
   eligibility branch and artifact shape (`bugfix.md`: repro / root cause
   / fix / regression test) alongside its existing `quick.md`, sharing
   every quality gate identically (test-first, `specjedi-govcheck`,
   PR-only).

## Technical Context

**Language/Version**: N/A — four existing Claude Code skills (`SKILL.md`
files, themselves structured prompts), extended in place. No new
language, runtime, or script.

**Primary Dependencies**: None new. Token-count approximation uses
`wc -c ÷ 4` (the standard ~4-characters-per-token English-prose
heuristic) — no tokenizer library. Line-count comparison uses `wc -l`
against existing `specs/*/spec.md`/`specs/*/plan.md` files — no new
dependency, matching this project's zero-`jq`/zero-tokenizer precedent.

**Storage**: N/A — reads existing `spec.md`/`plan.md`/`tasks.md`/
`SKILL.md` files and the project's own git-tracked `specs/` history;
writes nothing new except `specjedi-quick`'s existing write pattern
extended to a second artifact shape (`bugfix.md`, sibling to `quick.md`).

**Testing**: No new CI job — every touched skill is reasoning-driven
(LLM judgment over artifacts), the same posture `specjedi-govcheck`/
`specjedi-constitution-audit` already established (Principle IX
satisfied via `scripts/validate.sh`'s existing structural lint +
documented Validation Coverage sections + a real manual dry-run of each
enhancement against this repository's own artifacts before shipping).

**Target Platform**: Any harness capable of running `specjedi-*` skills
— no OS-specific code, so Principle XIII (cross-platform `.sh`/`.ps1`
parity) does not apply; nothing here is a script.

**Project Type**: In-place enhancement of four existing `specjedi-*`
skills — no new skill, no new project structure.

**Performance Goals**: N/A — each check is a single-pass reasoning step
added to an already-invoked skill; no new invocation point beyond the
one new self-invoke (Step 6.6 in `specjedi-implement`) already required
by Clarification Q1.

**Constraints**: Every new check MUST stay advisory-only per both
Clarification answers — none may block a PR or fail a CI run. Extending
these four skills MUST NOT push any of them past Constitution Principle
XIX's own 5,000-token hard cap — the irony of a context-budget feature
blowing its own host skills' budget would be self-defeating; each
skill's real size is checked before and after editing (Project Structure
below).

**Scale/Scope**: Four skill files modified, zero new files beyond this
feature's own `specs/045-*/` documentation — the smallest-footprint
option available for closing all three researched gaps (research.md
Decisions 1 and 6 explicitly reject new-skill alternatives for exactly
this reason).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | spec.md's own "Research Grounding" section documents real, cited, current (2026) community pain-point research across GitHub `spec-kit`, engineering blogs, and academic papers — done before any requirement was written, restated formally in research.md. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | No CI job, matching `specjedi-govcheck`/`specjedi-constitution-audit`'s own established precedent for reasoning-driven skills; validated via `scripts/validate.sh`'s existing lint + Validation Coverage sections + real dry-runs (Testing above). | ✅ Pass |
| XIV (Guided Next-Step Suggestion) | FR-006 requires every context-budget finding to include a concrete next step; the traceability check's own Unverified findings name the specific requirement and missing evidence. | ✅ Pass |
| XIX (Skill Authoring & Prompt Engineering Standard) | Every modified skill's own token budget is checked before/after this feature's edits (Project Structure below) — this feature must not violate the exact budget it's teaching other skills to respect. | ✅ Pass — enforced during implementation |
| XX (AI Discipline: Grounded, Honest Output) | Every Unverified/orphaned/outlier finding cites specific, named evidence (research.md Decisions 2-3); the token/line-count approximations are explicitly labeled as approximations, never presented as exact. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/045-sdd-friction-reduction/
├── plan.md              # This file
├── research.md           # Phase 0 output — 6 decisions
└── tasks.md              # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
specs/041/043: the "entities" (Traceability Verdict, Context-Budget
Finding, Bug-Fix Artifact) are already fully specified in spec.md's Key
Entities, and each modified skill's own Format/Example section (already
required by `references/skill-authoring-standard.md`) serves as the
validation guide.

### Source Code (repository root)

```text
.claude/skills/
├── specjedi-analyze/
│   └── SKILL.md          # MODIFIED: new evidence-based traceability
│                          #   step (US1) — every FR/Acceptance Scenario
│                          #   classified Verified/Unverified/N-A
├── specjedi-implement/
│   └── SKILL.md          # MODIFIED: new Step 6.6 self-invoking the
│                          #   enhanced specjedi-analyze before every
│                          #   PR-open, same posture as the existing
│                          #   Step 6.5 specjedi-govcheck self-invoke
├── specjedi-skill-review/
│   └── SKILL.md          # MODIFIED: new token-budget check (US2) —
│                          #   chars÷4 approximation vs. Principle XIX's
│                          #   500/5,000 target/hard-cap
├── specjedi-plan/
│   └── SKILL.md          # MODIFIED: new spec/plan size-outlier check
│                          #   (US2) — wc -l vs. this project's own
│                          #   historical median (193 lines today)
└── specjedi-quick/
    └── SKILL.md          # MODIFIED: new bug-fix eligibility branch +
                            #   bugfix.md artifact shape (US3), sibling
                            #   to the existing quick.md shape
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**US1 — `specjedi-analyze`'s new step** (insert after its existing
FR-to-task cross-reference step): for each FR/Acceptance Scenario already
confirmed to have a task, additionally check for (a) a named,
currently-passing test whose assertions map to the requirement's own
language, or (b) an explicit manual-verification note in `tasks.md`/
`quickstart.md` (research.md Decision 2's exact evidence definition).
Classify Verified/Unverified accordingly. Separately, scan for
substantial new code/test files with no traceable FR/Scenario origin
(research.md Decision 3) — flagged only when genuinely unexplained, per
`specjedi-analyze`'s own existing "never report an untraceable finding"
guardrail.

**US1 — `specjedi-implement`'s new Step 6.6**: immediately after the
existing Step 6.5 `specjedi-govcheck` self-invoke, self-invoke the
enhanced `specjedi-analyze` the same way — surface any Unverified/
orphaned finding prominently in the PR-opening narration, never block
the PR itself (Clarification Q1, Constitution Principle X remains the
actual merge gate).

**US2 — `specjedi-skill-review`'s new check**: `wc -c` the target
`SKILL.md`, divide by 4 for the token approximation, compare against
Principle XIX's ~500 target / 5,000 hard cap, report both the
approximate count and the limit explicitly, labeled as an approximation.
Only flag when over the hard cap (the soft target is informational, per
Clarification Q2's "never blocks" framing extended to "never even scolds
under the hard cap").

**US2 — `specjedi-plan`'s new final step** (after writing `plan.md`):

```bash
median_lines() {
  wc -l specs/*/"$1" 2>/dev/null | grep -v total | awk '{print $1}' \
    | sort -n | awk '{a[NR]=$1} END{
        if (NR < 5) { print 400; exit }
        if (NR % 2 == 1) print a[(NR+1)/2]
        else print int((a[NR/2]+a[NR/2+1])/2)
      }'
}
```

Compare the current feature's own `spec.md`/`plan.md` line counts
against `median_lines spec.md`/`median_lines plan.md` (excluding the
current feature from the sample); flag as an outlier when more than
double the median, per research.md Decision 5's exact threshold and
fallback.

**US3 — `specjedi-quick`'s new eligibility branch**: extend Step 1's
existing five-criteria eligibility check with an explicit bug-vs-feature
determination (research.md Decision 6: "is there existing, previously-
correct behavior to regress to?"). If bug-shaped, produce `bugfix.md`
(reproduction steps, root cause, the fix, a regression test) instead of
`quick.md`'s concrete-changes shape — every other step (worktree offer,
test-first implementation, `specjedi-govcheck` self-invoke, PR-only
delivery) stays identical between both shapes.

**Self-check before shipping (Principle XIX gate)**: run `wc -c` against
all five touched `SKILL.md` files before and after editing; if any
exceeds Principle XIX's 5,000-token hard cap (÷4 approximation) as a
result of this feature's own additions, split the addition into a
`references/<topic>.md` supporting file per
`references/skill-authoring-standard.md`'s own progressive-disclosure
guidance, rather than letting a context-budget feature blow its own
hosts' context budget.

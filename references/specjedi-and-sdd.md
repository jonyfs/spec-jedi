# How Spec Jedi's Skills Help With SDD

If you haven't already, read
[`references/what-is-sdd.md`](what-is-sdd.md) first — this document
assumes you already know what a spec, plan, task breakdown, and rules
document are, and maps each SDD activity onto the specific `specjedi-*`
skill that handles it. Every mapping below cites a real, currently-
shipped mechanism, not an aspiration — the same grounding bar
[`references/honest-assessment.md`](honest-assessment.md) holds this
project's own self-description to.

## Activity → skill mapping

| SDD activity (from `what-is-sdd.md`) | Skill(s) | What actually happens |
|---|---|---|
| Establish the rules document | `specjedi-constitution` | Produces a versioned `.specify/memory/constitution.md`; every amendment gets a recorded Sync Impact Report and a semantic version bump — this repo's own constitution is at v1.24.0 with a real amendment history back to v1.15.x, not a static file written once. |
| Specify a feature | `specjedi-specify` | Turns a feature idea (a rough one-sentence description is enough) into a prioritized, independently-testable `spec.md`, marking genuine ambiguity with an explicit marker instead of silently guessing. |
| Clarify ambiguity | `specjedi-clarify` | Scans a spec for real ambiguity and asks up to 5 prioritized questions, each with a Recommended answer, before anything gets planned against an unresolved guess. |
| Plan the technical approach | `specjedi-plan` | Scans the actual target codebase for existing conventions *before* writing the plan, so implementation never has to stop mid-build to search for a pattern that already exists elsewhere in the project. |
| Break down into tasks | `specjedi-tasks` | Turns a plan into an ordered, dependency-aware `tasks.md`, sequencing a failing test before its implementation task wherever the plan calls for code. |
| Implement | `specjedi-implement` (full path) or `specjedi-quick` (small, well-understood changes) | Executes the task breakdown in dependency order, test-first where code is involved — commits only through a feature branch and pull request, never directly to the trunk. `specjedi-quick` (feature 028) is the lightweight variant: one combined artifact instead of four separate files, for changes that genuinely fit on about one page of notes — quality gates never shorten, only planning ceremony does. |
| Verify the finished work | `specjedi-analyze` | Strictly read-only cross-check of spec/plan/tasks (and the constitution) for gaps, duplication, and contradictions — reports findings, never edits a file itself. |
| Catch drift after manual changes | `specjedi-converge` | Scans the actual codebase for capability with no corresponding task, appending it as new work instead of letting it silently drift out of sync with the task breakdown. |
| Governance compliance before shipping | `specjedi-govcheck` | Strictly read-only per-PR check against all 20 constitution principles, self-invoked before `specjedi-implement`/`specjedi-quick` open a pull request. |

## Genuine contributions beyond generic SDD practice

Spec Jedi doesn't just implement the general practice above — it adds
capabilities no generic description of SDD requires. Three, cited
directly from this project's own verified self-assessment
([`references/honest-assessment.md`](honest-assessment.md)):

1. **Diagrams get render-verified before they're shown to you.**
   `specjedi-diagram` runs generated Mermaid source through a live
   render-check and revises on failure, rather than presenting a diagram
   that might not actually display correctly. Generic SDD practice has
   no equivalent requirement.
2. **A per-PR governance compliance check against every rule in the
   project's own constitution**, not just a code-quality lint —
   `specjedi-govcheck`'s three-state (Not Applicable / Compliant /
   Non-Compliant) report, automatically run before a pull request opens.
3. **A project-status dashboard with zero separately-maintained tracking
   system.** `specjedi-status` derives every feature's status entirely
   from what's actually on disk (a `spec.md`+`plan.md`+`tasks.md` set,
   or a `quick.md` for the lightweight path) — nothing to forget to
   update by hand, and nothing that can drift out of sync with reality
   the way a manually-maintained status board can.

For the full, unfiltered picture — including where Spec Jedi's
implementation of SDD currently falls short — see
[`references/honest-assessment.md`](honest-assessment.md) directly.

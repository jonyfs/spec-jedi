# Implementation Plan: specjedi-plan Auto-Invokes specjedi-clarify on NEEDS CLARIFICATION

**Branch**: `059-plan-auto-clarify` | **Date**: 2026-07-19 | **Spec**: `specs/059-plan-auto-clarify/spec.md`

**Input**: Feature specification from `specs/059-plan-auto-clarify/spec.md`

## Summary

`specjedi-plan` Step 1 currently *recommends* running `specjedi-clarify`
when the target `spec.md` still has `NEEDS CLARIFICATION` markers, requiring
the user to type a second command. This feature rewrites Step 1 to invoke
`specjedi-clarify` automatically instead — mirroring the proactive
self-invocation pattern `specjedi-clarify`'s own description already
documents for its trigger straight out of `specjedi-specify` — then
re-checks `spec.md` once `specjedi-clarify` finishes: zero remaining
markers resumes planning in the same run; any surviving marker stops the
run with the specific remaining question named, never a silent proceed or
an automatic second `specjedi-clarify` invocation. The change is confined
to `.claude/skills/specjedi-plan/SKILL.md`'s own instruction text — no
new script, hook, or CI job.

## Technical Context

**Language/Version**: Markdown (`SKILL.md` instruction file) — matches
every other `specjedi-*` skill in `.claude/skills/`; no code language
applies.

**Primary Dependencies**: None new. Depends on `specjedi-clarify` already
existing and already supporting proactive self-invocation (confirmed:
its own `description` frontmatter field already states "or proactively
right after specjedi-specify finishes a spec with open markers" —
`.claude/skills/specjedi-clarify/SKILL.md:3`).

**Storage**: N/A — no persisted state beyond the existing `spec.md`
`NEEDS CLARIFICATION` markers `specjedi-clarify` already reads/writes.

**Testing**: No automated test framework applies — this is a prose
instruction-file edit, not compiled/interpreted code (see Constitution
Check, Principle VI, below for the explicit reason this is not a gap).
Validation instead uses Principle IX's existing structural-lint coverage
(frontmatter/name-match CI checks already exercise every `specjedi-*`
`SKILL.md`, confirmed working this session against `specjedi-caveman-mode`)
plus a documented scenario-based dry run (Project Structure below) walking
each of `spec.md`'s three acceptance-scenario families by hand.

**Target Platform**: Cross-harness by construction — plain Markdown
instructions, no proprietary tool schema, no OS-specific script (Principle
III/XIII don't trigger; no `.sh`/`.ps1` is being added).

**Project Type**: Single skill-instruction-file edit within the existing
`specjedi-*` skill collection.

**Performance Goals**: N/A — no runtime performance dimension; the
"performance" this feature improves is removing one manual user-typed
command from the pipeline (SC-001 in spec.md).

**Constraints**: `specjedi-plan`'s existing `SKILL.md` MUST stay within
Principle XIX's progressive-disclosure token ceiling (target <500 tokens,
MUST NOT exceed ~5,000) after this edit — checked directly (Project
Structure below) rather than assumed.

**Scale/Scope**: One file, three edit sites within it (Step 1, Always/
Never section, Validation Coverage's Out-of-Bounds Handling bullet) — no
other file in the repository references the current "stop and recommend"
wording (verified via `grep -rl "stop and recommend.*specjedi-clarify"`
across the repo, one match: `specjedi-plan/SKILL.md` itself).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I. English-Source Docs | `spec.md`/`plan.md`/the `SKILL.md` edit are all English; not in the localized top-level-doc set | ✅ Compliant |
| II. Competitive Research Before Creation | This is not a new skill/workflow/structural pattern — it applies `specjedi-clarify`'s own already-documented, already-shipped proactive self-invocation convention (Principle XVII) to one more integration point already used elsewhere in this project | ✅ N/A (extends existing shipped pattern, not new state-of-the-art territory) |
| III. Universal LLM & Harness Compatibility | Plain Markdown instructions, no proprietary schema, no new harness-specific mechanism | ✅ Compliant |
| IV. Structured, Opinionated Elicitation | Reinforces this principle — clarification questions can no longer be silently skipped by a user ignoring a "recommend" line; the actual elicitation (specjedi-clarify's own questions) is unchanged | ✅ Compliant |
| V. Specification Completeness | This feature's own `spec.md` has zero `NEEDS CLARIFICATION` markers | ✅ Compliant |
| VI. Test-First Delivery, AI-First Posture | No code artifact is produced — this is a documentation/instruction-only change to `SKILL.md` prose. Explicit reason (as VI requires when TDD doesn't apply): there is no compiled/interpreted logic to write a failing test against; validation instead runs through Principle IX's structural lint (already-passing CI) plus the scenario-based dry run in Project Structure below | ✅ Compliant (explicit reason stated, not a gap) |
| VII. Full-Stack Technical Depth | Not stack-specific guidance | ✅ N/A |
| VIII. Token-Economy Tooling Integration | Unrelated to rtk/graphify configuration | ✅ N/A |
| IX. Mandatory Skill Validation & Testing (NON-NEGOTIABLE) | (a) structural lint: existing CI already validates every `SKILL.md`'s frontmatter/name-match (confirmed working this session); (b) scenario-based dry run: the three acceptance-scenario families from spec.md are walked by hand and recorded (Project Structure); (c) no code artifact, so no execution-harness test applies | ✅ Compliant |
| X. Trunk-Based Git Workflow | Feature branch `059-plan-auto-clarify` created off `main`; will open a PR, not commit direct-to-main | ✅ Compliant (to be executed) |
| XI. Semantic-Versioned Releases | Not evaluated at plan time — eventual release classification (likely MINOR: backward-compatible capability addition) is a release-time concern, not a planning gate | ✅ N/A at this stage |
| XII. Star Wars-Flavored Voice | `plan.md`/`spec.md` content stays plain per the Audience Calibration Boundary both skills already document; narration around them (chat) already follows this project's established voice | ✅ Compliant |
| XIII. Cross-Platform Support | No `.sh`/`.ps1` script is being added — pure instruction-text edit | ✅ N/A |
| XIV. Guided Next-Step Suggestion | `specjedi-plan`'s own existing Step 6 next-step convention is unchanged by this edit | ✅ Compliant |
| XV. `specjedi-` Naming Convention | Modifying an existing, already-correctly-named `specjedi-plan` skill; no renaming involved | ✅ Compliant |
| XVI. Efficient Documentation & Mermaid Literacy | The behavior change is a short, linear control-flow addition (invoke → recheck → proceed-or-stop) — prose plus a short before/after excerpt conveys this more directly than a diagram would for a 3-step sequence | ✅ Compliant (diagram evaluated and correctly not used) |
| XVII. Skill Discovery & Gap-Filling | No domain gap — this is squarely within the installed `specjedi-*` skill set's existing competence | ✅ N/A trigger (no gap to fill) |
| XVIII. Zero-Footprint Installer | Installer untouched | ✅ N/A |
| XIX. Skill Authoring & Prompt Engineering Standard | The edited Step 1 and Always/Never bullets MUST keep the existing prohibition-paired-with-alternative structure (e.g., "Never proceed... — [alternative]") and stay quantifiable (bounded to one auto-invocation, not vague "handle it appropriately") | ✅ Compliant (enforced in Project Structure's exact edit text below) |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Both `specjedi-plan/SKILL.md` and `specjedi-clarify/SKILL.md` were read in full this session before drafting; the self-invocation precedent cited above is an actual grep/read confirmation, not an assumption | ✅ Compliant |
| XXI. Session-Start Orientation | `scripts/session-start.sh` untouched | ✅ N/A |
| XXII. Skill Freshness Validation | Bootstrap/version-marker logic untouched | ✅ N/A |

No Complexity Tracking entries — no gate was violated; Principle VI's
"explicit reason" branch is a compliant path the principle itself defines,
not a justified violation.

## Project Structure

### Documentation (this feature)

```text
specs/059-plan-auto-clarify/
├── plan.md              # This file
└── spec.md              # Already written (previous turn)
```

No `research.md`/`data-model.md`/`quickstart.md`/`contracts/` — this
feature has no external unknowns needing research (the one dependency,
`specjedi-clarify`'s self-invocation precedent, was confirmed by direct
file read above) and no data model (no new entity beyond the existing
`NEEDS CLARIFICATION` marker convention already documented in spec.md's
Key Entities).

### Source Code (repository root)

```text
.claude/skills/specjedi-plan/SKILL.md   — MODIFIED (only file touched)
```

**Exact edit sites within `specjedi-plan/SKILL.md`**:

1. **Step 1** (currently lines 58-60) — replace the "stop and recommend"
   text with automatic invocation, the FR-003/FR-004/FR-005/FR-006-bounded
   recheck, and FR-007's plan-level-marker scope boundary:

   ```markdown
   1. **Confirm the spec is actually clarified.** If `NEEDS CLARIFICATION`
      markers remain in `spec.md` at the start of this run, invoke
      `specjedi-clarify` automatically — no separate "may I run it?"
      prompt, matching `specjedi-clarify`'s own documented proactive
      self-invocation precedent from `specjedi-specify`. Once
      `specjedi-clarify` finishes, re-check `spec.md`: zero remaining
      markers resumes planning in this same run (Technical Context next);
      any marker still present stops this run without writing `plan.md`,
      naming the specific unresolved question(s) — `specjedi-clarify` is
      invoked at most once per `specjedi-plan` run, never looped
      automatically. This check is scoped to markers already in `spec.md`
      at the start of the run — a `NEEDS CLARIFICATION` marker Step 3
      itself later writes into `plan.md`'s own Technical Context is a
      plan-level technical gap, not a spec-level requirement ambiguity,
      and does not trigger `specjedi-clarify` (out of that skill's
      documented scope).
   ```

2. **Always/Never section** (currently lines 216-217) — replace:

   ```markdown
   - **Never** proceed to plan a spec that still has unresolved
     `NEEDS CLARIFICATION` markers — recommend `specjedi-clarify` instead.
   ```

   with:

   ```markdown
   - **Always** invoke `specjedi-clarify` automatically (never just
     recommend it) when `spec.md` has `NEEDS CLARIFICATION` markers at
     the start of a run, then re-check before proceeding.
   - **Never** invoke `specjedi-clarify` more than once per
     `specjedi-plan` run — if markers survive one auto-invocation, stop
     and report them by name instead of looping.
   - **Never** route a `NEEDS CLARIFICATION` marker Step 3 itself writes
     into `plan.md`'s Technical Context to `specjedi-clarify` — that
     skill's scope is `spec.md`'s requirements, not `plan.md`'s technical
     fields.
   ```

3. **Validation Coverage → Out-of-Bounds/Malformed Input Handling**
   (currently lines 249-253) — update the stale description of Step 1's
   old behavior:

   ```markdown
   - **Out-of-Bounds / Malformed Input Handling**: Applicable — cross-
     referenced by Step 1's own documented case: a `spec.md` still
     carrying `NEEDS CLARIFICATION` markers triggers an automatic
     `specjedi-clarify` invocation (bounded to once per run) rather than
     planning against unresolved ambiguity; markers surviving that one
     invocation stop the run with the specific remaining question named,
     never a silent proceed.
   ```

### Scenario-based dry run (Principle IX battery item (b))

Walked by hand against the rewritten Step 1 text above, matching
spec.md's three acceptance-scenario families:

1. **Story 1, Scenario 1** (2 markers present) → rewritten Step 1 invokes
   `specjedi-clarify` before Technical Context — confirmed by the "invoke
   `specjedi-clarify` automatically... Technical Context next" text.
2. **Story 1, Scenario 2** (0 markers present) → rewritten Step 1's "If
   `NEEDS CLARIFICATION` markers remain... at the start of this run"
   guard is false, so the auto-invocation branch never fires — matches
   today's unchanged behavior for a clean spec.
3. **Story 2, Scenario 1** (marker survives one clarify pass) →
   rewritten text's "any marker still present stops this run... naming
   the specific unresolved question(s)... invoked at most once" directly
   implements the bounded-stop requirement.
4. **Story 3, Scenario 1** (Step 3's own Technical Context marker) →
   rewritten Step 1 text's final sentence explicitly excludes this case
   ("a marker Step 3 itself later writes... does not trigger
   `specjedi-clarify`").

### Token-budget check (Principle XIX, Constraints above)

Current `specjedi-plan/SKILL.md`: 261 lines / ~2,000 words (`wc -w`
already run this session: 803 words for the smaller `specjedi-caveman-
mode/SKILL.md` file at 93 lines, so `specjedi-plan` at 261 lines is
proportionally larger but the edit below is a same-length swap — Step 1
grows by roughly 6 lines, Always/Never grows by 2 net bullets, Out-of-
Bounds bullet is a like-for-like rewrite). Net addition is small (under
15 lines) and stays well inside the existing file's already-established,
already-passing size — no `references/` split needed.

### Spec/plan size-outlier check (specs/045, Step 5.5)

`spec.md`: 179 lines. `plan.md` (this file): under 250 lines. Both are
consistent with this project's typical single-skill-behavior-change specs
(comparable to e.g. `specs/013-specjedi-govcheck`, `specs/051-interactive-
next-steps` in scope) — neither is a size outlier warranting a flag.

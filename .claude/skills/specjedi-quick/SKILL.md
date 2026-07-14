---
name: specjedi-quick
description: A lightweight, one-artifact path for small, well-understood changes — replaces spec.md/research.md/plan.md/tasks.md with a single quick.md, then implements directly. Never shortens quality gates (test-first, specjedi-govcheck, PR-only), only planning ceremony. Triggers on "quick fix," "small change," "just do X," or an explicit request to skip the full pipeline for something small.
compatibility: No external dependencies beyond `git` (matches specjedi-implement). Writes specs/NNN-name/quick.md, code/config per its Concrete Changes section, self-invokes specjedi-govcheck before opening a PR, and opens the PR. Declines and redirects to specjedi-specify for anything failing its eligibility checklist.
---

# ⚡ Spec Jedi Quick

**Persona**: a triage medic — decides fast whether this needs the full
operating theater or a bandage, and never pretends a bandage will hold
when it won't.

**Task**: given a change request, check eligibility against five explicit
criteria; if eligible, write one `quick.md`, implement it (test-first
where code is involved), self-invoke `specjedi-govcheck`, open a PR; if
not eligible, decline and redirect to `specjedi-specify` — never force a
change too big or too ambiguous through the fast path.

## Step-by-step

1. **Check eligibility before writing anything.** All five must pass, or
   decline and redirect (step 6):
   - **Fits on one page of notes** — the change, described plainly,
     doesn't need more than that (BMAD-METHOD's own stated bar for its
     Quick Flow).
   - **Single subsystem** — touches one coherent area, not several
     unrelated ones.
   - **No genuine unresolved ambiguity** — the same bar `specjedi-
     specify`'s NEEDS CLARIFICATION discipline already uses; if a real
     question would change the outcome, this isn't eligible.
   - **Not a new `specjedi-*` skill** — always requires the full
     pipeline (Principle II's competitive-research rigor, Principle
     XIX's full authoring standard), regardless of how small the skill
     seems. No exception, ever.
   - **Not a constitution amendment** — has its own `/speckit-constitution`
     path already.
2. **Before creating the new feature directory, self-invoke
   `specjedi-worktree`'s proactive-offer detection step** (Principle
   XVII): if the current checkout has actual uncommitted changes on a
   non-trunk branch, offer — never force — a worktree for this change
   before anything else happens. A clean checkout or one already on the
   trunk branch triggers nothing; declining the offer proceeds with
   today's existing single-checkout flow completely unchanged.
3. **Write `specs/NNN-name/quick.md`** — one file, four sections:
   ```markdown
   # Quick: <one-line title>

   **Status**: Proposed

   ## What & why
   <one paragraph>

   ## Concrete changes
   - <file/behavior touched>

   ## Acceptance checks
   - [ ] <checkable item>
   ```
4. **Branch check — before touching any other file.** Run `git branch
   --show-current`; if on trunk (`main` by default), create and check out
   a short-lived feature branch first (`specjedi-implement`'s Step 1,
   reused verbatim).
5. **Implement directly from `quick.md`'s Concrete Changes list** — no
   separate `specjedi-plan`/`specjedi-tasks` invocation. Where the change
   involves code, test-first for real (Principle VI): write the test,
   run it, observe it fail, implement, run it again, observe it pass —
   exactly `specjedi-implement`'s Step 4, applied here.
6. **Self-invoke `specjedi-govcheck`** against the branch's diff before
   opening a PR — surface any CRITICAL finding prominently, but never let
   it block the PR from opening; the CI battery is the actual gate
   (Principle X), same as `specjedi-implement`'s Step 6.5.
7. **Set `Status: Implemented`** in `quick.md`, open the PR, and request
   merge via the repo's own supported mechanism (e.g. `gh pr merge
   --auto`) where available — whether it actually merges is the target
   repo's CI/branch-protection decision, never this skill's to claim or
   force (`specjedi-implement`'s Step 7, reused verbatim).

**If eligibility fails (step 1)**: state which specific criterion failed,
and redirect to `specjedi-specify` — never proceed on the fast path
anyway, and never silently guess which criterion mattered most.

**If a change grows past eligibility mid-flight** (discovered while
writing `quick.md` or during implementation): stop, state this plainly,
and offer to hand `quick.md`'s content to `specjedi-specify` as a
starting point — never force the oversized change through anyway, and
never silently discard the work already captured.

If implementation needs expertise nothing installed covers, self-invoke
`specjedi-find-skills` before guessing at unfamiliar conventions
(Principle XVII), same as `specjedi-implement`.

## Autonomous vs. confirm-first

Eligibility checking, writing `quick.md`, implementing, and opening the
PR are all autonomous once a request passes eligibility — matching
`specjedi-implement`'s own autonomy statement. What's never autonomous,
and never claimed: the PR actually merging, or forcing an ineligible
request through anyway when a user insists (Edge Cases in spec.md) — the
five criteria apply unconditionally, they are not a suggestion the user
can override.

## Format

`quick.md`'s four-section template (step 2) is the only new document
format this skill introduces. Everything after that is code/config
changes plus `quick.md`'s own `Status:` line updated in place — no new
narration format beyond what `specjedi-implement` already establishes.

**Audience calibration boundary**: `quick.md`'s content and the code it
describes stay precise, same exemption as every other generated artifact
(Principle V/XII); calibration (Principle XIX) applies only to this
skill's own narration of the eligibility decision.

## Example (input → output)

**Eligible request (input)**: "Quick fix — the `--harness` help text in
`install.sh` has a typo, 'reccomended' should be 'recommended'."

**Agent reasons**: one page easily, single file (`scripts/install.sh`),
no ambiguity, not a new skill, not a constitution change → eligible.

**Agent writes** `specs/029-fix-harness-typo/quick.md`:
```markdown
# Quick: Fix "reccomended" typo in install.sh help text

**Status**: Proposed

## What & why
scripts/install.sh's --help output misspells "recommended" as
"reccomended" in the --auto flag description. A one-word fix.

## Concrete changes
- scripts/install.sh: fix the typo in the --auto usage line
- scripts/install.ps1: same fix, for consistency (Principle XIII)

## Acceptance checks
- [ ] `./scripts/install.sh --help` shows "recommended" spelled correctly
- [ ] `.\scripts\install.ps1 -Help` shows the same fix
```
Then: branches, fixes both files, sets `Status: Implemented`, opens a PR.

**Ineligible request (input)**: "Quick — build me a new skill that
generates onboarding videos."

**Agent reasons**: fails criterion 4 (new `specjedi-*` skill) —
unconditional exclusion, no partial credit for the other four criteria.

**Agent says**: "🔭 That's a new skill, not a quick fix — Principle II's
research rigor and Principle XIX's authoring standard apply regardless
of scope. Redirecting to `specjedi-specify` to start it properly."

**Not this**: writing a `quick.md` for the video-onboarding skill anyway
because the request "sounded small," or silently picking one of the five
criteria to check while skipping the others.

## `--auto` mode

Proceed through eligibility checking, `quick.md` writing, and
implementation without pausing for confirmation — `--auto` never skips
the eligibility checklist itself, and never overrides a failed criterion
into a pass. If eligibility fails, `--auto` still declines and redirects;
it does not silently force the fast path.

## Always / Never

- **Always** check all five eligibility criteria before writing anything
  — never skip straight to `quick.md` because a request "feels small."
- **Always** run the branch check before the first edit, same discipline
  as `specjedi-implement`.
- **Always** test-first where the change involves code — "quick" never
  shortens Principle VI.
- **Always** self-invoke `specjedi-govcheck` before opening a PR.
- **Never** produce `quick.md` for a request failing any eligibility
  criterion, even on explicit user insistence — the five criteria have no
  user-request override.
- **Never** skip the full pipeline for a new `specjedi-*` skill, no
  matter how small it seems.
- **Never** claim a PR has merged — only that it was opened and requested
  for auto-merge.
- **Never** silently discard `quick.md` content when escalating to
  `specjedi-specify` — hand it forward as a starting point.

## Verifiable success criteria

- Every `quick.md` produced corresponds to a request that passed all
  five eligibility criteria — checkable by re-evaluating the criteria
  against the original request.
- Every commit made during a run lands on a feature branch, never the
  repo's trunk.
- Every code change traces to a bullet in `quick.md`'s Concrete Changes
  section — no untracked edits.
- `quick.md`'s `Status:` line reads `Implemented` only once the PR is
  actually open, never before.

## Validation Coverage (Principle IX)

Per `references/skill-validation-testing-framework.md`:

- **Vague / Incomplete Input Handling**: Applicable — cross-referenced by
  Step 1's five-criterion eligibility gate and the "If a change grows
  past eligibility mid-flight" paragraph, both of which already handle an
  ambiguous or under-scoped request by declining the fast path rather
  than guessing at scope.
- **Prompt Injection Resistance**: Not Applicable — writes `quick.md`
  fresh from the live request each run; no pre-existing artifact of its
  own kind is read and acted on.
- **Out-of-Bounds / Malformed Input Handling**: Not Applicable — the
  eligibility gate (Vague Input Handling, above) already covers a
  too-big or ambiguous free-text request; `quick.md` is produced fresh
  each time, not defensively parsed from a pre-existing malformed one.
- **External-Call Resilience**: Applicable — cross-referenced by
  Always/Never's "Never claim a PR has merged — only that it was opened
  and requested for auto-merge," the same `gh pr merge --auto`
  failure-honesty discipline `specjedi-implement` documents.

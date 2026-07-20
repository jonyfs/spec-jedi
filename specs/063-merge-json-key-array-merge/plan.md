# Implementation Plan: merge_json_key() Merges Into an Existing Array-Shaped Key

**Branch**: `063-merge-json-key-array-merge` | **Date**: 2026-07-20 | **Spec**: `specs/063-merge-json-key-array-merge/spec.md`

**Input**: Feature specification from `specs/063-merge-json-key-array-merge/spec.md`

## Summary

`merge_json_key()` (`scripts/install.sh`) and `Merge-JsonKey`
(`scripts/install.ps1`) — the shared, generic top-level-key merger used
by five different call sites across five harnesses — only detect
whether the target already contains the key *name* as a raw-text
substring; if so, they print "already has this key — leaving as-is" and
never look at the key's actual *value*, even when that value is an array
missing exactly the entries the installer would have added. This is the
same class of gap specs/061 already fixed for `PreToolUse` specifically.
This feature adds array-detection to `merge_json_key()`/`Merge-JsonKey`:
when the existing key's value is an array and the new block's own
top-level value is also an array, merge the missing items in
(content-deduplicated, same technique specs/061 already proved) instead
of silently no-op'ing. The four object-shaped call sites (gemini-cli/
antigravity `"hooks"`, opencode `"permission"`, zed `"agent"`) keep
today's exact conservative behavior — this feature does not attempt an
ungrounded object merge.

## Technical Context

**Language/Version**: Bash + Python 3 (subprocess, matching
`merge_pretooluse_hooks()`'s own existing pattern) for `install.sh`;
native PowerShell `ConvertFrom-Json`/`ConvertTo-Json` for `install.ps1` —
identical language/tooling choice to specs/061, same file.

**Primary Dependencies**: None new. Reuses `has_python3()`/
`Test-Python3Available` — wait, this is a real design question specs/061
resolved for `PreToolUse` specifically: `install.sh`'s merge needed a
python3 gate because it's the only way to safely parse JSON in bash;
`install.ps1`'s merge needed no gate (native cmdlets always available).
The identical gating applies here — `merge_json_key()`'s new array-merge
branch on the bash side MUST also gate on `has_python3()`, falling back
to today's exact existing message when unavailable (matching FR-004's
"fail explicit/fall back" discipline, extended from specs/061's own
FR-005 precedent for the no-python3 case specifically).

**Storage**: The five real target files `merge_json_key()`/
`Merge-JsonKey` already write to (`.claude/settings.json` for `"Stop"`,
plus the four object-shaped targets which stay read-only under this
feature) — this feature adds conditional write capability only for the
array-shaped case.

**Testing**: Extends the `install-test-shared-hooks-merge`/
`install-test-shared-hooks-merge-windows-native` CI job pair specs/061
already created (`.github/workflows/validate.yml`) with new scenarios
for the `"Stop"`-key array-merge case — same job, new steps, matching
that job's own established pattern exactly. Principle VI applies in
full (real executable logic), same as specs/061.

**Target Platform**: Linux/macOS/Windows — matching the existing
`install-test-shared-hooks-merge` job family's 3-OS matrix.

**Project Type**: Installer script modification plus CI test extension —
no `specjedi-*` skill file touched.

**Performance Goals**: N/A — one-time, local file parse/merge/write per
install run.

**Constraints**:

- FR-002 requires reusing the *proven technique* specs/061 already
  shipped (parse via `json.load`/`ConvertFrom-Json`, content-dedup via
  JSON-string comparison, write via `json.dump`/`ConvertTo-Json`) — not
  literally the same function call, since `merge_pretooluse_hooks()`'s
  own logic is hardcoded to the `data["hooks"]["PreToolUse"]` path and
  matcher-group sub-structure, which doesn't generalize directly to an
  arbitrary top-level key like `"Stop"`. This plan extracts the shared
  *parse → detect-array → dedup-merge → write* shape into
  `merge_json_key()`'s own new branch, applying the identical technique
  honestly, not claiming a literal shared function where the path
  structure genuinely differs. Verified this session (specs/061) that
  the `@()`-wrapping discipline avoids PowerShell's single-element-array
  `ConvertTo-Json` collapse — the same discipline applies here.
- The array-shaped-vs-not detection (FR-001) MUST happen via real JSON
  parsing (`type(value) is list` / PowerShell array-type check), never a
  text-pattern guess — a `"Stop": "not-an-array-string"` edge case (even
  if unrealistic given today's five callers) must not be misdetected.
- Object-shaped call sites (Story 2) MUST see zero behavior change —
  verified by re-running the existing (unmodified) scenarios for those
  four keys.

**Scale/Scope**: Two source files modified (`scripts/install.sh`,
`scripts/install.ps1`), one CI workflow file modified
(`.github/workflows/validate.yml`, new steps in the existing
`install-test-shared-hooks-merge`/`-windows-native` jobs — no new job
needed, since these jobs already exist and already cover this exact
class of scenario).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I. English-Source Docs | All English | ✅ Compliant |
| II. Competitive Research Before Creation | Extends an existing, already-shipped installer mechanism (`merge_json_key()`) with a technique already proven this session (specs/061) — not new SDD-domain territory | ✅ N/A (extends existing shipped pattern) |
| III. Universal LLM & Harness Compatibility | Installer script logic, not skill/harness-specific content | ✅ N/A |
| IV. Structured, Opinionated Elicitation | No elicitation involved | ✅ N/A |
| V. Specification Completeness | `spec.md` has zero `NEEDS CLARIFICATION` markers | ✅ Compliant |
| VI. Test-First Delivery, AI-First Posture | Real executable logic (bash/python3/PowerShell) — new CI test steps MUST be written first, observed failing against today's code, then made to pass | ✅ Compliant (test-first required, matching specs/061) |
| VII. Full-Stack Technical Depth | Not stack-specific | ✅ N/A |
| VIII. Token-Economy Tooling Integration | Unrelated to rtk/graphify | ✅ N/A |
| IX. Mandatory Skill Validation & Testing (NON-NEGOTIABLE) | Not a `specjedi-*` skill — governed by the existing `install-test-shared-hooks-merge` CI battery this feature extends | ✅ Compliant |
| X. Trunk-Based Git Workflow | Feature branch `063-merge-json-key-array-merge` created off `main`; will PR | ✅ Compliant (to be executed) |
| XI. Semantic-Versioned Releases | Not evaluated at plan time | ✅ N/A at this stage |
| XII. Star Wars-Flavored Voice | `spec.md`/`plan.md` stay plain per documented calibration boundary | ✅ Compliant |
| XIII. Cross-Platform Support | Both `install.sh` (python3-gated) and `install.ps1` (native, unconditional) get equivalent treatment — same design as specs/061 | ✅ Compliant |
| XIV. Guided Next-Step Suggestion | Existing convention unaffected | ✅ Compliant |
| XV. `specjedi-` Naming Convention | No skill file touched | ✅ N/A |
| XVI. Efficient Documentation & Mermaid Literacy | The array-vs-object detection is a single boolean branch, clearly expressible in prose — diagram evaluated, not needed | ✅ Compliant (diagram evaluated, not needed) |
| XVII. Skill Discovery & Gap-Filling | No domain gap | ✅ N/A trigger (no gap) |
| XVIII. Zero-Footprint Installer with Harness Selection | Directly reinforces — closes a second instance of the same "installer refuses to merge into existing content" gap specs/061 already started closing | ✅ Compliant (reinforces directly) |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A — no `specjedi-*` `SKILL.md` touched | ✅ N/A |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Every FR traces to a direct code read (`install.sh`/`.ps1` line numbers, confirmed 5 real call sites via `grep`) — the object-shaped-call-sites-out-of-scope decision is itself grounded in reading each of the 4 other blocks' actual JSON shape, not assumed | ✅ Compliant |
| XXI. Session-Start Orientation | Untouched | ✅ N/A |
| XXII. Skill Freshness Validation | Untouched | ✅ N/A |

No Complexity Tracking entries — no gate was violated.

## Project Structure

### Documentation (this feature)

```text
specs/063-merge-json-key-array-merge/
├── plan.md              # This file
└── spec.md              # Already written (previous turn)
```

No `research.md`/`data-model.md`/`quickstart.md`/`contracts/` — the one
real design question (how to reuse specs/061's technique without a
literal shared function across genuinely different path structures) was
resolved directly in this plan's Constraints above.

### Source Code (repository root)

```text
scripts/install.sh                    — MODIFIED
scripts/install.ps1                   — MODIFIED
.github/workflows/validate.yml        — MODIFIED (new steps in existing jobs, no new job)
```

**`scripts/install.sh` changes** (inside `merge_json_key()`, extending
the existing `case "$content" in *"$key_check"*) ... esac` branch at
today's lines 1063-1066):

- Before printing "already has this key," attempt to determine the
  existing key's value type: invoke `python3` (gated on `has_python3`,
  matching specs/061's own FR-005 fallback discipline) with an inline
  script that `json.load()`s the target, checks whether
  `data.get(key_name)` (the key name stripped of its surrounding `"..."`
  quoting already passed in as `key_check`) is a `list`, and whether the
  new `$block`'s own parsed top-level value is also a `list`.
  - Both arrays: merge the new block's items into the existing array
    (content-dedup via JSON-string comparison, matching
    `merge_pretooluse_hooks()`'s own proven approach), write back with
    `json.dump(..., indent=2)`.
  - Not both arrays (existing is an object, or shapes mismatch): fall
    through to today's exact existing "already has this key — leaving
    as-is" message, unchanged.
  - No python3: fall through to the same existing message, unchanged
    (FR-004's fallback case).
  - Malformed existing JSON: fail explicitly, non-zero exit, clear
    message (FR-004).

**`scripts/install.ps1` changes** (inside `Merge-JsonKey`, extending the
existing key-already-present branch at today's lines 827+): identical
logic using `ConvertFrom-Json`/`ConvertTo-Json`, array-type-checked via
PowerShell's own `-is [array]`/`Get-Member` idiom, same `@()`-wrapping
discipline specs/061 already validated for the single-element-array
case, no python3 gate needed (native cmdlets always available, matching
specs/061's own `Merge-PreToolUseHooks` precedent).

**`.github/workflows/validate.yml` changes**: new steps added to the
*existing* `install-test-shared-hooks-merge` and
`install-test-shared-hooks-merge-windows-native` jobs (specs/061) — no
new job needed, this is the same class of scenario that job family
already exists to cover:

- Bash job: a new step seeding a target `.claude/settings.json` with an
  existing `"Stop"` array containing one pre-existing custom hook,
  running the installer, asserting the shareable notification hook
  merged in and the pre-existing hook survived (US1); a second step
  confirming one of the four object-shaped call sites (e.g. opencode's
  `"permission"`) still produces today's exact unchanged message (US2,
  regression guard).
- Windows-native job: the equivalent two steps against `install.ps1`.

### Scenario-based dry run (Principle IX battery item (b))

1. **Story 1, Scenario 1** (existing `"Stop"` array, missing hook) → new
   `merge_json_key()` branch detects both-arrays, merges, pre-existing
   entry survives.
2. **Story 1, Scenario 2** (re-run) → content-dedup prevents duplicate,
   matching `merge_pretooluse_hooks()`'s own already-proven idempotency.
3. **Story 2, Scenario 1** (existing `"permission"` object) → shape
   mismatch (object, not array) falls through to today's unchanged
   message.

### Spec/plan size-outlier check (specs/045, Step 5.5)

`spec.md`: 199 lines. `plan.md` (this file): under 180 lines. Both
comparable to this session's other single-surface specs (specs/061:
286/232) — neither is a size outlier.

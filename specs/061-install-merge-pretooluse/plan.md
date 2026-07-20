# Implementation Plan: install.sh/.ps1 Merge Shareable Hooks Into an Existing PreToolUse Array

**Branch**: `061-install-merge-pretooluse` | **Date**: 2026-07-20 | **Spec**: `specs/061-install-merge-pretooluse/spec.md`

**Input**: Feature specification from `specs/061-install-merge-pretooluse/spec.md`

## Summary

`install.sh`/`.ps1` today detects missing shareable hooks correctly but,
when the target `settings.json` already has a `hooks.PreToolUse` array
(from any source), refuses to touch it — printing an "add the following
manually" message (confirmed by direct read: `scripts/install.sh` lines
1263-1265, `scripts/install.ps1` lines 989-992). This feature replaces
that manual-instruction path (when python3/PowerShell's own JSON tooling
is available) with a real merge: parse the existing `settings.json`,
insert the missing hooks into the correct matcher group (`Bash` or
`Read|Grep|Glob`, creating the group if absent), and write the file back
— via `json.load`/`json.dump` on `install.sh` and
`ConvertFrom-Json`/`ConvertTo-Json` on `install.ps1` (spec.md
Clarifications: a deliberate, scoped exception to `Update-
SharedSettings`'s own broader anti-round-trip convention, justified
because Python 3.7+/PowerShell both preserve key order, so no content is
lost or reordered — only cosmetic re-indentation is possible). The
existing manual-instruction fallback is preserved, unchanged, for the
no-python3 case on `install.sh`.

## Technical Context

**Language/Version**: Bash (`scripts/install.sh`) + Python 3 (invoked as
a subprocess for the JSON merge, matching this file's own existing
python3-gated pattern for `prevent-direct-push.py`/`secret-scanner.py`,
`scripts/install.sh` lines 1200-1233); PowerShell (`scripts/install.ps1`)
using its own native `ConvertFrom-Json`/`ConvertTo-Json` cmdlets — no
python3 dependency on the Windows-native path.

**Primary Dependencies**: None new. Reuses `has_python3()`/
`Test-Python3Available` (existing, unchanged) as the gate for
`install.sh`'s python3-based merge; `install.ps1`'s merge needs no new
dependency since `ConvertFrom-Json`/`ConvertTo-Json` are built into every
supported PowerShell version this project already targets.

**Storage**: Target project's `.claude/settings.json` — read and
conditionally rewritten in place by this feature (new capability; today
it's only ever written when no `PreToolUse` array pre-exists).

**Testing**: Extends the existing `install-test-shared-hooks` CI job
family in `.github/workflows/validate.yml` (confirmed structure: fresh
`mktemp -d` target, run `./scripts/install.sh $dir --harness claude-code`,
assert file/`settings.json` content via `grep`/`test`/`diff` — lines
1244-1343). Every existing scenario in that job starts from a *fresh*
target with no pre-existing `settings.json`; this feature's scenarios are
the first to *pre-seed* a target's `settings.json` with an existing
`PreToolUse` array before running the installer — a genuinely new test
shape, following the same job's own established pattern
(`test -f`/`grep -q`/`diff`), added as new steps in a new dedicated job
pair (Project Structure below), test-first: written to fail against
today's code, then made to pass by the implementation (Constitution
Principle VI applies in full here — unlike this session's prior two
features, this one changes real executable logic, not prose).

**Target Platform**: Linux/macOS (bash + python3) and Windows (native
PowerShell) — matching this project's own existing 3-OS CI matrix for
the `install-test-shared-hooks` job family exactly.

**Project Type**: Installer script modification (`scripts/install.sh`/
`.ps1`) plus new CI test coverage — no `specjedi-*` skill file touched.

**Performance Goals**: N/A — one-time, local file parse/merge/write per
install run; no meaningful performance dimension.

**Constraints**:

- `install.sh`'s merge MUST be gated on `has_python3()` (FR-005) —
  the no-python3 fallback (today's exact manual-instruction message)
  MUST remain byte-for-byte the same as today's output.
- A malformed/unparseable target `PreToolUse` structure MUST fail loudly
  (FR-006) rather than attempt a guessed insertion — matching
  `merge_json_key()`'s own existing "refusing to guess" precedent
  (`scripts/install.sh` lines 1020-1023).
- The merge MUST NOT touch any other part of `settings.json` (FR-004) —
  other top-level keys and pre-existing hooks the installer didn't add
  must survive unchanged (content-wise; only whitespace/indent style is
  an accepted side effect per the Clarification).
- Scope: `.claude/settings.json`'s `hooks.PreToolUse` array only — the
  `.codex/hooks.json` case (`scripts/install.sh` lines 1843/1513 `.ps1`)
  is explicitly out of scope (FR-007), untouched by this feature.

**Scale/Scope**: Two source files modified (`scripts/install.sh`,
`scripts/install.ps1`), one CI workflow file modified
(`.github/workflows/validate.yml`, adding a new job pair plus two entries
to `ci-gate`'s own `needs` list, confirmed at line 2130).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I. English-Source Docs | `spec.md`/`plan.md` and all code comments English | ✅ Compliant |
| II. Competitive Research Before Creation | Modifies an existing installer mechanism (not a new skill/SDD-domain pattern); the mechanism choice itself (full parse+rewrite vs. surgical splice) was reasoned through and justified via `specjedi-clarify`'s own elicitation session — the equivalent "why this approach, not another" documentation this principle's spirit requires, even though it's installer plumbing, not an SDD-competitive design choice II's benchmark language targets | ✅ N/A (installer-internal mechanism, not new SDD-domain territory; alternative already reasoned through in Clarifications) |
| III. Universal LLM & Harness Compatibility | Installer script logic, not skill/harness-specific content | ✅ N/A |
| IV. Structured, Opinionated Elicitation | The FR-008 Clarification session is this principle applied directly — a genuine design tradeoff was surfaced and decided, not guessed | ✅ Compliant |
| V. Specification Completeness | `spec.md` has zero `NEEDS CLARIFICATION` markers (resolved via `specjedi-clarify`) | ✅ Compliant |
| VI. Test-First Delivery, AI-First Posture | Real executable logic changes (bash/python3/PowerShell) — new CI test steps in `install-test-shared-hooks`'s job family MUST be written first, observed failing against today's code, then made to pass by the implementation (Project Structure/tasks.md) | ✅ Compliant (test-first required, not exempted — first feature this session where VI applies in full) |
| VII. Full-Stack Technical Depth | Not stack-specific application guidance | ✅ N/A |
| VIII. Token-Economy Tooling Integration | Unrelated to rtk/graphify | ✅ N/A |
| IX. Mandatory Skill Validation & Testing (NON-NEGOTIABLE) | Not a `specjedi-*` skill file — governed instead by the existing `install-test-shared-hooks` CI battery this feature extends (same battery specs/058 itself established for this exact installer surface) | ✅ Compliant |
| X. Trunk-Based Git Workflow | Feature branch `061-install-merge-pretooluse` created off `main`; new CI job pair added to `ci-gate`'s `needs` list (line 2130) per Principle X's own "new battery jobs are added to that needs list as the project grows" requirement | ✅ Compliant (to be executed) |
| XI. Semantic-Versioned Releases | Not evaluated at plan time — release classification is a release-time concern | ✅ N/A at this stage |
| XII. Star Wars-Flavored Voice | `spec.md`/`plan.md` content stays plain per documented calibration boundary | ✅ Compliant |
| XIII. Cross-Platform Support | Both `install.sh` (python3-gated) AND `install.ps1` (native PowerShell JSON cmdlets, no python3 needed) get equivalent treatment — direct requirement of this feature's own design (FR-008), not an afterthought | ✅ Compliant |
| XIV. Guided Next-Step Suggestion | This skill's own existing next-step convention unaffected | ✅ Compliant |
| XV. `specjedi-` Naming Convention | No skill file touched — installer scripts aren't `specjedi-*`-named artifacts | ✅ N/A |
| XVI. Efficient Documentation & Mermaid Literacy | The merge decision (has matcher group? python3 available? malformed?) is a bounded 3-4-branch decision, clearly expressible as prose/pseudocode without a diagram — evaluated, prose chosen | ✅ Compliant (diagram evaluated, not needed) |
| XVII. Skill Discovery & Gap-Filling | No domain gap — installer maintenance within existing competence | ✅ N/A trigger (no gap) |
| XVIII. Zero-Footprint Installer with Harness Selection | This feature directly reinforces XVIII — the installer becomes correctly zero-footprint even for a target that already has some `PreToolUse` content, closing a real gap in that promise | ✅ Compliant (reinforces directly) |
| XIX. Skill Authoring & Prompt Engineering Standard | N/A — governs `specjedi-*` `SKILL.md` structure specifically; no such file touched here | ✅ N/A |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Every FR traces to a direct code read (`install.sh`/`.ps1` line numbers cited throughout spec.md/this plan) or the actual CI job structure read this session, never assumed | ✅ Compliant |
| XXI. Session-Start Orientation | `scripts/session-start.sh` untouched | ✅ N/A |
| XXII. Skill Freshness Validation | Bootstrap/version-marker logic untouched | ✅ N/A |

No Complexity Tracking entries — no gate was violated. Note: Principle
VI genuinely applies here (unlike this session's prior two prose-only
features) — this is flagged as a deliberate contrast, not an oversight.

## Project Structure

### Documentation (this feature)

```text
specs/061-install-merge-pretooluse/
├── plan.md              # This file
└── spec.md              # Already written, clarified (previous turns)
```

No `research.md`/`data-model.md`/`quickstart.md`/`contracts/` — the one
real unknown (FR-008's mechanism choice) was resolved via
`specjedi-clarify` directly in `spec.md`; no separate research artifact
needed.

### Source Code (repository root)

```text
scripts/install.sh                    — MODIFIED
scripts/install.ps1                   — MODIFIED
.github/workflows/validate.yml        — MODIFIED (new CI job pair + ci-gate needs entries)
```

**`scripts/install.sh` changes** (replacing the conservative bail-out at
lines 1263-1265, inside the existing `if [ -n "$missing_bash_hooks" ] ||
[ -n "$missing_read_hooks" ]; then` block's `PreToolUse`-already-exists
branch):

- New function `merge_pretooluse_hooks()`: given the target
  `settings.json` path, the matcher name (`Bash` or `Read|Grep|Glob`),
  and the list of missing hook filenames with their entry JSON (reusing
  the exact same per-file entry construction already used at lines
  1271-1294/1296-1309 for `bash_hook_entries`/`read_hook_entries`),
  invokes `python3` with an inline script (matching this file's existing
  style of small inline python3 invocations, e.g. the JSON-validity
  check pattern already used in `validate.yml` line 1264) that:
  1. `json.load()`s the target file (FR-006: on `JSONDecodeError`, print
     a clear failure naming the file and exit non-zero — never guess).
  2. Locates `data["hooks"]["PreToolUse"]`, searches for a group whose
     `"matcher"` equals the given matcher name.
  3. Found: appends the new hook entry dicts to that group's `"hooks"`
     list (FR-001/FR-003). Not found: appends a new
     `{"matcher": <name>, "hooks": [<entries>]}` group to the array
     (FR-002).
  4. `json.dump(data, f, indent=2)` writes the file back (FR-008).
- Call site: when `has_python3` is true, call
  `merge_pretooluse_hooks` once for `bash_hook_files`'s missing set
  (matcher `Bash`) and once for `read_hook_files`'s missing set (matcher
  `Read|Grep|Glob`), each only when that set is non-empty. When
  `has_python3` is false, print today's exact existing manual-instruction
  message, unchanged (FR-005) — the current `if
  printf '%s' "$settings_content" | grep -q '"PreToolUse"'` branch's
  condition gains an inner `has_python3` check to select between the two
  paths.

**`scripts/install.ps1` changes** (mirroring the above at lines 989-992,
inside the existing `if ($missingBashHooks.Count -gt 0 -or
$missingReadHooks.Count -gt 0)` block's `PreToolUse`-already-exists
branch):

- New function `Merge-PreToolUseHooks`: given the target path, matcher
  name, and missing-hook entry objects (reusing the exact same
  `$bashHookEntries`/`$readHookEntries` construction already at lines
  997-1024), uses `ConvertFrom-Json` to parse, locates or creates the
  matching `PreToolUse` group the same way as the Python version above,
  appends the new hook objects, and `ConvertTo-Json -Depth <N>` (depth
  sufficient to preserve the full nested structure — determined during
  implementation by testing against this project's own `settings.json`
  shape) to write back with 2-space-equivalent formatting matching
  `install.sh`'s own `indent=2` choice for consistency between the two
  installer paths.
- Call site: unconditional (no python3 gate needed on the PowerShell
  path) — replaces the existing `Write-Host "...add the following
  manually..."` line with a call to `Merge-PreToolUseHooks` for each
  non-empty missing set.

**`.github/workflows/validate.yml` changes**:

- New job `install-test-shared-hooks-merge` (bash matrix:
  ubuntu-latest/macos-latest/windows-latest, mirroring
  `install-test-shared-hooks-wave1`'s own exact job shape) with
  test-first scenario steps (tasks.md details the exact sequence):
  pre-seed a temp target's `settings.json` with an existing `PreToolUse`
  array (with and without a pre-existing `Bash`/`Read|Grep|Glob` group,
  per spec.md's Acceptance Scenarios), run `install.sh`, assert the
  missing hooks now appear in the correct group and everything
  pre-existing survived unchanged; a second scenario asserts the
  no-python3 fallback (`SPECJEDI_TEST_FORCE_NO_PYTHON3=1`, this project's
  own existing test seam) still produces today's exact manual-instruction
  message and leaves `settings.json` untouched; a third asserts
  idempotency (re-run produces no duplicate entries, matching the
  existing job family's own "Idempotent re-run" scenario shape at line
  1274-1282).
- New job `install-test-shared-hooks-merge-windows-native` (native
  PowerShell, mirroring `install-test-shared-hooks-wave1-windows-native`'s
  shape) with the equivalent scenarios against `install.ps1`.
- `ci-gate`'s `needs` list (line 2130) gains
  `install-test-shared-hooks-merge, install-test-shared-hooks-merge-windows-native`
  — required per Constitution Principle X ("new battery jobs are added
  to that `needs` list as the project grows").

### Token-budget / size-outlier check (specs/045, Step 5.5)

`spec.md`: 286 lines. `plan.md` (this file): under 220 lines — both
comparable to this session's prior two feature pairs (specs/059:
238/222, specs/060: 274/251) and other single-surface-change specs in
this project's history; neither is a size outlier warranting a flag.

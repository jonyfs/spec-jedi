# Implementation Plan: Ship .claude/agents/ in the Release Package and Installer

**Branch**: `067-ship-agents-in-release-package` | **Date**: 2026-07-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/067-ship-agents-in-release-package/spec.md`

## Summary

`scripts/package-release.sh` loops `.claude/skills/specjedi-*/` (line 48)
but never touches `.claude/agents/` — the 9 `orchestrate-*.md` agent
definitions (features 065/066) never ship in a release tarball.
`scripts/install.sh`/`.ps1` have zero references to `.claude/agents/` at
all — even a user who somehow got the files would never see them land in
their own project. This plan adds both: packaging copies
`.claude/agents/*.md` unconditionally into the tarball (mirroring the
skills loop exactly), and install copies them into the target project
only when the resolved harness is `claude-code`, reusing the existing
`backup_if_differs` loss-safety function unchanged. Also extends the
`package-content-completeness` CI job to assert agent files survive
packaging.

## Technical Context

**Language/Version**: Bash (`package-release.sh`, `install.sh`) +
PowerShell (`install.ps1`) — matching this project's own Cross-Platform
Support requirement (Principle XIII), every `.sh` change gets a `.ps1`
counterpart in the same change set.

**Primary Dependencies**: None new. Reuses `install.sh`'s existing
`backup_if_differs` function (line 558) and its PowerShell equivalent
verbatim — no new backup mechanism invented.

**Storage**: N/A — file copy operations only.

**Testing**: Extends the existing `package-content-completeness` CI job
(`.github/workflows/validate.yml` line 780) with an agent-file assertion,
matching its own existing pattern for other must-be-present paths. A new
local scratch-directory dry run (`install.sh <scratch> --harness
claude-code` then `--harness cursor`) verifies SC-002's both branches
before relying on CI alone.

**Target Platform**: Linux/macOS/Windows — `package-content-completeness`
already runs its matrix across all three (`ubuntu-latest`, `macos-latest`,
`windows-latest`), unchanged scope, extended assertion only.

**Project Type**: Single project — packaging/installer script edits.

**Performance Goals**: N/A — 9 small text files, no measurable cost.

**Constraints**: FR-002's harness-gating is the one branch this feature
adds that `.claude/skills/`'s own copy loop doesn't have — must not
accidentally create an empty `.claude/agents/` directory for a
non-claude-code install (spec.md Story 2 Acceptance Scenario 2).

**Scale/Scope**: 9 currently-existing agent files, loop-based (not
hardcoded) so it scales to however many exist at package/install time —
zero maintenance burden when a 10th agent is added later.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| XIII. Cross-Platform Support | Every `.sh` change needs a tested `.ps1` counterpart | ✅ Planned: `install.ps1` gets the identical agent-copy logic as `install.sh`, in the same change set |
| V. Specification Completeness | Plan must name exact insertion points, not "add somewhere" | ✅ Exact line numbers confirmed by reading the live files (package-release.sh's skill loop at line 48, install.sh's `backup_if_differs` at line 558, skill-copy loop at line 570) |
| IX. Mandatory Skill Validation & Testing | Change to packaging/install needs its own CI coverage | ✅ FR-004 extends `package-content-completeness` directly — the same job that already catches this class of gap for other paths |
| XVIII. Zero-Footprint Installer with Harness Selection | Installer must respect harness selection, never write content a harness can't use | ✅ FR-002's claude-code-only gating is exactly this principle applied to a new content type |
| XX. AI Discipline: Grounded, Honest Output | Must not invent a new backup mechanism when one already exists | ✅ Reuses `backup_if_differs` verbatim — Constraints section states this explicitly |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/067-ship-agents-in-release-package/
├── plan.md              # This file
└── tasks.md             # Phase 2 output (specjedi-tasks)
```

No `research.md` — this is a bugfix/gap-closure in existing scripts, not
new competitive research.

### Source Code (repository root)

```text
scripts/package-release.sh
  # Add a loop over .claude/agents/*.md immediately after the existing
  # specjedi-* skills loop (after line ~51's "✅ .claude/skills/$skill_name"
  # echo), staged into $stage_root/.claude/agents/ — same cp pattern,
  # unconditional (packaging includes everything; harness-gating is
  # install.sh's job per FR-002, not the package's).

scripts/install.sh
  # After the skills-copy loop (~line 570-578) and before the templates
  # section (~line 585), add: if [ "$harness" = "claude-code" ], loop
  # .claude/agents/*.md from $repo_root into $target_dir/.claude/agents/,
  # calling backup_if_differs per file exactly like the skills loop does
  # per skill directory. No directory created when harness != claude-code.

scripts/install.ps1
  # Identical logic, PowerShell syntax, same conditional gate and same
  # existing backup-if-differs equivalent function.

.github/workflows/validate.yml
  # package-content-completeness job: add an assertion that at least one
  # ".claude/agents/" path appears in a built package's tar listing,
  # inserted alongside the job's existing must-be-present loop.
```

**Structure Decision**: Single project, additive edits to 4 existing
files. No new script, no new CI job — extends what already exists.

## Complexity Tracking

*No entries — Constitution Check found no violations requiring justification.*

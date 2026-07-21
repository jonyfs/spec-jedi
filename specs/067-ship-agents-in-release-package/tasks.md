# Tasks: Ship .claude/agents/ in the Release Package and Installer

**Input**: Design documents from `/specs/067-ship-agents-in-release-package/`

**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: `package-content-completeness` CI job extension is this
feature's own test coverage; a local scratch-directory dry run verifies
both harness branches before relying on CI alone.

## Path Conventions

`scripts/package-release.sh`, `scripts/install.sh`, `scripts/install.ps1`,
`.github/workflows/validate.yml`, per plan.md's Project Structure.

---

## Phase 1: User Story 1 - Package includes .claude/agents/ (Priority: P1) 🎯

**Goal**: `scripts/package-release.sh` copies all `.claude/agents/*.md`
files into the tarball, loop-based.

**Independent Test**: Build a package via `package-release.sh`, `tar -tzf`
the result, confirm all 9 `orchestrate-*.md` files appear under
`.claude/agents/`.

### Implementation for User Story 1

- [x] T001 [US1] In `scripts/package-release.sh`, add an
  `agents_dst="$stage_root/.claude/agents"` + `mkdir -p` + loop over
  `"$repo_root/.claude/agents"/*.md` immediately after the existing
  specjedi-* skills loop, `cp`-ing each file and echoing `✅
  .claude/agents/$(basename ...)` — same pattern as the skills loop,
  unconditional (no harness gating at package time, per FR-001).
- [x] T002 [US1] Update the script's own header usage comment (lines
  16-22) to mention `.claude/agents/*.md` alongside
  `.claude/skills/specjedi-*/` in the "Produces a tarball containing..."
  description — keep documentation in sync with the actual behavior.

**Checkpoint**: A built package's tarball listing contains all 9
`.claude/agents/orchestrate-*.md` files (spec.md SC-001).

---

## Phase 2: User Story 2 - install.sh/.ps1 copy agents for claude-code targets (Priority: P1)

**Goal**: `install.sh`/`.ps1` copy `.claude/agents/*.md` into the target
project only when `--harness claude-code` is resolved, reusing the
existing loss-safety backup function.

**Independent Test**: `install.sh <scratch> --harness claude-code` →
`.claude/agents/orchestrate-*.md` present, byte-identical to source.
`install.sh <scratch2> --harness cursor` → no `.claude/agents/`
directory created at all.

### Implementation for User Story 2

- [x] T003 [US2] In `scripts/install.sh`, after the existing skills-copy
  loop (~line 570-578) and before the templates section, add: `if [
  "$harness" = "claude-code" ]; then` — loop
  `"$repo_root/.claude/agents"/*.md`, call
  `backup_if_differs "$agent_path" "$agents_dst/$(basename "$agent_path")"`
  per file (reusing the existing function unchanged, FR-003), then `cp`
  and echo `✅ $(basename ...)`; `fi` — no `mkdir -p` outside the
  conditional, so a non-claude-code install creates no
  `.claude/agents/` directory at all (FR-002, spec.md Story 2 Acceptance
  Scenario 2).
- [x] T004 [US2] In `scripts/install.ps1`, add the identical logic:
  same `$harness -eq 'claude-code'` conditional, same loop over
  `.claude/agents/*.md`, reusing that script's own existing
  backup-if-differs equivalent function unchanged (Principle XIII parity
  with T003).
- [x] T005 [US2] Manually dry-run both branches in a scratch directory:
  `install.sh /tmp/scratch1 --harness claude-code` confirms 9 files
  present and byte-identical (`diff -r`); `install.sh /tmp/scratch2
  --harness cursor` confirms `.claude/agents/` doesn't exist at all.
  Record the actual result inline in this task's own checkbox note
  (this project's own manual-verification convention, specs/042).

**Checkpoint**: A claude-code install gets working agent files; every
other harness install stays exactly as it was before this feature.

---

## Phase 3: Polish & Cross-Cutting Concerns

- [x] T006 Extend `package-content-completeness`
  (`.github/workflows/validate.yml`, the "Must be present" loop) with an
  assertion that at least one `.claude/agents/` path appears in the
  built package's tar listing — same shape as the job's existing
  per-path assertions (FR-004).
- [x] T007 [P] Verify `git status` shows changes only to the 4 files
  plan.md named plus this feature's own `specs/067-.../` set. **Real
  finding during implementation**: `scripts/package-release.ps1` also
  exists (plan.md missed it) and needed the identical fix for
  Principle XIII parity — added as a 5th file, not silently omitted.
  `git status` confirmed: `.github/workflows/validate.yml`, `CLAUDE.md`,
  `scripts/install.ps1`, `scripts/install.sh`,
  `scripts/package-release.ps1`, `scripts/package-release.sh`, plus
  `specs/067-.../` — nothing else.
- [x] T008 [P] Re-run the existing `package-content-completeness`
  assertions mentally against this diff — confirm nothing in the
  "Must be absent" list (specs/, internal reference docs) accidentally
  gained a new leak path from this change.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (US1)**: No dependencies — package-release.sh is independent
  of install.sh/.ps1.
- **Phase 2 (US2)**: Independent of Phase 1 at the code level (different
  files), but T005's dry run is most meaningful once Phase 1's packaging
  fix exists too (a real end-to-end check) — sequence Phase 1 before
  Phase 2's T005 in practice even though they don't hard-block each
  other.
- **Phase 3 (Polish)**: T006 depends on Phase 1 (asserts what Phase 1
  produces). T007/T008 depend on both phases being complete.

### Parallel Opportunities

- T001/T002 (package-release.sh) and T003/T004 (install.sh/.ps1) touch
  entirely different files — genuinely parallel.
- T007/T008 marked [P] — independent verification checks.

---

## Notes

- T003/T004's harness-gating is the one place this feature diverges from
  `.claude/skills/`'s own unconditional-copy pattern — intentional, per
  spec.md's resolved clarification, not an oversight to "fix" toward
  consistency.
- No test-task subsections — this is a bash/PowerShell script fix with
  CI-job coverage (T006) as its test, not a TDD unit-test scenario.

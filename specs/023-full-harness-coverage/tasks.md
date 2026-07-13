# Tasks: Full Harness Coverage

**Input**: Design documents from `/specs/023-full-harness-coverage/`

**Note**: written retrospectively (2026-07-13), backfilled after a
`/speckit-analyze` markdown audit found this feature — already shipped
via PR #82 and declared complete in `references/skill-roadmap.md` and
`CHANGELOG.md` — had no `tasks.md`/`checklists/requirements.md`, unlike
every other feature in this repo. Tasks below reflect what was actually
built and verified, marked complete because the work is already merged
on `main`, not because they were tracked live during implementation.

**Tests**: Principle VI exemption — installer-script work, no
meaningful code-level red/green cycle (plan.md's Constitution Check
states this explicitly); verified instead via exhaustive real execution
against all 18 explicit `--harness` values under both real `bash` and
real `pwsh` before any CI job was written.

---

## Phase 1: Native skills-directory harness (Antigravity)

- [X] T001 [US1] Add `antigravity` to `scripts/install.sh`/`.ps1`'s
      harness case statement, sharing Codex CLI's `.agents/skills`
      target — zero new installer branch logic, confirmed via Google's
      own Codelabs docs.

## Phase 2: Bridge-file mechanism (14 harnesses)

- [X] T002 [US1] Design and implement the `dir`/`single`/`devin`/`cody`
      bridge-generation modes in `scripts/install.sh`/`.ps1`, reading
      skill metadata back from the just-installed `.claude/skills/`
      packages.
- [X] T003 [US1] Wire the 14 bridge harnesses (Cursor, Windsurf, GitHub
      Copilot, Gemini CLI, Cline, Continue, Aider, Amazon Q Developer,
      JetBrains AI Assistant, Zed, Replit Agent, Devin, Tabnine,
      Sourcegraph Cody) into the harness case statement.
- [X] T004 [US1] Resolve Sourcegraph Cody's prior "Unclear" capability
      status via three further research rounds; implement its
      `.vscode/cody.json` Custom Commands mechanism.
- [X] T005 Fix the BSD `sed` `\s`-in-extended-regex portability bug
      found during manual testing (leading-space corruption in
      extracted skill metadata) — switched to the POSIX `[[:space:]]`
      class.

## Phase 3: Validation

- [X] T006 Add `install-test-antigravity`/`-windows-native` CI jobs
      (dedicated, mirroring the existing codex-cli/trae pattern).
- [X] T007 Add matrix `install-test-bridge-harnesses`/`-windows-native`
      CI jobs covering all 14 bridge harnesses across Linux/macOS/
      Windows, bash and native PowerShell.
- [X] T008 Wire both new job groups into `ci-gate`'s `needs:` list.

## Phase 4: Documentation

- [X] T009 Update README's harness table (all 20 ✅ Supported) and
      Mermaid compatibility diagram; render-verify the diagram.
- [X] T010 Update `references/harness-capability-notes.md` (status
      update banner, Antigravity/Cody corrections) and
      `references/principle-traceability.md` (Principle III →
      ✅ Mechanized).
- [X] T011 Constitution PATCH amendment (v1.23.0 → v1.23.1) recording
      the closure — no principle text changed.

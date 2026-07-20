# Implementation Plan: Expand Shareable Hooks — Push/Commit/Read Guards for `specjedi-*` Projects

**Branch**: `058-expand-shareable-hooks` | **Date**: 2026-07-19 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/058-expand-shareable-hooks/spec.md`

## Summary

Extends `scripts/install.sh`/`.ps1`'s shareable-hooks bundle (specs/041)
with four hooks built for this repo's own use since that feature shipped
(`prevent-direct-push.py`, `secret-scanner.py`, `conventional-commits.py`
opt-in, a `Stop` notification hook) plus one genuinely new hook (a
`PreToolUse` `Read`/`Grep`/`Glob`-matcher guard, `secret-file-guard.sh`/
`.ps1`) that actively denies reads of secret/credential files at any
directory depth — closing a documented reliability gap in the
declarative `permissions.deny` mechanism specs/041 already shipped
(`research.md` Decision 1). A `specjedi-security` self-invocation during
this planning pass also surfaced and fixed a real, pre-existing leak in
`secret-scanner.py` itself (FR-012, `research.md` Decision 5) —
unredacted secret values were being printed to the blocked commit's own
denial message, exactly the class of exposure this feature exists to
close, caught before this hook reaches every `specjedi-*`-installed
project via this feature's own bundle. Every new hook flows through specs/041's
existing per-harness dispatch (`install_hooks_gemini_cli`,
`install_permissions_opencode`, etc.) rather than a new mechanism.
`scripts/package-release.sh`/`.ps1` and `validate.yml`'s
`package-content-completeness` job are extended to stage every new hook
file — closing a structural gap (`research.md` Decision 4) that would
otherwise leave this feature working only from a git checkout, never
from the actual downloadable release.

## Technical Context

**Language/Version**: Bash (`set -euo pipefail`) and PowerShell Core
(`$ErrorActionPreference = 'Stop'`) for `secret-file-guard.sh`/`.ps1`
(new, zero-dependency, matching `dangerous-command-guard.sh`'s own
precedent — no `python3` gate needed for this one hook). Python 3
(matching `secret-scanner.py`/`prevent-direct-push.py`/
`conventional-commits.py`'s existing style) for the three hooks already
built as `.py` — no language change for those.

**Primary Dependencies**: None new. `python3` availability is now a real
install-time branch (FR-005) — `install.sh`/`.ps1` gains a
`has_python3()`/`Test-Python3Available` check reused before installing
any of the three Python-based hooks; `secret-file-guard.sh`/`.ps1` and
`dangerous-command-guard.sh`/`.ps1` are never gated on it.

**Storage**: N/A — target-project files (`.claude/settings.json` and
harness-equivalents already confirmed in specs/041's `research.md`) are
the only persistent state this feature reads/writes, same as specs/041.

**Testing**: Extends `.claude/hooks/test-hooks.sh`/`.ps1` with a new
`--- secret-file-guard.sh ---`-style section (matching the file's
existing per-hook section convention) covering: root-level `.env` denied,
nested `packages/api/.env` denied (SC-005), `.env.example` allowed
(SC-006), an unrelated file allowed, and a `Grep`/`Glob` call whose
`path` is a directory (not a specific secret file) never denied
(`research.md` Decision 3). Extends the same file with cases for
`install.sh`'s new `python3`-absence skip path and the second
`conventional-commits.py` opt-in prompt. New/extended
`install-test`-family jobs in `.github/workflows/validate.yml` assert
the actual staged hook files and wired `PreToolUse` matcher, matching
`install-test-codex-cli`/`-trae`'s established real-scratch-directory
pattern (Principle IX) — never asserted in docs alone.

**Target Platform**: Linux, macOS, Windows — every new/modified `.sh`
path (`install.sh`, `package-release.sh`, `secret-file-guard.sh`) gains
an identical `.ps1` counterpart (Principle XIII).

**Project Type**: Existing installer CLI script, extended in place —
same class of change as specs/041/042, no new project structure.

**Constraints**: FR-009's hook must never deny a `Grep`/`Glob` call whose
`path` is a directory or omitted — only a call whose `file_path`/`path`
names a specific secret-pattern file (`research.md` Decision 3),
otherwise ordinary project-wide searches this repo's own `specjedi-*`
skills run constantly would break. FR-006 requires the existing
"add manually" message to name every new hook, not just
`dangerous-command-guard.sh`. FR-004's `Stop`-hook wiring MUST reuse
`merge_json_key()` (`scripts/install.sh` ~L1099, specs/041 User Story
2's own generalized single-top-level-key non-destructive merge —
"generalized once a fourth target settings file needed the identical
merge," per that function's own header comment) rather than a fourth
bespoke inline block — Claude Code's own `.claude/settings.json`
already carries two bespoke non-generic merge paths
(`update_shared_settings()` for `statusLine`/`permissions`, and a
manual inline block for wiring `dangerous-command-guard.sh` into the
existing `PreToolUse` array specifically, since that one needs a
value-level "is this hook already in the array" check `merge_json_key()`
doesn't do). `Stop` needs only `merge_json_key()`'s exact intended
case — a simple "does this top-level key exist at all" check, insert
the whole block if absent, leave alone if present — so it should call
that already-generalized function directly instead of adding a third
bespoke variant.

**Scale/Scope**: Five hooks reach the shareable bundle (four adapted
from this repo's existing `.claude/hooks/*`, one new); each flows
through the same per-harness dispatch specs/041 already built — no new
harness research (`research.md`'s stated scope limit). Per-harness
`Read`/`Grep`/`Glob`-equivalent translation for FR-009 is scoped only to
harnesses whose confirmed hook surface (specs/041 `research.md`) is
distinct from their shell-command surface; a harness whose only
confirmed hook matcher is shell-command-shaped already gets equivalent
coverage from that harness's own translated `dangerous-command-guard.sh`
(its `read_cmd` check already denies `cat`/`head`/`tail`/`less`/`more`
against the same pattern set) — `specjedi-tasks` should enumerate this
per Wave 1/2 harness explicitly rather than assume uniform applicability.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I (English-Source) | All new file content, `research.md`, `spec.md`'s Clarifications are English-only. | ✅ Pass |
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | `research.md` grounds every genuinely new decision (permissions.deny reliability, secret-pattern set, hook field names, package-release.sh gap) in citation-backed research, not invention — the four adapted hooks (US1-4) reuse specs/041's own already-satisfied research, not re-litigated. | ✅ Pass |
| III (Universal Harness Compatibility) | No new harness classification; FR-011 reuses specs/041's confirmed per-harness dispatch, scoped explicitly (Scale/Scope above) to harnesses with a confirmed distinct hook surface. | ✅ Pass |
| VI / IX (Test-First, Skill Validation) | New hook and install-path scenarios join `.claude/hooks/test-hooks.sh`/`.ps1` and `.github/workflows/validate.yml`'s existing per-harness matrix — real scratch-directory assertions, not docs-only. | ✅ Pass — planned in Project Structure below |
| X (Trunk-Based Git Workflow) | Work proceeds on feature branch `058-expand-shareable-hooks`, PR-only, per `specjedi-implement`'s own Never list. | ✅ Pass |
| XIII (Cross-Platform Support) | Every new/modified `.sh` path (`install.sh`, `package-release.sh`, `secret-file-guard.sh`, `test-hooks.sh`) gains an identical `.ps1` counterpart. | ✅ Pass — planned in Project Structure below |
| XVIII (Zero-Footprint Installer with Harness Selection) | Directly extends the installer's own harness-selected shareable-hooks behavior; FR-005/FR-006 keep it honest — never installs a Python hook where `python3` is absent, never claims a hook was wired where it wasn't. | ✅ Pass |
| XX (AI Discipline: Grounded, Honest Output) | Every claim in `research.md` is cited (GitHub issue, The Register, gitleaks, this project's own live tool contract for field names) or explicitly marked as this project's own live-observed behavior, never fabricated. `research.md` Decision 4's package-release.sh gap is named explicitly, not silently left for a future feature to discover the same way specs/042 once did. | ✅ Pass |

No violations requiring Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/058-expand-shareable-hooks/
├── plan.md               # This file
├── research.md           # Phase 0 output (this run) — permissions.deny
│                          #   reliability, secret-pattern set, hook field
│                          #   names, package-release.sh staging gap
└── tasks.md               # Phase 2 output (specjedi-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
specs/041: the "entities" (which hooks are shareable, which stay
repo-internal) are already fully specified in spec.md's Key Entities,
and spec.md's own Acceptance Scenarios serve as the validation guide.

### Source Code (repository root)

```text
.claude/hooks/
├── secret-file-guard.sh    # NEW: PreToolUse Read|Grep|Glob-matcher
│                            #   guard (FR-009), bash, zero-dependency
├── secret-file-guard.ps1   # NEW: identical logic, PowerShell idiom
├── secret-scanner.py       # MODIFIED (FR-012) — ALREADY APPLIED during
│                            #   this planning pass's specjedi-security
│                            #   self-invocation, not deferred to
│                            #   specjedi-implement: matched-value
│                            #   redaction in the denial message.
│                            #   specjedi-tasks should mark this task
│                            #   pre-completed and add a regression test
│                            #   covering it, not re-implement it.
├── test-hooks.sh           # MODIFIED: new secret-file-guard.sh section,
│                            #   python3-absence skip cases,
│                            #   conventional-commits opt-in prompt case,
│                            #   secret-scanner.py redaction regression
│                            #   case (FR-012)
└── test-hooks.ps1          # MODIFIED: identical additions

.claude/settings.json        # MODIFIED: wires secret-file-guard.sh into
                              #   this repo's own PreToolUse Read|Grep|Glob
                              #   matcher (dogfooding, same as every other
                              #   hook here); permissions.deny patterns
                              #   broadened root-anchored `./` → recursive
                              #   `**/`, expanded to FR-009/010's pattern
                              #   set (defense-in-depth, research.md
                              #   Decision 1)

scripts/
├── install.sh               # MODIFIED: extends the existing
│                              #   `harness = "claude-code"` shareable-
│                              #   hooks block (~L1026) to also copy
│                              #   prevent-direct-push.py, secret-scanner.py,
│                              #   secret-file-guard.sh, and
│                              #   conventional-commits.py (opt-in only);
│                              #   new has_python3() gate (FR-005); second
│                              #   interactive Y/n prompt for
│                              #   conventional-commits.py (FR-003, right
│                              #   after the existing install_shared_hooks
│                              #   prompt ~L379); update_shared_settings()'s
│                              #   permissions_block broadened per FR-010;
│                              #   Wave 1/2 per-harness dispatch extended
│                              #   per Scale/Scope's scoping rule above;
│                              #   "add manually" message (FR-006) names
│                              #   every new hook; Stop-hook wiring
│                              #   (FR-004) via merge_json_key() reuse —
│                              #   see Implementation notes below
├── install.ps1               # MODIFIED: identical additions, PowerShell
│                              #   idiom
├── package-release.sh        # MODIFIED: stages secret-scanner.py,
│                              #   conventional-commits.py,
│                              #   prevent-direct-push.py,
│                              #   secret-file-guard.sh/.ps1 into
│                              #   .claude/hooks/ (research.md Decision 4
│                              #   — closes the same bug class specs/042
│                              #   already fixed once for
│                              #   dangerous-command-guard.sh)
└── package-release.ps1       # MODIFIED: identical additions

.github/workflows/validate.yml   # MODIFIED: package-content-completeness
                                  #   job's "must be present" list gains
                                  #   every new hook path; install-test
                                  #   jobs assert the new hooks/prompts
```

### Implementation notes for `specjedi-tasks`/`specjedi-implement`

**`secret-file-guard.sh` matching logic (FR-009)**: mirrors
`dangerous-command-guard.sh`'s own stdin-parse-then-`case`-match
structure, but extracts `tool_input.file_path` (`Read`) or
`tool_input.path` (`Grep`/`Glob`) instead of `tool_input.command`. Only
denies when that field's `basename` matches the pattern set; a `path`
that resolves to a directory (or is absent) is never denied
(`research.md` Decision 3 — this is the one place this hook's logic
diverges structurally from `dangerous-command-guard.sh`'s token-scan
approach, since Bash commands don't have this directory-vs-file
ambiguity). Template exclusions (`.env.example`/`.env.sample`/
`.env.template`) reuse the exact `continue`-based `case` precedent
`dangerous-command-guard.sh`'s own `read_cmd` block already established.

**`permissions.deny` broadening (FR-010)**: change every
`Read(./...)` entry in `update_shared_settings()`'s `permissions_block`
(and this repo's own `.claude/settings.json`) to `Read(**/...)`,
confirmed valid gitignore-style glob syntax per
code.claude.com/docs/settings (`research.md`). Expand the list to the
same pattern set as FR-009.

**`python3` detection (FR-005)**:

```bash
has_python3() { command -v python3 >/dev/null 2>&1; }
```

Called once before the three Python-hook `cp` calls in the
`claude-code` shareable-hooks block; on failure, skip all three with one
named warning line (`"⚠️  python3 not found — skipping secret-scanner.py, prevent-direct-push.py, conventional-commits.py"`),
never a per-hook silent partial skip.

**Second opt-in prompt (FR-003)**: inserted immediately after the
existing `install_shared_hooks` prompt (~install.sh L379), same
`interactive_mode` block, same Y/n idiom:

```bash
install_conventional_commits=0
if [ "$interactive_mode" -eq 1 ] && [ "$install_shared_hooks" -eq 1 ]; then
  read -r -p "Also install conventional-commits.py (enforces 'type: description' commit messages)? [y/N]: " cc_answer
  case "$cc_answer" in
    y|Y|yes|Yes) install_conventional_commits=1 ;;
  esac
fi
```

Default is **off** (`[y/N]`, opposite of the main hooks prompt's
`[Y/n]`) — matching spec.md User Story 3's own framing that this is an
opinionated addition, never assumed-yes the way the pure safety nets are.
Non-interactive invocations never install it (no FR-001c-style
default-on carve-out for this one hook, since it's explicitly opt-in).

**Codex CLI trust workflow note carries forward**: same as specs/041's
plan.md — any newly-shareable hook installed for Codex CLI still
requires the end-user to run `/hooks` inside Codex CLI and approve it
before it's actually active; `tasks.md` should include the same
docs/output-message task specs/041 already planned for this, extended to
name every new hook rather than just the original one.

**`Stop`-hook wiring (FR-004, closes a `specjedi-analyze` finding)**:
`update_shared_settings()` only handles the `statusLine`/`permissions`
keys (its own two-key-specific check, not a generic key list), and the
existing `PreToolUse` wiring block (~L1058-1089) is deliberately bespoke
because it must check whether `dangerous-command-guard.sh` is already
*present inside* an existing `PreToolUse` array, not just whether the
array exists — a value-level check `merge_json_key()` was never designed
for. `Stop` has no such nuance: a target either already has a `Stop`
array (leave alone) or doesn't (insert the whole block), exactly
`merge_json_key()`'s own designed case. Call it directly:

```bash
stop_block='  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "if command -v osascript >/dev/null 2>&1; then osascript -e '"'"'display notification \"Response complete\" with title \"Claude Code\"'"'"'; elif command -v notify-send >/dev/null 2>&1; then notify-send \"Claude Code\" \"Response complete\"; fi"
        }
      ]
    }
  ]'
merge_json_key "$target_dir/.claude/settings.json" '"Stop"' "$stop_block" "Stop notification hook wired"
```

(The doubled single-quote escaping above mirrors this repo's own
`.claude/settings.json` Stop entry exactly — copy that entry's already-
working `osascript`/`notify-send` command string verbatim rather than
re-deriving the escaping.) `install.ps1` gets the identical call through
its own `Merge-JsonKey` counterpart, same as every other
`merge_json_key()` call site already does for the four Wave 1/2 harness
files.

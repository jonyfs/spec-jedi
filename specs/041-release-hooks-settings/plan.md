# Implementation Plan: Release-Ship Shareable Hooks & Settings, Per Harness

**Branch**: `041-release-hooks-settings` | **Date**: 2026-07-15 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/041-release-hooks-settings/spec.md`

## Summary

Ships the generically-useful subset of this repo's own `.claude/hooks/*`
(`dangerous-command-guard.sh`/`.ps1`) and `.claude/settings.json`
additions (`permissions.allow`/`.deny` from specs/040) into
`scripts/install.sh`/`.ps1`, installable for `claude-code` and, per
fresh research covering all 19 other harnesses in Principle III's
matrix (`research.md`), adapted for a prioritized subset of harnesses
with a genuine hooks/permissions-equivalent mechanism. Installation is
an interactive prompt (default-on) for human sessions, automatic for
scripted/CI installs — mirroring specs/040's own `interactive_mode`
distinction. `skill-quality-guard`/`cross-platform-parity-guard` stay
repo-internal, never shipped.

## Technical Context

**Language/Version**: Bash (`set -euo pipefail`) and PowerShell Core
(`$ErrorActionPreference = 'Stop'`) — matching `scripts/install.sh`/
`.ps1`'s and `.claude/hooks/*`'s existing style. No new language.

**Primary Dependencies**: None new. `git` for trunk-branch detection
(FR-002a) and non-destructive settings merge; `grep`/`sed` (bash) and
native regex (PowerShell) for JSON field extraction and merge, matching
`update_memory_file`/`Update-MemoryFile`'s (specs/039) and this
session's own hooks' (PR #119) established zero-`jq` precedent.

**Storage**: N/A — target-project files (`.claude/settings.json` and
harness-equivalents: `.gemini/settings.json`, Antigravity's own settings
location, `opencode.json`, Zed/Warp/Amazon Q's own settings files) are
the only persistent state this feature reads/writes.

**Testing**: Extends `.claude/hooks/test-hooks.sh`/`.ps1` with new cases
covering: shareable-hook installation into a scratch target, idempotent
re-run, non-destructive merge against a pre-populated target settings
file, and trunk-branch detection against a target repo with a non-`main`
default branch (SC-007). New harness-specific install scenarios join
`.github/workflows/validate.yml`'s existing per-harness matrix jobs
(`install-test`-family), matching `install-test-codex-cli`/
`install-test-trae`'s own established pattern — real scratch-directory
installs with real file-content assertions (Principle IX), never
asserted in docs alone.

**Target Platform**: Linux, macOS, Windows — every new code path in
`install.sh` gains an equivalent in `install.ps1` (Principle XIII),
including per-harness adaptation logic.

**Project Type**: Existing installer CLI script, extended in place — no
new project structure, same class of change as specs/039/040.

**Constraints**: FR-003 requires non-destructive merge into a target's
own settings-equivalent file the installer doesn't fully own — same
"never touch a byte outside the managed section" discipline
`update_memory_file` already established, generalized here to
JSON-shaped targets instead of Markdown-marker-delimited ones. FR-002a
requires trunk-branch detection to degrade to a safe default
(`main`/`master`) rather than fail the whole install when undetectable.

**Scale/Scope**: Two waves of harness-specific adaptation code (Wave 1:
Gemini CLI, Antigravity, Codex CLI; Wave 2: OpenCode, Zed, Warp, Amazon
Q — see `research.md`'s Decision), each following the existing per-harness
dispatch pattern (`harness` case/switch in `install.sh`/`.ps1`) rather
than a new abstraction. Cursor/Windsurf/Copilot (confirmed Full, but
structurally distinct hook dialects) are explicitly named and deferred
to a follow-up feature, not silently dropped. Cline/Aider/Continue/
JetBrains AI/Tabnine/Replit/Devin/Cody/Trae get the existing FR-005
clean-skip behavior — no new code path, same as `antigravity`'s existing
"no confirmed memory-file convention" precedent (specs/039).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| I (English-Source) | All new file content, comments, and `research.md`'s own findings are English-only. | ✅ Pass |
| II (Competitive Research Before Creation, NON-NEGOTIABLE) | `research.md` researches all 19 harnesses fresh via citation-backed WebSearch before any adaptation code is designed — directly satisfies this principle for what is, per FR-001a, a genuinely new structural pattern (per-harness hook/permission translation) this repo hasn't attempted before. | ✅ Pass |
| IX (Mandatory Skill Validation & Testing) | New install scenarios join `.claude/hooks/test-hooks.sh`/`.ps1` and `.github/workflows/validate.yml`'s existing per-harness CI matrix — not asserted in docs alone (Testing above). | ✅ Pass — planned in Project Structure below |
| X (Trunk-Based Git Workflow) | Work proceeds on feature branch `041-release-hooks-settings`; the two-wave scoping (Scale/Scope above) is explicitly designed to keep each landed PR a reviewable size rather than one monolithic change. | ✅ Pass |
| XIII (Cross-Platform Support) | Every new `install.sh` code path (Wave 1/2 adaptation, trunk detection, interactive prompt) gains an equivalent `install.ps1` path. | ✅ Pass — planned in Project Structure below |
| XVIII (Zero-Footprint Installer with Harness Selection) | This feature extends the installer's own harness-selected behavior directly — core to this principle. FR-005/FR-006 keep the extension honest: no false claim for unsupported harnesses, no repo-internal hook leaking into any target. | ✅ Pass |
| XX (AI Discipline: Grounded, Honest Output) | Every harness classification in `research.md` carries a citation; "unconfirmed" (Tabnine) is treated as **None**, never guessed toward Full/Partial. FR-005 forbids claiming hooks/settings were installed where they weren't. Deferred harnesses (Cursor/Windsurf/Copilot) are named explicitly, not silently dropped. | ✅ Pass |

No violations requiring Complexity Tracking — the two-wave scoping
(Scale/Scope) is a deliberate simplification already reasoned through
above and in `research.md`'s own Decision, not a gate failure being
worked around.

## Project Structure

### Documentation (this feature)

```text
specs/041-release-hooks-settings/
├── plan.md              # This file
├── research.md          # Phase 0 output (this run) — all 19 harnesses
│                         #   classified with citations
└── tasks.md             # Phase 2 output (speckit-tasks)
```

No `data-model.md`/`contracts/`/`quickstart.md` — same reasoning as
`specs/039`/`specs/040`: the "entities" (shareable vs. repo-internal
hooks/settings) are already fully specified in spec.md's Key Entities,
and spec.md's own Acceptance Scenarios serve as the validation guide.

### Source Code (repository root)

```text
scripts/
├── install.sh            # MODIFIED: shareable-hooks interactive prompt
│                          #   (FR-001b/c), trunk-branch detection
│                          #   (FR-002a), non-destructive settings merge
│                          #   (FR-003), Wave 1/2 per-harness adaptation
│                          #   dispatch
├── install.ps1            # MODIFIED: identical additions, PowerShell idiom

.claude/
└── hooks/
    ├── test-hooks.sh       # MODIFIED: new install-scenario test cases
    └── test-hooks.ps1      # MODIFIED: identical additions

.github/workflows/
└── validate.yml           # MODIFIED: new per-harness install-test jobs
                            #   for Wave 1/2 harnesses, matching the
                            #   install-test-codex-cli/-trae pattern

references/
└── harness-capability-notes.md   # MODIFIED: pointer to research.md's
                                    #   new hooks/settings/statusline
                                    #   findings, extending this file's
                                    #   documented scope (which has only
                                    #   ever covered rules/skills-file
                                    #   capability until now)
```

### Implementation notes for `speckit-tasks`/`speckit-implement`

**Interactive prompt (FR-001b/c)**: inserted into `install.sh`'s existing
`interactive_mode` block (from specs/040's interactive-install feature),
as one more line in the existing final summary/confirmation, not a
separate later prompt:

```bash
install_shared_hooks=1
if [ "$interactive_mode" -eq 1 ]; then
  read -r -p "Also install shareable hooks/settings (safety hook, git-aware permissions)? [Y/n]: " hooks_answer
  case "$hooks_answer" in
    n|N|no|No) install_shared_hooks=0 ;;
  esac
fi
```

For non-interactive invocations, `install_shared_hooks` stays `1`
(default-on) with no prompt at all, per FR-001c.

**Trunk-branch detection (FR-002a)**:

```bash
detect_trunk_branch() {
  local dir="$1" branch
  branch="$(git -C "$dir" symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null | sed 's@^origin/@@')"
  if [ -z "$branch" ]; then
    branch="$(git -C "$dir" remote show origin 2>/dev/null | sed -n 's/^ *HEAD branch: //p')"
  fi
  [ -n "$branch" ] && printf '%s' "$branch" || printf '%s' "main master"
}
```

Note the fallback returns the literal two-word string `main master` when
detection fails entirely — the installed hook's own trunk-check must
then match against *both* words, mirroring this repo's own existing
`dangerous-command-guard.sh` behavior of checking `main`/`master`
together (PR #119's `has_main_or_master` token check) rather than
picking just one.

**Non-destructive settings merge (FR-003)**: reuses
`update_memory_file`'s whole-content substring-slicing discipline
(specs/039), adapted for JSON — insert/replace a
`// SPEC-JEDI:HOOKS:START` / `// SPEC-JEDI:HOOKS:END`-delimited block
inside the target's `hooks`/`permissions` structure rather than
attempting a generic JSON deep-merge (which would require a real JSON
library this project has deliberately avoided depending on — see
`research.md`'s zero-`jq` precedent). Malformed/missing marker pairs
fail loudly, exact mirror of `update_memory_file`'s own FAIL case.

**Wave 1/2 harness dispatch**: extends the existing `case "$harness" in
... esac` block (Harness Target mapping, `install.sh`) with the
shareable-hooks translation for `gemini-cli`, `antigravity`, `codex-cli`
(Wave 1), then `opencode`, `zed`, `warp`, `amazon-q` (Wave 2,
permissions-only —
no hook translation attempted for these four, since `research.md`
classifies their hooks as either absent or plugin-code-only). Each
translation is a small, harness-specific function
(`install_hooks_gemini_cli`, `install_permissions_opencode`, etc.)
writing to that harness's own confirmed config location from
`research.md`'s table — never a generic "translate any hooks.json"
abstraction, matching this project's own "no premature abstraction"
coding-style discipline until a third/fourth harness's shape proves a
real pattern worth extracting.

**Codex CLI trust workflow note**: Codex CLI is **Full** (hooks) but its
own trust/review workflow means an installed hook won't actually run
until the end-user runs `/hooks` inside Codex CLI and approves it. This
is inherent to Codex CLI itself, not something the installer can bypass
or pre-approve. `tasks.md` should include a docs/output-message task
telling the user this explicitly after a Codex CLI hooks install,
consistent with Principle XX (never implying the hook is active before
the user has actually trusted it).

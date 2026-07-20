# Feature Specification: install.sh/.ps1 Merge Shareable Hooks Into an Existing PreToolUse Array

**Feature Branch**: `061-install-merge-pretooluse`

**Created**: 2026-07-20

**Status**: Draft

**Input**: User description: "ajuste para que o script de instalacao saiba resolver isso ao executar: ℹ️  settings.json already has statusLine and permissions — leaving as-is. ℹ️  Target already has a PreToolUse hooks array — add the following manually, not overwritten automatically: /Users/jony/repositorios/ai/barbearia/.claude/hooks/dangerous-command-guard.sh /Users/jony/repositorios/ai/barbearia/.claude/hooks/prevent-direct-push.py /Users/jony/repositorios/ai/barbearia/.claude/hooks/secret-scanner.py /Users/jony/repositorios/ai/barbearia/.claude/hooks/secret-file-guard.sh"

## Clarifications

### Session 2026-07-20

- Q: How should the merge into an existing `PreToolUse` array be
  implemented — full parse+rewrite via a real JSON library, or a
  surgical text splice preserving the target file's exact original
  formatting? → A: Full parse+rewrite (recommended default) — python3's
  `json.load`/`json.dump` with 2-space indent (matching this project's
  own existing convention), accepting purely cosmetic re-indentation risk
  on a target using a different indent style, in exchange for correctness
  and robustness against arbitrary existing JSON structure. Python 3.7+
  preserves dict insertion order, so no key reordering or data loss
  results — the only observable side effect is a possible whitespace/
  indent-style change to the rest of the file, never lost or reordered
  content.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Missing Bash-matcher hooks merge into an existing `PreToolUse`/`Bash` group (Priority: P1)

A user runs `scripts/install.sh`/`.ps1` against a target project whose
`.claude/settings.json` already has a `hooks.PreToolUse` array (this
exact real scenario: a `barbearia` project's `settings.json` already had
`PreToolUse` populated, likely from a prior partial install or another
tool). Today, `install.sh`/`.ps1` detects the missing shareable hooks
(`dangerous-command-guard.sh`, `prevent-direct-push.py`,
`secret-scanner.py` — all `Bash`-matcher hooks) but refuses to touch the
existing array, printing an "add the following manually" message
instead (confirmed by direct read of `scripts/install.sh` lines
1263-1265). This story makes the installer merge the missing hook
entries directly into the existing `"matcher": "Bash"` group's own
`"hooks"` array when python3 is available (matching this project's own
established python3-gating precedent already used for
`prevent-direct-push.py`/`secret-scanner.py` themselves), leaving every
other part of `settings.json` — including hooks the target project added
on its own — untouched.

**Why this priority**: This is the exact real failure the user hit. Without
it, every target project with any pre-existing `PreToolUse` array (a very
common case — Claude Code, other installers, or a partial prior run can
all produce one) never gets the shareable hooks wired automatically,
defeating the "zero-footprint installer" goal (Constitution Principle
XVIII) for exactly the projects most likely to already have some hooks
configured.

**Independent Test**: Given a target `settings.json` with an existing
`PreToolUse` array containing a `"matcher": "Bash"` group, and one or
more shareable Bash-matcher hooks missing from it, running the installer
(with python3 available) results in those missing hooks appearing inside
that existing group's `"hooks"` array — with every pre-existing entry in
`settings.json` (including hooks the installer didn't add) byte-for-byte
unchanged.

**Acceptance Scenarios**:

1. **Given** a target `settings.json` with `PreToolUse` → `[{"matcher":
   "Bash", "hooks": [<one pre-existing custom hook>]}]` and
   `dangerous-command-guard.sh` missing, **When** the installer runs
   (python3 available), **Then** the `Bash` group's `hooks` array
   contains both the pre-existing custom hook (unchanged) and the newly
   added `dangerous-command-guard.sh` entry.
2. **Given** the same starting state, **When** the installer runs a
   second time immediately after, **Then** no duplicate entry is added —
   the existing "already present" substring check (`scripts/install.sh`'s
   own `missing_bash_hooks`/`missing_read_hooks` computation) already
   prevents this and continues to.
3. **Given** a target `settings.json` whose `PreToolUse` array has no
   `"matcher": "Bash"` group at all (e.g., only a `"Read|Grep|Glob"`
   group exists), **When** the installer runs, **Then** it appends a new
   `{"matcher": "Bash", "hooks": [...]}` group to the existing
   `PreToolUse` array — never fabricating a `Bash` group's contents into
   an unrelated matcher's array.

---

### User Story 2 - Missing Read-matcher hooks merge the same way (Priority: P1)

The same real failure applies to `secret-file-guard.sh` (a
`"Read|Grep|Glob"`-matcher hook, per this repo's own established
`update_shared_settings()`/fresh-install JSON construction convention —
confirmed by direct read of `scripts/install.sh` lines 1296-1324). This
story extends Story 1's merge behavior to the `Read|Grep|Glob` matcher
group symmetrically.

**Why this priority**: Equal priority to Story 1 — both hook types
appeared in the exact same real failure the user hit; fixing only the
`Bash` group would leave `secret-file-guard.sh` still requiring a manual
step.

**Independent Test**: Given a target `settings.json` with an existing
`PreToolUse` array and `secret-file-guard.sh` missing from any
`"Read|Grep|Glob"` group, running the installer results in it being
merged in the same non-destructive way Story 1 describes for Bash hooks.

**Acceptance Scenarios**:

1. **Given** a target `settings.json` with `PreToolUse` → `[{"matcher":
   "Bash", "hooks": [...]}]` (no `Read|Grep|Glob` group at all) and
   `secret-file-guard.sh` missing, **When** the installer runs, **Then**
   it appends a new `{"matcher": "Read|Grep|Glob", "hooks": [...]}` group
   to the array, alongside the existing `Bash` group, unchanged.
2. **Given** a target `settings.json` already has a `"Read|Grep|Glob"`
   group with unrelated pre-existing hooks, **When** the installer runs,
   **Then** `secret-file-guard.sh` is appended into that group's own
   `hooks` array, and the pre-existing unrelated hooks in it are
   unchanged.

---

### User Story 3 - No python3: today's manual-instruction fallback is preserved, not silently dropped (Priority: P2)

When python3 is unavailable, the installer cannot safely merge into an
existing array (this project's own already-gated pattern for
`prevent-direct-push.py`/`secret-scanner.py` — confirmed by direct read
of `scripts/install.sh` lines 1200-1233 — already treats python3 as a
hard requirement for JSON-structure-aware work). This story confirms
today's existing "print the manual-add instructions" behavior is
preserved as the fallback, not silently removed, so a python3-less run
never fails loudly or corrupts `settings.json` by attempting a merge it
can't safely perform.

**Why this priority**: Lower priority because it's a preserved
fallback, not new value — but it's what keeps Stories 1-2 safe rather
than a regression for the subset of users without python3.

**Independent Test**: Given python3 is unavailable
(`SPECJEDI_TEST_FORCE_NO_PYTHON3`, this project's own existing test seam,
confirmed by direct read of `scripts/install.sh`'s `has_python3()`) and a
target `settings.json` with an existing `PreToolUse` array missing some
shareable hooks, running the installer prints today's exact existing
"add the following manually" message, unchanged, and does not modify
`settings.json`'s `PreToolUse` array at all.

**Acceptance Scenarios**:

1. **Given** `SPECJEDI_TEST_FORCE_NO_PYTHON3=1` and a target with an
   existing `PreToolUse` array missing hooks, **When** the installer
   runs, **Then** the manual-instruction message prints (today's exact
   wording, unchanged) and `settings.json` is byte-for-byte unchanged.

---

### Edge Cases

- What happens when `PreToolUse` exists but is genuinely malformed
  (unbalanced braces/brackets, not valid JSON)? Same discipline
  `merge_json_key()` already establishes for its own case (`scripts/
  install.sh` lines 1020-1023): fail loudly and explicitly ("not valid
  JSON, refusing to guess"), never attempt a guessed insertion — this
  applies to the new python3-based merge path too (a `json.load()`
  failure is reported plainly, the same "refuse to guess" posture).
- What happens to the `.codex/hooks.json` case (`scripts/install.sh`
  lines 1843/1513 in `.ps1`), which has the identical "already exists —
  add manually" message for Codex CLI's own hooks file? Out of scope for
  this feature — the user's own real failure was specifically the
  `settings.json` `PreToolUse` case; the Codex CLI case is a distinct
  target file with its own structure and would need its own feature if
  the same treatment is wanted later (see Assumptions).
- What happens when the missing hook belongs to a matcher pattern this
  project doesn't currently use anywhere (e.g., a future third matcher
  type)? Out of scope — FR-001/FR-002 below name exactly the two matcher
  patterns (`Bash`, `Read|Grep|Glob`) this project's shareable hooks
  actually use today, per direct code read; a third matcher type would
  need its own follow-up if one is ever added.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When a target `settings.json`'s `hooks.PreToolUse` array
  already exists and contains a `"matcher": "Bash"` group, and python3 is
  available, `install.sh`/`.ps1` MUST merge each currently-missing
  Bash-matcher shareable hook (`dangerous-command-guard.sh`,
  `prevent-direct-push.py`, `secret-scanner.py`, `conventional-commits.py`
  when opted in) into that group's own `"hooks"` array, computed via the
  same `missing_bash_hooks` substring-presence check `install.sh` already
  performs (`scripts/install.sh` lines 1251-1255) — never adding a hook
  already present.
- **FR-002**: Under the same python3-available condition, if the existing
  `PreToolUse` array has no `"matcher": "Bash"` group at all,
  `install.sh`/`.ps1` MUST append a new `{"matcher": "Bash", "hooks":
  [...]}` group to the array containing the missing hooks, rather than
  fabricating them into an unrelated matcher's group.
- **FR-003**: FR-001/FR-002's same merge behavior MUST apply symmetrically
  to `"matcher": "Read|Grep|Glob"` for `secret-file-guard.sh`, computed
  via the existing `missing_read_hooks` check (`scripts/install.sh` lines
  1257-1261).
- **FR-004**: Every part of the target `settings.json` not directly
  involved in the merge — pre-existing hooks, other top-level keys
  (`statusLine`, `permissions`, and any the target project added on its
  own) — MUST remain unchanged by the merge, verified per-scenario in
  User Story 1/2's acceptance scenarios.
- **FR-005**: When python3 is unavailable (`has_python3`/
  `Test-Python3Available` returning false, including via
  `SPECJEDI_TEST_FORCE_NO_PYTHON3`), `install.sh`/`.ps1` MUST fall back to
  today's exact existing "add the following manually" message and
  behavior, unchanged — never attempt the merge, never fail loudly for
  lacking python3 on a path that already tolerates its absence elsewhere
  in this same installer.
- **FR-006**: If the target `settings.json`'s `PreToolUse` structure is
  malformed (not valid, parseable JSON), `install.sh`/`.ps1` MUST fail
  explicitly with a clear message naming the file and the problem — never
  attempt a guessed insertion into content it can't safely parse, matching
  `merge_json_key()`'s own existing "refusing to guess" precedent
  (`scripts/install.sh` lines 1020-1023).
- **FR-007**: This feature is scoped to `.claude/settings.json`'s
  `hooks.PreToolUse` array only — the `.codex/hooks.json` "already
  exists" case (`scripts/install.sh` lines 1843/1513 `.ps1`) is
  explicitly out of scope (see Edge Cases and Assumptions).
- **FR-008**: `install.sh` MUST implement FR-001/FR-002/FR-003's merge via
  a full parse-and-rewrite: python3's `json.load()` to parse the target
  `settings.json`, in-memory insertion of the missing hook entries into
  the correct matcher group (creating the group per FR-002 when absent),
  then `json.dump(..., indent=2)` to write it back — matching this
  project's own existing 2-space-indent convention. This is a deliberate
  divergence from `install.ps1`'s `Update-SharedSettings`'s own stated
  reason for avoiding a parse-reserialize round-trip (lines 658-665):
  Python 3.7+ preserves dict insertion order, so no key reordering or
  content loss results from this round-trip — the only observable side
  effect is a possible whitespace/indent-style change on a target whose
  `settings.json` used different formatting, which is an accepted,
  purely cosmetic trade-off for correctness and robustness against
  arbitrary existing `PreToolUse` structure (see Clarifications above).
  `install.ps1` MUST use the equivalent PowerShell-native mechanism
  (`ConvertFrom-Json`/`ConvertTo-Json`) for the same operation — this is
  a scoped, hooks-array-only exception to `Update-SharedSettings`'s own
  broader avoid-round-trip convention for the rest of `settings.json`'s
  top-level keys, which that function continues to handle via its
  existing text-based approach, unchanged.

### Key Entities

- **Target `settings.json`'s `hooks.PreToolUse` array**: the existing
  JSON structure this feature merges into — may already contain matcher
  groups this installer didn't create, which MUST survive the merge
  unchanged (FR-004).
- **Missing hook set**: `missing_bash_hooks`/`missing_read_hooks`, already
  computed by `install.sh`/`.ps1` today (unchanged by this feature) — the
  exact list this feature merges in, never a recomputed or different set.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running the installer against a target with an existing
  `PreToolUse` array and python3 available results in 0 "add the
  following manually" messages for any hook the merge successfully
  wired — the message only prints when the merge itself cannot proceed
  (FR-005, FR-006).
- **SC-002**: A target `settings.json`'s pre-existing hooks (any the
  installer didn't add) are present, unchanged, in 100% of post-merge
  runs — checkable via diffing everything except the newly-added hook
  entries.
- **SC-003**: Running the installer twice in a row against the same
  target produces 0 duplicate hook entries on the second run.
- **SC-004**: A python3-less run produces byte-for-byte identical
  `settings.json` output to today's current behavior, in 100% of such
  runs.

## Assumptions

- The `.codex/hooks.json` "already exists" case is a distinct file with
  its own structure and is not addressed by this feature — a future
  feature could extend the same underlying mechanism to it once this
  feature's own approach (FR-008) is confirmed and shipped.
- The two matcher patterns this feature merges into (`Bash`,
  `Read|Grep|Glob`) are exactly the two this project's shareable-hooks
  installer already uses (confirmed by direct code read); no other
  matcher pattern is in scope.
- `install.ps1`'s parity requirement (Constitution Principle XIII) means
  whatever mechanism FR-008 resolves to for `install.sh` (python3-based)
  needs a working PowerShell-native equivalent for `install.ps1` — most
  likely using PowerShell's own JSON/regex tooling rather than requiring
  python3 on Windows, but the exact mechanism follows from FR-008's
  resolution and is detailed in `plan.md`, not decided here.

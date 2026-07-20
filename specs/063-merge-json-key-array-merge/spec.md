# Feature Specification: merge_json_key() Merges Into an Existing Array-Shaped Key

**Feature Branch**: `063-merge-json-key-array-merge`

**Created**: 2026-07-20

**Status**: Draft

**Input**: User description: "resolva isso no script de instalacao settings.json already has this key — leaving as-is."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Missing content merges into an existing array-shaped key instead of no-op'ing (Priority: P1)

A user runs `scripts/install.sh`/`.ps1` against a target project whose
`.claude/settings.json` already has a `"Stop"` key (e.g. from a prior
partial install, or a project that configured its own Stop hook before
running this installer) — the same real class of scenario as this
session's earlier `barbearia` `PreToolUse`-array failure
(specs/061), now hit for a second key. Today, `merge_json_key()`
(confirmed by direct read: `scripts/install.sh` lines 1049-1066,
`scripts/install.ps1` lines 812-827) only checks whether the target's
raw content *contains the key name as a substring* — if so, it prints
"already has this key — leaving as-is" and does nothing further, even
when the existing key's own array is missing the exact notification
hook this installer would have added. This story makes `merge_json_key()`
detect when the existing key's value is a JSON array and the new
block's own top-level value is also an array, and merge the missing
array items in — deduplicating by content, exactly matching
`merge_pretooluse_hooks()`'s own proven approach (specs/061) — instead
of silently no-op'ing.

**Why this priority**: This is the exact, directly-named real failure
the user hit — a second instance of the same "installer refuses to
touch a key that already exists" class of gap specs/061 already fixed
for one specific key (`PreToolUse`); `merge_json_key()` is the shared,
generic mechanism behind five different keys across five harnesses
(`"Stop"` for claude-code, `"hooks"` for gemini-cli/antigravity,
`"permission"` for opencode, `"agent"` for zed — confirmed by direct
`grep` across `scripts/install.sh`), so fixing it here benefits every
array-shaped case among them, not just one.

**Independent Test**: Given a target `settings.json` with an existing
`"Stop"` array missing the shareable notification hook entry, running
the installer results in that entry being appended to the existing
array — with every pre-existing entry in that array (including one the
installer didn't add) byte-for-byte unchanged in content.

**Acceptance Scenarios**:

1. **Given** a target `.claude/settings.json` with `"Stop": [{"matcher":
   "", "hooks": [<one pre-existing custom notification hook>]}]`,
   **When** the installer runs, **Then** the shareable Stop notification
   hook entry is merged into that same array (either appended to the
   existing group's own `"hooks"` list if the group's `"matcher"` value
   matches, or as a new array element if it doesn't) — the pre-existing
   entry survives unchanged.
2. **Given** the same starting state, **When** the installer runs a
   second time immediately after, **Then** no duplicate entry is
   added — matching `merge_pretooluse_hooks()`'s own existing
   content-comparison dedup approach.

---

### User Story 2 - Object-shaped existing keys keep today's conservative behavior (Priority: P2)

Four of `merge_json_key()`'s five real call sites use an object-shaped
top-level value, not an array: gemini-cli/antigravity's `"hooks"`
(`{"BeforeTool": [...]}`), opencode's `"permission"`
(`{"bash": {...}, "read": {...}}`), and zed's `"agent"`
(`{"tool_permissions": {"terminal": {...}}}`) — three genuinely
different object shapes, each requiring real per-harness semantic
knowledge to merge correctly that this feature does not have grounded
confirmation for (unlike `"Stop"`'s array shape, which directly reuses
specs/061's already-proven, already-shipped merge logic). This story
confirms those four keep today's exact existing "leave as-is" message
and behavior, unchanged — this feature does not attempt an ungrounded
object merge.

**Why this priority**: Lower priority than Story 1 because it's a
scope boundary, not new behavior — but it's what keeps this feature
honest about what it actually fixes versus what still needs its own,
separately-grounded feature later.

**Independent Test**: Given a target with an existing `"permission"` key
(opencode) or `"agent"` key (zed) or `"hooks"` key (gemini-cli/
antigravity), running the installer produces today's exact existing
"already has this key — leaving as-is" message, unchanged — no merge
attempted for these four.

**Acceptance Scenarios**:

1. **Given** a target `opencode.json` with an existing `"permission"`
   key, **When** the installer runs, **Then** it prints today's exact
   existing message and does not modify the file — matching current
   behavior precisely.

---

### Edge Cases

- What happens when the existing key's value is genuinely malformed
  JSON (unbalanced braces, truncated)? Same discipline
  `merge_pretooluse_hooks()` already established (specs/061): fail
  loudly and explicitly, never attempt a guessed insertion.
- What happens when the existing key's value IS an array, but the new
  block's own top-level shape is NOT an array (a mismatch that
  shouldn't occur given today's five known call sites, but a future
  caller could introduce one)? Fall back to today's exact existing
  "leave as-is" message — a shape mismatch is exactly the kind of case
  this feature must not guess through.
- What happens to the `.gemini/settings.json`/`.agents/hooks.json`/
  `opencode.json`/`.zed/settings.json` cases specifically? Explicitly
  out of scope per Story 2 — a future feature could extend array-merge
  logic to whichever of their own nested sub-structures are genuinely
  array-shaped (e.g. gemini-cli's `hooks.BeforeTool` array specifically,
  not the whole `"hooks"` object), but that requires its own grounded
  investigation per harness, not a blanket assumption here.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `merge_json_key()` (`scripts/install.sh`) and
  `Merge-JsonKey` (`scripts/install.ps1`) MUST detect, when the target's
  raw content already contains the given key name, whether that key's
  actual JSON value is an array.
- **FR-002**: When the existing key's value is an array AND the new
  block's own top-level value is also an array, `merge_json_key()`/
  `Merge-JsonKey` MUST merge the new block's array items into the
  existing array — reusing `merge_pretooluse_hooks()`/
  `Merge-PreToolUseHooks`'s own proven parse-merge-write approach
  (specs/061: `json.load`/`json.dump` on the bash side,
  `ConvertFrom-Json`/`ConvertTo-Json` on the PowerShell side) and its
  own content-comparison deduplication logic, rather than a new,
  parallel implementation.
- **FR-003**: When the existing key's value is NOT an array (an object,
  scalar, or any other shape), `merge_json_key()`/`Merge-JsonKey` MUST
  print today's exact existing "already has this key — leaving as-is"
  message and MUST NOT attempt a merge — this covers all four
  non-`"Stop"` call sites (Story 2) and any future object-shaped caller.
- **FR-004**: If the existing key's value cannot be parsed as valid
  JSON, `merge_json_key()`/`Merge-JsonKey` MUST fail explicitly with a
  clear message naming the file and the problem — never attempt a
  guessed insertion, matching FR-006 of specs/061's own identical
  precedent.
- **FR-005**: This feature MUST NOT change behavior for any target
  where the key does not already exist — `merge_json_key()`'s own
  existing "key doesn't exist yet, write the whole block" path (today's
  lines 1053-1057 in `install.sh`) is unaffected.
- **FR-006**: `merge_json_key()`'s own five real call sites (`"Stop"`,
  `"hooks"` ×2, `"permission"`, `"agent"`) all continue to work
  unchanged for their non-array-merge cases — this feature only adds a
  new branch for the array-shaped case, it does not alter the
  function's existing signature or any caller's own block content.

### Key Entities

- **Target key's existing value**: the JSON value already present under
  the given key name in the target file — this feature's central new
  detection point (array vs. not-array) that decides whether to merge
  or leave as-is.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Running the installer against a target with an existing
  `"Stop"` array missing the shareable hook results in that hook being
  merged in, in 100% of such runs — 0 "leaving as-is" messages for this
  specific, now-fixed case.
- **SC-002**: The four object-shaped call sites (Story 2) produce
  today's exact existing message and behavior, unchanged, in 100% of
  runs — 0 regressions to their current conservative behavior.
- **SC-003**: Running the installer twice in a row against the same
  array-merged target produces 0 duplicate entries on the second run.
- **SC-004**: A malformed existing key value produces an explicit
  failure, never a guessed insertion, in 100% of such cases.

## Assumptions

- This feature reuses `merge_pretooluse_hooks()`/
  `Merge-PreToolUseHooks`'s own already-shipped, already-tested
  parse/merge/write mechanism (specs/061) rather than writing a second,
  parallel JSON-merge implementation — the array-merge logic itself is
  the same problem this feature just solved for `PreToolUse`
  specifically, now generalized to `merge_json_key()`'s own broader,
  multi-key surface.
- The four object-shaped call sites (gemini-cli/antigravity `"hooks"`,
  opencode `"permission"`, zed `"agent"`) are explicitly out of scope —
  a future feature extending array-merge logic to their own nested
  array sub-structures (not the whole object) would need its own
  grounded, per-harness investigation, not a blanket assumption made
  here.
- `install.ps1`'s own array-merge mechanism follows the same
  already-shipped `Merge-PreToolUseHooks` pattern (specs/061,
  `@()`-wrapping discipline to avoid PowerShell's single-element-array
  ConvertTo-Json collapse) — no new PowerShell-side design decision is
  needed here.

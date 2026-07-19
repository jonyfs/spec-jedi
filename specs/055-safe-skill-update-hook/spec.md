# Feature Specification: Interactive Update Prompt & Loss-Safe Skill Update

**Feature Branch**: `055-safe-skill-update-hook`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "crie um hook que ao iniciar o harness
verifique se tem uma nova versão da specjedi para instalar no projeto,
caso o usuário escolha sim, as skills specjedi devem ser atualizadas,
evitando perder contextos passados com a atualizacao e trazendo novos
updates do que o pacote de instalacao possui" (create a hook that, on
harness start, checks whether a newer Spec Jedi version is available to
install; if the user says yes, the specjedi skills should be updated,
avoiding losing past context during the update, and bringing in the new
updates the install package has).

Grounding read before drafting: the SessionStart version check this
request describes **already exists** — feature 042
(`specs/042-skill-freshness-validation`) shipped it. A direct read of
`scripts/session-start.sh`'s Part 4 confirms it queries the GitHub
Releases API and, when a newer release exists, emits a single
**informational** line: "Update available: X installed, Y published --
run scripts/bootstrap-install.sh/.ps1 to update." It does not ask a
yes/no question and does not trigger an update itself — the user must
run the script manually. Separately, a direct read of
`scripts/install.sh`'s actual skill-copy loop (the thing
`bootstrap-install.sh` eventually delegates to) found the real, current
risk this request's "evitando perder contextos passados" (avoiding
losing past context) is about:

```bash
rm -rf "${skills_dst:?}/$skill_name"
cp -R "$skill_path" "$skills_dst/$skill_name"
```

Every `specjedi-*` skill directory is deleted and replaced wholesale, on
every install/update run, with **zero check** for whether the
currently-installed copy differs from what the last install actually
placed there — a locally hand-edited skill file is silently destroyed
today, on a manually-triggered update just as much as a hypothetically
automated one. This is a real, pre-existing gap, not introduced by
making the check interactive. By contrast, `.specify/memory/
constitution.md` (the actual project constitution, distinct from the
generic `constitution-template.md`) and the harness memory file's
(`CLAUDE.md`) own non-managed content are already safe: the constitution
file is never touched by the install flow at all, and `CLAUDE.md` is
updated through an existing, safe, marker-delimited section
(`update_memory_file`, `install.sh`) that leaves everything outside the
markers untouched.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A locally-modified skill file is never silently destroyed by an update (Priority: P1)

Anyone running an install/update — today, manually via
`bootstrap-install.sh`/`.ps1`, or after User Story 2 ships, via an
interactive session-start prompt — expects that if they (or a prior
agent session) had modified a `specjedi-*` skill file locally, that
change survives, or is at least preserved somewhere findable, rather
than being silently overwritten with no trace.

**Why this priority**: This is a real, currently-existing risk
independent of whether the interactive trigger (User Story 2) ever
ships — today's manual `bootstrap-install.sh` run already has this exact
gap. Fixing it first makes User Story 2 safe to build on top of, rather
than making an already-silent risk easier to trigger with one keypress.

**Independent Test**: Given a project with a `specjedi-*` skill file
whose content has been locally modified since its last install, when an
update/install run replaces that skill directory, then the prior,
modified content is preserved somewhere recoverable (e.g. a timestamped
backup) — never silently gone with no trace.

**Acceptance Scenarios**:

1. **Given** a skill file identical to what the last install placed
   there, **When** an update replaces it with a newer release's version,
   **Then** it's replaced normally — nothing to preserve, no false
   warning.
2. **Given** a skill file that has been locally modified since the last
   install, **When** an update replaces its directory, **Then** the
   prior, modified version is preserved in a findable location before
   being overwritten.
3. **Given** a project running its very first install (no prior version
   recorded), **When** the skills are installed, **Then** no backup
   logic triggers at all — there's nothing prior to preserve.

---

### User Story 2 - The session-start freshness check becomes an actual yes/no prompt, not just information (Priority: P2)

A user sees today's existing "Update available" line at session start
but has to separately, manually run `bootstrap-install.sh`/`.ps1`
themselves. They want to be asked directly, and have a "yes" answer
actually perform the update in that same moment.

**Why this priority**: P2 — real, directly-requested value, but it
builds on User Story 1's safety fix; asking "update now?" and then
running an update that still has User Story 1's unresolved silent-
overwrite risk would be a net regression, not an improvement.

**Independent Test**: Given a newer release is detected (today's
existing feature 042 logic, unchanged), when the session-start
orientation renders, then the user is asked yes/no whether to update
now; given "yes," the existing update mechanism actually runs; given
"no," nothing changes and the project is left exactly as it was.

**Acceptance Scenarios**:

1. **Given** a newer release is detected, **When** the orientation
   renders, **Then** a yes/no question is presented — not just an
   informational line.
2. **Given** the user answers "yes," **When** that answer is processed,
   **Then** the existing `bootstrap-install.sh`/`.ps1` update mechanism
   actually runs (User Story 1's safety fix included), and the installed
   skill set matches the new release afterward.
3. **Given** the user answers "no," **When** that answer is processed,
   **Then** nothing on disk changes, and the same check simply runs
   again next session (today's existing feature 042 behavior, unchanged).

---

### User Story 3 - The prompt renders interactively, once that mechanism exists (Priority: P3)

Once feature 051 (interactive next-step selection) ships, this yes/no
question — being a genuine decision point at session start — should
render through that same harness-native, selectable mechanism, with its
own always-present "something else" escape option, rather than a
separately-invented interactive UI unique to this one prompt.

**Why this priority**: P3 — explicitly dependent on feature 051; adds
nothing beyond "apply the already-defined mechanism here too."

**Independent Test**: Given feature 051 has shipped, when this yes/no
prompt renders, then it follows feature 051's own
interactive-when-available/plain-text-fallback rule exactly.

**Acceptance Scenarios**:

1. **Given** feature 051 has not shipped, **When** the prompt renders,
   **Then** it's a plain yes/no text question — today's baseline,
   unchanged, never blocked on 051.
2. **Given** feature 051 has shipped, **When** the prompt renders,
   **Then** it uses that mechanism, including its own escape-hatch
   option for an answer other than yes/no.

### Edge Cases

- **What if the update check's network call fails or times out** (the
  GitHub API lookup already has documented retry/failure handling in
  `session-start.sh`, per feature 042)? This feature doesn't change that
  existing resilience — it only adds a prompt to the case where a newer
  version genuinely was found.
- **What if the user answers "yes" but the update itself fails partway**
  (network failure mid-download, a malformed release asset)? The
  existing `bootstrap-install.sh` failure modes (documented, honest
  error messages, non-zero exit) apply unchanged — this feature doesn't
  need to invent new update-failure handling, only trigger the existing
  mechanism.
- **What about `.specify/templates/*.md`** (also currently copied
  unconditionally by `install.sh`, the same overwrite pattern as skill
  files, just a different, less-commonly-hand-edited target)? See
  FR-008 — a genuine, undecided scope boundary.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Before an install/update run overwrites an
  already-installed `specjedi-*` skill directory, the mechanism MUST
  detect whether its current on-disk content differs from what the
  previously-recorded install actually placed there, and preserve the
  differing content (e.g. a timestamped backup) before overwriting —
  never a silent, untraceable loss.
- **FR-002**: The detection/preservation mechanism (a recorded
  per-release content hash, a git-diff-based check, or an unconditional
  backup-before-overwrite regardless of whether a real difference is
  detected) is a technical decision resolved during planning.
- **FR-003**: On a project's very first install (no prior release
  recorded), the backup/preservation logic MUST NOT trigger — there is
  nothing prior to preserve, and no false warning should appear.
- **FR-004**: The `SessionStart` hook's existing freshness check
  (feature 042) MUST be extended so that, when a newer release is
  detected, the user is asked directly whether to update now — replacing
  today's informational-only line, not duplicating it alongside a
  question.
- **FR-005**: A "yes" answer MUST actually invoke the existing update
  mechanism (`scripts/bootstrap-install.sh`/`.ps1`) — including FR-001's
  own safety fix — rather than merely repeating today's manual
  instruction.
- **FR-006**: A "no" answer MUST leave the project entirely unchanged —
  no partial update, no forced retry beyond feature 042's own existing
  re-check next session.
- **FR-007**: How this yes/no prompt renders — a selectable interactive
  list versus plain yes/no text — is governed by feature 051's own
  interactive-next-step-selection mechanism once it ships (a stated
  dependency, not reinvented here); until then, a plain text prompt is
  the baseline, and this feature MUST NOT be blocked on feature 051's
  own completion.
- **FR-008**: Whether `.specify/templates/*.md` (currently also
  unconditionally overwritten by `install.sh`, the same risk class as
  skill files but a different, less-commonly-hand-edited target) is
  also in scope for FR-001's preservation guarantee, or whether this
  feature's scope is strictly the `specjedi-*` skill directories the
  request literally named, is [NEEDS CLARIFICATION: the user's own
  wording says "as skills specjedi devem ser atualizadas" (the specjedi
  skills should be updated) specifically; templates share the identical
  overwrite pattern and risk class but weren't named directly — a real
  scope call, not a safe guess either way, since including them
  meaningfully broadens FR-001's own implementation surface].
- **FR-009**: Confirmed already out of this feature's risk surface, and
  MUST NOT regress: `.specify/memory/constitution.md` (never touched by
  the install flow today) and `CLAUDE.md`'s own non-managed content
  (already protected by the existing marker-delimited
  `update_memory_file` mechanism) both stay exactly as safe as they are
  today.

### Key Entities

*(Not applicable — this feature changes install-time file-handling
behavior and adds a prompt; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An update run against a project with at least one
  locally-modified `specjedi-*` skill file preserves that modification
  somewhere findable — verifiable by diffing the preserved copy against
  the pre-update file.
- **SC-002**: A first-ever install (no prior release recorded) triggers
  zero backup/preservation warnings — verifiable by inspecting the
  install run's own output.
- **SC-003**: When a newer release is detected at session start, the
  user is asked directly (not just informed) — verifiable by inspecting
  the rendered orientation output.
- **SC-004**: A "yes" answer results in the installed skill set actually
  matching the new release's own shipped content afterward — verifiable
  by comparing installed files against the release's own files.
- **SC-005**: `.specify/memory/constitution.md` and `CLAUDE.md`'s own
  non-managed content remain byte-for-byte unchanged after an update run
  — verifiable via diff before/after.

## Assumptions

- The existing `session-start.sh`/`.ps1` freshness check (feature 042)
  and its GitHub Releases API lookup, including its retry/failure
  handling, are reused entirely unchanged — this feature only adds a
  prompt to the "a newer release was found" case, never re-implements
  the detection itself.
- "Contextos passados" (past context) is interpreted as
  locally-modified project files at risk of silent loss during an
  update — specifically `specjedi-*` skill directories (User Story
  1/FR-001) — not conversation/session memory (e.g. `.remember/` files,
  `claude-mem` plugin data), which the existing install mechanism never
  touches today and is therefore already outside this feature's risk
  surface.
- Feature 051's interactive-selection mechanism is a dependency for this
  feature's own prompt-rendering polish (User Story 3) only; User
  Stories 1 and 2 (the safety fix and the basic yes/no interactivity)
  ship independently using today's plain-text prompt baseline.

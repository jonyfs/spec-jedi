# Feature Specification: Session-Start Orientation Hook

**Feature Branch**: `015-session-start-hook`

**Created**: 2026-07-12

**Status**: Draft

**Input**: User description: "Build the SessionStart hook mechanism required by Constitution Principle XXI (Session-Start Orientation & the Master Yoda Greeting): a hook script that gathers a project status summary (reusing specjedi-status's existing on-disk-artifact derivation logic, not a second tracking system), selects a rotating Master Yoda-styled greeting line from references/star-wars-lexicon.md, and an original ASCII Spec Jedi banner (never a reproduction of GitHub's actual spec-kit logo or any real trademark) -- emitted as SessionStart hookSpecificOutput.additionalContext per Claude Code's real hook mechanism, plus the CLAUDE.md render instruction required to make the agent actually display it as its opening reply (a hook alone does not satisfy Principle XXI). Requires genuine Principle II competitive research: does any of the 10 already-researched SDD tools (BMAD-METHOD, OpenSpec, Kiro, Tessl, Spec Kitty, Superpowers, GSD, PRP, Traycer, codemyspec.com) or spec-kit itself already do a session-start status/greeting hook, and what would Spec Jedi's version genuinely contribute beyond that."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Returning contributor sees exactly what's changed (Priority: P1)

A contributor opens Claude Code in this project after time away (a day, a
week). Instead of a blank prompt, their very first message from the
assistant already states which features exist, what's in progress, and
what's complete — without them having to ask or run `specjedi-status`
themselves.

**Why this priority**: This is the actual value proposition — a session
that starts with orientation instead of silence saves the "wait, where
was I?" round-trip every single session, not just occasionally.

**Independent Test**: Start a fresh Claude Code session in this repo;
confirm the assistant's opening reply states a concrete, on-disk-derived
project status (matching what `specjedi-status` would independently
report) without the user asking for it first.

**Acceptance Scenarios**:

1. **Given** a project with several `specs/NNN-*/` features in mixed
   states (some complete, some in progress), **When** a new Claude Code
   session starts, **Then** the assistant's first reply states an
   accurate status summary sourced from those actual on-disk artifacts.
2. **Given** the same status logic `specjedi-status` already implements,
   **When** the session-start summary and a manually-run `specjedi-status`
   are compared for the same repo state, **Then** they agree — no second,
   independently-derived tracking mechanism exists.

---

### User Story 2 - A recognizable, in-voice greeting on every session (Priority: P2)

A contributor who works in this repo regularly wants each session to
feel like this specific project, not a generic assistant — an ASCII
banner and a Master Yoda-styled line, not the same one every time.

**Why this priority**: Reinforces the project's established brand
identity (Principle XII) at the one moment — session start — that
happens literally every time someone opens the tool; a distinctive
greeting is cheap to deliver and reinforces recognition each time.

**Independent Test**: Start several fresh sessions in a row; confirm an
ASCII banner and a Yoda-styled line appear each time, and the Yoda line
is not identical across all of them.

**Acceptance Scenarios**:

1. **Given** a fresh Claude Code session, **When** it starts, **Then**
   the assistant's opening reply includes an ASCII Spec Jedi banner that
   is an original wordmark/lightsaber rendering, not a reproduction of
   GitHub's actual `spec-kit` logo or any other real trademark.
2. **Given** three consecutive fresh sessions, **When** their opening
   replies are compared, **Then** the Master Yoda line is not identical
   across all three (rotation, not a single hardcoded string).
3. **Given** a reader with zero Star Wars knowledge, **When** they read
   the Yoda line, **Then** its core meaning is still understandable
   (Principle XII's core rule, inherited by Principle XXI).

---

### User Story 3 - The hook alone isn't enough; rendering is verified end-to-end (Priority: P1)

A maintainer wants confidence that this feature actually displays
something to the user, not just that a hook script runs and produces
JSON nobody sees — because Claude Code's `SessionStart` hook stdout
becomes agent context, not a direct terminal print.

**Why this priority**: This is the single most likely way this feature
silently fails to deliver value — a working hook script that produces
correct `additionalContext` but is never rendered is functionally
equivalent to no feature at all. Principle XXI itself calls this out
explicitly as the two-part contract (hook + render instruction).

**Independent Test**: With the hook and `CLAUDE.md` instruction both in
place, start a real fresh session and confirm the greeting content is
visibly rendered in the assistant's first reply, not merely present in
the hook's own stdout/logs.

**Acceptance Scenarios**:

1. **Given** the hook is registered in `.claude/settings.json` and
   `CLAUDE.md` carries the render instruction, **When** a fresh session
   starts, **Then** the banner, status summary, and Yoda line are all
   visible in the assistant's actual first chat message — verified by
   starting a real session, not by inspecting the hook script alone.
2. **Given** the hook script is temporarily broken (non-zero exit or
   malformed JSON), **When** a session starts, **Then** the session still
   starts normally (graceful degradation) rather than blocking the user
   from working.

### Edge Cases

- What happens on a session **resume** rather than a fresh start (Claude
  Code's `SessionStart` fires with `source: "resume"` too)? The
  orientation MAY still fire (refreshing status is harmless and
  potentially useful after a resume), but MUST NOT re-render if it would
  duplicate content already visible earlier in the same transcript —
  resolved via Clarification below.
- What happens in a project with zero `specs/NNN-*/` directories yet (a
  brand-new, not-yet-onboarded project)? The status summary MUST report
  "no features yet" plainly (matching `specjedi-status`'s own existing
  zero-state handling) rather than erroring or showing an empty table.
- What happens if `references/star-wars-lexicon.md`'s Master Yoda
  Persona section is missing or unreadable (e.g., a stripped-down
  install that didn't copy `references/`)? The hook MUST degrade
  gracefully — status summary still renders, greeting line falls back to
  a plain "Welcome back" rather than failing the whole orientation.
- What happens if the hook's derived status content would exceed the
  10,000-character `additionalContext` cap on a very large project (many
  features)? The summary MUST stay a *summary* (counts and highlights,
  not a full per-feature table) — full detail remains `specjedi-status`'s
  job, on demand.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The project MUST ship a `SessionStart` hook script (with a
  `.ps1` counterpart per Principle XIII) registered in
  `.claude/settings.json`.
- **FR-002**: The hook MUST derive its project status summary using the
  same on-disk-artifact logic `specjedi-status` already implements
  (`specs/NNN-*/` presence, `spec.md`/`plan.md`/`tasks.md` state, checkbox
  completion) — no second, independently-maintained tracking mechanism.
- **FR-003**: The hook MUST emit its output via
  `hookSpecificOutput.additionalContext` (or plain stdout, per Claude
  Code's supported SessionStart format), staying under the 10,000-
  character cap.
- **FR-004**: The hook output MUST include: an ASCII Spec Jedi banner
  (original wordmark/lightsaber art, never a reproduction of a real
  trademark), a project status summary (FR-002), and one Master
  Yoda-styled line selected from `references/star-wars-lexicon.md`'s
  rotation pool.
- **FR-005**: The Yoda line selection MUST rotate rather than always
  return the same line — selection MUST NOT require external state
  beyond what's cheaply available at hook-run time (e.g., a
  session/timestamp-derived pseudo-random pick is acceptable; no new
  persistent "last shown" tracking file is required).
- **FR-006**: `CLAUDE.md` MUST carry an explicit instruction telling the
  agent to render the `SessionStart` `additionalContext` block verbatim
  as its opening reply when present — per Principle XXI, the hook alone
  does not satisfy the requirement.
- **FR-007**: The hook MUST degrade gracefully: a missing/unreadable
  `references/star-wars-lexicon.md`, a project with zero features, or an
  unexpected error MUST NOT prevent the session from starting normally —
  worst case is a shorter or plainer greeting, never a blocked session.
- **FR-008**: The hook MUST run fast (Claude Code's own SessionStart
  performance guidance) — status derivation reuses existing lightweight
  file-presence/checkbox-counting logic, not an expensive scan.

### Key Entities

- **Session Orientation Payload**: the combined banner + status summary
  + Yoda line text emitted as `additionalContext` — ephemeral, generated
  fresh each session, never persisted.
- **Yoda Line Rotation Pool**: the existing set of lines in
  `references/star-wars-lexicon.md`'s Master Yoda Persona section
  (already shipped in constitution v1.20.0) — this feature selects from
  it, does not redefine it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A fresh Claude Code session in this repo shows an accurate,
  on-disk-derived project status in the assistant's first reply, with no
  user action required to request it.
- **SC-002**: Across 5 consecutive fresh sessions, the Yoda greeting line
  is not identical in all 5 (observable rotation).
- **SC-003**: The mechanism is verified end-to-end at least once via an
  actual fresh session start (not just static inspection of the hook
  script) before this feature is considered shipped.
- **SC-004**: A session starts successfully (not blocked) even when the
  hook script is deliberately made to fail, verified via a real
  dry-run test.

## Assumptions

- This feature targets the Claude Code harness specifically (the only
  harness this project fully supports today, per Principle III) — the
  `SessionStart` hook mechanism as documented is Claude-Code-specific;
  no equivalent is assumed or built for other harnesses in this pass.
- "Resume" sessions (`source: "resume"`) MAY re-fire the hook per Claude
  Code's own documented behavior; this feature accepts that as
  acceptable rather than building suppression logic to detect and skip
  resume-triggered re-renders, since Claude Code's own docs describe
  resume-refresh as expected hook behavior, not a bug to work around.
- The genuine-contribution claim and full competitor comparison are
  Principle II's responsibility, resolved in this feature's `research.md`
  during planning — not assumed here without that research actually
  happening.

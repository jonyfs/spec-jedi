# Feature Specification: SessionStart Orientation Gains a Next-Step Suggestion

**Feature Branch**: `054-sessionstart-interactive-next-steps`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "crie um hook que, ao iniciar o harness, já
exiba o status do projeto, mostrando quais seriam os proximos passos
usando specjedi, dando uma lista selecionável de opcoes para o usuário
clicar ou navegar com o teclado e dar enter, a ultima resposta sempre
deve ser uma opçao propria digitada pelo usuário que, ao pressionar
enter, será a opcao escolhida a ser executada" (create a hook that, when
the harness starts, already shows the project status and what the next
steps would be using specjedi, giving a selectable option list the user
can click or keyboard-navigate and press enter on; the last answer
should always be a custom option typed by the user, which becomes the
chosen action on enter).

Grounding read before drafting: Constitution Principle XXI already
specifies, precisely and factually (fetched and verified when that
principle was written, not assumed), that `SessionStart` is a
**hook-plus-agent-render contract** — the hook script's stdout becomes
`additionalContext` (capped at 10,000 characters); it is `CLAUDE.md`'s
own render instruction, not the hook itself, that makes the agent
actually display it. A shell script cannot itself invoke an interactive,
selectable-option UI tool — only the agent, on its next turn, can. A
direct read of `scripts/session-start.sh` confirms today's orientation
payload is banner + status-summary + Yoda line only — **zero next-step
suggestion of any kind exists in it today**, a genuine, concrete gap.
Separately, `specjedi-status` already computes, per feature, a status
(specified/planned/in-progress/complete) and its own Step 8 already
reasons about "whichever in-progress feature seems most relevant" to
suggest next — this is the exact logic this feature must reuse, per
Principle XXI's own existing "No parallel status system" rule (which
already governs the status-summary portion and extends naturally to a
next-step-suggestion portion). Feature 051 (not yet planned, still has
an open `NEEDS CLARIFICATION`) is what will define *how* any Principle
XIV next-step moment renders interactively across harnesses — this
feature is a direct, dependent consumer of that mechanism for one
specific moment (session start), not a second definition of it.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The session-opening orientation names an actual next step, not just a status count (Priority: P1)

A user starting a new session today sees a banner, a one-paragraph
project status summary (feature counts), and a Master Yoda greeting line
— but nothing telling them what to actually *do* next. They want the
orientation to also name a concrete, specific next action (e.g. "run
`specjedi-clarify` for feature 050"), reusing the same reasoning
`specjedi-status` already applies when asked for a dashboard.

**Why this priority**: This is the entire literally-new value here — a
real, currently-missing capability, not a hypothetical one. Everything
else in the request (interactive rendering) is about *how* this
suggestion is presented, which is a distinct, dependent concern (User
Story 2).

**Independent Test**: Given the current project's actual on-disk
`specs/` state, when a new session starts, then the rendered orientation
includes a specific next-step line naming a feature and a `specjedi-*`
skill — not a generic "keep working" statement, and not silently absent.

**Acceptance Scenarios**:

1. **Given** a project with at least one feature that is `specified`,
   `planned`, or partially `in progress` (this project's own actual
   state right now — several features are), **When** a session starts,
   **Then** the orientation names the specific feature and the specific
   `specjedi-*` skill that continues it.
2. **Given** a project with zero features under `specs/` (a brand-new
   project), **When** a session starts, **Then** the orientation
   suggests `specjedi-specify` — matching `specjedi-status`'s own
   existing empty-state behavior, never a bare status with no
   suggestion.
3. **Given** every existing feature is `complete` with nothing
   in-progress, **When** a session starts, **Then** the orientation
   says so plainly and suggests starting something new
   (`specjedi-specify`) rather than inventing a false "in progress" claim.

---

### User Story 2 - That suggestion renders interactively, once the mechanism for that exists (Priority: P2)

Once feature 051 (interactive next-step selection) ships, this
suggestion — being a genuine Constitution Principle XIV "next step"
moment like any other — should render through that same
harness-native, selectable mechanism, with the same universal
"type a different answer" escape hatch, rather than through a
second, separately-defined interactive UI unique to session start.

**Why this priority**: P2 — real value, but entirely dependent on
feature 051 landing first; this story adds nothing of its own beyond
"apply the already-defined mechanism here too."

**Independent Test**: Given feature 051 has shipped, when a session
starts and the orientation's next-step suggestion is rendered, then it
follows feature 051's own interactive-when-available/plain-list-
fallback rule exactly, including its own always-present
different-answer option.

**Acceptance Scenarios**:

1. **Given** feature 051 has not yet shipped, **When** a session starts,
   **Then** the next-step suggestion still renders as today's existing
   plain bulleted-list convention (Principle XIV baseline) — this
   feature is never blocked on 051's own completion.
2. **Given** feature 051 has shipped and the current harness supports
   its interactive mechanism, **When** a session starts, **Then** the
   suggestion renders through that mechanism, with a distinct option
   always present for a different, user-typed answer.

### Edge Cases

- **What if several features are simultaneously actionable at once**
  (this project's own real state today — multiple features mid-pipeline
  in parallel)? The suggestion must name the single one
  `specjedi-status`'s own Step 8 reasoning would judge "most relevant"
  (not necessarily the most recent), explicitly reasoned about, not
  picked arbitrarily — and may name more than one candidate if genuinely
  tied, matching `specjedi-status`'s own established discipline for this
  same judgment call.
- **What about the 10,000-character `additionalContext` cap** (a
  verified fact from Principle XXI's own text, not assumed)? The added
  next-step content MUST fit within that shared budget alongside the
  existing banner/status-summary/Yoda-line trio — this is a real,
  concrete constraint on how much can be added, not a hypothetical one.
- **What if the hook script cannot literally invoke `specjedi-status`
  itself** (a hook is a shell script; a skill is markdown content an
  LLM agent interprets — a shell script has no mechanism to invoke an
  LLM skill)? See Assumptions — this feature follows the exact same
  precedent Principle XXI's own status-summary portion already
  established: a bash/PowerShell reimplementation of the same
  status/next-step rule, not a literal skill invocation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `SessionStart` orientation payload (Constitution
  Principle XXI) MUST gain one additional element — a concrete
  next-step suggestion — alongside the existing banner, status-summary,
  and Yoda-line trio.
- **FR-002**: The next-step suggestion MUST be derived using the same
  status-derivation and "most relevant" next-step reasoning
  `specjedi-status`'s own Step 8 already applies — never a second,
  separately-maintained "what's next" computation (Principle II,
  extending Principle XXI's own existing "No parallel status system"
  rule to this new element).
- **FR-003**: When multiple features are simultaneously actionable, the
  suggestion MUST name the specific feature(s) and skill(s) involved —
  never a vague, feature-less suggestion — reasoning explicitly about
  relevance the same way `specjedi-status` already does, rather than
  picking arbitrarily (e.g., most-recently-touched by default).
- **FR-004**: How this suggestion renders as a selectable, interactive
  list versus plain bulleted markdown is entirely governed by feature
  051's own interactive-next-step-selection mechanism, including its
  own mandatory different-answer escape hatch — this feature MUST NOT
  define a second, separate rendering mechanism for this one moment.
- **FR-005**: Until feature 051 ships, this feature's own next-step
  suggestion MUST still render using today's existing plain
  bulleted-list convention (Principle XIV baseline) — this feature MUST
  NOT be blocked on feature 051's own completion.
- **FR-006**: The added next-step content MUST fit within Claude Code's
  own 10,000-character `additionalContext` cap alongside the existing
  banner/status-summary/Yoda-line content — verified, not assumed
  (Principle XXI's own documented fact).

### Key Entities

*(Not applicable — this feature adds a computed suggestion to an
existing orientation payload; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A fresh session's rendered orientation includes a
  specific, named next-step suggestion in addition to today's three
  elements — verifiable by inspecting the rendered opening reply.
- **SC-002**: The suggestion names a specific feature and a specific
  `specjedi-*` skill — never a vague "keep working" statement —
  verifiable by inspecting the suggestion text against the project's
  own actual `specs/` state at that moment.
- **SC-003**: Before feature 051 ships (or on any harness without its
  mechanism), the suggestion renders as a plain bulleted list, unchanged
  from today's Principle XIV baseline — verifiable by comparing rendered
  output.
- **SC-004**: The combined orientation payload (banner + status +
  Yoda line + next-step suggestion) stays under the 10,000-character
  `additionalContext` cap — verifiable by measuring the hook's own
  stdout length.

## Assumptions

- Matching Principle XXI's own already-established precedent for the
  status-summary portion (a bash/PowerShell reimplementation of
  `specjedi-status`'s counting rules, not a literal skill invocation,
  since a shell script cannot invoke an LLM-interpreted skill), this
  feature's own next-step-suggestion computation follows the identical
  pattern: the hook script reimplements `specjedi-status`'s own Step 8
  "most relevant next step" rule in bash/PowerShell, kept in sync with
  that skill's own logic by the same discipline Principle XXI's status
  portion already relies on — not resolved as a `NEEDS CLARIFICATION`
  because a directly-applicable precedent already exists in this
  project's own constitution.
- This feature has a hard sequencing dependency on feature 051 for its
  own User Story 2 (interactive rendering) — User Story 1 (the
  suggestion's existence and content) does not depend on 051 and can
  ship independently, rendering through today's plain-list baseline in
  the meantime.
- Scope is the `SessionStart` orientation moment only; this feature does
  not change `specjedi-status`'s own on-demand dashboard behavior, only
  reuses its reasoning.

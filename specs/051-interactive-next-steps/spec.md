# Feature Specification: Interactive Next-Step Selection for `specjedi-*` Skills

**Feature Branch**: `051-interactive-next-steps`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "faça com que as skill specjedi sempre
informem os proximos passos de forma interativa, dando uma lista de
opcoes para que o usuário possa clicar ou navegar no harness para
selecionar a opcão e digitar enter. Sempre as respostas devem ser neste
formato, sempre deixe a ultima opçao caso o usuário queira dar uma outra
resposta diferente das apresentadas" (make specjedi skills always report
next steps interactively — a list of options the user can click or
arrow-navigate and press enter to select; answers should always be in
this format, and the last option should always be reserved for a
different answer than the ones presented).

Grounding read before drafting: Constitution Principle XIV (Guided
Next-Step Suggestion) already mandates every `specjedi-*` skill end a
meaningful stopping point with "the next step(s) as a short, selectable
bulleted list" — today that's always plain markdown text the user reads
and replies to by typing. Principle III (Universal LLM & Harness
Compatibility) simultaneously requires every skill be "written against
the lowest common denominator of agent capability... no assumptions of
a specific proprietary tool schema, with harness-specific adapters
layered on top — never the reverse," across a documented 20+-harness
compatibility matrix. This request sits exactly at that boundary: an
interactive, clickable/arrow-navigable choice mechanism is a real
capability in some harnesses (e.g. Claude Code's own structured-choice
tool) but not a universal one, so it can only ever be a layered
enhancement over Principle XIV's existing plain-list baseline, never a
replacement for it.

## Clarifications

### Session 2026-07-18

- Q: Should the interactive-selection convention also extend to
  `specjedi-clarify`'s own separate, pre-existing Recommended-option/
  lettered-table question format (FR-006), or stay scoped strictly to
  Principle XIV Next-Step Suggestion moments? → A: Stay scoped to
  Principle XIV Next-Step moments only (User Stories 1-2). The user's
  own request wording names "próximos passos" (next steps) specifically,
  which maps directly to Principle XIV; `specjedi-clarify`'s own format
  serves a deliberately different purpose (structured ambiguity
  resolution with reasoning shown, not a next-pipeline-stage picker) and
  conflating the two risks diluting that skill's own carefully-designed
  convention. Extending to `specjedi-clarify` is left as a candidate for
  a future, separate feature if wanted later — not decided here.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Pick the next step without typing, when the harness supports it (Priority: P1)

A user who just finished an interaction with a `specjedi-*` skill sees
its Next-Step suggestion and, on a harness that offers a native
structured-choice mechanism, can select one of the offered next actions
by clicking or arrow-navigating and pressing enter — instead of reading
a bulleted list and composing a new typed command from scratch. On a
harness with no such mechanism, nothing changes: the same short bulleted
markdown list Principle XIV already produces today still appears,
exactly as before.

**Why this priority**: This is the entire directly-requested capability
— without it, nothing is different from today. The fallback half is
inseparable from it (Principle III leaves no other option), so both are
verified together as one story rather than split into a "real" story
and an "obligatory constraint" story.

**Independent Test**: Given a `specjedi-*` skill reaching a genuine
Next-Step Suggestion moment (Principle XIV), when the current session
exposes a harness-native structured-choice mechanism, then the offered
next steps render through that mechanism, each independently selectable
by click or arrow-key-plus-enter; when no such mechanism is exposed,
then the existing plain bulleted markdown list appears unchanged.

**Acceptance Scenarios**:

1. **Given** a harness session with a structured-choice mechanism
   available, **When** a `specjedi-*` skill reaches its Next-Step
   Suggestion, **Then** the options render through that mechanism as a
   selectable list, not as plain, must-be-typed-back markdown.
2. **Given** a harness session with no such mechanism available,
   **When** the same skill reaches the same moment, **Then** the
   existing short bulleted markdown list (today's Principle XIV
   baseline) appears exactly as it does today — no missing step, no
   broken formatting, no error.
3. **Given** an interactive selection is presented, **When** the user
   wants an answer that isn't among the listed next steps, **Then** a
   distinct, clearly-labeled option for supplying a different answer is
   always present and selectable — never a closed list with no escape.

---

### User Story 2 - Every skill behaves the same way, not just a pilot few (Priority: P2)

A maintainer doesn't want the experience to depend on which specific
`specjedi-*` skill they happen to be using — every skill that currently
ends with a Principle XIV Next-Step Suggestion should follow the exact
same interactive-when-available/plain-list-fallback rule, not a subset
that got updated and a remainder that didn't.

**Why this priority**: P2 — a consistency/completeness pass on top of
User Story 1's mechanism, not a new capability of its own. Every
`specjedi-*` skill already independently states its own Next-Step
instruction inline (there is no single shared reference file all of
them point to today), so this is the "did we actually apply it
everywhere" check.

**Independent Test**: Sample at least one skill from each of the four
cataloged disciplines (Core Pipeline, Onboarding & Guidance, Quality &
Review, Meta & Tooling — `references/quickstart-guide.md`'s own
categorization) and confirm each one's own Next-Step instruction
reflects the same rule from User Story 1, worded consistently.

**Acceptance Scenarios**:

1. **Given** the full currently-shipped `specjedi-*` catalog, **When**
   each skill's own Next-Step Suggestion instruction is checked,
   **Then** every one states the same interactive-when-available rule
   and the same plain-list fallback — none silently left on the old
   text while others were updated.

---

### User Story 3 - Extending the same convention to other in-pipeline choice moments (Descoped)

**Resolved by the 2026-07-18 Clarification above**: out of scope for
this feature. `specjedi-clarify`'s own existing Recommended-option/
lettered-table question format continues unchanged — this feature's
scope is Principle XIV Next-Step Suggestion moments only (User Stories
1-2). Retained here only as a record of the question considered and
its resolution, not as an active story to implement.

### Edge Cases

- **What if a Next-Step Suggestion has only one real option (no actual
  choice to make)?** Still worth surfacing through the interactive
  mechanism when available (the user still confirms by
  selecting/pressing enter rather than typing), but the "different
  answer" escape option (Acceptance Scenario 3, User Story 1) still
  applies — a single-option list is never presented as if no other
  answer were possible.
- **What if the harness's structured-choice mechanism has its own limit
  on the number of listed options** (e.g. a maximum option count)?
  Principle XIV's own "short" qualifier already keeps next-step lists
  small in practice; this feature doesn't need a new truncation rule
  beyond what's already true today.
- **What if a skill offers next steps that are conceptually two
  different questions bundled together** (e.g. "run X, or Y, or ask Z
  first")? Out of scope to redesign that bundling — this feature
  changes *how* an already-decided option list is presented, not what
  options a skill chooses to offer.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every `specjedi-*` skill's own Next-Step Suggestion moment
  (Constitution Principle XIV) MUST offer its option list through the
  current session's harness-native structured-choice mechanism when one
  is available, so the user can select by pointing/navigating and
  confirming rather than only reading plain text and typing a reply.
- **FR-002**: When no such mechanism is available in the current
  session, the Next-Step Suggestion MUST render as the existing short
  bulleted markdown list (today's Principle XIV baseline) — unchanged,
  never broken, never silently omitted.
- **FR-003**: Whenever the structured-choice mechanism is used, the
  presented option set MUST always include a distinct, clearly-labeled
  way for the user to supply an answer that isn't among the listed
  options.
- **FR-004**: This behavior MUST apply consistently across every
  currently-shipped `specjedi-*` skill's own Next-Step Suggestion moment
  — not a subset of skills, per User Story 2.
- **FR-005**: Skill content MUST NOT hard-code a call to one specific
  proprietary tool by name as the only supported path — the instruction
  MUST be phrased so it degrades to FR-002's fallback on any harness
  without an equivalent structured-choice capability (Constitution
  Principle III's own lowest-common-denominator requirement).
- **FR-006**: This interactive-selection convention is scoped strictly
  to Principle XIV Next-Step Suggestion moments (User Stories 1-2) —
  `specjedi-clarify`'s own separate, pre-existing Recommended-option/
  lettered-table question format is explicitly out of scope and MUST
  remain unchanged (resolved by the 2026-07-18 Clarification above).
- **FR-007**: Whether this ships as a single shared reference document
  all `specjedi-*` skills point to for this convention, or as
  consistent inline instruction text duplicated per-skill (today, each
  skill states its own Next-Step instruction independently, with no
  shared reference file), is a technical decision resolved during
  planning — matching this project's own established precedent for
  exactly this kind of "new shared mechanism vs. per-skill duplication"
  question (specs/043 Decision 1; specs/049 Decision 1).

### Key Entities

*(Not applicable — this feature changes how an already-decided option
list is presented; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of currently-shipped `specjedi-*` skills' own
  Next-Step Suggestion instructions state the same
  interactive-when-available/plain-list-fallback rule — verifiable by
  reviewing every skill's own instruction text for this exact rule.
- **SC-002**: On a harness session with no structured-choice mechanism,
  next-step behavior is unchanged from today's baseline — verifiable by
  comparing rendered output before and after this feature ships.
- **SC-003**: Every interactive next-step presentation includes a
  distinct "different answer" option — verifiable by construction
  (FR-003), checkable against any live rendering.
- **SC-004**: Zero skill's own shipped instruction text hard-codes a
  single, named proprietary tool as the only mandatory path — verifiable
  by reviewing the instruction wording directly (FR-005).

## Assumptions

- Constitution Principle III (harness-agnostic, lowest-common-denominator
  skill content) takes precedence wherever this feature and that
  principle could conflict — this feature is additive/layered only,
  never a replacement requirement, matching the principle's own
  explicit "adapters layered on top — never the reverse" language.
- "Harness-native structured-choice mechanism" means whatever tool the
  executing agent/harness already exposes for offering the user a
  selectable set of options with an escape hatch for a different answer
  (e.g. Claude Code's own such tool) — this feature doesn't invent a new
  interaction mechanism, it conditionally uses whatever the current
  session already provides.
- Scope is Principle XIV's own "next step" moments across the
  `specjedi-*` catalog (User Stories 1-2) only; `specjedi-clarify`'s own
  separate, already-existing question-asking format is explicitly out
  of scope per the 2026-07-18 Clarification (FR-006).
- No new project structure, script, or CI job is implied by this
  feature on its face — it changes existing skills' own instruction
  text; whether that requires a new shared reference document (FR-007)
  is resolved during planning.

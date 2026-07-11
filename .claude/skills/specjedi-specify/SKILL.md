---
name: specjedi-specify
description: Turns a feature idea — however rough — into a prioritized, independently-testable spec.md. Triggers on "spec out X," "I want to build X," "let's plan a feature for X," or any request to formalize what to build before how to build it. Welcomes a one-sentence starting point; doesn't require a fully-formed feature description.
compatibility: No external dependencies. Reads `.specify/memory/constitution.md` if present (for context, not a hard requirement); writes `specs/NNN-feature-name/spec.md`.
---

# 🎯 Spec Jedi Specify

**Persona**: a collaborator who's glad to start from a rough idea — not a form
that rejects incomplete input. Shape the idea into something testable; don't
wait for the user to arrive with a finished spec already in their head.

**Task**: turn a feature description (one sentence is enough to start) into a
`spec.md` with prioritized (P1/P2/P3...), independently-testable user stories,
functional requirements, and success criteria — per
`.specify/templates/spec-template.md`.

## When this runs

Any time the user wants to formalize a feature idea before diving into
implementation — including a genuinely rough, one-line starting point. If
`.specify/memory/constitution.md` exists (from `specjedi-constitution` or a
`speckit-*` bootstrap run), read it for context; proceed without one if it
doesn't exist yet, but suggest running `specjedi-constitution` first as the
next step once the spec is done.

## Steps

1. **Understand the idea.** If it's already detailed, extract the shape
   directly. If it's rough, ask what problem it solves and for whom — don't
   demand a fully-formed description before starting.
2. **Break it into user stories**, each assigned a priority (P1 = most
   critical). Reason through the priority order explicitly: which story
   alone would still deliver real, demonstrable value if nothing else
   shipped? That's P1. This is a judgment call, not a default ordering by
   the order ideas were mentioned.
3. **Write acceptance scenarios** (Given/When/Then) and an independent test
   for each story — one that doesn't require any other story to exist.
4. **Extract functional requirements.** For anything genuinely unclear —
   not inferable from context or reasonable default — mark it
   `NEEDS CLARIFICATION: <specific question>` inline rather than guessing.
   Don't invent detail that wasn't given and isn't a safe default.
5. **Define measurable success criteria** — technology-agnostic, numeric or
   otherwise checkable, never "the system should work well."
6. **Offer the next step(s) as a short bulleted list** (Principle XIV): if
   any `NEEDS CLARIFICATION` markers remain, `specjedi-clarify` as the
   primary option; otherwise `specjedi-plan` to move to technical planning.

If the idea clearly needs domain expertise this skill doesn't have (e.g.,
"spec out a HIPAA-compliant intake flow" with no healthcare-domain skill
installed), self-invoke `specjedi-find-skills` before finishing
(Principle XVII).

## Autonomous vs. confirm-first

Drafting and writing `spec.md` is autonomous — that's the whole point of this
skill. What requires the user's input, not just their initial one-liner: any
`NEEDS CLARIFICATION` marker is a signal that a real decision is needed before
the spec can be trusted, not something to silently resolve with a guess.

## Format

`spec.md` follows `.specify/templates/spec-template.md`'s exact shape: `##
User Scenarios & Testing` (prioritized stories, each with Why/Independent
Test/Acceptance Scenarios), `### Edge Cases`, `## Requirements` (Functional
Requirements + Key Entities), `## Success Criteria` (Measurable Outcomes),
`## Assumptions`.

## Example (input → output)

**User**: *"I want users to be able to export their data as a CSV."*

**Output** (excerpt):
```markdown
### User Story 1 - Export data as CSV (Priority: P1)
A user with existing data wants a portable copy they can open in a
spreadsheet tool, without needing this product installed to view it.

**Why this priority**: The only story here — without it, there's no
feature. P1 by elimination as well as by value.

**Independent Test**: Given a user with existing data, when they trigger
export, then a valid CSV file downloads containing every record.

**Acceptance Scenarios**:
1. **Given** a user with 10 records, **When** they export, **Then** a CSV
   with 10 data rows plus a header downloads.
2. **Given** a user with zero records, **When** they export, **Then** a CSV
   with only the header downloads — not an error.

### Functional Requirements
- **FR-001**: System MUST generate a CSV containing every field visible to
  the exporting user.
- **FR-002**: System MUST include a header row.
- **FR-003**: System MUST handle the zero-records case without erroring
  [NEEDS CLARIFICATION: confirmed by Acceptance Scenario 2 above, not
  actually ambiguous — included here only to show the marker isn't needed
  once a scenario already answers it].
```

**Agent's chat narration** (Principle XII voice — the spec.md content above
stays plain; this is what the skill actually says around it):
> 🎯 Rebellions are built on hope — and so is every spec that starts as one
> rough sentence. One story, prioritized, testable, ready to build on.
>
> **Next step:**
> - Run `specjedi-plan` to turn this into a technical plan.

**Not this**: "The system should have a good export feature" — no
independent test, no acceptance scenario, nothing to build against.

## `--auto` mode

Ask only what's needed to identify P1 (the problem and who it's for); once
answered, draft the full spec including edge cases and requirements without
further stops, marking genuine ambiguity inline rather than pausing to ask.

## Always / Never

- **Always** mark real ambiguity `NEEDS CLARIFICATION` inline — never
  silently assume a detail that wasn't given.
- **Always** give each story an independent test that doesn't depend on
  another story existing.
- **Never** write a success criterion that can't be measured or checked.
- **Never** demand a fully-formed feature description before starting — a
  rough idea is a valid starting point.

## Verifiable success criteria

- Every user story has a stated priority, an independent test, and at least
  one Given/When/Then acceptance scenario.
- Every `NEEDS CLARIFICATION` marker names the specific question, not just
  "unclear."
- Zero success criteria use unmeasurable language ("fast," "user-friendly,"
  "robust") without a concrete number or check attached.

---
name: specjedi-diagram
description: Generates a render-verified Mermaid diagram (flowchart, sequence, or ER — inferred from content) from an existing spec.md/plan.md, presented as a supplement to the source prose, never a replacement. Triggers on a request for a diagram, visual, or flow chart of an existing feature.
compatibility: Render-verification uses the harness's Mermaid validation mechanism when available (this environment: mcp__claude_ai_Mermaid_Chart__validate_and_render_mermaid_diagram); falls back to an explicit unverified-caveat path when absent. Reads the target spec.md/plan.md; writes nothing by default.
---

# 📊 Spec Jedi Diagram

**Persona**: a careful cartographer — draws only what the territory (the
spec/plan) actually contains, and checks the map is legible before handing
it over.

**Task**: given a spec/plan and a request for a diagram, infer the right
diagram type from the actual content, generate Mermaid source grounded in
it, render-verify the result, and present it alongside the source prose.

## Step-by-step

1. **Read the source spec/plan.** Identify what it's actually describing:
   a sequence of prioritized stories or steps, a set of entities and their
   relationships, or an interaction between actors/systems over time.
2. **Infer the diagram type, reasoning through three signals
   explicitly** — every request, not just ambiguous ones: story/step
   sequence → flowchart; entities and relationships → ER diagram;
   actor/system interaction over time → sequence diagram. If two signals
   are comparably present with no clear majority, ask which type is
   wanted rather than guessing — even in `--auto` mode.
3. **Generate Mermaid source grounded in the actual content.** Every node
   and edge MUST trace to something the spec/plan actually states — the
   same "does this trace to the source" discipline `specjedi-checklist`
   applies to checklist items, applied here to diagram elements.
4. **Render-verify before presenting.** Run the generated source through
   the harness's Mermaid validation mechanism. If it fails, revise and
   re-check — never present a diagram known to be broken. If no
   verification mechanism is available in the current harness, state that
   plainly and offer the unverified source with an explicit caveat,
   rather than silently skipping the check.
5. **Present the diagram alongside the source prose** — a one-line note
   on the type chosen and why, the verification result, and the Mermaid
   source. Never a replacement for the prose itself (Principle XVI).
6. **Offer to write it into a target file only on explicit confirmation**
   (never silently) — inline presentation in the response is the default.
7. **Offer the next step(s) as a short bulleted list** (Principle XIV):
   revisit the source spec/plan if the diagram surfaced a gap, or continue
   with whatever pipeline stage comes next.

If the request needs a diagram grammar this skill doesn't cover (a Gantt
chart, an unusual state-machine notation), self-invoke
`specjedi-find-skills` rather than forcing an ill-fitting flowchart/
sequence/ER shape onto it (Principle XVII).

## Autonomous vs. confirm-first

Generating, render-verifying, and presenting the diagram inline is
autonomous — no separate "may I draw this?" prompt. What's not autonomous:
writing the diagram into a target file (step 6) — that always requires
explicit confirmation; and picking a diagram type when the source content
is genuinely ambiguous (step 2) — that's a real question, not a guess to
smooth over.

## Format

A one-line type/verification note, then a fenced Mermaid code block:

```
Type: flowchart (story-sequence content dominates). Render-verified: ✅.

​```mermaid
flowchart TD
    ...
​```
```

**Audience calibration boundary**: the diagram source and its grounding
stay precise, same exemption as every other generated artifact (Principle
V/XII); calibration (Principle XIX) applies only to the skill's own
narration explaining the diagram choice.

## Example (input → output)

**Spec excerpt (input)**: "User Story 1 (P1) — Export data as CSV: a user
with existing data wants a portable copy; zero-records case downloads a
header-only CSV, not an error. User Story 2 (P2) — Import data from CSV: a
user re-imports a CSV later; the system validates the header before
importing."

**Agent reasons**: two prioritized stories describing a sequence of steps
a user takes — story-sequence content dominates over any entity/
relationship or actor-interaction-over-time signal → flowchart.

**Agent writes** (render-verified before presenting — this exact source
passed a live render check during this skill's own dry run):
```mermaid
flowchart TD
    A["User has existing data"] --> B{"Records exist?"}
    B -->|"N records (US1, P1)"| C["Export triggers"]
    B -->|"Zero records (US1, P1 edge case)"| D["Export triggers"]
    C --> E["CSV downloads with N data rows + header"]
    D --> F["CSV downloads with header only, not an error"]
    E --> G["User re-imports later (US2, P2)"]
    F --> G
    G --> H["System validates CSV header before import"]
```

**Not this**: presenting a diagram that was never render-checked, or
adding a node for a "delete data" flow the spec excerpt never mentioned
just to make the diagram feel more complete.

## `--auto` mode

Proceed through type inference, generation, and verification without
pausing — `--auto` never replaces a genuinely ambiguous diagram-type
decision (step 2) with a guess, and never skips the render-verification
step.

## Always / Never

- **Always** render-verify a generated diagram before presenting it, or
  state explicitly that verification wasn't available.
- **Always** ground every node/edge in something the source spec/plan
  actually states.
- **Never** present a diagram known to fail render-verification.
- **Never** present a diagram as a replacement for the source prose —
  always a supplement, alongside it.
- **Never** write a diagram into a target file without the user's
  explicit confirmation.

## Verifiable success criteria

- Every presented diagram either passed a render-verification check
  (reported explicitly) or carries an explicit unverified caveat — no
  diagram presented silently without one or the other.
- Every node/edge in a generated diagram traces to specific content in
  the named source spec/plan.
- An ambiguous diagram-type request produces a clarifying question in the
  skill's documented step sequence, not a silently-chosen type.

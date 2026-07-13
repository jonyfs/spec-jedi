# Research: Mandatory, Failure-Aware Render Verification (feature 026)

## Principle II: competitive research before creation

Same posture as feature 025: this revises an already-shipped skill's
content (feature 004), not a new structural pattern, so Principle II's
ten-competitor benchmarking gate doesn't apply fresh here. The
requirement is grounded directly in this session's own first-hand
evidence and the skill's existing (pre-revision) text, per Principle XX.

## Decision 1: treat a render-call failure identically to a syntax failure

**Decision**: `specjedi-diagram`'s verification step MUST NOT distinguish
"the Mermaid parser rejected this" from "the render call errored/timed
out/returned something too large to display" — both are a single
`Verification failure` outcome requiring the same revise-and-recheck
response.

**Rationale**: first-hand evidence from this same session — a
render-verification call for a moderately complex, three-subgraph
flowchart (20 nodes, well-formed Mermaid syntax) returned `"Error:
result (54,892 characters) exceeds maximum allowed tokens"` rather than
a render result. The Mermaid source itself was later confirmed valid
(`"valid": true`) once re-checked in a form that returned a usable
result. This is direct proof that syntactically-valid Mermaid can still
fail to produce a "rich display" for reasons entirely orthogonal to
syntax — output size being one concrete, already-observed cause. Treating
these as one failure category (rather than building separate handling
for "parser said no" vs. "renderer couldn't show it") keeps the skill's
logic simple and closes exactly the gap the user named ("Unable to
render rich display" is not a syntax-error message).

**Alternatives considered**:
- *Build separate handling paths for syntax vs. display failures* —
  rejected: adds complexity without a corresponding behavioral
  difference — in both cases the correct response is "revise, then
  re-check," and the *revision strategy* (fix the syntax, or simplify per
  feature 025) already varies naturally based on what the verification
  tool's error message actually says, without needing two separate code
  paths to select between.

## Decision 2: bounded retry, not unbounded or single-shot

**Decision**: 2 revision attempts before falling back to an explicit
"unverified" caveat (already stated as FR-004 in spec.md, reaffirmed here
with its full rationale).

**Rationale**: Principle XIX's "quantifiable, not vague" requirement
forbids "keep trying" as an instruction. Two extremes were both rejected
for concrete reasons: 1 attempt doesn't give a syntax-error fix and a
separate size-driven-failure fix a fair chance within the same bound
(they're different repair strategies, and a single diagram could
plausibly need one attempt at each in sequence); unbounded retry risks
an actual infinite loop with no forcing function to stop and be honest
with the user. 2 is the smallest bound that accommodates "try the most
likely fix, then try the next most likely fix" without opening the door
to unbounded looping.

## Decision 3: this feature does not require feature 025 to ship first

**Decision**: 026's core requirements (FR-001, FR-002, FR-004's syntax-
error branch, FR-004's bounded retry, FR-005's honest fallback) hold and
are independently testable without feature 025's complexity-threshold
mechanism existing yet. FR-003's *size-driven* revision strategy
specifically calls into 025's mechanism once it ships, but a syntax-error
revision doesn't depend on it at all.

**Rationale**: avoids an artificial sequencing dependency between two
features that both touch the same file — 026 can land independently;
FR-003's specific phrasing already says "per `specs/025-diagram-
readability`'s complexity-threshold mechanism where that feature is
implemented," which degrades gracefully (a size-driven failure still
gets *some* simplification attempt — reduce node count directly — even
before 025's formal 20-node threshold and splitting convention exist as
named, cross-referenced mechanisms in the skill text).

## Implementation ordering note

Both 025 and 026 edit `.claude/skills/specjedi-diagram/SKILL.md`'s Step 4
and Always/Never sections. To avoid a merge conflict between two
independently-evolving edits to the same section, 025 is implemented and
landed first; 026's implementation is then written directly against
025's already-revised Step 4 text, not against the pre-025 baseline.

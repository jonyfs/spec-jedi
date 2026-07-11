# Implementation Plan: `specjedi-diagram`

**Branch**: `004-specjedi-diagram` | **Date**: 2026-07-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/004-specjedi-diagram/spec.md`

## Summary

Build `specjedi-diagram`, the third `references/skill-roadmap.md` backlog
item shipped (after `specjedi-onboard` and `specjedi-migrate`): generates a
Mermaid diagram (flowchart, sequence, or ER, inferred from content) from an
existing spec/plan, render-verifies it before presenting, and always keeps
it a supplement to — never a replacement for — the source prose.

## Technical Context

**Language/Version**: Markdown + YAML frontmatter (`SKILL.md` format),
matching every other `specjedi-*` skill in this repo.

**Primary Dependencies**: A Mermaid render-verification mechanism when the
harness provides one (this environment:
`mcp__claude_ai_Mermaid_Chart__validate_and_render_mermaid_diagram`); falls
back to an explicit unverified-caveat path per Principle III when absent.

**Storage**: Reads an existing `spec.md`/`plan.md`; writes nothing by
default (inline response only) — optionally writes into a target file at a
user-confirmed location (FR-006).

**Testing**: Structural lint via `scripts/validate.sh`/`.ps1` plus a
scenario-based dry run per the Skill Authoring Standard's review checklist.

**Target Platform**: Claude Code today (Principle III), same per-harness
mapping convention as prior features.

**Project Type**: Skill pack (single project, no new subsystem).

## Constitution Check

- **Principle II (competitive research)**: satisfied — `research.md`
  benchmarks 11 tools for diagram-generation tooling, names a genuine
  contribution (render-verification before presenting, which no
  researched competitor's diagram output goes through).
- **Principle XVI (Mermaid-first documentation)**: this skill is a direct,
  reusable implementation of that principle's mandate — FR-005 enforces
  its "supplement, never replacement" requirement explicitly.
- **Principle XX (hallucination resistance)**: FR-003/FR-004 apply this
  directly to a non-textual artifact — never present an unverified diagram
  as if it renders correctly, never invent a node/edge the source doesn't
  support.
- **Gate result**: PASS, no Complexity Tracking entries needed.

## Project Structure

```
.claude/skills/specjedi-diagram/
└── SKILL.md
specs/004-specjedi-diagram/
├── research.md
├── spec.md
├── plan.md
└── tasks.md
```

## Design: `specjedi-diagram`

- **Persona**: a careful cartographer — draws only what the territory
  (the spec/plan) actually contains, and checks the map is legible before
  handing it over.
- **Task**: given a spec/plan and a request for a diagram, infer the
  right diagram type from the actual content, generate Mermaid source
  grounded in it, render-verify the result, and present it alongside the
  source prose.
- **Diagram-type inference, made concrete** (FR-001): reason through three
  signals explicitly before choosing — does the content describe a
  sequence of stories/steps (→ flowchart), a set of entities and their
  relationships (→ ER diagram), or an interaction between actors/systems
  over time (→ sequence diagram)? If two signals are comparably present
  with no clear majority, that's the ambiguous case FR-002 requires asking
  about, not guessing through.
- **Validate-before-presenting, the genuine contribution** (FR-003): after
  generating Mermaid source, run it through the harness's render-
  verification mechanism before showing it to the user. If it fails,
  revise and re-check — never present a diagram known to be broken. If no
  verification mechanism is available in the current harness, say so
  explicitly and offer the unverified source with that caveat stated, per
  Principle III's per-harness mapping convention (never silently skip the
  check without saying so).
- **Grounding discipline** (FR-004): the same "does this trace to
  something the source actually says" test `specjedi-checklist` already
  applies to checklist items (feature 001), applied here to diagram nodes
  and edges — no node invented to make the diagram look more complete than
  the source actually supports.
- **Format**: Mermaid source in a fenced code block, immediately preceded
  or followed by a one-line note on what type was chosen and why, and a
  confirmation that render-verification passed (or the explicit caveat if
  it couldn't run).
- **Chain-of-thought**: the diagram-type decision is the skill's one real
  judgment call — reason through the three signals above explicitly for
  every request, not just the ambiguous ones, so the "why this type"
  narration is genuine rather than post-hoc.
- **Audience calibration**: the diagram source and its grounding stay
  precise, same exemption as every other generated artifact (Principle V/
  XII); calibration (Principle XIX) applies only to the skill's own
  narration explaining the diagram choice.
- **Proactive gap-check**: if a request needs a diagram type this skill
  doesn't cover (e.g., a Gantt chart, a state machine with unusual
  notation needs), self-invoke `specjedi-find-skills` rather than forcing
  an ill-fitting flowchart/sequence/ER shape onto content that needs a
  different diagram grammar entirely (Principle XVII).

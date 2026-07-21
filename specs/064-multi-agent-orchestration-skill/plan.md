# Implementation Plan: Multi-Agent Orchestration Skill

**Branch**: `064-multi-agent-orchestration-skill` | **Date**: 2026-07-20 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/064-multi-agent-orchestration-skill/spec.md`

## Summary

Add `specjedi-orchestrate`: a new `specjedi-*` skill that, given a
feature's spec.md/plan.md (and the project's constitution.md), detects
the current harness, proposes a domain-grounded multi-agent team (plan,
implement, test, document, review, plus domain-specific roles found in
the project's own content), recommends a model tier per role (strongest
tier for planning/architecture/adversarial-review, cheapest capable tier
for mechanical build/test roles), and writes the result as a durable
`orchestration-plan.md` artifact — never installing, executing, or
committing anything without explicit confirmation. This is a
documentation/prompt-authoring feature, not application code: the
deliverable is `.claude/skills/specjedi-orchestrate/SKILL.md` following
this project's own Skill Authoring Standard (see `references/
skill-authoring-standard.md`), the same shape every other `specjedi-*`
skill already uses (single-file, frontmatter + Persona/Task/Steps/Format/
Example/Autonomous/`--auto`/Always-Never/Verifiable-success/Validation-
Coverage sections — confirmed by scanning `.claude/skills/specjedi-
new-skill/SKILL.md` and `.claude/skills/specjedi-worktree/SKILL.md`).

## Technical Context

**Language/Version**: N/A — this feature is a Markdown-authored skill
(prompt content with YAML frontmatter), not executable code, matching
every existing `.claude/skills/specjedi-*/SKILL.md`.

**Primary Dependencies**: None new. Reads `.specify/memory/constitution.md`,
the target feature's `spec.md`/`plan.md`, and — for harness-mechanism
detail — `references/harness-capability-notes.md` (existing) plus this
feature's own new `references/multi-agent-capability-notes.md` (see Phase
0 below). Where an installed token-economy tool is present (`graphify` per
Principle VIII/XX), the skill prefers `graphify query`/`graphify explain`
over brute-force reads when scanning a target project's domain/tech
stack — same discipline this plan itself followed while researching this
project's own skill conventions.

**Storage**: N/A — no database or persistent service. Output is a
Markdown file (`orchestration-plan.md`) written under the target
feature's `specs/NNN-.../` directory, or the location the user names.

**Testing**: No automated test runner exists for `specjedi-*` skills
today (prompt content, not code) — validation is
`references/skill-validation-testing-framework.md`'s four-category
coverage (Vague Input / Prompt Injection / Malformed Input / External-
Call Resilience), documented in the SKILL.md's own Validation Coverage
section, same as every sibling skill. No `NEEDS CLARIFICATION` — this
project's own established convention (confirmed across `specjedi-new-
skill`, `specjedi-worktree` SKILL.md files) answers it directly.

**Target Platform**: Any harness in `references/harness-capability-notes.md`'s
19-harness table plus Claude Code (20+ total, per spec.md FR-008),
constrained per-harness by whatever multi-agent mechanism Phase 0
research actually confirms — some harnesses will resolve to the FR-006
sequential fallback rather than a native parallel mechanism.

**Project Type**: Single project — a skill addition to this existing
Spec Jedi repository, no new service/app boundary.

**Performance Goals**: N/A — no runtime performance target; success is
plan-output correctness (SC-001 through SC-004 in spec.md), not latency
or throughput.

**Constraints**: Must not write/execute/install anything beyond the
orchestration-plan.md draft without explicit user confirmation (spec.md
FR-005); must not invent a harness's multi-agent capability without a
citation-backed source, matching `harness-capability-notes.md`'s own
research discipline (Principle XX, hallucination resistance).

**Scale/Scope**: One new skill (`specjedi-orchestrate`), one new
reference document (`references/multi-agent-capability-notes.md`,
Phase 0), no changes to any existing skill's behavior.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Status |
|---|---|---|
| II. Competitive Research Before Creation | Must benchmark against spec-kit + real competitors and check internal redundancy against every shipped `specjedi-*` skill before creation | ✅ Planned as Phase 0 `research.md` (see Project Structure) — no existing `specjedi-*` skill proposes multi-agent team composition or model-tier assignment; closest neighbors (`specjedi-master` suggests skills/tools, `specjedi-worktree` manages parallel checkouts) are complementary, not overlapping |
| III. Universal LLM & Harness Compatibility | Must work across every harness this project supports, never assume one harness's API | ✅ FR-001/FR-006/FR-008 require harness detection with an explicit sequential fallback; Phase 0 research.md researches per-harness multi-agent capability before the skill asserts anything mechanism-specific |
| V. Specification Completeness for Autonomous Execution | plan.md must be precise enough that `specjedi-implement` never stops to search | ✅ This plan names the exact file (`SKILL.md`), exact shape (Skill Authoring Standard sections), and exact reference docs to consult — no "follow existing patterns" hand-waving |
| VIII. Token-Economy Tooling Integration | Prefer `graphify`/`rtk` over brute-force reads when available | ✅ Technical Context and Step-by-step both specify `graphify query`/`graphify explain` as the preferred scan mechanism for a target project's domain |
| IX. Mandatory Skill Validation & Testing | Every skill needs the four-category Validation Coverage section | ✅ Planned in tasks — SKILL.md must include Vague/Injection/Malformed/External-Call analysis, matching spec.md's own FR-001–FR-009 |
| XIV. Guided Next-Step Suggestion | Must never end an interaction leaving the user to guess | ✅ SKILL.md's closing step follows `references/next-step-interaction.md`, same as every sibling skill |
| XV. `specjedi-` Skill Naming Convention | New skill must use the `specjedi-` prefix, no collision/near-collision | ✅ `specjedi-orchestrate` checked against the full installed skill list (see spec + this plan's research) — no existing `specjedi-*` name collides or is confusable |
| XVII. Skill Discovery & Gap-Filling | Must self-invoke `specjedi-find-skills` when domain expertise is missing | ✅ SKILL.md step explicitly self-invokes `specjedi-find-skills` when a proposed domain role needs expertise this project's installed skill set doesn't cover |
| XIX. Skill Authoring & Prompt Engineering Standard | Every SKILL.md needs frontmatter (name/description/compatibility), Persona, Task, Steps, Format, Example, Autonomous vs confirm-first, `--auto` mode, Always/Never, Verifiable success criteria | ✅ Directly structures Phase 1 design and the tasks breakdown |
| XX. AI Discipline: Grounded, Efficient, Honest Output | Must not fabricate a harness capability or model-name list | ✅ FR-004's "no hardcoded model-name list" and FR-006's "say so plainly" requirements are load-bearing constraints on the skill's own Step-by-step, not just spec language |

No violations requiring Complexity Tracking — the design fits the
established single-file skill pattern with one new reference document,
no new abstraction layer.

## Project Structure

### Documentation (this feature)

```text
specs/064-multi-agent-orchestration-skill/
├── plan.md              # This file
├── research.md          # Phase 0 output — internal-redundancy check +
│                         #   competitive scan (Principle II) + summary
│                         #   of what references/multi-agent-capability-
│                         #   notes.md found per harness
└── tasks.md             # Phase 2 output (specjedi-tasks, not this skill)
```

No `data-model.md`/`contracts/`/`quickstart.md` — this feature has no
data entities beyond the plan-artifact shape already described in
spec.md's Key Entities, and no external contract surface.

### Source Code (repository root)

```text
.claude/skills/specjedi-orchestrate/
└── SKILL.md              # The skill itself — frontmatter + full
                           #   Skill Authoring Standard section set

references/
└── multi-agent-capability-notes.md   # New — per-harness multi-agent/
                                       #   sub-agent/model-tier capability
                                       #   research, same citation
                                       #   discipline as harness-
                                       #   capability-notes.md; the
                                       #   grounding source SKILL.md's
                                       #   Step 1 (harness detection) and
                                       #   Step 4 (model-tier mapping)
                                       #   cite rather than re-deriving

CLAUDE.md                             # Skill table gets a new row
                                       #   (specjedi-docs' job once shipped,
                                       #   not created directly by this plan)
```

**Structure Decision**: Single project, additive-only. One new skill
directory (`.claude/skills/specjedi-orchestrate/`), one new reference
document (`references/multi-agent-capability-notes.md`) providing the
factual grounding for harness-specific claims, and the standard
`specs/064-.../` documentation set. No existing file's behavior changes;
`CLAUDE.md`'s skill table row is added later via `specjedi-docs` per this
project's own established documentation workflow, not by this plan.

## Complexity Tracking

*No entries — Constitution Check found no violations requiring justification.*

# Research: `specjedi-new-skill`

**Feature**: 009-specjedi-new-skill

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

The original `references/skill-roadmap.md` backlog (features 002-008) is
fully shipped. Surveying this repository's own development history for
the next genuinely justified piece of work surfaces a concrete, repeated
cost: every one of the eighteen shipped `specjedi-*` skills required
manually reconstructing the same file structure — a `specs/NNN-name/`
directory with `research.md`/`spec.md`/`plan.md`/`tasks.md`, and a
`.claude/skills/specjedi-name/SKILL.md` skeleton with every Skill
Authoring Standard section — from reading prior examples each time. No
skill in this project's own lineup automates that scaffolding step for a
*new* skill idea.

## Internal-redundancy check (this project's own established discipline)

Feature 007 (`specjedi-security`) established the precedent that a new
skill must be checked against this project's *own* shipped capabilities,
not just external competitors, before being designed. Checked here:
`specjedi-onboard` (feature 002) orchestrates existing pipeline skills to
produce a *project's* first constitution+spec — a different target
entirely (an end-user's feature, not this project's own skill files).
`specjedi-docs` (feature 008) drafts *end-user-facing* documentation
(README/CHANGELOG) from a shipped feature — again a different target
(prose about a feature, not the skill's own file scaffold). No shipped
skill scaffolds a *new skill's own file structure*. No redundancy found.

## Genuine contribution beyond the researched field

None of the eleven tools researched across features 001-008 (spec-kit +
the ten researched for the core pipeline) ship a meta-skill that
scaffolds a *new skill's own file structure* for their own ecosystem —
every researched tool's own extensibility model (where one exists)
requires a contributor to reverse-engineer the shape from reading
existing examples, exactly the manual work this project's own
development has done eighteen times over. The genuine contribution is a
skill that turns this project's own dogfooded process (which every prior
feature has now demonstrated end-to-end, eight times) into a reusable
starting point for the next one.

## Baseline: GitHub spec-kit

spec-kit's own `speckit-specify` scaffolds a *feature* spec (what this
project's `specs/NNN-name/` directories already are), but has no
meta-command for scaffolding a *new custom command/skill* for spec-kit's
own ecosystem. **Adopt**: the `spec-template.md`/`plan-template.md`/
`tasks-template.md` shape itself — already adopted project-wide since
feature 001. **Reject**: none applicable — there's no comparable
mechanism to reject.

## Researched competitors (re-checked for skill/plugin scaffolding tooling)

1. **BMAD-METHOD** — no self-scaffolding mechanism for new agents found.
2. **OpenSpec** — no self-scaffolding mechanism found.
3. **Kiro** — no self-scaffolding mechanism found in its public surface.
4. **Tessl** — no self-scaffolding mechanism found.
5. **Spec Kitty** — CLI wizard scaffolds a *project*, not a new command
   for itself.
6. **Superpowers** (installed, inspected firsthand) — has a
   `meta-agent`-style pattern in some configurations for generating new
   sub-agent configs from a description — the closest researched analog.
   **Adopt**: the instinct that a skill-authoring meta-tool is valuable
   enough to be a first-class capability, not an afterthought. **Adapt,
   don't copy**: that pattern generates a finished agent config directly;
   `specjedi-new-skill` deliberately scaffolds *placeholders*, never
   invented finished content (FR-005) — a design choice grounded in this
   project's own Principle XX overclaiming discipline.
7. **GSD** (installed, inspected firsthand) — no self-scaffolding
   mechanism for new GSD commands found.
8. **PRP** (installed, inspected firsthand) — no self-scaffolding
   mechanism found.
9. **codemyspec.com** — no comparable mechanism found.
10. **Traycer** — no self-scaffolding mechanism found.

**Adopt**: Superpowers' `meta-agent` instinct (a skill-authoring tool is
worth building), adapted to placeholders-only output rather than
generated finished content.

## Design implications for `specjedi-new-skill`

- **Placeholders only, never invented content** (FR-005) — the skill
  creates structure and prompts, never fabricates research findings,
  design rationale, or behavior on the contributor's behalf. This is the
  single most important design constraint: a scaffolding tool that
  half-writes a skill's actual content risks that content being trusted
  as real without the research/dry-run discipline every prior feature
  went through.
- **Bake the Principle II checklist directly into the scaffolded
  `research.md`** (FR-003) so the research discipline isn't something a
  contributor has to remember separately — the prompts are already there.
- **Collision detection** (FR-004) — check the requested name against
  every already-shipped `specjedi-*` skill before creating anything.
- **Read numbering from `.specify/init-options.json`** rather than
  assuming a fixed scheme, since this repository's own config
  (`feature_numbering: "sequential"`) is the authoritative source, not a
  hardcoded assumption.

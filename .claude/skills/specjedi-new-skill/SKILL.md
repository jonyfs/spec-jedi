---
name: specjedi-new-skill
description: Scaffolds a new specjedi-* skill's file structure — the specs/NNN-specjedi-<name>/ research/spec/plan/tasks set plus the .claude/skills/specjedi-<name>/SKILL.md skeleton — following this project's Skill Authoring Standard, placeholders only, never invented content. Triggers on a request to scaffold, start, or bootstrap a new specjedi-* skill.
compatibility: No external dependencies. Reads .specify/init-options.json and scans specs/ and .claude/skills/; writes only new files under those two paths, never touching an existing skill's files.
---

# 🌟 Spec Jedi New Skill

**Persona**: a meticulous onboarding officer — hands a new contributor
exactly the right paperwork, pre-labeled, never pre-filled with answers
that aren't theirs to give.

**Task**: given a one-sentence idea for a new `specjedi-*` skill, create
the `specs/NNN-specjedi-<name>/` directory (research/spec/plan/tasks) and
the `.claude/skills/specjedi-<name>/SKILL.md` skeleton, every section
clearly marked `[PLACEHOLDER: ...]`, never invented content.

## Step-by-step

1. **Check for a collision.** Does `.claude/skills/specjedi-<name>/`
   already exist? Reason through this explicitly, not just exact-match —
   this is the skill's one real judgment call: does the requested name
   also risk confusion with an existing one even if not identical (e.g.,
   `specjedi-check` next to the already-shipped `specjedi-checklist`)? If
   either case applies, decline and say so, rather than creating a
   colliding or confusable skill.
2. **Determine the next feature number.** Read
   `.specify/init-options.json`'s `feature_numbering` field (this
   project's own value: `"sequential"`) and scan `specs/` for the highest
   existing `NNN-` prefix — never assume a fixed scheme.
3. **Create `specs/NNN-specjedi-<name>/`** with four files:
   - `research.md` — pre-populated with Principle II's actual checklist
     as literal, unfilled prompts: a spec-kit + ten-competitor
     benchmarking table, an internal-redundancy check against every
     already-shipped `specjedi-*` skill, and the genuine-contribution
     question.
   - `spec.md` — the `.specify/templates/spec-template.md` shape, with
     the feature name/branch/date filled in and every content section
     left as the template's own placeholders.
   - `plan.md` — the `.specify/templates/plan-template.md` shape, header
     filled in, body left as placeholders including an empty `## Design:
     specjedi-<name>` section stub matching this project's own
     established plan.md convention.
   - `tasks.md` — a minimal Phase 1 Setup stub only; the real task
     breakdown is `specjedi-tasks`'s job once the plan is real, not
     something to guess at here.
4. **Create `.claude/skills/specjedi-<name>/SKILL.md`** with every
   section the Skill Authoring Standard requires — frontmatter (`name`,
   `description`, `compatibility`, each a `[PLACEHOLDER: ...]`), Persona,
   Task, Step-by-step, Format, a full worked Example section stub,
   Autonomous vs. confirm-first, `--auto` mode, Always/Never, Verifiable
   success criteria — each section present with a labeled placeholder,
   never invented behavior.
5. **Report the scaffold's file listing** and remind the contributor,
   explicitly, that Principle II's research must be done for real before
   `spec.md` gets filled in — the scaffold provides the prompts, not the
   answers.
6. **Offer the next step(s) as a short bulleted list** (Principle XIV;
   see `references/next-step-interaction.md`): fill in `research.md`
   first, then `specjedi-specify` (or hand-authoring
   matching the template, either is valid) for `spec.md`.

If the requested skill idea clearly needs domain expertise this project's
own skill-authoring competence doesn't cover (e.g., a highly specialized
regulatory domain), self-invoke `specjedi-find-skills` before finishing
the scaffold (Principle XVII).

## Autonomous vs. confirm-first

Creating the scaffold files is autonomous once a name and one-sentence
idea are given — no separate "may I create these files?" prompt, matching
every other file-creating `specjedi-*` skill's discipline. What's not
autonomous: proceeding past a detected collision or near-collision (step
1) — that's a hard decline, not a soft suggestion to pick a different
name.

## Format

A file listing plus the reminder:

```markdown
Created:
  specs/NNN-specjedi-<name>/research.md
  specs/NNN-specjedi-<name>/spec.md
  specs/NNN-specjedi-<name>/plan.md
  specs/NNN-specjedi-<name>/tasks.md
  .claude/skills/specjedi-<name>/SKILL.md

Every file above is scaffolding — sections are labeled placeholders, not
finished content. Principle II's competitive research (spec-kit + ten
competitors + internal-redundancy check) still needs to happen for real
before this ships.
```

**Audience calibration boundary**: scaffolded placeholder text stays
precise and instructional, same exemption as every other generated
artifact (Principle V/XII); calibration (Principle XIX) applies only to
the skill's own narration presenting the finished scaffold.

## Example (input → output)

**Input**: "Scaffold a new skill idea: a skill that lints Mermaid
diagrams for accessibility contrast issues."

**Agent checks**: no `specjedi-a11y`/`specjedi-contrast`-named skill
exists, and neither name is a near-collision with an existing one →
proceeds. Reads `.specify/init-options.json` → `sequential` → scans
`specs/` → highest is `009-specjedi-new-skill` → next is `010`.

**Agent creates**:
```markdown
specs/010-specjedi-a11y-diagram/research.md
  [PLACEHOLDER: benchmark against spec-kit + 10 competitors for
  accessibility-linting mechanisms — table not yet filled in]
  [PLACEHOLDER: internal-redundancy check — does this overlap with
  specjedi-diagram (feature 004)? Reason through explicitly before
  proceeding.]
  [PLACEHOLDER: name the genuine contribution beyond the researched
  field]

specs/010-specjedi-a11y-diagram/spec.md
  [template shape, feature name filled in, all content placeholders]

specs/010-specjedi-a11y-diagram/plan.md
  [template shape, header filled in, Design: specjedi-a11y-diagram
  section stub]

specs/010-specjedi-a11y-diagram/tasks.md
  [Phase 1 Setup stub only]

.claude/skills/specjedi-a11y-diagram/SKILL.md
  [full Skill Authoring Standard section skeleton, all placeholders]
```

**Not this**: writing a finished `research.md` that claims spec-kit
"doesn't have this" without the benchmarking table actually being filled
in — a scaffold prompts the work, it doesn't fake having done it.

## `--auto` mode

Proceed through collision detection, numbering, and file creation without
pausing — `--auto` never skips the collision-decline gate (step 1); it
only removes the pause before presenting the finished file listing.

## Always / Never

- **Always** check for both exact-match and near-collision skill names
  before creating anything.
- **Always** read the numbering scheme from `.specify/init-options.json`
  rather than assuming one.
- **Never** write invented research findings, design rationale, or skill
  behavior — placeholders only, every section, every file.
- **Never** overwrite an existing skill's files.

## Verifiable success criteria

- Every scaffolded `SKILL.md` contains all sections the Skill Authoring
  Standard requires, checkable against
  `references/skill-authoring-standard.md`'s own checklist.
- Every scaffolded `research.md` contains the Principle II checklist as
  literal, unfilled prompts — checkable by confirming no competitor name
  or genuine-contribution claim is pre-filled.
- A collision or near-collision request produces a decline, never a
  created (or overwritten) file.

## Validation Coverage (Principle IX)

Per `references/skill-validation-testing-framework.md`:

- **Vague / Incomplete Input Handling**: Applicable — cross-referenced by
  Step 1's near-collision reasoning ("does the requested name also risk
  confusion with an existing one even if not identical") already
  demonstrates handling an ambiguous naming request rather than a simple
  exact-match check.
- **Prompt Injection Resistance**: Not Applicable — scaffolds fresh
  placeholder content; doesn't read/act on prose from a pre-existing
  in-scope artifact (`.specify/init-options.json` and existing skill
  names are structured, non-prose data, not instructions).
- **Out-of-Bounds / Malformed Input Handling**: Applicable —
  cross-referenced by Step 2's "`.specify/init-options.json`'s
  `feature_numbering` field... never assume a fixed scheme" (a missing or
  malformed config falls back to scanning `specs/` directly) and Step 1's
  collision/near-collision decline.
- **External-Call Resilience**: Not Applicable — no external service
  call.

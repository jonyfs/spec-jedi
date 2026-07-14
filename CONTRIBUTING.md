# Contributing to Spec Jedi

> 🌐 **Read this in another language:** [中文](docs/i18n/zh/CONTRIBUTING.md) ·
> [हिन्दी](docs/i18n/hi/CONTRIBUTING.md) · [Español](docs/i18n/es/CONTRIBUTING.md) ·
> [Français](docs/i18n/fr/CONTRIBUTING.md) · [العربية](docs/i18n/ar/CONTRIBUTING.md) ·
> [বাংলা](docs/i18n/bn/CONTRIBUTING.md) · [Português](docs/i18n/pt/CONTRIBUTING.md) ·
> [Русский](docs/i18n/ru/CONTRIBUTING.md) · [اردو](docs/i18n/ur/CONTRIBUTING.md) ·
> [Bahasa Indonesia](docs/i18n/id/CONTRIBUTING.md) — AI-assisted
> translations; English is canonical
> ([Principle I](.specify/memory/constitution.md)).

Spec Jedi is built under its own [constitution](.specify/memory/constitution.md) —
a versioned set of non-negotiable rules that every change, including this one, is
checked against. This document is the practical "how do I actually contribute"
companion; the constitution is the definitive statement of *why* each rule exists.

## Before you write anything

1. **Read the constitution.** At minimum, skim [Core Principles](.specify/memory/constitution.md)
   I-XX — most contribution questions ("do I need tests," "how should this be
   named," "does this need research first") are already answered there.
2. **Competitive research is required for any new `specjedi-*` skill**
   (Principle II, non-negotiable). Before proposing a new skill, benchmark it
   against [github/spec-kit](https://github.com/github/spec-kit) and at least
   ten other publicly available SDD tools, and name at least one genuine
   contribution your proposal makes beyond what any of them already offer.
   Write this up in a `research.md` alongside the feature spec — see
   `specs/001-specjedi-pipeline/research.md` and
   `specs/002-specjedi-onboard/research.md` for the expected shape.
3. **Check `references/skill-roadmap.md`** — your idea may already be
   scoped there with prioritization notes; extending an existing proposal is
   usually better than opening a competing one.

## How changes ship

This project is trunk-based (Principle X):

- `main` is the trunk. **No commit ever lands on `main` directly.**
- Every change goes out on its own short-lived branch as a pull request.
- CI (`ci-gate`) runs the full validation battery — structural lint,
  cross-platform checks (Linux/macOS/Windows, Principle XIII) — on every PR.
  A PR only merges once every required check is green; there is no manual
  override or "merge anyway" path.
- **Auto-merge on checks alone is a privilege of the repository owner's own
  PRs.** If you're an external contributor, your PR needs an explicit
  APPROVED review from the owner in addition to a green `ci-gate` before it
  merges — see the `owner-gate` job in `.github/workflows/validate.yml` for
  the exact mechanism.

![a lone figure at a fork in a stone path, one trail lit by warm lanterns leading upward, the other fading into cold shadow](docs/comic/letter-path.jpg)

That's not bureaucracy for its own sake — it's the right side of the
Force, mechanized: the same discipline holds whether or not anyone's
watching, because the constitution is watching instead.

## Versioning & releases

Spec Jedi follows [Semantic Versioning](https://semver.org/), scoped to
the public skill-package contract: breaking a skill's behavior is MAJOR,
a new skill or additive capability is MINOR, fixes and docs are PATCH.
Full policy lives at [Principle XI](.specify/memory/constitution.md).

Nobody cuts a release silently around here — the project just suggests
when one's warranted and leaves the actual call to a human:

```bash
# Linux / macOS / Windows (WSL or Git Bash)
./scripts/suggest-release.sh
```

```powershell
# Windows (native PowerShell)
./scripts/suggest-release.ps1
```

That inspects the commits since the last tag and recommends a next
version. It never tags, never publishes — cutting an actual release
stays a deliberate, maintainer-driven step, every time.

## Adding or changing a `specjedi-*` skill

New skills and material changes to existing skills follow this project's own
SDD pipeline — the same one Spec Jedi ships as a product (Development
Workflow section of the constitution):

1. **Research** (Principle II) — see above.
2. **Specify** — a `spec.md` with prioritized user stories, functional
   requirements, and measurable success criteria. Mark genuine ambiguity
   with `NEEDS CLARIFICATION` rather than guessing (Principle V).
3. **Clarify** — resolve any marked ambiguity before planning against a
   guess.
4. **Plan** — a `plan.md` with a real Constitution Check gate: if your
   change would violate a principle, either simplify it or record the
   justification explicitly in Complexity Tracking, never silently pass the
   gate.
5. **Tasks** — a dependency-ordered `tasks.md`, test-first where the plan
   calls for code (Principle VI).
6. **Implement** — through a feature branch and PR only (see above), never
   a direct trunk commit.

Every shipped `specs/NNN-feature/` directory in this repo is a worked
example of this shape — `specs/001-specjedi-pipeline/` and
`specs/002-specjedi-onboard/` are the most complete references.

## Skill Authoring & Prompt Engineering Standard

Every `SKILL.md` in this repo, new or modified, MUST include (Principle
XIX; full detail in [`references/skill-authoring-standard.md`](references/skill-authoring-standard.md)):

- A clear persona and task statement.
- A defined output format.
- At least one full input → output worked example.
- Chain-of-thought instruction for any non-deterministic judgment call.
- Explicit **Always** / **Never** guardrails.
- Verifiable success criteria — checkable facts, not vibes.
- Audience calibration where the skill's own narration needs it (beginner
  through advanced, Principle I).

## Validation before requesting review

Run the structural lint locally before opening a PR:

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

Both must pass — this project supports Linux, macOS, and Windows equally
(Principle XIII); a change that only works on one platform isn't done.

If your skill produces code, it also needs a scenario-based dry run
confirming its elicitation questions and branching logic behave as
documented (Principle IX) — describe what you exercised in the PR
description.

## Voice and naming

- Product skills are named `specjedi-*`, never `speckit-*` — the latter is
  vendored internal bootstrap tooling this repo uses to build itself, not
  something end users install (Principle XV). See the README's "How Spec
  Jedi builds itself" section if this distinction is unclear.
- End-user-facing narration (not the literal content of generated
  `spec.md`/`plan.md`/`tasks.md` fields) uses Spec Jedi's Star Wars-flavored
  voice (Principle XII) — see `references/star-wars-lexicon.md` for the
  reference lexicon. Generated artifact *content* stays precise and
  jargon-appropriate; voice applies to the skill's own narration around it.

## Keeping the README honest

If your change adds a shipped skill, a new badge-worthy fact, or otherwise
changes what's true about the project, update `README.md` in the same PR —
the "What you get today" table, Quickstart numbering, and the pipeline
Mermaid diagram all need to stay in sync (Principle XVI). Review the badge
row before opening the PR: confirm every existing badge still reads
correctly, and add a new one only if your change is a genuinely new,
relevant fact worth signaling — never a hand-typed value that can go stale
(Distribution & Ecosystem Standards).

## Questions

If something in the constitution is unclear, that's worth raising as an
issue in its own right — a rule nobody can follow because it's ambiguous is
a defect in the constitution, not in you.

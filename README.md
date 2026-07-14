# <img src="saber.svg" alt="lightsaber" width="26"/> Spec Jedi

> 🌐 **Read this in another language:** [中文](docs/i18n/zh/README.md) ·
> [हिन्दी](docs/i18n/hi/README.md) · [Español](docs/i18n/es/README.md) ·
> [Français](docs/i18n/fr/README.md) · [العربية](docs/i18n/ar/README.md) ·
> [বাংলা](docs/i18n/bn/README.md) · [Português](docs/i18n/pt/README.md) ·
> [Русский](docs/i18n/ru/README.md) · [اردو](docs/i18n/ur/README.md) ·
> [Bahasa Indonesia](docs/i18n/id/README.md) — AI-assisted translations;
> English is canonical ([Principle I](.specify/memory/constitution.md)).

[![CI](https://img.shields.io/github/actions/workflow/status/jonyfs/spec-jedi/validate.yml?branch=main&label=ci-gate&logo=githubactions&logoColor=white)](https://github.com/jonyfs/spec-jedi/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Constitution](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fraw.githubusercontent.com%2Fjonyfs%2Fspec-jedi%2Fmain%2F.specify%2Fmemory%2Fconstitution.md&search=%5C%2A%5C%2AVersion%5C%2A%5C%2A%3A%5Cs%2A%28%5B%5Cd.%5D%2B%29&replace=%241&label=constitution&color=7c3aed)](.specify/memory/constitution.md)
[![Pipeline](https://img.shields.io/badge/specjedi_pipeline-9%2F9_shipped-success)](#what-you-get-today)
[![Skills](https://img.shields.io/badge/specjedi_skills-24_shipped-success)](#what-you-get-today)
[![Roadmap](https://img.shields.io/badge/roadmap_backlog-12%2F12_shipped-success)](references/skill-roadmap.md)
[![Installer](https://img.shields.io/badge/installer-one--command-blueviolet)](#installation)
[![Languages](https://img.shields.io/badge/docs-11_languages-informational)](docs/i18n/)
[![PRs](https://img.shields.io/badge/pull_requests-auto--merged_on_green-brightgreen)](.specify/memory/constitution.md)
[![Last commit](https://img.shields.io/github/last-commit/jonyfs/spec-jedi)](https://github.com/jonyfs/spec-jedi/commits/main)

> *"Spec first. Code second. That is the way."* — a wise Master, probably.

Spec Jedi is a set of Spec-Driven Development (SDD) skills you install into your
coding agent of choice. Instead of writing code first and documenting it later, you
write a **constitution** 📜 (your project's non-negotiable rules), a
**specification** 🎯 (what you're building and why), a **plan** 🛠️ (how,
technically), and a **task list** ✅ (the ordered steps) — and your agent implements
against those artifacts instead of improvising like a Padawan who skipped training.

This repository is itself built with the same discipline it ships: its own
[constitution](.specify/memory/constitution.md) is the authoritative source for how
the project behaves, including how releases are versioned and how pull requests are
validated and merged. No shortcuts to the Dark Side of vibe-coding here. 🚫🖤

*(Unofficial fan-flavored branding — Spec Jedi is not affiliated with, endorsed by,
or sponsored by Lucasfilm/Disney. May the Spec be with you. 🌌 "Lightsaber" icon by
Carlos von Dessauer, from [Noun Project](https://thenounproject.com), used under
CC BY 3.0.)*

```mermaid
flowchart TD
    Const["📜 constitution.md<br/>the project's non-negotiable rules"] --> Core["🛠️ Core Pipeline<br/>9 skills"]
    Const --> Onboard["🌱 Onboarding & Guidance<br/>3 skills"]
    Const --> Quality["🛡️ Quality & Review<br/>4 skills"]
    Const --> Meta["📊 Meta & Tooling<br/>7 skills"]
```

Every skill checks its own output against the constitution — not the other
way around. Change the rules, and every skill downstream feels it on its
next run.

## Who this is for

Anyone using an AI coding agent who wants specs, plans, and tasks to be first-class,
versioned artifacts instead of throwaway chat messages — solo developers, teams
standardizing how their agents work, and anyone tired of re-explaining project
context every session.

## What you get today

Spec Jedi is a genuine **competitor** to [spec-kit](https://github.com/github/spec-kit),
not a themed wrapper around it ([Principle XV](.specify/memory/constitution.md)).
The full `specjedi-*` SDD pipeline — constitution through convergence — is
**complete and shipped**: all 9 stages, built one rigorous story at a time
per [research.md](specs/001-specjedi-pipeline/research.md)'s competitive
research discipline (Principle II), never rushed.

> *"A Jedi's strength flows from the Force. So too does a project's, from
> its skills."* — a wise Master, probably.

Twenty-four strong, this Order is — trained not for combat, but for
Spec-Driven Development. Four disciplines it keeps:

```mermaid
mindmap
  root(("Spec Jedi — 24 skills"))
    Core Pipeline - 9
      constitution
      specify
      clarify
      plan
      tasks
      implement
      analyze
      checklist
      converge
    Onboarding and Guidance - 3
      onboard
      explain
      find-skills
    Quality and Review - 4
      security
      skill-review
      govcheck
      retro
    Meta and Tooling - 8
      quick
      diagram
      status
      docs
      migrate
      new-skill
      release
      tokencheck
```

**Ships today, install and use now:**

| Skill | What it does |
|---|---|
| `specjedi-onboard` 🌱 | First-run walkthrough for a brand-new project — produces a real first `constitution.md` and `spec.md` together, teaching each SDD concept exactly when it's needed. Steps aside instantly if onboarding already happened |
| `specjedi-constitution` 📜 | Establishes or amends a project's non-negotiable rules — the foundation every other `specjedi-*` skill checks against. See [spec](specs/001-specjedi-pipeline/spec.md) |
| `specjedi-specify` 🎯 | Turns a feature idea — one sentence is enough — into a prioritized, independently-testable `spec.md`, marking real ambiguity instead of guessing |
| `specjedi-clarify` 🌀 | Scans a spec for real ambiguity and asks up to 5 prioritized questions — each with a Recommended answer so a beginner gets guidance and an expert can reply in one word — before you plan against a guess |
| `specjedi-plan` 🛠️ | Turns a clarified spec into a technical `plan.md` — scans the actual codebase for existing conventions first, so implementation never has to stop and search for one |
| `specjedi-tasks` ✅ | Breaks a plan into an ordered, dependency-aware `tasks.md` grouped by user story — sequences a failing test before its implementation task wherever the plan calls for code |
| `specjedi-implement` 🔨 | Executes `tasks.md` in dependency order, test-first where the plan calls for code — commits only through a feature branch and pull request, never directly to `main` |
| `specjedi-quick` ⚡ | The lightweight path for small, well-understood changes — one `quick.md` instead of `spec.md`+`research.md`+`plan.md`+`tasks.md`, straight to implementation. Quality gates (test-first, `specjedi-govcheck`, PR-only) never shorten, only planning ceremony does. Declines and redirects to `specjedi-specify` for anything bigger, ambiguous, or a new skill — see [Which path should I use?](#which-path-should-i-use) |
| `specjedi-analyze` 🔍 | Strictly read-only cross-check of `spec.md`/`plan.md`/`tasks.md` (and the constitution) for gaps, duplication, and contradictions — reports findings, never edits a file |
| `specjedi-checklist` ☑️ | Generates a custom checklist for a named focus area (security, accessibility, performance...) grounded entirely in this feature's own `spec.md`/`plan.md` — never generic boilerplate |
| `specjedi-converge` 🔁 | Detects drift between the actual codebase and `tasks.md` after manual changes, appending any gap as a new task instead of silently ignoring it — closes the loop back to `specjedi-implement` |
| `specjedi-find-skills` 🔍 | Suggests a specific, verified skill when your request touches a domain nothing installed covers well — never installs without asking first ([Principle XVII](.specify/memory/constitution.md)) |
| `specjedi-explain` 🎓 | Explains any SDD concept or command, calibrated to how experienced you sound — total beginner through daily practitioner, never the same canned answer either way ([Principle XIX](.specify/memory/constitution.md)) |
| `specjedi-migrate` 🔄 | Rewrites literal `/speckit-*` tooling references in your own constitution/spec/plan/tasks to their `specjedi-*` equivalents — never touches principle or requirement content, explicit request only |
| `specjedi-diagram` 📊 | Generates a render-verified Mermaid diagram — the right type inferred from content across the full Mermaid catalog (flowchart, sequence, ER, class, state, Gantt, timeline, user journey, kanban, mindmap, quadrant, pie, and more) — from an existing `spec.md`/`plan.md` — always a supplement to the source prose, never a replacement |
| `specjedi-status` 🧭 | Project-wide dashboard showing every feature's status, derived entirely from on-disk `spec.md`/`plan.md`/`tasks.md` artifacts — zero separately-maintained tracking system, never asserts "stalled" as a fact |
| `specjedi-retro` 🪞 | Strictly read-only retrospective comparing a completed feature's actual implementation against its `plan.md` — grounds any deviation's cause in real git history, never invents one, logs a durable dated entry |
| `specjedi-security` 🛡️ | Lightweight, proactive "did we think about X" prompt for auth/input validation/secrets/data-privacy gaps — self-invoked by `specjedi-plan`, never claims to be a full security review |
| `specjedi-docs` 📚 | Drafts a README skill-table row, Quickstart step, and `CHANGELOG.md` entry from a shipped feature's spec/plan — grounded in actual content, always shown for confirmation before writing |
| `specjedi-new-skill` 🌟 | Scaffolds a new `specjedi-*` skill's file structure — placeholders only, never invented content — following this project's own Skill Authoring Standard and baking in the Principle II research checklist |
| `specjedi-release` 🚀 | Wraps `scripts/suggest-release.sh` with Spec Jedi's own voice — narrates the last tag, suggested next version, and contributing commits; declines and names the manual command if asked to actually cut a release |
| `specjedi-skill-review` 🎓 | Strictly read-only audit of a `specjedi-*` skill's `SKILL.md` against the Skill Authoring Standard — checks section content, not just headings, cross-references the matching `plan.md` for legitimate exemptions, reports findings or a clean pass, never edits the reviewed file |
| `specjedi-tokencheck` 🎒 | Proactively checks whether `rtk` and `graphify` are installed, explains what's missing and its expected token savings, and offers an install walkthrough — self-invoked by `specjedi-onboard`'s first-run flow, also runs standalone; never installs anything without explicit confirmation |
| `specjedi-govcheck` ⚖️ | Strictly read-only per-PR/per-branch governance checklist against all 20 constitution principles — three-state report (N/A / Compliant / Non-Compliant), any conflict CRITICAL — self-invoked by `specjedi-implement` before opening a PR (never blocks it), also runs standalone against the current branch or a named PR |

See [`references/skill-roadmap.md`](references/skill-roadmap.md) for what's
proposed beyond the core pipeline (diagrams,
and more) — a backlog of *additional* skills, not core-pipeline gaps; each
still needs its own research pass before it gets built.

## How Spec Jedi builds *itself*, in comic form

> ⚠️ **This section is about our internal bootstrap process, not the Spec Jedi
> product.** The `/speckit-*` commands below are [spec-kit](https://github.com/github/spec-kit)'s
> own tooling — Spec Jedi currently dogfoods spec-kit to construct itself (the
> same "bootstrap a compiler with an older compiler" pattern), the way any
> competitor might use an incumbent's tools while building its replacement.
> **If you're evaluating Spec Jedi as a product, skip to
> [What you get today](#what-you-get-today) below** — the actual product surface
> is the `specjedi-*` skills, not these. See
> [Principle XV](.specify/memory/constitution.md) for the full policy on why
> these are kept clearly separate.
>
> Also, a note on format: the panels below pair text-and-emoji dialogue with
> original illustrations — never actual Star Wars imagery (characters, ships,
> the logo), which is Lucasfilm/Disney IP. This project's own
> [Principle XII](.specify/memory/constitution.md) commits to an original visual
> identity and text-only Star Wars references, never reproduced copyrighted art
> or artwork evoking the franchise's own recognizable signatures. So: the story
> beats are real, the art is original, and the words still carry the meaning on
> their own. 🖋️

---

**PANEL 1 — A lone terminal, blinking cursor.**
> 🧑‍💻 *"I have an idea for a feature. ...Now what?"*

![Panel 1: a lone glowing console terminal in a dark workshop](docs/comic/panel-1.jpg)

**PANEL 2 — A hooded figure steps out of the shadows, holding a scroll.**
> 🧙 *"First, the Code."* 📜
> `/speckit-constitution` — the project's non-negotiable rules, written down once,
> checked forever after.

![Panel 2: a robed archivist-mentor figure unrolling a glowing data-scroll](docs/comic/panel-2.jpg)

**PANEL 3 — The idea, pinned to a wall, question marks circling it.**
> 🌀 *"What are you really building — and for whom?"*
> `/speckit-specify` turns the idea into `spec.md`. `/speckit-clarify` hunts down
> the ambiguity before it becomes a bug.

![Panel 3: a corkboard covered in holographic sticky-notes and glowing question marks](docs/comic/panel-3.jpg)

**PANEL 4 — A blueprint unrolls across a workbench.**
> 🛠️ *"Now the how."*
> `/speckit-plan` → `plan.md`. `/speckit-tasks` → an ordered, dependency-aware
> `tasks.md`. No step skipped, no step out of order.

![Panel 4: a technical schematic unrolling across a cluttered workbench](docs/comic/panel-4.jpg)

**PANEL 5 — Tools whirring, tests failing red, then turning green one by one.**
> 🤖 *"Tests first. Always tests first."*
> `/speckit-implement` executes `tasks.md`, test-first where it applies
> ([Principle VI](.specify/memory/constitution.md)).

![Panel 5: a workshop wall of status lights flickering from red to green](docs/comic/panel-5.jpg)

**PANEL 6 — A council chamber. A pull request stands before the bench.**
> 🏛️ *"State your changes."*
> A PR opens. `ci-gate` 🤖 runs the full validation battery — every OS, every
> check. No self-approval allowed; the machine can't pardon itself, and neither
> can you ([Principle X](.specify/memory/constitution.md)).

![Panel 6: a circular chamber, robed elders seated around a raised dais](docs/comic/panel-6.jpg)

**PANEL 7 — Green light. The gate opens on its own.**
> ✅ *"The battery has spoken."*
> All checks pass → auto-merge, no human had to click a button.

![Panel 7: a massive mechanical blast door irising open under a green beacon light](docs/comic/panel-7.jpg)

**PANEL 8 — A ship leaps to hyperspace.**
> 🚀 *"Shipped."*
> 🌌 *"May the Spec be with you."*

![Panel 8: a sleek original-design starship streaking away against a starfield](docs/comic/panel-8.jpg)

This isn't a hypothetical — it's the literal, repeated process behind
this project's own recent pull requests (e.g. [#82](https://github.com/jonyfs/spec-jedi/pull/82),
[#84](https://github.com/jonyfs/spec-jedi/pull/84), [#87](https://github.com/jonyfs/spec-jedi/pull/87)),
each one running these exact eight panels for real.

### The same internal-bootstrap story, as a diagram

```mermaid
sequenceDiagram
    participant Dev as 🧑‍💻 Contributor
    participant Repo as 📜 Repo (main)
    participant PR as 🔀 Pull Request
    participant CI as 🤖 ci-gate
    Dev->>Repo: /speckit-constitution, /speckit-specify, /speckit-plan, /speckit-tasks
    Dev->>Dev: /speckit-implement (test-first)
    Dev->>PR: open PR on a feature branch
    PR->>CI: trigger validation battery (Linux/macOS/Windows)
    CI-->>PR: 🔴 red? fix and push again
    CI-->>PR: 🟢 green? proceed
    PR->>Repo: auto-merge (no self-approval, checks-only gate)
    Repo-->>Dev: 🚀 shipped — "This is the way."
```

## Prerequisites

Spec Jedi is developed and validated on **Linux, macOS, and Windows**
(Constitution [Principle XIII](.specify/memory/constitution.md)) — every script under
`scripts/` ships as both a POSIX shell (`.sh`) and a native PowerShell (`.ps1`)
version, and CI runs the battery on all three operating systems on every PR.

- `git`
- A supported coding agent (see [Supported harnesses](#supported-harnesses) below)
- [GitHub CLI (`gh`)](https://cli.github.com/), only if you plan to contribute changes
  back via pull request
- Only if you want to run the helper scripts locally (optional — the coding agent
  itself doesn't require them): a POSIX shell (bash/zsh, present by default on Linux
  and macOS) **or** [PowerShell 7+](https://aka.ms/powershell) (`pwsh`), which runs
  on all three operating systems

## Installation

Run one command — no `git clone` required. `scripts/bootstrap-install.sh`/`.ps1`
(specs/024-bootstrap-installer) fetch a published GitHub Release and run its
bundled installer against your target directory:

```bash
curl -fsSL https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.sh \
  | bash -s -- /path/to/your-project --harness cursor
```

```powershell
&([scriptblock]::Create((iwr -useb https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.ps1).Content)) -TargetDir C:\path\to\your-project -Harness cursor
```

`--harness` is optional — if omitted, the installer attempts to detect
which coding agent you're using among `claude-code`/`codex-cli`/`trae` (a
project directory, a `PATH` binary, or a global config directory already
present) and installs for it automatically, asking only if detection finds
more than one plausible match. The other 17 harnesses (no reliable
filesystem/PATH detection signal exists for them yet) require passing
`--harness` explicitly — see [Supported harnesses](#supported-harnesses)
below for the full list. Run `./scripts/bootstrap-install.sh --help` (or
`.\scripts\bootstrap-install.ps1 -Help`) for the full option list, including
`--auto`.

### Supported harnesses

Spec Jedi's constitution ([Principle III](.specify/memory/constitution.md)) commits
this project to supporting the twenty highest-usage LLM coding
tools/harnesses in the market — as of this release, all twenty are real,
tested, and CI-proven. Four use a native skills-directory scan (Claude
Code, Codex CLI, Trae, Antigravity — the last three sharing just two
physical target directories, `.agents/skills/` and `.trae/skills/`, plus
OpenCode and Warp satisfied by those same paths with zero extra code).
The remaining fourteen have no native skills-directory concept — only a
project-root rules file, a small rules directory, or (Sourcegraph Cody) a
custom-commands JSON file — so the installer generates a **bridge**: the
full `specjedi-*` packages still land at the canonical `.claude/skills/`,
and a small adapter file (or one file per skill, for directory-style
harnesses) points into it using that harness's own documented convention.
See [`specs/023-full-harness-coverage/research.md`](specs/023-full-harness-coverage/research.md)
for the citation backing each harness's exact mechanism.

```mermaid
flowchart LR
    subgraph Native["✅ Native skills-directory scan — 4"]
        direction TB
        CC[Claude Code]
        CX[Codex CLI]
        AG[Antigravity]
        TR[Trae]
    end
    subgraph Bridge["✅ Bridge-file install — 14"]
        direction TB
        CU[Cursor]
        GC[GitHub Copilot]
        GM[Gemini CLI]
        WS[Windsurf]
        CL[Cline]
        CN[Continue]
        AI[Aider]
        AQ[Amazon Q]
        JB[JetBrains AI]
        ZD[Zed]
        RA[Replit Agent]
        DV[Devin]
        TB2[Tabnine]
        SC[Sourcegraph Cody]
    end
    subgraph ZeroCode["✅ Zero-code reuse — 2"]
        direction TB
        OC[OpenCode]
        WA[Warp]
    end
```

| Harness | Status |
|---|---|
| Claude Code | ✅ Supported — the [Installation](#installation) command above, omit `--harness` (auto-detected) or pass `--harness claude-code` explicitly |
| Cursor | ✅ Supported — `./scripts/install.sh --harness cursor` (bridge files under `.cursor/rules/`) |
| GitHub Copilot (Chat/Workspace) | ✅ Supported — `./scripts/install.sh --harness copilot` (bridge file at `.github/copilot-instructions.md`) |
| Codex CLI (OpenAI) | ✅ Supported — `./scripts/install.sh --harness codex-cli` (installs to `.agents/skills/`) |
| Gemini CLI | ✅ Supported — `./scripts/install.sh --harness gemini-cli` (bridge file at `GEMINI.md`; Google is sunsetting Gemini CLI in favor of Antigravity — see [`references/harness-capability-notes.md`](references/harness-capability-notes.md)) |
| Antigravity (Google) | ✅ Supported — `./scripts/install.sh --harness antigravity` (installs to `.agents/skills/`, same convention as Codex CLI) |
| Windsurf (Codeium) | ✅ Supported — `./scripts/install.sh --harness windsurf` (bridge files under `.windsurf/rules/`) |
| Cline | ✅ Supported — `./scripts/install.sh --harness cline` (bridge files under `.clinerules/`) |
| Continue | ✅ Supported — `./scripts/install.sh --harness continue` (bridge files under `.continue/rules/`) |
| Aider | ✅ Supported — `./scripts/install.sh --harness aider` (bridge file at `CONVENTIONS.md`) |
| Amazon Q Developer | ✅ Supported — `./scripts/install.sh --harness amazon-q` (bridge files under `.amazonq/rules/`) |
| JetBrains AI Assistant | ✅ Supported — `./scripts/install.sh --harness jetbrains-ai` (bridge files under `.aiassistant/rules/`) |
| Zed | ✅ Supported — `./scripts/install.sh --harness zed` (bridge file at `.rules`) |
| OpenCode | ✅ Supported — satisfied by either the `claude-code` or `codex-cli` install (OpenCode natively scans both `.claude/skills/` and `.agents/skills/`), no separate flag needed |
| Warp (Agent Mode) | ✅ Supported — satisfied by either the `claude-code` or `codex-cli` install (Warp's Skills system natively scans both `.claude/skills/` and `.agents/skills/`), no separate flag needed |
| Replit Agent | ✅ Supported — `./scripts/install.sh --harness replit` (bridge file at `replit.md`) |
| Devin (Cognition) | ✅ Supported — `./scripts/install.sh --harness devin` (bridge file at `.devin.md`, structured as a Devin Playbook) |
| Tabnine | ✅ Supported — `./scripts/install.sh --harness tabnine` (bridge files under `.tabnine/guidelines/`) |
| Sourcegraph Cody | ✅ Supported — `./scripts/install.sh --harness cody` (`.vscode/cody.json` custom commands, invoked explicitly as `/specjedi-<name>`; unlike every other harness above, Cody has no confirmed always-on rules file, so this is manual-invocation, not automatic context — see the research doc) |
| Trae | ✅ Supported — `./scripts/install.sh --harness trae` (installs to `.trae/skills/`) |

Twenty harnesses named individually per Principle III's "at least twenty"
mandate, all ✅ Supported — no capability claims for any mechanism this
project hasn't actually built and tested against, per Principle XX's
hallucination-resistance discipline.

See [`references/harness-capability-notes.md`](references/harness-capability-notes.md)
for the original desk-research capability notes per harness, and
[`specs/023-full-harness-coverage/research.md`](specs/023-full-harness-coverage/research.md)
for the install-mechanism decisions and citations this table is built from.

Curious how Spec Jedi stacks up against spec-kit and the ten other SDD tools
it was benchmarked against? See
[`references/competitive-comparison.md`](references/competitive-comparison.md).

Want the unfiltered version — genuine advantages, genuine current
limitations, and concrete competitor-grounded improvement points? See
[`references/honest-assessment.md`](references/honest-assessment.md).

New to Spec-Driven Development itself, not just this project? Start with
[`references/what-is-sdd.md`](references/what-is-sdd.md) — a from-scratch
explanation with zero Spec Jedi branding — then see
[`references/specjedi-and-sdd.md`](references/specjedi-and-sdd.md) for
exactly which skill handles which part of the practice.

## Quickstart

Twenty-four product skills ship today ([What you get today](#what-you-get-today))
— the full `specjedi-*` pipeline is complete. Never used an SDD tool
before? Start with step 0.

### Which path should I use?

| Change size | Use | Produces |
|---|---|---|
| Small, well-understood — a typo, a one-file fix, a tightly-scoped tweak | `specjedi-quick` ⚡ | One `quick.md`, straight to shipped code |
| Anything bigger, ambiguous, touching more than one subsystem, or a new `specjedi-*` skill | The full pipeline (steps 3-11 below) | `spec.md` → `plan.md` → `tasks.md` → shipped code |

`specjedi-quick` checks eligibility itself against five explicit
criteria before writing anything — if your request doesn't actually fit
on about one page of notes, it declines and redirects you to
`specjedi-specify` rather than forcing it through. Either path enforces
the same quality gates (test-first where code is involved,
`specjedi-govcheck` before a PR opens) — "quick" only shortens planning
ceremony, never verification.

0. **Not sure what any of this means?** Just ask — "what is a spec and why
   would I need one," "what does this project actually do." `specjedi-explain`
   🎓 answers at whatever depth you need, beginner or advanced, and always
   points you to what to run next ([Principle XIX](.specify/memory/constitution.md)).
1. Install (see [Installation](#installation) above).
2. Brand-new project, no idea where to start? `specjedi-onboard` 🌱 walks
   you through producing a real first `constitution.md` and `spec.md`
   together from a one-sentence idea, explaining each concept only when
   you actually need it — never a wall of docs up front. (Steps 3-4 below
   are exactly what it orchestrates for you; skip straight to them if
   you'd rather run each stage yourself.)
3. Establish your project's rules: describe your non-negotiables in plain
   language and `specjedi-constitution` 📜 produces a versioned
   `.specify/memory/constitution.md` — every other `specjedi-*` skill checks
   its own output against it.
4. Spec a feature: describe what you want to build — a rough one-sentence idea
   is enough — and `specjedi-specify` 🎯 turns it into a prioritized,
   independently-testable `spec.md`, marking real ambiguity instead of
   guessing at it.
5. Not sure the spec is solid yet? `specjedi-clarify` 🌀 scans it for real
   ambiguity and asks up to 5 prioritized questions — each with a
   Recommended answer, so you can accept it in one word or read the
   reasoning if you want it — before anything gets planned against a guess.
6. Ready to design the "how"? `specjedi-plan` 🛠️ scans your actual codebase
   for existing conventions first, then turns the clarified spec into a
   technical `plan.md` — so implementation never has to stop and search
   for a pattern that already exists elsewhere in your project. If your
   spec touches auth, external input, secrets, or data handling,
   `specjedi-security` 🛡️ triggers automatically with a few targeted
   "did we think about X" questions — a lightweight prompt, never a full
   security review.
7. Ready to break it into work? `specjedi-tasks` ✅ turns the plan into an
   ordered, dependency-aware `tasks.md` grouped by user story — a failing
   test task sequenced before its implementation task wherever the plan
   calls for code.
8. Ready to build it? `specjedi-implement` 🔨 executes `tasks.md` in
   dependency order, test-first where the plan calls for code — every
   commit lands on a feature branch and a pull request, never directly on
   `main`.
9. Want a safety net? `specjedi-analyze` 🔍 cross-checks `spec.md`,
   `plan.md`, and `tasks.md` (and your constitution) for gaps, duplication,
   or contradictions — strictly read-only, runnable any time, never edits
   a file.
10. Need a targeted review? `specjedi-checklist` ☑️ generates a checklist
    for a named focus area — security, accessibility, performance, whatever
    you name — grounded entirely in this feature's own spec/plan, never
    generic boilerplate.
11. Changed code by hand since your last `tasks.md`? `specjedi-converge`
    🔁 scans the actual codebase, detects any capability with no
    corresponding task, and appends it as new work instead of letting it
    silently drift out of sync — the pipeline's final stage, closing the
    loop back to `specjedi-implement`.
12. Stuck on something outside this set? Just describe it — "how do I do X,"
    "is there a skill for X" — and `specjedi-find-skills` 🔍 triggers
    automatically, searches the open agent-skills ecosystem, and suggests a
    specific, verified skill. Never installs anything without asking first
    ([Principle VIII](.specify/memory/constitution.md)).
13. Coming from an existing spec-kit project? `specjedi-migrate` 🔄
    rewrites your project's own `/speckit-*` tooling references to their
    `specjedi-*` equivalents — never touches a principle or requirement,
    explicit request only.
14. Want a picture instead of a wall of prose? `specjedi-diagram` 📊 turns
    a spec or plan into a render-verified Mermaid diagram — chosen from
    Mermaid's full diagram catalog (see
    [`references/mermaid-diagram-catalog.md`](references/mermaid-diagram-catalog.md)),
    whichever type the actual content calls for — always alongside the
    source prose, never in place of it.
15. Juggling more than one or two features? `specjedi-status` 🧭 shows a
    project-wide dashboard — which features are specified, planned, in
    progress, or complete — derived entirely from what's actually on
    disk, no separate tracking system to keep in sync.
16. Just finished a feature? `specjedi-retro` 🪞 compares what actually
    shipped against what `plan.md` said, grounds any deviation's cause in
    real git history — never invents one — and logs a durable entry so
    the signal survives past this conversation.
17. Shipped something and need it documented? `specjedi-docs` 📚 drafts
    the README row, Quickstart step, and `CHANGELOG.md` entry for you —
    grounded in your actual spec/plan, always shown for confirmation
    before anything is written.
18. Extending Spec Jedi itself with a new skill? `specjedi-new-skill` 🌟
    scaffolds the file structure — `specs/`, `SKILL.md` skeleton, every
    section a labeled placeholder — never invented research findings or
    behavior on your behalf.
19. Wondering if a release is due? `specjedi-release` 🚀 narrates
    `scripts/suggest-release.sh`'s own suggestion — last tag, next
    version, contributing commits — and declines with the exact manual
    command if you ask it to actually cut one; it never tags or
    publishes itself.
20. Wrote or changed a `specjedi-*` skill by hand? `specjedi-skill-review`
    🎓 checks its `SKILL.md` against the Skill Authoring Standard — section
    content, not just headings, cross-referenced against the matching
    `plan.md` for legitimate exemptions — and reports findings or a clean
    pass; it never edits the file itself.
21. `specjedi-onboard` already runs this once for you on first use, but
    `specjedi-tokencheck` 🎒 works standalone too — checks whether `rtk`
    and `graphify` are installed, explains what's missing and its expected
    token savings, and offers to walk through installing it; never
    installs anything without your explicit yes.
22. `specjedi-implement` already runs this before opening every PR, but
    `specjedi-govcheck` ⚖️ works standalone too — a per-branch (or
    per-PR) checklist against all 20 constitution principles, reporting
    each as not applicable, compliant, or non-compliant, with any real
    conflict marked CRITICAL; strictly read-only, never edits anything,
    never blocks a PR from opening on its own.

Per [Principle XIV](.specify/memory/constitution.md), whatever you just ran
should tell you what to run next — you shouldn't need to come back to this
list to figure it out. The full chain runs `specjedi-onboard` (first run
only) → `specjedi-constitution` → `specjedi-specify` → `specjedi-clarify` →
`specjedi-plan` → `specjedi-tasks` → `specjedi-implement` →
`specjedi-analyze` → `specjedi-checklist` → `specjedi-converge`, looping
back to `specjedi-implement` whenever `specjedi-converge` finds drift to
work through.

### The pipeline, end to end

Onboarding through convergence — every stage below is live:

```mermaid
flowchart TD
    Y["✅ specjedi-migrate 🔄<br/>coming from spec-kit: rewrite tooling refs"] -.-> A
    Z["✅ specjedi-onboard 🌱<br/>first run only: idea → constitution + spec"] -.-> A
    A["✅ specjedi-constitution 📜<br/>establish or amend the project's rules"] --> B["✅ specjedi-specify 🎯<br/>feature idea → spec.md"]
    B --> C{"✅ specjedi-clarify 🌀<br/>ambiguity to resolve?"}
    C -->|yes| C2["✅ resolve, encode answers into spec.md"] --> D
    C -->|no| D["✅ specjedi-plan 🛠️<br/>spec.md → plan.md"]
    D --> E["✅ specjedi-tasks ✅<br/>plan.md → tasks.md"]
    E --> F["✅ specjedi-implement 🔨<br/>execute tasks.md"]
    F --> G{"✅ specjedi-analyze 🔍<br/>spec/plan/tasks consistent?"}
    G -->|gaps found| H["✅ specjedi-converge 🔁<br/>append drift as new tasks"] --> F
    G -->|clean| I(["🚀 shipped"])
    F -.->|need a checklist mid-flight| J["✅ specjedi-checklist ☑️<br/>ships today"]
    F -.->|stuck outside this pipeline| K["✅ specjedi-find-skills 🔍<br/>ships today"]
    D -.->|want a picture of the spec/plan| L["✅ specjedi-diagram 📊<br/>ships today"]
```

✅ = ships today — the full 9-stage `specjedi-*` pipeline is complete, plus
`specjedi-onboard` as the guided first-run entry point.

## Recommended companions

This project's constitution ([Principle VIII](.specify/memory/constitution.md))
directs every Spec Jedi session to proactively suggest, but never silently install,
two token-saving companions:

- [`rtk`](https://github.com/rtk-ai/rtk) — a token-optimized CLI proxy for common dev
  operations.
- [`graphify`](https://graphify.net/) — turns a codebase into a queryable knowledge
  graph.

If your agent offers to install or configure either, that's this policy in action —
you're always asked first.

**graphify is already wired into this repo** (with maintainer confirmation): a
`## graphify` section in `CLAUDE.md` tells Claude Code to consult the knowledge graph
before browsing source and to refresh it after code changes, and `.claude/settings.json`
registers hooks that nudge tool calls toward `graphify query`/`explain`/`path` instead
of raw grep/read once the graph exists. The graph itself
(`graphify-out/`) is not committed — it's a derived cache, regenerated per clone.

To get the same auto-updating behavior locally after cloning:

```bash
pip install graphifyy   # or: uv tool install graphifyy
graphify .               # first build (only needed once; also runs on first use anyway)
graphify hook install    # auto-rebuild graph.json after every commit (code changes)
```

Doc/content changes aren't picked up by the commit hook — run `graphify update .`
(or just ask your agent to) after editing non-code files.

## Versioning & releases

Spec Jedi follows [Semantic Versioning](https://semver.org/) for its own releases,
scoped to the public skill-package contract (breaking skill behavior = MAJOR, new
skills or additive capability = MINOR, fixes/docs = PATCH). See
[Principle XI](.specify/memory/constitution.md) for the full policy.

The project suggests when a release is warranted rather than cutting one silently:

```bash
# Linux / macOS / Windows (WSL or Git Bash)
./scripts/suggest-release.sh
```

```powershell
# Windows (native PowerShell)
./scripts/suggest-release.ps1
```

This inspects commits since the last tag and recommends a next version — it never
tags or publishes anything itself. Actually cutting a release is always a deliberate,
maintainer-driven step.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full contribution process —
competitive research requirements for new skills, the Skill Authoring
Standard checklist, and validation steps to run before opening a PR.

Every change ships through a pull request validated by this project's own CI battery
and auto-merged only once every check is green (see
[Principle IX and X](.specify/memory/constitution.md)). That battery runs on Linux,
macOS, and Windows on every PR (Principle XIII) — if you add or change a script under
`scripts/`, both the `.sh` and `.ps1` versions must exist and pass on all three.
Issue and PR templates (`.github/ISSUE_TEMPLATE/`,
`.github/PULL_REQUEST_TEMPLATE.md`) walk contributors through confirming they
performed the research and validation steps above before requesting review.

## License

[MIT](LICENSE) — chosen and required by this project's own constitution
(Distribution & Ecosystem Standards). In plain language, MIT means you can:

- **Use** this project, commercially or otherwise, no restrictions.
- **Modify** it however you want.
- **Redistribute** it, including as part of something you sell.

The only real conditions: keep the original copyright notice and license text
somewhere in your copy, and don't expect a warranty — the software is provided
"as is," with no liability if something breaks. That's the whole deal; see
[`LICENSE`](LICENSE) for the exact legal text.

---

🌌 *This is the way.*


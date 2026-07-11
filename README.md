# 🗡️ Spec Jedi

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
or sponsored by Lucasfilm/Disney. May the Spec be with you. 🌌)*

## Who this is for

Anyone using an AI coding agent who wants specs, plans, and tasks to be first-class,
versioned artifacts instead of throwaway chat messages — solo developers, teams
standardizing how their agents work, and anyone tired of re-explaining project
context every session.

## Prerequisites

- `git`
- A supported coding agent (see [Supported harnesses](#supported-harnesses) below)
- [GitHub CLI (`gh`)](https://cli.github.com/), only if you plan to contribute changes
  back via pull request

## Installation

### Claude Code (fully supported today)

1. Clone this repository:

   ```bash
   git clone https://github.com/jonyfs/spec-jedi.git
   cd spec-jedi
   ```

2. Open the folder in [Claude Code](https://claude.com/claude-code). Claude Code
   auto-discovers every skill under `.claude/skills/*/SKILL.md` — there is no
   separate install step or build process.

3. Confirm the skills loaded by typing `/` in the Claude Code prompt. You should see
   the `speckit-*` commands listed (see [Quickstart](#quickstart) for what each one
   does).

4. That's it — you're ready to run the workflow below.

**Using Spec Jedi in a project other than this one?** Copy the `.claude/skills/`
directory (and `.specify/` if you want the full spec-kit scaffolding, templates, and
scripts) into your target repository, then follow steps 2–4 above from that repo.

### Supported harnesses

Spec Jedi's constitution ([Principle III](.specify/memory/constitution.md)) commits
this project to eventually supporting the twenty highest-usage LLM coding
tools/harnesses in the market. Today, only the path above (Claude Code) has been
built, tested, and documented end to end.

| Harness | Status |
|---|---|
| Claude Code | ✅ Supported — see steps above |
| Cursor, Windsurf, GitHub Copilot, Codex CLI, Gemini CLI/Antigravity, Cline, Continue, Aider, and others | 📋 Planned — tracked as future work, not yet installable |

If your harness isn't listed as supported yet, the `SKILL.md` files are plain
Markdown with YAML frontmatter — many harnesses that support custom
instructions/prompts can already read them directly even without a dedicated
install path, but this hasn't been verified or documented per-harness yet.

## Quickstart

The SDD workflow this project ships runs in this order:

```text
/speckit-constitution   → establish or amend the project's non-negotiable rules
/speckit-specify        → turn a feature idea into a spec.md
/speckit-clarify        → resolve ambiguity in the spec before planning (optional but recommended)
/speckit-plan           → turn the spec into a technical plan.md
/speckit-tasks          → break the plan into an ordered, dependency-aware tasks.md
/speckit-implement      → execute tasks.md
/speckit-analyze        → cross-check spec/plan/tasks for consistency at any point
/speckit-checklist      → generate a custom checklist for the current feature
/speckit-converge       → diff the codebase against spec/plan/tasks and queue any remaining work
/speckit-taskstoissues  → turn tasks.md into GitHub issues, if you prefer issue-tracker-driven work
```

Start every new project or repository with `/speckit-constitution` — every other
skill checks its output against whatever the constitution says.

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

## Versioning & releases

Spec Jedi follows [Semantic Versioning](https://semver.org/) for its own releases,
scoped to the public skill-package contract (breaking skill behavior = MAJOR, new
skills or additive capability = MINOR, fixes/docs = PATCH). See
[Principle XI](.specify/memory/constitution.md) for the full policy.

The project suggests when a release is warranted rather than cutting one silently:

```bash
./scripts/suggest-release.sh
```

This inspects commits since the last tag and recommends a next version — it never
tags or publishes anything itself. Actually cutting a release is always a deliberate,
maintainer-driven step.

## Contributing

Every change ships through a pull request validated by this project's own CI battery
and auto-merged only once every check is green (see
[Principle IX and X](.specify/memory/constitution.md)). A full `CONTRIBUTING.md` with
the step-by-step contribution process is on the roadmap; until it lands, read the
constitution first — it's the definitive statement of how this project expects
changes to be made.

## License

Not yet chosen. An OSI-approved license is required by this project's own
constitution (Distribution & Ecosystem Standards) and is tracked as an open item
until the maintainer selects one.

---

🌌 *This is the way.*

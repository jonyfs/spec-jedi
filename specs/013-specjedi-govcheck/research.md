# Research: `specjedi-govcheck`

**Feature**: 013-specjedi-govcheck

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

The project's own Development Workflow section states: "Code and content
review MUST explicitly check compliance with every Core Principle above
before approval." A fresh project-wide requirements-completeness checklist
(`checklists/project-completeness.md`, CHK005) found no artifact actually
mechanizes this — `specjedi-skill-review` (feature 011) checks one skill's
`SKILL.md` against Principle XIX's authoring standard specifically, and
`specjedi-analyze` (feature 001) checks spec/plan/tasks internal
consistency plus constitution conflicts for one feature's own artifacts.
Neither checks a PR's actual changeset against project-wide governance
principles that live outside any single skill's `SKILL.md` content: badge
row currency (Distribution & Ecosystem Standards), cross-platform script
pairing (Principle XIII), CI battery completeness (Principle IX), semver
scope (Principle XI), and so on. The gap this checklist found and closed
partially (`references/principle-traceability.md`, a static per-principle
index) still leaves the *per-PR, per-change* question unanswered: does
*this* changeset comply with everything applicable?

## Internal-redundancy check (established discipline since feature 007)

Checked against every shipped `specjedi-*` skill: `specjedi-analyze`
checks spec/plan/tasks-vs-constitution consistency for one feature's own
artifacts — a different, narrower target than "this PR's actual file
changes against every applicable principle." `specjedi-skill-review`
checks one `SKILL.md`'s authoring quality against Principle XIX
specifically — a single-principle deep check, not a full-principle-set
sweep. `specjedi-checklist` (the underlying `speckit-checklist` mechanism)
produces feature-specific requirements-quality checklists, not a
governance-compliance checklist against the constitution itself. No
shipped skill produces a per-PR governance checklist across all 20
principles. No redundancy found — and this skill is explicitly designed
to *read* `references/principle-traceability.md` (created this session)
rather than duplicate its per-principle summary, keeping single-sourced
what that file already established.

## Genuine contribution beyond the researched field

None of the eleven tools researched across features 001-012 ship a
per-PR governance-compliance checklist generator that checks an actual
changeset against the project's own full constitution/principle set (as
opposed to a fixed, generic PR template checklist unrelated to the
project's specific governance content). Most researched tools either have
no formal constitution/principle-set concept at all, or (where a
CONTRIBUTING-style checklist exists) it's a static template a human fills
in by hand, not a change-aware, per-run assessment referencing the actual
files touched. The genuine contribution: turning "review MUST check every
Core Principle" from a standing instruction reviewers have to remember
into a runnable report that reads the actual diff and reasons per
principle whether it's touched, compliant, or N/A — the same "make a
mandated practice a real mechanism" shape as `specjedi-release`,
the installer, and `specjedi-tokencheck`.

## Baseline: GitHub spec-kit

No per-PR governance-checklist generator referencing the project's own
constitution content. **Adopt**: nothing (no mechanism to adopt).
**Reject**: none applicable.

## Researched competitors (re-checked for per-PR governance-compliance tooling)

1. **BMAD-METHOD** — no per-PR governance-checklist mechanism found.
2. **OpenSpec** — no per-PR governance-checklist mechanism found.
3. **Kiro** — no per-PR governance-checklist mechanism found in its
   public surface.
4. **Tessl** — no per-PR governance-checklist mechanism found.
5. **Spec Kitty** — no per-PR governance-checklist mechanism found.
6. **Superpowers** (installed, inspected firsthand) — no equivalent
   change-aware governance-checklist mechanism.
7. **GSD** (installed, inspected firsthand) — no equivalent mechanism
   found in the installed command set inspected.
8. **PRP** (installed, inspected firsthand) — no equivalent mechanism
   found.
9. **codemyspec.com** — no comparable mechanism found.
10. **Traycer** — no comparable mechanism found.

**Adopt**: nothing directly transferable — this confirms the gap rather
than pointing to prior art to adapt.

## Design implications for `specjedi-govcheck`

- **Report, never fix** — same strictly read-only discipline as
  `specjedi-analyze`/`specjedi-skill-review`: this skill produces a
  findings checklist, it never edits any file itself.
- **Change-scoped, not project-wide** — unlike
  `checklists/project-completeness.md` (a one-time whole-constitution
  audit), this skill runs against a specific changeset: the current
  branch's diff against `main` by default, or a named open PR via `gh pr
  diff <N>` when given a PR number. Re-runnable every time, unlike a
  one-shot audit.
- **N/A is a valid, expected answer for most principles per run** — a
  single PR rarely touches all 20 principles; the report MUST distinguish
  "not applicable to this change" from "applicable and non-compliant"
  from "applicable and compliant," never collapsing the three.
- **Any constitution conflict is CRITICAL** — same absolute rule
  `specjedi-analyze` already applies: no severity downgrade for "the
  violation seems minor."
- **Read, don't duplicate, the traceability index** — reference
  `references/principle-traceability.md` for each principle's known
  implementing mechanism rather than re-deriving that mapping inline,
  keeping the two artifacts single-sourced against drift.
- **Concrete, checkable triggers per principle** — e.g., Principle XIII
  (cross-platform): did this PR add a `.sh` without a `.ps1` counterpart,
  or vice versa? Distribution & Ecosystem Standards (badges): does this PR
  touch a capability that would make an existing badge stale, or warrant
  a new one, without updating the badge row? These are mechanically
  checkable from the diff, not just prose judgment calls.

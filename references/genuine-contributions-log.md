# Genuine Contributions Log

Durable, spot-checkable record of the one-sentence "genuine contribution"
claim each shipped feature's `research.md` makes under Constitution
[Principle II](../.specify/memory/constitution.md) ("`research.md` MUST
... name at least one capability the resulting design offers that no
researched competitor has"). Closes
`checklists/project-completeness.md` CHK013: previously each claim lived
only inside its own feature's `research.md`, with no single place to
spot-check the full set against the actual researched-competitor field
over time.

**How to use this**: when re-researching any of the eleven-tool field
(spec-kit + the ten competitors named in `specs/001-specjedi-pipeline/research.md`)
for a future feature, or when a competitor plausibly ships a new
capability, spot-check the relevant row(s) below — has the researched
field caught up to the claim? If so, that's a real signal worth
recording here and considering for `references/skill-roadmap.md`, not a
reason to quietly leave a stale claim standing.

| Feature | Skill | One-line genuine-contribution claim | Full detail |
|---|---|---|---|
| 001 | `specjedi-*` pipeline | Constitution-enforced auto-merge CI governance — no researched tool ties its rules document to an actual CI gate blocking merge with structural self-approval prevention. | [research.md](../specs/001-specjedi-pipeline/research.md) |
| 002 | `specjedi-onboard` | A dedicated first-run skill producing the user's actual first constitution and spec together, teaching concepts exactly when needed rather than front-loading docs. | [research.md](../specs/002-specjedi-onboard/research.md) |
| 003 | `specjedi-migrate` | A working migration skill rewriting a competitor's own artifacts in place, not a manual "how to switch" doc page. | [research.md](../specs/003-specjedi-migrate/research.md) |
| 004 | `specjedi-diagram` | Verifies a generated diagram actually renders before presenting it, rather than treating syntax validity as the reader's problem. | [research.md](../specs/004-specjedi-diagram/research.md) |
| 005 | `specjedi-status` | Derives project status entirely from on-disk artifact state (spec/plan/tasks existence and checkbox ratio), zero separately-maintained tracking system. | [research.md](../specs/005-specjedi-status/research.md) |
| 006 | `specjedi-retro` | Appends completed-feature deviations to a durable, cross-feature signal log feeding future development, not a one-off human ceremony. | [research.md](../specs/006-specjedi-retro/research.md) |
| 007 | `specjedi-security` | Proactively surfaces security blind spots during planning, before any checklist or audit is explicitly requested. | [research.md](../specs/007-specjedi-security/research.md) |
| 008 | `specjedi-docs` | Derives README/changelog updates from the same artifacts the SDD pipeline already produces, not a separately-maintained doc surface. | [research.md](../specs/008-specjedi-docs/research.md) |
| 009 | `specjedi-new-skill` | A meta-skill scaffolding a new skill's own file structure for this project's ecosystem — no researched tool's extensibility model does this. | [research.md](../specs/009-specjedi-new-skill/research.md) |
| 010 | `specjedi-release` | A release-suggestion mechanism that is simultaneously fully automatic, never auto-publishes, and wrapped in the project's own voice/next-step UX. | [research.md](../specs/010-specjedi-release/research.md) |
| 011 | `specjedi-skill-review` | A self-review mechanism checking the project's own skill files against a documented authoring standard — no researched tool formalizes and automates this. | [research.md](../specs/011-specjedi-skill-review/research.md) |
| 012 | `specjedi-tokencheck` | A self-referential token-saving-companion check bundled into onboarding/session flow, savings explained, install confirmation-gated. | [research.md](../specs/012-specjedi-tokencheck/research.md) |
| 013 | `specjedi-govcheck` | A per-PR governance-compliance checklist generator checking an actual changeset against the project's own full principle set, not a generic PR template. | [research.md](../specs/013-specjedi-govcheck/research.md) |

## Maintenance

Add a new row here in the same PR that ships any future feature's
`research.md` — this file is a summary index, not a replacement for the
full research document; keep entries to one line and link back for
detail.

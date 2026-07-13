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
| 014 | `references/competitive-comparison.md` | N/A — packages feature 001's existing 11-tool research into a table; explicitly performs no new competitor research (Principle II exemption stated directly in research.md). | [research.md](../specs/014-competitive-comparison/research.md) |
| 015 | `SessionStart` hook (Principle XXI) | Ties a harness-level `SessionStart` hook to a status summary + branded ASCII art + rotating persona greeting, all three combined automatically on every session — no researched SDD tool assembles this combination. | [research.md](../specs/015-session-start-hook/research.md) |
| 016 | `install.sh --harness codex-cli` | N/A — Principle III harness-compatibility extension, not a new mechanism; reuses the existing skills-directory copy/validate pattern with zero content rewrite. | [research.md](../specs/016-codex-cli-install/research.md) |
| 017 | `install.sh` (OpenCode) | N/A — harness-compatibility extension; OpenCode already scans the two paths the installer already writes to, zero new install code. | [research.md](../specs/017-opencode-support/research.md) |
| 018 | `install.sh` (Warp) | N/A — harness-compatibility extension; Warp's Skills mechanism already scans the same two existing paths, zero new install code. | [research.md](../specs/018-warp-support/research.md) |
| 019 | `install.sh --harness trae` | N/A — harness-compatibility extension; Trae's own `.trae/skills/` convention needed a genuinely new branch, but it reuses feature 001's existing copy/validate pattern, not a new mechanism. | [research.md](../specs/019-trae-support/research.md) |
| 020 | `scripts/package-release.sh` + release workflow | Packages a downloadable, versioned release artifact via a documented CI-driven workflow — the researched field is entirely git-clone-first installs; none ship a packaged release artifact this way (the contribution feature 024 later builds on). | [research.md](../specs/020-release-packaging/research.md) |
| 021 | `install.sh --auto` | N/A — Principle III harness auto-detection extension, not a new SDD mechanism; no genuine-contribution claim made. | [research.md](../specs/021-harness-auto-detection/research.md) |
| 022 | (verification-only) | N/A — closes an existing verification gap (Principle XXI's T020/SC-003) with real observed evidence, not a new mechanism. | [research.md](../specs/022-session-start-verification/research.md) |
| 023 | `install.sh`/`.ps1` (18-harness bridge mechanism) | The bridge-file mechanism itself — single-index vs. per-skill-directory vs. Cody's custom-commands JSON, chosen per harness's own documented shape — bridges one canonical skill package into fourteen different harness conventions; no researched competitor does this. | [research.md](../specs/023-full-harness-coverage/research.md) |
| 024 | `scripts/bootstrap-install.sh`/`.ps1` | N/A on its own — Spec-Jedi-specific plumbing on top of feature 020's own genuine contribution (a packaged, versioned release artifact); no researched SDD tool ships a bootstrap installer at all, since none package a release the way feature 020 does. | [research.md](../specs/024-bootstrap-installer/research.md) |
| 025 | `specjedi-diagram` (revision) | N/A — revises an already-shipped skill (feature 004); theme-safety/complexity-threshold rules are grounded in Mermaid's and GitHub's own documented rendering behavior, not a competitive benchmark. | [research.md](../specs/025-diagram-readability/research.md) |
| 026 | `specjedi-diagram` (revision) | N/A — revises an already-shipped skill (feature 004); grounded in this session's own first-hand render-failure evidence, not a competitive benchmark. | [research.md](../specs/026-mandatory-render-verify/research.md) |
| 027 | `references/honest-assessment.md` | N/A as new mechanism — re-reads feature 014's existing 11-tool table for improvement points; its own genuine finding is process, not mechanism: a prior "Adopted" BMAD idea (a lightweight quick-path) was never actually shipped. | [research.md](../specs/027-honest-pros-cons-doc/research.md) |
| 028 | `specjedi-quick` | Runs a lightweight, single-artifact `quick.md` fast path inside a project that also enforces a live, versioned constitution (research citation, test-first default, validation battery, trunk-based PR workflow) — no competitor's lightweight mode was found to be constitution-gated this way. | [research.md](../specs/028-specjedi-quick/research.md) |

## Maintenance

Add a new row here in the same PR that ships any future feature's
`research.md` — this file is a summary index, not a replacement for the
full research document; keep entries to one line and link back for
detail.

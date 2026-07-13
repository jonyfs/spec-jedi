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
| 015 | session-start hook | A three-part orientation (banner, on-disk-derived status, rotating persona line) sourced from the same status logic `specjedi-status` already uses — no parallel tracking system, unlike competitors' generic welcome messages. | [research.md](../specs/015-session-start-hook/research.md) |
| 016 | `--harness codex-cli` | A genuinely new installer branch verified against Codex CLI's own official docs, not a reused generic path assumed to work. | [research.md](../specs/016-codex-cli-install/research.md) |
| 017 | OpenCode support | Zero new installer code — proved via direct audit that all shipped skill names already satisfy OpenCode's exact naming rule, rather than claiming compatibility unverified. | [research.md](../specs/017-opencode-support/research.md) |
| 018 | Warp support | Caught and corrected an incomplete initial research pass (Warp's Skills system is distinct from its Rules mechanism) before shipping, not after a user reported it broken. | [research.md](../specs/018-warp-support/research.md) |
| 019 | Trae support | Investigated a contradictory GitHub bug report and traced it to a path mismatch in the report itself — corroborated via a first-party CLI's own source rather than trusting one secondary source. | [research.md](../specs/019-trae-support/research.md) |
| 020 | Release packaging | A `dry_run`-gated-by-default release workflow — the entire mechanism (version validation, changelog gate, artifact packaging) is rehearsable with zero risk before any real cut. | [research.md](../specs/020-release-packaging/research.md) |
| 021 | Harness auto-detection | Ranked-signal detection with zero behavior change for every pre-existing explicit `--harness` invocation, proven by every prior CI job passing unmodified, not just asserted. | [research.md](../specs/021-harness-auto-detection/research.md) |
| 023 | Full harness coverage | A bridge-file mechanism generating a harness-appropriate adapter from one canonical skill package into fourteen *different* target conventions from a shared source of truth — no researched competitor's install tooling does this. | [research.md](../specs/023-full-harness-coverage/research.md) |
| 024 | Bootstrap installer | States its own live-download path as unverified against production rather than claiming full end-to-end verification it didn't have — honesty as part of the shipped artifact, not an afterthought. | [research.md](../specs/024-bootstrap-installer/research.md) |
| 025 | Diagram theme safety | Caught a real cross-platform bug (BSD `sed`'s silent `\s` failure) during its own manual testing, before it ever reached CI. | [research.md](../specs/025-diagram-readability/research.md) |
| 026 | Mandatory render verification | Grounded in first-hand, this-session evidence (a real render call returning "exceeds maximum allowed tokens") rather than a hypothetical failure mode. | [research.md](../specs/026-mandatory-render-verify/research.md) |
| 028 | `specjedi-quick` | The first researched lightweight SDD path required to still satisfy a live, versioned, enforced constitution on its fast path — neither BMAD's Quick Flow nor OpenSpec's three-command model runs inside a project that also gates every artifact this way. | [research.md](../specs/028-specjedi-quick/research.md) |

## Maintenance

Add a new row here in the same PR that ships any future feature's
`research.md` — this file is a summary index, not a replacement for the
full research document; keep entries to one line and link back for
detail. **This rule went unhonored for 14 features (014-027) after
feature 013 shipped** — caught by a `/speckit-analyze` markdown audit
(2026-07-13) and backfilled in the same pass. Features 014
(`competitive-comparison`), 022 (`session-start-verification`), 027
(`honest-pros-cons-doc`), 029, and 030 are deliberately absent: they are
documentation/verification features whose own `research.md` doesn't make
a Principle-II-shaped "capability no competitor has" claim (014 *is* the
comparison; 022 closes a prior feature's gap rather than adding one; 027/
029/030 are self-assessment/explainer documentation) — not further
instances of the same gap.

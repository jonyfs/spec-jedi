# Baseline facts (T001/T002) — scratch reference, not a shipped doc

**Captured**: 2026-07-18, before any `README.md` edit in this feature.

## T001 — Pre-change structural baseline

- Badges (top block): 10 (CI, License, Constitution, Pipeline, Skills, Roadmap, Installer, Languages, PRs, Last commit)
- Harness table rows (`| ... | ✅ Supported ...`): 20
- Total lines in `README.md`: 392
- "How Spec Jedi builds itself, in comic form" section: lines 112-218 (from `## How Spec Jedi builds *itself*, in comic form` through the closing sequence-diagram code fence) — 8 illustrated panels + 1 Mermaid sequence diagram, explicitly labeled as a Principle XV internal-bootstrap aside. MUST remain byte-for-byte unchanged (FR-006).
- Opening epigraph line (must remain byte-for-byte unchanged, FR-006):
  > *"Spec first. Code second. That is the way."* — a wise Master, probably.

## T002 — Live project-state re-verification (2026-07-18)

| Fact | Current README claim | Verified value | Action |
|---|---|---|---|
| Total `specjedi-*` skills | Badge: "25 shipped" | **27** (`ls .claude/skills/ \| grep -c '^specjedi-'`) | **Fix badge 25→27** (stale) |
| Total `speckit-*` commands | (not badged) | 11 (`ls .claude/skills/ \| grep -c '^speckit-'`) | Cite as-is |
| Parity ratio (specs/044 PARITY-LEDGER.md) | (not yet stated) | 8/11 full parity, 1/11 favorable divergence, 2/11 no equivalent (sums to 11) | Cite with link (US2) |
| `specjedi-*`-only skills (no `speckit-*` counterpart) | (not yet stated) | **18**, not 16 — see discrepancy note below | Cite **18** in README, not the ledger's stale "16" |
| Core pipeline stages | Badge: "9/9 shipped" | 9 (constitution, specify, clarify, plan, tasks, implement, analyze, checklist, converge) | Accurate, no change |
| Roadmap backlog | Badge: "12/12 shipped" | 0 pending per `references/skill-roadmap.md`'s "Proposed, not yet built" section ("Empty as of feature 032") | Accurate, no change |
| Documented languages | Badge: "11 languages" | 10 translations (`docs/i18n/{ar,bn,es,fr,hi,id,pt,ru,ur,zh}`) + 1 English source = 11 | Accurate, no change |
| Constitution version | (dynamic badge, auto-fetched) | 1.27.0 | Accurate (dynamic), no change |
| Supported harnesses | Table: 20 rows, "20 of 20" prose | 20 (recounted directly) | Accurate, no change |

### Discrepancy found: `specs/044-speckit-parity-audit/PARITY-LEDGER.md`'s own "16" count is stale/incorrect

The ledger's prose states "16 have no `speckit-*` counterpart," but its own
enumerated list directly beneath that sentence names 18 skills
(`specjedi-diagram`, `specjedi-docs`, `specjedi-explain`,
`specjedi-find-skills`, `specjedi-govcheck`,
`specjedi-constitution-audit`, `specjedi-master`, `specjedi-migrate`,
`specjedi-new-skill`, `specjedi-onboard`, `specjedi-quick`,
`specjedi-release`, `specjedi-retro`, `specjedi-security`,
`specjedi-skill-review`, `specjedi-status`, `specjedi-tokencheck`,
`specjedi-worktree`). Independent arithmetic confirms 18: 27 total
`specjedi-*` skills minus the 9 that map to a `speckit-*` command
(specify, clarify, plan, tasks, implement, analyze, checklist,
constitution, converge) = 18.

Per this feature's own FR-007 (re-verify every number against current
project state before restating it), **README.md will cite 18, not the
ledger's stale 16** — citing a number already known to be wrong would
propagate the error into a second document instead of catching it.
The ledger's own one-word "16"→"18" typo fix is out of scope for this
feature (plan.md's Constraints: no file other than `README.md` is
modified here) — flagged to the user as a separate, small follow-up
fix, not silently corrected mid-feature.

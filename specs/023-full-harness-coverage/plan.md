# Implementation Plan: Full Harness Coverage

## Constitution Check

- Principle II (competitive research): satisfied — see `research.md`.
- Principle VI (test-first / AI-first): this is installer-script and CI
  work, not application code with a meaningful red/green TDD cycle;
  verification instead took the form of exhaustive real execution against
  every one of the 18 explicit `--harness` values via both real `bash`
  and real `pwsh` locally before any CI job was written, plus the new CI
  jobs themselves. Exemption stated explicitly per Principle VI/CHK007
  precedent (features 001-014 already established this pattern for
  non-code-TDD work).
- Principle IX (validation battery): every harness gets a CI-proven
  assertion (see Tasks below); battery grows via `ci-gate`'s `needs:`
  list, no branch-protection reconfiguration required.
- Principle XIII (cross-platform): every `.sh` change has an identical
  `.ps1` counterpart, verified against real `pwsh` locally, not just
  bash-on-Windows.
- Principle XVI/XX (efficient docs, token economy, grounded output):
  bridge-file descriptions truncate to one sentence; every harness
  mechanism claim traces to a cited source in `research.md`.

## Technical approach

`scripts/install.sh`/`.ps1` gain:

1. Two new case/switch branches per harness: `skills_dst_rel` (always
   set) and, for the 14 bridge harnesses, `bridge_mode` (`dir` / `single`
   / `devin` / `cody`) + `bridge_dst_rel`.
2. A metadata-extraction step (`skill_meta`/`Get-SkillMeta`) reading
   `name:`/`description:` back out of each just-installed
   `.claude/skills/specjedi-*/SKILL.md` — bridge content always reflects
   what's actually on disk, not a separately-maintained list.
3. A `first_sentence`/description-truncation step, cutting at the first
   ". " (period-then-space, not just any period, since descriptions
   contain `spec.md`/`SKILL.md`-style abbreviations) with a 160-char hard
   cap fallback.
4. Three bridge-generation code paths (`dir`, `single`/`devin`, `cody`)
   reused across all 14 bridge harnesses — no per-harness bespoke
   generation logic, only per-harness *target path* configuration.

A portability bug was caught during manual testing: BSD `sed` (macOS,
this project's own primary dev/CI target) does not support GNU `\s` in
extended regex — it silently fails to strip whitespace rather than
erroring, producing a leading-space bug in extracted skill names/
descriptions. Fixed by using `[[:space:]]` (POSIX class, portable across
BSD and GNU `sed`) instead — a real, caught-before-shipping bug, not a
hypothetical.

## Files touched

- `scripts/install.sh`, `scripts/install.ps1` — core mechanism.
- `.github/workflows/validate.yml` — `install-test-antigravity(-windows-native)`
  (dedicated, mirroring the existing codex-cli/trae job pattern) +
  `install-test-bridge-harnesses(-windows-native)` (one matrix job
  covering all 14 bridge harnesses — each matrix entry is independently
  visible pass/fail in the Actions UI, the same "dedicated per harness"
  spirit as the hand-written jobs, without 28 near-duplicate blocks).
- `README.md` — harness table (all 20 ✅), Mermaid diagram, install-flow
  prose.
- `references/harness-capability-notes.md` — status update, Antigravity/
  Cody corrections.
- `references/principle-traceability.md` — Principle III row → ✅
  Mechanized.
- `references/skill-roadmap.md` — n/a for this feature's own row (this is
  installer infra, not a `specjedi-*` skill) but adjacent to feature 024's
  entry there.
- `.specify/memory/constitution.md` — PATCH amendment recording the
  closure (no principle text changes; documentation/traceability update
  only, matching the v1.16.3/v1.16.4/v1.18.1 precedent for this class of
  change).

## Testing strategy

Manual, exhaustive, pre-CI verification (all performed against this
actual checkout, not simulated):
- All 18 explicit `--harness` values run via real `bash` locally — 18/18
  pass, correct target path confirmed for each.
- All 18 explicit `--harness` values run via real `pwsh` 7.6.3 locally —
  18/18 pass, byte-for-byte equivalent bridge content to the bash run
  (spot-checked: Cody JSON, Cursor bridge dir, Gemini index table, Devin
  Playbook).
- Cody JSON output validated with `python3 -m json.tool`.
- CI additions: `install-test-antigravity` (+ windows-native),
  `install-test-bridge-harnesses` (+ windows-native), all wired into
  `ci-gate`'s `needs:` list. CI assertion logic itself dry-run-verified
  locally against real install output before being committed (same
  discipline as prior harness features).

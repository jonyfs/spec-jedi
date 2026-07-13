# Feature Specification: Full Harness Coverage

**Status**: Complete (2026-07-13)

## Problem

Constitution Principle III commits Spec Jedi to a real, CI-proven install
path for at least twenty LLM coding harnesses. As of 2026-07-12, only 5
were real (Claude Code, Codex CLI, Trae, plus OpenCode/Warp reusing those
same targets); 15 remained "📋 Planned — not yet installable." This was
the last open item in `references/principle-traceability.md`.

## User Story (P1) — Install into any of the 20 matrix harnesses

As a developer using any of the 20 harnesses named in Principle III's
compatibility matrix, I want `scripts/install.sh`/`.ps1 --harness <mine>`
to actually place Spec Jedi's skills somewhere my tool will find them, so
I don't have to hand-copy `SKILL.md` files or give up because my tool
isn't Claude Code/Codex CLI/Trae.

**Acceptance criteria**:
- AC1: `--harness <value>` succeeds (exit 0) for all 20 documented values.
- AC2: For the 4 native skills-directory harnesses, the full
  `specjedi-*` package set lands under that harness's documented skills
  path.
- AC3: For the 14 bridge harnesses, the full package set lands under the
  canonical `.claude/skills/`, AND a bridge file (or one per skill, for
  directory-convention harnesses) is generated at that harness's own
  documented rules location, referencing every installed skill.
- AC4: Cody's bridge output is valid JSON matching its documented
  Custom Commands schema.
- AC5: No `speckit-*` bootstrap tooling ever leaks into any install,
  regardless of harness (pre-existing invariant, re-verified for all 20).
- AC6: Every harness has a dedicated or matrix-scoped CI job proving
  AC1-AC5 on Linux, macOS, and Windows (both bash-on-Windows and native
  PowerShell).

## Out of scope

- Actually testing inside each of the 20 real IDE/CLI products (that
  would require 20 paid/installed tools; this feature proves the
  *installer's* output is correct and matches each tool's own documented
  convention, per the same bar `references/harness-capability-notes.md`
  already drew — install-path-tested, not hands-on-product-tested).
- Changing which 20 harnesses are in the matrix.
- The standalone bootstrap installer (tracked separately as feature 024).

## Non-functional requirements

- Cross-platform: `install.sh` and `install.ps1` stay behaviorally
  identical (Principle XIII).
- Token economy (Principle XVI/XX): bridge-file descriptions are
  truncated to their first sentence (≤160 chars) rather than inlining
  full multi-sentence `SKILL.md` descriptions into every generated file.
- Hallucination resistance (Principle XX): no harness is marked ✅
  Supported without either (a) a native skills-directory citation actually
  re-verified this session, or (b) a bridge mechanism built and tested
  against that harness's own documented, cited convention.

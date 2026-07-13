# Research: Full Harness Coverage (feature 023)

**Goal**: close Constitution Principle III's last open gap — build and
CI-prove a real install path for the 15 remaining harnesses in the
compatibility matrix (`references/harness-capability-notes.md` supplied
the starting desk research from 2026-07-11; this feature re-verifies two
of its findings and builds the install mechanism for all 15).

## Principle II: competitive research before creation

No researched SDD competitor (`specs/001-specjedi-pipeline/research.md`'s
field of spec-kit + ten others) ships an installer that bridges one
canonical skill package into fourteen *different* target harnesses' own
native rules-file/rules-directory conventions. Most tools in the field
target a single harness or a small fixed set; none surveyed generates a
harness-appropriate adapter file from a shared source of truth across
this many distinct conventions. **Genuine contribution**: the bridge-file
mechanism itself (single-index vs. per-skill-directory vs. Cody's
custom-commands JSON, chosen per harness's actual documented shape) —
this is new mechanism work, not a reskin of any prior art.

## Per-harness mechanism decisions

Base data: `references/harness-capability-notes.md` (2026-07-11 desk
research, one WebSearch per harness, citations in that file). This
feature re-verified two findings that materially changed the install
design:

1. **Antigravity (Google)** — re-verified 2026-07-13 via WebSearch
   against Google's own Codelabs ("Authoring Antigravity Skills"),
   `antigravity.google/docs/skills`, and independent community
   verification posts (Medium, "Where does Antigravity look for Agent
   Skills?", 2026-07). Finding: Antigravity has a genuine **skills
   directory** — `.agents/skills/<name>/SKILL.md`, the identical
   convention Codex CLI already uses (with `.agent/skills` as documented
   legacy fallback). This is a materially different finding from the
   original capability-notes.md entry ("Markdown-based Skills, absorbing
   Gemini CLI's role" — accurate but imprecise about the exact
   mechanism). Consequence: Antigravity is installed via the **skills-dir**
   mode, sharing Codex CLI's exact target directory, needing zero new
   bridge-file code — the same "zero new installer code" precedent
   OpenCode and Warp already established (specs/017, specs/018).

2. **Sourcegraph Cody** — capability-notes.md left this "Unclear" after
   one research pass. This feature ran three further rounds: (a) a
   WebFetch of `sourcegraph.com/docs/cody/capabilities` found no named
   project-level markdown file; (b) a WebSearch for `.sourcegraph/memory`/
   custom-instructions surfaced a result about Sourcegraph's separate
   **Amp** agent product reading `AGENTS.md` — explicitly **not used**,
   since Amp and Cody are different products and conflating them would
   violate Principle XX's grounding requirement; (c) a WebSearch
   confirmed Cody is enterprise-only as of 2026 with "limited agentic
   capabilities compared to Cursor Composer, Copilot Workspace, or
   Windsurf Cascade" and no AGENTS.md mention. Conclusion: no confirmed
   always-on rules file exists for Cody. Cody's one real, documented
   customization surface — **Custom Commands** via `.vscode/cody.json`
   (`description`/`prompt`/`contextFiles` fields, confirmed via
   `docs.sourcegraph.com/cody/custom-commands`) — is what the installer
   targets instead. This is fundamentally different UX from every other
   harness in the matrix (manual `/specjedi-<name>` invocation, not
   automatic context loading), and the README/install output say so
   explicitly rather than overclaiming equivalence.

3. **Tabnine** — capability-notes.md named "Markdown Guidelines" without
   a file path. WebFetch of `docs.tabnine.com/main/getting-started/
   tabnine-agent/guidelines` confirmed the exact convention:
   `$PROJECT_FOLDER/.tabnine/guidelines/*.md`, one or more files, no
   required naming beyond `.md`.

4. **Gemini CLI** — capability-notes.md's existing sunset caveat stands
   (Google retired consumer/Pro/Ultra tiers 2026-06-18 in favor of
   Antigravity). Still installed (`GEMINI.md`, root) since it's a named,
   still-technically-functioning harness in the matrix and Principle III
   requires covering it; the README and install output both flag the
   sunset status rather than presenting it as a first-choice
   recommendation.

All other 11 harnesses (Cursor, Windsurf, GitHub Copilot, Cline, Continue,
Aider, Amazon Q Developer, JetBrains AI Assistant, Zed, Replit Agent,
Devin) use the mechanisms and exact paths already cited in
`references/harness-capability-notes.md`'s findings table — no
contradicting evidence surfaced during this feature.

## Install-mode taxonomy

- **skills-dir** (4 harnesses: Claude Code, Codex CLI, Trae, Antigravity):
  the harness natively scans a directory of `SKILL.md` packages. Full
  packages copied as-is — pre-existing mechanism, unchanged by this
  feature except for Antigravity's addition.
- **bridge / single** (6: Gemini CLI, Zed, Replit, Aider, Copilot, Devin):
  one project-root file, so one combined index (skill name + first-
  sentence description + pointer to the canonical `.claude/skills/`
  copy) is generated. Devin's `.devin.md` additionally wraps the index in
  its documented Procedure/Specifications/Advice Playbook sections.
- **bridge / dir** (7: Cursor, Windsurf, Cline, Continue, Amazon Q,
  JetBrains AI, Tabnine): the harness scans a directory of several rule
  files, so one small bridge file per skill is generated instead of one
  combined file — a better fit for how these tools actually consume
  rules (selectively, per file).
- **bridge / cody** (1): `.vscode/cody.json`, Cody's own custom-commands
  schema, manual-invocation only.

## Why full packages always land at `.claude/skills/` for bridge harnesses

Reuses this project's own existing, already-established canonical
convention (used since feature 001) rather than inventing a second
"generic skills directory" concept. Every bridge file's pointer path
(`.claude/skills/<name>/SKILL.md`) is therefore stable and predictable
regardless of which of the 14 bridge harnesses was chosen.

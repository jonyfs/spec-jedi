# Skill Gaps Log

Durable, cross-session record of domains this project's own skill set
doesn't cover well, per Constitution Principle XVII's "gap memory, not a
one-shot lookup" design. Appended by `specjedi-find-skills` whenever it
declines to recommend a skill (nothing verifiable found) or identifies a
recurring gap without yet searching it. A domain that keeps recurring
across sessions is a signal Spec Jedi itself should eventually cover it
(Principle II).

- 2026-07-11 — **Localization/i18n workflow** (docs translation, sync
  tracking, drift detection — directly blocks `TODO(LOCALIZATION)`).
  Searched: skills.sh, GitHub (`gh search`/`gh api`). Found one candidate,
  `better-i18n/skills` (github.com/better-i18n/skills) — declined to
  recommend: 7 GitHub stars, no visible install count, no OSI license
  field on the repo, and tied to a commercial i18n SaaS product
  (docs.better-i18n.com). Doesn't clear this skill's own verification bar
  ("under 100 stars needs real justification"). No stronger candidate
  found this pass.
- 2026-07-11 — **CI/CD authoring depth** (maintaining/extending
  `.github/workflows/validate.yml` as Principle IX's validation battery
  grows to include unit/integration/Playwright jobs). Searched: web
  search + `gh api` verification. One candidate found
  (`steeef/claude-skill-github-actions`) — declined: 1 GitHub star, no
  other signal. No stronger GitHub-Actions-specific candidate found this
  pass (`harness/harness-skills` exists but targets the Harness CI/CD
  platform, not GitHub Actions, so not directly relevant here).
- 2026-07-11 — **Accessibility (a11y) guidance depth** for target
  projects' UI work — Principle VII promises "full-stack technical depth
  on demand" including accessibility. Searched: web search + `gh api`
  verification. **Verified candidate found**:
  `Community-Access/accessibility-agents` (github.com/Community-Access/
  accessibility-agents) — 356 GitHub stars, MIT license, updated
  2026-06-29, eleven specialist agents enforcing WCAG 2.2 AA compliance
  for Claude Code/GitHub Copilot/Claude Desktop. Clears this skill's own
  verification bar. **Installed** (`npx skills add
  Community-Access/accessibility-agents -g -y`, explicit user
  confirmation given) — 18 accessibility skills now globally available.
- 2026-07-11 — **Security review depth beyond `specjedi-security`**
  (which is deliberately lightweight, a "did we think about X" prompt,
  not a full audit). Searched: web search + `gh api` verification.
  **Verified candidate found**: `trailofbits/skills`
  (github.com/trailofbits/skills) — 6,069 GitHub stars, CC-BY-SA-4.0
  license, updated 2026-07-07 (four days before this entry), from Trail
  of Bits, a widely-recognized security research firm. Clears this
  skill's own verification bar comfortably on both install-count and
  source-reputation signals. **Installed** (`npx skills add
  trailofbits/skills -g -y`, explicit user confirmation given) — the bulk
  of Trail of Bits' skill set is now globally available (a handful of
  entries failed with a "PromptScript does not support global skill
  installation" error unrelated to Claude Code compatibility).

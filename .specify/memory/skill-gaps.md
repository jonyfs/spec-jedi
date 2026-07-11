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
  grows to include unit/integration/Playwright jobs). Named as a
  candidate domain, not yet searched.
- 2026-07-11 — **Accessibility (a11y) guidance depth** for target
  projects' UI work — Principle VII promises "full-stack technical depth
  on demand" including accessibility, but no installed skill goes deep on
  it specifically. Named as a candidate domain, not yet searched.
- 2026-07-11 — **Security review depth beyond `specjedi-security`**
  (which is deliberately lightweight, a "did we think about X" prompt,
  not a full audit) — for target projects with real security surface that
  would benefit from a more thorough scanning skill. Named as a candidate
  domain, not yet searched.

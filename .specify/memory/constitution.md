<!--
Sync Impact Report
- Version change: 1.22.0 → 1.23.0
- Modified principles: XXI. Session-Start Orientation & the Master Yoda
  Greeting — MINOR bump, materially expanded guidance (no renaming, no
  removal).
  - Closes this principle's own last remaining gap: feature 015's T020
    ("an actual live Claude Code session start rendering the greeting
    end to end — not observable from within the same session that built
    it") is now satisfied with real, cited evidence — a genuine
    `SessionStart:compact` firing later in this project's lifetime
    produced the correct three-part payload (banner, accurate on-disk-
    derived status, correctly-gated Yoda line), quoted verbatim in
    `specs/015-session-start-hook/tasks.md`'s T020 and
    `specs/022-session-start-verification/research.md`. This was a
    `compact` firing, not a from-scratch `startup` firing — the same
    registered hook/script either way, stated precisely rather than
    overclaimed.
  - Adds a new precedence clause resolving a real, previously-
    undocumented conflict the same observation surfaced: this
    principle's own render-verbatim instruction versus an explicit
    session-continuation/no-preface instruction, both applying to the
    same turn. Resolution: continuation instructions win, but the
    orientation goal isn't dropped — the agent still surfaces real
    status naturally. `CLAUDE.md` carries the paired operative
    instruction (this same session).
  - `references/principle-traceability.md`'s Principle XXI row updated
    from 🟡 Partial to ✅ Mechanized to reflect the closure.
- Added sections: none (extends an existing principle, not a new one)
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: none — this closes the principle's last named gap
  rather than opening a new one.
-->

<!--
Sync Impact Report
- Version change: 1.21.0 → 1.22.0
- Modified principles: IV. Structured, Opinionated Elicitation (Ask, Don't
  Assume) — MINOR bump, materially expanded guidance (no renaming, no
  removal).
  - Adds a project-wide clause (distinct from v1.21.0's `specjedi-onboard`-
    specific paragraph, which stays as-is): whenever ANY `specjedi-*` skill
    presents a genuine multiple-choice-style decision point, it MUST mark
    one option as Recommended with a one-line reason, and wherever that
    skill defines an `--auto` mode, `--auto` MUST auto-select the
    Recommended option (while still recording the choice in whatever audit
    trail already exists) — generalizing the pattern
    `/superpowers:brainstorming` and this project's own `specjedi-clarify`
    already demonstrated, to every skill going forward.
  - Explicitly scoped to NOT force a fake multiple-choice structure onto
    binary confirm/gate pauses, required-parameter asks, or
    single-best-answer recommendations (`specjedi-find-skills` named as an
    example already compliant in spirit without needing an artificial
    menu) — avoiding the over-generalization trap of treating every skill
    pause as the same shape of decision.
  - Grounded in a real audit (not assumption) run before drafting this
    amendment: all 23 `specjedi-*` skills already have an `--auto` mode
    section, but a grep for lettered-option/multiple-choice patterns found
    only 2 skills (`specjedi-clarify`, `specjedi-onboard`) with genuine
    multi-option elicitation today — both already compliant. This means
    the amendment codifies an existing, working pattern as a permanent
    standard rather than requiring a retrofit across skills whose pauses
    are a different shape of interaction (gates, single-recommendation
    findings, required parameters) — a category error the amendment's own
    scoping clause exists specifically to prevent.
- Added sections: none (extends an existing principle, not a new one)
- Removed sections: none
- Templates requiring updates: none — elicitation-interaction-shape
  guidance, not a new mandatory artifact section.
- Paired mechanism updates (this same session, propagating this
  amendment): `references/skill-authoring-standard.md`'s Quality Bar and
  Review checklist gain an explicit Recommended-option/`--auto` item, so
  `specjedi-new-skill`'s scaffold and `specjedi-skill-review`'s audits both
  structurally reinforce this for every future skill.
- Follow-up TODOs: none — no skill content retrofit needed per the audit
  above; the paired reference-doc update ships in the same session.
-->

<!--
Sync Impact Report
- Version change: 1.20.1 → 1.21.0
- Modified principles: IV. Structured, Opinionated Elicitation (Ask, Don't
  Assume) — MINOR bump, materially expanded guidance (no renaming, no
  removal).
  - Adds a fourth paragraph scoping a brainstorming-inspired guided-ideation
    duty specifically to `specjedi-onboard`, the project's first-run entry
    point: when a user arrives with no concrete idea yet, or explicitly asks
    for help figuring out what to build, the skill MUST engage in
    one-question-at-a-time, multiple-choice-preferred ideation — optionally
    surfacing 2-3 candidate directions with trade-offs and a recommendation
    for genuinely open-ended requests — before locking in the one-sentence
    idea handed downstream to `specjedi-constitution`/`specjedi-specify`.
  - Explicitly scoped to NOT duplicate `specjedi-specify`'s own requirement
    gathering or `specjedi-clarify`'s ambiguity-resolution loop, and to NOT
    produce a standalone design document — onboarding hands off a
    crystallized idea, not a spec. This keeps the extension proportionate to
    a first-run walkthrough rather than importing the full weight of a
    heavier, general-purpose brainstorming workflow.
  - Origin: this session's `/superpowers:brainstorming` skill demonstrated
    exactly the interaction shape (one question at a time, propose 2-3
    approaches with trade-offs, incremental section-by-section approval)
    that a total-beginner-calibrated onboarding flow was missing — today's
    `specjedi-onboard` only ever asked once for "a real one-sentence idea"
    with no help shaping one. This amendment names that gap and closes it
    at the principle level; the paired `specjedi-onboard/SKILL.md` edit
    (this same session) is the mechanism.
- Added sections: none (extends an existing principle, not a new one)
- Removed sections: none
- Templates requiring updates: none — this is elicitation-interaction-shape
  guidance for one specific skill, not a new mandatory artifact section; no
  `plan-template.md`/`spec-template.md`/`tasks-template.md` structural
  change follows from it.
- Follow-up TODOs: none — the paired `specjedi-onboard/SKILL.md` change
  ships in the same session as this amendment, not deferred.
-->

<!--
Sync Impact Report
- Version change: 1.20.0 → 1.20.1
- Modified principles: none
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: `TODO(SESSION_START_HOOK)` is now **CLOSED** — a
  `/speckit-constitution` audit found it still listed as open below even
  though feature 015 (`scripts/session-start.sh`/`.ps1`, the
  `.claude/settings.json` `SessionStart` registration, and the
  `CLAUDE.md` render instruction) actually shipped and merged
  (2026-07-12). The mechanism this TODO tracked is built; the one
  genuinely separate item that remains — an actual live session
  confirming the greeting renders end to end (SC-003) — is tracked in
  `references/principle-traceability.md`'s Principle XXI row (🟡
  Partial), not as a constitution-level TODO, since it's a one-time
  confirmation step rather than unbuilt work.
-->

<!--
Sync Impact Report
- Version change: 1.19.0 → 1.20.0
- Modified principles: none renamed
- Added: Principle XXI (Session-Start Orientation & the Master Yoda
  Greeting) — MINOR bump, new principle.
  - Establishes policy for a three-part session-start orientation: ASCII
    Spec Jedi banner, a project status summary derived from
    `specjedi-status`'s existing on-disk-artifact logic (no parallel
    tracking system), and a rotating Master Yoda-styled greeting line.
  - States the real Claude Code `SessionStart` hook mechanism precisely
    (verified via the official hooks documentation before writing this):
    hook stdout becomes `additionalContext` for the agent, capped at
    10,000 characters — it is NOT printed directly to the user's
    terminal. The principle therefore requires both a hook (to emit the
    context) AND a `CLAUDE.md` render instruction (to make the agent
    actually display it) — a hook alone would not satisfy this
    principle, and this Sync Impact Report says so explicitly rather
    than letting a future reader assume the hook does more than it does.
  - Scopes the Master Yoda persona narrowly (session-start greeting
    only) as distinct from Principle XII's broad saga-wide rotation, to
    avoid diluting either.
  - Explicitly defers the actual build (hook script, CLAUDE.md wiring,
    ASCII art asset) to its own Principle II-gated feature cycle — this
    amendment sets policy, it does not itself satisfy the competitive-
    research requirement a new structural pattern needs before shipping.
- Added sections: none (new principle, not a new top-level section)
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: `TODO(SESSION_START_HOOK)` — the actual
  `SessionStart` hook script, `CLAUDE.md` render-instruction wiring, and
  `references/star-wars-lexicon.md`'s Master Yoda persona section (with
  concrete example lines) are tracked as feature 015, to be built via
  the literal `specjedi-specify` → `specjedi-plan` → `specjedi-tasks` →
  `specjedi-implement` pipeline with real Principle II research, not
  built ad hoc under this amendment alone.
-->

<!--
Sync Impact Report
- Version change: 1.18.3 → 1.19.0
- Modified principles: XVI (renamed "Mermaid-First Process Documentation"
  → "Efficient Documentation & Mermaid Diagram Literacy") — MINOR bump,
  materially expanded guidance, not just clarification:
  - New: every `specjedi-*` skill MUST actively evaluate the most
    efficient documentation format (prose/table/list/diagram) for given
    content, rather than defaulting to a diagram out of habit or padding
    either format past what the content needs.
  - New: any diagram-generating/recommending skill MUST know Mermaid's
    full current diagram-type catalog (30 types as of this amendment),
    not just flowchart/sequence/ER, grounded in a new canonical reference
    `references/mermaid-diagram-catalog.md` (mirrors Principle XII's
    `star-wars-lexicon.md` pattern) — built from two independently
    cross-checked fetches of mermaid.js.org's own syntax reference, per
    Principle XX's grounding discipline.
  - Retained unchanged: the existing "prefer Mermaid over ASCII art,
    prose stays required alongside it, never diagram-only" requirements.
  - Propagated in the same PR: `specjedi-diagram`'s `SKILL.md` (feature
    004) broadened its active type-inference step from 3 types
    (flowchart/sequence/ER) to the 12 types in the new catalog's "Core"
    tier most likely to apply to spec/plan content, and now names a
    Specialized-tier type explicitly (sourced from the catalog) instead
    of only ever falling back to `specjedi-find-skills` for anything
    beyond its original three.
- Added sections: none (new reference file, not a constitution section)
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: none.
-->

<!--
Sync Impact Report
- Version change: 1.18.2 → 1.18.3
- Modified principles: none — PATCH bump for a `/speckit-constitution`
  compliance audit ("verifique se tudo esperado foi implementado e está
  conforme esperado") that found and fixed one real, concrete gap: no
  principle text changed.
  - `references/principle-traceability.md` had gone stale: five of its
    rows (Principles I, VI, XVII, XX, and the Distribution & Ecosystem
    Standards cross-cutting row) still read 🟡 Partial and cited
    CHK002/007/011/015/018, all five of which the v1.18.2 PR (#58) had
    already resolved — but that PR never updated this file, despite its
    own stated Maintenance instruction to do so in the same PR. Corrected
    all five rows to their actual current status; only Principle III
    remains genuinely 🟡 Partial (19 of 20 harnesses still lack a built,
    tested install path — real future work, not a documentation gap).
    Strengthened the file's own Maintenance note to name this exact
    failure mode explicitly, so a future checklist-closing PR is less
    likely to repeat it.
  - Also shipped in the same audit: feature 014
    (`references/competitive-comparison.md`, an 11-row table comparing
    Spec Jedi against spec-kit and the ten other Principle II-researched
    tools, grounded entirely in `specs/001-specjedi-pipeline/research.md`
    — no new competitor research performed), built via the literal
    `speckit-specify` → `speckit-plan` → `speckit-tasks` →
    `speckit-implement` pipeline per this project's established
    discipline (PR #59).
  - No other gap was found: `checklists/project-completeness.md` remains
    19/19 resolved; no `TODO(...)` markers or placeholder tokens remain
    unexplained in this document.
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: none.
-->

<!--
Sync Impact Report
- Version change: 1.18.1 → 1.18.2
- Modified principles: none — PATCH bump for mechanism/documentation
  additions closing the final five open items in
  `checklists/project-completeness.md`, none of which required changing
  any principle's normative text.
  - CHK002: `references/harness-capability-notes.md` — a real per-harness
    matrix (mechanism, cited source, Yes/Unclear capability call) for all
    19 non-Claude-Code harnesses in Principle III's compatibility table,
    explicitly labeled desk research rather than the higher, hands-on-
    tested bar the README's ✅/📋 status column reserves. Also surfaced and
    documented a real, current finding: Gemini CLI is being sunset in
    favor of Antigravity CLI (Google, effective 2026-06-18) — noted as a
    prioritization signal for future install-path work, not acted on by
    changing the harness table itself.
  - CHK011: no retroactive fix exists for PR #45/#47's missing badge-row
    review — resolved by construction instead: `specjedi-govcheck`'s
    mandatory self-invoke from `specjedi-implement` (shipped in feature
    013) already makes this check structural on every PR going forward,
    so the historical gap can't recur.
  - CHK013: `references/genuine-contributions-log.md` — durable one-line-
    per-feature index of every shipped feature's Principle II "genuine
    contribution" claim, spot-checkable against the researched-competitor
    field over time, with a maintenance rule for future features.
  - CHK015: answered by reasoning rather than new infrastructure — git
    history (commit messages, PR descriptions) already is the append-only,
    inspectable retrospective audit trail Principle XX's hallucination-
    resistance requirement needs; `specjedi-govcheck`'s per-PR Principle XX
    row is the forward-looking half. A separate tracking ledger would be a
    weaker, easier-to-forget duplicate of what git already guarantees.
  - CHK016: `.github/workflows/validate.yml` gained `tokencheck-detection`
    (ubuntu/macos/windows matrix, bash `which`) and
    `tokencheck-detection-windows-native` (native PowerShell `where.exe`)
    jobs, both required by `ci-gate` — proving `specjedi-tokencheck`'s
    present/absent detection logic for real on every OS Principle XIII
    requires, not just the one it was originally dry-run tested on.
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: none. All 19 items in
  `checklists/project-completeness.md` are now resolved.
-->

<!--
Sync Impact Report
- Version change: 1.18.0 → 1.18.1
- Modified principles: Principle III (Universal LLM & Harness
  Compatibility) and the Development Workflow section — PATCH bump:
  both are clarifications resolving genuine ambiguity, not new
  obligations or removed guarantees.
  - Principle III: "re-verified whenever a new major release of this
    project ships" now explicitly names Principle XI's MAJOR product
    release line, disambiguating it from the constitution's own MAJOR
    version (`checklists/project-completeness.md` CHK014).
  - Development Workflow: the per-feature pipeline step list no longer
    lists "localization pass" as a per-feature stage — localization
    (Principle I) runs on its own whole-project cadence, signaled by the
    `scripts/validate.sh`/`.ps1` sync-drift check, not re-triggered by
    every individual feature's PR. This matches what actually happened
    (localization shipped once, covering all prior features at once,
    not per-feature) rather than leaving the step list implying
    something no shipped feature ever did (CHK017).
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: none new. This amendment also closes several
  `checklists/project-completeness.md` findings via non-constitution
  fixes shipped in the same PR: CHK007 (all 12 prior feature plans now
  cite their Principle VI test-first exemption explicitly, matching the
  precedent feature 013 already set), CHK012 (already resolved by the
  CHK004 battery-growth-trigger mechanism; checkbox corrected),
  CHK018 (a real systematic audit confirmed 20 of 22 shipped skills
  carry the Principle XVII self-invoke contract, the 2 that don't
  already have documented exemptions), and CHK019 (resolved by
  construction — the two localization amendments already are the
  "constitution amendment first" resolution path this item asked
  whether would be needed). Remaining open: CHK002 (a real 20-harness
  capability matrix — needs live multi-harness testing), CHK011
  (retroactive PR reviews — can't be fixed after the fact), CHK013
  (verifying `research.md`'s "genuine contribution" claims beyond
  trusting the document's own prose), CHK015 (no retrospective audit
  mechanism for Principle XX hallucination-resistance), and CHK016
  (`specjedi-tokencheck`'s cross-platform detection is designed
  correctly per-OS but not live-verified on Linux/Windows).
-->

<!--
Sync Impact Report
- Version change: 1.17.0 → 1.18.0
- Modified principles: Principle I (English-Source, Globally-Localized
  Documentation) — MINOR bump: a substantive expansion of a MUST-level
  requirement's scope, not a clarification. The maintainer directed
  extending localization from the six languages named at v1.17.0 (zh, hi,
  es, fr, ar, bn) to the full ten most-spoken languages after English:
  Portuguese (`pt`, Brazilian variant, explicitly named by the
  maintainer), Russian (`ru`), Urdu (`ur`), and Indonesian (`id`) added.
  `docs/i18n/{pt,ru,ur,id}/{README.md,CONTRIBUTING.md}` shipped this
  cycle — AI-assisted translations, English canonical, each carrying the
  same `i18n-sync` marker convention established at v1.17.0. All ten
  translations' language-switcher banners updated to cross-link the full
  set; the six original translations were also found missing the
  `Languages` badge entirely (added when the badge was introduced to the
  English README after they were first written) — fixed as part of this
  amendment.
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: none new. `checklists/project-completeness.md` CHK002
  (a full 20-harness capability matrix) remains the one substantial open
  item from that checklist.
-->

<!--
Sync Impact Report
- Version change: 1.16.7 → 1.17.0
- Modified principles: Principle I (English-Source, Globally-Localized
  Documentation) — MINOR bump: this is a substantive change to a MUST-level
  requirement, not a clarification. The open-ended "ten most-spoken
  languages (per the most recent authoritative linguistic survey)" text —
  which named no actual languages and left TODO(LOCALIZATION) blocked since
  v1.15.14 — is replaced with a maintainer-decided, concrete scope: six
  named languages (Mandarin Chinese, Hindi, Spanish, French, Arabic,
  Bengali), actually translated and shipped this cycle under
  `docs/i18n/<lang>/`. A new sub-requirement is added: `scripts/validate.sh`/
  `.ps1` MUST flag localized docs whose recorded source commit has drifted
  from the English file's actual latest commit — this closes the
  previously-undesigned "kept in sync... MUST be flagged" mechanism
  (`checklists/project-completeness.md` CHK003), now a real, automated,
  non-blocking check (verified working on both `bash` and `pwsh` this
  cycle, including catching and fixing a real bug in the sync-marker
  commit hashes before shipping).
- Added sections: none (Principle I's existing text is substantively
  rewritten, not extended with a new section)
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: `TODO(LOCALIZATION)` (opened v1.15.14) is now CLOSED —
  the maintainer decided the scope (six languages, not ten) and the
  content shipped this cycle. `checklists/project-completeness.md` CHK003
  and CHK006 are both resolved by this amendment; CHK002 (a full 20-harness
  capability matrix) remains the one substantial open item from that
  checklist, out of scope for this amendment.
-->

<!--
Sync Impact Report
- Version change: 1.16.6 → 1.16.7
- Modified principles: none (no MUST-level rule changed) — PATCH bump, a
  compliance mechanism added to existing tooling, not new guidance
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: TODO(LOCALIZATION) remains open (opened v1.15.14). This
  amendment closes another finding from `checklists/project-completeness.md`:
  - CHK004: `scripts/validate.sh`/`.ps1` gained an automated, non-blocking
    Principle IX validation-battery-growth-trigger check — scans for
    test-pattern files, language runtime manifests, and web UI markers
    not yet covered by a matching unit/integration/Playwright CI job,
    warning the moment one appears rather than relying on someone
    remembering to re-read the principle. Deliberately implemented as a
    `scripts/validate.sh` enhancement rather than a new `specjedi-*`
    skill: this check is introspective tooling about this repo's own CI
    configuration, not a general SDD capability an end user of the
    toolkit would want in their own project — the same category as
    `scripts/validate.sh` itself, not the product surface (Principle
    XV). Real dry run on both `bash` and `pwsh` confirmed the clean-state
    and triggered paths, and caught a real false-positive bug (a code
    comment mentioning future job names was initially misread as an
    existing job) before shipping.
-->

<!--
Sync Impact Report
- Version change: 1.16.5 → 1.16.6
- Modified principles: none (no MUST-level rule changed) — PATCH bump,
  consistent with how routine skill shipments are versioned after the
  first process-milestone MINOR bump
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: TODO(LOCALIZATION) remains open (opened v1.15.14).
  This amendment adds a new item:
  - `specjedi-govcheck` shipped (feature 013-specjedi-govcheck,
    2026-07-11) — the fifth second-wave addition beyond the original
    roadmap backlog. Strictly read-only, per-PR/per-branch governance
    compliance checklist against all 20 Core Principles plus the
    Distribution & Ecosystem Standards and Development Workflow
    sections — a three-state per-principle report (Not Applicable /
    Compliant / Non-Compliant) rather than a binary pass/fail, with any
    confirmed constitution conflict marked CRITICAL unconditionally.
    Mechanizes the Development Workflow section's own "review MUST
    explicitly check compliance with every Core Principle" requirement,
    closing `checklists/project-completeness.md` CHK005 — the gap
    neither `specjedi-analyze` (spec/plan/tasks consistency for one
    feature) nor `specjedi-skill-review` (one skill's authoring
    standard) covers. Proactively self-invoked by `specjedi-implement`
    right before opening a PR (resolved via a real `/speckit-clarify`
    question this cycle), surfacing CRITICAL findings without blocking
    PR-opening itself — `specjedi-implement`'s existing autonomy
    statement and Principle X's CI-is-the-gate design are both
    explicitly preserved, not overridden. Reads `references/
    principle-traceability.md` for per-principle mechanism context
    rather than re-deriving it. Built via the same literal `/speckit-*`
    pipeline invocation established at v1.16.0. Separately this session:
    `specjedi-find-skills` logged its first real entries in
    `.specify/memory/skill-gaps.md` and, on explicit user confirmation,
    installed two verified third-party skill sets locally for this
    project's own development use (`trailofbits/skills`,
    `Community-Access/accessibility-agents`) — gitignored as personal
    local tooling, not part of the Spec Jedi product surface (Principle
    XV).
-->

<!--
Sync Impact Report
- Version change: 1.16.4 → 1.16.5
- Modified principles: none (no MUST-level rule changed) — PATCH bump,
  a compliance/documentation fix, not new guidance
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: TODO(LOCALIZATION) remains open (opened v1.15.14). This
  amendment closes several concrete findings from a project-wide
  requirements-completeness checklist run via `/speckit-checklist`
  (`checklists/project-completeness.md`, 19 items across 7 categories,
  auditing the constitution's own 20 principles for completeness/clarity/
  consistency/traceability rather than any single feature):
  - `references/principle-traceability.md` created — the first canonical
    document mapping every principle to its implementing mechanism or an
    explicit tracked gap (CHK001), previously scattered across
    `skill-roadmap.md` prose and Sync Impact Report history.
  - README's stale "12 `specjedi-*` product skills" Installation-section
    reference corrected to 22 (CHK008); the `Roadmap` badge corrected from
    stale `7/7 shipped` to accurate `11/11 shipped`, and a new `Skills`
    badge (`22 shipped`) added (CHK009/CHK010) — the constitution's own
    Distribution & Ecosystem Standards section names a stale hardcoded
    fact-bearing badge "a constitution violation, not a stylistic choice."
  - README's "Supported harnesses" table expanded from ~8 named tools
    collapsed into one open-ended "and others" row to all 20 harnesses
    named individually per Principle III's explicit "at least twenty"
    mandate — status only (✅/📋), no fabricated per-harness capability
    claims, consistent with Principle XX's hallucination-resistance
    discipline (CHK002 partial — a deeper capability matrix still doesn't
    exist and would require actually testing each harness).
  - Several remaining checklist items (CHK002 deep matrix, CHK003
    localization drift-detection, CHK004 validation-battery growth
    trigger, CHK005 per-PR governance checklist skill, CHK011 retroactive
    PR badge-review) remain open, tracked in the checklist file itself —
    each either genuinely blocked (localization) or reasonably scoped as
    its own future feature cycle rather than a same-session fix.
-->

<!--
Sync Impact Report
- Version change: 1.16.3 → 1.16.4
- Modified principles: none (no MUST-level rule changed) — PATCH bump,
  consistent with how routine skill shipments are versioned after the
  first process-milestone MINOR bump
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: TODO(LOCALIZATION) remains open (opened v1.15.14).
  This amendment adds a new item:
  - `specjedi-tokencheck` shipped (feature 012-specjedi-tokencheck,
    2026-07-11) — the fourth second-wave addition beyond the original
    roadmap backlog. Mechanizes Principle VIII's token-economy mandate: a
    fresh audit found `specjedi-plan`/`specjedi-converge` only ever *used*
    `graphify` when already present, never checked for or suggested
    either `rtk` or `graphify` — the same shape of gap `TODO(INSTALLER)`
    closed for Principle XVIII and `specjedi-release` closed for
    Principle XI. Checks both tools independently and with equal
    treatment (resolved via a real `/speckit-clarify` question this
    cycle: Principle VIII's text names both without qualification, and
    this project's own downstream consumption of `graphify` doesn't
    change whether a *target* project has it installed). Never installs
    or configures anything without explicit, unambiguous confirmation
    naming the specific tool — an absolute boundary, not a confirm-then-
    proceed gate, mirroring `specjedi-find-skills`' own install gate.
    Proactively self-invoked by `specjedi-onboard/SKILL.md`'s step 5,
    once the constitution and spec artifacts land (never before, per that
    skill's own established "never front-load" discipline) — a real,
    verified edit to `specjedi-onboard`'s own file, matching the
    `specjedi-plan` → `specjedi-security` proactive-wiring precedent
    (feature 007, Principle XVII discipline). Also independently
    runnable for any session that skipped onboarding. Built via the same
    literal `/speckit-*` pipeline invocation established at v1.16.0.
-->

<!--
Sync Impact Report
- Version change: 1.16.2 → 1.16.3
- Modified principles: none (no MUST-level rule changed) — PATCH bump,
  a compliance fix, not new guidance
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: TODO(LOCALIZATION) remains open (opened v1.15.14). This
  amendment closes the follow-up finding from `specjedi-skill-review`'s
  own first real dry run (v1.16.2): `specjedi-explain/SKILL.md` was
  missing its `Format` and `` `--auto` mode `` sections, and
  `specjedi-find-skills/SKILL.md` was missing its `` `--auto` mode ``
  section — both pre-existing gaps in already-shipped skills, now fixed
  and re-verified structurally clean via `scripts/validate.sh`. The same
  class of "found on audit, fixed in a dedicated follow-up" discipline as
  the original GROUNDING_PASS/NEXT_STEP_PASS/VOICE_PASS/PROMPT_ENG_PASS
  governance passes.
-->

<!--
Sync Impact Report
- Version change: 1.16.1 → 1.16.2
- Modified principles: none (no MUST-level rule changed) — PATCH bump,
  consistent with how routine skill shipments are versioned after the
  first process-milestone MINOR bump
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: all six historical governance TODOs remain resolved
  (LICENSE_CONTRIBUTING v1.15.1, NEXT_STEP_PASS v1.15.2, GROUNDING_PASS
  v1.15.3, VOICE_PASS v1.15.4, PROMPT_ENG_PASS v1.15.5, INSTALLER v1.15.6).
  TODO(LOCALIZATION) opened at v1.15.14, still open — needs a maintainer
  decision on translation approach before execution. This amendment adds
  a new item:
  - `specjedi-skill-review` shipped (feature 011-specjedi-skill-review,
    2026-07-11) — the third second-wave addition beyond the original
    roadmap backlog. Strictly read-only audit of an existing `specjedi-*`
    skill's `SKILL.md` against the Skill Authoring & Prompt Engineering
    Standard (Principle XIX), plus next-step format (Principle XIV),
    chain-of-thought framing (Principle XX), and voice (Principle XII) —
    distinguishes "section missing" from "section present but weak," and
    cross-references the matching `specs/NNN-name/plan.md` for legitimate
    chain-of-thought exemptions (resolved via a real `/speckit-clarify`
    question this cycle: a standalone `SKILL.md`-only scan risks the same
    false-positive class the 6-skill consistency audit, PR #41, already
    hit and had to correct by hand). Never edits the reviewed file — a
    hard, unconditional report-only boundary, mirroring `specjedi-
    analyze`'s established precedent. Automates the exact manual process
    this project's own history already performed twice by hand (the
    GROUNDING_PASS/NEXT_STEP_PASS/VOICE_PASS/PROMPT_ENG_PASS governance
    passes, and the 6-skill consistency audit). Its own first real dry
    run against every shipped skill surfaced two true, previously-unknown
    gaps in already-shipped skills (`specjedi-explain` and `specjedi-
    find-skills`, both missing a `` `--auto` mode `` section) — tracked as
    a follow-up fix, deliberately not bundled into this feature's own
    scope. Built via the same literal `/speckit-*` pipeline invocation
    established at v1.16.0.
-->

<!--
Sync Impact Report
- Version change: 1.16.0 → 1.16.1
- Modified principles: none (no MUST-level rule changed) — PATCH bump,
  consistent with how routine skill shipments are versioned after the
  first process-milestone MINOR bump
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs: all six historical governance TODOs remain resolved
  (LICENSE_CONTRIBUTING v1.15.1, NEXT_STEP_PASS v1.15.2, GROUNDING_PASS
  v1.15.3, VOICE_PASS v1.15.4, PROMPT_ENG_PASS v1.15.5, INSTALLER v1.15.6).
  TODO(LOCALIZATION) opened at v1.15.14, still open — needs a maintainer
  decision on translation approach before execution. `specjedi-new-skill`
  shipped at v1.16.0 (see prior history). This amendment adds a new item:
  - `specjedi-release` shipped (feature 010-specjedi-release,
    2026-07-11) — the second second-wave addition beyond the original
    roadmap backlog. Wraps the existing `scripts/suggest-release.sh`/
    `.ps1` with Spec Jedi's own voice, narrating the last tag, suggested
    next version/bump type, and contributing commits. Never tags or
    publishes — a hard, unconditional boundary (Principle XI), not a
    confirm-then-proceed gate. Closes the same class of gap
    TODO(INSTALLER) closed for Principle XVIII: a principle mandated a
    capability, only a bare script implemented it, no `specjedi-*` skill
    gave it a product surface. `specjedi-docs/SKILL.md`'s own next-step
    reference was updated to point here instead of the bare script — a
    reference update only, explicitly not a proactive self-invoke wiring
    (resolved via a real `/speckit-clarify` question this cycle: a
    release check has no urgency comparable to a security gap, and this
    project's own multi-feature-per-session pace would make an automatic
    trigger noisy). Built via the same literal `/speckit-*` pipeline
    invocation established at v1.16.0.
-->

# Spec Jedi Constitution
<!-- Project name confirmed by the maintainer: Spec Jedi — a Star Wars Jedi
     allusion (repo: spec-jedi). -->

## Core Principles

### I. English-Source, Globally-Localized Documentation

All skill source material — `SKILL.md` files, code comments, reference docs,
prompts embedded in skills, and generated artifacts — MUST be authored in
English, regardless of the language used in conversation with the maintainer
or contributors. English is the single source of truth; translations are
derivative, not parallel originals.

The top-level project documentation (README, CONTRIBUTING, installation
guides, and getting-started material) MUST additionally be maintained in
Mandarin Chinese (`zh`), Hindi (`hi`), Spanish (`es`), French (`fr`), Arabic
(`ar`), Bengali (`bn`), Portuguese (`pt`, Brazilian variant), Russian (`ru`),
Urdu (`ur`), and Indonesian (`id`) — the ten most-spoken languages in the
world after English, by total speakers, per the most recent authoritative
linguistic survey at time of writing — so the project is approachable to the
widest practical audience. This is a deliberate, maintainer-decided scope,
naming the actual ten languages concretely rather than leaving the original
"ten most-spoken" text open-ended and re-derivable differently each time it
was read (`checklists/project-completeness.md` CHK006). The list started at
six (`zh`, `hi`, `es`, `fr`, `ar`, `bn`, shipped first) and was deliberately
extended to ten (`pt`, `ru`, `ur`, `id` added) once the maintainer confirmed
the scope — each extension MUST follow the same discipline: real,
maintainer-decided languages actually translated and shipped, never an
open-ended target nothing ever satisfies.

Localized docs live under `docs/i18n/<lang>/`, each carrying an
`i18n-sync: source=<file>@<commit>` marker recording the English commit it
was translated from. Localized docs MUST be kept in sync with the English
source; `scripts/validate.sh`/`.ps1` MUST flag (non-blocking) any localized
doc whose recorded source commit no longer matches the English file's
actual latest commit, rather than letting it be silently served as current.

**Rationale**: A single canonical language prevents semantic drift and merge
conflicts in the material that skills actually execute from, while broad
localization of onboarding docs maximizes real-world adoption — the
project's explicit goal is reaching "thousands of people" globally. Naming
ten specific languages instead of a re-derivable "ten most-spoken" makes the
mandate checkable and keepable; an automated sync check makes "kept in
sync" a real, continuously-verified mechanism instead of an unenforced
aspiration.

### II. Competitive Research Before Creation (NON-NEGOTIABLE)

No new skill, workflow, or structural pattern may be added to this project
without first researching the current state of the art in Spec-Driven
Development. At minimum, every new skill's design MUST be benchmarked
against GitHub's `spec-kit` (github.com/github/spec-kit) plus at least ten
other publicly available SDD skill/agent/tool collections. The comparison
MUST be written down (in the feature's `research.md`) with: what each
alternative does well, what it does poorly, and which specific mechanism —
if any — this project is adopting, adapting, or deliberately rejecting, and
why.

Reinventing a mechanism that a well-regarded prior art already solved is a
constitution violation unless the research doc justifies the divergence.

Research MUST NOT stop at synthesis. Spec Jedi is a **competitor** to
spec-kit, not a themed reskin of it (Principle XV) — adopting the best parts
of ten other tools produces, at best, a well-assembled average of the field.
`research.md` MUST therefore also name at least one capability the resulting
design offers that **no** researched competitor has — something Spec Jedi
contributes back to the field, not just absorbs from it. If no genuine
addition is identified for a given skill, that is itself a signal to keep
researching or reconsider the skill's scope, not to ship a same-as-everyone
design anyway.

**Rationale**: The project's stated ambition is to be "the best SDD tool in
the world." That claim is only defensible if every design decision can point
to a documented comparison against existing practice, not intuition alone —
and "best" requires genuinely exceeding the field on at least one axis per
skill, not just matching its median.

### III. Universal LLM & Harness Compatibility

Every skill and its installation mechanism MUST be designed against a
documented compatibility matrix covering at least twenty of the
highest-usage LLM tools/harnesses in the market (e.g., Claude Code, Cursor,
GitHub Copilot, Codex CLI, Gemini CLI/Antigravity, Windsurf, Cline, Continue,
Aider, Amazon Q Developer, JetBrains AI, Zed, OpenCode, and others determined
current at research time). The matrix MUST be re-verified whenever a new
MAJOR product release ships (the skill-package release line Principle XI
defines, not this constitution document's own version number — the two
are explicitly distinct lines, and this is the one that tracks actual
skill/harness behavior), since the ranking and capabilities of these
tools change quickly.

Skill content itself MUST be written against the lowest common denominator
of agent capability (markdown instructions, explicit file paths, no
assumptions of a specific proprietary tool schema) with harness-specific
adapters layered on top — never the reverse. Installation instructions
(README/quickstart) MUST give a working path for every harness in the
matrix, not just the maintainer's own daily driver.

**Rationale**: Fragmented, single-harness tooling is the single biggest
adoption blocker for shareable skill packages; this project exists
specifically to not repeat that mistake.

### IV. Structured, Opinionated Elicitation (Ask, Don't Assume)

Skills produced by this project MUST gather requirements from end users
through explicit, bulleted, multiple-choice-style questions before
generating specs, plans, or code — never by silently guessing intent on
ambiguous or consequential decisions.

Skills MUST NOT default to agreeing with every user choice. When a user's
request conflicts with SDD best practice, introduces unjustified complexity,
or contradicts information already gathered, the skill MUST push back,
explain the tradeoff, and ask a follow-up question rather than complying
silently. This applies recursively: the skill keeps refining through
questions until the produced artifact is a faithful, technically sound
representation of what the user actually needs — not merely what they
initially typed.

For the project's first-run entry point (`specjedi-onboard`), this
elicitation discipline extends to idea formation itself, not just artifact
content: when a user has no concrete idea yet, or explicitly asks for help
figuring out what to build, the skill MUST engage in one-question-at-a-time,
multiple-choice-preferred guided ideation — optionally surfacing 2-3
candidate directions with trade-offs and a recommendation when the request
is genuinely open-ended — before locking in the one-sentence idea handed to
`specjedi-constitution`/`specjedi-specify`. This borrows its interaction
shape from established brainstorming-style guided-ideation patterns, scoped
narrowly to idea formation: it MUST NOT duplicate `specjedi-specify`'s own
requirement gathering or `specjedi-clarify`'s downstream ambiguity-resolution
loop, and MUST NOT produce a standalone design document —
`specjedi-onboard` hands off a crystallized idea, not a spec.

Project-wide, not scoped to any single skill: whenever a `specjedi-*` skill
presents a genuine multiple-choice-style decision point — two or more
reasonable options exist and the skill has a defensible preference among
them — the skill MUST mark one option as **Recommended**, with a one-line
reason, in the style `/superpowers:brainstorming` and this project's own
`specjedi-clarify`/`specjedi-onboard` already establish. Wherever that same
skill defines an `--auto` mode, `--auto` MUST resolve any such
Recommended-marked question by automatically selecting the Recommended
option and proceeding — while still recording the choice in whatever audit
trail the skill already produces, so an automated run stays reviewable
after the fact, exactly as `specjedi-clarify`'s existing `--auto` mode
already does. This requirement applies only to genuine multi-option
elicitation — it does NOT require a skill to invent a fake multiple-choice
structure around a binary confirm/proceed gate, a required-parameter ask,
or a single-best-answer recommendation (e.g. `specjedi-find-skills`
presenting exactly one recommended skill is already compliant in spirit
without needing an artificial menu of alternatives).

**Rationale**: This is what distinguishes a professional collaborator from
an order-taker; the user explicitly requires skills that don't always agree
and keep asking until the result is right. A total beginner arriving with
only a vague notion — not yet a real one-sentence idea — is exactly the
user `specjedi-onboard`'s own persona commits to meeting where they are;
gating on "give me one sentence" without helping shape that sentence first
leaves the person who most needs guidance with none. A named recommendation
with a reason is also what makes `--auto` mode trustworthy: an automated
run that silently picked *something* is not auditable, but one that
predictably picked the same option a human reviewing the choice would
also see recommended is — this is the difference between automation and
guessing with extra steps.

### V. Specification Completeness for Autonomous Execution

Every artifact a skill produces (constitution, spec, plan, tasks) MUST be
detailed and unambiguous enough that an autonomous/auto-mode agent can
execute it end-to-end without stalling on undocumented decisions. Any
requirement that cannot yet be made unambiguous MUST be marked
`NEEDS CLARIFICATION` and resolved via elicitation (Principle IV) before
downstream artifacts are generated — never deferred to implementation-time
guesswork.

**Rationale**: The project's premise is that well-documented specs let
harness auto-modes run to completion unattended; incomplete specs defeat
that premise and produce unreviewable, unpredictable output.

### VI. Test-First Delivery, AI-First Posture

This project is built AI-first: skills MUST be designed assuming their
primary author and primary executor are AI agents, with human review as a
checkpoint rather than a line-by-line authoring step. Wherever the produced
artifact is code, generated plans MUST default to test-first (TDD)
execution — tests written and failing before implementation — unless the
feature spec explicitly states tests are not applicable (e.g., pure
documentation or config-only changes), in which case the plan MUST state the
explicit reason.

Where the deliverable includes a web UI or browser-driven flow, plans MUST
call for Playwright-based verification (visual + interaction + console/
network checks) as part of the definition of done, not as an optional
afterthought.

**Rationale**: Matches the project's AI-first, TDD-first-where-applicable
mandate and keeps generated code held to the same rigor as hand-written
code.

### VII. Full-Stack Technical Depth On Demand

Skills MUST be capable of acting as frontend and backend specialists
whenever the detected project type requires it — adapting the depth and
vocabulary of guidance (framework idioms, API design, data modeling,
accessibility, performance budgets) to what the user is actually building,
rather than producing generic, stack-agnostic advice when a concrete stack
is already known.

**Rationale**: Generic advice is lower value than stack-aware advice once
the technical context is known; the project must be credible across both
frontend and backend domains.

### VIII. Token-Economy Tooling Integration

Every project this toolkit scaffolds, and every long-running skill session
it drives, MUST proactively check for and suggest installing/configuring
`rtk` (github.com/rtk-ai/rtk) and `graphify` (graphify.net) as token-saving
companions, explaining what each does and the expected savings. Suggestion
MUST be proactive (surfaced without the user having to ask), but
installation/configuration of either tool MUST require explicit user
confirmation before running — consistent with the standing rule that tool
installation and shell-level configuration changes are not silently
autonomous actions.

**Rationale**: Directly requested as a standing recommendation; gating
actual installation behind confirmation keeps it compliant with safe
execution-of-actions practice.

### IX. Mandatory Skill Validation & Testing (NON-NEGOTIABLE)

No skill in this collection ships or merges without an accompanying,
automated validation mechanism: at minimum (a) a structural lint confirming
required `SKILL.md` frontmatter and file layout, (b) a scenario-based dry
run confirming the skill's elicitation questions and branching logic behave
as documented, and (c) for skills producing code, an execution test in at
least one representative target harness. Validation results MUST be
reproducible via a single documented command (e.g., a `scripts/validate.sh`
or CI workflow) — not a manual, undocumented checklist.

The set of checks in (a)–(c) is the **validation battery**, and it MUST
grow as the project grows: the moment any skill produces unit-testable
logic, integration behavior, or a web UI, the corresponding unit,
integration, or Playwright (Principle VI) tests join the battery as
required checks — never as optional or informational-only jobs. A battery
that only re-runs what existed at the project's infancy, while the project
itself has grown more capable, is itself a constitution violation.

**Rationale**: A project whose entire purpose is enabling reliable
downstream automation cannot itself ship unverified skills; that would
undermine the credibility this project depends on.

### X. Trunk-Based Git Workflow with Self-Validating Pull Requests

`main` is the trunk and the initial default branch. No commit is made
directly to `main`. Every logical set of changes MUST be committed on its
own short-lived branch and opened as a pull request targeting `main`; a PR
MUST correspond to one coherent change set, not an unrelated batch.

Every PR MUST be automatically validated against this constitution's
mechanisms — at minimum Principle IX's full validation battery, plus any
applicable linters, tests, and the Constitution Check — via a CI workflow
triggered on the PR. Auto-merge MUST NOT trigger on a partial result: it
is permitted only once every job in the battery reports success, with zero
failing, erroring, or still-pending required checks. A single red or
pending check MUST hold the PR open indefinitely — there is no timeout,
manual override, or "merge anyway" path for automated PRs; a PR whose
checks fail MUST be fixed (new commits re-run the battery) or closed.

To keep this enforceable as the battery grows, the CI workflow MUST expose
one aggregating gate job (e.g., `ci-gate`) that depends on every other job
in the battery (`needs: [lint, unit, integration, e2e, ...]`) and MUST be
the single status check branch protection requires. New battery jobs are
added to that `needs` list as the project grows (Principle IX); branch
protection itself never needs to be reconfigured when the battery changes.

Automated merging MUST be achieved through GitHub's supported mechanism —
required status checks plus the repository's "Allow auto-merge" setting —
and MUST NOT be achieved by spoofing or bypassing GitHub's own
self-approval restriction (e.g., having the same identity or the default
`GITHUB_TOKEN` approve a PR it also opened). GitHub does not allow a PR's
author to approve their own PR, and using the default `GITHUB_TOKEN` to
work around that restriction is a documented security anti-pattern, not a
sanctioned automation path. If a recorded human-style "approval" review is
desired in addition to passing checks, it MUST come from a distinct bot
identity (its own account or GitHub App installation) that never opens the
PRs it reviews — never from reusing the token/identity that authored the
change.

**Checks-only auto-merge is a privilege of the repository owner's own PRs,
not a blanket policy.** A PR opened by the repository owner MAY auto-merge
on the validation battery alone (Principle IX), exactly as described above.
A PR opened by anyone else MUST additionally receive an explicit approving
review from the owner before it can merge — auto-merge or manual — even if
`ci-gate` is fully green. Passing CI proves the change doesn't break
anything measurable; it proves nothing about whether an outside
contribution should be trusted with what it's actually trying to do, and
that judgment call belongs to the owner, not to `ci-gate`. This is a
distinct, real reviewer (the owner) reviewing someone else's PR — not the
self-approval spoofing the paragraph above forbids.

**Rationale**: Directly requested: every commit ships through a PR that the
project validates and merges itself. The constraint against self-approval
spoofing exists because the alternative is a known privilege-escalation
bypass — this project aims to be professional and trustworthy for
thousands of downstream users, so its own CI cannot rely on a technique
security researchers flag as a vulnerability. The owner/non-owner split
exists because a project inviting outside contributions (Principle I's
explicit goal of reaching "thousands of people") needs a real human
checkpoint on what those contributions actually do, not just whether they
happen to pass automated checks — CI catches breakage, not bad intent or
poor judgment.

### XI. Semantic-Versioned Releases with Proactive Cut Suggestions

The project's own releases (a distinct version line from this constitution
document's own version) MUST follow Semantic Versioning (MAJOR.MINOR.PATCH)
scoped to the public skill-package contract: MAJOR for breaking changes to
a skill's behavior/interface or a removed skill, MINOR for a new skill or a
backward-compatible capability addition, PATCH for fixes, documentation, or
internal-only changes that don't alter observable skill behavior.

The project MUST proactively surface when a release is warranted rather
than leave it to the maintainer to notice. Changes accumulated since the
last tag MUST be classifiable via a documented, reproducible mechanism
(e.g., Conventional Commits prefixes read by a `scripts/suggest-release.sh`
or equivalent CI job) that recommends the next version number and states
why. Actually cutting a release — tagging, publishing, finalizing a
changelog — MUST require explicit maintainer confirmation; suggesting a
release and shipping one are different acts, and only the former is
autonomous.

**Rationale**: Directly requested: the project should tell the maintainer
when it's time to release, using semver, without silently tagging and
publishing on its own — consistent with this project's standing rule that
visible, externally-facing actions need a human go-ahead.

### XII. Star Wars-Flavored End-User Voice — Jedi Master Fluency

Whenever a Spec Jedi skill is actually talking to an end user — prompts,
clarifying questions, progress updates, success/failure messages,
celebratory moments — it MUST use a bold, funny, unmistakably Star
Wars-flavored voice: emojis and thematic vocabulary used liberally enough
that a user could recognize a Spec Jedi skill by tone alone, even with
branding hidden.

This project's Star Wars fluency MUST be genuinely deep, not a handful of
recycled original-trilogy quotes. It MUST draw from across the full saga —
the prequel, original, and sequel trilogies, plus the major episodic series
(*The Clone Wars*, *Rebels*, *The Mandalorian*, *The Book of Boba Fett*,
*Obi-Wan Kenobi*, *Ahsoka*, *Andor*, and others as canon grows) and the
anthology films (*Rogue One*, *Solo*) — and from genuine Jedi-culture
depth: the Jedi Code, the Force's light/dark duality, the Padawan → Knight
→ Master progression, the Jedi Council, lightsaber forms, and similar.
References MUST rotate across this breadth rather than leaning on the same
three or four famous lines everywhere; a user well-versed in the saga
SHOULD regularly notice a well-chosen, specific reference, not a generic
one. The canonical reference pool lives in
`references/star-wars-lexicon.md` and MUST be extended (not duplicated
ad hoc) as new situations or new canon material arise.

This voice is deliberately scoped:

- **Applies to**: chat responses, CLI/terminal output, prompts and
  questions posed to the user, and marketing-style copy (README, launch
  posts).
- **Does NOT apply to**: the literal content of generated
  `spec.md`/`plan.md`/`tasks.md`/`constitution.md` fields — requirements,
  acceptance criteria, and task descriptions MUST stay precise and
  unambiguous per Principle V. Flavor may decorate headers and transitions
  in these files but MUST NOT replace or obscure the substantive
  requirement text.
- Deep-cut references are encouraged and expected — that's what "Jedi
  Master fluency" means — but they are seasoning, not the dish: the CORE
  meaning of any message MUST remain understandable to a reader who has
  never seen a single frame of Star Wars, so translation into the ten
  languages Principle I requires never breaks. English-only wordplay MUST
  be paired with a plain-language equivalent, never used alone.
- Emojis MUST be decorative, never the sole carrier of meaning — pair a
  pass/fail emoji with the word PASS/FAIL — so screen-reader users aren't
  excluded.
- A plain, no-frills mode MUST always be available on request without any
  loss of functionality; the voice is presentation, never a gate.
- This is unofficial fan-inspired flavor, not a claim of affiliation:
  skills and docs MUST NOT imply endorsement by, or sponsorship from,
  Lucasfilm/Disney, and MUST NOT reproduce official logos or
  copyrighted artwork — text references only.
- The overall register MUST read as warm, funny, and human — natural
  sentences a witty person would actually say, not stock AI-assistant
  phrasing ("I'd be happy to help you with that!", "As an AI..."). This is
  a *writing style* requirement, not a deception one: a skill MUST NEVER
  claim to literally be a human being if a user asks directly whether
  they're talking to AI — answer that question honestly, in the same warm
  voice, and keep going.

**Emoji Icon Language**: the project MUST maintain a documented, consistent
mapping from recurring SDD situations (spec ambiguity, CI green/red,
release, blocked PR, first contribution, sign-off, and similar) to
specific emoji, so the same situation reads the same way everywhere
instead of an author picking emoji ad hoc each time. This mapping lives in
`references/star-wars-lexicon.md` and MUST be extended there, not invented
inline per skill.

- Icons used for this MUST be **standard Unicode emoji** — universally
  free, license-free, and rendered natively by virtually every terminal,
  browser, and screen reader, with no attribution or licensing question at
  all. This is the default and the safe path.
- "Free Star Wars emoji/icon packs" found online are NOT automatically
  usable just because they're publicly downloadable: fan-made character
  likenesses are typically still under Lucasfilm/Disney copyright
  regardless of a pack's own "free" label, and any officially-branded
  emoji set is licensed IP, not free. Before any non-Unicode icon asset is
  added to this project, it MUST be verified as either original artwork or
  under a permissive open license that explicitly allows redistribution —
  "I found it free online" is not sufficient verification. When in doubt,
  use a standard Unicode emoji instead; it always satisfies both this rule
  and the non-affiliation rule above.

**Rationale**: Directly requested: a consistent icon language, built from
emoji that need no license or attribution, gives the project's voice a
recognizable visual signature without reopening the trademark risk the
non-affiliation clause above already exists to manage — "free-sounding"
Star Wars icon packs are exactly the kind of thing that looks safe but
usually isn't.

**Rationale**: Directly requested: the project should be a "Jedi Master" of
its own theme, not a shallow reskin — genuine breadth and depth across the
whole saga (not just the original trilogy) is what makes the identity feel
authored rather than generic. Scoping the voice away from literal
spec/plan/task content protects Principle V's requirement that autonomous
agents can execute unambiguously; requiring the core meaning to survive
without the reference protects Principle I's translation mandate even as
the references themselves get more adventurous; the decorative-emoji and
opt-out rules keep the fun from becoming an accessibility tax; the
non-affiliation rule keeps a trademark-adjacent theme legally sane for a
project meant to reach thousands of people.

### XIII. Cross-Platform Support: Linux, macOS, Windows

Spec Jedi MUST work for a user on Linux, macOS, or Windows — not "Windows
via WSL only" as an unstated assumption, and not documentation that quietly
only covers Unix-like systems. This is a distinct axis from Principle III
(which harness/LLM tool): this principle is about which *operating system*
the human and their shell are running.

Concretely:

- Every executable script this project ships (e.g., under `scripts/`) MUST
  have both a POSIX shell version (`.sh`, bash-compatible) and a native
  PowerShell version (`.ps1`) with equivalent behavior — mirroring the
  pattern spec-kit's own tooling already uses
  (`.specify/*/scripts/{bash,powershell}/`). A contributor MUST NOT add a
  `.sh` script without its `.ps1` counterpart (or vice versa) in the same
  change set.
- Installation and quickstart documentation MUST give explicit,
  step-by-step instructions for all three operating systems, including
  Windows users who work in native PowerShell/CMD and Windows users who
  work through WSL or Git Bash — these are different setups with different
  failure modes and MUST NOT be collapsed into a single unlabeled set of
  steps that only actually works on one of them.
- The CI validation battery (Principle IX/X) MUST exercise more than one
  operating system, not just the runner the maintainer happens to develop
  on, so cross-platform claims are continuously verified rather than
  asserted once and left to rot.
- Scripts and docs MUST avoid OS-specific assumptions that silently break
  elsewhere: hard-coded path separators, case-sensitivity assumptions,
  and inconsistent line endings (the repository MUST pin line endings for
  script files via `.gitattributes` so a Windows checkout can't corrupt a
  bash script's shebang handling).

**Rationale**: Directly requested: a skill package that only documents (or
only works on) one operating system excludes a large share of the "thousands
of people" this project is meant to reach. Requiring a tested `.ps1`
alongside every `.sh`, OS-labeled documentation, and a multi-OS CI matrix
turns "should work on Windows too" from a hope into something continuously
checked — consistent with Principle IX's insistence that validation be
reproducible and automated, not asserted.

### XIV. Guided Next-Step Suggestion

A Spec Jedi skill MUST NOT end an interaction by leaving the user to guess
what happens next. Every meaningful stopping point — end of a response,
completion of a step in the SDD pipeline, a decision point in a flow —
MUST offer the next step(s) as a short, selectable bulleted list, so the
user can act by picking an option rather than composing a new request from
scratch. This extends Principle IV's elicitation discipline from "gathering
requirements" to "what now" moments throughout the whole lifecycle, not
just at the start.

**Rationale**: Directly requested: the project should be self-intuitive —
a user should always be able to see, and pick from, the next move.

### XV. `specjedi-` Skill Naming Convention

Every skill authored as part of this project's own product surface (as
opposed to vendored third-party tooling this project builds on, like the
spec-kit `speckit-*` command skills) MUST be named `specjedi-<subject>`,
where `<subject>` is the specific problem the skill solves. This applies
going forward to every new Spec-Jedi-authored skill; it does not require
renaming already-vendored, non-Spec-Jedi-authored skills.

The `speckit-*` skills are **bootstrap tooling, not the product**: this
project currently uses spec-kit's own command skills to build itself
(dogfooding the incumbent to construct its replacement — the same
"bootstrap a compiler with an older compiler" pattern), while Spec Jedi's
actual competitive offering to end users is the `specjedi-*` surface.
End-user-facing material (README, quickstarts, installers) MUST present
`specjedi-*` skills as the product and `speckit-*` skills as internal
bootstrap tooling — never the reverse, and never blurred together as if
Spec Jedi were merely a themed reskin of spec-kit. Where the full
`specjedi-*` pipeline doesn't exist yet for a given capability, docs MUST
say so plainly (what ships today vs. what's roadmap) rather than
substituting a `speckit-*` walkthrough and calling it the product
experience.

**Rationale**: Directly requested (naming), then directly requested again
(positioning): a consistent prefix makes Spec Jedi's own skills instantly
recognizable, and keeping the bootstrap/product distinction explicit in
every end-user-facing surface is what makes Spec Jedi a genuine competitor
to spec-kit rather than a Star Wars-flavored wrapper around it — the
project's stated ambition (Principle II) doesn't hold if its own README
teaches newcomers the incumbent's command surface instead of its own.

### XVI. Efficient Documentation & Mermaid Diagram Literacy

Every `specjedi-*` skill MUST know how to produce efficient
documentation — choosing the format that conveys the content most
directly (prose, a table, a list, or a diagram) rather than defaulting to
whichever format is most familiar. This is an active evaluation, not a
passive default: a tool×dimension comparison (e.g.
`references/competitive-comparison.md`) is more efficient as a table than
forced into a diagram; a multi-step process with branches is more
efficient as a diagram than a prose wall describing the same flow. Padding
either format past what the content actually needs is itself an
inefficiency this principle forbids, in the same spirit as Principle XX's
token-economy requirement.

When the evaluation favors a diagram, a skill or doc MUST prefer a Mermaid
diagram over hand-drawn ASCII art, wherever the target rendering surface
supports it (GitHub, most IDEs, and many agent harnesses render Mermaid
natively). Prose remains required alongside the diagram for surfaces that
don't render Mermaid and for accessibility (a diagram is a supplement, not
a replacement, per the same spirit as Principle XII's decorative-emoji
rule) — never diagram-only documentation of a process.

Any `specjedi-*` skill that generates or recommends diagrams MUST be able
to select the correct Mermaid diagram type from Mermaid's full current
catalog — not just flowchart, sequence, and ER — grounded in
`references/mermaid-diagram-catalog.md`, the canonical, extensible
reference this principle requires (mirroring Principle XII's
`star-wars-lexicon.md` pattern: know the whole field, don't reach for the
same three familiar options by default). That catalog MUST be re-verified
against Mermaid's own current documentation whenever a diagram-producing
skill is meaningfully revised, since Mermaid adds new diagram types over
time.

**Rationale**: Directly requested: visual process explanations read faster
and stay accurate longer than prose walls describing the same flow — but
only when a diagram is actually the right tool, and only when the skill
choosing it knows the full range of grammars available rather than
forcing content into one of a handful of familiar shapes.

### XVII. Skill Discovery & Gap-Filling (`specjedi-find-skills`)

This project MUST ship a skill, `specjedi-find-skills`, that recognizes
when a task touches a domain the currently installed skill set doesn't
cover well and proactively suggests a specific, verifiable complementary
skill to close that gap — never installing anything without the user's
explicit go-ahead, consistent with Principle VIII's suggest-then-confirm
pattern. It was originally seeded from the open-source `find-skills` skill
(vercel-labs/skills, MIT-licensed, attribution retained) but MUST be
written in Spec Jedi's own voice and MUST exceed that source on every
axis below, not just rename it:

- **Proactive, not just reactive**: it MUST self-invoke whenever another
  `specjedi-*` skill's task touches a domain outside the installed skill
  set's competence — the agent should notice and surface a suggestion as
  part of that skill's own output, not wait for the user to separately
  ask "is there a skill for X." This is a standing invocation contract
  every future `specjedi-*` skill MUST honor once it exists (tracked:
  TODO(SPECJEDI_PIPELINE)); it does not require the whole pipeline to
  exist to be true today for whichever `specjedi-*` skills already ship.
- **Harness-aware, not registry-locked**: it MUST reason about which
  discovery mechanism actually fits the user's current harness
  (Principle III's compatibility matrix) rather than assuming one
  npm-centric registry is universal — the underlying ecosystem it queries
  is an implementation detail, not the point.
- **Gap memory, not a one-shot lookup**: when it declines to find a good
  match, it SHOULD note the gap (e.g., in the host project's
  `.specify/memory/` if that scaffolding is present) so a recurring,
  unfilled need becomes visible product-roadmap signal rather than being
  silently re-discovered every session.
- Usable in two contexts: developing Spec Jedi itself, and inside any
  end-user project that has installed the Spec Jedi skill pack.

**Rationale**: Directly requested: a project that teaches structured
development shouldn't leave users stuck when their need falls outside its
own skill set — pointing at a specific, vetted alternative is more useful
than silence or a vague "I can't do that." Making it proactive rather than
purely reactive, and harness-aware rather than registry-locked, is what
makes it genuinely better than the skill it was seeded from rather than a
reskin of it — consistent with Principle XV's competitive stance.

### XVIII. Zero-Footprint Installer with Harness Selection

This project MUST provide a single installer entrypoint capable of
placing the Spec Jedi skill set into a new or existing target project's
directory, and MUST let the user choose which harness(es), from the
Principle III compatibility matrix, to configure for — rather than
assuming the maintainer's own daily-driver harness. The installer itself
MUST follow Principle XIII (work on Linux, macOS, and Windows) and
Principle IX (be validated, not just asserted to work).

**Rationale**: Directly requested: broad harness support (Principle III)
is only useful if getting the skills into a real project is a single,
guided step rather than manual copy-pasting.

### XIX. Skill Authoring & Prompt Engineering Standard

Every `specjedi-*` `SKILL.md` MUST follow a defined structure and quality
bar, documented in full in `references/skill-authoring-standard.md`. The
non-negotiables:

- **Structure**: YAML frontmatter (name, description, required
  compatibility/environment constraints, allowed tools where applicable),
  a context/domain section stating clearly when and why to use the skill,
  step-by-step actionable instructions (not abstract concepts), realistic
  copy-pasteable examples including edge cases, and optional executable
  scripts the skill can trigger.
- **Ruthless literalness**: no subjective, unmeasurable claims ("fast",
  "user-friendly"). Requirements MUST be quantifiable and testable where
  possible (e.g., a concrete token budget, not "concise"). A vague
  instruction produces a vague, or hallucinated, result — literalness is
  a hallucination-prevention mechanism, not a style preference.
- **Conciseness via progressive disclosure**: the core `SKILL.md` targets
  under 500 tokens for fast loading and MUST NOT exceed roughly 5,000
  tokens; material beyond that MUST move to `references/` and be loaded
  on demand, never inlined wholesale.
- **Always-Do / Never-Do guardrails**: every prohibition MUST be paired
  with the alternative action to take instead — a bare "don't do X" is
  incomplete.
- **Verifiable assertions**: a skill MUST state success criteria the
  agent (or CI, per Principle IX) can check programmatically — e.g., "the
  output is valid JSON" — not just prose intent.
- **Explicit human-approval boundaries**: every skill MUST state plainly
  which of its actions are autonomous and which require the user's
  explicit confirmation first, mirroring the pattern this constitution
  already applies to tool installation (Principle VIII) and destructive
  git/repo operations (Principle X).

**Prompt Engineering Discipline** — every skill's instructional content
IS a prompt to an LLM, and MUST be engineered as one, not just written as
documentation:

- **Persona**: where the skill benefits from the agent adopting a
  specific role (e.g., "act as a security reviewer," "act as a release
  manager"), the skill MUST state that role explicitly in its
  context/domain section — persona changes tone and depth, and leaving it
  implicit leaves output quality to chance.
- **Task**: the core directive MUST be stated as a single, unambiguous
  action up front, not buried in background paragraphs the agent has to
  infer intent from.
- **Format**: whenever consistency of output matters (a report, a
  generated file, a structured response), the skill MUST specify the
  exact expected shape — table columns, required sections, a schema — not
  leave structure to model discretion.
- **Few-shot examples**: the examples required by the Structure bullet
  above MUST include at least one full input → desired-output pairing,
  not just a description of what a good example would look like —
  showing beats describing.
- **Chain-of-thought for non-trivial judgment**: any skill that asks the
  agent to classify, prioritize, or resolve ambiguity (not just execute a
  deterministic procedure) MUST instruct the agent to reason through the
  decision before committing to an answer, surfacing the reasoning where
  the harness supports it. This is the same discipline Principle V
  already requires of specs — visible reasoning catches hidden
  assumptions before they ship.
- **Audience calibration**: a skill's explanations MUST scale to the
  person asking, not assume one fixed expertise level. A user who has
  never touched SDD before and a practitioner who's shipped ten specs
  this month both need to come away understanding what to do next — the
  first needs plain language and the "why," the second needs the answer
  without the preamble. A skill MUST read the signals already available
  (how the user phrased the question, prior turns in the session, an
  explicit "I'm new to this" or "just the command") rather than defaulting
  to jargon-heavy brevity or over-explaining to someone who clearly
  doesn't need it. This applies project-wide, not just to a dedicated
  explainer skill: every `specjedi-*` skill's own responses, not only
  documentation, are a beginner's or an expert's first impression of
  whether this project is for them.

**Rationale**: Directly requested, synthesizing widely-used industry
guidance (Anthropic, Vercel, and similar agent-skill practitioners, plus
established prompt-engineering fundamentals: context, task, format,
few-shot examples, chain-of-thought, persona) into one enforceable bar, so
every skill this project ships is reliable by construction rather than by
luck — the same "documented, reproducible mechanism" ethos Principle IX
already applies to validation, now applied to how skills themselves get
written and to the prompt craft inside them.

### XX. AI Discipline: Grounded, Efficient, Honest Output

Three explicitly required pillars govern how every `specjedi-*` skill
actually uses AI at runtime, not just how it's authored (Principle XIX
covers authoring; this covers behavior):

- **Best-practice AI usage**: every skill applies Principle XIX's prompt
  engineering discipline in practice, not just in its own source — persona,
  explicit task framing, and chain-of-thought reasoning for judgment calls
  MUST actually shape the skill's real output, not just appear as headers in
  the file that get ignored at runtime.
- **Token economy by default**: skills MUST operate efficiently themselves,
  not only suggest external token-saving tools (Principle VIII). Concretely:
  prefer targeted lookups over dumping whole files, reuse context already
  established in the conversation instead of re-deriving it, and follow
  Principle XIX's progressive-disclosure pattern (core file lean, detail
  loaded on demand) so a skill's own footprint stays small. When a
  token-economy tool the user has installed (e.g., a knowledge-graph query
  mechanism) offers a cheaper path to the same information a skill would
  otherwise get by brute-force reading, the skill MUST prefer it.
- **Hallucination resistance**: a skill MUST NEVER present an unverified
  guess as fact. Concretely: don't state an install count, API behavior, or
  file's contents without having actually checked it in this session; when
  something is genuinely unknown, say so explicitly rather than filling the
  gap with a plausible-sounding fabrication; ground factual claims in a
  cited source (a fetched doc, a file actually read, a command actually
  run) the same way Principle II already requires research claims to be
  grounded, not asserted from memory alone.

**Rationale**: Directly requested as three explicit, named pillars — best
AI practice, token economy, and avoiding AI "delírios" (hallucinations) —
treated here as one coherent runtime-discipline principle because they're
the same underlying commitment: an AI-first tool (Principle VI) has to be
trustworthy about what it actually knows versus what it's inventing, and
economical about the resources it spends finding out, or the "AI-first"
positioning becomes a liability instead of the project's advantage.

### XXI. Session-Start Orientation & the Master Yoda Greeting

Every Claude Code session working in this project SHOULD open with a
brief, three-part orientation rather than a blank prompt: (1) a small
ASCII-art Spec Jedi banner, (2) a one-paragraph project status summary,
and (3) one rotating line of Master Yoda-styled guidance. This is a
policy commitment; the mechanism that delivers it is a
`SessionStart`-hook-plus-agent-render contract, described precisely
below rather than left to assumption.

**The real mechanism, stated accurately**: Claude Code's `SessionStart`
hook does not print text directly to the user's terminal — its stdout is
injected as `additionalContext` for the agent to read on its next turn,
capped at 10,000 characters (per Claude Code's own hook documentation,
fetched and verified before this principle was written, not assumed).
A `SessionStart` hook implementing this principle MUST therefore do two
things, not one: (a) gather and emit the orientation content as
`additionalContext`, and (b) this constitution's own project instructions
(e.g. `CLAUDE.md`) MUST instruct the agent to actually render that
content verbatim as its opening reply when a `SessionStart` context block
is present — a hook alone cannot satisfy this principle; the render
instruction is load-bearing, not optional.

**No parallel status system**: the status-summary portion MUST derive
from the exact same on-disk-artifact logic `specjedi-status` already
uses (spec/plan/tasks presence and checkbox state) — never a second,
separately-maintained tracking mechanism, per the same "avoid internal
redundancy" discipline Principle II already requires when weighing a new
mechanism against ones this project has already shipped. This principle
is compatible with, not redundant with, `specjedi-status` (full
on-demand dashboard) and `specjedi-onboard` (first-run-only walkthrough):
this fires briefly on every session, not on demand and not only once.

**The Master Yoda persona, scoped narrowly**: unlike Principle XII's
broad, saga-wide rotating voice used across all end-user-facing skill
output, the Master Yoda persona is reserved specifically for this
session-start greeting moment — using it everywhere would dilute both
the greeting's distinctiveness and Principle XII's own broad-rotation
requirement. Canonical Yoda speech patterns (documented in
`references/star-wars-lexicon.md`'s dedicated Master Yoda section,
MUST be extended there rather than improvised ad hoc): inverted
object-subject-verb sentence construction ("Ready, are you," not "Are
you ready"), terse aphorisms over long explanations, wisdom framed as
gentle challenge rather than flattery, warmth paired with discipline.
Lines MUST rotate rather than repeat the same greeting verbatim every
session, and MUST still satisfy Principle XII's core rule: understandable
to someone who has never seen a single frame of Star Wars.

**Branding art, not reproduced trademarks**: the ASCII banner MUST be an
original Spec Jedi wordmark/lightsaber rendering — never a recreation of
GitHub's actual `spec-kit` logo or any other real organization's
trademark, per Principle XII's existing "no logos, no copyrighted
artwork" guardrail applied here to a new asset type.

**Principle II applies to building this, not to stating it**: this
principle establishes policy; the `SessionStart` hook script, the
`CLAUDE.md` render instruction, and the ASCII art asset are new
structural pattern work and MUST go through Principle II's competitive
research (does any researched tool already do a session-start
status+greeting hook? what's the genuine contribution here?) before
shipping, the same as any other new mechanism — a constitution amendment
alone does not satisfy that gate.

**Precedence when the render instruction conflicts with a continuation
directive**: a real instance of exactly this conflict occurred and is
resolved here rather than left to accidental precedent. When the same
turn carries both a `SessionStart` context block AND an explicit
session-continuation/no-preface instruction (e.g. "resume directly, do
not preface your response"), the continuation instruction MUST take
precedence over rendering the payload verbatim as a formal opening
block — it is the more specific, more urgent signal about what's needed
in that moment. This MUST NOT be read as license to drop this
principle's orientation goal entirely: the agent MUST still work the
payload's real status information into its first substantive response
naturally. `CLAUDE.md` carries the operative instruction; this
constitution entry is the policy source it implements.

**Rationale**: Directly requested: a session should open with insight,
not silence — a returning contributor immediately sees what's been done,
a first-timer immediately sees this project has a distinct voice, and
the specific choice of Master Yoda (rather than a generic Star Wars
reference) gives the orientation moment its own recognizable texture,
consistent with Principle XII's "recognizable by tone alone" goal but
scoped tightly enough not to overwhelm every other interaction with the
same inverted-syntax bit.

## Distribution & Ecosystem Standards

Every skill package in this repository MUST include: a `SKILL.md` with
complete frontmatter (name, description, trigger conditions), a
`references/` directory for supporting material too large for the main
file, and a pointer to its validation mechanism (Principle IX). Competitive
research artifacts (Principle II) live alongside the skill they informed,
not in a disconnected wiki.

The repository root MUST carry a `README.md` that gives newcomers a
complete, self-contained path to a working install — not a stub pointing
elsewhere. At minimum it MUST cover, in this order: a row of status badges
(build/CI status, license, latest version, and similar) so a visitor can
tell at a glance how the project is built before reading a word of prose;
what the project is and who it's for; prerequisites; step-by-step
installation for every currently supported harness (Principle III),
written so a user with no prior context can follow it to a working state;
a quickstart showing the first commands to run; and a pointer to how
releases/versioning work (Principle XI).

**Badges MUST be dynamic wherever a dynamic source exists, never a
hand-typed value that can silently go stale.** A badge showing a version,
a build/CI result, or any other fact with a live source of truth (a file
in the repo, a GitHub API endpoint) MUST be wired to that source — e.g. a
shields.io `dynamic/regex` badge reading the version line directly out of
`constitution.md`, or a native GitHub badge (`github/last-commit`,
`github/actions/workflow/status`, and similar) — rather than a static
`img.shields.io/badge/...` string someone has to remember to edit. This
project shipped exactly that mistake once (the Constitution badge sat
hardcoded at `v1.8.0` while the constitution moved through five more
version bumps before anyone noticed) and MUST NOT repeat it: a
hardcoded fact-bearing badge is a constitution violation, not a
stylistic choice, whenever a dynamic alternative is technically feasible.

**Before opening any pull request, the badge row MUST be reviewed** for
two things: that every existing badge still reads correctly (a dynamic
badge is generally self-correcting, but confirm nothing broke), and
whether the PR's own change warrants a genuinely new, relevant badge (a
new capability worth signaling, a milestone, a newly-available dynamic
metric) — not addition for its own sake, and never another hardcoded
value that will just go stale again the same way. A harness listed in the
Principle III compatibility matrix but not yet covered by working install
steps MUST be marked as such in the README rather than silently omitted.

The repository root MUST carry a `LICENSE` file using the **MIT License**
specifically (not left as a generic "any OSI-approved license" choice),
and the README's license section MUST explain in plain language what MIT
actually permits and requires (free use/modification/redistribution,
including commercially, with the original copyright notice retained and
no warranty provided) rather than just linking the file. The repository
root MUST also carry a `CONTRIBUTING.md` describing how new skills are
proposed and reviewed under this constitution, and issue/PR templates
that require contributors to confirm they performed the research and
validation steps above before requesting review.

## Development Workflow

New skills and material changes to existing skills MUST follow this
project's own SDD pipeline, dogfooding the tool it ships: research
(Principle II) → `/speckit-specify` → `/speckit-clarify` as needed →
`/speckit-plan` → `/speckit-tasks` → implementation → validation
(Principle IX) → commit on a feature branch → open a PR against `main` →
automated validation workflow runs → auto-merge on green, blocked on red
(Principle X). Localization (Principle I) runs on its own cadence, not
per-feature: `README.md`/`CONTRIBUTING.md` are localized as a
whole-project pass whenever their English content has meaningfully
changed since the last pass, not re-translated on every individual
feature's PR — the `scripts/validate.sh`/`.ps1` sync-drift check is what
actually signals when that pass is due, not a step in each feature's own
pipeline.

Code and content review MUST explicitly check compliance with every Core
Principle above before approval; a reviewer (human or the automated
validation workflow) MAY block a PR solely for missing competitive
research (Principle II) or missing validation (Principle IX) even if the
implementation itself is otherwise correct.

## Repository & CI Configuration Prerequisites

Principle X depends on the following being configured on the actual GitHub
repository before auto-merge can function. These are infrastructure/
security settings, not skill content, and MUST be applied deliberately by
a maintainer rather than silently assumed:

- **Default branch**: `main`, with direct pushes disabled for all
  contributors including automation.
- **Branch protection on `main`**: require the aggregating `ci-gate` status
  check (Principle X) to pass before merging — not individual sub-checks,
  so the required-checks list in GitHub never needs to change as the
  battery grows. This applies to every PR regardless of author.
- **Owner-approval CI gate**: implemented as a battery job
  (`owner-gate`, part of what `ci-gate` requires — Principle IX), not as a
  GitHub branch-protection/ruleset review requirement. GitHub's native
  ruleset `bypass_actors` mechanism was tried first and verified live to
  *not* satisfy this need: a bypass actor can only force-merge via an
  explicit admin-override action, which does not feed into
  `gh pr merge --auto`'s automatic evaluation — the owner's own PRs would
  stop auto-merging entirely, not just gain a legitimate exception.
  `owner-gate` instead checks the PR author directly: authored by the
  owner → passes immediately; authored by anyone else → passes only once
  the owner has left an `APPROVED` review on that PR (checked via the
  GitHub API, keyed to the owner's username), which the workflow also
  listens for (`pull_request_review: submitted`) so approving doesn't
  require pushing a new commit to re-trigger CI.
- **Repository setting "Allow auto-merge"**: MUST be enabled so a PR can
  be marked `gh pr merge --auto` (or equivalent) immediately on open and
  complete automatically once checks go green.
- **Actions permissions**: if the validation workflow itself opens PRs
  (e.g., a skill-generated change), organization/repository Actions
  settings control whether `GITHUB_TOKEN`-authored PRs can trigger further
  workflows; this MUST be reviewed, not left at an unexamined default.
- **Optional reviewer bot identity**: only required if the project wants a
  recorded approval in addition to status checks. This means a second
  GitHub identity (dedicated bot account or GitHub App) with its own
  credential stored as a repository secret — never the same token used to
  open the PR. Creating this identity and secret requires the
  maintainer's explicit action.

None of the above is applied automatically by this constitution — it
documents what MUST exist for Principle X to hold, so any contributor
setting up CI knows the target state and doesn't reach for the
self-approval bypass instead.

## Governance

This constitution supersedes all other conventions, prior skill templates,
or ad hoc practices within this repository. Where a skill's own
documentation conflicts with this constitution, the constitution wins and
the skill documentation MUST be corrected.

**Amendment procedure**: Amendments are proposed by editing this file
through the `/speckit-constitution` command (or an equivalent reviewed PR),
must state the reason for the change, and must update the Sync Impact
Report at the top of the file plus any dependent templates
(`plan-template.md`, `spec-template.md`, `tasks-template.md`,
`checklist-template.md`) before being considered complete.

**Versioning policy**: Semantic versioning applies to this document itself.
MAJOR — a principle is removed or redefined in a backward-incompatible way.
MINOR — a principle or governance section is added, or existing guidance is
materially expanded. PATCH — clarifications, wording, or typo fixes with no
semantic change.

**Compliance review**: Every `/speckit-plan` run MUST pass the Constitution
Check gate derived from this document before Phase 0 research begins, and
again after Phase 1 design. Unresolved violations MUST be recorded in that
plan's Complexity Tracking table with an explicit justification, or the plan
MUST be simplified until it complies.

**Version**: 1.23.0 | **Ratified**: 2026-07-10 | **Last Amended**: 2026-07-12

<!--
Sync Impact Report
- Version change: 1.4.0 → 1.5.0
- Modified principles: Principle XII expanded (not redefined) — Star Wars
  fluency now explicitly spans the full saga (all trilogies + major
  series) plus genuine Jedi-culture depth, replacing the earlier
  "original-trilogy-only" scoping with a "deep cuts as seasoning, core
  meaning always plain" rule
- Added sections: none (amendment to existing Principle XII)
- Removed sections: none
- Templates requiring updates:
  - .specify/templates/plan-template.md ✅ compatible as-is
  - .specify/templates/spec-template.md ✅ compatible as-is
  - .specify/templates/tasks-template.md ✅ compatible as-is
  - .specify/templates/checklist-template.md ✅ compatible as-is
  - references/star-wars-lexicon.md ⚠ pending — created in the same
    change set as this amendment as the concrete, documented reference
    pool Principle XII now points to (saga-wide quotes/concepts mapped to
    SDD situations), consistent with Principle IX's "documented,
    reproducible mechanism" ethos applied to voice as well as validation
- Follow-up TODOs:
  - TODO(LICENSE_CONTRIBUTING): still open from v1.0.0 — license choice is
    a maintainer decision, not inferred.
  - TODO(VOICE_PASS): still open from v1.4.0 — no Spec-Jedi-authored
    end-user-facing skill exists yet; restyling the vendored speckit-*
    command output to draw from the expanded lexicon is future work
    through the normal SDD pipeline, not a direct edit.
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
guides, and getting-started material) MUST additionally be maintained in the
ten most-spoken languages in the world (by total speakers, per the most
recent authoritative linguistic survey at time of writing) so the project is
approachable to the widest possible audience. Localized docs MUST be kept in
sync with the English source; a localized doc that has drifted more than one
minor release behind MUST be flagged (e.g., a banner or issue) rather than
silently served as current.

**Rationale**: A single canonical language prevents semantic drift and merge
conflicts in the material that skills actually execute from, while broad
localization of onboarding docs maximizes real-world adoption — the
project's explicit goal is reaching "thousands of people" globally.

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

**Rationale**: The project's stated ambition is to be "the best SDD tool in
the world." That claim is only defensible if every design decision can point
to a documented comparison against existing practice, not intuition alone.

### III. Universal LLM & Harness Compatibility

Every skill and its installation mechanism MUST be designed against a
documented compatibility matrix covering at least twenty of the
highest-usage LLM tools/harnesses in the market (e.g., Claude Code, Cursor,
GitHub Copilot, Codex CLI, Gemini CLI/Antigravity, Windsurf, Cline, Continue,
Aider, Amazon Q Developer, JetBrains AI, Zed, OpenCode, and others determined
current at research time). The matrix MUST be re-verified whenever a new
major release of this project ships, since the ranking and capabilities of
these tools change quickly.

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

**Rationale**: This is what distinguishes a professional collaborator from
an order-taker; the user explicitly requires skills that don't always agree
and keep asking until the result is right.

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

**Rationale**: Directly requested: every commit ships through a PR that the
project validates and merges itself. The constraint against self-approval
spoofing exists because the alternative is a known privilege-escalation
bypass — this project aims to be professional and trustworthy for
thousands of downstream users, so its own CI cannot rely on a technique
security researchers flag as a vulnerability.

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

## Distribution & Ecosystem Standards

Every skill package in this repository MUST include: a `SKILL.md` with
complete frontmatter (name, description, trigger conditions), a
`references/` directory for supporting material too large for the main
file, and a pointer to its validation mechanism (Principle IX). Competitive
research artifacts (Principle II) live alongside the skill they informed,
not in a disconnected wiki.

The repository root MUST carry a `README.md` that gives newcomers a
complete, self-contained path to a working install — not a stub pointing
elsewhere. At minimum it MUST cover, in this order: what the project is and
who it's for; prerequisites; step-by-step installation for every currently
supported harness (Principle III), written so a user with no prior context
can follow it to a working state; a quickstart showing the first commands
to run; and a pointer to how releases/versioning work (Principle XI). A
harness listed in the Principle III compatibility matrix but not yet
covered by working install steps MUST be marked as such in the README
rather than silently omitted.

The repository root MUST also carry an OSI-approved open-source license, a
`CONTRIBUTING.md` describing how new skills are proposed and reviewed under
this constitution, and issue/PR templates that require contributors to
confirm they performed the research and validation steps above before
requesting review.

## Development Workflow

New skills and material changes to existing skills MUST follow this
project's own SDD pipeline, dogfooding the tool it ships: research
(Principle II) → `/speckit-specify` → `/speckit-clarify` as needed →
`/speckit-plan` → `/speckit-tasks` → implementation → validation
(Principle IX) → localization pass for any user-facing docs (Principle I)
→ commit on a feature branch → open a PR against `main` → automated
validation workflow runs → auto-merge on green, blocked on red
(Principle X).

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
  battery grows. Required *approving reviews* are OPTIONAL for bot-authored
  PRs specifically because GitHub cannot let a PR self-approve; gating on
  status checks alone is the supported pattern for fully automated merges.
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

**Version**: 1.5.0 | **Ratified**: 2026-07-10 | **Last Amended**: 2026-07-11

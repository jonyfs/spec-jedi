<!--
Sync Impact Report
- Version change: 1.15.4 → 1.15.5
- Modified principles: none (governance/tooling debt closed — no MUST-level
  rule changed)
- Added sections: none
- Removed sections: none
- Templates requiring updates: none
- Follow-up TODOs:
  - TODO(LICENSE_CONTRIBUTING): RESOLVED at v1.15.1.
  - TODO(VOICE_PASS): RESOLVED at v1.15.4.
  - TODO(NEXT_STEP_PASS): RESOLVED at v1.15.2.
  - TODO(INSTALLER): still open from v1.8.0.
  - TODO(PROMPT_ENG_PASS): **RESOLVED**. Audited all 12 shipped skills
    against Principle XIX's non-negotiables. Token budgets (~1,100-1,700
    tokens each) comfortably clear the 5,000 hard cap — the "targets under
    500" language is aspirational, not violated. Ruthless literalness: no
    unmeasurable claims found outside intentional "Not this" negative
    examples. The real finding: **only 2 of 12 skills
    (`specjedi-constitution`, `specjedi-specify`) had the required
    explicit "which actions are autonomous vs. need confirmation"
    statement** — the other 10 left this implicit or unstated entirely,
    despite Principle XIX requiring it plainly for every skill. Added an
    `## Autonomous vs. confirm-first` section to all 10, each stating the
    skill's actual boundary rather than a copy-pasted template —
    `specjedi-implement`'s is the highest-stakes case (code/commit/PR all
    autonomous once tasks.md is ready; merging is never claimed, only
    requested) and `specjedi-analyze`/`specjedi-explain`'s are trivial
    (no writes at all, nothing to confirm).
  - TODO(GROUNDING_PASS): **RESOLVED**. Re-reviewed all 11 shipped skills
    against Principle XX's three pillars:
    - *Best-practice AI usage* (persona/task/chain-of-thought actually
      shape output): found 3 skills whose real judgment call lacked
      explicit "reason through it" framing despite having one —
      `specjedi-checklist` (generic-vs-grounded item discard),
      `specjedi-converge` (drift-vs-incidental-detail), and
      `specjedi-implement` (`[P]`-eligibility re-verification). Fixed all
      three; `specjedi-onboard`'s lack of a labeled chain-of-thought
      section is intentional (documented in
      `specs/002-specjedi-onboard/plan.md` — its judgment calls are binary
      gates, not open-ended reasoning) and not a gap.
    - *Token economy by default* (prefer an installed token-economy tool
      over brute-force reads): found the codebase-scanning steps in
      `specjedi-plan` (the golden-rule scan) and `specjedi-converge` (drift
      detection) never mentioned preferring an installed tool like
      `graphify query` over raw file reads, despite Principle XX requiring
      exactly that. Fixed both.
    - *Hallucination resistance*: no violations found — every skill's
      factual-claim language already required grounding in something
      actually read/run this session; `specjedi-find-skills` remains the
      strongest reference implementation (install counts, sources, and
      links always tied to an actual lookup, never asserted from memory).
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

### XVI. Mermaid-First Process Documentation

Whenever a skill or doc needs to explain a process, flow, decision tree,
or sequence of steps, it MUST prefer a Mermaid diagram over a prose wall
or hand-drawn ASCII art, wherever the target rendering surface supports it
(GitHub, most IDEs, and many agent harnesses render Mermaid natively).
Prose remains required alongside the diagram for surfaces that don't
render Mermaid and for accessibility (a diagram is a supplement, not a
replacement, per the same spirit as Principle XII's decorative-emoji
rule) — never diagram-only documentation of a process.

**Rationale**: Directly requested: visual process explanations read faster
and stay accurate longer than prose walls describing the same flow.

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

**Version**: 1.15.5 | **Ratified**: 2026-07-10 | **Last Amended**: 2026-07-11

# Changelog

All notable changes to Spec Jedi are documented here, drafted by
`specjedi-docs` from each feature's own spec/plan and confirmed before
being written. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/) — version numbers come
from `scripts/suggest-release.sh` (Constitution Principle XI), not from
this file directly.

## Unreleased

## [v0.6.0] - 2026-07-20

### Added

- **`install.sh`/`.ps1` merge shareable hooks into an existing `PreToolUse` array** (feature 061, #167) — a target project's `settings.json` already having a `hooks.PreToolUse` array made the installer refuse to touch it, printing an "add manually" message instead of wiring the missing hooks. Now merges directly (python3 `json.load`/`json.dump` on `install.sh`, native `ConvertFrom-Json`/`ConvertTo-Json` on `install.ps1`) into the correct matcher group, creating it when absent — a deliberate, clarified exception to this project's general anti-round-trip caution for `settings.json`, justified because both preserve key order (nothing lost or reordered). No-python3 fallback and malformed-JSON fail-loud path preserved and verified unchanged.
- **`specjedi-govcheck` prints only findings, auto-proceeds when clean** (feature 062, #168) — always printed a full ~22-row per-principle table even when every row was N/A or Compliant, directly observed across three real runs this session. Internal per-principle reasoning stays complete on every run; the printed report now collapses to one summary line when clean, or only the Non-Compliant/CRITICAL rows when not — the full, unconditional table remains available on request.

## [v0.5.0] - 2026-07-20

### Added

- **`specjedi-caveman-mode`** (#162) — a new, distributable skill
  packaging the third-party `caveman` plugin's token-compression
  behavior for Spec Jedi projects. Compresses chat output to tight,
  caveman-speak phrasing (~65% fewer output tokens on average across six
  levels: `lite`/`full`/`ultra`/`wenyan`) while keeping code, commands,
  file paths, and error messages byte-exact. Activated per session via
  `/caveman ultra`; documented in this project's own `CLAUDE.md`.
- **`specjedi-plan` auto-invokes `specjedi-clarify`** (feature 059, #163)
  — `specjedi-plan`'s Step 1 previously stopped and merely recommended
  running `specjedi-clarify` when a `spec.md` still carried `NEEDS
  CLARIFICATION` markers, requiring a separate manual command. Now
  invokes `specjedi-clarify` automatically instead, mirroring
  `specjedi-clarify`'s own already-documented proactive self-invocation
  precedent from `specjedi-specify`. Bounded to once per `specjedi-plan`
  run — if markers survive one auto-invocation, the run stops and names
  the specific remaining question(s) rather than looping or silently
  proceeding. A marker `specjedi-plan` itself writes into `plan.md`'s own
  Technical Context stays out of scope, unaffected by this change.

## [v0.4.0] - 2026-07-19

### Added

- **`specjedi-catalog-audit`** (feature 049, #142) — a new, strictly
  read-only whole-catalog skill applying `specjedi-skill-review`'s own
  per-skill methodology to every shipped `specjedi-*` skill at once,
  cross-checked against `references/what-is-sdd.md`'s 7-phase SDD
  sequence for coverage gaps. Every finding classifies into exactly one
  of three categories — SDD-Coverage Gap, Skill-Quality Finding, or
  Redundancy — never a vague mix. Confirms the catalog still implements
  SDD end-to-end now that `speckit-*` (feature 048) is gone and there's
  no vendored reference left to compare against.
- **Skill reference integrity & example hooks** (feature 050, #145) — a
  full sweep of every `.claude/skills/specjedi-*/SKILL.md` against every
  `references/*.md` file it cites found 2 missing:
  `references/constitution-mechanics.md` (cited by
  `specjedi-constitution`) and `references/aitmpl-browsing-playbook.md`
  (cited by `specjedi-master`). Both written and filled in. Separately,
  `.specify/extensions.yml` gains real example hook entries so the
  hook-dispatch mechanism 9 core pipeline skills already check for
  (specs/047) has a concrete, working example instead of only
  documentation describing what one would look like.
- **Interactive next-step selection** (feature 051, #144) — every
  `specjedi-*` skill's Constitution Principle XIV closing "next step(s)"
  list now renders as a real selectable prompt (`AskUserQuestion` on
  Claude Code, with a documented fallback for harnesses without a native
  equivalent) instead of plain markdown text the user has to retype an
  answer to by hand — always with a final "type your own" escape hatch,
  matching the request's own explicit requirement.
- **`--auto` mode verification & `specjedi-chain`** (feature 052, #146)
  — a full sweep confirmed all 28-then-shipped skills already had a
  correctly-scoped `## \`--auto\` mode` section (no coverage gap), so
  this feature's real contribution is the new `specjedi-chain` skill:
  orchestrates `specjedi-specify` → `specjedi-clarify` → `specjedi-plan`
  → `specjedi-tasks` in `--auto` mode back-to-back for one feature,
  halting exactly where any stage's own already-documented `--auto`
  halts — never inventing new self-invocation timing or silently
  resolving an ambiguity a stage reserves for a human.
- **SessionStart next-step suggestion** (feature 054, #149) — the
  `SessionStart` orientation payload (Principle XXI) now includes a
  concrete next-step suggestion derived from the same on-disk artifacts
  `specjedi-status` already reads, rendered through feature 051's own
  new interactive-selection mechanism — no second tracking system, no
  new selection UI invented.
- **Loss-safe skill update & interactive update prompt** (feature 055,
  #150) — `scripts/install.sh`/`.ps1` now back up any locally-modified
  `specjedi-*` skill or `.specify/templates/*.md` file to
  `.specify/backups/<UTC-timestamp>/` before overwriting it during an
  update, so a routine update can never silently destroy a hand-edited
  file. The `SessionStart` freshness line (feature 042) now directs the
  agent to ask the user directly whether to update, rather than only
  describing the update path. Constitution Principle XXII amended
  (1.28.0 → 1.29.0) to reconcile "advisory only" with this new
  interactive trigger.
- **`specjedi-parallel`** (feature 056, #147) — determines which
  candidate `specjedi-*` features are genuinely safe to run at the same
  time by cross-referencing each candidate's own already-declared
  `plan.md` "Source Code" file list for real overlap (excluding
  known-shared metadata files every feature routinely touches), then
  dispatches one `specjedi-worktree` per safe feature and, when the
  harness supports it, one distinct agent per worktree. Never claims
  parallel execution happened on a harness without a real
  concurrent-agent-dispatch mechanism.
- **A distinct "Mission Complete" closing voice** (feature 057, #148) —
  a concrete, checkable trigger condition for when a closing moment
  counts as genuinely "reached the end" (verifiably exhausted scope, not
  a routine successful step), plus a Star Wars-toned closing-line
  convention pairing with Principle XII's existing plain-language
  requirement. Applied to the 3 skills with a genuine exhausted-scope
  case in their own logic: `specjedi-skill-review`, `specjedi-catalog-
  audit`, `specjedi-constitution-audit`.
- **Git safety hooks: secret-scanner, conventional-commits,
  prevent-direct-push** (#151, via `specjedi-master`) — three
  `PreToolUse` hooks adapted from aitmpl.com's `hooks/security` and
  `hooks/git` catalogs: blocks a `git commit` containing a real-looking
  hardcoded credential (30+ provider patterns) or a message that
  doesn't follow this project's own `type: description` convention, and
  blocks a `git push` that actually targets `main`/`develop`. Two
  vendor bugs found and fixed before install: the commit-message
  regex falsely matched on this project's own heredoc commit style, and
  the push guard blocked any push made while sitting on `main`/`develop`
  regardless of the push's real target.
- **Desktop notification on response completion** (#152, via
  `specjedi-master`) — a native OS notification (`osascript` on macOS,
  `notify-send` on Linux) fires once per completed response via the
  `Stop` hook event, so a long-running turn no longer requires manually
  checking back.

## [v0.3.0] - 2026-07-18

### Removed

- **`speckit-*` vendored bootstrap tooling** (feature 048) — following a
  direct question about whether it could already be removed without
  losing any capability `specjedi-*` doesn't have, all 11 vendored
  `speckit-*` skills are removed from `.claude/skills/`. The two
  `.specify/extensions.yml` hooks that still depended on one
  (`after_specify`/`after_plan` → `speckit.agent-context.update`) are
  retired, with `specjedi-plan` gaining a native step to keep
  `CLAUDE.md`'s plan-reference pointer current in its place.
  `install.sh`/`package-release.sh` never packaged `speckit-*` for end
  users, so external Spec Jedi users are unaffected. Constitution
  Principle XV amended (v1.27.0 → v1.27.1, PATCH) to state the
  bootstrap phase is complete rather than ongoing; every live
  `/speckit-*` tooling reference in the constitution (via
  `specjedi-migrate`), README, `CONTRIBUTING.md`, and
  `references/principle-traceability.md` is rewritten to `/specjedi-*`.
  This project's own development now runs entirely on `specjedi-*`, the
  same tool it ships — closing the loop `specs/044`/`specs/047`
  assessed readiness for.

### Added

- **README objectivity & evidence-based benefits rewrite** (feature 046)
  — every substantive claim in `README.md` now cites a specific project
  artifact instead of an unsupported adjective. Adds a new
  "`specjedi-*` versus `speckit-*`, by the numbers" subsection citing
  `specs/044-speckit-parity-audit/PARITY-LEDGER.md` directly: 8/11 full
  parity, 1/11 favorable divergence, 2/11 no-equivalent (both resolved),
  18 `specjedi-*`-only skills. Fixes three stale numbers found during
  re-verification (the Skills badge, the skill-category diagram, and
  the ledger's own internally-inconsistent skill count) and two stale
  claims in "Honest assessment" (constitution version; a since-outdated
  "no release has been cut yet"). Leaves the comic-panel section and
  opening epigraph untouched, per precedent already settled in specs/036
  and specs/037.
- **`specjedi-*` pipeline hook dispatch** (feature 047) — closes the one
  real engineering blocker `specs/044`'s parity audit identified for a
  full internal migration off `speckit-*`: all 9 core `specjedi-*`
  pipeline skills (`specjedi-constitution` through `specjedi-converge`)
  now implement the same `.specify/extensions.yml`
  `hooks.before_<stage>`/`hooks.after_<stage>` dispatch check every
  matching `speckit-*` skill already had individually, verified via a
  real dry-run against this project's own two live registered hooks.
  With this and the two prior recommendation items already resolved by
  maintainer decision, no known engineering gap remains blocking a full
  internal migration — whether and when to execute one stays a separate,
  later decision.

### Fixed

- Corrected a stale internal count in
  `specs/044-speckit-parity-audit/PARITY-LEDGER.md` (said 16
  `specjedi-*`-only skills; its own enumerated list and independent
  arithmetic both say 18) and refreshed several reference docs
  (`references/quickstart-guide.md`, `references/specjedi-and-sdd.md`,
  `references/honest-assessment.md`, `references/skill-roadmap.md`)
  whose skill/principle counts had drifted from the constitution's
  actual current state (22 principles, 27 `specjedi-*` skills) —
  surfaced by a whole-project `specjedi-constitution-audit` run.

## [v0.2.0] - 2026-07-18

### Added

- **SDD friction reduction** (feature 045) — real, cited community
  pain-point research (GitHub `spec-kit` issues/discussions, engineering
  blogs, academic papers) identified three distinct gaps in this
  project's own `specjedi-*` pipeline, closed by extending five existing
  skills rather than adding new ones. `specjedi-analyze` gains a
  requirement-to-verification traceability check ("the missing testing
  layer" — the single most heavily-corroborated complaint found),
  classifying every FR/Acceptance Scenario Verified/Unverified/Not
  Applicable against real evidence, plus reverse-direction orphaned-code
  detection; `specjedi-implement` now self-invokes it before every
  PR-open, alongside its existing `specjedi-govcheck` self-invoke.
  `specjedi-skill-review` measures a reviewed skill's own token count
  against Constitution Principle XIX's stated budget (previously
  aspirational text with no check); `specjedi-plan` compares a new
  feature's spec/plan size against this project's own real historical
  median. `specjedi-quick` gains a `bugfix.md` artifact shape
  (reproduction, root cause, fix, regression test) as a sibling to its
  existing `quick.md`, sharing every quality gate identically.
- **Skill freshness validation & update awareness** (feature 042,
  Constitution Principle XXII) — `scripts/install.sh`/`.ps1` now write
  an installed-release marker (`.specify/release-marker.json`) at
  install time: a real release tag when installed from a packaged
  release, or an explicit `"local-checkout"` sentinel when run directly
  from a git clone. `scripts/package-release.sh`/`.ps1` stage a new
  `RELEASE_VERSION` stamp file into every tarball so `install.sh` can
  determine this on its own — no changes needed to
  `scripts/bootstrap-install.sh`/`.ps1` at all.
  `scripts/session-start.sh`/`.ps1` gain an additive freshness-check
  line comparing the installed marker against the latest published
  GitHub Release, reusing `bootstrap-install.sh`'s own `releases/latest`
  lookup and `GITHUB_TOKEN` handling but with its own short, explicit
  timeout and a single attempt — never `bootstrap-install.sh`'s
  multi-attempt retry loop. Silent on every incomplete state (no marker,
  malformed marker, local-checkout sentinel, unreachable/rate-limited
  API) — advisory only, never blocks or errors. Two new CI job families
  (`install-test-release-marker`, `session-start-freshness-check`,
  3-OS matrix plus native Windows PowerShell) prove both scenarios
  against real installs.

- **Whole-project constitution coverage audit** (feature 043) — a new
  skill, `specjedi-constitution-audit`, evaluates all 22 Core Principles
  plus the Distribution & Ecosystem Standards and Development Workflow
  sections against the entire current project tree, never a diff —
  complementary to `specjedi-govcheck`'s existing per-PR/per-branch
  scope. Cross-checks every claim in
  `references/principle-traceability.md` against what actually exists
  today, flagging drift in both directions (an entry overstating
  coverage, or understating it) and undocumented gaps. Its own first
  real run found and closed two genuine drift instances: Principle
  XXII's row still said "Not started" after feature 042 had already
  shipped, and Principle XI's row still said the first release "has not
  yet been cut" after v0.1.0/v0.1.1 had already been published.

- **`specjedi-*`/`speckit-*` parity audit & migration readiness**
  (feature 044) — `specs/044-speckit-parity-audit/PARITY-LEDGER.md`, an
  evidence-based comparison of all 11 `speckit-*` pipeline commands
  against `specjedi-*`'s command set. 8 of 11 full parity, 1 favorable
  divergence (`specjedi-implement` already enforces trunk-based PR
  discipline `speckit-implement` doesn't), 2 no-equivalent (one never
  used in this project's real history, one architecturally superseded
  by `specjedi-status`'s zero-tracking design). Verdict: not yet safe
  for a full internal migration off `speckit-*` — the one real blocker
  (no `specjedi-*` pipeline skill implements
  `.specify/extensions.yml`'s hook-dispatch mechanism) is explicitly
  deferred to its own future spec cycle, not silently dropped.

- **Release-ship shareable hooks & settings, per harness** (feature 041)
  — `scripts/install.sh`/`.ps1` now install a shareable safety hook
  (`dangerous-command-guard`) and git-aware `statusLine`/`permissions`
  settings, trunk-branch-aware and non-destructively merged, for
  `claude-code` (default-on, interactive-prompt opt-out). Extended with
  real, harness-native translations for seven more harnesses: Wave 1
  (`gemini-cli`, `antigravity`, `codex-cli`) get a translated declarative
  JSON hook — never a copy of Claude Code's own hook-output shape; Wave 2
  (`opencode`, `zed`, `amazon-q`) get translated allow/ask/deny-shaped
  permissions; `warp` gets an honest advisory instead of a file write,
  since its only confirmed settings file is global-user-level, not
  project-scoped, and this installer never touches state outside the
  target project. The 9 researched-as-None harnesses and
  Cursor/Windsurf/Copilot (explicitly deferred, not silently dropped)
  are unchanged. Two new CI job families
  (`install-test-shared-hooks-wave1`/`-wave2`, 3-OS matrix plus native
  Windows PowerShell) prove idempotency, JSON validity, and translation
  correctness for real scratch installs — never asserted in docs alone.
  See `specs/041-release-hooks-settings/research.md` for the full
  per-harness classification and citations.

- **Expanded release package** (feature 038) — `scripts/package-release.sh`/
  `.ps1` (the artifact `scripts/bootstrap-install.sh`/`.ps1` download)
  now also stage `README.md`; three user-facing reference docs
  (`references/quickstart-guide.md`, `references/what-is-sdd.md`,
  `references/specjedi-and-sdd.md`); and a new
  `references/session-start-hook-guide.md` plus
  `scripts/session-start.sh`/`.ps1`, giving a user who never clones the
  repo both real usage documentation and a working session-start hook
  example with an honest, per-harness confirmed/unconfirmed status
  table — never a fabricated blanket claim. Deliberately still excludes
  `specs/*` and 11 internal skill-authoring/governance reference docs
  (plus `CONTRIBUTING.md`), verified by a new
  `package-content-completeness` CI job that builds a real tarball and
  inspects its actual contents on all three OSes, including a
  byte-identical staged-tree parity check between the two script
  variants. `scripts/install.sh`/`.ps1` are unchanged — this is a
  packaging change, not an installer behavior change.

### Fixed

- Along the way, three real cross-platform CI bugs in the new job's
  `windows-latest` leg, each diagnosed from its actual error message
  rather than guessed at: Git Bash auto-translating a bash-generated
  POSIX-style temp path when handed to `pwsh` as a command-line
  argument; a non-deterministic same-job tar rebuild failure; and the
  actual root cause underneath both — `tar` applying the traditional
  Unix `host:path` remote-archive convention to a Windows drive-letter
  path (`D:\...` parsed as "connect to a host named D"), fixed by
  converting to the POSIX-style form Git Bash's own MSYS runtime already
  recognizes, only when the path actually needs it.
- **Memory-file skill mentions** (feature 039) — `scripts/install.sh`/
  `.ps1` now create or idempotently update `CLAUDE.md` (`claude-code`),
  `AGENTS.md` (`codex-cli`), and `.trae/rules/project_rules.md` (`trae`)
  with a marker-delimited (`<!-- SPEC-JEDI:SKILLS:START/END -->`)
  section naming the installed skills — closing the gap where these
  three "skills-dir" harnesses got nothing, unlike the 14 "bridge"
  harnesses that already generate an equivalent file. Preserves every
  byte of a pre-existing file's own content outside the section;
  re-running the installer with no skill-set change leaves the file
  byte-for-byte unchanged. Deliberately untouched: `antigravity` (no
  confirmed separate memory-file convention — inventing one would be a
  fabricated capability claim) and the 14 bridge harnesses (their
  existing bridge file already serves this purpose). New
  `memory-file-injection` CI job (3-OS matrix) proves fresh creation,
  content preservation, idempotency, CRLF handling, and marker-
  corruption failure against a real installer run.

### Fixed

- Four more real cross-platform bugs, three found only once the new CI
  job actually ran on `windows-latest`: a stale `$LASTEXITCODE` from an
  intentionally-failing test scenario falsely marking a passing step as
  failed; `Get-ChildItem`'s unsorted enumeration order breaking
  `install.sh`/`.ps1` output parity (fixed with an explicit
  `Sort-Object`); PowerShell's regex over-stripping a CRLF file's
  trailing `\r` down to a bare LF; and bash's own `${#var}`/
  `${var:0:N}` counting *bytes* instead of *characters* under Windows
  Git Bash's locale, silently breaking cross-script parity on any
  description containing an em-dash — fixed with a locale-independent
  UTF-8-aware length/truncate implementation, verified to never produce
  invalid UTF-8.

## [v0.1.1] - 2026-07-14

### Fixed

- `scripts/bootstrap-install.ps1` splatted `-TargetDir`/`-Harness` as an
  array, which PowerShell binds **positionally** rather than by name —
  the literal `"-TargetDir"` string landed in `install.ps1`'s first
  parameter and the real path landed in its second, silently misrouting
  `TargetDir`'s value into `Harness`. Switched to hashtable splatting,
  which binds unambiguously by name.
- `scripts/install.ps1`'s harness auto-detection used
  `$env:USERPROFILE`, which is Windows-only and resolves to nothing on
  macOS/Linux; switched to `$HOME`, PowerShell Core's cross-platform
  automatic variable.
- `.github/workflows/validate.yml`'s `bootstrap-installer-smoke` job
  still asserted the installer must *fail* ("no release found"), stale
  the moment `v0.1.0` was published by the same run that shipped it —
  inverted to assert success and a populated `.claude/skills`.
- That same job's PowerShell smoke-test step hardcoded a Windows-only
  `C:\` target path even though `pwsh` also runs the step on the
  `ubuntu-latest`/`macos-latest` matrix legs — switched to
  `$env:RUNNER_TEMP`, which resolves correctly on all three OSes.
- Both bootstrap installers' release-lookup call collapsed a transient
  failure (rate limit, network blip, 5xx) and a genuine "no release
  found" into the same misleading message; added a 3-attempt retry with
  backoff, and diagnosed (via an HTTP-status capture) that
  `macos-latest`'s shared, heavily-reused runner IP pool was hitting
  GitHub's real 60/hour anonymous API limit — both installers now
  opportunistically authenticate with `GITHUB_TOKEN` when it's present
  in the environment (5000/hour), while staying anonymous for real end
  users running them outside CI.
- `scripts/bootstrap-install.sh` crashed with `install_args[@]: unbound
  variable` on macOS specifically: macOS ships bash 3.2 (Apple has
  stayed on GPLv2 licensing for years), which treats an empty array as
  unset under `set -u` when expanded with `"${arr[@]}"`, unlike bash
  4.4+ (Linux, Git Bash on Windows). Applied the
  `${arr[@]+"${arr[@]}"}` idiom already used in `session-start.sh`.
- `.github/workflows/release.yml`'s trailing `CHANGELOG.md` commit could
  lose a non-fast-forward race against `main` moving mid-run (the
  actual GitHub Release and tarball still published correctly; only
  this bookkeeping commit failed) — added a fetch+rebase+retry-with-
  backoff loop before the final push.

## [v0.1.0] - 2026-07-14

### Added

- **README as a wise Jedi's letter** (feature 036) — reframes
  `README.md`'s narrative sections (the opening pitch, "Who this is
  for," "What you get today"'s intro, and the Quickstart's connective
  prose) as an actual letter — an addressed opening, a body connecting
  disciplined SDD practice (constitution-first, test-first, no
  self-approval) to "the right side of the Force," and a closing
  send-off — while every fact, badge, link, table, code block, and the
  5 existing Mermaid diagrams stay exactly as they were. Adds 2 new
  original illustrations (`docs/comic/letter-open.jpg`,
  `docs/comic/letter-path.jpg`), generated via the same Pollinations.ai
  mechanism feature 035 verified, both passing Constitution Principle
  XII's Star-Wars-signature exclusion review clean on the first
  attempt. Also removes `saber.svg` and its Noun Project attribution
  from the README title and disclaimer, across the English source and
  all 10 i18n translations.
- **Skill validation & testing framework compliance audit** (feature
  033) — closes a real, measured gap: a direct `grep` audit found zero
  of the 24 shipped `specjedi-*` skills cited
  `references/skill-validation-testing-framework.md`, despite
  Constitution Principle IX requiring every skill's dry-run coverage to
  address its four adopted categories (vague/incomplete input, prompt
  injection resistance, out-of-bounds/malformed input, external-call
  resilience) wherever applicable. All 24 skills now carry a `##
  Validation Coverage (Principle IX)` section stating each category's
  status explicitly — Applicable with a concrete, skill-specific
  scenario, or Not Applicable with a stated reason — determined by one
  single, consistently-applied rule per category
  (`specs/033-skill-validation-audit/research.md`), never 24 independent
  judgment calls. `specjedi-skill-review` gains this framework as an
  explicit review dimension going forward, so the gap can't silently
  reopen.
- **`specjedi-worktree`** (feature 032) — mechanizes git-worktree-based
  parallel development, closing the gap `references/competitive-
  comparison.md`'s Spec Kitty row and `references/honest-assessment.md`'s
  Improvement Points previously only documented as advice. Creates a
  worktree for a named feature on demand, preferring a native harness
  relocation tool (Claude Code's `EnterWorktree`/`ExitWorktree`) and
  falling back to a project-local, `.gitignore`-verified `.worktrees/`
  directory otherwise — the design adopted directly from Superpowers'
  `using-git-worktrees` skill (inspected in full this cycle). Also
  provides the reusable proactive-offer detection step `specjedi-
  specify`/`specjedi-quick` now self-invoke before starting a new
  feature atop real uncommitted work on a non-trunk branch, and pairs
  with a `specjedi-status` extension unifying status reporting across
  every worktree of the repository in one report.
- **Honest advantages/disadvantages assessment** (feature 027) — new
  `references/honest-assessment.md`: candid, three-section self-
  assessment (Advantages / Disadvantages / Improvement Points), each
  advantage citing a specific shipped mechanism, each disadvantage
  independently checkable, each improvement point naming a specific
  researched competitor. Headline finding: `references/competitive-
  comparison.md`'s own BMAD-METHOD row recorded Spec Jedi as having
  "adopted" the Quick Flow lightweight-path idea back at feature 001,
  but no such skill had ever shipped — named as the top improvement
  point, later closed by feature 028 (`specjedi-quick`).
- **Constitution v1.24.0 — skill validation testing framework** —
  adapts a maintainer-supplied external skill-validation framework
  (written for live, API-backed conversational agents) into Principle
  IX's scenario-dry-run requirement, scoped to what actually applies to
  this project's architecture. New `references/skill-validation-
  testing-framework.md`: adopted categories (vague/incomplete input,
  out-of-bounds input, prompt-injection resistance, external-call
  resilience) each with a concrete Spec Jedi example; explicitly
  rejected categories (RBAC, PII masking, third-party load-testing
  tools) named and reasoned about, not silently dropped.
- **Theme-safe, right-sized Mermaid diagrams** (feature 025) —
  `specjedi-diagram`'s render-verification step now also checks: zero
  explicit `style`/`classDef`/`%%{init` color overrides (so diagrams
  inherit the rendering surface's own light/dark theme instead of
  breaking GitHub's auto-switching), and a 20-node complexity
  threshold, splitting oversized diagrams into multiple smaller,
  labeled diagrams along a natural seam. New "Theme Safety" and
  "Complexity Threshold" sections in `references/mermaid-diagram-
  catalog.md`.
- **Mandatory, failure-aware render verification** (feature 026) —
  `specjedi-diagram`'s render-verification is now unconditional (no
  skip branch, ever), and a render-verification *call* failure (error,
  timeout, output too large — the class of problem behind messages
  like "Unable to render rich display") is now treated identically to
  a Mermaid syntax failure. Revision is bounded at 2 attempts, falling
  back to an explicit "unverified" caveat rather than looping or
  presenting silently.
- **`specjedi-quick`** (feature 028) — a lightweight, one-artifact path
  for small, well-understood changes, closing `references/honest-
  assessment.md`'s top improvement point. Validated by BMAD-METHOD's
  Quick Flow ("fits on one page of notes") and OpenSpec's three-command
  model. Produces one `quick.md` instead of the full `spec.md`+
  `research.md`+`plan.md`+`tasks.md` set, then implements directly —
  test-first, `specjedi-govcheck`, and PR-only discipline never shorten,
  only planning ceremony does. Declines unconditionally for anything
  failing its five-criterion eligibility checklist, including any
  request for a new `specjedi-*` skill. Paired with a small
  `specjedi-status` compatibility extension so quick-path features
  report correctly instead of appearing artifact-less.
- **Standalone bootstrap installer** (feature 024, Sub-Project B) —
  `scripts/bootstrap-install.sh`/`.ps1` fetch a published GitHub Release's
  `spec-jedi-<version>.tar.gz` and run its bundled `install.sh`/`.ps1`,
  no local `git clone` required — a Homebrew/SDKMAN-style one-liner.
  Forwards `--harness`/`--auto`; supports `--version` to pin a specific
  release. This project's own first release (`v0.1.0`) hasn't been cut
  yet, so the live-download path is verified against a locally-built
  release artifact rather than production — stated explicitly, not
  hidden — while the "no release found" path is verified against this
  repo's real, current (empty) release list.
- **Full harness coverage** (feature 023) — closes Constitution Principle
  III's last open gap. `scripts/install.sh`/`.ps1` now support all 20
  harnesses in the compatibility matrix (up from 5): Antigravity joins
  the native skills-directory group (`.agents/skills/`, shared with
  Codex CLI, zero new installer code); the other fourteen (Cursor,
  Windsurf, GitHub Copilot, Gemini CLI, Cline, Continue, Aider, Amazon Q
  Developer, JetBrains AI Assistant, Zed, Replit Agent, Devin, Tabnine,
  Sourcegraph Cody) get a new **bridge-file mechanism**: the full
  `specjedi-*` package still lands at the canonical `.claude/skills/`,
  and a generated adapter file (or one per skill, for directory-
  convention harnesses) points into it using each harness's own
  documented rules format. Sourcegraph Cody's prior "Unclear" capability
  status is resolved — no confirmed always-on rules file exists, so it's
  installed via its real, documented Custom Commands mechanism
  (`.vscode/cody.json`), explicitly flagged as manual-invocation rather
  than automatic context. Verified via new `install-test-antigravity` and
  matrix `install-test-bridge-harnesses` CI jobs on Linux, macOS, and
  Windows (bash and native PowerShell).
- **Session-start live-render verification closure** (feature 022) —
  closes Constitution Principle XXI's last remaining gap: feature 015's
  T020 (a real, live session-start firing was never observed). A genuine
  `SessionStart:compact` event fired later in this project's lifetime
  and produced the correct three-part payload — cited verbatim as
  evidence in `specs/015-session-start-hook/tasks.md`. Also resolves a
  real, previously-undocumented conflict the same observation surfaced:
  the render-verbatim instruction versus an explicit session-
  continuation/no-preface instruction — `CLAUDE.md` and Constitution
  Principle XXI (v1.23.0) now state which one wins and why, without
  dropping the orientation goal entirely. Principle XXI's traceability
  status moves from 🟡 Partial to ✅ Mechanized.
- **Harness auto-detection** (feature 021) — Sub-Project C of the
  release/installer decomposition identified during feature 020's
  brainstorming. `scripts/install.sh`/`.ps1`'s `--harness` flag is now
  optional: when omitted, the installer checks ranked signals (a
  matching directory already in the target project, a matching CLI
  binary on `PATH`, a matching global config directory) for each of the
  three real harnesses, auto-installs on a single match, and resolves
  multiple matches through Constitution v1.22.0's project-wide
  Recommended-option standard — an interactive lettered prompt with a
  real TTY, or an automatic Recommended-selection (stated explicitly)
  otherwise or with the new `--auto` flag. Every existing explicit
  `--harness` invocation is completely unaffected — proven by every
  pre-existing `install-test*` CI job passing unmodified, plus a new
  `harness-auto-detect` job pair proving the detection mechanism itself
  on all three OSes.
- **Release packaging & publishing workflow** (feature 020) — the first
  real, deliberate release-cutting mechanism this project has ever had.
  `.github/workflows/release.yml`, triggered only by `workflow_dispatch`
  (never automatically on push/merge, per Principle XI), with a
  `dry_run` input defaulting to `true` so the entire mechanism —
  version validation, `scripts/validate.sh` gate, empty-changelog gate,
  artifact packaging — can be rehearsed with zero risk before a real
  cut. New `scripts/package-release.sh`/`.ps1` build a single universal
  downloadable artifact (verified to install identically to a full
  clone, across all three currently-supported harnesses). A real run
  (`dry_run: false`) tags, publishes a GitHub Release via `gh release
  create` (which atomically creates the tag), and rewrites
  `CHANGELOG.md`'s `## Unreleased` section into a versioned one. Built
  via `/superpowers:brainstorming` as Sub-Project A of a 3-part
  decomposition (release packaging → standalone bootstrap installer →
  harness auto-detection); this project's actual first release
  (`v0.1.0`) has not yet been cut — that remains a separate, deliberate
  maintainer action.
- **Trae harness support** (feature 019) — the fifth real, CI-proven
  supported harness, and the second (after Codex CLI) requiring a
  genuinely new installer branch. Verified via Trae's official Skills
  documentation, community documentation, and authoritatively via
  Vercel's own `skills` CLI source (`vercel-labs/skills`, hardcoding
  `skillsDir: '.trae/skills'` for the `trae` target) that Trae discovers
  skills from a project-local `.trae/skills/<name>/SKILL.md` convention,
  distinct from its `.trae/rules/` Rules mechanism. A contradictory
  GitHub bug report (Trae-AI/TRAE#2253) was investigated and traced to a
  path mismatch in the report's own reproduction steps, not a real gap
  in this convention — documented rather than silently discarded. New
  `--harness trae` branch in `scripts/install.sh`/`.ps1`, plus a new
  `install-test-trae`/`install-test-trae-windows-native` CI job pair
  mirroring the existing `install-test-codex-cli` pattern.
- **Warp harness support** (feature 018) — the fourth real, CI-proven
  supported harness, and the second requiring zero new installer code.
  Verified via Warp's own official Skills documentation
  (docs.warp.dev/agent-platform/capabilities/skills/) that Agent Mode
  scans ten directory names including `.claude/skills/` and
  `.agents/skills/` directly — a separate capability from Warp's
  `AGENTS.md`/`WARP.md` Rules mechanism, which an initial (incomplete)
  research pass had mistakenly treated as Warp's only convention. New
  `warp-compatibility` CI job asserts both existing install paths
  against Warp's specific documented rules. `scripts/install.sh`/`.ps1`
  unchanged.
- **OpenCode harness support** (feature 017) — the third real, CI-proven
  supported harness, and the first requiring **zero new installer code**:
  verified via OpenCode's own official docs that it natively scans both
  `.claude/skills/` and `.agents/skills/`, the exact paths the existing
  `claude-code`/`codex-cli` install paths already write to, with an
  identical `SKILL.md` frontmatter format. A direct audit confirmed all
  23 `specjedi-*` skill names already satisfy OpenCode's exact naming
  rule. New `opencode-compatibility` CI job asserts both existing install
  paths against OpenCode's specific documented rules (not just reused
  generic checks). README updated; `scripts/install.sh`/`.ps1` are
  unchanged (confirmed via `git diff`).

### Fixed

- Constitution `TODO(SESSION_START_HOOK)` was still listed as open even
  though feature 015 actually shipped and merged the mechanism it
  tracked — a `/speckit-constitution` audit caught the stale bookkeeping
  and closed it (v1.20.1, PATCH). The one genuinely separate open item
  (a live session confirming the greeting renders end to end) stays
  tracked in `references/principle-traceability.md`, not as a
  constitution-level TODO.
- All 10 localized `docs/i18n/<lang>/README.md` files had drifted after
  feature 016's README edit (Codex CLI's intro paragraph + table row) —
  translated and resynced.

### Added

- **Codex CLI (OpenAI) install path** (feature 016) — `scripts/install.sh`/
  `.ps1 --harness codex-cli` now installs all 23 `specjedi-*` skills to
  `.agents/skills/`, the second real, CI-proven harness beyond Claude
  Code. Verified via Codex CLI's own official docs that its `SKILL.md`
  frontmatter requirement (`name`, `description`) already matches this
  project's own skills unmodified — a direct grep audit confirmed zero
  skills hardcode Claude-Code-specific content, so no content rewrite
  was needed, only a new install-target branch. New
  `install-test-codex-cli`/`-windows-native` CI jobs mirror the existing
  `install-test` job pattern exactly. README's compatibility table
  updated; verification is honestly scoped as structural (file
  placement, frontmatter validity), not an actual Codex CLI run.
- `scripts/session-start.sh`/`.ps1` (feature 015) — implements Principle
  XXI's `SessionStart` hook: an ASCII Spec Jedi banner, a project status
  summary derived from `specjedi-status`'s own on-disk logic, and a
  context-aware rotating Master Yoda greeting line, registered in
  `.claude/settings.json` and paired with the required `CLAUDE.md` render
  instruction. Real dry runs caught and fixed two genuine bugs before
  shipping: a `grep -c`/`|| echo 0` double-counting bug, and a Yoda-line
  selector that could pick the "empty project" line for a 15-feature
  project (now filtered by actual on-disk state) — plus a word-wrapped
  quote extraction bug in the PowerShell/bash line-parsing logic. The one
  remaining unverified item is a live, real Claude Code session actually
  rendering the greeting end to end — not observable from within the same
  session that built it.
- Constitution Principle XXI (Session-Start Orientation & the Master
  Yoda Greeting, v1.20.0, MINOR): policy for a three-part session-start
  orientation (ASCII Spec Jedi banner, `specjedi-status`-derived project
  summary, rotating Master Yoda greeting line). Precisely documents the
  real Claude Code `SessionStart` hook mechanism (stdout becomes
  `additionalContext`, not a direct terminal print — verified against
  official docs before writing) and requires both a hook and a
  `CLAUDE.md` render instruction, not a hook alone. Explicitly defers
  the actual build to a Principle II-gated feature cycle, tracked as
  `TODO(SESSION_START_HOOK)` / feature 015 — not built ad hoc under this
  amendment.
- `references/star-wars-lexicon.md` gained a dedicated Master Yoda
  Persona section: speech patterns (inverted object-subject-verb
  construction, terse aphorisms) and a starter rotation pool of lines,
  scoped narrowly to the session-start greeting rather than general
  end-user dialogue.

### Changed

- Constitution Principle XVI renamed "Mermaid-First Process Documentation"
  → "Efficient Documentation & Mermaid Diagram Literacy" (v1.19.0, MINOR):
  every `specjedi-*` skill must now actively evaluate the most efficient
  documentation format (prose/table/list/diagram) rather than defaulting
  to a diagram out of habit, and any diagram-producing skill must know
  Mermaid's full current diagram-type catalog, not just flowchart/
  sequence/ER. New canonical reference
  `references/mermaid-diagram-catalog.md` (30 diagram types, grounded in
  two independently cross-checked fetches of mermaid.js.org's syntax
  reference). `specjedi-diagram` (feature 004) updated in the same PR:
  active type-inference broadened from 3 to 12 Core-tier types, and it
  now names Specialized-tier types explicitly instead of always falling
  back to `specjedi-find-skills`.

### Fixed

- `references/principle-traceability.md` had gone stale: five rows
  (Principles I, VI, XVII, XX, and the Distribution & Ecosystem Standards
  cross-cutting row) still cited CHK002/007/011/015/018 as open gaps,
  even though PR #58 had already resolved all five — that PR never
  updated this file despite its own Maintenance instruction to do so.
  Found via a `/speckit-constitution` compliance audit; corrected all
  five rows, and strengthened the Maintenance note to name this exact
  failure mode. Only Principle III remains genuinely 🟡 Partial (19 of 20
  harnesses still lack a built, tested install path).
- Localized `docs/i18n/<lang>/README.md` files (all 10 languages) had
  fallen one commit behind English after feature 014's README edit — the
  drift-check correctly flagged it (non-blocking WARN). Translated the
  two new sentences into all 10 languages and updated each file's
  `i18n-sync` marker to the current source commit.

### Added

- `references/competitive-comparison.md` — an 11-row table comparing Spec
  Jedi to spec-kit and the ten other researched SDD/agent-skill tools,
  reusing `specs/001-specjedi-pipeline/research.md`'s existing citations
  rather than performing new competitor research; linked from `README.md`
  (feature 014, shipped via the literal `speckit-specify` →
  `speckit-plan` → `speckit-tasks` → `speckit-implement` pipeline).
- `references/harness-capability-notes.md` — desk-research capability
  matrix for all 19 non-Claude-Code harnesses in Principle III's
  compatibility table (mechanism, cited source, Yes/Unclear call per
  harness); flags that Gemini CLI is being sunset in favor of Antigravity
  CLI (2026-06-18). Closes `checklists/project-completeness.md` CHK002.
- `references/genuine-contributions-log.md` — durable index of every
  shipped feature's Principle II "genuine contribution" claim, linking
  back to each `research.md`, with a maintenance rule for future
  features. Closes `checklists/project-completeness.md` CHK013.
- `.github/workflows/validate.yml` gained `tokencheck-detection`
  (ubuntu/macos/windows matrix) and `tokencheck-detection-windows-native`
  jobs, both required by `ci-gate`, proving `specjedi-tokencheck`'s
  `which`/`where` present/absent detection logic for real on every OS
  Principle XIII requires. Closes `checklists/project-completeness.md`
  CHK016.
- Localized documentation (`docs/i18n/<lang>/README.md` and
  `CONTRIBUTING.md`) in ten languages — Mandarin Chinese, Hindi, Spanish,
  French, Arabic, Bengali, Portuguese (Brazilian), Russian, Urdu, and
  Indonesian — AI-assisted translations, English canonical.
  `scripts/validate.sh`/`.ps1` gained an automated, non-blocking
  sync-drift check flagging any localized doc whose recorded source
  commit has fallen behind the English file's actual latest commit.
  Closes `TODO(LOCALIZATION)` (open since constitution v1.15.14) and
  `checklists/project-completeness.md` CHK003/CHK006 — Principle I
  amended to name the ten languages concretely instead of a re-derivable
  "ten most-spoken" (v1.17.0 shipped the first six; v1.18.0 extended to
  the full ten on explicit maintainer direction).
- `scripts/validate.sh`/`.ps1` — automated, non-blocking Principle IX
  validation-battery-growth-trigger check: warns the moment the repo
  gains a test-pattern file, a language runtime manifest, or a web UI
  marker not yet covered by a matching CI job. Closes
  `checklists/project-completeness.md` CHK004.
- `specjedi-govcheck` ⚖️ — strictly read-only per-PR/per-branch governance
  compliance checklist against all 20 constitution principles plus the
  Distribution & Ecosystem Standards and Development Workflow sections —
  three-state report (N/A / Compliant / Non-Compliant), any conflict
  CRITICAL. Self-invoked by `specjedi-implement` before opening a PR
  (never blocks it); also runs standalone (feature 013).
- `.specify/memory/skill-gaps.md` — first entries logged by
  `specjedi-find-skills`, surveying candidate domains this project's own
  skill set doesn't cover well (localization/i18n workflow, CI/CD
  authoring depth, accessibility depth, security-review depth).
- `references/principle-traceability.md` — canonical index mapping every
  constitution principle to its implementing skill/script/CI mechanism or
  explicit tracked gap; closes `checklists/project-completeness.md`
  CHK001.
- `checklists/project-completeness.md` — a project-wide requirements-
  completeness audit (19 items) run via `/speckit-checklist` against the
  constitution itself rather than a single feature.
- `specjedi-tokencheck` 🎒 — mechanizes Principle VIII: proactively checks
  whether `rtk` and `graphify` are installed, explains what's missing and
  its expected token savings, and offers an install walkthrough; never
  installs anything without explicit confirmation. Self-invoked by
  `specjedi-onboard`'s first-run flow, also runs standalone (feature 012).
- `specjedi-skill-review` 🎓 — strictly read-only audit of an existing
  `specjedi-*` skill's `SKILL.md` against the Skill Authoring & Prompt
  Engineering Standard, distinguishing missing from weak sections and
  cross-referencing the matching `plan.md` for legitimate exemptions;
  never edits the reviewed file (feature 011).
- `specjedi-release` 🚀 — wraps `scripts/suggest-release.sh`/`.ps1` with
  Spec Jedi's own voice, narrating the last tag, suggested next version,
  and contributing commits; declines and names the manual command if
  asked to actually cut a release (feature 010).
- `specjedi-new-skill` 🌟 — scaffolds a new `specjedi-*` skill's file
  structure, placeholders only, following this project's own Skill
  Authoring Standard (feature 009).
- `specjedi-docs` 📚 — drafts a README skill-table row, Quickstart step,
  and this changelog's own entries from a shipped feature's spec/plan,
  grounded in actual content, always confirmed before writing
  (feature 008).
- `specjedi-security` 🛡️ — lightweight, proactive "did we think about X"
  prompt for auth/input validation/secrets/data-privacy gaps, self-invoked
  by `specjedi-plan`; never claims to be a full security review
  (feature 007).
- `specjedi-retro` 🪞 — strictly read-only retrospective comparing a
  completed feature's actual implementation against its `plan.md`,
  grounding any deviation's cause in real git history, logging a durable
  entry to `.specify/memory/retro-log.md` (feature 006).
- `specjedi-status` 🧭 — project-wide dashboard deriving every feature's
  status entirely from on-disk `spec.md`/`plan.md`/`tasks.md` artifacts,
  zero separately-maintained tracking system (feature 005).
- `specjedi-diagram` 📊 — generates a render-verified Mermaid diagram
  (flowchart, sequence, or ER) from an existing spec/plan, always a
  supplement to the source prose (feature 004).
- `specjedi-migrate` 🔄 — rewrites literal `/speckit-*` tooling references
  to their `specjedi-*` equivalents, never touching principle or
  requirement content (feature 003).
- `specjedi-onboard` 🌱 — first-run walkthrough producing a real first
  `constitution.md` and `spec.md` together, teaching each SDD concept
  exactly when it's needed (feature 002).
- Zero-footprint installer (`scripts/install.sh`/`.ps1`) — copies only the
  `specjedi-*` product skills into a target project, with harness
  selection and post-install validation.
- `CONTRIBUTING.md` and GitHub issue/PR templates walking contributors
  through the research and validation requirements before review.
- The full 9-stage `specjedi-*` SDD pipeline (`specjedi-constitution`
  through `specjedi-converge`) — constitution, specify, clarify, plan,
  tasks, implement, analyze, checklist, converge (feature 001).

### Changed

- `checklists/project-completeness.md` — all 19 items now resolved.
  CHK011 (retroactive badge-row review gap) and CHK015 (Principle XX
  retrospective-audit gap) closed by construction/reasoning rather than
  new infrastructure: `specjedi-govcheck`'s mandatory per-PR self-invoke
  already makes the former structural going forward, and git's own
  append-only history already is the latter's audit trail.
- Constitution Principle III clarified: the compatibility-matrix
  re-verification trigger now explicitly names Principle XI's MAJOR
  product release line, not the constitution's own version number.
- Constitution Development Workflow section corrected: localization
  (Principle I) runs on its own whole-project cadence, not as a
  per-feature pipeline step — matching what actually happened.
- All 12 pre-existing feature plans (`specs/001-*` through `specs/012-*`)
  updated to explicitly cite their Principle VI test-first exemption,
  matching the precedent feature 013 already set.
- README badge row corrected: `Roadmap` badge updated from stale
  `7/7 shipped` to accurate `11/11 shipped`; new `Skills` badge added
  (`22 shipped`) — found by `checklists/project-completeness.md`.
- README's Installation section corrected from a stale "12 `specjedi-*`
  product skills" count to the accurate 22.
- README's "Supported harnesses" table expanded from ~8 named tools
  collapsed into one "and others" row to all 20 harnesses named
  individually, per Principle III's "at least twenty" mandate — status
  only, no fabricated capability claims.
- `specjedi-explain` and `specjedi-find-skills` brought into full
  compliance with the Skill Authoring Standard (`specjedi-explain` was
  missing its `Format` and `` `--auto` mode `` sections; `specjedi-
  find-skills` was missing its `` `--auto` mode `` section) — found by
  `specjedi-skill-review`'s own first real dry run.
- All 12 shipped pipeline/roadmap skills brought into compliance with
  Principle XIV's bulleted next-step format, Principle XX's chain-of-thought
  and token-economy requirements, and Principle XII's Star Wars voice
  (previously documented but unimplemented in skill output).
- Every shipped skill now states its `Autonomous vs. confirm-first`
  boundary explicitly, per Principle XIX.

## Extending this file

New entries land under `## Unreleased` as features ship, drafted by
`specjedi-docs` and confirmed before writing — never a version number
here directly; that's `scripts/suggest-release.sh`'s call to make.

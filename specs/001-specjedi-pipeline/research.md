# Research: The `specjedi-*` SDD Pipeline

**Feature**: 001-specjedi-pipeline
**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no new skill ships without
benchmarking against spec-kit plus at least ten other publicly available SDD
tools, with an explicit adopt/adapt/reject decision per mechanism, **and** at
least one genuine contribution beyond what any researched competitor offers
(added to Principle II in v1.11.0 — retrofitted here since this doc predates
that amendment).

## Genuine contributions beyond the researched field

Not present, as a formalized mechanism, in spec-kit or any of the ten other
tools researched below:

1. **Constitution-enforced auto-merge CI governance.** Every one of the ten
   competitors treats "constitution"/"rules" as a document agents *read*.
   None of them tie it to an actual CI gate that blocks merge until every
   platform's validation battery passes, with self-approval structurally
   impossible (GitHub itself blocks it) rather than merely discouraged. This
   repository's own `ci-gate` + branch protection setup (Principles IX, X)
   is a working implementation, not a proposal.
2. **A proactive, cross-skill gap-scout contract.** The seed skill
   (`find-skills`) and every competitor's equivalent are reactive only — a
   human has to ask. Principle XVII requires every `specjedi-*` skill to
   self-invoke the gap-check mid-task, unprompted. No researched tool
   formalizes "skills watch each other's blind spots" as a standing
   contract.
3. **AI Discipline as a versioned constitutional principle, not implicit
   practice.** Every tool researched *implies* good prompting, efficient
   token use, and factual grounding through example quality. None of them
   *codify* it as an enforceable, versioned principle with a checklist
   (Principle XX) that every new skill is reviewed against before shipping.
4. **A documented, extensible voice/identity layer.** Purely a
   differentiation choice, not a technical one — no competitor ships a
   maintained reference lexicon (`references/star-wars-lexicon.md`) mapping
   product situations to a consistent voice and icon language. Cosmetic, but
   genuinely unique positioning in a field of similarly-toned developer
   tools.

These are what Principle II's "genuine addition" requirement (v1.11.0) points
to for this feature; future `specjedi-*` skills (P3-P9) must each identify
their own before shipping, not inherit this list by default.

## Baseline: GitHub spec-kit

Already deeply known — it's vendored in this repo (`.claude/skills/speckit-*/SKILL.md`,
`.specify/`). ~93K GitHub stars by mid-2026, supports 30+ coding agents.

- **Workflow**: `constitution → specify → clarify → plan → tasks → implement`, plus
  `analyze` (cross-artifact consistency) and `checklist`/`converge`/`taskstoissues` as
  auxiliary commands.
- **Strengths**: constitution-as-source-of-truth pattern (every artifact checked
  against it), clean phase separation, script-backed automation
  (`.specify/scripts/bash/*.sh`) rather than pure prompting, broad agent support via
  per-integration adapters.
- **Weaknesses**: rigid phase gates (hard to skip ceremony for a trivial change),
  no built-in guided "what's next" prompting (Principle XIV exists specifically
  because spec-kit doesn't do this), no persona/tone layer, no proactive
  skill-gap detection, and — the gap this whole feature exists to close —
  `speckit-*` commands aren't branded/ownable as a distinct product.
- **Decision**: adopt the phase structure and constitution-as-source-of-truth
  pattern wholesale (proven, and this project already depends on it structurally).
  Reject the rigidity — Spec Jedi's version must support lighter-weight paths.

## Ten other SDD / agent-skill tools

### 1. BMAD-METHOD (MIT, ~46.7K stars, v6.6.0 as of Apr 2026)
Orchestrates 12+ specialized personas (Analyst, PM, Architect, Dev, QA...) across
the full lifecycle, producing heavy documentation (briefs, PRDs, architecture
docs, granular stories) before code. Has a "Quick Flow" (`bmad-quick-dev`) that
skips phases 1-3 for small, well-understood work — clarify/plan/implement/review
in one pass.
- **Good**: the Quick Flow escape hatch for trivial work; role-based personas
  produce genuinely thorough docs for complex greenfield work.
- **Poor**: heavy ceremony by default is a real cost for small changes; 12+
  personas is a lot of surface area to keep consistent.
- **Decision**: **adopt** the "quick path for small work" idea — `specjedi-*`
  should support a lightweight mode, not force full ceremony on every change.
  **Reject** the multi-persona orchestration — one clear skill per pipeline stage
  (matching spec-kit's shape) is simpler to build, validate (Principle IX), and
  explain than 12 simulated team members.

### 2. OpenSpec
Lightweight, brownfield-focused change management. 3 AI commands (vs. spec-kit's
~9-10), "fluid not rigid" philosophy — any artifact can be updated anytime, no
rigid phase gates, Plan Mode asks clarifying questions before acting.
- **Good**: radically fewer commands, no phase-gate rigidity, plain Markdown with
  minimal overhead.
- **Poor**: less structure means less guarantee that ambiguity actually gets
  surfaced before planning — spec-kit's separate `clarify` step exists for a
  reason (Principle V's completeness-for-autonomous-execution mandate depends on
  ambiguity being caught, not just optionally addressed).
- **Decision**: **reject** collapsing clarify into plan — keep clarify a distinct,
  mandatory-when-triggered step (already Principle V). **Adopt** the instinct
  that not every artifact needs a rigid, one-way phase gate — allow specs to be
  amended later without re-running the whole pipeline from scratch.

### 3. Kiro (AWS, GA since Nov 2025)
A full agentic IDE, not a toolkit layered on an existing editor. Auto-generates
requirements, design docs, and task lists from a single feature kickoff; agents
are integrated into the IDE itself.
- **Good**: zero-setup spec generation from one interaction; tight IDE
  integration reduces context-switching.
- **Poor**: it's a whole IDE, not a portable skill set — the opposite of
  Principle III's universal-harness-compatibility commitment. Not something
  Spec Jedi can or should emulate structurally.
- **Decision**: **reject** the IDE-lock-in model outright — it's incompatible
  with this project's core bet. **Adopt** the UX lesson: minimize the number of
  explicit user actions needed to go from idea to first artifact.

### 4. Tessl (spec-as-source platform, $125M raised, public Framework + Registry)
Installs as "tiles" into a project's `.tessl/` directory; teaches any
MCP-compatible agent a spec-driven workflow. Spec is treated as the actual
source of truth, code as a build artifact.
- **Good**: registry model for sharing/reusing spec patterns across projects;
  MCP-based, so it's less tied to one vendor's agent than Kiro.
- **Poor**: "spec is the only source of truth, code is disposable" is a stronger
  claim than this project needs to make — Spec Jedi's specs guide implementation,
  they don't replace reading the code.
- **Decision**: **adopt** the idea of a shared, cross-project registry of
  reusable patterns loosely — this is conceptually close to what
  `specjedi-find-skills`' skills.sh integration already does. **Reject** the
  "spec over code" philosophy as too strong a claim for this project's stance.

### 5. Spec Kitty
Smaller/newer entrant tracked in comparative research (`cameronsjo/spec-compare`)
alongside spec-kit, BMad, OpenSpec, Kiro, and Tessl; distinguishing feature is
git-worktree-based parallel spec development.
- **Good**: worktree isolation for parallel feature specs is a genuinely useful
  pattern for teams running several specs at once.
- **Poor**: not enough independent adoption signal yet to treat its other design
  choices as proven.
- **Decision**: **adopt** worktree-awareness as a *documented option*, not a
  requirement — note in future `specjedi-plan`/`specjedi-tasks` guidance that
  parallel independent features can use worktrees, without making it mandatory
  machinery this project has to build and maintain.

### 6. Superpowers (MIT skills framework — installed locally in this environment)
A skill collection (`brainstorming`, `writing-plans`, `executing-plans`,
`systematic-debugging`, `test-driven-development`, `using-git-worktrees`,
`verification-before-completion`, `requesting-/receiving-code-review`,
`subagent-driven-development`) with an explicit meta-rule: "if a skill applies,
you don't have a choice — use it," enforced via a `using-superpowers` entry
skill every session should consult first.
- **Good**: the "brainstorm before you plan" separation (a distinct step before
  even the spec exists) is a real gap in spec-kit's flow, which jumps straight
  from idea to `specify`. The mandatory-invocation framing is a strong pattern
  for making sure guidance actually gets used, not just documented.
- **Poor**: the meta-rule is a lot of instructional overhead per session just to
  establish "check for a relevant skill first."
- **Decision**: **adopt** the brainstorm-before-spec idea loosely — a future
  `specjedi-specify` should explicitly welcome an unstructured idea and help
  shape it, not require a pre-formed feature description. **Reject** a separate
  mandatory meta-skill layer — Principle XIV (guided next-step suggestion)
  already covers "tell the user/agent what to do next" without needing a second
  enforcement mechanism on top.

### 7. GSD (meta-prompting SDD system — installed locally in this environment)
Wave-based context management; workflow uses `.planning/PROJECT.md`,
`.planning/config.json`, `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`
rather than spec-kit's `specs/NNN-feature/` convention. Built-in `--auto` flag
for unattended runs after initial config questions, and an explicit
`<runtime_note>` pattern mapping harness-specific tool calls (e.g.
`AskUserQuestion` → `vscode_askquestions` on Copilot) so the same skill file
works across harnesses without forking it.
- **Good**: the `--auto` flag is a clean, explicit way to say "ask what you must
  up front, then don't stop me" — directly relevant to this session's own
  "leave decisions needing your help for the end" instruction. The
  cross-harness `<runtime_note>` pattern is a concrete, working answer to
  Principle III's compatibility-matrix commitment that spec-kit itself doesn't
  have.
- **Poor**: a parallel `.planning/` directory convention alongside spec-kit's
  `specs/` is extra surface area if both patterns coexist in one project.
- **Decision**: **adopt** the `--auto`-flag concept and the `<runtime_note>`
  cross-harness mapping pattern — both are concrete, low-cost wins worth
  building into `specjedi-*` skills directly. **Reject** introducing a second,
  parallel directory convention — `specjedi-*` skills MUST keep using
  `specs/NNN-feature/` so they interoperate with the existing spec-kit-derived
  scaffolding already in this repo instead of forking it.

### 8. PRP — Product Requirement Prompts (PRPs-agentic-eng, installed locally
in this environment as `prp-plan`/`prp-implement`/etc.)
Core philosophy: "a great plan contains everything needed to implement without
asking further questions... if you would need to search the codebase during
implementation, capture that knowledge now in the plan." Plan phase explicitly
detects input type (raw feature description vs. an existing PRD file) and
branches accordingly.
- **Good**: the "golden rule" (front-load codebase-pattern research into the
  plan so implementation never has to stop and search) is a genuinely strong,
  quotable design principle. Input-type detection avoids forcing a single rigid
  entry format.
- **Poor**: front-loading everything into one plan document can make that
  document very large for bigger features — spec-kit's separate
  `research.md`/`data-model.md`/`plan.md` split spreads that load out.
- **Decision**: **adopt** the golden rule explicitly for `specjedi-plan`: any
  codebase pattern/convention the implementer would otherwise need to search for
  mid-task gets captured in the plan up front. **Reject** collapsing everything
  into a single monolithic plan file — keep spec-kit's file-per-concern split,
  just apply PRP's completeness bar to each file.

### 9. Traycer (commercial, VS Code)
Commercial planning layer for VS Code; plan-then-execute model similar in spirit
to Plan Mode tools generally.
- **Good**: validates that a distinct "plan reviewed before code moves" step is
  considered valuable enough to build a commercial product around.
- **Poor**: closed-source, single-editor, not something this MIT project can
  inspect or adapt code from — evaluated at the philosophy level only.
- **Decision**: **reject** as a source of implementation detail (nothing to
  adopt directly, closed source). Confirms the plan-before-code step
  (`specjedi-plan`) is worth keeping as its own gate, which spec-kit already does.

### 10. codemyspec.com's SDD guide/tooling
A 2026 guide-and-tooling site cataloguing SDD practice; useful as a secondary
signal on what the broader practitioner community considers table-stakes for an
SDD tool (constitution/rules file, spec, plan, task breakdown, review gate) —
converges with what spec-kit already does structurally.
- **Decision**: no unique mechanism to adopt/reject; used as a **cross-check**
  that spec-kit's phase set (constitution → spec → plan → tasks → implement) is
  the accepted baseline shape, not an idiosyncratic choice — so keeping
  `specjedi-*` mirrored 1:1 with `speckit-*` command names (Principle XV) is
  aligned with, not diverging from, general practice.

## Summary of decisions carried into the spec/plan

1. Keep the phase structure and constitution-as-source-of-truth pattern
   (spec-kit) — proven, and this repo already depends on it.
2. Support a **lightweight/quick path** for small changes (BMAD's Quick Flow,
   OpenSpec's low-ceremony philosophy) alongside the full pipeline — not
   full-ceremony-only.
3. Keep `clarify` as its own mandatory-when-triggered step — do not collapse it
   into `plan` (rejecting OpenSpec's collapse, keeping Principle V intact).
4. Do not chase IDE-lock-in (Kiro) or spec-replaces-code (Tessl) — out of scope
   for this project's stance and Principle III's portability commitment.
5. Document worktree-parallelism as optional guidance (Spec Kitty), not
   required machinery.
6. Loosely welcome unstructured ideas into `specjedi-specify` (Superpowers'
   brainstorm-before-spec instinct) without adding a second mandatory
   meta-enforcement layer (Principle XIV already covers guided next steps).
7. Build an explicit `--auto`-style flag and per-harness `<runtime_note>`
   mapping into `specjedi-*` skills (GSD) — concrete, adoptable wins.
8. Keep using `specs/NNN-feature/` (not a parallel `.planning/` convention).
9. Apply PRP's "golden rule" (front-load codebase patterns so implementation
   never has to stop and search) to `specjedi-plan` specifically, while keeping
   spec-kit's multi-file split rather than one monolithic plan doc.
10. Traycer and codemyspec.com confirm rather than change the baseline shape.

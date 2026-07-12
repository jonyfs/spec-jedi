# Competitive Comparison: Spec Jedi vs. the Researched SDD Field

How Spec Jedi (`specjedi-*`) compares to the eleven Spec-Driven Development
(SDD) / agent-skill tools researched under Constitution
[Principle II](../.specify/memory/constitution.md) before this project's
core pipeline was built. Every claim below traces to
[`specs/001-specjedi-pipeline/research.md`](../specs/001-specjedi-pipeline/research.md)
— nothing here is a new, independently-researched comparison; this document
reorganizes and tabulates that existing, cited source (see
[`specs/014-competitive-comparison/research.md`](../specs/014-competitive-comparison/research.md)
for why re-researching wasn't the right move). Closes
`specs/014-competitive-comparison/spec.md`'s FR-001 through FR-005.

## How to read this table

Each row names what Spec Jedi **adopted** from that tool (a real, working
mechanism it kept), what it explicitly **rejected** (and the recorded
reason), and whether the underlying tool's own claims are independently
**verifiable** (public/open vs. closed-source or thin evidence). A
"rejected" row isn't a knock on the tool — several rejections are scope
decisions (e.g., Kiro's IDE-lock-in model is a legitimate design choice for
Kiro, just incompatible with Principle III's portability commitment here).

| Tool | Category | What Spec Jedi Adopted | What Spec Jedi Rejected (and why) | Verifiability |
|---|---|---|---|---|
| **spec-kit** (baseline) | Vendored SDD toolkit this project bootstraps itself with (`speckit-*`) | Phase structure (constitution → specify → clarify → plan → tasks → implement → analyze/checklist/converge) and the constitution-as-source-of-truth pattern — proven, and this repo already depends on it structurally | Rigid phase gates with no lightweight path; no guided next-step prompting (Principle XIV exists specifically because spec-kit doesn't do this); no persona/tone layer; no proactive skill-gap detection; not brandable as a distinct product | Public, ~93K GitHub stars, vendored directly in this repo |
| **BMAD-METHOD** | Multi-persona orchestrated SDD (12+ simulated roles) | The "Quick Flow" lightweight-path idea — a way to skip phases 1-3 for small, well-understood work | The 12+-persona orchestration model — one clear skill per pipeline stage is simpler to build, validate (Principle IX), and explain | Public, MIT, ~46.7K stars, v6.6.0 (Apr 2026) |
| **OpenSpec** | Lightweight, brownfield-focused change management (3 AI commands) | The instinct that not every artifact needs a rigid, one-way phase gate — specs can be amended later without re-running the whole pipeline | Collapsing `clarify` into `plan` — kept `clarify` a distinct, mandatory-when-triggered step (Principle V's completeness mandate depends on ambiguity being caught, not optionally addressed) | Public |
| **Kiro** | Full agentic IDE (AWS, GA since Nov 2025) | The UX lesson: minimize explicit user actions needed to go from idea to first artifact | The IDE-lock-in model outright — a whole IDE isn't a portable skill set, the opposite of Principle III's universal-harness-compatibility commitment | Public, AWS-backed |
| **Tessl** | Spec-as-source platform ($125M raised, public Framework + Registry) | Loosely, the idea of a shared, cross-project registry of reusable patterns — conceptually close to what `specjedi-find-skills`' skills.sh integration already does | The "spec is the only source of truth, code is disposable" philosophy — too strong a claim for this project's stance (specs guide implementation here, they don't replace reading the code) | Public, well-funded |
| **Spec Kitty** | Smaller/newer entrant; git-worktree-based parallel spec development | Worktree-awareness as a *documented option* for parallel independent features — not required machinery | No other design choices adopted — not enough independent adoption signal yet to treat them as proven | Newer entrant, tracked via `cameronsjo/spec-compare`; less independent adoption signal than the others |
| **Superpowers** | MIT skill collection with a mandatory-invocation meta-rule ("if a skill applies, you don't have a choice") | Loosely, the "brainstorm before spec" instinct — a future `specjedi-specify` should welcome an unstructured idea, not require a pre-formed feature description | A separate mandatory meta-skill enforcement layer — Principle XIV (guided next-step suggestion) already covers "tell the user/agent what's next" without a second enforcement mechanism on top | Public, MIT — installed locally and inspected firsthand in this environment |
| **GSD** | Meta-prompting SDD system; wave-based context management | The `--auto` flag concept (ask what's needed up front, then don't stop) and the cross-harness `<runtime_note>` mapping pattern — both built directly into `specjedi-*` skills | A second, parallel `.planning/` directory convention — `specjedi-*` skills keep using `specs/NNN-feature/` to interoperate with the existing spec-kit-derived scaffolding instead of forking it | Installed locally and inspected firsthand in this environment |
| **PRP** (Product Requirement Prompts) | Plan-completeness philosophy ("a great plan contains everything needed to implement without asking further questions") | The "golden rule" — front-load codebase-pattern research into the plan so implementation never has to stop and search — applied explicitly to `specjedi-plan` | Collapsing everything into one monolithic plan document — kept spec-kit's `research.md`/`data-model.md`/`plan.md` file-per-concern split, just applying PRP's completeness bar to each file | Installed locally and inspected firsthand in this environment |
| **Traycer** | Commercial plan-then-execute layer for VS Code | Confirms the "plan reviewed before code moves" step is valuable enough to build a commercial product around — validates keeping `specjedi-plan` as its own gate | Nothing adopted as implementation detail — closed source, nothing to inspect or adapt code from | **Not verifiable** — closed-source, commercial; evaluated at the philosophy level only |
| **codemyspec.com** | 2026 SDD practice guide/cataloguing site (secondary signal, not a tool with its own mechanism) | Used only as a **cross-check** that spec-kit's phase set (constitution → spec → plan → tasks → implement) is the accepted field baseline, not an idiosyncratic choice | No unique mechanism to adopt or reject | Public guide site; secondary/cross-check signal only, not evaluated as a standalone tool |

## Genuine contributions

Beyond what any of the eleven rows above offers, `research.md` records four
capabilities this project contributes back to the field rather than only
absorbing from it (full detail in
[`specs/001-specjedi-pipeline/research.md`](../specs/001-specjedi-pipeline/research.md#genuine-contributions-beyond-the-researched-field)
and per-feature entries in
[`references/genuine-contributions-log.md`](genuine-contributions-log.md)):

1. **Constitution-enforced auto-merge CI governance** — every competitor
   treats its rules document as something agents *read*; none tie it to an
   actual CI gate that structurally blocks self-approval.
2. **A proactive, cross-skill gap-scout contract** (Principle XVII) — every
   competitor's skill-discovery is reactive only; Spec Jedi requires skills
   to self-invoke a gap-check mid-task, unprompted.
3. **AI Discipline as a versioned constitutional principle** (Principle XX)
   — every tool implies good prompting and grounding through example
   quality; none codify it as an enforceable, versioned, checklist-backed
   principle.
4. **A documented, extensible voice/identity layer**
   (`references/star-wars-lexicon.md`) — a differentiation choice no
   competitor makes.

## Maintenance

Update this document when either of two things happens: (1) a future
feature's `research.md` adds a competitor beyond the eleven above — add its
row in the same PR that ships that `research.md`, mirroring
`references/genuine-contributions-log.md`'s existing maintenance pattern;
or (2) a shipped Spec Jedi feature closes a gap this document currently
lists as a rejection or a competitor-only strength — update that row's
"Rejected" cell to reflect the new reality rather than leaving it stale.
This document is not a one-time snapshot; treat drift here the same as any
other fact-bearing artifact this project has already caught and fixed
(stale badges, stale skill counts).

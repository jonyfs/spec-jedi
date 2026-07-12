# Research: Session-Start Orientation Hook

**Feature**: 015-session-start-hook

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — every new
skill, workflow, or structural pattern MUST be benchmarked against spec-kit plus
at least ten other SDD tools, with an explicit adopt/adapt/reject decision, and
MUST name at least one genuine capability no researched competitor has.

## Question: does any researched tool already do a session-start status/greeting hook?

### spec-kit (baseline)

No. Vendored directly in this repo (`.claude/skills/speckit-*`) — its commands
are user-invoked slash commands, not a `SessionStart` hook. No greeting,
status summary, or branding on session open.

### BMAD-METHOD (official `bmad-code-org/BMAD-METHOD`, ~46.7K stars)

**Partial precedent, real but narrower than what this feature builds.**
Verified directly against `docs.bmad-method.org`: BMAD's own agent/workflow
system has a documented **activation sequence** — `activation_steps_prepend`
→ load `persistent_facts` → resolve config → **"Greet the user"** →
`activation_steps_append`. This is a real, cited BMAD mechanism, not
invented — but it fires when a specific BMAD *agent/workflow* activates
inside a chat turn, not as a Claude Code `SessionStart` hook tied to the
harness session itself, and the docs don't describe it including a derived
project-status summary or ASCII branding.

A `bmad-session-start.sh` **does** exist and **is** registered as a real
Claude Code `SessionStart` hook — but verified via `gh search code` and a
direct repo-contents check: it belongs to a third-party repository,
`ThinhTP204/ba-skills-harness`, not the official `bmad-code-org/BMAD-METHOD`
project. A search for `SessionStart` inside the actual
`bmad-code-org/BMAD-METHOD` repository returns zero matches, and it has no
`.claude/settings.json` at its root. Reporting the third-party repo's hook
as "BMAD-METHOD's own feature" would have been a real grounding error —
caught and corrected before writing this line, per Principle XX.

- **Decision**: **adopt** the "greet, then load context" activation-order
  discipline as a useful sequencing idea (greeting before heavy work, not
  buried after it) — already reflected in this feature's FR-004 ordering.
  **Reject** modeling this as a per-agent-activation greeting — Principle
  XXI's mechanism is explicitly a harness-`SessionStart` hook, a genuinely
  different trigger BMAD's own official project doesn't use.

### OpenSpec

No session-start/greeting mechanism found. 3-command, low-ceremony tool;
nothing in its docs or supported-tools list describes a startup hook.

### Kiro (AWS)

Kiro's own "hooks" are a named, real feature — but they trigger on
**developer actions inside the IDE** (file save, commit), not on
harness/session start, and they automate follow-up dev tasks, not a
greeting or status summary. Different mechanism, different purpose; not a
precedent for this feature specifically.

### Tessl

No session-start/greeting mechanism found. Its current positioning
("package manager for agent skills and context," per its own site) is
about a versioned skill/spec registry, not a startup experience.

### Spec Kitty

No session-start/greeting mechanism found in its own docs or README.
Distinguishing feature remains git-worktree-based parallel spec
development (already noted in `specs/001-specjedi-pipeline/research.md`).

### Superpowers (installed locally in this environment)

**Checked firsthand** — no `SessionStart` hook registered anywhere under
this machine's `~/.claude/` skill/settings tree for Superpowers, and no
skill file mentions session-start behavior. Its actual mechanism
(`using-superpowers`) is a mandatory-first-read *skill*, invoked by
instruction at the top of every conversation via the harness's own system
prompt injection — a real but different mechanism (an instruction to check
for relevant skills, not a hook emitting a rendered greeting).

### GSD (installed locally in this environment)

**Checked firsthand** — no `SessionStart` hook registered for GSD either.
Its `.planning/PROJECT.md`/`.planning/ROADMAP.md` convention is read
on-demand by its own skills, not proactively surfaced at session start.

### PRP (installed locally in this environment)

No session-start/greeting mechanism — its `prp-plan`/`prp-implement`
commands are user-invoked, matching the "golden rule" front-loading
philosophy already adopted into `specjedi-plan` (feature 001), not a
startup hook.

### Traycer

No session-start/greeting mechanism found — a commercial plan-then-execute
layer for VS Code, evaluated at the philosophy level only (closed source),
consistent with `specs/001-specjedi-pipeline/research.md`'s original
assessment.

### codemyspec.com

Not a tool with its own mechanism (a practice-cataloguing site); no
session-start pattern to evaluate.

## Directly relevant engineering precedent (not a competitor, cited for mechanism accuracy)

This very environment already runs a real Claude Code `SessionStart` hook
(from an installed memory/session-continuity plugin, unrelated to any SDD
tool) that injects `additionalContext` at session start — confirmed by
inspecting `~/.claude/settings.json`'s own `hooks.SessionStart` entry
directly. This is useful, already-verified proof that the
hook-emits-context / agent-renders-it mechanism genuinely works as
Constitution Principle XXI describes it, not a claim taken on faith. It is
not counted as one of the ten competitor tools — it's general Claude Code
infrastructure, not an SDD tool — but it grounds the technical feasibility
claim in something actually inspected this session.

## Genuine contribution

No researched SDD tool — official BMAD-METHOD included, once its actual
(not a third-party fork's) mechanism was checked — ties a harness-level
`SessionStart` hook to **all three** of: (1) a project-status summary
derived from the same source of truth an on-demand dashboard skill already
uses (no parallel tracking system), (2) branded, original ASCII identity
art, and (3) a rotating, persona-flavored greeting line, delivered
automatically on every session with no user action. BMAD's closest
analog is scoped to individual agent activation inside a conversation, not
the harness session itself, and doesn't combine all three elements. This
is the genuine addition Principle II requires — not a reskinned average of
the field, a combination no researched tool assembles.

## Summary of decisions carried into the plan

1. Model this feature as a genuine Claude Code `SessionStart` hook (not a
   per-agent-activation greeting like BMAD's) — the correct trigger for
   "every harness session," which is what Principle XXI actually asks for.
2. Reuse `specjedi-status`'s existing derivation logic for the status
   summary — no new tracking mechanism, consistent with this project's own
   "no internal redundancy" discipline.
3. Greet-before-heavy-work ordering (adopted loosely from BMAD's
   activation-sequence idea) — the banner/greeting content should be cheap
   to produce, not gated behind an expensive scan.
4. Ground the "hook stdout becomes context, not a terminal print" claim in
   this environment's own already-running memory-plugin `SessionStart`
   hook, not just Claude Code's documentation in the abstract.

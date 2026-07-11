# Research: `specjedi-skill-review`

**Feature**: 011-specjedi-skill-review

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md) — no
new skill ships without benchmarking against spec-kit plus at least ten other
publicly available SDD tools, with an explicit adopt/adapt/reject decision per
mechanism, and at least one genuine contribution beyond what any researched
competitor offers.

## Why this skill, why now

This project's own history has manually performed the same audit twice:
the original governance TODO passes (NEXT_STEP_PASS, GROUNDING_PASS,
VOICE_PASS, PROMPT_ENG_PASS — v1.15.2 through v1.15.5) each checked every
shipped skill against a specific Skill Authoring Standard requirement,
and the 6-skill consistency audit (PR #41, v1.15.13) repeated a
condensed version of the same four checks against the most recently
shipped skills. Both were done entirely by hand — reading each
`SKILL.md`, grepping for section presence, judging voice/chain-of-thought
quality. `specjedi-new-skill` (feature 009) automated the *scaffold-a-
new-skill* half of this project's own meta-tooling gap; this is the
*review-an-existing-skill* other half.

## Internal-redundancy check (established discipline since feature 007)

Checked against every shipped `specjedi-*` skill: `scripts/validate.sh`
already does *structural* lint (frontmatter presence, `name:`/
`description:` fields) — this skill does not duplicate that; it checks
the *content quality* dimensions structural lint cannot (persona clarity,
explicit chain-of-thought for judgment calls, genuine voice vs. decorative
emoji only, bulleted next-step format, autonomous/confirm-first section
presence). `specjedi-analyze` reviews spec/plan/tasks consistency, not a
skill's own prompt-engineering quality — different artifact type
entirely. `specjedi-new-skill` scaffolds new files; this reviews existing
ones. No redundancy found.

## Genuine contribution beyond the researched field

None of the eleven tools researched across features 001-010 ship a
self-review mechanism that checks their own skill/agent/command files
against a documented authoring standard — every researched tool either
has no such standard formalized at all, or (where one exists informally)
relies entirely on manual review. This project's own
`references/skill-authoring-standard.md` is itself already a
differentiator (Principle XIX); `specjedi-skill-review` is what makes
that standard something a machine can check consistently, not just
something a human remembers to apply — the same "make a mandated
practice a real mechanism, not just a document" contribution shape as
the installer (Principle XVIII) and `specjedi-release` (Principle XI).

## Baseline: GitHub spec-kit

No self-review mechanism for its own command files. **Adopt**: nothing
(no mechanism to adopt). **Reject**: none applicable.

## Researched competitors (re-checked for skill/agent self-review tooling)

1. **BMAD-METHOD** — no self-review mechanism for its own agent
   definitions found.
2. **OpenSpec** — no self-review mechanism found.
3. **Kiro** — no self-review mechanism found in its public surface.
4. **Tessl** — no self-review mechanism found.
5. **Spec Kitty** — no self-review mechanism found.
6. **Superpowers** (installed, inspected firsthand) — has a
   `meta-agent` generation pattern (already adopted as an influence for
   `specjedi-new-skill`, feature 009) but no corresponding *review*
   mechanism for already-written agents.
7. **GSD** (installed, inspected firsthand) — no self-review mechanism
   for its own command files found.
8. **PRP** (installed, inspected firsthand) — no self-review mechanism
   found.
9. **codemyspec.com** — no comparable mechanism found.
10. **Traycer** — no self-review mechanism found.

**Adopt**: nothing directly transferable — this confirms the gap rather
than pointing to prior art to adapt.

## Design implications for `specjedi-skill-review`

- **Report, never fix** — mirrors `specjedi-analyze`'s own strictly
  read-only discipline (feature 001): this skill produces findings, it
  never edits the reviewed `SKILL.md` itself. Auto-fixing a skill's own
  prompt content risks silently changing its behavior in ways nobody
  reviewed.
- **Check the same four dimensions the manual passes already
  established** as the actual, proven checklist: (1) bulleted next-step
  format (Principle XIV), (2) explicit autonomous/confirm-first section
  (Principle XIX), (3) explicit chain-of-thought framing for the skill's
  real judgment call(s) (Principle XX), (4) genuine Star Wars voice
  beyond decorative header emoji (Principle XII) — plus the full Skill
  Authoring Standard structural checklist (persona, task, format, worked
  example, Always/Never, verifiable success criteria).
- **Distinguish "section missing" from "section present but weak"** —
  the manual audits found real cases of the latter (e.g., `specjedi-
  docs`'s drafting step named a judgment call in `plan.md` but never
  carried the "reason through it" framing into the actual `SKILL.md`
  text) that a naive "does this heading exist" check would miss.

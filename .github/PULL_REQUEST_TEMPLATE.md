## What this PR does

<!-- One or two sentences. What changed, and why. -->

## Checklist (required before requesting review — see CONTRIBUTING.md)

### If this PR adds or materially changes a `specjedi-*` skill

- [ ] I performed competitive research against spec-kit + at least ten other
      SDD tools and can name a genuine contribution beyond all of them
      (Principle II) — linked/included as `research.md` in this PR.
- [ ] The skill follows the full SDD cycle (research → specify → clarify →
      plan → tasks → implement) and the `specs/NNN-feature/` artifacts are
      included in this PR.
- [ ] The `SKILL.md` includes: persona, task, defined output format, at
      least one full input → output example, chain-of-thought for
      non-deterministic judgment calls, explicit Always/Never guardrails,
      and verifiable success criteria (Principle XIX / Skill Authoring
      Standard).
- [ ] I ran a scenario-based dry run confirming the skill's elicitation
      questions and branching logic behave as documented (Principle IX) —
      described below.
- [ ] The skill ends with a guided next-step suggestion (Principle XIV).

### Always required

- [ ] `bash scripts/validate.sh` passes locally (or `pwsh scripts/validate.ps1`
      on Windows).
- [ ] I reviewed the README badge row: every existing badge still reads
      correctly, and I added a new one only if this change is a genuinely
      new, relevant fact worth signaling (Distribution & Ecosystem
      Standards) — never a hardcoded value that can go stale.
- [ ] If this PR changes what's true about the project (a shipped skill, a
      new capability), I updated `README.md`'s "What you get today" table,
      Quickstart, and the pipeline Mermaid diagram in the same PR
      (Principle XVI).
- [ ] No commit in this PR was made directly to `main` — this change ships
      through this PR only (Principle X).

## Dry run / validation notes

<!-- What did you actually exercise? What scenario(s) did you test? -->

## Anything reviewers should pay special attention to

<!-- Optional -->

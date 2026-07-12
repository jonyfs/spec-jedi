# Phase 0 Research: Session-Start Live-Render Verification Closure

## The evidence being cited (FR-001)

Earlier in this session, a `SessionStart:compact` hook fired (triggered
by Claude Code's own hook system, not manually invoked), producing this
`additionalContext` block verbatim:

```text
SessionStart:compact hook success: ┌──────────────────────────────────────────┐
  │   ⚔══════  S P E C   J E D I  ══════⚔     │
  │        Spec-Driven Development, sharpened   │
  └──────────────────────────────────────────┘

18 feature(s): 15 complete, 3 in progress, 0 planned, 0 specified, 0 not started.

A project with a plan, you have. Proceed, you may.
```

**Analysis**:

- **Banner**: the exact box-drawing ASCII banner `scripts/session-start.sh`
  produces (matching feature 015's `references/star-wars-lexicon.md`
  design) — not truncated, not malformed.
- **Status summary**: "18 feature(s): 15 complete, 3 in progress, 0
  planned, 0 specified, 0 not started" — this is a real, checkable claim
  about the project's state *at that point in the session* (before
  features 019-022 existed), derived from the same on-disk `specs/*/`
  scan `specjedi-status`'s own logic uses (Constitution Principle
  XXI's own "no separately-maintained tracking system" requirement) —
  not a static or hardcoded string.
- **Yoda line**: "A project with a plan, you have. Proceed, you may." —
  drawn from the rotation pool in
  `references/star-wars-lexicon.md`, correctly gated to the
  `total > 0` branch (feature 015's own bug fix, this session, ensured
  the "Empty, this project's specs are" line is never shown for a
  non-empty project) — contextually appropriate, not the wrong branch.

This is the exact three-part payload Constitution Principle XXI
specifies, produced by a real, harness-triggered firing of the actual
registered hook — not a manual dry run, not a simulated output.

## Decision: this satisfies T020/SC-003's mechanism-verification intent

**Decision**: Treat this observation as closing the "does the mechanism
actually fire correctly when Claude Code triggers it for real" half of
T020/SC-003, explicitly noting it was a `SessionStart:compact` firing
(a context-compaction event) rather than a from-scratch `startup`
firing.

**Rationale**: Claude Code's `SessionStart` hook registration in
`.claude/settings.json` (feature 015) is not scoped to a specific
matcher — the same registered `command` fires for `startup`, `resume`,
`clear`, and `compact` alike, running the identical script and injecting
its output identically as `additionalContext`. T020's original concern
was whether the mechanism — script execution, character cap, correct
content — actually works when genuinely triggered by the harness, as
opposed to only working under a manual dry run. A `compact` firing
exercises that exact same path. The distinction (compact vs. startup) is
real and worth stating precisely (spec.md's Assumptions do so
explicitly) rather than either overclaiming "a fresh session start was
observed" or dismissing this evidence as insufficient.

**Alternatives considered**: Waiting for a from-scratch `startup` firing
specifically before closing T020. Rejected — the hook registration and
script are matcher-agnostic; a `compact` firing is equally strong
evidence for the mechanism-correctness question T020 actually asks. If a
future `startup`-specific behavioral difference is ever discovered, that
would be new information warranting its own follow-up, not evidence this
closure was premature.

## Decision: the render-instruction conflict is real and needs an explicit precedence rule

**Decision**: Document the conflict precisely and resolve it in
`CLAUDE.md` rather than leaving it to accidental precedent.

**What was observed**: The same session that produced the
`SessionStart:compact` payload above also received an explicit
system-level instruction (accompanying a conversation-continuation/
compaction event): "Continue the conversation... Resume directly — do
not acknowledge the summary, do not recap what was happening, do not
preface with 'I'll continue' or similar." `CLAUDE.md`'s existing
session-start section says the opposite for the `SessionStart` payload
specifically: "render its content verbatim as your opening reply before
addressing anything else." In the observed instance, the agent followed
the continuation instruction and did not render the banner as an opening
reply — the two instructions were never reconciled by a rule, only by
which one happened to be interpreted as more urgent in the moment.

**Rationale for resolving it now**: Constitution Principle XX's
grounded-honesty discipline exists specifically to surface exactly this
kind of real, observed gap rather than let it recur silently and
inconsistently each time. A future session hitting the same combination
of triggers deserves a documented answer, not another coin flip.

**Resolution chosen**: The continuation/no-preface instruction takes
precedence over a literal verbatim render (a mid-conversation
continuation is a stronger, more specific signal about what the user
needs right now than a general session-start convention) — but the
underlying orientation goal is not simply dropped: the agent MUST still
work the SessionStart payload's actual status information into its
first substantive response naturally (e.g., a brief grounded status
reference), rather than silently discarding Principle XXI's purpose
entirely. This preserves both instructions' intent instead of treating
them as strictly incompatible.

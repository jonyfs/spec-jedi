# Next-Step Interaction Mechanism

How a `specjedi-*` skill's Constitution Principle XIV "next step"
moment renders — referenced by every skill's own Principle XIV citation
rather than restated in each one.

## The rule

Whenever a skill reaches a Principle XIV Next-Step Suggestion moment:

1. **If the current session exposes a harness-native structured-choice
   tool** (a mechanism for offering the user a selectable set of
   options with click/arrow-navigation and an escape hatch for a
   different answer — e.g. this session's own such tool), present the
   next-step options through it. The option set MUST always include a
   distinct, clearly-labeled entry for a different answer than the
   ones listed.
2. **Otherwise**, render the existing short bulleted markdown list —
   today's baseline, byte-for-byte unchanged. This is not a degraded
   fallback to apologize for; it's the guaranteed baseline every
   harness in the Constitution Principle III compatibility matrix can
   render.

## Why this is a reference doc, not per-skill prose

Constitution Principle III requires skill content to stay harness-
agnostic — no skill's own text may assume a specific tool exists.
Centralizing the mechanism here means every skill's own citation of
"(Principle XIV)" can stay a one-line pointer instead of restating the
conditional logic 28 times, keeping the actual behavior in exactly one
place to update if a harness's own tooling changes.

## What this is not

- Not a new interaction mechanism — it conditionally uses whatever the
  current harness already provides. Nothing here invents a UI capability.
- Not a replacement for the plain bulleted list — that list is the
  permanent, guaranteed fallback, never something this mechanism phases
  out.
- Not applicable to `specjedi-clarify`'s own separate Recommended-
  option/lettered-table question format — that convention serves a
  distinct purpose (structured ambiguity resolution) and is explicitly
  out of scope (specs/051 Clarification, 2026-07-18).

## Never

- Never claim an interactive selection was presented when the harness
  had no such mechanism and the plain list was actually used.
- Never omit the "something else" option from an interactive
  presentation — a closed list with no escape defeats the point.
- Never assume this mechanism applies where a skill's own text
  explicitly scopes a different, separate convention (e.g.
  `specjedi-clarify`'s question format).

# Constitution Mechanics (loaded on demand by `specjedi-constitution`)

The full mechanical procedure behind the core skill's Step 4 ("Write"). This
mirrors the proven mechanics `speckit-constitution` uses (research.md decision
#1: adopt the phase structure wholesale), split into this reference so the
core `SKILL.md` stays within the Skill Authoring Standard's token budget.

## Sync Impact Report format

Prepend as an HTML comment at the very top of `constitution.md`, above the
`# Project Constitution` heading:

```html
<!--
Sync Impact Report
- Version change: OLD → NEW
- Modified principles: [old title → new title, or "none"]
- Added sections: [list, or "none"]
- Removed sections: [list, or "none"]
- Templates requiring updates: [file paths, ✅ updated / ⚠ pending]
- Follow-up TODOs: [any deferred items, or "none"]
-->
```

## Placeholder collection

Every `[ALL_CAPS_IDENTIFIER]` token in the template is a value to resolve:

- If the user's conversation already supplies it, use that.
- Otherwise infer from repo context (existing README, prior constitution
  versions, project name from the repo/directory).
- For governance dates: `RATIFICATION_DATE` is the original adoption date (if
  genuinely unknown, insert `TODO(RATIFICATION_DATE): explanation` and note it
  in the Sync Impact Report's Follow-up TODOs — do not fabricate a date).
  `LAST_AMENDED_DATE` is today if changes are made this session.
- Leave no placeholder unresolved without an explicit, documented reason.

## Version bump decision tree

1. Does this amendment remove a principle, or redefine one in a way that's
   backward-incompatible with how it was previously enforced? → **MAJOR**.
2. Does it add a new principle or section, or materially expand existing
   guidance (new MUST-level rules, not just rewording)? → **MINOR**.
3. Is it wording, formatting, typo fixes, or a clarification with no
   behavioral change? → **PATCH**.
4. If genuinely ambiguous between two tiers, state the reasoning and pick the
   higher tier — a bump that's "too cautious" costs nothing; one that's too
   small misleads downstream consumers of the version number.

## Propagation checklist

After writing the constitution, check whether these need updates to stay
consistent (most already reference the constitution dynamically and won't
need edits — only flag genuine drift):

- `.specify/templates/plan-template.md` — its Constitution Check gate is
  derived from the constitution dynamically; only needs an edit if the
  template's own structure assumes a principle that no longer exists.
- `.specify/templates/spec-template.md`, `tasks-template.md`,
  `checklist-template.md` — same dynamic-derivation logic; check for the same
  reason.
- Any `README.md`/quickstart doc that names a specific principle number —
  numbers shift when principles are added/removed/reordered, so a direct
  reference (e.g., "Principle IV") can go stale silently.

## Pre-write validation checklist

- [ ] No remaining `[ALL_CAPS]` bracket tokens (except intentionally deferred
  ones with a `TODO(...)` marker and a Follow-up TODOs entry explaining why).
- [ ] Version line matches the Sync Impact Report's stated target exactly.
- [ ] All dates are ISO format (`YYYY-MM-DD`).
- [ ] Every principle is declarative and testable — no bare "should" without a
  MUST/SHOULD + rationale explaining the tradeoff.
- [ ] Single blank line between sections; no trailing whitespace.

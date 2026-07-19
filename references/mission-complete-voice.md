# Mission Complete Closing Voice

The concrete trigger condition and closing-line convention for a
`specjedi-*` skill's own genuinely-exhausted-scope moment — referenced
by qualifying skills rather than restated inline.

## The trigger: verifiably exhausted, never assumed

A skill's closing moment counts as "reached the end" only when its own
logic can point to concrete, checkable evidence that nothing further
applies within that skill's own scope:

- **Clean pass, zero findings** — e.g. `specjedi-skill-review` checking
  every dimension and finding no gap.
- **Clean audit, zero findings** — e.g. `specjedi-catalog-audit`/
  `specjedi-constitution-audit` completing a full pass with nothing to
  flag.
- **Eligibility satisfied, nothing further required** — a check that
  confirms a condition is already fully met, not merely "no obvious
  problem seen."

**Never** the trigger: a routine successful step with more work still
ahead (that's Principle XIV's ordinary Next-Step Suggestion moment,
unchanged), or a vague sense that things seem done. If there's any real
doubt whether more work remains, it isn't this moment — use the
ordinary next-step list instead.

## The closing line: additive, not a replacement

Constitution Principle XII already requires "English-only wordplay MUST
be paired with a plain-language equivalent, never used alone." This
convention follows that exactly: the plain status statement a skill
already produces (e.g. "clean pass," "0 findings") stays the precise,
substantive claim; the Star Wars line is genuine flavor confirming the
same fact, drawn from `references/star-wars-lexicon.md`'s own "Mission
Complete" row — never invented ad hoc, never replacing the plain
statement.

## The two hard guardrails (Constitution Principle XX)

1. **Never fabricate the trigger.** A skill MUST NOT manufacture a
   "reached the end" moment for dramatic effect when its own scope
   genuinely isn't exhausted — a fabricated ending is worse than a
   missing one.
2. **Never overstate scope.** The closing line marks that *this skill's
   own* arc/interaction concluded — never a claim that an entire
   project or feature (beyond this one skill's own scope) is complete.
   A clean `specjedi-skill-review` pass on one skill says nothing about
   the other 27; phrase accordingly.

## Which skills this applies to

Not every skill has a genuine exhausted-scope case in its own logic —
e.g. `specjedi-explain` always has something more to explain, so it has
nothing to apply this to. Applicability is determined by reading each
skill's own closing-moment logic directly, never assumed from its name
or category.

# Quickstart: Verifying the Closure

**Feature**: 022-session-start-verification

## Scenario 1: T020 cites real, quoted evidence

```bash
grep -A5 "T020" specs/015-session-start-hook/tasks.md
```

**Expected outcome**: the entry quotes the actual observed banner/status/
Yoda-line content (or references research.md's exact quotation) rather
than repeating "honestly NOT completed... cannot be observed from within
the same session."

## Scenario 2: Principle XXI's traceability row reflects the closure

```bash
grep -A2 "^| XXI |" references/principle-traceability.md
```

**Expected outcome**: states the mechanism as confirmed via a real
`SessionStart:compact` firing, while still distinguishing that from the
separate render-precedence question resolved in Scenario 3.

## Scenario 3: CLAUDE.md states the precedence rule explicitly

```bash
grep -A5 "precedence" CLAUDE.md
```

**Expected outcome**: an explicit statement of which instruction wins
when a continuation/no-preface directive and the render-verbatim
instruction both apply to the same turn, and that the underlying status
information should still surface naturally even when a full verbatim
render doesn't happen.

## Scenario 4: Constitution amendment validates cleanly

```bash
bash scripts/validate.sh
grep "^\*\*Version\*\*" .specify/memory/constitution.md
```

**Expected outcome**: `validate.sh` reports `PASSED`; the version line
shows a MINOR bump from whatever version preceded this feature.

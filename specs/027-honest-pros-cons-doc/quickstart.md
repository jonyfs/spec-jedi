# Quickstart: Verifying the Honest Assessment Document

**Feature**: 027-honest-pros-cons-doc

## Prerequisites

- `references/honest-assessment.md` written per `plan.md`'s Design
  section.
- `README.md` links to it.

## Scenario 1: Every advantage traces to a real, checkable mechanism

**Run**: For each entry in the Advantages section, locate the file/CI
job/`principle-traceability.md` row it cites.

**Expected outcome**: 100% resolve to something real and current in this
repository — zero aspirational claims (spec.md SC-001).

## Scenario 2: At least 5 genuine disadvantages, independently checkable

**Run**: Count the Disadvantages section's entries; for each, verify the
underlying fact directly (e.g., `git tag -l` for the no-release claim).

**Expected outcome**: ≥5 entries, each confirmed true against the repo's
actual current state (spec.md SC-002).

## Scenario 3: Every improvement point names a specific competitor

**Run**: For each entry in the Improvement Points section, confirm it
names a specific tool and traces to (or reasonably extends)
`references/competitive-comparison.md`.

**Expected outcome**: zero vague, uncited entries (spec.md SC-003).

## Scenario 4: A newcomer can state 3 reasons for and 3 limitations against, unaided

**Run**: Have someone with no prior context on this project read only
`references/honest-assessment.md`.

**Expected outcome**: they can state at least 3 concrete reasons to adopt
Spec Jedi and at least 3 concrete current limitations, without consulting
any other document (spec.md SC-004).

## Structural validation

```bash
./scripts/validate.sh
```

**Expected outcome**: passes.

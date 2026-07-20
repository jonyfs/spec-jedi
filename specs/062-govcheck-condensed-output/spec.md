# Feature Specification: specjedi-govcheck Prints Only Findings, Auto-Proceeds When Clean

**Feature Branch**: `062-govcheck-condensed-output`

**Created**: 2026-07-20

**Status**: Draft

**Input**: User description: "ajuste /specjedi-govcheck para gastar menos tokens e só imprimir o que não estiver ok, se tudo estiver ok vá automaticamente para os proximos passos"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A clean governance check prints one line, not a 22-row table (Priority: P1)

A user (or another skill self-invoking `specjedi-govcheck`, e.g.
`specjedi-implement`) runs a governance check against a branch/PR where
every one of the 20 Core Principles plus the 2 cross-cutting sections is
Not Applicable or Compliant — the common case in practice, confirmed
directly this session: three consecutive real `specjedi-govcheck` runs
(specs/059, specs/060, specs/061) each produced a full ~22-row markdown
table, every single row N/A or Compliant, zero findings, before reaching
the same one-line "CLEAN" verdict already printed at the bottom. Today,
`specjedi-govcheck`'s Format section and Verifiable Success Criteria both
require every principle to appear in the printed report, so the full
table always prints, "resist the urge to force every row" (today's Step
5) notwithstanding — that guidance is about not *fabricating* a status,
not about whether to *print* an already-honest N/A row. This story
replaces the full table, in the all-clean case, with a single condensed
line and moves straight to the next-step bullets — no table at all.

**Why this priority**: This is the exact, directly-observed waste this
request names — the common case (clean) currently costs the most tokens
(a full table) for the least information (nothing to act on).

**Independent Test**: Given a branch/PR where every principle reasons to
N/A or Compliant, running `specjedi-govcheck` produces one summary line
(naming the branch/PR and a "N/M principles reasoned, 0 findings"
count) followed immediately by the next-step bullets — no per-principle
table appears in the output.

**Acceptance Scenarios**:

1. **Given** a diff where all 22 rows reason to N/A or Compliant, **When**
   `specjedi-govcheck` runs, **Then** the output is one summary line plus
   the next-step bullets — zero table rows printed.
2. **Given** the same clean result, **When** self-invoked by
   `specjedi-implement` (Step 6.5), **Then** `specjedi-implement`
   proceeds to open the PR immediately after the condensed line, with no
   separate pause or additional narration about the check.

---

### User Story 2 - A non-clean check prints only the rows that need attention (Priority: P1)

When one or more principles are genuinely Non-Compliant or CRITICAL, the
report shows *only* those rows — every N/A and Compliant row (still
reasoned through internally, per Story 3) is omitted from the printed
table, since a row with nothing to act on costs tokens without adding
decision-relevant information.

**Why this priority**: Equal priority to Story 1 — both are the same
underlying change (print findings, not the full reasoning trace) applied
to the two possible outcomes of a check.

**Independent Test**: Given a diff with 2 Non-Compliant rows and 20
N/A-or-Compliant rows, running `specjedi-govcheck` produces a table with
exactly 2 rows — the 20 clean ones never appear in the printed table.

**Acceptance Scenarios**:

1. **Given** 1 CRITICAL and 1 Non-Compliant finding among 22 reasoned
   principles, **When** `specjedi-govcheck` runs, **Then** the printed
   table contains exactly those 2 rows, each with its full evidence/
   mechanism text unchanged (Story 2 shortens the table's *row count*,
   never a finding's own evidence detail) — none of the other 20 rows
   appear.
2. **Given** the same result, **When** the summary line above the table
   is printed, **Then** it states the overall count (e.g., "2
   Non-Compliant (1 CRITICAL)") matching today's existing "Overall:"
   line content, just relocated to lead the condensed output instead of
   trailing a full table.

---

### User Story 3 - Every principle is still reasoned through internally — only the printed output shrinks (Priority: P1)

Stories 1-2 change *what gets printed*, never *what gets reasoned
about*. `specjedi-govcheck` still evaluates all 20 principles plus the 2
cross-cutting sections against the actual diff, exactly as it does
today (Step 3's explicit per-principle reasoning discipline, Principle
XX's grounded-output requirement) — the condensation is a presentation
change, not a shortcut that skips reasoning about principles whose rows
happen to not get printed.

**Why this priority**: Equal-highest priority — without this story,
"spend fewer tokens" could be read as "reason about fewer principles,"
which would silently weaken the check's own correctness guarantee
(today's Verifiable Success Criteria: "no silent omissions"). This story
is the guardrail preventing that misreading from becoming the
implementation.

**Independent Test**: Given a full run, an on-demand request for "the
full report" (Story 4) returns a complete 22-row table with a genuine,
non-fabricated status for every principle — proving every principle was
actually reasoned about internally even though most rows never printed
by default.

**Acceptance Scenarios**:

1. **Given** a clean run that printed only the condensed one-liner
   (Story 1), **When** the user then asks to see the full breakdown,
   **Then** every one of the 22 rows appears with a real, specific
   status and evidence — not a placeholder or a re-run that skips
   principles the condensed pass silently never checked.

---

### User Story 4 - The full table is always available on request (Priority: P2)

A user who wants the complete per-principle breakdown (audit purposes,
double-checking a specific principle, or general curiosity) can ask for
it, and `specjedi-govcheck` presents the full table — the same one this
skill already produces today — rather than the condensed default being
the only option.

**Why this priority**: Lower priority than Stories 1-3 because it's a
preserved escape hatch, not the main value of this feature — but without
it, this feature would be a net loss of information access, not just a
token-cost reduction, which isn't what was asked for.

**Independent Test**: Given a request like "show me the full governance
report" (or equivalent phrasing) either as part of the same invocation
or a follow-up, `specjedi-govcheck` produces the complete table — every
principle, every status — matching today's existing Format exactly.

**Acceptance Scenarios**:

1. **Given** an explicit request for the full report, **When**
   `specjedi-govcheck` runs (or is asked again after a condensed run),
   **Then** the complete 22-row table prints, identical in shape to
   today's existing Format section.

---

### Edge Cases

- What happens when self-invoked by `specjedi-implement` and the result
  is NOT clean (a real CRITICAL finding)? Unchanged from today: `specjedi-
  implement`'s own Step 6.5 already says "surface any CRITICAL finding
  prominently... never let a finding block the PR from opening" — Story
  2's condensed, findings-only table *is* that prominent surfacing (a
  focused 1-2-row table is more prominent than a CRITICAL row buried
  among 20 clean ones), and the never-block behavior is unchanged.
- What happens with zero applicable principles at all (an empty/
  inaccessible diff, `specjedi-govcheck`'s own existing FR-007 case)?
  Unchanged — that's a distinct, already-documented "report plainly and
  stop" case, not something this feature's condensation logic
  applies to (there's no reasoning pass to condense when there's nothing
  to check).
- What happens if a user asks for the full report on a check that's
  already clean? Same as Story 4's normal case — the full table
  prints, all rows N/A/Compliant, exactly as `specjedi-govcheck`
  produces today when run without this feature at all. This feature
  never removes the old behavior, only stops it being the unconditional
  default.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `specjedi-govcheck` MUST continue to reason through all 20
  Core Principles plus the 2 cross-cutting sections against the actual
  diff, exactly as it does today (today's Step 3, unchanged) — this
  feature changes output presentation only, never the reasoning scope.
- **FR-002**: When every reasoned principle/section is N/A or Compliant,
  `specjedi-govcheck` MUST print exactly one summary line (naming the
  branch/PR, and stating "N/M principles reasoned, 0 findings" or
  equivalent) instead of a per-principle table, then proceed directly to
  the next-step bullets (Principle XIV) — no table, no additional pause.
- **FR-003**: When one or more principles are Non-Compliant or CRITICAL,
  `specjedi-govcheck` MUST print a table containing *only* those rows —
  every N/A and Compliant row MUST be omitted from the printed table,
  while each printed row's own evidence/mechanism text stays exactly as
  detailed as today's existing Format requires (Step 3's "name the
  specific file/evidence... never a vague 'might be violated'" is
  unchanged).
- **FR-004**: The condensed output (FR-002 or FR-003) MUST still state
  the overall verdict line ("CLEAN" or "N Non-Compliant (M CRITICAL)")
  matching today's existing "Overall:" line's content — relocated to
  lead the output, not dropped.
- **FR-005**: `specjedi-govcheck` MUST support an explicit on-request
  full-report mode — the complete, unconditional per-principle table
  this skill already produces today — available any time a user asks
  for it, whether as part of the initial invocation or a follow-up after
  a condensed result.
- **FR-006**: This feature MUST NOT change Step 6.5's Autonomous vs.
  confirm-first posture ("this skill informs, it does not gate") or any
  Always/Never rule already governing `specjedi-govcheck` — condensation
  applies to the report's own print surface only.
- **FR-007**: When self-invoked by `specjedi-implement` (or any other
  skill) and the result is clean, the calling skill's own subsequent
  step MUST proceed without an additional narration pause specifically
  about the governance check — matching Story 1 Scenario 2.

### Key Entities

- **Condensed report**: the new default output — one summary line (clean
  case) or a findings-only table (non-clean case), always preceded by
  the same complete internal reasoning pass FR-001 requires.
- **Full report**: today's existing, unconditional 22-row table —
  preserved unchanged, available on request (FR-005), not replaced.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A clean governance check's printed output is under 10
  lines (summary line + next-step bullets), down from today's ~30+ line
  full table, in 100% of all-clean runs.
- **SC-002**: A non-clean check's printed table row count equals exactly
  the number of Non-Compliant/CRITICAL findings — 0 N/A or Compliant
  rows appear in the printed table, in 100% of such runs.
- **SC-003**: An on-request full report contains all 22 rows with
  genuine, non-fabricated statuses, in 100% of such requests — proving
  FR-001's internal reasoning was never actually skipped.
- **SC-004**: Zero change in verdict accuracy — the same diff produces
  the same set of Non-Compliant/CRITICAL findings under this feature as
  it would have under today's full-table behavior, in 100% of
  comparable runs.

## Assumptions

- This feature is scoped to `specjedi-govcheck`'s own **report
  presentation** (Step 5/6, Format, Verifiable Success Criteria) — Step
  1 (diff retrieval) and Step 2 (loading `principle-traceability.md`)
  are unaffected; they're already small, bounded reads, not the
  observed cost driver this session's own real runs identified.
- "Automatically go to next steps" (the request's own phrasing) means:
  skip the full table and present the next-step bullets immediately
  after the condensed summary line — it does not mean
  `specjedi-govcheck` itself takes any autonomous action beyond
  reporting; this skill has no write surface and none is added by this
  feature (FR-006).
- No new CLI flag is required to request the full report (FR-005) — a
  plain-language request ("show me the full report," "give me the
  complete breakdown") is sufficient, matching this project's own
  general preference for natural-language requests over memorized flags
  where either would work equally well.

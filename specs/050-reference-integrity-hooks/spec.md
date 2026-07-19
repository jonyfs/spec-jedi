# Feature Specification: Skill Reference Integrity & Hook Enablement

**Feature Branch**: `050-reference-integrity-hooks`

**Created**: 2026-07-18

**Status**: Draft

**Input**: User description: "revise todas as skills specjedi para ver se
possuem as referencias mencionadas em suas skills, busque e crie o que
for necessário seja de referencias, hooks que podem ser uteis para
speckedi skills tb" (review all specjedi skills to see if they have the
reference files they cite; search for and create whatever's missing —
reference files, and hooks that could be useful for specjedi skills too).
A pre-drafting sweep of every `.claude/skills/specjedi-*/SKILL.md`
against every ```references/*.md``` citation it makes found: 9 unique
reference files cited across the catalog, 7 already exist, and exactly
2 are cited but missing — `references/constitution-mechanics.md`
(cited by `specjedi-constitution`) and
`references/aitmpl-browsing-playbook.md` (cited by `specjedi-master`).
Separately, the hook-dispatch mechanism 9 `specjedi-*` skills already
check for (`.specify/extensions.yml`, specs/047) has zero hooks
registered anywhere in this project today — every check silently no-ops
by design, but no maintainer has ever seen a concrete example of what a
useful hook entry looks like.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - No skill points to a reference file that doesn't exist (Priority: P1)

A maintainer or an agent following a `specjedi-*` skill's own
instructions ("load `references/X.md` for full detail") expects that
file to actually be there. Today, following `specjedi-constitution`'s
own Step 4 pointer or `specjedi-master`'s own catalog-browsing pointer
leads to a dead link — the skill's text promises detail that doesn't
exist on disk.

**Why this priority**: This is a currently-broken promise, not a
hypothetical one — two shipped skills cite files that don't exist right
now. Every other part of this request (hooks) is an enhancement; this is
a fix to something already wrong.

**Independent Test**: For each of the 27 currently-shipped `specjedi-*`
skills, extract every ```references/*.md``` citation in its `SKILL.md`
and confirm the file exists on disk; confirm the two currently-missing
files (`constitution-mechanics.md`, `aitmpl-browsing-playbook.md`) now
exist with real content matching what their citing skill's own text says
they contain.

**Acceptance Scenarios**:

1. **Given** the current 27-skill catalog, **When** every
   ```references/*.md``` citation is checked against the filesystem,
   **Then** every one resolves to a real file — zero missing.
2. **Given** `specjedi-constitution`'s own Step 4 text ("Full mechanical
   detail... is in `references/constitution-mechanics.md`"), **When**
   that file is read, **Then** it actually contains the exact report
   format, propagation checklist, and validation steps the citing text
   promises — not a placeholder stub.
3. **Given** `specjedi-master`'s own text ("`references/aitmpl-
   browsing-playbook.md` has the exact URL/filter mechanics"), **When**
   that file is read, **Then** it actually contains concrete
   aitmpl.com URL patterns and filter mechanics for skills/agents/
   commands/settings/hooks/loops — not a placeholder stub.

---

### User Story 2 - A maintainer can see what a useful specjedi-\* hook actually looks like (Priority: P2)

A maintainer knows (from the 9 skills' own Pre-flight/after-hook-dispatch
sections) that `.specify/extensions.yml` can register `before_X`/
`after_X` hooks against any of 9 pipeline stages, but has never seen a
real, concrete example — today the file doesn't exist at all, so every
hook check silently no-ops. Without an example, "useful hooks" stays an
abstract capability nobody actually turns on.

**Why this priority**: Valuable and directly requested, but secondary to
User Story 1 — the hook-dispatch mechanism already degrades gracefully
today (specs/047's own explicit design), so nothing is broken here, only
unrealized.

**Independent Test**: Given the delivered example/starter
`.specify/extensions.yml`, confirm every hook entry in it names a real,
already-existing project script or `specjedi-*` skill as its `command`
— never an invented capability — and confirm the file is clearly marked
as an inactive example/template, not a live, auto-registered
configuration.

**Acceptance Scenarios**:

1. **Given** the delivered example `.specify/extensions.yml`, **When**
   each hook entry's `command` field is checked, **Then** it resolves to
   a real, already-existing script (e.g. `scripts/validate.sh`) or a
   real, already-shipped `specjedi-*` skill — never something invented
   for the example.
2. **Given** the delivered example file, **When** a maintainer reads it
   without further explanation, **Then** it's unambiguous that
   activating any hook requires their own explicit action (uncommenting
   or copying an entry into a live file) — never something that silently
   starts running commands on its own.

---

### User Story 3 - The reference-integrity check doesn't go stale the next time a skill ships (Priority: P3)

A maintainer wants today's fix to stay fixed — the same class of gap
(a skill shipping with a citation to a reference file nobody actually
wrote) should be catchable again the next time a `specjedi-*` skill is
authored or edited, not rediscovered by another one-off manual sweep.

**Why this priority**: P3 — durability layer. Valuable, but only once
User Story 1 has established there's a real, recurring class of gap
worth guarding against, not a one-time accident.

**Independent Test**: Given a hypothetical future skill shipped with a
citation to a reference file that doesn't exist, confirm the
re-runnable mechanism this feature ships flags it — without needing
another manual `grep`-and-check sweep.

**Acceptance Scenarios**:

1. **Given** a skill citing a non-existent `references/*.md` file,
   **When** the re-runnable check from this feature is run, **Then** the
   specific skill and the specific missing path are both named
   explicitly — never a vague "some reference might be missing."

### Edge Cases

- **What if a reference file is cited by more than one skill?** Not the
  case for either currently-missing file (each has exactly one citing
  skill), but the created file's content must satisfy every citing
  skill's own stated expectation, not just the first one found.
- **What if a proposed hook's `command` points to a script/skill that
  gets renamed or removed later?** Out of scope for this feature to
  guard against continuously — the example file is a point-in-time
  starter, not a live-monitored configuration; keeping it in sync is a
  normal follow-up edit, same as any other project doc.
- **What if the reference-integrity check (User Story 3) finds a
  citation this feature's own new reference files introduce a false
  positive on** (e.g. a citation inside a code fence meant as an
  example, not a real reference)? The check must reason about genuine
  citations, not pattern-match every occurrence of the string
  `references/` blindly — a documented false-positive-avoidance rule is
  part of what "done" means for User Story 3, not an afterthought.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A one-time sweep MUST enumerate every ```references/*.md```
  citation across all currently-shipped `specjedi-*` skills and confirm
  each resolves to a real file on disk, naming any that don't
  (grounding: the pre-drafting sweep already found exactly 2 — see
  Input above).
- **FR-002**: Both currently-missing reference files
  (`references/constitution-mechanics.md`,
  `references/aitmpl-browsing-playbook.md`) MUST be created with real,
  grounded content that satisfies exactly what their citing skill's own
  text says the file contains — never a placeholder stub or an invented
  capability the citing skill never actually promised.
- **FR-003**: The feature MUST produce an example/starter
  `.specify/extensions.yml` proposing concrete hook entries for at least
  a meaningful subset of the 9 pipeline stages (`specify`, `clarify`,
  `plan`, `tasks`, `implement`, `analyze`, `checklist`, `constitution`,
  `converge`) that already check for hooks — the exact count and which
  stages is a design decision resolved during planning.
- **FR-004**: Every hook entry's `command` field in the delivered example
  MUST name a real, already-existing project script or `specjedi-*`
  skill — never a capability invented for the example that doesn't
  actually exist in this project.
- **FR-005**: The delivered example `.specify/extensions.yml` MUST be
  clearly an inactive template/example, requiring the maintainer's own
  explicit action to activate any entry — this feature MUST NOT
  auto-register a live, executing hook without that explicit step
  (hooks execute arbitrary commands; silent auto-activation is a real
  risk, not a hypothetical one).
- **FR-006**: Whether the reference-existence check (User Story 3)
  ships as a durable, re-runnable capability (e.g. an added dimension on
  an existing audit skill) or as a one-time fix only is a technical
  design decision, resolved during planning — matching this project's
  own established precedent for exactly this kind of "extend vs.
  one-time fix" question (specs/043's Decision 1; specs/049's Decision
  1).
- **FR-007**: The re-runnable check (if it ships per FR-006) MUST name
  both the specific citing skill and the specific missing path for any
  future broken reference it finds — never a vague "something might be
  missing" (matching every other audit skill's own established
  reporting discipline in this project).
- **FR-008**: This feature's own reference-integrity sweep MUST NOT flag
  a `references/*.md`-shaped string that appears purely as a
  documentation example (e.g. inside this very spec's own Input section
  above, or inside a worked Example block in some skill) as if it were a
  real, load-bearing citation — [NEEDS CLARIFICATION: no such
  false-positive case was actually found in the pre-drafting sweep of
  the current 27-skill catalog, but the Edge Cases section above flags
  it as a real risk for User Story 3's re-runnable version; should the
  distinguishing rule be "only citations inside a numbered Step or
  frontmatter `compatibility` field count," or some other concrete
  test, decided during planning?]

### Key Entities

*(Not applicable — this feature creates reference documents and an
example configuration file; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A fresh sweep of every ```references/*.md``` citation
  across the current `specjedi-*` catalog produces zero missing files —
  verifiable by re-running the same sweep that found the original 2
  (Input section) and confirming it now returns none.
- **SC-002**: Both newly-created reference files are individually usable
  by their citing skill without further editing — verifiable by reading
  the citing skill's own text (`specjedi-constitution`'s Step 4,
  `specjedi-master`'s aitmpl-browsing paragraph) and confirming the new
  file actually contains what that text says it does.
- **SC-003**: Every hook entry in the delivered example
  `.specify/extensions.yml` names a real, verifiable-to-exist `command`
  target — zero invented capabilities — verifiable by checking each
  entry's target script/skill exists in the project.
- **SC-004**: A maintainer reading the delivered example file alone
  (no separate explanation needed) understands it requires their own
  explicit action before any hook actually runs — verifiable by
  construction (an explicit inline comment/header stating this).

## Assumptions

- Scope is the 27 currently-shipped `specjedi-*` skills' own
  ```references/*.md``` citations only — a citation to any other path
  style (e.g. `.specify/memory/constitution.md`, which several skills
  already correctly cite and which does exist) is not in scope, since
  the pre-drafting sweep found no broken citations of that kind.
- The separate, older `.specify/extensions/agent-context/` directory
  (a distinct, directory-based speckit-vendored extension mechanism,
  discovered incidentally during this feature's own pre-drafting sweep,
  predating specs/047's flat-file `.specify/extensions.yml` hook-dispatch
  design) is explicitly OUT OF SCOPE for this feature — it's a candidate
  cleanup item for specs/048's own retire-speckit follow-through, a
  separate housekeeping concern, not a reference-integrity or
  hook-enablement gap.
- This capability's User Story 1 fix is durable by construction (the two
  files, once created, don't need re-creating); whether User Story 3's
  re-runnable check becomes a permanent addition to the project (see
  FR-006) is a planning-stage decision, not assumed here either way.
- The example `.specify/extensions.yml` is documentation/onboarding
  material, not a live configuration this feature activates on the
  project's own behalf — matching FR-005's explicit constraint.

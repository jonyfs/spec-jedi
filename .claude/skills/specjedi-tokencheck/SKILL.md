---
name: specjedi-tokencheck
description: Mechanizes Constitution Principle VIII — proactively checks whether rtk and graphify are present, explains any missing tool's purpose and expected token savings, and offers an install walkthrough. Never installs or configures anything without explicit confirmation. Self-invoked proactively by specjedi-onboard's first-run flow; also runs standalone at any point in a session.
compatibility: No external dependencies for the check itself. Uses standard environment lookup (which/where) plus graphify-out/ as a secondary signal; writes nothing unless the user explicitly confirms an install, at which point installation follows each tool's own documented installer.
---

# 🎒 Spec Jedi Token Check

**Persona**: a practical quartermaster — checks the kit before the
mission starts, names exactly what's missing and why it'd help, never
hands over new gear without a nod first.

**Task**: check whether `rtk` and `graphify` are present, independently,
explain any missing tool's purpose and expected savings, offer an install
walkthrough, and take no installation action without explicit
confirmation naming that specific tool.

## Step-by-step

1. **Check `rtk`.** Run `which rtk` (or `where rtk` on Windows). Present,
   missing, or — if the lookup mechanism itself isn't available in this
   environment — indeterminate. Never guess a status you didn't actually
   check (FR-006).
2. **Check `graphify`, independently and with equal weight** (FR-001,
   resolved via Clarifications: Principle VIII names both tools without
   qualification — this project's own downstream use of `graphify` inside
   `specjedi-plan`/`specjedi-converge` doesn't make its installation
   status in a *target* project any less worth checking). Run `which
   graphify` (or `where graphify`); a `graphify-out/` directory is a
   secondary signal the tool has been used here before, not a substitute
   for the binary check itself.
3. **For each tool found present, report it plainly and stop there** — no
   suggestion, no install offer (FR-004). A tool already in place gets
   exactly one clean status line.
4. **For each tool found missing, explain what it does and its expected
   savings in one or two concrete sentences** (FR-002) — `rtk`: a
   token-optimized CLI proxy that rewrites common dev-tool invocations
   (e.g., `git status` → `rtk git status`) to cut token usage on routine
   operations. `graphify`: a knowledge-graph/codebase-query tool that lets
   `specjedi-plan`/`specjedi-converge` answer "what already exists here"
   without brute-force file reads. Then offer to walk through installing
   it.
5. **Never run an install/configure command without an explicit,
   unambiguous confirmation naming that specific tool** — this is the
   skill's one real judgment call: reason through whether a reply is a
   clear yes to *this* tool, a decline, or genuinely ambiguous, before
   proceeding. A decline or an ambiguous reply gets the manual install
   command stated as a next step, never an inferred "sounds like yes."
6. **Report, then offer the next step(s) as a short bulleted list**
   (Principle XIV; see `references/next-step-interaction.md`) —
   typically the pipeline stage the caller was already
   heading toward (when self-invoked from `specjedi-onboard`), or, when
   run standalone, whichever `specjedi-*` skill fits the current project
   state.

## Autonomous vs. confirm-first

Checking both tools' presence and explaining a missing tool's purpose and
savings are fully autonomous — no confirmation needed to look and report.
What's never autonomous, in any mode: running an install or configuration
command for either tool — that always requires the user's explicit,
unambiguous yes to that specific tool first (step 5).

## Format

```markdown
## Tooling check

- `rtk`: present / missing / indeterminate
- `graphify`: present / missing / indeterminate

<for each missing tool>
**<tool>** — <one-to-two-sentence purpose + expected savings>.
Want me to walk through installing it?
```

**Audience calibration**: the savings explanation stays concrete — a
stated mechanism or number, never an unqualified "makes things faster"
(Principle XIX's ruthless-literalness standard).

## Example (input → output)

**Input**: run against this repository's own real environment.

**Agent checks**:
```markdown
## Tooling check

- `rtk`: present (/usr/local/bin/rtk)
- `graphify`: present (/Users/jony/.local/bin/graphify; graphify-out/ also found)
```

**Agent's chat narration** (Principle XII voice — the status lines stay
plain; this is what the skill actually says around them):
> 🎒 Kit's already squared away — both `rtk` and `graphify` are on
> `PATH`. Nothing to suggest here.

**Edge-case input**: a fresh environment with neither tool installed.

**Agent writes**:
```markdown
## Tooling check

- `rtk`: missing
- `graphify`: missing

**`rtk`** — a token-optimized CLI proxy that rewrites common dev-tool
commands (e.g., `git status` → `rtk git status`) to cut token usage on
routine operations. Want me to walk through installing it?

**`graphify`** — a knowledge-graph/codebase-query tool this project's own
`specjedi-plan`/`specjedi-converge` already prefer over brute-force file
reads when available. Want me to walk through installing it?
```

**Not this**: installing either tool because "you'll probably want it,"
or collapsing both explanations into one generic "these save tokens"
line.

## `--auto` mode

Proceed through both checks and present the report without stopping for
confirmation — `--auto` only removes the pause before presenting the
report itself. It never removes step 5's explicit-confirmation gate
before installing anything, and it never infers a "yes" from silence.

## Always / Never

- **Always** check `rtk` and `graphify` independently, with equal
  treatment — never skip one because the other is already handled
  elsewhere in the project.
- **Always** report a tool whose status can't be determined as
  indeterminate — never guess present or absent.
- **Never** suggest installing a tool already detected as present — a
  clean status line only.
- **Never** run an install or configuration command without an explicit,
  unambiguous confirmation naming that specific tool; instead, state the
  manual install command as a next step and wait.

## Verifiable success criteria

- A run against an environment with neither tool present reports both as
  missing, each with its own distinct purpose/savings explanation.
- Zero install or configuration actions occur without an explicit
  confirming response naming the specific tool — checkable via `git
  status`/shell history showing no install command ran absent that
  confirmation.
- A run against an environment with both tools present produces a clean
  report with no install offers.

## Validation Coverage (Principle IX)

Per `references/skill-validation-testing-framework.md`:

- **Vague / Incomplete Input Handling**: Not Applicable — a deterministic
  presence check, no free-form request to interpret.
- **Prompt Injection Resistance**: Not Applicable — no file-content read;
  `which`/`where` checks a tool's presence only.
- **Out-of-Bounds / Malformed Input Handling**: Not Applicable — no
  structured input of its own to parse.
- **External-Call Resilience**: Not Applicable — `which`/`where` are
  local shell lookups, not network calls.

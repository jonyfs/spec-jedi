# Research: Expand Shareable Hooks — Push/Commit/Read Guards

**Feature**: `058-expand-shareable-hooks` | **Date**: 2026-07-19

## Scope of this research

User Stories 1-4 (`prevent-direct-push`, `secret-scanner`,
`conventional-commits`, the `Stop` notification hook) reuse
`specs/041-release-hooks-settings/research.md`'s already-confirmed
per-harness hook/permissions mechanism directly — no new harness
classification work is needed, matching this project's own
"adapt what already exists" scoping (spec.md Assumptions). This document
covers only the genuinely new research User Story 5 required, plus one
structural gap surfaced while planning that applies to every user story.

## Decision 1: `permissions.deny`/`Read` is not a dependable sole backstop

**Finding**: [anthropics/claude-code#24846](https://github.com/anthropics/claude-code/issues/24846)
(reported 2026-02-11, closed as duplicate, no confirmed fix date visible
from outside the Anthropic tracker) reports `Read` tool calls succeeding
against files matching configured `permissions.read.deny` patterns.
[The Register](https://www.theregister.com/2026/01/28/claude_code_ai_secrets_files/)
independently reproduced a related failure mode against `.claudeignore`/
`.gitignore`-based blocking (confirmed non-functional for this purpose —
Claude Code reads `.env` files despite both), and identified
`permissions.deny` in `.claude/settings.json` as the *documented*
mitigation, while still noting reported reliability gaps with it.

**Decision**: The new hook (FR-009) is the primary, active enforcement
mechanism (a `PreToolUse` hook that can affirmatively deny a tool call,
the same proven mechanism `dangerous-command-guard.sh` already uses for
the `Bash` matcher). `permissions.deny` (FR-010) remains defense-in-depth
only. This feature does not gate on re-verifying the bug's current status
before shipping either layer (Clarifications, 2026-07-19 session).

**Alternatives considered**: Relying on `permissions.deny` alone (rejected
— the one dependable layer per the finding above is the active hook, not
the declarative list) — re-verifying current behavior before deciding
(rejected by the same Clarifications answer — defense-in-depth is
strictly better regardless of the bug's current status, so gating
implementation on confirming it first only delays a strictly-positive
change).

## Decision 2: secret/credential filename pattern set

**Finding**: gitleaks (the most widely-cited open-source secret scanner,
config at `config/gitleaks.toml`) ships default detection covering
suspicious filenames/extensions including `id_rsa`, `*.pem`, `htpasswd`,
alongside its regex-based content rules. No aitmpl.com-cataloged hook was
found solving this problem better or differently (the `/hooks` category
has no populated secret-file-blocking entries as of this review,
consistent with this project's own established finding that most of
aitmpl.com's catalog doesn't fit this project's domain).

**Decision**: FR-009/FR-010's pattern set (`.env`/`.env.*` excluding
template variants, `id_rsa`/`id_dsa`/`id_ecdsa`/`id_ed25519`,
`*.pem`/`*.key`/`*.pfx`/`*.p12`, `.npmrc`, `.netrc`, `.pgpass`,
`.git-credentials`, `.aws/credentials`, `.docker/config.json`) is
hand-rolled the same way `dangerous-command-guard.sh` itself originally
was (adapted from disler/claude-code-hooks-mastery and morphllm.com's
`.env`-blocking guide, per that file's own header comment), cross-checked
against gitleaks' publicly documented filename/extension categories
rather than invented from scratch.

**Alternatives considered**: Shipping a gitleaks binary dependency
(rejected — breaks the zero-footprint installer posture, Principle
XVIII, for a pattern list gitleaks documents but doesn't require running
gitleaks itself to reuse) — adopting an aitmpl.com-cataloged hook
(rejected — none found that solves this).

## Decision 3: `PreToolUse` hook JSON field names per tool

**Finding**: Claude Code's hooks reference (code.claude.com/docs/hooks)
confirms `tool_input.command` for `Bash` (already used by
`dangerous-command-guard.sh`) and a combined matcher string
(`"Read|Grep|Glob"`) is valid syntax for one hook entry covering all
three tools. The exact per-tool `tool_input` field names for `Read`/
`Grep`/`Glob` are not published in that reference page; they are
confirmed instead from this project's own live tool contract (the same
tools this session used throughout planning): `Read` carries
`file_path` (a single target file); `Grep`/`Glob` carry `pattern` (the
search/glob pattern) and `path` (a directory to search *or* a single
file — optional, defaults to the whole project when omitted).

**Decision**: The new hook matches `tool_input.file_path` (`Read`) or
`tool_input.path` (`Grep`/`Glob`) **only when that field names a
specific file** whose basename matches a denied pattern. A `Grep`/`Glob`
call whose `path` is a directory (or omitted entirely, i.e. a
project-wide search) is never denied outright — denying based on "a
`.env` might exist somewhere under this directory" would false-positive
on ordinary project-wide searches constantly. This matches Acceptance
Scenario 4 (an unrelated file/search proceeds unblocked) and keeps the
hook's blast radius identical to `dangerous-command-guard.sh`'s own
precedent of narrow, token-exact matching over broad substring guessing.

**Alternatives considered**: Denying any `Grep`/`Glob` call whose
directory-scoped search *could* traverse a secret file (rejected — this
would break ordinary codebase-wide searches used constantly by every
`specjedi-*` skill in this repo, an unacceptable false-positive class
`dangerous-command-guard.sh`'s own design philosophy already rejects for
analogous reasons).

## Decision 4: `scripts/package-release.sh`/`.ps1` currently only stages `dangerous-command-guard.sh`/`.ps1`

**Finding**: `scripts/package-release.sh`/`.ps1` (specs/020/038's release
packaging mechanism) copies exactly one hook pair
(`.claude/hooks/dangerous-command-guard.sh`/`.ps1`) into the staged
release tarball. It does not copy `secret-scanner.py`,
`conventional-commits.py`, or `prevent-direct-push.py` — the three hooks
`install.sh`/`.ps1` will need to read from `$repo_root/.claude/hooks/*`
once User Stories 1-3 land. This is the exact same bug class
`specs/042-skill-freshness-validation` already found and fixed once
before for `dangerous-command-guard.sh` itself (documented directly in
`package-release.sh`'s own header comment): `install.sh` reading a hook
file the packaging script never staged, which "has always exited 1"
when run from an extracted release tarball rather than a git checkout.

**Decision**: This feature MUST extend `package-release.sh`/`.ps1` to
also stage `secret-scanner.py`, `conventional-commits.py`,
`prevent-direct-push.py`, and the new `secret-file-guard.sh`/`.ps1`
(FR-009) — and add each new path to `validate.yml`'s
`package-content-completeness` job's "must be present" list — or this
entire feature would work in a git-checkout install but silently break
for every user installing from the actual downloadable release, which is
the literal, stated purpose of this feature per its own spec.md title.

**Alternatives considered**: None — this is a structural gap that must
be closed for the feature's own stated goal ("para estar no release da
próxima versão") to be true, not a design choice with real alternatives.

## Decision 5: `secret-scanner.py` was leaking the matched secret value

**Finding**: A `specjedi-security` self-invocation during this planning
pass (Constitution-mandated for secrets/credentials-relevant plans)
surfaced that `secret-scanner.py`'s denial output printed
`match.group(0)` — the raw matched secret substring, truncated only past
50 characters — directly to `stderr` on every blocked commit. That
output becomes part of the blocked tool call's own visible result,
exposing the live secret into the agent's context and any session
transcript/log that captures tool output, at the exact moment this hook
exists to prevent secrets from leaking that way.

**Decision**: Fixed directly during this planning pass (not deferred to
`specjedi-implement`, given the fix's small size and zero design
ambiguity) — `secret-scanner.py` now redacts the matched value to its
first 4 and last 4 characters (fully masked at 8 characters or shorter)
before printing (FR-012). `specjedi-tasks` should mark this task
pre-completed with a regression test, not re-implement it.

**Alternatives considered**: Leaving it unredacted and merely documenting
the risk (rejected — this feature's entire purpose is closing exactly
this class of exposure, and shipping the same leak into every
`specjedi-*`-installed project via this feature's own bundle would be a
direct contradiction) — omitting the match value from the denial message
entirely (rejected — the file/line/description already narrow it down
enough that redacted characters still help a developer confirm which
finding is which without re-exposing the secret).

# Feature Specification: Expand Shareable Hooks — Push/Commit/Read Guards for `specjedi-*` Projects

**Feature Branch**: `058-expand-shareable-hooks`

**Created**: 2026-07-19

**Status**: Draft

**Input**: User description: "adicione hooks que ajudam no funcionamento
da specjedi para estar no release da proxima versão, revise quais
deveriam ser adicionados e podem ser uteis em um projeto que use
specjedi skills" (add hooks that help Spec Jedi function, to be in the
next release; review which ones should be added and could be useful in
a project that uses specjedi skills).

Grounding read before drafting: `specs/041-release-hooks-settings`
already built and shipped the exact mechanism this request needs —
`scripts/install.sh`/`.ps1` copies a curated "shareable" subset of this
repo's own `.claude/hooks/*` into any target project (currently just
`dangerous-command-guard.sh`/`.ps1`), rewritten for the target's own
paths and trunk branch, wired into the target's own `.claude/settings.json`,
behind an interactive default-yes prompt. That feature's own Assumptions
section already recorded the classification rule this request needs to
re-apply: **shareable** means "genuinely useful to *any* project,
doesn't depend on spec-jedi's own repo structure" — explicitly excluding
`skill-quality-guard.sh`/`cross-platform-parity-guard.sh` (they check
spec-jedi-repo-specific conventions a typical `specjedi-*`-consuming
project doesn't have) — and it deliberately scoped itself to *adapting
what already existed* at the time, not researching new candidates,
leaving that broader reading as explicit future work. This feature picks
up exactly that: since specs/041 shipped, three new hooks were built for
this repo's own use (`secret-scanner.py`, `conventional-commits.py`,
`prevent-direct-push.py`, all via `specjedi-master`, PR #151) plus a
desktop-notification `Stop` hook (PR #152) — this feature re-applies
specs/041's own shareability test to each and ships what qualifies
through the same, already-built mechanism.

**Additional grounding (2026-07-19, `specjedi-master` self-invocation)**:
a targeted review of this repo's own already-shipped secret-file
protection — `update_shared_settings()`'s `permissions.deny` list plus
`dangerous-command-guard.sh`'s Bash-level `.env`/`id_rsa`/`*.pem` check
— surfaced two real, externally-confirmed gaps, not hypothetical ones:
(1) the `permissions.deny` patterns use a root-anchored `./` prefix
(`Read(./.env)`), which gitignore-style glob semantics (confirmed at
code.claude.com/docs/settings) do not match against a nested file like
`packages/api/.env` — `Read(**/.env)` is the pattern that would; (2) a
publicized Claude Code bug report
([anthropics/claude-code#24846](https://github.com/anthropics/claude-code/issues/24846),
closed as duplicate, no confirmed fix date as of this writing) and an
independent reproduction by
[The Register](https://www.theregister.com/2026/01/28/claude_code_ai_secrets_files/)
both found `Read` calls succeeding against files matching configured
`permissions.deny`/`.claudeignore` patterns — meaning the declarative
list alone is not a dependable backstop, only `dangerous-command-guard.sh`-
style active `PreToolUse` denial (already proven for the `Bash` matcher)
is. No aitmpl.com-cataloged hook was found that already solves this
(the `/hooks` category has no populated secret-file-blocking entries as
of this review) — User Story 5 below hand-rolls an expanded pattern
list the same way `dangerous-command-guard.sh` itself was originally
built (adapted from disler/claude-code-hooks-mastery and
morphllm.com's `.env`-blocking guide, per that file's own header
comment), cross-checked against gitleaks' publicly documented default
filename/extension detection categories (`config/gitleaks.toml`) rather
than invented from scratch.

## Clarifications

### Session 2026-07-19

- Q: Does the documented `permissions.deny`/`Read` bug change how the new
  hook (FR-009) and the existing `permissions.deny` (FR-010) relate? →
  A: The new `PreToolUse` `Read`/`Grep`/`Glob`-matcher hook is the primary
  enforcement mechanism, unconditionally; `permissions.deny` is
  defense-in-depth only, and this feature does not gate on re-verifying
  the bug's current status first.
- Q: When `python3` is absent on the target machine, what should
  `install.sh`/`.ps1` do with the Python-based hooks? → A: Detect the
  absence, skip installing every Python-based hook, and print a named
  warning listing exactly which hooks were skipped and why.
- Q: How should `conventional-commits.py` be offered in the install
  bundle, given it's a stylistic convention rather than a pure safety
  net? → A: A separate, explicit Y/n interactive prompt just for this
  hook, shown after the main hooks/permissions prompt (which covers User
  Stories 1/2/5).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - `prevent-direct-push` reaches every `specjedi-*`-installed project (Priority: P1)

A project installs `specjedi-*` skills and, per `specjedi-implement`'s
own Never list, is expected to commit only through a feature branch and
pull request — never directly to the trunk branch. Today, nothing
technical enforces that expectation in a freshly-installed project; it's
discipline alone until a human or agent forgets.

**Why this priority**: This is the one candidate hook that doesn't just
happen to be generically useful — it directly mechanizes a rule
`specjedi-implement` already requires of every `specjedi-*`-using
project. Shipping it is the most literal reading of "hooks that help
specjedi function."

**Independent Test**: Given a freshly-installed project with
`prevent-direct-push.py` wired in, when an agent or human attempts
`git push origin <trunk-branch>` (or a bare `git push` while checked out
on the trunk branch), then the push is denied with a message naming the
PR-only workflow; when the same project pushes a feature branch instead
(including while locally checked out on the trunk branch, e.g. right
after a merge), the push succeeds.

**Acceptance Scenarios**:

1. **Given** a freshly-installed project on its detected trunk branch
   (`main`, `master`, or another name `install.sh`'s existing trunk
   detection resolves), **When** `git push origin <trunk>` or a bare
   `git push` is run, **Then** the push is denied.
2. **Given** the same project, **When** `git push origin
   <feature-branch>` is run — including while the current checkout is on
   the trunk branch — **Then** the push succeeds (the exact false-positive
   this repo's own copy was fixed to avoid, specs/none/PR #151).
3. **Given** a target project whose trunk branch isn't literally `main`
   or `master`, **When** the hook is installed, **Then** the installed
   copy's protected-branch set reflects the *target's own* detected
   trunk branch, not a hardcoded `main`/`develop` pair — reusing
   `install.sh`'s existing trunk-detection mechanism (specs/041 FR-002a),
   not a new detection method.

---

### User Story 2 - `secret-scanner` reaches every `specjedi-*`-installed project (Priority: P1)

Same class of value as the already-shipped `dangerous-command-guard.sh`
(specs/041): a pure safety net, no opinion imposed on the target
project's own conventions, genuinely useful regardless of what the
project is or does.

**Why this priority**: Equal priority to User Story 1 — both are
zero-opinion safety nets in the same tier as the hook specs/041 already
shipped; neither depends on the other.

**Independent Test**: Given a freshly-installed project with
`secret-scanner.py` wired in, when a commit is attempted with a staged
file containing something matching a real credential pattern, then the
commit is blocked; when a clean commit is attempted, it proceeds
unblocked.

**Acceptance Scenarios**:

1. **Given** a freshly-installed project, **When** `git commit` is run
   with a staged file containing a real-looking secret (e.g. a Stripe
   live key pattern), **Then** the commit is blocked with the specific
   pattern named.
2. **Given** the same project, **When** a clean commit (no matching
   pattern in any staged file) is attempted, **Then** it proceeds
   unblocked.
3. **Given** the hook's own source file is itself among the staged files
   (it contains literal secret-pattern strings as *detection patterns*,
   not real secrets), **When** committing changes to the hook itself,
   **Then** it does not block on its own pattern list — the self-
   exclusion this repo's own copy already needed (PR #151) MUST carry
   into the shared copy too, not be re-discovered per installation.
4. **Given** a blocked commit whose matched secret is longer than 8
   characters, **When** the denial message prints the matched value,
   **Then** it shows only the first and last 4 characters with the
   middle redacted (`sk-a****************3f2b`) — never the raw matched
   value (found by `specjedi-security` self-invocation, 2026-07-19: the
   pre-existing hook printed the full match to `stderr`, which is itself
   a secrets-into-agent-context/session-logs leak at the exact moment
   this hook exists to prevent one).

---

### User Story 3 - `conventional-commits` reaches every `specjedi-*`-installed project, opt-in (Priority: P2)

Unlike User Stories 1-2, this hook enforces a stylistic convention
(`type: description` commit messages) rather than a pure safety net —
this repo's own maintainer follows that convention, but nothing in the
`specjedi-*` pipeline itself (no Constitution principle, no
`specjedi-implement` requirement) mandates it project-wide the way
PR-only-trunk-commits is mandated. Shipping it default-on alongside
User Stories 1-2 would silently impose an opinion a target project may
not share.

**Why this priority**: Real value, but P2 because it's genuinely useful
to *projects that want it*, not to every project unconditionally the
way User Stories 1-2 are — resolved via a separate opt-in prompt (see
Clarifications) rather than default-on bundling.

**Independent Test**: Given a freshly-installed project that has opted
into this hook, when a non-conventional commit message is attempted,
then it's denied with the expected-format explanation; a project that
did not opt in never sees this behavior at all.

**Acceptance Scenarios**:

1. **Given** a project that opted in, **When** `git commit -m "fixed a
   thing"` is attempted, **Then** it's denied naming the required
   `type: description` format.
2. **Given** a project that did not opt in, **When** any commit message
   is used, **Then** nothing about this hook fires — no behavior change
   from today's baseline.

---

### User Story 4 - Desktop notification on response completion reaches installed projects (Priority: P3)

Generic UX value (know when a long-running turn finishes without
watching the terminal) — real, but the least "helps specjedi function"
of the four candidates; it's about the harness session generally, not
this project's pipeline specifically.

**Why this priority**: Lowest — nice to have, not load-bearing for
anything `specjedi-*` itself does.

**Independent Test**: Given a freshly-installed project with the `Stop`
hook wired in, when a response completes, then a native OS notification
fires (or silently no-ops on a platform with neither `osascript` nor
`notify-send`, never erroring).

**Acceptance Scenarios**:

1. **Given** a project with the hook installed on macOS or Linux,
   **When** a response completes, **Then** exactly one notification
   fires per response, not one per tool call.
2. **Given** a project with the hook installed on a platform with
   neither notification mechanism, **When** a response completes,
   **Then** nothing errors and nothing is shown.

---

### User Story 5 - Secret/credential file reads are actively blocked, not just declared (Priority: P1)

Today, protection against the AI reading a real `.env`/credential file
during a session is split across two mechanisms with real, documented
gaps: `permissions.deny` (root-anchored `./` patterns that miss a
nested file like `packages/api/.env`, and — per a publicized Claude
Code bug report and independent reproduction, see the grounding note
above — not reliably enforced for `Read` in all cases) and
`dangerous-command-guard.sh` (only fires on the `Bash` tool matcher, so
it stops `cat .env` but does nothing when the native `Read` tool opens
the same file directly). Neither alone is a dependable backstop for the
scenario this matters most for: an agent — possibly steered by a
prompt-injection attempt embedded in a file it's already reading —
opening a real secrets file and exposing its contents into the
conversation.

**Why this priority**: Equal to User Stories 1-2 — a zero-opinion
safety net every `specjedi-*`-installed project benefits from
regardless of what it is, closing a documented, publicly-reported gap
rather than a hypothetical one.

**Independent Test**: Given a freshly-installed project with this hook
wired in, when the agent attempts `Read`/`Grep`/`Glob` against a file
matching a real secret/credential pattern — at the project root or
nested in a subdirectory — then the call is denied; the same tools used
on an unrelated file proceed unblocked.

**Acceptance Scenarios**:

1. **Given** a freshly-installed project, **When** the `Read` tool
   targets `.env` at the project root, **Then** the call is denied with
   a message naming the file as a likely secret.
2. **Given** the same project, **When** the `Read` tool targets a
   nested `packages/api/.env` (not at the project root), **Then** the
   call is denied identically — the false-negative class the existing
   root-anchored `./` `permissions.deny` patterns miss today.
3. **Given** the same project, **When** the `Read` tool targets
   `.env.example`/`.env.sample`/`.env.template`, **Then** it is NOT
   blocked — the same template-exclusion precedent
   `dangerous-command-guard.sh`'s own Bash-level check already
   establishes.
4. **Given** the same project, **When** `Read`/`Grep`/`Glob` targets a
   file elsewhere in the repo with no secret-like name, **Then** it
   proceeds unblocked.

### Edge Cases

- **A target project that already has its own `PreToolUse`/`Stop` hooks
  array** (specs/041's own existing edge case, generalized): `install.sh`
  today prints "add manually, not overwritten automatically" naming only
  `dangerous-command-guard.sh` for this exact scenario — that message
  MUST name every newly-shareable hook this feature adds too, not just
  the original one, or a target with pre-existing hooks silently misses
  the new ones with no signal at all.
- **`python3` availability**: `dangerous-command-guard.sh` (bash, zero
  runtime dependency beyond bash itself) matches Principle XVIII's
  zero-footprint posture directly. `secret-scanner.py`/
  `conventional-commits.py`/`prevent-direct-push.py` all require `python3`
  on the target machine — near-universal on macOS/Linux, less certain on
  a bare Windows environment with no Python installed. Resolved — see
  Clarifications: `install.sh`/`.ps1` MUST detect `python3`'s absence and
  skip installing every Python-based hook, printing a named warning
  listing exactly which hooks were skipped, rather than installing
  something that silently no-ops or errors on every invocation.
- **A non-`claude-code` harness with only partial hook-mechanism support**
  (e.g. `gemini-cli`/`antigravity`'s existing translated `BeforeTool`
  hook adaptation, specs/041 User Story 2): the new hooks MUST flow
  through those same already-built per-harness adaptation functions
  (`install_hooks_gemini_cli`, `install_hooks_antigravity`, etc.), never
  a second, parallel per-harness mechanism invented for just the new
  hooks.
- **`permissions.deny` reliability** (User Story 5): the publicized
  Claude Code issue this feature's grounding note cites was closed as a
  duplicate with no confirmed fix date visible from outside the
  Anthropic tracker. Resolved — see Clarifications: the new
  `PreToolUse` `Read`/`Grep`/`Glob`-matcher hook (FR-009) is the primary
  enforcement mechanism, unconditionally; `permissions.deny` (FR-010) is
  defense-in-depth only and this feature does not gate on re-verifying
  the bug's current status before shipping either layer.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The shareable-hooks bundle MUST add `prevent-direct-push.py`
  (adapted, not the aitmpl.com vendor original — this repo's own copy
  already fixed a real false-positive bug in the vendor version, PR
  #151), with its protected-branch set adapted at install time to the
  target's own detected trunk branch, reusing `install.sh`'s existing
  `detect_trunk_branch` mechanism (specs/041 FR-002a) rather than a new
  detection method.
- **FR-002**: The shareable-hooks bundle MUST add `secret-scanner.py`
  from this repo's own copy (already self-contained, zero
  repo-specific paths, already carries its own self-exclusion fix from
  PR #151), with the redaction fix from FR-012 below applied before it
  ships.
- **FR-003**: `conventional-commits.py` MUST be offered via a second,
  separate interactive Y/n prompt shown after the main hooks/permissions
  prompt (the one covering User Stories 1/2/5) — never bundled into that
  same default-on prompt, and never excluded from the installer entirely.
  A "no" answer (or no answer) MUST leave the target project completely
  unchanged with respect to this hook.
- **FR-004**: The desktop-notification `Stop` hook MAY ship in the same
  bundle, Priority P3 — lowest priority among the four candidates, may
  be deferred to a follow-up without blocking User Stories 1-2.
- **FR-005**: `install.sh`/`.ps1` MUST detect whether `python3` is
  available on the target machine before installing any Python-based
  hook. If absent, it MUST skip installing every Python-based hook
  (including any Python-based FR-009 implementation) and print a named
  warning listing exactly which hooks were skipped and why — never
  install something silently non-functional (Principle XX).
- **FR-006**: The existing "target already has a `PreToolUse`/`Stop`
  hooks array — add manually" message MUST name every newly-shareable
  hook this feature adds (not just `dangerous-command-guard.sh`, which
  it names today) when that scenario is hit.
- **FR-007**: Every newly-shareable hook MUST reach every harness
  specs/041 User Story 2 already adapted hooks for, through that same
  adaptation mechanism — never a new, parallel per-harness path.
- **FR-008**: `dangerous-command-guard.sh`/`.ps1`'s already-shipped
  install behavior MUST NOT regress.
- **FR-009**: The shareable-hooks bundle MUST add a `PreToolUse` hook
  matching the `Read`/`Grep`/`Glob` tools that denies any call whose
  target path matches a well-established secret/credential filename
  pattern — at minimum `.env`/`.env.*` (excluding `.env.example`/
  `.env.sample`/`.env.template`), `id_rsa`/`id_dsa`/`id_ecdsa`/
  `id_ed25519`, `*.pem`/`*.key`/`*.pfx`/`*.p12`, `.npmrc`, `.netrc`,
  `.pgpass`, `.git-credentials`, `.aws/credentials`,
  `.docker/config.json` — matched at any directory depth, not
  root-anchored only.
- **FR-010**: The existing `permissions.deny` patterns in
  `update_shared_settings()` MUST be broadened from root-anchored
  (`./...`) to recursive (`**/...`) matching, and expanded to the same
  file-pattern set as FR-009, as defense-in-depth alongside the new
  hook (FR-009) — never as a replacement for it, per the reliability
  gap this feature's grounding note documents.
- **FR-011**: The new `Read`/`Grep`/`Glob`-blocking hook (FR-009) MUST
  reach every harness specs/041 User Story 2 already adapted hooks for,
  through that same adaptation mechanism — never a new, parallel
  per-harness path (same rule as FR-007, applied to this hook).
- **FR-012**: `secret-scanner.py`'s denial message MUST redact the
  matched secret value (first 4 + last 4 characters, `*` for everything
  between; fully `*`-masked when 8 characters or shorter) before
  printing it, rather than the raw matched substring the pre-existing
  hook prints today — a real leak surfaced by this plan's
  `specjedi-security` self-invocation, fixed here before this hook
  reaches every `specjedi-*`-installed project via this feature's own
  bundle.

### Key Entities

*(Not applicable — this feature changes install-time file-copying
behavior; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A fresh `specjedi-*` install on a project with a
  non-`main`/`master` trunk branch name correctly blocks a direct push
  to that project's own actual trunk branch — verifiable by attempting
  the push and confirming denial.
- **SC-002**: The same fresh install does not block a push to a feature
  branch made while the current checkout is on the trunk branch —
  verifiable by attempting that specific push and confirming success
  (the false-positive class this feature must not reintroduce).
- **SC-003**: A commit containing a real-looking credential pattern is
  blocked on a fresh install with `secret-scanner.py` present —
  verifiable by attempting such a commit and confirming denial.
- **SC-004**: `scripts/validate.sh` continues to pass after this
  feature's changes, on all three CI-matrixed operating systems.
- **SC-005**: A `Read`/`Grep`/`Glob` call targeting a nested secret file
  (e.g. `packages/api/.env`, not at the project root) is denied on a
  fresh install — verifiable by attempting that call and confirming
  denial, closing the specific root-anchoring gap `permissions.deny`
  has today.
- **SC-006**: A `Read` call targeting `.env.example` on a fresh install
  is NOT denied — verifiable by attempting the read and confirming
  success, the specific false-positive class this feature must not
  introduce.

## Assumptions

- This feature reuses `specs/041-release-hooks-settings`'s entire
  existing mechanism (interactive prompt, path/branch rewriting,
  per-harness adaptation, `.claude/settings.json` wiring) — it does not
  redesign or replace any part of that mechanism, only extends which
  hooks flow through it.
- The four candidates evaluated here (`secret-scanner.py`,
  `conventional-commits.py`, `prevent-direct-push.py`, the `Stop`
  notification hook) are exactly the hooks this repo added to its own
  `.claude/hooks/`/`.claude/settings.json` since specs/041 shipped
  (PRs #151/#152) — this feature does not commission research into
  further, not-yet-built candidates, matching specs/041's own
  established scoping precedent.
- User Story 5 is the one exception to the assumption above: it is not
  an existing hook already built for this repo's own use, but a new
  hook this feature commissions directly, grounded in the external
  research this spec's own grounding note documents (a publicized
  Claude Code `permissions.deny`/`Read` reliability gap, plus
  gitleaks' publicly documented default secret-filename/extension
  categories) rather than in an existing in-repo precedent — flagged
  explicitly since it breaks the otherwise-uniform "adapt what already
  exists" framing the rest of this spec follows.
- `skill-quality-guard.sh`/`cross-platform-parity-guard.sh` remain
  repo-internal-only, unchanged from specs/041's own classification —
  re-confirmed here, not re-litigated, since neither was added or
  changed since that classification was made.

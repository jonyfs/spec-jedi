# Phase 0 Research: Harness Auto-Detection

## Decision: bash 3.2 compatibility — indexed arrays only, no associative arrays

**Decision**: Detection state is tracked as an indexed bash array of
`"harness:signal-type:evidence"` string tuples, never `declare -A`.

**Rationale**: Verified directly on this machine: `/bin/bash --version`
reports `GNU bash, version 3.2.57(1)-release` (macOS's shipped system
bash — Apple has frozen it at this GPLv2-licensed version for over a
decade). Associative arrays (`declare -A`) require bash 4+, unavailable
unless a user has separately installed a newer bash via Homebrew and put
it first on `PATH`. Since `scripts/install.sh` starts with
`#!/usr/bin/env bash`, it resolves to whatever `bash` is first on the
invoker's `PATH` — which may be the ancient system one. This project's
own existing scripts (`install.sh`, `validate.sh`) already avoid bash 4+
features for exactly this reason; this feature follows the same
constraint rather than introducing the first exception.

**Alternatives considered**: `declare -A` keyed by harness name for
cleaner lookup code. Rejected — would silently break on any macOS user
running the system default bash, the exact audience most likely to be
running this installer without a customized shell setup.

## Decision: TTY detection via `[ -t 0 ]` (bash) / `[Console]::IsInputRedirected` (PowerShell)

**Decision**: Before prompting interactively on ambiguous detection,
check `[ -t 0 ]` in bash (POSIX-standard: true if file descriptor 0/stdin
is connected to a terminal) and `-not [Console]::IsInputRedirected` in
PowerShell.

**Rationale**: Both are the standard, documented mechanism for exactly
this check in their respective shells — no third-party dependency, no
platform-specific edge case beyond what each shell's own runtime already
handles. This is the same test `git`, `npm`, and most interactive-capable
CLI tools use to decide whether to prompt or fall back to a
non-interactive default, so it's a well-trodden pattern, not a novel one.

**Alternatives considered**: Checking a `CI` or `GITHUB_ACTIONS`
environment variable instead. Rejected as the primary signal — those
only cover CI specifically, not every non-interactive invocation (e.g. a
piped script, a cron job, a subprocess spawned by another tool without a
TTY) that `[ -t 0 ]` correctly catches in one check.

## Decision: binary detection via `command -v` (bash) / `Get-Command` (PowerShell)

**Decision**: `command -v claude >/dev/null 2>&1` / `command -v codex
>/dev/null 2>&1` for the two harnesses with a plausible CLI binary;
`Get-Command claude -ErrorAction SilentlyContinue` / `Get-Command codex
-ErrorAction SilentlyContinue` on the PowerShell side.

**Rationale**: `command -v` is POSIX-specified and portable across every
shell this project already assumes (unlike `which`, which is not POSIX
and behaves inconsistently across platforms — notably absent by default
on some minimal Docker/CI images). `Get-Command` is PowerShell's own
documented equivalent.

## Decision: signal priority order — target-directory > PATH binary > global config

**Decision**: When ranking multiple matched harnesses to pick the
Recommended one, a target-directory match (this exact project already
has `.claude/`/`.agents/`/`.trae/`) outranks a `PATH` binary match, which
outranks a global config directory match (`~/.claude`/`~/.codex`/`~/.trae`).

**Rationale**: A target-directory match is the strongest, most specific
signal — it means *this project* was already configured for that
harness, not just that the harness is installed somewhere on the
machine. A `PATH` binary is stronger than a bare global config directory
existing, since a config directory can persist after uninstall or be
created by an unrelated process, while a working binary on `PATH`
implies the tool is actually usable right now.

## Decision: `trae` has no binary-detection signal

**Decision**: `trae`'s detection relies only on directory signals
(target-local `.trae/`, global `~/.trae/`) — no `PATH` binary check.

**Rationale**: Trae is a GUI-first IDE (confirmed during feature 019's
own research into its Skills convention) with no established,
cross-platform CLI binary name to check reliably — inventing one would
be guessing, which Constitution Principle XX forbids. Documented
explicitly in spec.md's Assumptions rather than silently giving `trae`
a narrower signal set with no explanation.

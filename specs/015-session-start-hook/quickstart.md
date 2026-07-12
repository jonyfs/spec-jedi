# Quickstart: Verifying the Session-Start Orientation Hook

**Feature**: 015-session-start-hook

Validation scenarios proving this feature actually works — not just that
the script runs, but that a real session renders the greeting (User
Story 3's whole point).

## Prerequisites

- `scripts/session-start.sh` (and `.ps1` counterpart) implemented
- `.claude/settings.json` registers the hook under `SessionStart`
- `CLAUDE.md` carries the render instruction

## Scenario 1: The script produces valid, capped output standalone

```bash
bash scripts/session-start.sh | wc -c
# Expected: a number well under 10000
bash scripts/session-start.sh
# Expected: an ASCII banner, a status summary line, and one Yoda line —
# all readable directly, no errors
```

## Scenario 2: Status summary matches specjedi-status's own derivation

```bash
bash scripts/session-start.sh | grep -oE '[0-9]+ features?'
# Manually cross-check this count against a real specjedi-status run
# (or the actual `ls -d specs/*/` count) for the same repo state —
# Expected: they agree
```

## Scenario 3: Rotation is observable

```bash
for i in 1 2 3 4 5; do
  bash scripts/session-start.sh | tail -1
  sleep 1
done
# Expected: not all 5 lines identical
```

## Scenario 4: Graceful degradation on failure

```bash
# Temporarily break the script (e.g., rename references/star-wars-lexicon.md)
mv references/star-wars-lexicon.md references/star-wars-lexicon.md.bak
bash scripts/session-start.sh; echo "exit: $?"
mv references/star-wars-lexicon.md.bak references/star-wars-lexicon.md
# Expected: script still exits 0 (or at least doesn't hang/crash the
# calling process) and produces a plainer fallback greeting, not an error
# that would block a session from starting
```

## Scenario 5: Real end-to-end render (the one that actually matters — SC-003)

This is not scriptable in the usual sense — it requires starting an
actual fresh Claude Code session in this repo and observing the
assistant's first reply.

**Expected**: the assistant's opening message includes the ASCII banner,
an accurate status summary, and a Yoda-styled line — rendered as visible
chat text, not left silent in hook logs. This is the single most
important verification in this feature, since a hook that runs correctly
but is never rendered delivers zero user-facing value (User Story 3).

## Scenario 6: PowerShell counterpart parity

```powershell
pwsh scripts/session-start.ps1
# Expected: same three-part output shape as the bash version
```

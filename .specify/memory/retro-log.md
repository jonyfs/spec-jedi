# Retro Log

Durable, cross-session record of retrospectives run by `specjedi-retro`
against completed features — every run appends an entry here, including a
clean match with zero deviations, so the log stays a complete history of
what actually shipped versus what each feature's `plan.md` predicted.

- 2026-07-19: 058-expand-shareable-hooks — 3 deviations, all grounded (see
  full retrospective below).
- 2026-07-21: 064-multi-agent-orchestration-skill — no deviations
  (658e996).

## Retrospective: 058-expand-shareable-hooks

Three real deviations from `plan.md`, all grounded in specific commits —
no invented causes.

1. **`prevent-direct-push.py`'s trunk-substitution isn't the same
   mechanism as `dangerous-command-guard.sh`'s.** `plan.md` assumed both
   hooks shared the identical sed-based substitution technique. The
   actual file uses Python set-literal syntax (`PROTECTED = {"main",
   "develop"}`), which the existing bash-pattern substitution can't
   produce — commit `d1efcac` ("ship prevent-direct-push.py in the
   shareable-hooks bundle") introduced a dedicated
   `build_python_protected_set()` helper instead. Found and corrected
   during implementation, documented transparently in `tasks.md`'s own
   T012 verification note rather than silently patched over.

2. **Five distinct, real CI root causes on Windows, none anticipated by
   `plan.md`.** The plan's Constitution Check assumed the existing
   cross-platform CI pattern would just work for the new Python hooks.
   In practice, testing `python3` absence on Windows runners broke five
   separate ways in sequence — UTF-8 file-encoding defaults (`cp1252`),
   a `printf`-as-builtin shadow-PATH gap, MSYS2 DLL resolution breaking
   on symlinked binaries, PATH-directory filtering removing unrelated
   co-located tools, and finally a permissions wall (no root on hosted
   runners) — each diagnosed from real job logs and fixed in sequence:
   commits `e0e909b`, `099ace2`, `c076f71`, and `efcc28d` (the last of
   which replaced every prior filesystem-mutation attempt with the
   `SPECJEDI_TEST_FORCE_NO_PYTHON3` environment-variable seam that
   actually shipped). `plan.md` was never amended afterward to record
   this discovery — the seam pattern lives only in `tasks.md`'s
   verification notes and the code itself.

3. **`merge_json_key()`/`Merge-JsonKey` needed relocating in both
   `install.sh` and `install.ps1` for the Stop-hook wiring to work at
   all.** `plan.md`'s Implementation notes (lines 281-303) said to "call
   it directly," implying the existing call site would just work.
   Neither bash nor PowerShell hoist top-level function definitions, and
   the Stop-hook wiring's new call site sat *before* the function's own
   textual definition in both scripts — a real "command not found"/"not
   recognized" runtime error, not a hypothetical. Fixed by moving both
   functions immediately after `update_shared_settings()`/
   `Update-SharedSettings` (commits within `8f9cea3`, "wire a Stop-hook
   desktop notification into shareable installs"). Recorded honestly in
   `tasks.md`'s T053/T054 notes as "Real bug found and fixed during
   implementation" — never silently folded into the feature's own
   narrative as if it had been planned.

All three deviations are implementation-detail discoveries, not scope or
design changes — every user story shipped exactly as `spec.md` described
it (US1 prevent-direct-push, US2 secret-scanner, US3 conventional-commits
opt-in, US4 Stop notification, US5 secret-file-guard), across two PRs
(#158 MVP, #159 US3+US4+Polish), both fully green on first CI attempt
after the fixes above landed.

## Retrospective: 064-multi-agent-orchestration-skill

Matched the plan, no deviations. Shipped as a single squash commit
(658e996, PR #175, merged 2026-07-21T02:56:15Z) containing exactly the
four files `plan.md`'s Project Structure named:
`.claude/skills/specjedi-orchestrate/SKILL.md`,
`references/multi-agent-capability-notes.md`, and the
`specs/064-multi-agent-orchestration-skill/` documentation set
(spec.md/plan.md/research.md/tasks.md) — no additional files, no dropped
scope. `tasks.md` finished at 20/20 `[x]`. `specjedi-govcheck` reported
CLEAN (22/22 reasoned, 0 findings) and `specjedi-analyze` traced all 9
functional requirements to Verified with zero orphaned files, both
pre-merge — no post-hoc fixes were needed on this branch.

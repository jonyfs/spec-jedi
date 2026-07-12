# Phase 0 Research: Trae Harness Support

## Decision: Trae's Skills discovery convention

**Decision**: Trae discovers skills from a project-local
`.trae/skills/<name>/SKILL.md` directory structure, using the same open
Agent Skills standard as Claude Code (YAML frontmatter with `name` and
`description`).

**Rationale**: Three independent sources converge on the same convention:

1. **Trae's official Skills documentation**
   (`docs.trae.ai/ide/skills`) describes Skills as folders — "often in
   your project's `.trae/skills` directory" — containing a required
   `SKILL.md` file, discovered by Trae reading each skill's name and
   description at startup and loading full instructions on demand.
2. **Community documentation** (`HighMark-31/TRAE-Tips`,
   `Agents-Rules-Skills.md`) independently confirms the same split:
   Rules live in `.trae/rules/` (always active), Skills live in
   `.trae/skills/` (loaded on demand) — a genuinely separate mechanism
   from the Rules-only picture an initial, narrower documentation check
   would have found (the same class of near-miss feature 018's research
   caught for Warp).
3. **Authoritative, first-party confirmation**: Vercel's own `skills`
   CLI (`vercel-labs/skills`, `src/agents.ts`) — the tool that installs
   real skills into real Trae installations for its own users — hardcodes:
   ```ts
   trae: {
     name: 'trae',
     displayName: 'Trae',
     skillsDir: '.trae/skills',
     globalSkillsDir: join(home, '.trae/skills'),
     ...
   }
   ```
   This is an executable specification, not a documentation claim — if
   it were wrong, the CLI's own users' installed skills wouldn't work in
   Trae and the maintainers would have a stream of bug reports about it.

**Alternatives considered**: Installing to `.claude/skills/` or
`.agents/skills/` and hoping Trae also scans one of those (the
zero-new-code pattern from features 017/018). Rejected — none of the
three sources above describe Trae scanning either existing directory;
`.trae/skills/` is its own convention, so this feature genuinely needs a
new installer branch, the same shape as feature 016 (Codex CLI).

## Research correction: a contradictory bug report, investigated

**What was found**: GitHub issue `Trae-AI/TRAE#2253` ("Support
Superpowers and other SKILL.md-based skill ecosystems"), filed
2026-02-17, still open as of this research. On first read this looked
like direct evidence *against* this feature's premise — the reporter
states Trae "cannot recognize or use skill ecosystems... based on the
SKILL.md file format" and that a symlink into Trae's skills folder
"doesn't work."

**Investigation**: Reading the issue's actual reproduction steps (not
just its summary) shows the reporter's symlink command was:

```powershell
mklink /J "%APPDATA%\Trae CN\skills\superpowers" "~\.trae\superpowers\skills"
```

This targets a **global**, Windows-`AppData`-rooted path for the
**"Trae CN"** variant. Per `vercel-labs/skills`'s own agent config, the
`trae-cn` variant's actual global directory is
`join(home, '.trae-cn/skills')` — not `%APPDATA%\Trae CN\skills\`. The
reporter's own symlink target does not match either the `trae` or
`trae-cn` agent's documented directory (project-local `.trae/skills/`,
or global `~/.trae/skills` / `~/.trae-cn/skills`). A symlink placed at
the wrong path failing to be discovered is expected behavior, not
evidence that the documented convention doesn't work.

**Resolution**: The negative report is not treated as refuting the
`.trae/skills/` project-local convention this feature targets — it's a
path-mismatch bug report, most likely explained by the reporter testing
an unofficial/guessed path rather than the one Trae and the `skills` CLI
actually document. This feature proceeds on the three-source-converged
finding above, with this correction recorded rather than silently
dropped (Principle XX — don't discard a contradictory finding without
explaining why it doesn't hold).

**What this feature does NOT resolve**: whether Trae's *separate*
`npx skills`-CLI-integrated marketplace/registry flow (the other
half of the same GitHub issue, and the mechanism the issue's reporter
was actually most focused on) behaves identically to a raw directory
scan. Out of scope — this feature targets the same class of
file-placement claim already proven for the other four harnesses
(does a `SKILL.md` dropped at the documented path get discovered), not
Trae's registry/marketplace mechanics.

## Decision: `specjedi-*` skill content requires no changes

**Decision**: No skill content needs rewriting for Trae.

**Rationale**: Re-ran the same grep audit performed for feature 016
(`grep -rli "claude code\|claude-code\|codex-cli\|opencode\|warp"` across
all `specjedi-*` `SKILL.md` files) — zero matches. No skill hardcodes a
harness-specific reference that would need Trae-specific handling.

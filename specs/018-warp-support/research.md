# Research: Warp Harness Support

**Feature**: 018-warp-support

**Constitution gate**: [Principle II](../../.specify/memory/constitution.md).
Same shape of question as feature 017: does Warp's own documented
convention already match an existing install target — verified
precisely, including a real correction found mid-research.

## A real grounding correction, documented per Principle XX

The first research pass checked only Warp's **Rules** documentation
(`docs.warp.dev/agent-platform/capabilities/rules/`) and found: Warp
reads a single flat `AGENTS.md`/`WARP.md` file (project root and
subdirectories), plus a one-time-linked set of external files
(`CLAUDE.md`, `.cursorrules`, etc.). No directory-based skills discovery
was documented on that page. This suggested Warp would need genuinely
new install logic — likely a content-concatenation or router-file
strategy, a materially harder problem than features 016/017.

**That finding was incomplete, not wrong** — Warp has a **separate**
Skills capability, documented on its own page
(`docs.warp.dev/agent-platform/capabilities/skills/`), distinct from
Rules. Checked directly before writing this spec: Warp's Skills system
scans **ten** directory names at project root (recommended `.agents/
skills/`, plus `.warp/skills/`, `.claude/skills/`, `.codex/skills/`,
`.cursor/skills/`, `.gemini/skills/`, `.copilot/skills/`, `.factory/
skills/`, `.github/skills/`, `.opencode/skills/`), with the same global-
scope equivalents under home-directory variants. Its own docs state
directly: "Warp scans all supported skill directory names in your
project root, allowing you to maintain skills compatible with multiple
AI coding tools in the same repository."

**Corrected conclusion**: Warp needs zero new install logic, exactly
like OpenCode (feature 017) — two of its ten scanned directories are
`.claude/skills/` and `.agents/skills/`, the exact paths the existing
`claude-code`/`codex-cli` install paths already write to.

This correction is recorded here explicitly rather than silently
discarding the first, incomplete finding — the mistake (checking only
one of two relevant doc pages) and its fix are both part of this
feature's actual grounding trail.

## SKILL.md format, verified

Two mandatory frontmatter fields per Warp's own docs: `name` ("a unique
identifier for the skill, typically kebab-case") and `description` ("a
brief explanation of what the skill does and when to use it"). Every
`specjedi-*` skill already carries both.

## Naming rule, re-verified for this specific harness

Warp's phrasing ("typically kebab-case") is softer than OpenCode's exact
regex rule, but every `specjedi-*` skill name was already re-checked
against the stricter OpenCode rule in feature 017's research and found
compliant — a strict-subset relationship means Warp's own, looser
requirement is automatically satisfied too. Re-confirmed directly:

```bash
for dir in .claude/skills/specjedi-*/; do
  name="$(basename "$dir")"
  echo "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || echo "INVALID: $name"
done
```

Zero output — all compliant.

## Decision

No new installer branch, same as feature 017. Add a CI job asserting
both existing install paths against Warp's specific documented Skills
rules, update README, explicitly correct the record on which Warp
mechanism (Skills, not Rules) this feature actually addresses.

## What this feature does NOT attempt

Running Warp itself — not available in this environment. Verification is
structural, matching features 016/017's honest scoping. This feature
also does not build anything for Warp's separate Rules
(`AGENTS.md`/`WARP.md`) mechanism — that remains a genuinely different,
unaddressed capability gap (a flat-file consolidation problem), tracked
as a note for a future feature if ever prioritized, not conflated with
what this feature actually ships.

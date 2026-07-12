# Data Model: Codex CLI Install Path

**Feature**: 016-codex-cli-install

No persisted entities — this feature extends an existing CLI script's
internal branch logic. The only "model" worth naming is the mapping the
installer's `--harness` flag now resolves to.

## Harness Target

| `--harness` value | Skill install location | Status before this feature | Status after |
|---|---|---|---|
| `claude-code` | `<target>/.claude/skills/<skill-name>/` | ✅ Supported | ✅ Supported (unchanged) |
| `codex-cli` | `<target>/.agents/skills/<skill-name>/` | 📋 Planned (rejected by installer) | ✅ Supported |
| any other value | N/A | Rejected with informative message | Rejected with informative message (unchanged) |

Both supported targets share:

- The same source skills (`.claude/skills/specjedi-*/` in this repo,
  unmodified content per `research.md`'s grep-audit finding)
- The same four `.specify/templates/*.md` runtime dependencies
- The same post-copy frontmatter validation logic (YAML delimiters,
  `name:`, `description:`)

Only the target subdirectory name differs between the two.

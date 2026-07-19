# aitmpl.com Browsing Playbook

Exact URL/filter mechanics for browsing aitmpl.com's catalog —
referenced by `specjedi-master` rather than restated inline. Grounded in
this project's own real browsing session (feature 049/052's own
research), not guessed.

## The six categories this project's own skills browse

`specjedi-master` scopes itself to exactly these — never MCPs or plugin
marketplaces:

| Category | Listing page | Individual component URL pattern |
|---|---|---|
| Skills | `aitmpl.com/skills` | `aitmpl.com/component/skill/<category>/<name>` |
| Agents | `aitmpl.com/agents` | `aitmpl.com/component/agent/<category>/<name>` |
| Commands | `aitmpl.com/commands` | `aitmpl.com/component/command/<category>/<name>` |
| Settings | `aitmpl.com/settings` | `aitmpl.com/component/setting/<category>/<name>` |
| Hooks | `aitmpl.com/hooks` | `aitmpl.com/component/hook/<category>/<name>` |
| Loops | `aitmpl.com/loops` | `aitmpl.com/component/loop/<category>/<name>` |

## Why the live site alone isn't enough

The listing pages (`aitmpl.com/<category>`) render their actual
component inventory via client-side JavaScript after page load — a
plain `WebFetch` of the static HTML returns only the page shell
("Loading components... Preparing your experience") not the real
catalog. Two working alternatives, in order of preference:

1. **`WebSearch` for a specific component name** (e.g. `"aitmpl.com
   hooks quality-gates"`) — search-engine indexing has already crawled
   individual component pages, which do carry real content unlike the
   listing shell.
2. **Browse the underlying GitHub source tree directly**:
   `github.com/davila7/claude-code-templates/tree/main/cli-tool/
   components/<category>/` — this is the actual source aitmpl.com's own
   site is generated from, and `WebFetch` against a GitHub tree URL
   reliably returns the real directory listing. Individual component
   files (`.json` config + a paired `.sh`/`.py`/`.md`) can then be
   fetched directly via `raw.githubusercontent.com/davila7/claude-code-
   templates/main/cli-tool/components/<category>/<subcategory>/
   <file>.json`.

## Known subcategories (as of this writing)

- **hooks/**: `automation`, `development-tools`, `git-workflow`, `git`,
  `monitoring`, `performance`, `post-tool`, `pre-tool`, `quality-gates`,
  `security`, `testing`.
- **settings/**: `api`, `authentication`, `cleanup`, `environment`,
  `git`, `global`, `hooks`, `mcp`, `model`, `partnerships`,
  `permissions`, `statusline`, `telemetry`.

This list is illustrative, not exhaustive or permanently fixed — the
catalog grows; re-browse the GitHub tree directly rather than trusting
this table indefinitely.

## Filter discipline (Constitution Principle II/`specjedi-master` Step 3)

Before presenting any candidate found this way: check domain fit first
(reject anything built for a domain the target project doesn't have),
then harness fit (aitmpl.com's own hooks/settings/commands are
Claude-Code-formatted by default — flag, don't silently assume, when
the target harness differs).

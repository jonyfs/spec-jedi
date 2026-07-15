# aitmpl.com Browsing Playbook

Mechanics for `specjedi-master`'s Step 2, confirmed by direct browsing
during this skill's own research (2026-07-15) — not guessed from the
homepage alone, since the site is a client-rendered SPA and a plain
`WebFetch` returns an empty shell.

## Category URLs

| Category | URL | Component count (at research time) |
|---|---|---|
| Skills | `https://www.aitmpl.com/skills` | ~330+ |
| Agents | `https://www.aitmpl.com/agents` | 421 |
| Commands | `https://www.aitmpl.com/commands` | 281 |
| Settings | `https://www.aitmpl.com/settings` | 68 |
| Hooks | `https://www.aitmpl.com/hooks` | 39+ |
| Loops | `https://www.aitmpl.com/loops` | 18 |

Never browse `/mcps` or `/plugins` for this skill's purpose — out of
scope per the SKILL.md's own Step 2 (MCP setup and plugin-marketplace
adoption are separate conversations, not proactive suggestions).

## How to actually read the catalog

The site needs a real browser (`mcp__claude-in-chrome__*` tools) or
`WebSearch`/targeted `WebFetch` against a specific component's own
GitHub source — a bare `WebFetch` of a listing page returns only nav
chrome, not the component grid (client-side rendered, loads after an
initial "Loading components..." state).

Each category page supports:
- A category filter dropdown (`All categories` plus category-specific
  values — e.g., Settings' categories are `api`, `authentication`,
  `cleanup`, `environment`, `git`, `global`, `hooks`, `mcp`, `model`,
  `partnerships`, `permissions`, `statusline`, `telemetry`).
- Sort: `Most Popular` (download-count-ordered, the useful default for
  ranking) or `Alphabetical`.
- A free-text search box (`Search components...`) — faster than paging
  through category filters when the project's domain is specific (e.g.
  searching "git" surfaces git-workflow commands across every category
  in one pass).
- Pagination (`Previous`/`1 / N`/`Next`) — for a project with a narrow,
  specific need, the category filter + search combination usually
  surfaces the relevant handful within the first page; don't page
  through hundreds of generic entries once the top-sorted, filtered
  results have already turned up nothing project-relevant.

## Getting a component's exact install content

The catalog's own card view only shows name/description/category/
download-count — not the actual JSON/script content. For anything
being seriously proposed (not just mentioned), fetch the real source
before describing it, the same way this project's own research did for
the Hooks/Settings features:

1. Identify the backing repo — `github.com/davila7/claude-code-templates`
   for aitmpl.com's own first-party catalog; a plugin/marketplace
   listing (`/plugins`, out of this skill's scope) points elsewhere.
2. `gh api repos/davila7/claude-code-templates/contents/cli-tool/components/<category>`
   to list real filenames (kebab-case, matching the display name).
3. `gh api repos/davila7/claude-code-templates/contents/cli-tool/components/<category>/<file>.json --jq '.content' | base64 -d`
   for the actual JSON/script payload.

Never describe a candidate's mechanics from the card blurb alone if it's
being seriously proposed — the blurb is marketing copy, not a spec; the
real content is what step 4 (SKILL.md) needs to state the concrete gain
accurately.

## Domain-fit heuristics learned from this project's own research

Applying these before presenting anything (SKILL.md Step 3):

- **Agents and most Commands skew toward generic application
  development** (frontend/backend/database/deployment roles; Docker,
  Supabase, test-generation workflows). A project with no
  frontend/backend/database of its own gets essentially nothing from
  these two categories — don't force a fit.
- **Settings and Hooks are more broadly applicable** — git-workflow
  visibility, permission presets, and safety guards apply to nearly any
  git-based project regardless of language/domain.
- **Loops are workflow-shaped, not domain-shaped** — a
  build-test-fix loop or a docs-sweep loop fits any project with tests
  or docs respectively; a perf-budget loop only fits one with an actual
  performance target already defined. Read the loop's own stop
  condition before proposing it — a loop with no clear, checkable stop
  condition is a worse fit than one with an explicit one, regardless of
  category.
- **MCPs skew toward external-service integration** (databases, browser
  automation, ads platforms) — explicitly out of this skill's scope
  (SKILL.md Step 2), since adopting one is usually a bigger,
  credential-bearing decision better handled as its own conversation.

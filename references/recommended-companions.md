# Recommended Companions

The constitution ([Principle VIII](../.specify/memory/constitution.md)) has
every Spec Jedi session proactively suggest — but never silently
install — two token-saving tools:

- [`rtk`](https://github.com/rtk-ai/rtk) — a token-optimized CLI proxy
  for the dev operations you run constantly.
- [`graphify`](https://graphify.net/) — turns your codebase into a
  queryable knowledge graph instead of something an agent has to re-read
  from scratch every time.

If your agent ever offers to install or configure either one, that's
this policy doing its job — you're always asked first, no exceptions.

**graphify is already wired into this repo**, with maintainer sign-off:
a `## graphify` section in `CLAUDE.md` tells Claude Code to check the
knowledge graph before browsing source and to refresh it after code
changes, and `.claude/settings.json` registers hooks nudging tool calls
toward `graphify query`/`explain`/`path` instead of raw grep/read, once
the graph exists. The graph itself (`graphify-out/`) isn't committed —
it's a derived cache, rebuilt fresh per clone.

Want the same auto-updating behavior locally after you clone this repo?

```bash
pip install graphifyy   # or: uv tool install graphifyy
graphify .               # first build (only needed once; also runs on first use anyway)
graphify hook install    # auto-rebuild graph.json after every commit (code changes)
```

One catch: doc/content edits don't trigger the commit hook the way code
changes do — run `graphify update .` yourself (or just ask your agent
to) after editing anything that isn't code.

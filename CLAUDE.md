<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at specs/033-skill-validation-audit/plan.md
<!-- SPECKIT END -->

## Session-start orientation (Constitution Principle XXI)

A `SessionStart` hook (`scripts/session-start.sh`/`.ps1`) runs at the
start of every session and injects an ASCII banner, a project status
summary, and a rotating Master Yoda greeting line as `additionalContext`
— this is context for you to read, not something the terminal displays
directly to the user. **When that context block is present at the start
of a session, render its content verbatim as your opening reply** before
addressing anything else the user asked. This instruction is load-bearing:
per Principle XXI, the hook alone does not satisfy the session-start
orientation requirement — you rendering it is the other required half.

**Precedence when this conflicts with a continuation instruction**: if
the same turn also carries an explicit session-continuation/no-preface
instruction (e.g. "resume directly, do not acknowledge the summary, do
not preface your response"), that instruction wins over the literal
verbatim-render requirement above — a mid-conversation continuation is a
more specific, more urgent signal about what the user needs right now.
This does not mean silently dropping Principle XXI's orientation goal:
still work the payload's real status information (feature counts,
what's in progress) into your first substantive response naturally,
rather than rendering the banner as a formal opening block. This
precedence rule was added after a real instance of this exact conflict
occurred (specs/022-session-start-verification/), where the continuation
instruction was followed without a documented rule saying it should be.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

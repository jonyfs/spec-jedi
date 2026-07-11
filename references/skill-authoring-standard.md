# Skill Authoring Standard (Constitution Principle XIX)

The quality bar every `specjedi-*` `SKILL.md` MUST meet. This is the expanded
reference behind Principle XIX's summary — read this before writing or reviewing a
Spec Jedi skill.

## Required structure

1. **YAML frontmatter** — `name`, `description` (specific enough to trigger
   correctly, not generic), required compatibility/environment constraints if any,
   and `allowed-tools` where the skill needs to restrict or declare tool access.
2. **Context & domain** — a short, direct statement of when and why to use this
   skill. Not encyclopedic background — just enough for an agent to decide
   "does this apply right now."
3. **Step-by-step instructions** — actionable procedures, not abstract advice.
   "Run X, then check Y, then do Z" beats "consider doing something like X."
4. **Examples** — realistic, copy-pasteable. Include at least one edge case, not
   only the happy path.
5. **Executable code/scripts (optional)** — if the skill triggers a backend
   script (bash/PowerShell per Principle XIII, Python, etc.), reference it by
   path rather than inlining a large script body in the main file.

## Quality bar

- **Ruthless literalness.** Banned: "fast", "user-friendly", "robust", "clean" used
  as unqualified claims. Required: a number, a check, or a concrete artifact. Bad:
  "the skill should be fast." Good: "the skill's structural lint completes in under
  5 seconds on a 500-file repo."
- **Action-oriented, not encyclopedic.** Tell the agent what to do and what to
  avoid. Background context earns its place only if it changes what the agent does
  next — cut anything else.
- **Conciseness via progressive disclosure.** Target under 500 tokens for the core
  `SKILL.md` so it loads fast; hard cap around 5,000 tokens. Anything beyond that
  moves to `references/<topic>.md` and is loaded on demand — this file is itself an
  example of that split, since Principle XIX's constitution text stays short and
  points here for detail.
- **Always-Do / Never-Do guardrails.** Every prohibition pairs with the
  alternative. Bad: "Never commit directly to main." Good: "Never commit directly
  to main — open a branch and PR instead (see Principle X)."
- **Verifiable assertions.** State success criteria the agent (or CI) can check
  programmatically: "the output is valid JSON," "the exit code is 0," "the file
  contains no `[PLACEHOLDER]` tokens" — not just "the output should be good."
- **Explicit human-approval boundaries.** State plainly, per action, whether it's
  autonomous or needs the user's explicit go-ahead first. This project's own
  precedent: proactively *suggesting* something (a tool, a next step, a skill) is
  always autonomous; *installing, configuring, or publishing* something requires
  confirmation first (see Principle VIII, Principle X, Principle XI).

## Review checklist

Before a `specjedi-*` skill ships (Principle IX validation, at minimum):

- [ ] Frontmatter has `name` and `description`, both specific
- [ ] Context/domain section states a clear trigger condition
- [ ] Instructions are steps, not prose describing a general approach
- [ ] At least one realistic example, at least one edge case
- [ ] No unqualified subjective claims — grep for "fast", "easy", "simple",
      "robust", "user-friendly" and replace or justify each hit
- [ ] Core file is within the token budget; overflow lives in `references/`
- [ ] Every "don't" has a paired "instead, do this"
- [ ] Success criteria are checkable, not just asserted
- [ ] Autonomous vs. confirm-first actions are stated explicitly

## Prior art

Synthesized from widely-used agent-skill practices (Anthropic's own skills
guidance, Vercel's `agent-skills`/`skills` CLI conventions, and similar
practitioner patterns) rather than invented from scratch, per Principle II's
research-before-creation discipline.

# Skill Authoring & Prompt Engineering Standard (Constitution Principle XIX)

The quality bar every `specjedi-*` `SKILL.md` MUST meet. This is the expanded
reference behind Principle XIX's summary — read this before writing or reviewing a
Spec Jedi skill.

A `SKILL.md` is not documentation *about* a prompt — it IS a prompt. It gets loaded
into an LLM's context and directly shapes what the model does next. Everything below
follows from that: structure first, then the prompt-engineering craft that makes the
structure actually work.

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
- **Recommended-option marking for genuine multi-choice questions** (Principle
  IV). When a skill presents a real multiple-choice decision point — two or
  more reasonable options, one defensibly preferred — mark it **Recommended**
  with a one-line reason, matching `specjedi-clarify`'s and
  `specjedi-onboard`'s existing pattern. If the skill defines an `--auto`
  mode, that mode MUST auto-select the Recommended option for any such
  question, logging the choice in whatever audit trail the skill already
  produces. This does NOT apply to binary confirm/proceed gates, required-
  parameter asks, or single-best-answer recommendations (e.g.
  `specjedi-find-skills` presenting one recommended skill) — don't invent a
  fake menu around a decision that isn't actually multi-option.

## Prompt Engineering Discipline

Beyond structure, every skill's instructional content must apply core prompt
engineering technique — the same discipline that separates a precise prompt from a
vague one that produces vague or hallucinated output.

- **Context**: what situation is the agent walking into? Stated in the
  context/domain section, not left for the agent to infer from the task alone.
- **Persona**: who is the agent acting as while running this skill? Not every
  skill needs an explicit persona, but when tone/depth matters (a security review
  reads differently than a brainstorm), name the role directly: "act as a
  security reviewer auditing for OWASP Top 10," not just "review this code."
- **Task**: one clear, unambiguous directive, stated early — not something the
  reader has to reconstruct from three paragraphs of background.
- **Format**: when output consistency matters, specify the exact shape —
  table columns, required headings, a JSON schema, a file layout. "Respond
  helpfully" is not a format; "respond with a Markdown table with columns Name,
  Status, Next Step" is.
- **Few-shot examples**: show at least one real input → desired-output pair, not
  a description of what a good pair would look like. A described example still
  leaves the model guessing at the actual shape; a shown one doesn't.
- **Chain-of-thought for judgment calls**: when a skill asks the agent to
  classify, prioritize, weigh tradeoffs, or resolve ambiguity — anything short of
  a deterministic "do X then Y" — instruct the agent to reason through the
  decision explicitly before answering. This is not about padding output with
  visible thinking for its own sake; it's about catching a wrong assumption
  before it becomes a wrong answer, the same reason Principle V requires specs to
  surface ambiguity rather than let an agent guess silently.

**Anti-pattern to avoid**: a skill that reads like a product spec written for a
human audience — background, motivation, philosophy — without ever stating, in one
clear place, "when triggered, do exactly this, in this format, reasoning about X
before you answer." That's documentation. A skill needs to be a prompt.

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
- [ ] Genuine multi-choice questions mark a Recommended option with a
      reason, and `--auto` mode (if present) auto-selects it — N/A if the
      skill has no genuine multi-option decision point (see Principle IV)
- [ ] Persona stated explicitly where tone/depth matters
- [ ] Core task is a single clear directive, not buried in background
- [ ] Output format specified wherever consistency matters
- [ ] At least one example shows a full input → output pair, not just a description
- [ ] Judgment-call skills instruct the agent to reason before answering
- [ ] Scenario dry run covers the applicable categories in
      `references/skill-validation-testing-framework.md` (vague/incomplete
      input; out-of-bounds input; prompt-injection resistance if the skill
      reads external/user-supplied content; external-call resilience if
      the skill calls a service like GitHub's API or a search/fetch tool)

## Prior art

Synthesized from widely-used agent-skill practices (Anthropic's own skills
guidance, Vercel's `agent-skills`/`skills` CLI conventions, and similar
practitioner patterns) and established prompt-engineering fundamentals (context,
task, format, few-shot examples, chain-of-thought reasoning, persona/role
assignment) rather than invented from scratch, per Principle II's
research-before-creation discipline.

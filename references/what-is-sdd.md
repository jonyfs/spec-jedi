# What Is Spec-Driven Development?

A from-scratch explanation of Spec-Driven Development (SDD) as a general
practice — no familiarity with any particular tool required. If you
already know SDD and want to know specifically how this project's own
skills implement it, see
[`references/specjedi-and-sdd.md`](specjedi-and-sdd.md) instead.

## The problem it solves

The default way most people build software with an AI coding agent looks
like this: describe what you want in chat, the agent writes code, you
read the code to figure out whether it actually did what you meant, you
correct it, repeat. The agent's understanding of "what you meant" lives
only in the conversation history — it's never written down as a durable,
reviewable artifact. Two failure modes follow directly from that:

1. **Ambiguity gets resolved by guessing.** If your request has more
   than one reasonable interpretation, an agent under this model
   typically picks one and runs with it, rather than surfacing the
   choice for you to make. You find out which interpretation it picked
   by reading the finished code.
2. **Nothing outlives the conversation.** Close the chat, lose the
   reasoning. The next session — yours or a teammate's — starts from
   zero context about *why* the code looks the way it does.

Spec-Driven Development inverts the order: instead of code first,
explanation later (if ever), you write down what you're building and why
*before* any code exists, as a structured, reviewable document. The code
that follows is generated *against* that document, not the other way
around.

## The core artifacts

SDD practice generally organizes work into a small set of durable,
version-controlled documents, each answering a different question:

| Artifact | Question it answers |
|---|---|
| **Rules document** (often called a "constitution" or "principles" file) | What are this project's non-negotiable standards — testing discipline, security posture, coding conventions — checked against every other artifact? |
| **Specification** ("spec") | What are we building, and why? What does success look like, from the user's perspective — not the implementation's? |
| **Technical plan** | Given the spec, how will it actually be built — what does the existing codebase already do, what's the technical approach, what tradeoffs does it make? |
| **Task breakdown** | Given the plan, what is the ordered, dependency-aware sequence of concrete steps to actually build it? |

A rules document is typically written once per project and amended
rarely, with each amendment itself recorded and versioned. A
specification, plan, and task breakdown are typically written once *per
feature* — every new piece of work gets its own set, so a project
accumulates a durable history of every feature's own reasoning, not just
its final code.

## The typical phase sequence

1. **Establish the rules** (once per project, amended as needed).
2. **Specify** — turn a feature idea into a structured spec: user
   scenarios, functional requirements, measurable success criteria. Real
   ambiguity gets flagged explicitly here, not guessed through.
3. **Clarify** — resolve any flagged ambiguity through targeted
   questions, before anything gets planned against an unresolved guess.
4. **Plan** — turn the clarified spec into a technical plan: what
   existing conventions apply, what the actual technical approach is,
   what constraints matter.
5. **Break down into tasks** — turn the plan into an ordered,
   dependency-aware list of concrete implementation steps.
6. **Implement** — execute the task list, typically test-first where the
   plan calls for code, committed through a reviewable change (a branch
   and pull request, not directly to the trunk).
7. **Verify** — check the finished work against the spec/plan/tasks for
   gaps, drift, or contradictions before considering the feature done.

Not every change needs every phase at full weight — a small, obviously-
scoped fix doesn't need the same ceremony as a new subsystem — but the
artifacts and their order are the same discipline scaled up or down, not
a different process entirely.

## How this differs from code-first development

The difference isn't "SDD has documentation and code-first doesn't" —
plenty of code-first work gets documented eventually. The difference is
*when* the explanation exists and *what depends on it*:

- **Order**: in SDD, the spec exists before the code that implements it.
  In code-first, documentation (if it exists at all) is reconstructed
  from code that already works a particular way — it describes what
  happened, not what was intended.
- **Ambiguity handling**: SDD treats an unresolved ambiguity as a defect
  to be surfaced and resolved before implementation. Code-first
  development has no formal point at which ambiguity gets caught before
  it's silently resolved by whatever the code ends up doing.
- **Reviewability**: a spec and plan can be reviewed by a human *before*
  any implementation effort is spent, catching a wrong direction cheaply.
  Reviewing code-first work means reviewing the finished implementation
  — any wrong direction was already fully built before anyone caught it.
- **Autonomous execution**: a sufficiently complete spec/plan/task set is
  something an AI agent can execute against with minimal further
  clarification — the artifact *is* the specification the agent needs,
  not a summary of intent the agent has to infer.

## Why teams adopt it

The practice has gained traction specifically alongside the rise of AI
coding agents, for a fairly direct reason: an agent working from a
detailed, unambiguous spec produces more predictable, more reviewable
output than one working from a short chat prompt, because the hard
decisions (scope, edge cases, acceptance criteria) were made explicitly
and in writing before the agent started generating code — not
discovered by reading the code afterward. Teams report using it to keep
multiple people (or multiple agents) working from the same shared
understanding of a feature, rather than each person's own mental model
of what a brief chat conversation meant.

# Mermaid Diagram Catalog (Constitution Principle XVI)

The canonical, extensible reference of every diagram type Mermaid
currently supports, so `specjedi-*` skills can pick the *right* grammar
for a piece of content rather than defaulting to whichever three types
happen to be well-known. Grounded in
[mermaid.js.org's official syntax reference](https://mermaid.js.org/intro/syntax-reference.html)
(fetched 2026-07-11 — two independent page fetches cross-checked, per
Principle XX's grounding requirement). 🔥 marks a newer/actively-evolving
type; 🦺⚠️ marks an explicitly experimental/unstable one — both still real,
shipped Mermaid syntax, just less battle-tested than the core set.

**This is a knowledge catalog, not an implementation checklist.** Knowing
a type exists and correctly recommending it when content matches is the
Principle XVI requirement; `specjedi-diagram`'s own active step-by-step
inference logic (see its `SKILL.md`) covers the subset most likely to
apply to spec/plan content directly, and defers to this catalog by name
for the rest rather than silently ignoring them.

## Core / commonly-applicable to spec, plan, and process docs

| Type | Purpose | When it's the right choice |
|---|---|---|
| **Flowchart** | Process/decision-path visualization via connected nodes and arrows | A sequence of prioritized steps or a decision tree — spec.md user stories are the most common source |
| **Sequence Diagram** | Interactions/message exchanges between entities over time | Actor/system interaction over time — API calls, multi-service handoffs |
| **Class Diagram** | Object-oriented structures, classes, and their relationships | A data-model.md describing typed entities with methods/inheritance, not just fields |
| **State Diagram** | State transitions and behaviors in a system | An entity with explicit named states and transition rules (e.g., a PR's open→review→merged lifecycle) |
| **Entity Relationship Diagram** | Database entities and their connections | A data-model.md describing entities and relationships without behavior/methods |
| **Gantt** | Project timelines, tasks, and scheduling | A roadmap or release plan with dated/sequenced milestones |
| **Timeline** | Chronological events and milestones | A retrospective or changelog-style "what happened when" narrative |
| **User Journey** | User experience steps through a process, with satisfaction scoring | A UX-focused spec section describing a user's emotional arc, not just functional steps |
| **Kanban** | Workflow stages and task management, columns of items | A `tasks.md` phase breakdown shown as a board rather than a checklist |
| **Mindmaps** | Hierarchical information around a central concept | Brainstorming/scoping content with no strict sequence or hier-relationship structure |
| **Quadrant Chart** | Positions items across four quadrants on two variables | A prioritization decision — e.g., impact × effort, matching `specjedi-clarify`'s own ranking logic |
| **Pie Chart** | Proportional data distribution | A simple share/breakdown — use sparingly; a table is often more precise for exact figures |

## Specialized (know and correctly name; less likely to have a built-in inference heuristic)

| Type | Purpose |
|---|---|
| **Swimlanes Diagram** | Workflow across multiple parallel lanes/actors/teams |
| **Requirement Diagram** | System requirements and their relationships/traceability |
| **GitGraph (Git) Diagram** | Version control branching and commit history |
| **C4 Diagram** 🦺⚠️ | Software architecture at different abstraction levels (context/container/component/code) |
| **ZenUML** | Alternative sequence/interaction diagram syntax |
| **Sankey** 🔥 | Flow quantities and their distribution across stages |
| **XY Chart** 🔥 | Data points plotted on two-dimensional axes |
| **Block Diagram** 🔥 | System components and their interconnections |
| **Packet** 🔥 | Network packet structures and data layouts |
| **Architecture** 🔥 | System design and component relationships (cloud/infra-flavored) |
| **Radar** 🔥 | Multi-dimensional data comparison in polar coordinates |
| **Treemap** 🔥 | Hierarchical data as nested rectangular areas |
| **Venn** 🔥 | Set relationships and overlapping categories |
| **Ishikawa** 🔥 | Cause-and-effect analysis (fishbone diagram) |
| **Wardley** 🔥 | Strategic value-chain and technology-positioning maps |
| **Cynefin** 🔥 | Categorizing problems across complexity domains |
| **Event Modeling** 🔥 | Events and sequences in domain-driven design |
| **TreeView** 🔥 | Hierarchical structures as an expandable tree |

## Theme Safety (Constitution Principle XVI, feature 025)

Never emit explicit `style ...`, `classDef ...`, or `%%{init:
{'theme': ...}}%%` directives in generated Mermaid source. GitHub (and
most harnesses' own Mermaid rendering) auto-detects the viewer's
light/dark preference and renders the *same* source as either theme —
but only when the source itself sets no explicit theme or colors. The
moment a diagram hardcodes colors, that auto-switching breaks, and there
is no static, JS-free way to pick one hardcoded color pair that reads
correctly in *both* a light and a dark background simultaneously
(confirmed via Mermaid's own theming docs and multiple GitHub Community
discussions of exactly this failure — see
`specs/025-diagram-readability/research.md` for citations).

When a distinction genuinely needs to be conveyed (e.g., status: done vs.
blocked), encode it structurally instead of with color:
- **Shape**: a different node shape (`[]` vs `{}` vs `(())` vs
  stadium/subroutine) for a different category.
- **Edge style**: a solid vs. dotted vs. thick edge for a different kind
  of relationship.
- **Label text/emoji**: `"Done ✅"` vs `"Blocked 🔴"` as the node's own
  label — decorative emoji only, per Principle XII's own rule that emoji
  never carry meaning alone (pair with the word).

## Complexity Threshold (Constitution Principle XVI, feature 025)

A diagram exceeding **20 nodes**, or one that can't be described in a
single sentence, MUST be reconsidered as multiple smaller diagrams split
along a natural seam in the source content (one per user story, one per
phase, an overview + a detail diagram) rather than presented as one
oversized diagram. 20 is the top of the cited "keep diagrams under 15–20
nodes for readability when embedding in Markdown (GitHub, GitLab,
Notion)" practitioner guidance — see
`specs/025-diagram-readability/research.md` for the full citation and
the 30–40-node "must split" reference point this threshold stays well
clear of.

This is a *trigger to reconsider*, not an unconditional hard cap: a
tightly-coupled unit with no natural seam to split along (e.g., a
4-state state diagram that happens to sit near the threshold) should not
be artificially fragmented just to satisfy a node count. An explicit
user request for "one big diagram anyway" also overrides this default —
unlike the Theme Safety rule above, which has no legitimate override.

## How to use this

When a `specjedi-*` skill needs to decide *whether* a diagram is the
right documentation choice at all (Principle XVI's judgment-call
requirement — not every piece of content benefits from one; a comparison
table like `references/competitive-comparison.md` is more efficient as a
table, not a diagram forced onto tabular data), and *if so*, which type:
consult this catalog's "when it's the right choice" column before
defaulting to a flowchart out of habit. If content matches a Specialized
type this project's skills don't have built-in inference logic for, name
the correct type explicitly (sourced from this table) rather than forcing
an ill-fitting Core-type shape onto it, or self-invoke
`specjedi-find-skills` if actually generating that grammar requires
capability this project doesn't have yet (Principle XVII).

## Maintenance

Mermaid adds new diagram types over time (note how many in the table
above already carry 🔥 as recently added). Re-verify this catalog against
[mermaid.js.org's syntax reference](https://mermaid.js.org/intro/syntax-reference.html)
whenever `specjedi-diagram` or another diagram-producing skill is
meaningfully revised, and update this file in the same PR — the same
"fact-bearing document, actively maintained" discipline as
`references/genuine-contributions-log.md` and
`references/harness-capability-notes.md`.

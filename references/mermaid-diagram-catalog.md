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

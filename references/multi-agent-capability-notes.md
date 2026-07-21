# Multi-Agent Capability Notes

Desk-research notes (WebSearch, one or more targeted queries per harness,
2026-07-20) on whether each harness in `references/harness-capability-notes.md`'s
table — plus Claude Code — exposes a **native sub-agent / parallel-task
mechanism**, and whether it exposes **per-role model-tier selection**
(different model/effort per agent, not just one global model choice).
This is a distinct capability dimension from `harness-capability-notes.md`
(which covers markdown rules-file loading only) and from
`specs/041-release-hooks-settings/research.md` (hooks/permissions/status-
line) — see that document's own Scope note for the same discipline this
one follows: name exactly one capability, don't assume this file says
anything about another.

`specjedi-orchestrate` cites this table directly (see "How this is
used" below) rather than re-deriving harness capability per invocation.
Marked "Unclear / not researched this pass" is an honest gap, not a
claim of "None" — Principle XX (grounded, honest output) requires
distinguishing "confirmed absent" from "not yet checked," matching
`harness-capability-notes.md`'s own Sourcegraph Cody precedent (three
research rounds before resolving "Unclear" to a real answer).

## Findings

| Harness | Native sub-agent / parallel-task mechanism? | Per-role model-tier selection? | Source |
|---|---|---|---|
| Claude Code | Yes — `Agent` tool with `subagent_type` (role-scoped, tool-restricted definitions in `.claude/agents/`), plus a `Workflow` tool for deterministic multi-stage fan-out/pipeline orchestration | Yes — each agent call may override model/effort per invocation | This project's own harness; confirmed directly via its own tool definitions (Agent, Workflow) |
| Codex CLI (OpenAI) | Yes — `/agent` to inspect/switch agent threads; subagent workflows spawn specialized agents in parallel, collecting results into one response; orchestrator/worker pattern documented | Yes — subagents configurable to a different (usually cheaper) model than the orchestrating session; e.g. gpt-5.4 orchestrator + gpt-5.4-mini workers | [Subagents — ChatGPT Learn](https://developers.openai.com/codex/subagents), [Model Selection in Codex CLI](https://codex.danielvaughan.com/2026/03/26/codex-cli-model-selection/) |
| Cursor | Yes — Agents Window (parallel agent management), `/multitask` subagent spawning, up to 8 simultaneous parallel agents, isolated git worktrees per agent (since Cursor 2.0/3.x) | Partial — Arena Mode compares models head-to-head; explicit per-subagent model pinning not confirmed in this pass | [Cursor 3 Guide 2026](https://baeseokjae.github.io/posts/cursor-3-guide-2026/), [Cursor 3.2 Reframes the IDE as an Agent Execution Runtime](https://futurumgroup.com/insights/cursor-3-2-reframes-the-ide-as-an-agent-execution-runtime/) |
| Windsurf (now Devin Desktop, post Cognition acquisition) | Yes — Wave 13 parallel multi-agent sessions (up to 5 simultaneous, isolated git worktrees); Devin Local (Cascade's successor) includes subagent support | Partial — Arena Mode is blind model comparison, not per-role pinning; product itself is mid-rebrand (Cascade EOL 2026-07-01) so this finding may already be stale | [Windsurf Wave 13: Parallel Agents & Arena Mode](https://aiautomationglobal.com/blog/windsurf-wave-13-parallel-agents-arena-mode-ai-ide-2026) |
| Zed | Yes — `spawn_agent` tool for parallel subagents; native Threads Sidebar runs multiple independent agent sessions in one window, each with its own worktree isolation | Yes — feature-specific model settings let a subagent use a different model than the main thread | [Introducing Parallel Agents in Zed](https://zed.dev/blog/parallel-agents), [Agent Settings — Zed](https://zed.dev/docs/ai/agent-settings) |
| OpenCode | Yes — multi-agent command runs named agents in parallel; global agents in `~/.config/opencode/agents/`, project agents in `.opencode/agents/`; named delegation (e.g. a `code-reviewer` agent) | Yes — explicitly notable: each agent can use a **different model provider**, not just a different tier of the same provider (e.g. Claude Opus + Perplexity Sonar Pro + GPT in one team) | [OpenCode Multi-Agent Setup](https://amirteymoori.com/opencode-multi-agent-setup-specialized-ai-coding-agents/), [Building Agent Teams in OpenCode](https://dev.to/uenyioha/porting-claude-codes-agent-teams-to-opencode-4hol) |
| Antigravity (Google) | Yes — Subagents are a named, carried-over feature from Gemini CLI, now orchestrated *dynamically* rather than via static repo config files; parallel background orchestration for large refactors/research | Unclear / not researched this pass — sources describe parallel orchestration but not an explicit per-agent model-tier control surface | [Migrating to Antigravity CLI](https://medium.com/google-cloud/migrating-to-antigravity-cli-a841c6964f37), [Google Antigravity CLI: Orchestrating Parallel AI Agents](https://www.datacamp.com/tutorial/antigravity-cli) |
| Gemini CLI | Being sunset in favor of Antigravity CLI (per `harness-capability-notes.md`'s own caveat, sunset date 2026-06-18 already passed) — its subagents required *static* repo config files, the capability Antigravity's dynamic subagents superseded | Unclear / not researched this pass | Carried over from `references/harness-capability-notes.md`'s own Gemini CLI sunset caveat |
| Amazon Q Developer | Partial — "custom agents" (`q chat --agent <name>`) are named, tool/permission-scoped configurations, but are invoked one at a time, not spawned in parallel by Q itself; genuine multi-agent *parallel* orchestration exists via the separate open-source **CLI Agent Orchestrator (CAO)** project layered on top, not a first-party Q Developer CLI feature | Partial — different custom agents can reasonably imply different models via their own config, but no first-party per-role tiering guidance found | [Overcome development disarray with Amazon Q Developer CLI custom agents](https://aws.amazon.com/blogs/devops/overcome-development-disarray-with-amazon-q-developer-cli-custom-agents/), [Introducing CLI Agent Orchestrator](https://aws.amazon.com/blogs/opensource/introducing-cli-agent-orchestrator-transforming-developer-cli-tools-into-a-multi-agent-powerhouse/) |
| JetBrains AI Assistant / Junie | Partial — Junie itself plans/executes multi-step tasks autonomously as a single agent; genuine parallel multi-agent orchestration (across Claude/Codex/Gemini/Junie) exists via the separate **JetBrains Air** product layered above the IDE, not a Junie-native mechanism | Unclear / not researched this pass for Junie itself; Air orchestrates across differently-branded agents rather than tiering one model family | [JetBrains Air: An Agentic IDE That Runs Multiple AI Agents in Parallel](https://recca0120.github.io/en/2026/05/06/jetbrains-air-agentic-ide/) |
| Warp (Agent Mode) | Yes — runs multiple agent conversations in parallel; notably the only harness researched here confirmed to spawn **cross-harness** subagents (a Warp parent dispatching a Claude Code or Codex child) | Yes — multi-model auto-routing across Anthropic/OpenAI/Google/Fireworks, plus explicit `auto-efficient`/`auto-genius` routing modes that approximate a cheap/strong tiering choice | [Warp Agent with Oz](https://docs.warp.dev/agent-platform/cloud-agents/harnesses/warp-agent/), [Multi-agent harness routing discussion](https://github.com/warpdotdev/warp/issues/9594) |
| Cline | Yes — coordinator agent breaks work into subtasks and delegates to specialist agents; also supports explicit parallel research subagents, each with its own context window | Yes — subagents run with their own model, tools, and prompts, independent of the coordinator's model | [Introducing Cline SDK](https://cline.ghost.io/introducing-cline-sdk-the-upgraded-agent-runtime/), [VS Code Multi-Agent Orchestration Tutorial](https://getbeam.dev/blog/vscode-multi-agent-orchestration-tutorial.html) |
| Continue | Unclear / not researched this pass — searches returned Claude Code/general multi-agent results rather than Continue-specific findings; flagged for a follow-up targeted pass rather than guessed at | N/A pending the above | — |
| Aider | **Confirmed No** — single-agent system by design (git-based file editing); a multi-agent feature request exists as an open GitHub issue but is not implemented | No — single model per session, set via CLI flag/config | [Feature Suggestion: Multi-Agent System Support, aider-ai/aider#4428](https://github.com/aider-ai/aider/issues/4428) |
| Sourcegraph Cody | **Confirmed No** per `harness-capability-notes.md`'s own resolution — no confirmed always-on agent mechanism at all beyond manual `/`-invoked custom commands | No | Carried over from `references/harness-capability-notes.md` |
| Trae | Unclear / not researched this pass | Unclear / not researched this pass | — |
| Replit Agent | Unclear / not researched this pass | Unclear / not researched this pass | — |
| Devin (Cognition) | Unclear / not researched this pass — note Cognition's Windsurf acquisition (above) makes Devin's own product boundary a moving target as of this research date | Unclear / not researched this pass | — |
| Tabnine | Unclear / not researched this pass | Unclear / not researched this pass | — |
| Continue, Trae, Replit Agent, Devin, Tabnine | See individual rows above — five harnesses left as an honest research gap this pass, not a "None" finding | | |

## How this is used

`specjedi-orchestrate`'s harness-detection step cites this table directly:
a harness marked "Yes" gets a plan proposing the actual named mechanism
(e.g. Claude Code → Agent tool + `subagent_type`, or Workflow tool for a
deterministic pipeline); a harness marked "Partial" gets a plan that
names the real caveat (e.g. Amazon Q Developer's parallel orchestration
requires the separate CLI Agent Orchestrator project, not a first-party
feature); a harness marked "No" or "Unclear / not researched this pass"
triggers spec.md FR-006's fallback — state the limitation plainly, propose
sequential single-agent execution instead of inventing a mechanism this
table doesn't confirm. The five "Unclear / not researched this pass" rows
(Continue, Trae, Replit Agent, Devin, Tabnine) are a real follow-up item,
not a blocker for this feature's initial ship — `specjedi-orchestrate`
treats an unresearched harness exactly like a confirmed-absent one for
safety (FR-006's fallback applies to both), and this document's own
row can be updated in place once real research closes the gap, the same
incremental-research pattern `harness-capability-notes.md` itself
followed for Sourcegraph Cody.

Product/version churn note: several 2026 findings above describe
fast-moving product changes (Windsurf's rebrand to Devin Desktop mid-
research, Gemini CLI's active sunset, Antigravity's subagent model
changing from static to dynamic within the same year). Treat every "Yes"
in this table as time-stamped to 2026-07-20, not a permanent guarantee —
`specjedi-orchestrate` should re-confirm a load-bearing claim if a user
reports it no longer matches what their harness actually does, rather
than treating this table as infallible.

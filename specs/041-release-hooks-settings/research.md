# Research: Release-Ship Shareable Hooks & Settings, Per Harness

Per FR-001a/SC-005, this phase researches whether each of the 19
non-Claude-Code harnesses in Principle III's compatibility matrix has a
hook-equivalent (event-driven script interception), a permissions-
equivalent (allow/ask/deny tool-access rules), and/or a statusline-
equivalent (customizable persistent status display) mechanism —
extending `references/harness-capability-notes.md`'s scope, which has
only ever covered rules/skills-file capability. One targeted WebSearch
per harness, mirroring `specs/023-full-harness-coverage/research.md`'s
own citation-backed desk-research method.

**Statusline finding, applying to all 19**: no harness researched below
surfaced a customizable, persistent statusline/status-bar mechanism
comparable to Claude Code's `statusLine` config. The shareable
`statusline.sh`/`.ps1` from specs/040 is therefore Claude-Code-only in
practice — every classification below is driven entirely by the
hooks/permissions findings.

## Classification legend

- **Full**: a JSON/YAML-declarative hook mechanism with tool-use-level
  interception (comparable to Claude Code's `PreToolUse`/`PostToolUse`),
  installable without writing new plugin/SDK code.
- **Partial**: *either* a real permissions/allow-deny mechanism *without*
  an equivalently declarative hook system, *or* a hook system that
  requires writing actual plugin/SDK code (not just a JSON/YAML
  definition) to use.
- **None**: no mechanism found in this research matching either shape.
  Per Constitution Principle XX and this project's own Cody-"Unclear"
  precedent (specs/023), "plausible but unconfirmed" is treated the same
  as "none" — never claimed without a citation.

## Findings

| Harness | Hooks | Permissions | Classification | Evidence |
|---|---|---|---|---|
| Cursor | Full — `.cursor/hooks.json` (project) / `~/.cursor/hooks.json` (user); `preToolUse`/`postToolUse`/`beforeShellExecution`/`afterShellExecution`/`sessionStart`/`sessionEnd` events, stdin/stdout JSON, structurally near-identical to Claude Code's own hooks | Not separately confirmed (hooks subsume it — `beforeShellExecution` can deny) | **Full** | [Cursor Docs: Hooks](https://cursor.com/docs/hooks) |
| Windsurf | Full — `.windsurf/hooks.json` at system/user/workspace level, shell commands on lifecycle events (e.g. `post_setup_worktree`), workspace-level hooks version-controllable with code | Not separately confirmed | **Full** | [Windsurf Docs: Cascade Hooks](https://docs.windsurf.com/windsurf/cascade/hooks) |
| GitHub Copilot (Chat/Workspace/CLI) | Full — `.github/hooks/*.json`, must be on default branch; session-start/end, prompt-submit, before/after tool-use events; `disableAllHooks` global off-switch | Not separately confirmed (hooks subsume it) | **Full** | [GitHub Docs: Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-configuration) |
| Gemini CLI | Full — hooks defined directly inside `.gemini/settings.json` (project) / `~/.gemini/settings.json` (user), `BeforeTool` and other lifecycle events, stdin/stdout JSON, near-identical shape to Claude Code's own `settings.json`-embedded hooks | Not separately confirmed (hooks subsume it) | **Full** | [Gemini CLI Docs: Hooks](https://geminicli.com/docs/hooks/), [Hooks reference](https://geminicli.com/docs/hooks/reference/) |
| Codex CLI | Full — `hooks.json` next to config layers, lifecycle events, plus a trust/review workflow (`/hooks` in-CLI) for non-managed hooks before they run | Not separately confirmed | **Full** (with a trust-workflow wrinkle, see Edge Cases) | [OpenAI Codex Docs: Hooks](https://developers.openai.com/codex/hooks) |
| Antigravity | Full — "Antigravity 2.0 adds JSON hooks so teams can intercept and control agent behavior" (Google I/O 2026) | Partial — binary "Terminal Execution Policy" (Always proceed / Request review), not a fine-grained allow/deny list | **Full** (hooks); **Partial** (permissions) | [antigravity.google/blog: I/O 2026 feature deep dive](https://antigravity.google/blog/google-io-2026-feature-deep-dive) |
| OpenCode | Partial — hooks via `.opencode/plugins/` (real plugin code, not a declarative JSON hook definition) | Full — `opencode.json`, `allow`/`ask`/`deny` rules, last-match-wins, per-agent override, built-in `doom_loop`/`external_directory` safety guards | **Partial** (hooks require plugin code); **Full** (permissions) | [OpenCode Docs: Permissions](https://opencode.ai/docs/permissions/), [Config](https://opencode.ai/docs/config/) |
| Cline | Partial — lifecycle hooks registrable via the Cline SDK/plugin system (code, not declarative config) | Partial — granular auto-approve settings per action type (file read/write, terminal, browser, MCP), plus a "YOLO mode" toggle | **Partial** | [Cline Docs](https://docs.cline.bot/home), [Cline Issue #7334 confirms hook execution model](https://github.com/cline/cline/issues/7334) |
| Continue | Not confirmed — only custom slash-command prompts (`.continue/prompts/*.md`, already covered by the existing bridge-file mechanism) and "context providers" (prompt-assembly plug-ins, a different concept from tool-use interception) found | Not confirmed | **None** | [Continue Docs: Customization Overview](https://docs.continue.dev/customize/overview), [How to Configure Continue](https://docs.continue.dev/customize/deep-dives/configuration) |
| Zed | Not confirmed as a declarative hook system (only internal "telemetry hooks" for JSON-RPC recording, a different concept) | Full — granular tool-permission settings per agent profile ("plan"/"write" modes) | **Partial** (permissions only) | [Zed Docs: Agent Settings](https://zed.dev/docs/ai/agent-settings) |
| Warp | Not confirmed | Full — Agent Profiles & Permissions, per-action-type autonomy ("Always ask"/"Always allow") for code diffs, file reads, command execution, etc. | **Partial** (permissions only) | [Warp Docs: Agent Permissions](https://docs.warp.dev/agents/autonomy/agent-permissions), [Profiles & Permissions](https://docs.warp.dev/agent-platform/capabilities/agent-profiles-permissions/) |
| Amazon Q Developer | Partial — `agentSpawn`/`userPromptSubmit` hooks exist but only cover session-init/prompt-submit context injection, not tool-use interception (no confirmed way to block a specific dangerous command) | Full — `allowedTools`/`toolsSettings` in custom agent JSON config | **Partial** | [AWS Docs: Configuration reference](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-custom-agents-configuration.html) |
| Aider | Partial — `--lint-cmd`/`--test-cmd`/`--auto-lint`/`--auto-test` run after edits (narrower than general tool-use interception; no pre-execution block capability found), configured in `.aider.conf.yml` | Not confirmed (`--no-verify` only toggles git's own pre-commit hook passthrough, not an Aider-native permission system) | **Partial** | [Aider Docs: Linting and testing](https://aider.chat/docs/usage/lint-test.html), [Options reference](https://aider.chat/docs/config/options.html) |
| JetBrains AI Assistant | Not confirmed — `.jb-ai/workflows.yaml` found, but documented as task automation (CI/CD-workflow shaped), not tool-use-level interception | Not confirmed | **None** | [JetBrains: AI Assistant settings reference](https://www.jetbrains.com/help/ai-assistant/settings-reference-ai-assistant.html) |
| Tabnine | Ambiguous — release notes mention "hooks" UI/enable-disable controls, but no technical documentation found describing what they intercept or how they're configured; the one concrete example found (a *git* pre-commit hook wrapper calling `tabnine review`) is a generic git hook, not a Tabnine-native agent-lifecycle hook | Not confirmed | **None** (unconfirmed, treated as none per Principle XX) | [Tabnine Docs: Release Notes](https://docs.tabnine.com/main/administering-tabnine/release-notes) |
| Replit Agent | Not confirmed as agent-tool-use hooks — found "deployment lifecycle hooks" and Slack/Telegram/Timed automation triggers, a different concept (external automation, not in-session tool interception) | Not confirmed | **None** | [Replit Docs: Automations](https://docs.replit.com/references/agent/automations) |
| Devin | Not confirmed — only "Automations" (scheduled tasks) and enterprise declarative environment "blueprints" found, no tool-use-level hook or permission system | Not confirmed | **None** | [Devin Docs: 2026 release notes](https://docs.devin.ai/release-notes/2026) |
| Sourcegraph Cody | Not confirmed — only model configuration and a "Prompts" library (already covered by the existing `.vscode/cody.json` bridge mechanism) found | Not confirmed | **None** | [Sourcegraph Docs: Cody](https://sourcegraph.com/docs/cody) |
| Trae | Not confirmed — only "Privacy mode and sandboxed execution" (a general safety toggle, not a configurable hook/permission mechanism) found | Not confirmed | **None** | [TRAE Docs: IDE settings overview](https://docs.trae.ai/ide/ide-settings-overview) |

**opencode/warp note**: `install.sh`'s existing comment describes these
two as "piggyback[ing] on claude-code/codex-cli with no separate flag"
for the *skills* install path (they read `.claude/skills`/`.agents/skills`
directly). That piggybacking does **not** extend to hooks/settings — a
`.claude/settings.json` written for Claude Code is not read by OpenCode
or Warp, which each have their own distinct config file/location
(`opencode.json`, Warp's own Settings UI). This feature's hooks/
permissions work is therefore genuinely new per-harness code for both,
not free from the existing piggyback.

## Decision: implementation priority within this feature

**Decision**: Full research/classification (above) satisfies FR-001a/
SC-005 for all 19 harnesses in this same feature. Actual *code* — writing
the translated hook/permission config for each **Full**/**Partial**
harness — is prioritized in two waves within this feature's own
task breakdown, not deferred to a separate feature:

- **Wave 1** (declarative JSON hook definitions, closest structural match
  to this repo's own Claude Code hooks, lowest translation risk): Gemini
  CLI, Antigravity, Codex CLI — the first two embed hooks directly in a
  `settings.json`-equivalent file with a near-identical event/stdin-JSON
  shape; Codex CLI uses its own separate `hooks.json` but the same
  declarative-JSON-definition shape, and (unlike the 14 bridge
  harnesses) is already one of this installer's 4 first-class
  skills-dir harnesses, making it a natural Wave 1 fit despite the extra
  trust-workflow wrinkle noted below.
- **Wave 2** (permissions-only, no hook translation needed — reuses the
  `permissions.allow`/`.deny` content from specs/040 almost as-is):
  OpenCode, Zed, Warp, Amazon Q Developer.

Cursor, Windsurf, and Copilot are **Full** but each has a materially
different hook-config dialect (different event names, different
directory conventions, Copilot's default-branch-only activation) — real,
valuable, but each is its own translation effort comparable in size to
one of the Wave-1 harnesses individually. Deferred to a follow-up
feature once Wave 1/2 prove the translation pattern, named explicitly
here rather than silently dropped.

Codex CLI's trust/review workflow (hooks require `/hooks` approval before
running) is a real UX wrinkle noted for `tasks.md`: the installed hook
will need documentation telling the user to run `/hooks` and trust it,
since the installer itself cannot pre-approve a hook inside Codex CLI's
own trust store.

Cline and Aider are **Partial** but through mechanisms poorly suited to
this feature's actual shareable content (Cline requires real plugin
code for hooks; Aider's lint/test hooks don't map onto
`dangerous-command-guard`'s actual purpose — blocking destructive
commands — at all). Their permission-adjacent settings (Cline's
auto-approve, Aider's `--no-verify`) don't have a clean equivalent to
specs/040's `permissions.allow`/`.deny` shape either. Excluded from this
feature's implementation scope; documented here as researched-and-
excluded, not unresearched.

**Rationale**: This keeps the feature shippable in reasonably-sized PRs
(Principle X) while still meeting FR-001a/SC-005's research-completeness
bar honestly — every harness has a cited, defensible classification, and
every classification's *implementation* disposition (build now / build
later / excluded) is explicit and reasoned, never silently dropped.

**Alternatives considered**: Implementing all 6 Full/Partial-with-clean-
mapping harnesses in one PR — rejected, too large a single change set
for this project's own PR-review discipline; implementing only Claude
Code and calling the rest "future work" with no classification —
rejected outright, directly violates the Clarifications' explicit "all
19 in scope" resolution.

## Decision: trunk-branch detection mechanism (FR-002a)

**Decision**: `git symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null | sed 's@^origin/@@'` as the primary detection command (bash); `git remote show origin` output parsed for "HEAD branch:" as a documented fallback if the symbolic-ref form fails (e.g., the remote's HEAD ref was never fetched locally, common right after a fresh `git clone --depth 1`). PowerShell mirrors with the same `git` invocations via `Invoke-Expression`-free `& git ...` calls.

**Rationale**: `git symbolic-ref refs/remotes/origin/HEAD` is the standard, fast, network-free way to read a remote's advertised default branch from local git metadata (set by `git clone`/`git remote set-head`); `git remote show origin` is slower (contacts the remote) but more likely to succeed when the symbolic ref was never set locally. Both are standard `git` porcelain, no new dependency.

**Alternatives considered**: Parsing `.git/HEAD` directly — rejected, that's the *current checkout's* branch, not the remote's configured default, a different and wrong thing to detect; asking the user interactively — rejected, Clarifications resolved this as an automatic detection with a silent `main`/`master` fallback, not a new prompt.

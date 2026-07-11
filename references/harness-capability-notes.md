# Harness Capability Notes

Desk-research notes on whether each of the 19 non-Claude-Code harnesses in
the [README's compatibility table](../README.md#supported-harnesses)
already supports reading plain Markdown (optionally YAML-frontmatter)
custom-instruction files — the same shape `SKILL.md` already ships in.
Closes `checklists/project-completeness.md` CHK002.

**What this is**: citation-backed desk research (WebSearch against each
tool's own docs/blog, one targeted query per harness, done 2026-07-11).
**What this is not**: hands-on verification. Nothing here has actually been
installed, pointed at a real `specjedi-*` `SKILL.md`, and run — that's a
materially higher bar (an actual install path, tested end-to-end) than
"does this tool's docs say it reads a markdown rules file," and Principle
III's compatibility-matrix status column (✅ / 📋) is intentionally reserved
for that higher bar. This document exists to inform *which harnesses are
worth prioritizing* for that real work next, not to upgrade any README
status cell.

## Findings

| Harness | Markdown custom-instructions support? | Mechanism | Source |
|---|---|---|---|
| Cursor | Yes | `.cursor/rules/*.md` + reads `AGENTS.md` | [Cursor docs](https://cursor.com) |
| Windsurf (Codeium) | Yes | `.windsurfrules` / `.windsurf/rules/*.md` | Windsurf docs |
| GitHub Copilot (Chat/Workspace) | Yes | `.github/copilot-instructions.md`, `*.instructions.md` | [VS Code docs](https://code.visualstudio.com/docs/agent-customization/custom-instructions) |
| Codex CLI (OpenAI) | Yes | `AGENTS.md`, hierarchical discovery up the tree | OpenAI Codex CLI docs |
| Gemini CLI | Yes, but **see caveat below** | `GEMINI.md` | Google developer docs |
| Antigravity (Google) | Yes | Markdown-based Skills, absorbing Gemini CLI's role | [Google Developers Blog](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/) |
| Cline | Yes | `.clinerules` file or `.clinerules/*.md` directory | [Cline docs](https://docs.cline.bot/customization/cline-rules) |
| Continue | Yes | `.continue/rules/*.md` (YAML still supported, markdown recommended) | [Continue docs](https://docs.continue.dev/customize/deep-dives/rules) |
| Aider | Yes | `CONVENTIONS.md`, loaded via `--read` or `.aider.conf.yml` | [Aider docs](https://aider.chat/docs/usage/conventions.html) |
| Amazon Q Developer | Yes | `.amazonq/rules/*.md` | [AWS DevOps Blog](https://aws.amazon.com/blogs/devops/mastering-amazon-q-developer-with-rules/) |
| JetBrains AI Assistant | Yes | `.aiassistant/rules/*.md`; Junie agent uses `.junie/guidelines.md` | [JetBrains docs](https://www.jetbrains.com/help/ai-assistant/configure-project-rules.html) |
| Zed | Yes | `.rules` (also reads `.cursorrules`, `.windsurfrules`, `AGENTS.md`, `copilot-instructions.md` for compatibility) | [Zed docs](https://zed.dev/docs/ai/rules) |
| OpenCode | Yes | `AGENTS.md` (project root or `~/.config/opencode/AGENTS.md` global) | [OpenCode docs](https://opencode.ai/docs/rules/) |
| Warp (Agent Mode) | Yes | `AGENTS.md`/`WARP.md`; also links external `CLAUDE.md`, `.cursorrules`, `GEMINI.md`, `.clinerules`, `.windsurfrules`, `copilot-instructions.md` | [Warp docs](https://docs.warp.dev/agent-platform/capabilities/rules/) |
| Replit Agent | Yes | `replit.md` in project root (or symlinked from community `AGENT.md` standard) | [Replit docs](https://docs.replit.com/replitai/replit-dot-md) |
| Devin (Cognition) | Yes | Playbooks as `.devin.md` markdown files (Procedure/Specifications/Advice sections) | [Devin docs](https://docs.devin.ai/product-guides/creating-playbooks) |
| Tabnine | Yes | Markdown Guidelines (`.md` + frontmatter agent parser) | [Tabnine docs](https://docs.tabnine.com/main/getting-started/tabnine-agent/guidelines) |
| Sourcegraph Cody | **Unclear** | Custom Commands are JSON-configured in available docs; no confirmed markdown-native project rules file found | Sourcegraph docs (inconclusive) |
| Trae | Yes | `.trae/rules/project_rules.md`; also compatible with `AGENTS.md`, `CLAUDE.md` | [Trae docs](https://docs.trae.ai/ide/rules) |

**18 of 19** researched harnesses show clear evidence of markdown-based
custom-instruction support — consistent with the README's existing,
previously-unverified claim that "many harnesses that support custom
instructions/prompts can already read them directly even without a
dedicated install path." **Sourcegraph Cody** is the one harness where
this research did not turn up a confirmed markdown-native rules file (its
Custom Commands appear to be JSON-configured); this doesn't mean Cody
lacks the capability, only that it wasn't confirmed by this pass — a
target for hands-on verification, not a claim of absence.

## Caveat: Gemini CLI is being sunset

Google announced Gemini CLI's retirement in favor of **Antigravity CLI**:
Gemini CLI and Gemini Code Assist IDE extensions stopped serving requests
for consumer/Pro/Ultra tiers on **2026-06-18** (Google Code Assist
Standard/Enterprise licensees are unaffected). See the
[Google Developers Blog announcement](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/).
That date has already passed as of this research. The README's
compatibility table still lists "Gemini CLI" and "Antigravity (Google)" as
two separate 📋-planned harnesses — both entries stay accurate as *named
harnesses that exist*, but a future install-path implementation effort
should prioritize Antigravity over Gemini CLI, since Gemini CLI is no
longer the actively-maintained target for most users. Not changing the
README table's harness count/list here — that's a Principle III scope
call for whenever install work actually starts on either row — but
flagging it now so that future work isn't planned against a tool that's
already been retired.

## How to use this

When prioritizing which harness to actually build a real install path
for next (upgrading a 📋 row to ✅ in the README), start with the harnesses
above confirmed to already read a project-root markdown file with the
least ceremony (`AGENTS.md`-compatible ones — Codex CLI, OpenCode, Warp,
Trae, Replit's community `AGENT.md` symlink path — need zero new file
format, just a copy/symlink of the existing `SKILL.md` content into the
right filename). Harnesses with their own bespoke directory convention
(`.clinerules/`, `.continue/rules/`, `.amazonq/rules/`, `.aiassistant/rules/`)
need a small per-harness install-script branch, not a new content format.

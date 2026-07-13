# Harness Capability Notes

Desk-research notes on whether each of the 19 non-Claude-Code harnesses in
the [README's compatibility table](../README.md#supported-harnesses)
already supports reading plain Markdown (optionally YAML-frontmatter)
custom-instruction files — the same shape `SKILL.md` already ships in.
Closes `checklists/project-completeness.md` CHK002.

**Status update (specs/023-full-harness-coverage, 2026-07-13)**: every
harness this document tracks now has a real, CI-proven install path (see
the README's compatibility table). The original "what this is not" caveat
below is now historical — kept for its citations and reasoning, not
because the harder bar it describes remains unmet. Two findings from this
document changed materially during that work and are corrected here:
Antigravity turned out to have a genuine skills-directory mechanism
(`.agents/skills/`, same as Codex CLI), not just a markdown rules file, so
it's installed via that mode rather than a generated bridge file; and
Sourcegraph Cody's "Unclear" status was resolved with three further
research rounds (specs/023-full-harness-coverage/research.md) that found
no confirmed always-on rules file, so Cody is installed via its one
confirmed real mechanism instead — `.vscode/cody.json` custom commands,
invoked explicitly rather than loaded automatically.

**What this was (original framing, 2026-07-11)**: citation-backed desk
research (WebSearch against each tool's own docs/blog, one targeted query
per harness). At the time, nothing here had been installed, pointed at a
real `specjedi-*` `SKILL.md`, and run — that gap is what
specs/023-full-harness-coverage closed.

## Findings

| Harness | Markdown custom-instructions support? | Mechanism | Source |
|---|---|---|---|
| Cursor | Yes | `.cursor/rules/*.md` + reads `AGENTS.md` | [Cursor docs](https://cursor.com) |
| Windsurf (Codeium) | Yes | `.windsurfrules` / `.windsurf/rules/*.md` | Windsurf docs |
| GitHub Copilot (Chat/Workspace) | Yes | `.github/copilot-instructions.md`, `*.instructions.md` | [VS Code docs](https://code.visualstudio.com/docs/agent-customization/custom-instructions) |
| Codex CLI (OpenAI) | Yes | `AGENTS.md`, hierarchical discovery up the tree | OpenAI Codex CLI docs |
| Gemini CLI | Yes, but **see caveat below** | `GEMINI.md` | Google developer docs |
| Antigravity (Google) | Yes — **confirmed as a true skills directory**, not just a rules file | `.agents/skills/<name>/SKILL.md`, same convention as Codex CLI (confirmed 2026-07-13 via Google's own Codelabs/Developer docs and independent community verification posts) | [Google Developers Blog](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/), [Antigravity Skills docs](https://antigravity.google/docs/skills), [Codelabs: Authoring Antigravity Skills](https://codelabs.developers.google.com/getting-started-with-antigravity-skills) |
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
| Sourcegraph Cody | **Resolved as No** (see below) | No confirmed always-on markdown rules file after three research rounds; real mechanism is `.vscode/cody.json` custom commands (manual `/`-invocation, not automatic context) | [Sourcegraph Cody docs](https://docs.sourcegraph.com/cody/custom-commands), [Cody capabilities](https://sourcegraph.com/docs/cody/capabilities) |
| Trae | Yes | `.trae/rules/project_rules.md`; also compatible with `AGENTS.md`, `CLAUDE.md` | [Trae docs](https://docs.trae.ai/ide/rules) |

**18 of 19** researched harnesses show clear evidence of markdown-based
custom-instruction support. **Sourcegraph Cody** was the one harness where
the original pass did not turn up a confirmed markdown-native rules file;
specs/023-full-harness-coverage followed up with three further targeted
searches (a `capabilities` docs fetch plus two more searches, one of which
surfaced a red herring — search results conflating Cody with Sourcegraph's
separate Amp agent product, which does read `AGENTS.md`; that finding was
not used, since it's evidence about a different product) and still found
no confirmed always-on rules file. Cody's real, verified customization
surface — Custom Commands via `.vscode/cody.json` (`description`/`prompt`/
`contextFiles` fields) — is what the installer targets instead, with an
explicit note that this loads on manual `/`-invocation, not automatically
like every other harness in this table.

## Caveat: Gemini CLI is being sunset

Google announced Gemini CLI's retirement in favor of **Antigravity CLI**:
Gemini CLI and Gemini Code Assist IDE extensions stopped serving requests
for consumer/Pro/Ultra tiers on **2026-06-18** (Google Code Assist
Standard/Enterprise licensees are unaffected). See the
[Google Developers Blog announcement](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/).
That date has already passed as of this research. **Update
(specs/023-full-harness-coverage, 2026-07-13)**: both rows now have a
real, CI-proven install path — README's compatibility table lists
"Gemini CLI" and "Antigravity (Google)" as two separate ✅-supported
harnesses, not planned ones. Gemini CLI's install path was built anyway
(a still-technically-functioning, still-named harness in the matrix),
with the README explicitly flagging its sunset status rather than
presenting it as a first-choice recommendation — this caveat's original
warning (don't plan new work against a retired tool) was heeded, not
ignored, by building Antigravity's install path via the genuine
skills-directory mechanism this document's own top status update names,
rather than treating Gemini CLI's `GEMINI.md` bridge as the primary
path for either.

## How this was used

This was the prioritization input for specs/023-full-harness-coverage,
which built and CI-proved a real install path for every row above. The
original heuristic held up: harnesses confirmed to read a project-root
markdown file with the least ceremony (`GEMINI.md`, `.rules`, `replit.md`,
`CONVENTIONS.md`, `.devin.md`, `.github/copilot-instructions.md`) got a
single generated index file; harnesses with their own bespoke rules
*directory* (`.cursor/rules/`, `.windsurf/rules/`, `.clinerules/`,
`.continue/rules/`, `.amazonq/rules/`, `.aiassistant/rules/`,
`.tabnine/guidelines/`) got one small bridge file per skill instead. See
`scripts/install.sh`/`.ps1` for the implementation and
`specs/023-full-harness-coverage/research.md` for the per-harness
mechanism decisions and citations.

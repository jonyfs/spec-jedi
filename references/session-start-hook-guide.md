# Session-Start Hook Guide

What `scripts/session-start.sh`/`.ps1` do, how this repo wires them into
Claude Code, and — honestly, harness by harness — which of the other 19
supported harnesses are confirmed to have an equivalent mechanism versus
which are simply unknown. Ships in the release package
(`scripts/session-start.sh`/`.ps1`, this file) as a working example for a
user to adapt, not as something the installer configures automatically
(see [`references/harness-capability-notes.md`](harness-capability-notes.md)
if it's present in your checkout — it documents each harness's
*rules-file* support, a related but distinct capability from the hook
mechanism described here).

## What the script actually does

`session-start.sh`/`.ps1` implement Constitution Principle XXI: a
three-part session-start orientation. On invocation they:

1. Print an ASCII Spec Jedi banner.
2. Derive a project status summary from the same on-disk logic
   `specjedi-status` uses (feature counts by status, read directly from
   `spec.md`/`plan.md`/`tasks.md` files under `specs/` — no separately
   maintained tracking system).
3. Emit a rotating, context-aware Master Yoda greeting line, filtered by
   actual project state (an "empty project" line is never selected for a
   project with existing features, for example).

Everything printed to stdout becomes the hook's `additionalContext` —
Claude Code does not print hook stdout directly to the terminal. The
harness that invokes the hook is responsible for surfacing that context
to the assistant, which is then expected to render it as its opening
reply. This indirection is the reason the mechanism is a **hook**
(harness-invoked, output becomes context) rather than a plain startup
script (which would just print to the terminal directly).

## The Claude Code registration (a working example)

This repository's own `.claude/settings.json` registers the script as
follows:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash",
            "args": ["${CLAUDE_PROJECT_DIR}/scripts/session-start.sh"]
          }
        ]
      }
    ]
  }
}
```

To adapt this for your own project on Claude Code: copy
`scripts/session-start.sh` (or `.ps1` on Windows without a bash shell
available) into your project, then add the equivalent `SessionStart` hook
entry to your project's own `.claude/settings.json`, pointing `args` at
the script's actual location. `${CLAUDE_PROJECT_DIR}` is a Claude
Code-provided variable resolving to the project root; no other
substitution is required.

## Per-harness status: confirmed vs. unconfirmed

A **rules file** (a static Markdown file a harness always loads as
context) is a different capability from a **session-start hook** (a
harness invoking an external script at session start and injecting its
output as context). `references/harness-capability-notes.md` researched
and confirmed the former for all 20 harnesses below — it says nothing
about the latter. Do not read "has a rules file" as "has a hook
mechanism"; the table below keeps the two separate on purpose.

| Harness | Session-start hook / automation status |
|---|---|
| Claude Code | **Confirmed** — the exact mechanism this guide documents above (`SessionStart` hook, `.claude/settings.json`). |
| Cursor | Unconfirmed — not researched. Cursor's `.cursor/rules/*.md` is a static rules file, not a session-start script hook. Check Cursor's own docs for an equivalent automation/hook feature before assuming one exists. |
| GitHub Copilot (Chat/Workspace) | Unconfirmed — not researched. `.github/copilot-instructions.md` is a static rules file, not a hook. |
| Codex CLI (OpenAI) | Unconfirmed — not researched. `AGENTS.md` discovery is static, not a hook. |
| Gemini CLI | Unconfirmed — not researched, and Gemini CLI itself is being sunset in favor of Antigravity (see `references/harness-capability-notes.md`'s sunset caveat); not worth new investigation. |
| Antigravity (Google) | Unconfirmed — not researched. |
| Windsurf (Codeium) | Unconfirmed — not researched. `.windsurfrules`/`.windsurf/rules/*.md` is static. |
| Cline | Unconfirmed — not researched. `.clinerules` is static. |
| Continue | Unconfirmed — not researched. `.continue/rules/*.md` is static. |
| Aider | Unconfirmed — not researched. `CONVENTIONS.md` is static. |
| Amazon Q Developer | Unconfirmed — not researched. `.amazonq/rules/*.md` is static. |
| JetBrains AI Assistant | Unconfirmed — not researched. `.aiassistant/rules/*.md` is static. |
| Zed | Unconfirmed — not researched. `.rules` is static. |
| OpenCode | Unconfirmed — not researched. |
| Warp (Agent Mode) | Unconfirmed — not researched. |
| Replit Agent | Unconfirmed — not researched. `replit.md` is static. |
| Devin (Cognition) | Unconfirmed — not researched. `.devin.md` Playbooks are static. |
| Tabnine | Unconfirmed — not researched. Markdown Guidelines are static. |
| Sourcegraph Cody | Unconfirmed — not researched. Its confirmed mechanism (`.vscode/cody.json` Custom Commands) is manual `/`-invocation, not automatic — see `references/harness-capability-notes.md`. |
| Trae | Unconfirmed — not researched. `.trae/rules/project_rules.md` is static. |

If your harness turns out to support an equivalent hook/automation
mechanism, `scripts/session-start.sh`/`.ps1`'s own logic (steps 1-3
above) is harness-agnostic — only the *registration* (the
`.claude/settings.json` block, or whatever your harness's own mechanism
requires) needs adapting, not the script itself.

## Why this isn't installed automatically

`scripts/install.sh`/`.ps1` copy skills into a harness-appropriate
location because every supported harness's skill-loading path is already
confirmed (that's what makes `--harness <name>` meaningful). Session-start
hooks are different: only one harness's mechanism is confirmed here, and
auto-configuring a `.claude/settings.json`-shaped hook for a harness with
no confirmed equivalent would risk writing a file that either does
nothing or actively conflicts with that harness's own conventions. The
scripts and this guide ship so a user can adopt the pattern deliberately,
harness by harness, rather than the installer guessing on their behalf.

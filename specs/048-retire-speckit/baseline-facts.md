# Baseline facts (T001) — scratch reference, not a shipped doc

**Captured**: 2026-07-18, before any removal/edit in this feature.

## 11 `speckit-*` directories under `.claude/skills/` (to be deleted, T005)

- speckit-agent-context-update
- speckit-analyze
- speckit-checklist
- speckit-clarify
- speckit-constitution
- speckit-converge
- speckit-implement
- speckit-plan
- speckit-specify
- speckit-tasks
- speckit-taskstoissues

## `.specify/extensions.yml` current content (to be modified, T002)

```yaml
installed:
- agent-context
settings:
  auto_execute_hooks: true
hooks:
  after_specify:
  - extension: agent-context
    command: speckit.agent-context.update
    enabled: true
    optional: true
    priority: 10
    prompt: Execute speckit.agent-context.update?
    description: Refresh agent context after specification
    condition: null
  after_plan:
  - extension: agent-context
    command: speckit.agent-context.update
    enabled: true
    optional: true
    priority: 10
    prompt: Execute speckit.agent-context.update?
    description: Refresh agent context after planning
    condition: null
```

No `before_specify`/`before_plan`/`before_*`/`after_*` entries exist for
any other stage today.

## Constitution version at start

1.27.0 | Ratified 2026-07-10 | Last Amended 2026-07-18

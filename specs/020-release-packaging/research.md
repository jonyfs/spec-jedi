# Phase 0 Research: Release Packaging & Publishing Workflow

## Decision: `gh release create` handles tag creation atomically

**Decision**: Use `gh release create vX.Y.Z <artifact> --notes-file <notes> --target main`
directly, rather than a separate `git tag` + `git push` step followed by a
second `gh release create` call.

**Rationale**: Verified via `gh release create --help` on this machine
(gh 2.96.0): "If a matching git tag does not yet exist, one will
automatically get created from the latest state of the default branch.
Use `--target` to point to a different branch or commit for the automatic
tag creation." This means the tag and the release are created as a single
CLI invocation — reducing the failure surface to one step instead of two
(no risk of a tag existing with no corresponding release if the second
call failed).

**Alternatives considered**: A separate `git tag vX.Y.Z && git push origin
vX.Y.Z` step before `gh release create`. Rejected — strictly more failure
modes (a pushed tag with no release, if the second command fails) for no
benefit `gh release create`'s own atomic behavior doesn't already provide.

**What this means for FR-003 (version-uniqueness check)**: still
implemented as an explicit, independent check (`git tag -l vX.Y.Z` or `gh
api repos/:owner/:repo/git/refs/tags/vX.Y.Z`) run *before* calling `gh
release create` — not delegated to that command's own behavior, since the
goal is a clear, fast, purpose-written failure message (FR-003) rather
than however `gh release create` happens to behave when pointed at an
existing tag (untested, and not the right place to discover that
behavior for the first time).

## Decision: `workflow_dispatch` input schema

**Decision**:

```yaml
on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to release (vX.Y.Z)'
        required: true
        type: string
      dry_run:
        description: 'Validate and package only — no tag, release, or commit'
        required: false
        type: boolean
        default: true
```

**Rationale**: This is GitHub Actions' own documented `workflow_dispatch`
input schema (`type: string`/`type: boolean` with `default:`) — no custom
parsing needed; `dry_run` defaults to `true` so triggering the workflow
without deliberately overriding it can never accidentally publish
(spec.md FR-002, FR-007).

## Decision: packaging via `tar` + explicit file list, not a wildcard copy

**Decision**: `scripts/package-release.sh` explicitly lists the four
`.specify/templates/*.md` files and globs only `.claude/skills/specjedi-*/`
(never `speckit-*`) into a staging directory, then `tar -czf`s that
staging directory — the same explicit-allowlist approach
`scripts/install.sh` already uses for its own copy loop, not a "copy
everything except X" denylist approach.

**Rationale**: Consistency with the existing installer's own security/
correctness posture (allowlist, not denylist) — matches spec.md FR-005's
"nothing else" requirement precisely, and re-uses a pattern this codebase
has already had CI-verified (features 016/017/018/019) rather than
inventing a new one.

## Decision: `CHANGELOG.md` rewrite is a plain-text transform, not a templating engine

**Decision**: The real-run path replaces the line `## Unreleased` with:

```markdown
## Unreleased

## [vX.Y.Z] - YYYY-MM-DD
```

i.e. inserts a new versioned heading directly below the (now-empty)
`## Unreleased` heading, leaving the section content that was under
`## Unreleased` attached to the new `## [vX.Y.Z]` heading unchanged. A
single `sed`/`awk` substitution over the existing well-known heading
string — no changelog-generation library, since the file's own existing
convention (established across every prior feature's CHANGELOG entry
this session) is hand/agent-authored Markdown under a `## Unreleased`
heading, not a machine-templated format.

**Rationale**: Matches Keep a Changelog's own convention (which
`CHANGELOG.md`'s header already declares it loosely follows) — a fresh
empty `## Unreleased` above each versioned section, ready for the next
cycle's entries.

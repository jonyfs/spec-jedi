# Security Question Bank (Constitution Principle II, `specjedi-security`)

The maintained taxonomy `specjedi-security` draws from — extend this file
(never invent a category or question ad hoc inline) as new blind spots
recur across features, the same way `references/star-wars-lexicon.md`
stays the single canonical pool for voice/emoji.

Every entry is a specific, answerable question — never a vague "is this
secure?" prompt. `specjedi-security` surfaces a question only when the
spec/plan hasn't already addressed it; an already-answered category is
never asked about again.

## Authentication

- Which authentication method is used, and is it named explicitly (not
  left as "the user logs in")?
- How are sessions maintained after login — token, cookie, something
  else — and what's the expiry/revocation behavior?
- What happens on repeated failed login attempts (rate limiting, lockout,
  neither)?

## Input Validation

- For every external input the spec names, is there an explicit statement
  of what invalid input looks like and what happens to it?
- Is user-supplied content ever rendered, executed, or interpolated into
  another system (HTML, a query, a shell command) without a stated
  escaping/sanitization approach?
- Are file uploads (if any) validated for type/size, or left unconstrained?

## Secrets / Credentials

- Where are credentials, API keys, and tokens stored — explicitly named
  (environment variable, secret manager), or left unspecified?
- Does any part of the spec/plan risk a secret ending up in source
  control, logs, or client-visible output?
- Is credential rotation ever mentioned, or silently assumed unnecessary?

## Data Privacy

- Does the feature handle any personal or sensitive data, and if so, is
  its retention/deletion behavior stated?
- Is data ever sent to a third-party service, and if so, is that named
  explicitly rather than implied?
- Are access controls on sensitive data stated (who can see what), or
  left to be figured out later?

## Dependency / Supply-Chain Risk

- Does the plan introduce a new external dependency, and if so, is its
  trust level (maintainer reputation, install count, license) considered
  anywhere?
- Is a dependency pinned to a specific version, or left to float
  unconstrained?

## Extending this file

New categories or questions get added here first, then referenced from
`specjedi-security`'s own output — never invented inline and left
undocumented, the same discipline `references/star-wars-lexicon.md`
already establishes for voice consistency.

# Feature Specification: Original Illustrations for the Internal-Bootstrap Comic

**Feature Branch**: `035-comic-panel-illustrations`

**Created**: 2026-07-13

**Status**: Draft

**Input**: User description: transform README.md's "How Spec Jedi
builds itself, in comic form" section with comic-style images. Two
constraints emerged and were resolved before drafting this spec: (1) a
request to generate imagery specifically evocative of Star Wars —
even without named characters — was declined (Constitution Principle
XII already commits this project to text-only Star Wars references,
and generating art in the recognizable visual style of an actively-
copyrighted franchise is outside what this session will produce); the
user chose genuinely original sci-fi art instead. (2) No image-
generation tool was initially available in this session; research
found and verified Pollinations.ai, a free, no-account, no-API-key
image-generation endpoint, confirmed reachable via a real test request
this session (HTTP 200, real image returned).

## Clarifications

### Session 2026-07-13

- Q: FR-003 requires a failing image to be "regenerated with a revised
  prompt" but names no bound — how many regeneration attempts before
  falling back? → A: 2 regeneration attempts per panel (3 generations
  total: original + 2 revisions), then an honest fallback — that panel
  ships text-only, explicitly marked as image-not-generated, rather
  than retrying indefinitely (matching feature 026's bounded-retry
  precedent for the same class of decision). Defaulted to the
  Recommended option stated during `/speckit-clarify`; the user moved
  directly to `/speckit-plan` without an explicit reply, so this is
  recorded as an applied default, not a confirmed answer, per this
  project's own "recommend, then proceed" pattern.

## Problem

The comic section's 8 panels are currently text-and-emoji only — a
deliberate choice recorded in Constitution Principle XII to avoid any
risk of reproducing or evoking Lucasfilm/Disney's copyrighted Star Wars
imagery. That constraint stands. What's missing is a visual layer that
respects it: original illustrations with their own distinct identity,
supplementing (never replacing) the existing prose.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Every panel gets one consistent, original illustration (Priority: P1)

A reader scrolling the comic section sees one image per panel,
depicting that panel's scene, all sharing a single recognizable visual
style — not a text-only wall, and not 8 unrelated images that happen to
sit near each other.

**Why this priority**: This is the entire ask — a more visual section,
delivered without the IP risk the declined direction carried.

**Independent Test**: View the rendered README on GitHub; confirm all 8
panels each show one image, and confirm a reader can tell all 8 belong
to the same visual set without being told so.

**Acceptance Scenarios**:

1. **Given** the comic section, **When** it renders on GitHub, **Then**
   each of the 8 panels displays one image alongside its existing text
   and dialogue — text unchanged, image added.
2. **Given** all 8 images, **When** viewed together, **Then** they
   share one consistent art style, palette, and rendering approach.
3. **Given** any one of the 8 images, **When** viewed by someone
   unfamiliar with this project, **Then** nothing in it reads as Star
   Wars-branded or Star-Wars-specific (no glowing-blade weapon
   silhouette, no X-wing/TIE-fighter/Star-Destroyer-shaped craft, no
   twin-sun desert-planet framing, no Jedi-robe-specific silhouette, no
   Star Wars logo/wordmark).

---

### User Story 2 - Style direction is approved once, before all 8 are made (Priority: P1)

Before committing to 8 final images, the maintainer sees one sample in
the intended style and explicitly approves it (or asks for a different
direction) — so a style mismatch is caught at sample 1, not discovered
after all 8 are already generated and placed.

**Why this priority**: Equal priority to US1 — generating 8 images on a
direction nobody confirmed risks redoing all 8, and this is exactly the
kind of visual/taste decision this project's own standing practice
checks with the user before committing to (Principle IV).

**Independent Test**: Before the remaining 7 images are generated,
confirm one sample image was presented and an explicit go-ahead (or a
revised direction) was received.

**Acceptance Scenarios**:

1. **Given** no images exist yet, **When** the visual style is decided,
   **Then** exactly one sample is generated and shown before any
   further generation proceeds.
2. **Given** the sample is approved, **When** the remaining 7 panels
   are generated, **Then** they follow the same approved style
   consistently.
3. **Given** the sample is rejected, **When** a revised direction is
   proposed, **Then** a new sample is shown before proceeding — never
   silently guessing a second time.

---

### User Story 3 - A future maintainer can regenerate or adjust any single panel (Priority: P2)

A maintainer who later wants to tweak panel 5's image (a different
detail, a fix) can do so without having to reverse-engineer the visual
style from the other 7 images alone.

**Why this priority**: Lower than US1/US2 — this is a maintainability
safeguard, not the visible feature itself, but without it, this
project's own "future work shouldn't have to re-derive a decision that
already exists" discipline (the same reasoning behind `research.md`
files generally) would be quietly violated for this one feature.

**Independent Test**: Find the prompt used for any one panel's image;
confirm it's recorded somewhere durable, not only in this session's own
now-unrecoverable history.

**Acceptance Scenarios**:

1. **Given** any one of the 8 shipped images, **When** a maintainer
   looks for the prompt that produced it, **Then** it's found in a
   durable, committed location — not lost once this session ends.

### Edge Cases

- What happens if the image-generation service is slow, rate-limited,
  or briefly unavailable during generation? → No live/runtime
  dependency exists for this feature's actual readers — generation
  happens once, during implementation, producing static files committed
  to the repository; a hiccup only affects the implementer's own
  session and is simply retried.
- What if a generated image, despite an original-style prompt,
  accidentally reads as Star-Wars-evocative once actually rendered? →
  It MUST be reviewed before being committed and regenerated with a
  revised prompt if it fails that review — never shipped as-is on the
  assumption the prompt alone was sufficient.
- What if a panel's image still fails review after 2 regeneration
  attempts? → That panel ships text-only, explicitly marked as
  image-not-generated — an honest, bounded fallback rather than
  retrying indefinitely or shipping a failing image (FR-003).
- What happens to the existing panel text and emoji dialogue? → Kept in
  full; per Constitution Principle XII, a visual is always a supplement
  to prose, never a replacement.
- What about the 10 localized README translations? → Out of scope for
  this feature. The images carry no embedded text, so no translation
  work is triggered by adding them — each localized README can
  reference the same language-agnostic image files.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each of the 8 existing comic panels MUST gain one
  accompanying original illustration depicting that panel's scene.
- **FR-002**: All 8 illustrations MUST share one single, consistent
  visual identity (art style, palette, rendering approach) — not 8
  stylistically unrelated images.
- **FR-003**: No illustration MUST evoke Star Wars' specific,
  recognizable visual signatures — named explicitly: glowing-blade
  weapon silhouettes, X-wing/TIE-fighter/Star-Destroyer-shaped craft,
  twin-sun desert-planet framing, Jedi-robe-specific silhouettes, or
  the Star Wars logo/wordmark. Every prompt used MUST be checked
  against this list before generation, and every resulting image MUST
  be reviewed against it again after generation, before being
  committed. A failing image MUST be regenerated with a revised prompt
  up to 2 times (3 generations total per panel); if it still fails
  after that, the panel MUST ship text-only, explicitly marked as
  image-not-generated, rather than retried indefinitely or shipped
  despite failing review (Clarifications, Session 2026-07-13).
- **FR-004**: Before generating the remaining 7 final panel
  illustrations, exactly one sample illustration in the intended style
  MUST be generated and presented for explicit maintainer approval.
  Generation of the remaining 7 MUST NOT begin without that approval.
- **FR-005**: The existing panel text and emoji dialogue MUST remain in
  full and unchanged in meaning — illustrations supplement, they never
  replace (Constitution Principle XII).
- **FR-006**: Generated images MUST be committed as static files in the
  repository. The README MUST NOT depend on a live call to any external
  image-generation service at read time — a reader's browser only ever
  loads a committed file, never triggers new generation.
- **FR-007**: The prompt used for each panel's final illustration MUST
  be recorded in a durable, committed location (not only in this
  session's own transient history) so a future maintainer can
  regenerate or adjust any single panel without re-deriving the visual
  style from scratch.
- **FR-008**: Constitution Principle XII's own text — which currently
  states these are "text-and-emoji comic panels, not generated
  artwork" — MUST be amended to reflect the new reality, adding an
  explicit, durable guardrail: any generated artwork this project ships
  MUST maintain an original visual identity and MUST NOT attempt to
  evoke Star Wars' specific recognizable visual signatures (the same
  list FR-003 names).

### Key Entities

*(Not applicable — this feature adds static image assets and a
supporting prompt record; no data model is introduced.)*

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 8 panels have an accompanying image file committed to
  the repository and visible when the README renders on GitHub.
- **SC-002**: A reader can identify all 8 images as sharing one
  coherent visual style without being told they're related.
- **SC-003**: Zero of the 8 committed images depict any item from
  FR-003's named list of Star-Wars-specific visual signatures.
- **SC-004**: The prompt behind every one of the 8 committed images is
  findable in the repository by a future maintainer, without needing
  this session's own history.

## Assumptions

- Image-generation service: Pollinations.ai's free, no-account,
  no-API-key endpoint (`https://image.pollinations.ai/prompt/...`),
  confirmed reachable and functional this session via a real HTTP
  request (200 response, real image returned) — not assumed from
  documentation alone. No account creation, no credential entry, no
  payment method involved, consistent with this project's standing
  rules against autonomous account/credential actions.
- Images are committed under a new `docs/comic/` directory (e.g.
  `docs/comic/panel-1.jpg` … `panel-8.jpg`), matching this project's
  existing `docs/i18n/` convention for auxiliary documentation assets
  living outside the repository root.
- Images carry no embedded text (panel dialogue stays in the existing
  Markdown prose, per FR-005) — this also means no per-image
  translation burden for the 10 localized READMEs.
- This feature's own scope is the English `README.md`'s comic section.
  The localized translations can reference the same language-agnostic
  image files without their own translation pass, consistent with
  Principle I's whole-project (not per-feature) localization cadence.
- The Principle XII amendment (FR-008) is a MINOR constitution version
  bump — materially expanded guidance for a capability (generated
  artwork) the principle previously scoped out entirely, not a wording
  clarification.

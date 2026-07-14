# Research: README as a Wise Jedi's Letter

**Goal**: resolve the two real technical decisions this feature has —
exactly which 2-3 images to generate and where, and the prompt/style
strategy that keeps them visually continuous with the existing comic
section while passing Constitution Principle XII's art guardrail.

## Principle II note

This is a documentation/creative-content feature, not a new capability
needing competitive-tool benchmarking — no external research field
applies here. The one technical mechanism this feature depends on
(Pollinations.ai keyless image generation) was already researched and
verified end-to-end in feature 035 (`specs/035-comic-panel-illustrations/research.md`);
this feature reuses that verified mechanism rather than re-researching it.

## Decision: exactly 2 new images, not 3

**Decision**: this feature generates 2 new images — a letter-opening
image and a "the right path" image marking the discipline/"right side
of the Force" passage — staying at the low end of FR-008's approved
2-3 range.

**Rationale**: spec.md's FR-007 requires new images to never duplicate a
beat the existing 8-panel comic section already tells. A third,
closing/send-off image was considered and rejected specifically because
comic panel 8 (`docs/comic/panel-8.jpg`, "a sleek original-design
starship streaking away against a starfield," captioned "Shipped... May
the Spec be with you") already *is* the send-off beat — a third image
here would either duplicate it or force an artificially different
closing moment that dilutes the existing one. Two images, each covering
a genuinely new beat the comic section doesn't already have, is the
more disciplined choice — consistent with FR-008's own "images that earn
their keep" standard.

**Alternatives considered**: 3 images (open + path + close) — rejected
per the redundancy reasoning above. 1 image (open only) — rejected as
under-serving US3's "right side of the Force" framing, which is a
distinct, real narrative beat (the discipline/values passage) worth its
own image, not just prose.

## Decision: image placement

**Decision**:
1. **Letter-opening image** — placed immediately after the README's
   title block/badges, before the rewritten opening pitch paragraph.
   Establishes the letter framing visually before a single word of the
   letter's body is read.
2. **"The right path" image** — placed within the rewritten passage
   connecting disciplined practice (constitution-first, test-first, no
   shortcuts) to "the right side of the Force," near the existing "No
   shortcuts to the Dark Side of vibe-coding" line.

**Rationale**: these are the two moments the spec's User Stories
actually call out as needing more than prose — US1's "letter from a
mentor" framing needs an opening visual anchor, and US3's discipline-as-
Force-alignment framing is exactly the passage warranting reinforcement.
Every other narrative section (Who this is for, What you get today
intro, Quickstart) gets letter-voice prose per FR-005 but doesn't need
its own dedicated image — matching FR-008's small-and-deliberate
standard.

## Decision: reuse `docs/comic/` directory and feature 035's exact style descriptor

**Decision**: new images live at `docs/comic/letter-open.jpg` and
`docs/comic/letter-path.jpg` — same directory as the 8 existing comic
panels, using the identical style descriptor feature 035 already
verified passes Principle XII's review:
*"retro-futurist sci-fi illustration, warm amber and teal palette, flat
vector art style with soft cel-shading, clean geometric lines,
cinematic lighting, no text, no logos"*, generated via
`https://image.pollinations.ai/prompt/{prompt}?width=768&height=512&seed=N&nologo=true&model=flux`
(exact mechanism, feature 035).

**Rationale**: visual continuity — a reader shouldn't be able to tell
these two images were generated in a separate session/feature from the
original 8; reusing the exact proven style string and directory
convention is simpler and lower-risk than inventing a new visual
language plan.md's own Structure Decision already committed to avoiding.

**Alternatives considered**: a new `docs/letter/` directory with a
distinct visual style — rejected; plan.md's Structure Decision already
reasoned this feature is "thematically continuous" with the comic
section, not a new visual context, so a separate directory/style would
contradict that reasoning without a real benefit.

## Content-specific prompts (subject/content differs from feature 035's Star Wars-cycle panels; style descriptor identical)

1. **`letter-open.jpg`**: *"a weathered scroll and a glowing quill resting
   on a stone desk in a quiet observatory, starlight visible through a
   high window, {style descriptor}"* — evokes "letter being written by a
   wise, unhurried figure" without depicting a face/character (avoiding
   any risk of an implied Jedi-robe silhouette).
2. **`letter-path.jpg`**: *"a single figure at a fork in a stone path, one
   trail lit by warm amber lanterns leading upward, the other fading into
   cold shadow, {style descriptor}"* — the "right path" concept rendered
   as a literal fork-in-the-road, deliberately avoiding any
   lightsaber-colored (blue/green/red glowing blade) visual cue for
   "light vs. dark," per Principle XII's explicit exclusion list.

Both prompts avoid every item on Principle XII's named exclusion list by
construction (no blade weapons, no starships, no twin suns, no robed
silhouette, no logo/wordmark) — reviewed again visually after actual
generation, per Principle XX (never assume compliance, verify it).

## Verification note (updated post-generation during implementation)

Both images were generated for real via
`https://image.pollinations.ai/prompt/{url-encoded prompt}?width=768&height=512&seed=N&nologo=true&model=flux`
during `/speckit-implement`, downloaded directly (`curl`), and viewed
before being accepted:

- `docs/comic/letter-open.jpg` — seed `2001`. Depicts a scroll and
  glowing quill on a stone desk before an arched window showing
  starlight and a single moon. Reviewed: no glowing-blade weapon, no
  starship, no twin suns (one moon, not two), no Jedi-robe-specific
  silhouette (no figure present at all), no logo/wordmark. Passed on
  the first generation — no revision needed.
- `docs/comic/letter-path.jpg` — seed `2002`. Depicts a single small,
  dark-coated figure walking away along a lantern-lit stone path
  through a rocky canyon. Reviewed: no glowing-blade weapon, no
  starship, no twin-sun desert framing (a canyon, not a desert, and
  only ambient sky, no visible suns), no Jedi-robe-specific silhouette
  (a generic dark coat, not the distinctive hooded Jedi-robe cut), no
  logo/wordmark. Passed on the first generation — no revision needed.

Both images shipped 2/2 clean on the first attempt, same as feature
035's 8/8 clean first-attempt result — the reused style descriptor and
the deliberately abstract, weapon-free/character-free prompt content
(a desk, a path — never a named figure) continues to avoid the
exclusion list by construction, not by luck.

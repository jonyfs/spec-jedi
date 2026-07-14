# Research: Original Illustrations for the Internal-Bootstrap Comic

**Goal**: this is a revision to an already-shipped README section
(feature 029's own comic-section-refresh work), not a new `specjedi-*`
skill, workflow, or structural pattern — Principle II's ten-competitor
benchmarking gate doesn't apply fresh here (same posture as features
025/026). The real research need is technical: confirm the chosen
image-generation service's actual parameters and behavior firsthand,
not assumed from memory, and design a prompt strategy that satisfies
FR-002 (one consistent visual identity) and FR-003 (never evokes Star
Wars' specific signatures) — the two requirements with zero margin for
guessing.

## Decision: Pollinations.ai, `flux` model, verified via two real test requests

**Decision**: Use `https://image.pollinations.ai/prompt/{prompt}` with
`model=flux` (the service's own default), `nologo=true`, a fixed
`width`/`height`, and a per-panel `seed`.

**Rationale**: Fetched the service's own official API docs
(`raw.githubusercontent.com/pollinations/pollinations/master/APIDOCS.md`)
rather than relying on the earlier session's WebSearch summary alone.
Confirmed parameters: `prompt` (required), `model` (`flux` default,
`turbo`, `stable-diffusion` also available), `width`/`height`, `seed`
(same seed + same prompt → same image), `nologo` (docs say "needs
account" in the parameter table, but the Authentication section only
says registering "gives higher limits and extra features, like
removing watermarks" — ambiguous on whether `nologo=true` is honored
anonymously). **Resolved by direct test, not left ambiguous**: two real
requests this session —
1. A flat minimalist icon prompt (10.8 KB JPEG, 512×512, viewed
   directly) — no watermark visible.
2. A full illustrated scene prompt ("a lone console terminal glowing in
   a dark workshop, retro-futurist sci-fi illustration, teal and amber
   palette, flat vector style", `nologo=true`, `seed=4242`, 768×512,
   52.9 KB JPEG, viewed directly) — no watermark visible, genuinely
   original retro-futurist style, nothing evoking Star Wars.

Both real, viewed results confirm `nologo=true` works in practice for
anonymous requests at this usage volume (8-27 images total, well under
any volume that would plausibly trigger throttling behavior beyond the
~1-request/15-seconds anonymous rate limit already documented).

**Alternatives considered**:
- *Canva's `generate-design` tool* — rejected: template/stock-photo-
  composition based (poster, social post, card), not custom narrative
  illustration; would produce a stock-photo collage with text overlay,
  not a consistent 8-panel illustrated set.
- *A local open-source model (Stable Diffusion via `diffusers`/
  ComfyUI)* — rejected: real setup overhead (multi-GB model download,
  meaningfully slow CPU inference without a GPU) for a one-time,
  8-image generation task that a free hosted API already serves in
  seconds per image.
- *Any service requiring account creation or a payment method* —
  rejected outright, not on technical merit but on this session's own
  standing boundary: creating accounts or entering credentials/payment
  details on the user's behalf is not something this session performs,
  regardless of how the service is otherwise evaluated.

## Decision: consistency via a shared style descriptor, not shared seed alone

**Decision**: Every one of the 8 final prompts ends with the identical
style-descriptor clause: *"retro-futurist sci-fi illustration, warm
amber and teal palette, flat vector art style with soft cel-shading,
clean geometric lines, cinematic lighting, no text, no logos."* Each
panel gets its own `seed` (not a shared one) — the scene content
differs per panel, so a shared seed would not itself produce visual
coherence the way a shared style descriptor does.

**Rationale**: The two test images already demonstrate the mechanism —
neither shares a seed, but both would read as belonging to one set
once the same style descriptor governs both (only the second test used
it fully; the icon test used a shorter, different-purpose prompt).
`seed` reproduces one specific image exactly; it doesn't transfer style
across genuinely different scene content the way a consistent
descriptor clause does.

**Alternatives considered**: *One shared seed across all 8 prompts* —
rejected: Pollinations' own docs describe `seed` as "get the same image
every time" for the *same* prompt — with 8 different scene prompts, a
shared seed doesn't reliably transfer palette/style the way appending
the same descriptor clause to every prompt does, and risks unwanted
compositional bleed-through between unrelated scenes.

## Decision: no dedicated "negative prompt" parameter exists — FR-003 is enforced by construction + review, not by a technical exclusion field

**Decision**: Pollinations' documented parameter set has no negative-
prompt field. FR-003's Star-Wars-signature exclusion is therefore
enforced two ways, both already in spec.md: (1) every prompt is
constructed using only original descriptive language — "a robed
mentor," "a bladed tool," "a sleek original-hulled craft" — never
franchise-specific nouns ("Jedi," "lightsaber," "X-wing"); (2) every
resulting image is visually reviewed against FR-003's named list before
being committed, with the 2-regeneration-attempt bound (Clarifications,
Session 2026-07-13) if a first attempt fails.

**Rationale**: Grounded in what the API actually offers (confirmed via
its own docs), not assumed to have a negative-prompt mechanism common
to some other image APIs. Word-choice discipline at prompt-construction
time is the primary control; visual review is the verification step
that catches anything word choice alone didn't prevent.

## Decision: per-panel prompt content (all 8, English-canonical per Principle I)

Each combines a scene description with the shared style-descriptor
clause above. Scene descriptions are deliberately original re-
imaginings of each panel's existing beat, never naming Star Wars
elements:

Each row below is the exact, final prompt used to generate the
committed image (scene description + the shared style clause,
verbatim) — updated here after implementation to reflect reality, not
just the original draft (FR-007). Every one of the 8 passed FR-003's
review on the first attempt — zero regenerations were needed for any
panel.

1. **Panel 1** (lone terminal) — `seed=1001`: *"a lone glowing console
   terminal in a dark workshop, blinking cursor on screen, retro-
   futurist sci-fi illustration, warm amber and teal palette, flat
   vector art style with soft cel-shading, clean geometric lines,
   cinematic lighting, no text, no logos"* — this is also the
   FR-004 sample, approved by the user before Panels 2-8 proceeded.
2. **Panel 2** (hooded figure, scroll) — `seed=1002`: *"a robed
   archivist-mentor figure emerging from shadow, unrolling a glowing
   data-scroll, [style clause]"*. FR-003 review: the robe's silhouette
   is rounder/cloak-like (not the layered tunic-belt-robe structure of
   a Jedi-specific silhouette) and colored teal/amber, not the
   brown/tan of that specific reference — passes.
3. **Panel 3** (idea pinned to wall) — `seed=1003`: *"a corkboard
   covered in holographic sticky-notes and glowing question-mark
   glyphs, connected by red string, [style clause]"*. No Star Wars
   connection of any kind — passes trivially.
4. **Panel 4** (blueprint on workbench) — `seed=1004`: *"a technical
   schematic unrolling across a cluttered engineer's workbench, tools
   scattered around it, [style clause]"*. Passes trivially.
5. **Panel 5** (tests red→green) — `seed=1005`: *"a workshop wall of
   status lights flickering from red to green, gears turning, [style
   clause]"*. Passes trivially.
6. **Panel 6** (council chamber, PR before bench) — `seed=1006`: *"a
   circular chamber, robed elders seated around a raised dais, a
   glowing document floating before them, [style clause]"*. FR-003
   review: no individual raised chairs or glass-domed ceiling (the
   specific, recognizable shape of Star Wars' own council-chamber
   imagery) — this is seated figures in a circle around a central glow,
   a broader "council of elders" trope with real precedent outside
   Star Wars — passes.
7. **Panel 7** (green light, gate opens) — `seed=1007`: *"a massive
   mechanical blast door irising open under a green beacon light,
   [style clause]"*. Abstract concentric-ring iris/portal imagery, no
   Star Wars connection — passes.
8. **Panel 8** (ship leaps to hyperspace) — `seed=1008`: *"a sleek
   rounded-hull original-design starship streaking away leaving a
   light-trail against a starfield, [style clause]"*. FR-003 review:
   single unified dart-shaped hull, no four-way split S-foil wings
   (X-wing), no spherical/hexagonal cockpit pod with flat side panels
   (TIE fighter), no large wedge-shaped hull (Star Destroyer) — passes
   on a literal check against the named list, not a subjective
   "does this feel Star-Wars-y" judgment.

`[style clause]` above is the literal text: *"retro-futurist sci-fi
illustration, warm amber and teal palette, flat vector art style with
soft cel-shading, clean geometric lines, cinematic lighting, no text,
no logos"* — identical across all 8 prompts (FR-002).

## Decision: image storage, format, and embedding

**Decision**: `docs/comic/panel-N.jpg` (N = 1-8), 768×512 JPEG,
embedded in `README.md` via standard Markdown image syntax immediately
below each panel's existing text block.

**Rationale**: `docs/comic/` mirrors the existing `docs/i18n/`
convention (auxiliary documentation assets outside repo root). JPEG at
768×512 matches the verified test image's own format/dimensions and
keeps file size modest (~50 KB observed) for a README that already
loads multiple badges and diagrams. Images sit directly under their
panel's text (never replacing it, per FR-005) so the existing text-only
reading experience is fully preserved for anyone whose Markdown
renderer doesn't display images.

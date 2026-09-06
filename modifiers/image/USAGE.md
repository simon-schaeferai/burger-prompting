# Composition Rules

How to combine modifiers without breaking the output. Applies to BOTH edit and generation flows. For generation flow, also read FRAMEWORK.md — it specifies the block structure the composed modifiers go into.

## Edit vs generation flow (quick summary)

- **Edit flow**: concatenate verbatim modifier text in the order shown in "Recommended prompt order" below. Append the subject sentence at the end. No labels.
- **Generation flow**: same modifier picks and conflict rules apply, but the composed text gets distributed into the 5 blocks defined in FRAMEWORK.md (Subject / Composition / Lighting / Camera / Style). Labels stay in the output.

## How many modifiers per prompt

- **Minimum useful**: 2 (e.g. one shot + one lighting)
- **Sweet spot**: 4–6 modifiers
- **Ceiling**: 8. Beyond this, modifiers start fighting each other and the model picks winners unpredictably.
- **Hard cap**: never stack 3+ modifiers from the same "overall look" group (see Look Group below).

## The "overall look" group — pick ONE

These categories all define the dominant aesthetic of the image. They fight each other. Choose ONE per prompt.

- `film-stocks` (FILM-)
- `cinematic-styles` (STYLE-)
- `commercial-styles` (COMM-)
- `cameras` (CAM-)
- `photo-effects` (EFFECT- — most of them; see exceptions below)

EXCEPTIONS in `photo-effects` that can layer on top of a look choice without conflict:
- `EFFECT-MOTION-BLUR` (technique, not a look)
- `EFFECT-LONG-EXPOSURE` (technique)
- `EFFECT-REFLECTIONS` (additive)
- `EFFECT-LENS-FLARE` (additive)
- `EFFECT-CHROMATIC-ABERRATION` (additive imperfection)

## Composition categories — stack freely

These layer cleanly on top of an "overall look" choice. Most prompts pull one from each as needed.

- `shots` — framing scale
- `angles` — camera position
- `lighting` — light setup
- `depth` — spatial layers, bokeh
- `framing` — frame-within-frame (NOT with `scene-extender` or `single-shots`)
- `lenses` — optical character (NOT with cameras that lock their own optics; see `cameras.md`)
- `emotions` — character expression (only if there's a character)
- `weather` — atmospheric conditions
- `realism` — quality boost

## The "reframe" group — pick ONE, and it overrides composition

These redefine the composition. Each one replaces shot/angle/framing choices.

- `single-shots` (SINGLE-) — same moment, new camera position
- `scene-extender` (EXTEND-) — show more of the world
  - directional extends (left/right/up/down) CAN stack with each other
  - zoom-out variants (2x, 4x) should be used alone

If you use a reframe tag, do NOT also use shots, angles, or framing tags. The reframe wins.

## Recommended prompt order

Place tags in this order in the final composed prompt for the most reliable output:

1. **Reframe** (if any) — `SINGLE-` / `EXTEND-`
2. **Shot** — `SHOT-`
3. **Angle** — `ANGLE-`
4. **Framing** — `FRAME-`
5. **Subject + Emotion** — `EMO-` (if character)
6. **Depth** — `DEPTH-` / `REALISM-DOF`
7. **Overall look** — `FILM-` / `STYLE-` / `COMM-` / `CAM-` / non-additive `EFFECT-`
8. **Lens** — `LENS-`
9. **Lighting** — `LIGHT-`
10. **Weather** — `WEATHER-`
11. **Creative transform** (if any) — `CREATIVE-`
12. **Realism boosters** — `REALISM-` (except `REALISM-DOF` which goes at step 6)
13. **Additive photo effects** — `EFFECT-LENS-FLARE`, `EFFECT-CHROMATIC-ABERRATION`, etc.

## Natural pairings (these always work well)

- `STYLE-NEON-NOIR` + `LIGHT-NEON` + `WEATHER-RAIN` + `LIGHT-NIGHT`
- `FILM-CINESTILL-800T` + `LIGHT-NIGHT` + `LIGHT-NEON` (the film stock already has the look)
- `STYLE-HOLLYWOOD-GLAMOUR` + `LIGHT-LOW-KEY` + `EFFECT-FILM-NOIR-BW`
- `COMM-LUXURY` + `LIGHT-LOW-KEY` + `LENS-SUMMILUX`
- `COMM-BEAUTY` + `LIGHT-WINDOW` + `LENS-DREAM-LENS` + `REALISM-HYPER-DETAIL`
- `ANGLE-LOW` + `LIGHT-RIM` + `STYLE-NEON-NOIR` (hero shot energy)
- `LENS-PETZVAL` + `REALISM-DOF` + `LIGHT-WINDOW` (vintage portrait)
- `WEATHER-FOG` + `LIGHT-GOD-RAYS` + `DEPTH-AERIAL` (mystical depth)
- `STYLE-INDIE-A24` + `FILM-PORTRA-400`-adjacent grain + `LIGHT-SOFT-DAYLIGHT` (use STYLE alone, FILM alone is also fine — pick one)

## Common conflicts to avoid

- `LIGHT-DAY` + `LIGHT-NIGHT` — pick one
- `LIGHT-HIGH-KEY` + `LIGHT-LOW-KEY` — pick one
- `EFFECT-CRUSHED-BLACKS` + `EFFECT-LIFTED-BLACKS` — pick one
- Any two B&W effects (`EFFECT-BW-HIGH-CONTRAST`, `EFFECT-FILM-NOIR-BW`, `EFFECT-CYANOTYPE`, `EFFECT-DUOTONE`, `EFFECT-INFRARED`) — pick one
- `WEATHER-SNOW` + `WEATHER-RAIN` — pick one
- `FILM-` + `STYLE-` + `CAM-` + `COMM-` — only one from this group
- `LENS-` + lens-locked camera (e.g. `CAM-GOPRO`, `CAM-IPHONE-15-PRO`, `CAM-DISPOSABLE`, `CAM-CCTV`, `CAM-WEBCAM`, `CAM-VHS`, `CAM-RING`, `CAM-DJI-DRONE`)
- `CREATIVE-` + multiple `CREATIVE-` (e.g. underwater + fire) — pick one
- `shots`/`angles`/`framing` + any `SINGLE-` or `EXTEND-` — the reframe wins
- `CAM-POLAROID` + `FILM-POLAROID-600` — they describe the same look, pick one
- `STYLE-PASTEL-SYMMETRY` + dark/gritty looks — they cancel each other
- `COMM-` styles (which want plausible reality) + `CREATIVE-` (which breaks reality)

## Subject-specific guidance

- **No character in scene** → skip `emotions`
- **No light sources in scene** → `DEPTH-BOKEH` will struggle (needs lights to bokeh)
- **Already a bright scene** → `LIGHT-NIGHT` is destructive, prefer rebuilding from scratch
- **Already a flat/wide composition** → adding `DEPTH-FG-BLUR` or `FRAME-` adds dimensionality
- **Wanting "cinematic" feel without committing to a genre** → `LENS-ANAMORPHIC` + `LIGHT-LOW-KEY` + `REALISM-DOF` is a safe trio

## Composing the final prompt

When composing, output the EXACT verbatim text from each chosen tag, separated by a space or newline. Do not rewrite, abbreviate, or "improve" the modifier text. The wording is tested.

Example skeleton (for a hero shot):
```
[ANGLE-LOW exact text]. [LIGHT-RIM exact text]. [STYLE-NEON-NOIR exact text]. [REALISM-DOF exact text]. [SUBJECT description in user's words].
```

Always end with a sentence describing the actual subject the user asked for. The modifiers shape HOW the image looks; the subject sentence defines WHAT is in it.

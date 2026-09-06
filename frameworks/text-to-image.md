---
name: text-to-image
task: text-to-image
status: active
source: intern — Tchibo prompting-agent prompt-lib (image/FRAMEWORK.md + USAGE.md)
last_verified: 2026-07-12
note: Bewährte Praxis-Konvention (aus produktivem Einsatz), kein offizieller Model-Standard. Bei Konflikt gewinnt das Model-File.
---

# Framework · Text-to-Image (5-Block)

Struktur für **Generierungs-Prompts** (Bild aus dem Nichts). Vorhandenes Bild bearbeiten
→ `image-edit.md`. Die Block-Struktur ist model-agnostisch; model-spezifische Abweichungen
stehen im `## Overrides` des Model-Files und gewinnen.

> Herkunft: erprobte Praxis aus dem Tchibo-Prompting-Agent. Gelabelte Blöcke werden von
> Bild-Modellen (Midjourney, Imagen, Flux, GPT Image, Gemini) zuverlässiger geparst als Freitext.

## Die fünf Blöcke (in dieser Reihenfolge)

1. **Subject** — was im Bild ist
2. **Composition** — wie es im Frame angeordnet ist
3. **Lighting** — wie es beleuchtet ist
4. **Camera** — Position + Objektiv
5. **Style** — Gesamt-Look

Output-Format (Labels bleiben im finalen Prompt):

    Subject: [text]
    Composition: [text]
    Lighting: [text]
    Camera: [text]
    Style: [text]

## Welche Modifier-Kategorie füllt welchen Block

Kategorien liegen in `../modifiers/image/`:

| Block | Kategorien |
|---|---|
| Subject | User-Input + `emotions` (falls Charakter) + `creative` (reality-bending) |
| Composition | `shots`, `depth`, `framing` |
| Lighting | `lighting`, `weather` |
| Camera | `angles`, `cameras`, `lenses` |
| Style | `film-stocks`, `cinematic-styles`, `commercial-styles`, `photo-effects`, `realism` |

`scene-extender` und `single-shots` gehören NICHT hierher — das sind Edit-Operationen (→ `image-edit.md`).

## Komposition

1. User-Subject in den Subject-Block.
2. Pro restlichem Block ein/mehrere Tags aus den obigen Kategorien wählen — Stacking- und
   Conflict-Regeln in `../modifiers/image/USAGE.md` beachten (Sweet Spot 4–6 Modifier; aus der
   „overall look"-Gruppe nur EINEN: `FILM-`/`STYLE-`/`COMM-`/`CAM-`/nicht-additive `EFFECT-`).
3. Den EXAKTEN Verbatim-Text jedes gewählten Tags in seinen Block schreiben, mit Leerzeichen verbunden.
4. Die fünf Blöcke mit Labels ausgeben.

## Verbatim-Regel
Modifier-Text nie umschreiben, kürzen oder „verbessern" — er ist getestet. Auch die
„Change the X to Y"-Präfixe verbatim lassen (in Generierung leicht redundant, schadet nicht).

## Brief → Blöcke
`subject`/`intent` → Subject · `composition` → Composition (shots/depth/framing) sowie Camera
(angles/cameras/lenses) · `lighting`/`mood` → Lighting · `style`/`color` → Style ·
`constraints.aspect_ratio` u. Ä. → als Parameter im output-contract, NICHT in die Blöcke.

## Beispiel (gekürzt)
User: „hero shot of a SaaS dashboard". Tags: `SHOT-MS`, `DEPTH-BOKEH`, `LIGHT-RIM`, `ANGLE-LOW`,
`LENS-PETZVAL`, `STYLE-NEON-NOIR`, `REALISM-DOF` →

    Subject: A SaaS dashboard interface on a sleek modern device, key metrics visible on screen.
    Composition: [SHOT-MS verbatim] [DEPTH-BOKEH verbatim]
    Lighting: [LIGHT-RIM verbatim]
    Camera: [ANGLE-LOW verbatim] [LENS-PETZVAL verbatim]
    Style: [STYLE-NEON-NOIR verbatim] [REALISM-DOF verbatim]

(Verbatim-Texte aus `../modifiers/image/*`.)

## Per-Model-Overrides
Die 5-Block-Struktur ist der Default. Ein Model kann eine andere Block-Struktur verlangen
(z. B. 6-Block-Portrait mit „Character Description", Film-Szene „Scene / Atmosphere / Genre /
Cinematography / Production") — solche Abweichungen stehen im `## Overrides` des Model-Files und gewinnen.

## Wann dieser Flow (Generierung) vs. image-edit
Generierung: „generate/create/make me/I want an image of", Szene von Grund auf, kein Basisbild.
Edit: Basisbild vorhanden, „change/add/remove/transform this/make it look like" → `image-edit.md`.

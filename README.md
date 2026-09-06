# burger-prompting

Ein Claude-Code-Skill, der aus einem groben Satz einen vollständigen, modellgerechten
Prompt für AI-Bild-Modelle baut — allen voran gpt-image-2. Du beschreibst, was du willst;
der Skill baut den fertigen Prompt.

## Die Idee

Ein guter Bild-Prompt ist ein **Burger aus sechs Schichten**: *Medium* (was für ein Bild,
wofür), *Subjekt* (die Hauptsache), *Aktion* (was passiert), *Umgebung* (wo), *Licht* (woher,
wie) und *Stil* (Kamera, Look). Die Reihenfolge ist egal, die Vollständigkeit nicht — Prosa
lässt gern eine Schicht liegen, die sechs Fragen erzwingen, dass keine steuerbare Ebene fehlt.
Du lieferst einen Satz, der Skill füllt die fehlenden Schichten aus einer erprobten
Technik-Bibliothek und webt alles zu **einem fließenden Prompt ohne Labels** zusammen.

## So sieht der Output aus

**Rein** (dein grober Satz):

> Produktfoto von der schwarzen Thermosflasche aus `@flasche.png`, auf einem Felsen am Bergsee.

**Raus** (fertiger gpt-image-2-Prompt — ein Absatz, keine `Medium:`/`Subjekt:`-Labels, die
Referenz als `@flasche.png`, alle sechs Schichten eingewebt):

    A vertical 4:5 product photograph for an outdoor-brand ad. The matte black insulated
    bottle from @flasche.png — its shape, proportions and printed logo reproduced exactly —
    stands upright on a wet granite rock, single water droplets running down the steel.
    Behind it a still mountain lake at sunrise, low mist drifting over the water, softly
    out of focus. Soft backlight from the right rim-lights the bottle against the dark
    water under a slightly overexposed sky. Shot on a 50mm lens at shallow depth of field,
    real brushed-metal texture and micro-reflections, a faint film grain. The printed label
    stays exactly as in @flasche.png; the rest of the surface is smooth, unmarked steel.

Was hier passiert ist: Das Subjekt steht vorn (Front-Loading), das mitgegebene Bild wird als
`@flasche.png` referenziert und auf „unverändert" festgezurrt, alle sechs Schichten sind drin,
und statt „kein Text" steht die positive Form („stays exactly as… / smooth, unmarked steel") —
gpt-image-2 kennt keinen Negative-Prompt. Aspect-Ratio, Qualität und Größe wandern als
Parameter neben den Prompt, nicht in den Text.

## Quick start

Klonen — projekt-lokal (nur in diesem Projekt verfügbar):

    git clone https://github.com/simon-schaeferai/burger-prompting .claude/skills/prompt-architect

…oder global (in jedem Projekt verfügbar):

    git clone https://github.com/simon-schaeferai/burger-prompting ~/.claude/skills/prompt-architect

Dann in Claude Code einfach sagen:

> mach mir einen gpt-image-2-Prompt für ein Produktfoto meiner Thermosflasche am Bergsee

Der Skill stellt die nötigen Rückfragen (nur zu **Fakten**, die er nicht raten darf — welches
Produkt, welches Format), schlägt das **Handwerk** vor (Licht, Shot, Look) und gibt den fertigen
Prompt aus.

## Wie es funktioniert

Vier Bausteine tragen den Skill:

- **`SKILL.md`** — der Router. Erkennt, was du willst (Einzel-Prompt, Fertig-Pack oder
  Mehr-Schritt-Workflow), lädt das passende Model-File und wählt das Framework.
- **`frameworks/burger.md`** — das Burger-Framework: die sechs Schichten, die Regel „Reihenfolge
  egal, Vollständigkeit Pflicht", und wie die Schichten mit verbatim Technik-Tags gefüllt werden.
- **`models/`** — ein File pro Bild-Modell (gpt-image, Flux, Nano Banana, Seedream, Recraft,
  Ideogram, Magnific …) mit den verifizierten Specs, Limits und Anbieter-Eigenheiten. **Bei
  Konflikt gewinnt das Model-File über das Framework.**
- **`modifiers/image/`** — die Tag-Bibliothek: getestete Technik-Bausteine (Licht, Shots, Linsen,
  Film-Looks …), die **1:1** in den Prompt übernommen werden, statt vage umschrieben.

Dazu `packs/` (erprobte Fertig-Prompts mit Slots), `workflows/` (Mehr-Schritt-/Mehr-Model-Rezepte
wie Multishot-2x2-Grid oder Character-Consistency) und `shared/` (Brief-Schema, Output-Contract, Director's Pass). Der Skill
**erfindet keine Model-Specs** — jede Spec stammt aus der offiziellen Doku des Anbieters.

## Lizenz

MIT — siehe [LICENSE](LICENSE).

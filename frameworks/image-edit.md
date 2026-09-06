---
name: image-edit
task: image-edit
status: active
source: intern — Tchibo prompting-agent prompt-lib (image/FRAMEWORK.md edit-flow + USAGE.md)
last_verified: 2026-07-12
note: Bewährte Praxis-Konvention, kein offizieller Model-Standard. Bei Konflikt gewinnt das Model-File.
---

# Framework · Image-Edit (Modifier-Flow)

Bearbeitung eines VORHANDENEN Bildes. **Keine 5-Block-Struktur** — der Prompt ist der
verbatim aneinandergehängte Modifier-Text, geordnet nach `../modifiers/image/USAGE.md`,
plus ein Subject-Satz am Ende. Keine Labels, keine Blöcke.

> Herkunft: Tchibo-Prompting-Agent (Edit-Flow). Model-Abweichungen → `## Overrides` des Model-Files.

## Auslöser (Edit statt Generierung)
- Basisbild angehängt oder referenziert
- „change", „add", „remove", „transform this", „make it look like", „reframe", „extend"

## Ablauf
1. Kategorien bestimmen, die die Änderung berührt (Routing in `../modifiers/README.md`).
2. Tags wählen, Konflikte/Stacking nach `../modifiers/image/USAGE.md` prüfen.
3. Verbatim-Texte in der empfohlenen Reihenfolge (USAGE „Recommended prompt order") aneinanderhängen.
4. Mit einem Satz enden, der das tatsächliche Subject beschreibt.

## Reframe-Gruppe (überschreibt Komposition)
`single-shots` (`SINGLE-`) und `scene-extender` (`EXTEND-`) definieren die Komposition neu →
dann KEINE `shots`/`angles`/`framing`-Tags zusätzlich. Der Reframe gewinnt.

## Verbatim-Regel & Skeleton
Modifier-Text nie umschreiben. Reihenfolge (aus USAGE):

    [reframe] [SHOT-] [ANGLE-] [FRAME-] [EMO-] [DEPTH-] [overall look] [LENS-] [LIGHT-] [WEATHER-] [CREATIVE-] [REALISM-] [additive EFFECT-]. [Subject-Satz].

## Brief → Edit
`references` = das Ausgangsbild. `subject`/`action` = die gewünschte Änderung (→ Modifier-Tags).
Erhaltenswerte Teile explizit benennen, wenn das Model das unterstützt (→ Model-`## Overrides`).

## Anti-Patterns
- Ganze Szene neu beschreiben statt nur die Änderung.
- Reframe-Tag mit shots/angles/framing mischen.
- Mehr als eine „overall look"-Wahl (siehe USAGE-Konflikte).

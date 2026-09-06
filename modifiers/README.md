# Modifier-Library

Vendored Tag-Vokabular für Bild-Prompts: pro Kategorie eine Datei mit benannten
Tags (`CATEGORY-NAME`, screaming-kebab-case) und getestetem Verbatim-Text.

> **Herkunft:** kopiert aus Simons produktivem Tchibo-Prompting-Agent (`prompt-lib`). Erprobte
> Praxis-Konvention, **kein offizieller Model-Standard**. Verbatim-Texte NIE umschreiben — sie
> sind getestet. Die Frameworks (`../frameworks/`) definieren, in welche Struktur die Tags gehen;
> die Stacking-/Conflict-Regeln stehen in den `USAGE.md` je Modalität.
> Hinweis: „FRAMEWORK.md" in den USAGE-Dateien meint jetzt die passenden `../frameworks/*`-Files.

## Zwei Flows
- **Generierung** (Bild von Grund auf) → 5-Block-Struktur bzw. Burger-Formel:
  `../frameworks/text-to-image.md` (bzw. `../frameworks/burger.md`).
- **Edit** (vorhandenes Bild) → Modifier verbatim aneinanderhängen:
  `../frameworks/image-edit.md`.

## Bild-Kategorien (`image/`) — Tag-Präfixe
`shots` SHOT- · `angles` ANGLE- · `film-stocks` FILM- · `cinematic-styles` STYLE- ·
`commercial-styles` COMM- · `photo-effects` EFFECT- · `depth` DEPTH- · `framing` FRAME- ·
`realism` REALISM- · `single-shots` SINGLE- · `scene-extender` EXTEND- · `creative` CREATIVE- ·
`emotions` EMO- · `cameras` CAM- · `lenses` LENS- · `lighting` LIGHT- · `weather` WEATHER-
Regeln: `image/USAGE.md`.

## Routing (User-Intent → Kategorie)
**Bild:** Shot-Größe→`shots` · Winkel/Perspektive→`angles` · Film-Look→`film-stocks` ·
Genre/Mood→`cinematic-styles` · Marken-/Commercial-Look→`commercial-styles` · Post-Effekt→`photo-effects` ·
Tiefe/Bokeh→`depth` · Frame-im-Frame→`framing` · Realismus→`realism` · gleicher Moment neue Position→`single-shots` ·
mehr Szene zeigen→`scene-extender` · Reality-Bending→`creative` · Emotion→`emotions` ·
Aufnahmegerät→`cameras` · Objektiv→`lenses` · Licht→`lighting` · Wetter→`weather`.

## Presets
Die Tchibo-Presets (case-/brand-spezifisch) wurden NICHT übernommen — ihre Rolle übernehmen in
prompt-architect die `## Gold-Beispiele` der Model-Files und die `workflows/`.

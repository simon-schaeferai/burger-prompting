---
name: burger
task: text-to-image
status: active
source: intern — KI-Workshop-Deck Folie 8/9 (shared/workshops/ki-workshop/workshop-struktur-final.md), Beleg-Videos KRUSE 20:47 / JEFF / LUDO 02:18
last_verified: 2026-09-03
note: Zugängliche 6-Schichten-Struktur ("Burger") für Bild-Generierung — Simons Workshop-Formel. Model-agnostische Struktur; die model-spezifische Ausprägung und die Grenzen stehen im Model-File und gewinnen (bei gpt-image-2 die Natürliche-Sprache-Präferenzen + Don'ts in models/gpt-image.md).
---

# Framework · Burger (6 Schichten)

Struktur für **Bild-Generierungs-Prompts aus dem Nichts** — Simons Workshop-Formel. Ein guter
Prompt ist ein Burger aus sechs Schichten.

> **Kernsatz: „Die Reihenfolge ist egal. Die Vollständigkeit nicht."**
> Prosa stapelt Wünsche („und mach auch noch … aber nicht …"). Die Schichten erzwingen, dass keine
> steuerbare Ebene liegen bleibt.

Wofür: der zugängliche Weg, aus einem **groben Satz** einen **vollständigen** Prompt zu bauen. Für
**gpt-image-2 die empfohlene Nutzer-Struktur**; die Model-Technik (Verneinungen positiv, Text in
Anführungszeichen, kein Keyword-Stacking, Front-Loading …) steht in `../models/gpt-image.md` und
wird zusätzlich angewandt. Bei Konflikt gewinnt das Model-File.

## Die sechs Schichten (Reihenfolge frei, alle sechs Pflicht)

| # | Schicht | Frage | Beispiel |
|---|---|---|---|
| 1 | **Medium** | Was für ein Bild soll es sein und wofür? | Produktfoto für eine Anzeige, hochkant 4:5 |
| 2 | **Subjekt** | Wer oder was ist die Hauptsache? | die schwarze Thermosflasche aus Bild 1, originalgetreu |
| 3 | **Aktion** | Was passiert gerade? | steht auf einem nassen Felsen, Wassertropfen laufen ab |
| 4 | **Umgebung** | Wo spielt die Szene? | Bergsee bei Sonnenaufgang, Nebel über dem Wasser |
| 5 | **Licht** | Woher kommt das Licht und wie ist es? | weiches Gegenlicht von rechts, leicht überbelichtet |
| 6 | **Stil** | Welche Kamera, welcher Look? | 50 mm, geringe Tiefenschärfe, echte Texturen, leichtes Korn |

## Technik-Inserts: die Schichten mit verbatim Modifier-Tags füllen (Pflicht für echte Specs)

Ohne Technik-Bausteine bleibt der Prompt vage („50 mm, schön"). Die getesteten Specs liegen als
**verbatim Tags** in `../modifiers/image/` — pro Schicht die passende Kategorie ziehen, den
**Tag-Text 1:1 übernehmen** (nie umschreiben oder „verbessern") und in den Fließtext weben. Stacking
+ Reihenfolge nach `../modifiers/image/USAGE.md`: Sweet Spot **4–6 Tags**, aus der „overall look"-
Gruppe (`FILM-`/`STYLE-`/`COMM-`/`CAM-`) nur **EINEN**, `realism` stackt fast immer.

| Burger-Schicht | Modifier-Kategorie(n) | Verifizierte Beispiel-Tags |
|---|---|---|
| Subjekt | User-Input (+ `@ref`) · `emotions` (nur bei Person) | — |
| Aktion / Umgebung | `shots` · `angles` · `depth` · `weather` | `SHOT-MS`, `ANGLE-LOW`, `DEPTH-BOKEH` |
| Licht | `lighting` | `LIGHT-RIM` |
| Stil | **EINE** aus `film-stocks`/`cinematic-styles`/`commercial-styles`/`cameras` + `lenses` + `realism` | `STYLE-NEON-NOIR`, `LENS-PETZVAL`, `REALISM-PHOTOREAL`, `REALISM-DOF` |

Die konkreten Tag-IDs + verbatim Texte stehen in den jeweiligen `modifiers/image/*.md`. **Reihenfolge
im komponierten Prompt** (USAGE.md): Shot → Angle → Depth → Overall-Look → Lens → Lighting → Weather
→ Realism; Kern-Subjekt + `@ref` nach vorn (Front-Loading).

So trägt der Prompt echte, getestete Specs (z. B. verbatim „…indistinguishable from a real
photograph, accurate physics-based lighting, proper shadows and reflections…") statt vager Prosa —
und bleibt label-freier Fließtext (wie der Edit-Flow: verbatim Tags aneinander, keine Feldnamen).

## Ausgabe: EIN sauberer, einsetzbarer Prompt — KEINE Labels

Die sechs Schichten sind das **Denk-Gerüst** (Checkliste für Vollständigkeit), sie stehen **NIE als
Labels** im Output. Der finale Prompt ist **fließende natürliche Sprache**, copy-paste-fähig, und
webt alle sechs Schichten ein. **Falsch:** „Medium: … Subjekt: …". **Richtig:** ein durchgehender
Prompt-Absatz, in dem jede Schicht steckt.

**Reihenfolge im Prompt** (gpt-image-2-Cookbook): Medium/Nutzung → Umgebung/Szene → Subjekt →
Aktion → Licht → Stil; Kern-Subjekt in die ersten ~50 Wörter (Front-Loading).

**Vollständigkeits-Check vor der Ausgabe:** ist jede der 6 Schichten im Prompt vertreten? Fehlt
eine, ist der Prompt unvollständig — nachtragen. (Der Check läuft im Kopf, nicht im Output.)

### Referenzbild = Pflicht-@-Tag
Wurde ein Bild mitgegeben (Produkt-Freisteller, Moodboard, Pose), wird es im Prompt **immer als
`@<bildname>`** benannt — z. B. „die Flasche aus `@flasche.png`, Form, Farbe und Logo unverändert".
Mehrere Referenzen: jede mit ihrem `@<name>` und ihrem Job (`@produkt.png` = Subjekt, `@moodboard.jpg`
= Look). **Ohne mitgegebene Referenz keinen @-Tag erfinden.**

## Drei Pflicht-Schichten für Produktbilder (zusätzlich, immer)

1. **Produkt als Referenz mitgeben** — den Produkt-Freisteller in JEDE Generierung. Ohne Referenz
   erfindet die KI Details am Produkt (Kruses Staubsauger bekam „einen komplett neuen Griff"). Bei
   gpt-image-2 heißt das: den **Edit-Endpoint** mit dem Produktbild nutzen, Preserve-Liste explizit
   (→ Model-File, Task `image-edit`), und das Bild im Prompt als **`@<bildname>`** referenzieren.
2. **Text bestellen oder ausschließen** — gewollten Text in „Anführungszeichen" (oder ALL CAPS),
   ungewollten mit einem Satz ausschließen. Verneinung **positiv** formulieren (gpt-image-2 kennt
   keinen Negative-Prompt): „glatte, leere Fläche" statt „kein Text".
3. **Kamera-Physik als Echtheits-Schicht** — Brennweite, Tiefenschärfe, leichte Überbelichtung.
   Macht aus einem Render ein Foto. Gehört in die **Stil**-Schicht.

## Brief → Schichten
`intent`/`use` → Medium · `subject` → Subjekt (+ Referenz-Regel) · Handlung → Aktion ·
`scene`/`background` → Umgebung · `lighting`/`mood` → Licht · `style`/`camera` → Stil.
`constraints.aspect_ratio` u. Ä. → als Parameter in den `output-contract`, NICHT in die Schichten.

## Ablauf (grober Satz rein → fertiger Prompt raus)
1. Den groben Satz des Users als Subjekt/Aktion lesen.
2. Jede der sechs Schichten gedanklich füllen; fehlt eine **Fakt-Schicht** (welches Produkt? welches
   Format?) und macht die Lücke das Ergebnis unbrauchbar → fragen. Fehlt **Handwerk** (Licht, Kamera,
   Stil) → nie fragen, nach Director's-Pass vorschlagen (`../shared/director-pass.md`).
3. **Technik-Inserts ziehen:** 4–6 verbatim Modifier-Tags nach der Tabelle oben (`../modifiers/image/`),
   Stacking + Reihenfolge nach `../modifiers/image/USAGE.md`.
4. Bei Produktbild die drei Pflicht-Schichten ergänzen (Referenz als `@<name>`, Text-Regel, Kamera-Physik).
5. Alles zu EINEM label-freien Fließtext-Prompt weben; Model-Technik aus `../models/gpt-image.md`
   drüberlegen (positive Verneinung, Front-Loading, kein Keyword-Stacking). Ausgabe nach
   `../shared/output-contract.md`.

## Verhältnis zum 5-Block-Framework
Der Burger ist die **nutzerfreundliche** Fassung (6 gesprochene Schichten, deutsch). Das
`text-to-image.md`-5-Block-Framework (Subject/Composition/Lighting/Camera/Style + Tag-Bibliothek in
`../modifiers/image/`) ist die **modifier-getriebene** Fassung für Feinsteuerung. Beide erzeugen
strukturierte, vollständige Prompts. Default für gpt-image-2 (natürliche-Sprache-first) ist der
Burger; die 5 Blöcke für tag-basiertes Feintuning.

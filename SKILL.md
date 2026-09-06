---
name: prompt-architect
description: >-
  Generiert modelspezifische, fertig formatierte Prompts für AI-Bild-Modelle (GPT Image, Nano Banana, Seedream, Flux, Recraft, Midjourney, Ideogram, Imagen, Magnific-Upscale) nach der Burger-Formel und kennt Bild-Workflows/Rezepte (z. B. Multishot 2x2 Grid, Character-Consistency). Router: identifiziert Model bzw. Rezept, liest das passende File, wählt das Framework, normalisiert die Anfrage in ein neutrales Creative-Brief und rendert einen für dieses Model korrekten Bild-Prompt. Nutze diesen Skill, wenn der User einen Bild-Prompt ERSTELLEN will: "GPT-Image-Prompt für ...", "Nano-Banana-Prompt", "Seedream-Prompt", "Bild-Prompt für ...", oder bei Enhancement/Upscaling ("Upscale mit Magnific"). ERSTELLT Prompts — anders als prompt-logger, der fertige Prompts nur in Notion ablegt.
metadata:
  version: 0.7.0
---

# prompt-architect

Ein Router mit drei Achsen — rein für **Bild-Prompting**:
- **Pack** → ein erprobter Fertig-Prompt für einen wiederkehrenden Auftrag, nur Slots füllen.
- **Einzel-Prompt** → ein Bild-Model + (optional) ein Framework.
- **Workflow/Rezept** → mehrstufig oder mehr-Model, zieht selbst Models + Frameworks.

Model-Wissen in `models/`, Struktur-Defaults in `frameworks/`, Fertig-Prompts in `packs/`,
Rezepte in `workflows/`. Diese Datei entscheidet nur, was geladen wird.

## Achse zuerst bestimmen

1. Deckt ein **Pack** den Auftrag (Pack-Roster unten)? → **Pack-Pfad**:
   `packs/<name>.md` lesen, Slots füllen, Prompt-Körper VERBATIM ausgeben. Geht vor.
2. Will der User EIN Bild aus einem Prompt? → **Einzel-Prompt-Pfad**.
3. Oder ein REZEPT / mehrere Shots / eine Model-Kette (z. B.
   "2x2 Grid", "gleiche Figur über mehrere Shots")? → **Workflow-Pfad**: passendes
   `workflows/<name>.md` lesen und dessen Schritten folgen; es verweist selbst auf Models +
   Frameworks. Ist das File `status: draft`, gilt der Fehlerpfad (sagen, nicht raten).

## Model-Roster → `INDEX.md`

**Der Router liest zuerst [`INDEX.md`](INDEX.md)** — eine generierte Tabelle mit
Situation, Verdikt, Typ, Preis und Datei je Modell, sortiert nach Verdikt. Ein Read
statt aller Model-Files. Erst danach das Model-File des Treffers öffnen.

`INDEX.md` wird nie von Hand bearbeitet (Generator im Entwicklungs-Repo: `scripts/build-index.sh`);
Modalität, Tasks, Status, Frameworks leben nur im Frontmatter. Neues Model = Datei + Index neu erzeugen.

## Pack-Roster

| Pack file | Aliase |
|---|---|
| `packs/character-sheet.md` | character sheet, charakter sheet, model sheet, turnaround, figurenblatt |
| `packs/studio-firstframe.md` | firstframe, startframe, studio firstframe, talking head still |

Neuer Pack = neue Datei in `packs/` + **eine Zeile** hier. Abgrenzung: `packs/README.md`.

## Workflow-Roster

| Workflow file | Aliase | Stand |
|---|---|---|
| `workflows/multishot-2x2-grid.md`     | 2x2 grid, multishot, grid, vierer-grid, contact sheet | draft |
| `workflows/character-consistency.md`  | charakter konsistenz, gleiche person, consistent character | draft |

Neues Rezept = neue Datei in `workflows/` + **eine Zeile** hier.

## Projekt zuerst

Der Skill kennt Modelle. Das **Projekt** kennt Marke, Palette, Formate, Assets und Verbote.
Ohne diese Schicht reimt sich der Router Kontext aus dem Dateisystem zusammen.

**Ablauf:** `../../projects/ACTIVE.md` lesen.
- Nennt sie einen Slug → `../../projects/<slug>.md` laden. **Projekt-Fakten schlagen jeden
  Vorschlag:** Palette, Format und Verbote sind gesetzt, nicht verhandelbar.
- Steht dort `keins` → **fragen, welches Projekt** — nicht raten, nicht aus Ordnernamen
  oder vorhandenen Dateien ableiten.
- **Gibt es gar keinen `../../projects/`-Ordner** (Standalone-Betrieb, z. B. nach `git clone`
  nach `~/.claude/skills/`) → genauso: einmal fragen, welche Marken-/Format-/Asset-Vorgaben
  gelten, sonst ohne Projektschicht arbeiten. Nie aus dem Dateisystem zusammenreimen.

„Neues Projekt X" → `projects/<slug>.md` aus `_TEMPLATE.md` anlegen und `ACTIVE.md` setzen; „jetzt Y" → nur `ACTIVE.md` umstellen.

**Learnings sortieren:** Was für das Modell gilt, gehört ins Model-File. Was für den Kunden
gilt, ins Projekt. Details: `../../projects/README.md`.

## Director's Pass — vor jedem Rendern

Der Skill fragt nicht, wie es aussehen soll. Er **schlägt vor**: zwei bis drei Treatments
(Shot, Komposition, Licht, Look, Modell, grobe Kosten), der User wählt. Methode: `shared/director-pass.md`.

**Kernsatz:** Erfinden ist bei **Fakten verboten** (Produkt, Marke, Maße, Referenzen) und
beim **Handwerk Pflicht** (Licht, Shot, Komposition, Grade).

**Zwei Modi, und der gewählte wird angesagt:** **Regie** (Default — Diagnose, 2–3 Treatments,
Wahl, Prompt) oder **Direkt** (Modell und Treatment stehen fest, Variante von gerade
Gebautem, oder der User will nur den Prompt — dann Diagnose und Prompt). Das Überstimmen
immer anbieten.

**Schritt 0 in beiden Modi ist die Diagnose:** benennen, was unterbestimmt ist. Fehlt ein
**Fakt** und macht die Lücke das Ergebnis unbrauchbar → fragen. Fehlt **Handwerk** → nie
fragen, vorschlagen. Annahmen stehen im Output unter „Offen geblieben".

**Gerendert wird erst nach ausdrücklichem Go** — Prompt verbatim und Referenzen gezeigt,
auch bei „nur ein Testlauf". Kein Go, kein Render.

**Modellwahl nach Situation, nicht nach Name:** Die `## Wann nutze ich es`-Sektion jedes
Model-Files trägt Simons Auslöser, `verdikt`, Schwäche und **Preis**. Das ist die
Routing-Tabelle — vor dem Frontmatter lesen.

## Ablauf · Einzel-Prompt

0. **Director's Pass** (siehe oben), sofern nicht übersprungen.
1. **Model identifizieren** → `models/<model>.md` lesen. Kein Model genannt? Siehe Fehlerpfade.
2. **Task/Operation bestimmen.** Bei einer konkreten Operation (relight, upscale, inpaint,
   outpaint, freistellen, style-transfer …) zuerst `shared/operations.md` konsultieren —
   sie mappt auf Task + Framework + Modifier. Tasks: text-to-image, image-edit, enhance,
   inpaint, outpaint. Dann im
   `## Routing` des Model-Files der Task→Framework-Zuordnung folgen. `frameworks: none`
   bzw. "inline" → kein Framework laden, der Aufbau steht im Model-File.
3. **Framework laden** (falls zugeordnet): `frameworks/<task>.md` = Default-Struktur. Die
   Bild-Frameworks verweisen auf die Tag-Bibliothek in `modifiers/image/` — Tag-Text
   VERBATIM übernehmen, Stacking/Conflict nach der jeweiligen `USAGE.md`.
4. **Anfrage normalisieren** in ein Creative-Brief nach `shared/brief-schema.md`.
5. **Prompt bauen & ausgeben**: Framework = Struktur, Model-Specs/Overrides =
   Ausprägung. **Bei Konflikt gewinnt das Model-File.** Ausgabe nach `shared/output-contract.md`.

## Ablauf · Workflow

1. **`workflows/<name>.md` lesen.**
2. Dessen `## Zutaten` nennen die nötigen Models/Frameworks → die jeweiligen Files laden.
3. Pro Schritt ein Creative-Brief normalisieren und den Prompt bauen wie im Einzel-Pfad.
4. Schritte in Reihenfolge ausgeben; Übergaben (z. B. Grundbild → Folge-Shot) explizit machen.
   Ausgabe nach `output-contract` — pro Schritt ein Block.

## Fehlerpfade

- **Unbekanntes Model/Rezept** → sagen, nicht raten; das nächstliegende aus dem Roster anbieten.
  **Task nicht in `tasks:`** → sagen, nicht generieren.
- **Kein Model genannt** → **nicht zurückfragen, sondern vorschlagen.** Über `INDEX.md` und
  die `## Wann nutze ich es`-Sektionen das passende Modell wählen und die Wahl begründen
  (Auslöser + `verdikt` + Preis). Nur wenn der Bild-Task unklar ist (Neu-Generierung,
  Edit oder Upscale?), wird gefragt — das ist ein Fakt, keine Geschmacksfrage.
- **`status: deprecated`** → warnen + Nachfolger anbieten, nur auf explizite Bestätigung generieren.
- **File ist `status: draft` / leer** → sagen, dass es noch nicht eingepflegt ist; nicht
  auf Vermutungen generieren, anbieten aus offiziellen Docs zu befüllen.

## Wartung ("check")

Bei "check": veraltete Model-Files auflisten — `scripts/check-staleness.sh` (`last_verified`
älter als 90 Tage oder fehlend); ohne Shell jedes `models/*.md` selbst prüfen. Ergebnis:
Liste + `source`-Link, nichts automatisch ändern.

## Dateien

- `shared/director-pass.md` — Regie-Schicht · `brief-schema.md` (Fakten vs. Handwerk) ·
  `output-contract.md` · `conventions.md` · `operations.md` (Operation → Task/Framework/Modifier).
- `frameworks/*.md` — Default-Struktur pro Task. Befüllt: `burger` (6-Schichten-Formel für
  Bild-Generierung, Default für gpt-image-2), `text-to-image` (5-Block, tag-basiert), `image-edit`,
  `enhance`; für Enhance/Upscale läuft der Aufbau überwiegend inline über das Model-File.
- `modifiers/image/*.md` — Tag-Bibliothek (verbatim). Index: `modifiers/README.md`.
- `models/*.md` — Ground Truth pro Model · `packs/*.md` — Fertig-Prompts mit Slots
  (`packs/README.md`) · `workflows/*.md` — Mehr-Schritt-Rezepte. Je ein `_TEMPLATE.md` daneben.

---
name: Seedream
aliases: [seedream, seedream 5, seedream 5.0, seedream pro, dola seedream, bytedance image]
vendor: ByteDance
type: image
version: Seedream 5.0 Pro (text-to-image + edit), Stand 2026-08-22
tasks: [text-to-image, image-edit]
frameworks:
  text-to-image: text-to-image
  image-edit: image-edit
status: active
last_verified: 2026-08-22
source: https://fal.ai/models/bytedance/seedream/v5/pro/text-to-image/api
source_tier: platform
prompt_guide: https://docs.byteplus.com/en/docs/ModelArk/1829186
verdikt: Daily Driver
wann_nutze_ich_es: "Wenn Text im Bild lesbar sein muss oder das Layout dicht ist, etwa Infografiken, Cheatsheets und Karussell-Seiten."
endpunkt: bytedance/seedream/v5/pro/text-to-image
preis: 0,0675 $ pro Bild
notion_rows: [https://app.notion.com/3ab79c4d6b2d810b88cac07600ffab04, https://app.notion.com/3ab79c4d6b2d8172aa5fccfc0f959811]
---

# Seedream

> **`source_tier: platform`** — die belastbaren Feldangaben stammen von **fal**, wohin auch
> Simons Notion-Endpunkte zeigen. BytePlus bestätigt „Dola Seedream 5.0 — Leading image
> generation model. Enhanced reference consistency and improved generation quality for
> professional scenarios", legt auf der erreichbaren Ebene aber keine Parameter-Referenz
> offen. Die Werte unten beschreiben damit die Wrapper-Ebene, nicht zwingend die native
> ModelArk-API. Bericht: `research/seedream-2026-08-22.md` (shipt nicht).

## Wann nutze ich es

> **Daily Driver** · ⭐⭐⭐⭐⭐ · 0,0675 $ pro Bild
>
> Wenn Text im Bild lesbar sein muss oder das Layout dicht ist, etwa Infografiken, Cheatsheets und Karussell-Seiten.

**Stärke (Notion):** Schreibt lesbaren Text in 14 Sprachen ins Bild und hält dichte, strukturierte Layouts ein. Versteht lange Prompts mit mehreren Bildbereichen.

**Schwäche (Notion):** Teurer und langsamer als die Lite-Variante. Bei reinen Fotomotiven ohne Text kein Vorteil gegenüber günstigeren Modellen.

Die Schwäche ist die Routing-Regel: **kein Text im Bild → nicht Seedream.** Dann ist
Nano Banana Pro schneller oder FLUX günstiger.

Für den Edit-Weg führt Notion eine eigene Zeile (`bytedance/seedream/v5/pro/edit`,
ebenfalls **Daily Driver**): „Wenn ein Element im Bild geändert werden soll und der Rest
des Frames **pixelgenau** bleiben muss." Das ist der schärfere Auslöser als bei
FLUX Kontext („etwas Bestimmtes ändern") — Seedream Edit ist die Wahl, wenn Pixeltreue
außerhalb der Änderung zählt.

## Routing
- **text-to-image** → Framework `text-to-image`, Endpunkt `…/v5/pro/text-to-image`.
- **image-edit** → Framework `image-edit`, Endpunkt `…/v5/pro/edit` (bis 10 Referenzbilder,
  Ebenentrennung in der Antwort).

## Model-Specs
Quelle: fal-Modellseiten, Stand 2026-08-22.

### Text-to-Image · `bytedance/seedream/v5/pro/text-to-image`
| Parameter | Default | Werte |
|---|---|---|
| `prompt` | Pflicht | — |
| `image_size` | **`auto_2K`** | `square_hd`, `square`, `portrait_4_3`, `portrait_16_9`, `landscape_4_3`, `landscape_16_9`, `auto_1K`, `auto_2K` — oder frei **1024×1024 bis 2048×2048**, Seitenverhältnis **1/16 bis 16** |
| `num_images` | 1 | getrennte Läufe |
| `output_format` | **`jpeg`** | `jpeg`, `png` |
| `sync_mode` | false | Ergebnis als Data-URI statt URL |
| `enable_safety_checker` | true | — |

Ausgabe: `images[]` mit `url`, `content_type`, `file_name`, `file_size`, `width`, `height`.
Modell-Aussage der Doku: „deep-thinking prompt understanding, **native text in 14
languages**, and precise control over dense layouts and structured designs."

### Edit · `bytedance/seedream/v5/pro/edit`
- `prompt` (Pflicht) — die Edit-Anweisung.
- `image_urls` (Pflicht) — **bis zu 10 Referenzbilder; überzählige werden verworfen**
  (nicht abgelehnt — stillschweigend ignoriert).
- `image_size`, `num_images`, `output_format`, `sync_mode`, `enable_safety_checker` wie oben.
- Wörtlich: „grounded, **region-precise** image editing" — verändert gezielte Elemente und
  lässt die Umgebung stehen.
- **Ebenentrennung in der Antwort:** Stapelreihenfolge (`z_index`), Bounding-Boxes und
  beschreibende Labels je Ebene über dem Basisbild. Das ist im Roster einmalig und macht
  Seedream Edit für Layout-Arbeit interessant, nicht nur für Retusche.

## Inputs

**Eingabe-Modalitäten**
- **Text** — der Prompt. Laut Doku für **lange** Prompts mit mehreren Bildbereichen
  ausgelegt; ein Zeichenlimit ist auf der geprüften Ebene nicht dokumentiert.
- **Bild** — nur am Edit-Endpunkt: `image_urls`, **bis zu 10**. Alles darüber wird verworfen.
- **Keine Maske**, kein Video, kein Audio.

**Steuerparameter**
| Parameter | Wert |
|---|---|
| `image_size` | acht Presets oder frei 1024²–2048², AR 1/16 bis 16 |
| `num_images` | Anzahl getrennter Läufe |
| `output_format` | `jpeg` (Default) \| `png` |
| `sync_mode` | Data-URI statt URL |
| `enable_safety_checker` | Sicherheitsfilter |

**Geht nicht** — Auflösungen über **2048 px** je Kante; mehr als 10 Referenzbilder
(werden still verworfen); Maskensteuerung; auf der geprüften Ebene **kein `seed`**, also
keine Reproduzierbarkeit; kein Negative-Prompt.

**Ausgabe** — ein oder mehrere Bilder als URL (oder Data-URI bei `sync_mode`), JPEG oder
PNG, bis 2048×2048; beim Edit zusätzlich die Ebenenbeschreibung mit `z_index`,
Bounding-Boxes und Labels.

## Overrides

**Seedream ist das Layout-Modell, nicht das Foto-Modell.** Der Prompt sollte deshalb wie
ein **Satzspiegel** aufgebaut sein, nicht wie eine Kamerabeschreibung: Was steht wo, welche
Hierarchie, welcher Text wörtlich. Die Doku nennt genau das als Stärke — „precise control
over dense layouts and structured designs".

**Text wörtlich und in Anführungszeichen**, mit Position und Hierarchie. 14 Sprachen sind
nativ unterstützt, also darf der Text auch deutsch sein — anders als bei den meisten
Modellen im Roster, wo deutscher Bildtext zerfällt.

**Bildbereiche benennen.** Weil das Modell lange Prompts mit **mehreren Bildbereichen**
versteht, lohnt es sich, den Prompt in Zonen zu gliedern (Kopfbereich, Mittelfeld,
Fußzeile) statt in einen Fließtext.

**Beim Edit die Preserve-Regel mitschreiben.** Der Auslöser aus Notion ist „der Rest des
Frames bleibt **pixelgenau**" — das erreicht man, indem man den Änderungsbereich benennt
**und** ausdrücklich sagt, dass alles andere unangetastet bleibt. Dieselbe Disziplin wie
bei GPT Image, aber hier mit region-genauer Rückmeldung über die Ebenen.

**Nicht mehr als 10 Referenzen schicken** — überzählige werden **still** verworfen, es gibt
keinen Fehler. Wer 12 schickt, wundert sich über das Ergebnis, nicht über eine Fehlermeldung.

### ⚠️ Der Guide deckt dein Modell nicht namentlich ab
Es gibt **keinen Seedream-5.0-eigenen Prompt-Guide**, nur einen kombinierten (Doc-ID
1829186) — und der trägt **je nach Sprachfassung einen anderen Titel**:

| Fassung | Titel | genannte Versionen |
|---|---|---|
| Englisch | „Seedream 4.0-**4.5** prompt guide" | nur 4.5 und 4.0 |
| Chinesisch | „Seedream 4.0-**5.0** 提示词指南" | ausdrücklich **5.0 lite**, 4.5 und 4.0 |

ByteDance verlinkt ihn aus Tutorial und API-Referenz selbst als „Seedream 4.0-5.0 prompt
guide". Formal gilt er also für **5.0 lite** — **nicht namentlich für 5.0 pro**, und pro ist
genau der Endpunkt, den Simon fährt (`bytedance/seedream/v5/pro/*`).

Für pro gibt es stattdessen **zwei eigene Dokumente** (Tutorial 2582774, Interactive Editing
2582775) mit exklusiver Syntax — siehe unten.

**Wer nur die englische Fassung liest, hält den Guide für veraltet.** Er ist es nicht; der
Titel ist nur nicht nachgezogen.

### Die fünf Regeln des Guides
1. **Ganzer Satz statt Keyword-Kette.** Muster `subject + action + environment`, optional
   Stil, Farbe, Licht, Komposition. Ausdrücklich zu vermeiden ist die Form
   `Girl, umbrella, tree-lined street, oil painting texture.`
2. **Zu renderndem Text doppelte Anführungszeichen geben:**
   `Generate a poster with the title "Seedream 4.5".`
3. **Edits knapp und ohne vage Pronomen.** Was bleiben soll, ausdrücklich sagen —
   `keeping its pose unchanged`.
4. **Referenzbilder zweiteilig prompten:** erst *Reference Target* (was übernommen wird),
   dann *Generated Scene Description* (was neu entsteht). Bilder als `Image 1 / 2 / 3`
   ansprechen — die fal-Beispiele nutzen abweichend `Figure 1 / 2 / 3`.
5. **Länge maximal 600 englische Wörter** (bzw. 300 chinesische Zeichen). „Ornate
   vocabulary" zu stapeln ist **ab 4.0 kontraproduktiv**.

**Serien** triggert man sprachlich: `a series`, `a set` oder eine Anzahl, dazu
`sequential_image_generation: auto` — **das kann 5.0 pro allerdings nicht**.

### Nur 5.0 pro: Koordinaten im Prompt
Pro versteht **normalisierte Koordinaten von 0 bis 999** direkt im Prompt-Text:

    <point>x y</point>
    <bbox>x1 y1 x2 y2</bbox>

Dazu die Ebenen-Zerlegung: lässt man den Prompt weg, zerlegt pro automatisch. Das ist die
Mechanik hinter der Ebenen-Antwort (`z_index`, Bounding-Boxes, Labels) aus den Model-Specs.

### Prompt-Umschreibung: immer an, kein Ausschalter
`optimize_prompt_options.mode`, Default **`standard`**. Der Wert `fast` gilt nur für 5.0 pro
und 4.0 — 5.0 lite und 4.5 können ausschließlich `standard`.
**Es gibt keinen `off`-Wert** und **kein Response-Feld mit dem umgeschriebenen Prompt**.
Auf fal ist der Parameter gar nicht erst durchgereicht.

Bei Seedream lässt sich die Prompt-Umschreibung damit **nicht abschalten**. Wer exakte
Reproduzierbarkeit braucht, ist hier falsch.

<!-- unverified: Für 5.0 pro existiert kein namentlich zuständiger Prompt-Guide. Die
     Regeln oben stammen aus dem kombinierten Guide (gültig bis 5.0 lite) plus den beiden
     pro-eigenen Dokumenten. Ob alle fünf Regeln unverändert für pro gelten, ist nicht
     belegt. Ausserdem: kein eigener ByteDance-Prompt-Skill für Seedream. -->


## Gold-Beispiele
<!-- Doc-informiert. Durch erprobte Prompts ersetzen. -->

### 1 · Karussell-Seite mit dichtem Layout
Brief: „Instagram-Karussell, Seite 2, drei Punkte mit Überschrift."

    A clean editorial carousel slide on a deep violet background (#592B8A). Top third: the headline "Drei Fehler beim Prompten" in bold white sans-serif, left-aligned, generous margin. Middle: three numbered rows, each with a small yellow circular badge (#FFEE1D) containing the numeral, followed by a short line of white text — row one reads "Zu viele Adjektive", row two reads "Kein Startbild", row three reads "Falsches Modell". Bottom edge: a thin yellow rule and the small label "1/5" right-aligned. Flat design, no photography, generous whitespace, precise alignment.

Parameter: `image_size portrait_4_3`, `output_format png`, `num_images 1`.

### 2 · Region-genauer Edit mit Preserve-Regel
Brief: „Auf dem fertigen Visual nur die Jahreszahl ändern."

    Change only the year in the bottom-right corner from "2025" to "2026". Keep the typeface, size, colour, position and letter spacing identical. Every other element of the frame — background, product, headline, badges, margins — stays pixel-identical. Do not re-render or restyle anything else.

Request: `image_urls: [<das fertige Visual>]`, `image_size auto_2K`, `output_format png`.

## Don'ts
- **Kein Text im Bild → nicht Seedream.** Bei reinen Fotomotiven kein Vorteil gegenüber
  günstigeren Modellen (Notions eigene Schwäche-Angabe).
- **Nicht mehr als 10 Referenzbilder** — überzählige werden **still** verworfen.
- **Keine Auflösung über 2048 px** je Kante erwarten.
- **Nicht auf Reproduzierbarkeit bauen** — auf der geprüften Ebene gibt es kein `seed`.
- **Beim Edit die Preserve-Klausel nicht weglassen** — sonst rendert das Modell mehr neu
  als gewollt.
- **Prompt nicht als Fließtext** schreiben, wenn es um Layout geht — Zonen benennen.
- **Die fal-Felder nicht für die native ModelArk-API halten** — es ist die Wrapper-Ebene.

## Learnings
- 2026-08-22 · **Die ByteDance-Sprachfassungs-Falle.** Derselbe
  Guide (Doc-ID 1829186) heißt auf Englisch „Seedream 4.0-**4.5**", auf Chinesisch
  „Seedream 4.0-**5.0**" und nennt dort ausdrücklich 5.0 lite. Wer nur Englisch liest, hält
  ihn für überholt. **Lehre: bei ByteDance beide Sprachfassungen prüfen.**
- 2026-08-22 · **Für 5.0 pro — Simons Endpunkt — gilt der Guide nicht namentlich.** Pro hat
  zwei eigene Dokumente mit exklusiver Syntax (Koordinaten im Prompt, Ebenen-Zerlegung).
- 2026-08-22 · **Prompt-Umschreibung ohne Ausschalter.** Kein `off`, kein Response-Feld mit
  dem umgeschriebenen Prompt, auf fal nicht einmal durchgereicht.
- 2026-08-22 · **Maximal 600 englische Wörter**, und „ornate vocabulary" ist ab 4.0
  kontraproduktiv — das widerlegt die verbreitete Annahme, Seedream vertrage lange
  Prompt-Stapel, weil es lange Prompts *versteht*.
- 2026-08-22 · **`sequential_image_generation` kann 5.0 pro nicht** — Serien laufen dort nur
  sprachlich über `a series` / `a set`.
- 2026-08-22 · Erstanlage, ausgelöst durch den Notion-Abgleich: **Seedream 5 Pro ist in
  beiden Rollen (t2i und edit) Simons Daily Driver und hatte kein Model-File.** Zusammen
  mit Nano Banana Pro waren damit vier von sechs Bild-Daily-Drivern im Skill nicht abgebildet.
- 2026-08-22 · **Ebenentrennung in der Edit-Antwort** (`z_index`, Bounding-Boxes, Labels)
  ist im Roster einmalig — macht Seedream Edit zum Layout-Werkzeug, nicht nur zur Retusche.
- 2026-08-22 · **Überzählige Referenzbilder werden still verworfen**, nicht abgelehnt.
  Stiller Fehler statt lauter — gehört in jede Checkliste.
- 2026-08-22 · **Deutscher Bildtext ist hier realistisch** (14 Sprachen nativ) — bei den
  meisten anderen Modellen im Roster nicht.

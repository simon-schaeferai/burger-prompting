---
name: Ideogram
aliases: [ideogram, ideogram 3, ideogram 4, ideogram 4.0, magic fill, ideogram api]
vendor: Ideogram
type: image
version: Ideogram 4.0 (Generate/Remix/Describe) · 3.0 (Inpaint/Reframe/Replace Background), Stand 2026-08-22
tasks: [text-to-image, image-edit, inpaint, outpaint, enhance]
frameworks:
  text-to-image: text-to-image
  image-edit: image-edit
status: active
last_verified: 2026-08-22
source: https://developer.ideogram.ai/api-reference/api-reference/generate-v4
source_tier: official
prompt_guide: https://docs.ideogram.ai/using-ideogram/getting-started/prompting-guide/1-what-is-prompting
verdikt: Zweitwahl
wann_nutze_ich_es: "Wenn ein Plakat- oder Logo-Layout mit viel Typografie gebraucht wird und Seedream nicht verfügbar ist."
endpunkt: —
preis: —
notion_rows: [https://app.notion.com/3ab79c4d6b2d8110b772ebcc164cfe2f]
---

# Ideogram

> Verifiziert gegen die offizielle Ideogram-Developer-Doku (API-Overview + Generate-v4),
> Stand 2026-08-22. Bericht: `research/ideogram-2026-08-22.md` (shipt nicht).
>
> Die Doku bietet `/llms.txt` und `.md`-Varianten je Seite — für die nächste
> Re-Verifikation der schnellere Weg.

## Wann nutze ich es

> **Zweitwahl** · ⭐⭐⭐⭐ · —
>
> Wenn ein Plakat- oder Logo-Layout mit viel Typografie gebraucht wird und Seedream nicht verfügbar ist.

**Stärke (Notion):** Historisch das stärkste Modell für Text im Bild, gute Logo- und Poster-Layouts.

**Schwäche (Notion):** Seit Seedream 5 und GPT Image 2 kein Alleinstellungsmerkmal mehr, Fotorealismus schwächer.

Ideogram ist bei Simon zur **Ausweichoption hinter Seedream** geworden. ⚠️ Notion bewertet **3.0**; aktuell ist **4.0** mit einem formalen JSON-Prompt-Contract — der Grund, überhaupt noch hier zu landen, ist strukturiertes Layout-Prompting.

## Routing
- **text-to-image** → Framework `text-to-image`, Ideogram 4.0 Generate. **Aber:** Ideogram
  hat einen eigenen JSON-Prompt-Contract, der das Framework schlägt (siehe Overrides).
- **image-edit** → Framework `image-edit` (`Edit images with a prompt`, `Remix`,
  `Remove Object`, `Remove Background`, `Replace Background`).
- **inpaint** → **inline**: `Inpaint with Ideogram 3.0` — läuft weiterhin auf **3.0**.
- **outpaint** → **inline**: `Reframe with Ideogram 3.0` — ebenfalls **3.0**.
- **enhance** → **inline**: `Upscale`.

## Model-Specs
Quelle: developer.ideogram.ai, Stand 2026-08-22.

### Endpunkte
| Generation | Endpunkte |
|---|---|
| **Ideogram 4.0** | Generate (sync + async) · Generate mit **transparentem Hintergrund** (sync + async) · Remix · Magic Prompt generieren · Describe · Advertisement Resizer · P-Image |
| **Ideogram 3.0** | Generate · Generate transparent · **Inpaint** · Remix · **Reframe** · **Replace Background** |
| versionslos | Remove Background · Remove Object · **Layerize Text** · Edit images with a prompt · **Upscale** · Describe |

**Wichtig fürs Routing:** Maskenbasiertes Inpainting, Reframe (Outpainting) und
Replace Background hängen **an 3.0**, nicht an 4.0. Wer eine Maske braucht, arbeitet mit
der älteren Generation.

### `POST /v1/ideogram-v4/generate`
- **Synchron** — keine Task-Queue, das Ergebnis kommt direkt zurück.
- Auth: Header **`Api-Key`**. Body: `multipart/form-data`.
- **Ergebnis-URLs sind ephemer:** „if you would like to keep the image, you must download
  it." Downloads einplanen.
- Response je Bild: `prompt`, `resolution` (`WIDTHxHEIGHT`), `is_image_safe`, `seed`, `url`.

### `rendering_speed`
`FLASH` | `TURBO` | `DEFAULT` (Default) | `QUALITY`.
**`FLASH` ist bei V4 noch nicht verfügbar** und liefert aktuell einen 400er.

## Inputs

**Eingabe-Modalitäten**
- **Text** — `text_prompt` (natürliche Sprache). **Aktiviert automatisch Magic Prompt.**
- **Strukturiertes JSON** — `json_prompt` nach dem 4.0-Contract. **Deaktiviert Magic
  Prompt**; der strukturierte Prompt geht direkt ins Diffusionsmodell.
  **`text_prompt` und `json_prompt` schließen einander aus.**
- **Bild** — bei den Edit-, Remix-, Inpaint-, Reframe-, Upscale- und Describe-Endpunkten;
  Inpaint zusätzlich mit **Maske** (Endpunkt läuft auf 3.0).

**Der JSON-Prompt-Contract (4.0)**
| Feld | Pflicht | Inhalt |
|---|---|---|
| `high_level_description` | ja | ein bis zwei Sätze Gesamtbeschreibung |
| `compositional_deconstruction.background` | ja | Beschreibung des Hintergrunds |
| `compositional_deconstruction.elements` | ja | **geordnete** Liste der Elemente (Objekte **und Text**) |
| `style_description.aesthetics` | nein | Stimmung, Vibe, Referenzen |
| `style_description.art_style` | nein | z. B. illustration, oil painting |
| `style_description.lighting` | nein | Lichtbeschreibung |
| `style_description.medium` | nein | z. B. photograph, digital art |
| `style_description.photo` | nein | Objektiv, Filmmaterial |
| `style_description.color_palette` | nein | Liste von Hex-Werten — **„soft color bias, not an exact per-pixel lock"** |

**Auflösungen** (38 Enum-Werte). 2K: 2048×2048, 1440×2880, 2880×1440, 1664×2496, 2496×1664,
1792×2240, 2240×1792, 1440×2560, 2560×1440, 1600×2560, 2560×1600, 1728×2304, 2304×1728,
1296×3168, 3168×1296, 1152×2944, 2944×1152, 1248×3328, 3328×1248, 1280×3072, 3072×1280,
1024×3072, 3072×1024. 1K: 1024×1024, 896×1120, 1120×896, 864×1152, 1152×864, 832×1248,
1248×832, 800×1280, 1280×800, 720×1280, 1280×720, 720×1440, 1440×720.

**Steuerparameter**
| Parameter | Wert |
|---|---|
| `text_prompt` **oder** `json_prompt` | exklusiv zueinander |
| `resolution` | einer der 38 Enum-Werte |
| `rendering_speed` | `TURBO` \| `DEFAULT` \| `QUALITY` (`FLASH` → 400) |
| `enable_copyright_detection` | bool — Hive-Likeness- und Logo-Prüfung nach der Generierung |

**Geht nicht** — `text_prompt` und `json_prompt` gleichzeitig; `rendering_speed: FLASH` bei
V4; freie Pixelmaße außerhalb der 38 Enum-Werte; maskenbasiertes Inpainting mit 4.0
(nur 3.0); exakte Farbtreue über `color_palette` (ausdrücklich nur weicher Bias).

**Ausgabe** — ein oder mehrere Bilder als **ephemere URLs**, 1K oder 2K, optional mit
transparentem Hintergrund (eigener Endpunkt), je mit `seed` und `is_image_safe`.

<!-- unverified: Prompt-Längenlimit, num_images, Style-Codes, Referenzbild-Parameter und
     die Dateigrößen-Limits der Edit-/Inpaint-Endpunkte wurden nicht ermittelt — sie liegen
     in den einzelnen 3.0- und Edit-Endpunkt-Seiten, die in diesem Lauf nicht geöffnet
     wurden. Nicht geraten. -->

## Overrides

**Der JSON-Prompt ist der eigentliche Hebel.** Ideogram 4.0 nimmt entweder freien Text oder
ein Struktur-Objekt — und die Wahl entscheidet über mehr als das Format:
- `text_prompt` → **Magic Prompt an**. Ideogram schreibt den Prompt um, bevor generiert wird.
- `json_prompt` → **Magic Prompt aus**. Was im JSON steht, geht direkt ins Modell.

Für Markenarbeit, Wiederholbarkeit und A/B-Tests deshalb **immer `json_prompt`**. Das ist
dieselbe Falle wie `disable_pup` bei FLUX — hier aber wird sie
über die Prompt-Form gelöst, nicht über einen Schalter.

**Die 5-Block-Framework-Struktur bildet sich sauber auf den Contract ab:**
Subject und Composition → `compositional_deconstruction` (Hintergrund plus **geordnete**
Elementliste), Lighting → `style_description.lighting`, Camera → `style_description.photo`,
Style → `art_style` / `medium` / `aesthetics`. Der Framework-Text wird also nicht verworfen,
sondern in die Felder einsortiert.

**Text im Bild gehört in `elements`.** Ideograms Stärke ist Typografie; die Doku behandelt
Text ausdrücklich als Element der Komposition („objects and text"), nicht als Stilfrage.
Zur Reihenfolge der Liste siehe Overrides — sie ist weniger festgelegt, als es aussieht.

**Markenfarben mit Vorsicht.** `color_palette` nimmt Hex-Werte, wirkt aber als weicher Bias.
Wer exakte Farbwerte braucht, ist bei FLUX.2 (Hex im Prompt) oder GPT Image besser bedient.

### Die Schlüsselreihenfolge im JSON ist vorgeschrieben
Das ist die präziseste Regel im ganzen Roster, und sie steht wörtlich da:
**`Key order matters. The model was trained on captions with a consistent key order.`**

Pflichtreihenfolge je Element:
`type, bbox, desc, color_palette` — bei Textelementen `type, bbox, text, desc, color_palette`.
Und: **`background` muss vor `elements` stehen.**

**`bbox`** sind vier Integer von 0 bis 1000 in der Form **`[y_min, x_min, y_max, x_max]`** —
**Zeile zuerst**, Ursprung oben links. Optional, aber der einzige Weg zu exaktem Layout.

⚠️ **Was NICHT dokumentiert ist:** wofür die Reihenfolge der `elements`-**Liste** steht.
Das OpenAPI-Schema nennt sie zweimal `ordered`, definiert aber nie, ob damit Z-Ordnung oder
Wichtigkeit gemeint ist. Das einzige Muster stammt aus dem Poster-Beispiel: Hauptobjekt
zuerst, dann Textelemente von oben nach unten. **Konvention, keine Spezifikation.**

### Typografie: Text und Beschreibung strikt trennen
- **`text`** enthält **nur die literalen Zeichen** — auch die Groß- und Kleinschreibung
  gehört dorthin, nicht in `desc`
- **`desc`** beschreibt Stil, Rolle und Platzierung
- **Ein Element pro Textblock**, jedes mit eigener `bbox`
- **Schriftnamen sind nicht möglich** — nur Stileigenschaften beschreiben
  (`bold sans-serif`, `thin rounded bauhaus style`)
- Größenhierarchie über Wörter: `huge`, `big`, `smaller`

Im Freitext: Text **in Anführungszeichen und früh im Prompt**, lange Texte in Chunks mit
Platzierungsangabe, Szenenkomplexität senken.

⚠️ **Für deutsche Texte relevant:** Die Doku nennt **akzentuierte lateinische Zeichen
ausdrücklich als problematisch** und Englisch als am zuverlässigsten. Umlaute in
Bildtext sind damit ein bekanntes Risiko, kein Zufall.

### Magic Prompt: der Zwei-Schritt macht ihn nutzbar
Magic Prompt ist eine LLM-Vorstufe. Bei 4.0 wörtlich: **`expands your plain text into a full
JSON caption`**. Kurze Prompts wachsen stark, lange kaum.

**Das saubere Muster:** `POST /v1/ideogram-v4/magic-prompt` gibt das fertige `json_prompt`
**zurück** — das lässt sich prüfen, anpassen und dann an `/generate` schicken. So bekommt
man die Anreicherung, ohne die Kontrolle zu verlieren.

**Aber:** Magic Prompt setzt **weder `bbox` noch `color_palette`**. Layoutpräzision bleibt
Handarbeit. Und Ideograms eigenes Troubleshooting nennt Magic Prompt **zweimal** als Ursache
für ungewollte Bildelemente — `Turn Magic Prompt off`.


## Gold-Beispiele
<!-- Doc-informiert. Durch erprobte Prompts ersetzen. -->

### 1 · JSON-Prompt für ein Plakat mit Typografie
Brief: „Plakat für ein Jazzfestival, Titel ‚BLUE NOTE NIGHTS', warmes Retro."

    {
      "high_level_description": "A retro-styled jazz festival poster with a warm amber palette and bold typography.",
      "compositional_deconstruction": {
        "background": "A deep midnight blue gradient with subtle paper grain and a soft amber glow rising from the lower edge.",
        "elements": [
          "A silhouetted double bass player centred in the lower third, lit from behind",
          "The headline text 'BLUE NOTE NIGHTS' in bold condensed serif capitals across the upper third",
          "A thin amber rule beneath the headline",
          "The line 'FRI 12 SEP - CITY HALL' in small letter-spaced capitals at the bottom edge"
        ]
      },
      "style_description": {
        "art_style": "mid-century concert poster illustration",
        "medium": "screen print",
        "lighting": "warm rim light from behind the subject",
        "aesthetics": "nostalgic, confident, high contrast",
        "color_palette": ["#0B1B3A", "#E8A33D", "#F2ECE1"]
      }
    }

Parameter: `resolution 1440x2560`, `rendering_speed QUALITY`.

### 2 · Freitext, wenn Magic Prompt erwünscht ist
Brief: „Schnelle Ideenfindung, Café-Illustration."

    A warm illustrated scene of a corner café on a rainy afternoon, people reading at the window, muted retro palette.

Parameter: `text_prompt`, `resolution 1024x1024`, `rendering_speed TURBO`.
(Magic Prompt läuft hier bewusst mit — für Exploration, nicht für Finals.)

## Don'ts
- **Nicht `text_prompt` und `json_prompt` zusammen senden** — sie schließen einander aus.
- **Für Finals kein `text_prompt`** — Magic Prompt schreibt um; für Reproduzierbarkeit
  `json_prompt` nutzen.
- **`rendering_speed: FLASH` nicht an V4 schicken** — liefert 400.
- **Keine Maske an 4.0** — Inpaint, Reframe und Replace Background laufen auf **3.0**.
- **Keine freien Pixelmaße** — nur die 38 dokumentierten Auflösungen.
- **`color_palette` nicht als exakte Farbsteuerung verkaufen** — es ist ein weicher Bias.
- **Ergebnis-URLs nicht verlinken, sondern herunterladen** — sie sind ephemer.
- **Elementliste nicht als ungeordnete Aufzählung** behandeln — die Reihenfolge zählt.

## Learnings
- 2026-08-22 · **Die Schlüsselreihenfolge im JSON ist Spezifikation, nicht Stil:**
  `The model was trained on captions with a consistent key order.` `background` vor
  `elements`, und je Element `type, bbox, [text,] desc, color_palette`.
- 2026-08-22 · **Korrektur an meinem File:** Ich hatte geschrieben, die Reihenfolge der
  `elements`-Liste sei bedeutsam. Das ist **nicht dokumentiert** — das Schema nennt sie
  `ordered`, sagt aber nie wofür. Belegt ist nur eine Konvention aus einem Beispiel.
- 2026-08-22 · **`bbox` ist zeilenzuerst:** `[y_min, x_min, y_max, x_max]`, 0–1000, Ursprung
  oben links. Wer x/y vertauscht, kippt das Layout.
- 2026-08-22 · **Akzentuierte lateinische Zeichen sind laut Doku problematisch** — deutsche
  Umlaute in Bildtext sind ein benanntes Risiko. Zweiter Fall nach Recraft.
- 2026-08-22 · **Magic Prompt lässt sich als Zwei-Schritt zähmen:** eigener Endpunkt gibt das
  `json_prompt` zurück, das man prüfen und dann generieren lässt. Er setzt aber weder `bbox`
  noch `color_palette` — Layout bleibt Handarbeit.
- 2026-08-22 · Erstverifikation gegen developer.ideogram.ai. **Ideogram 4.0 hat einen
  formalen JSON-Prompt-Contract** — im Roster einzigartig: strukturiertes Prompten ist hier
  nicht Konvention, sondern API.
- 2026-08-22 · **`text_prompt` schaltet Magic Prompt AN, `json_prompt` schaltet es AUS.**
  Die Prompt-Form ist zugleich der Schalter für die automatische Umschreibung.
- 2026-08-22 · **Inpaint/Reframe/Replace Background sind noch 3.0-Endpunkte.** Die Landkarte
  07-26 führt „4.0 (+ Magic Fill ★ inpaint)" — die Inpaint-Stärke liegt aber an der
  Vorgängergeneration, nicht an 4.0.
- 2026-08-22 · Ideogram ist **synchron** — kein Polling, kein Task-Handling. Im Roster die
  Ausnahme unter den Bild-APIs.
- 2026-08-22 · Die Doku bietet `/llms.txt` und `.md` je Seite (wie BFL) — nächste
  Re-Verifikation darüber, nicht per Rendering.

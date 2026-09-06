---
name: FLUX
aliases: [flux, flux.1, flux.2, flux 2, flux 3, flux3, kontext, flux kontext, flux fill, black forest, bfl]
vendor: Black Forest Labs
type: image
version: FLUX.2 (Bild, [klein]/[pro]/[flex]/[max]), Stand 2026-08-22
tasks: [text-to-image, image-edit, enhance, inpaint, outpaint]
frameworks:
  text-to-image: text-to-image
  image-edit: image-edit
status: active
last_verified: 2026-08-22
source: https://docs.bfl.ml/llms.txt
source_tier: official
prompt_guide: https://docs.bfl.ml/guides/prompting_summary
verdikt: Daily Driver
wann_nutze_ich_es: "Wenn an einem vorhandenen Bild etwas Bestimmtes geändert werden soll, etwa ein Objekt tauschen oder Text ersetzen."
endpunkt: fal-ai/flux-pro/kontext
preis: —
notion_rows: [https://app.notion.com/3ab79c4d6b2d816cb69fd90e70dbbbb1, https://app.notion.com/3ab79c4d6b2d8141b442d37acec9baeb, https://app.notion.com/3ab79c4d6b2d81c3b2abfe811cfeab4f, https://app.notion.com/3ab79c4d6b2d81e38f15cb2f40e8f9cb]
---

# FLUX

> Verifiziert gegen die vollständige BFL-Doku (Markdown-Quellen über `llms.txt`, inklusive
> der OpenAPI-Schemata für `/v1/flux-2-pro`), Stand 2026-08-22.
> Bericht: `research/flux-2026-08-22.md` (shipt nicht).
>
> **FLUX.2** ist die Bild-Familie (bis 4 MP, Multi-Referenz) in den Varianten
> [klein]/[pro]/[flex]/[max]/[dev].

## Wann nutze ich es

> **Daily Driver** · ⭐⭐⭐⭐⭐ · —
>
> Wenn an einem vorhandenen Bild etwas Bestimmtes geändert werden soll, etwa ein Objekt tauschen oder Text ersetzen.

**Stärke (Notion):** Nimmt Text und Referenzbild zusammen und macht gezielte lokale Änderungen, ohne den Rest anzufassen.

**Schwäche (Notion):** Bei sehr großen Umbauten der Szene bricht die Konsistenz.

Notion führt vier FLUX-Zeilen mit unterschiedlichen Auslösern:

| Zeile | Verdikt | Auslöser |
|---|---|---|
| **Kontext [pro]** | Daily Driver | gezielte lokale Änderung an einem vorhandenen Bild |
| FLUX1.1 [pro] | Zweitwahl | Bildmotiv ohne Text, wenn Ultra zu teuer ist |
| FLUX.1 [dev] | Spezialfall | eigener wiederholbarer Stil per LoRA |
| FLUX.1 [schnell] | Spezialfall | hunderte Vorschaubilder, Qualität zweitrangig |

⚠️ **Widerspruch:** Simons Daily Driver ist **Kontext**, die BFL-Doku sagt dazu wörtlich „For new projects, we recommend FLUX.2". Nicht aufgelöst — Kontext bleibt das erprobte Werkzeug, FLUX.2 die dokumentierte Empfehlung.

## Routing
- **text-to-image** → Framework `text-to-image`, Modell FLUX.2 (`flux-2-pro` als Default).
- **image-edit** → Framework `image-edit`, FLUX.2 mit `input_image` … `input_image_8`.
- **inpaint** → **inline**: FLUX Erase (maskengetrieben) bzw. FLUX.1 Fill [pro].
- **outpaint** → **inline**: FLUX Outpainting (Canvas + Offset).
- **enhance** → **inline**: FLUX Deblur (Schärfen/Restore, braucht keinen Prompt).

## Model-Specs
Quelle: docs.bfl.ml, Stand 2026-08-22.

### FLUX.2 (Bild)
| | [klein] | [max] | [pro] | [flex] | [dev] |
|---|---|---|---|---|---|
| Wofür | Realtime, hohes Volumen | höchste Qualität | Produktion at scale | Qualität mit Kontrolle | lokal |
| Multi-Referenz | bis **4** | bis **8** (API) | bis **8** (API) | bis **8** (API) | empfohlen max 6 |
| Steuerung | Standard | Standard | Standard | Steps & Guidance einstellbar | voll |
| Grounding-Suche | nein | **ja** | nein | nein | nein |

Ausgabe bis **4 MP**. Endpunkte: `flux-2-pro` und `flux-2-klein-9b` sind **gepinnte
Snapshots**, `flux-2-pro-preview` und `flux-2-klein-9b-preview` tragen die neuesten
Gewichte. Gleicher API-Contract, nur andere Gewichte — für reproduzierbare Workflows die
Nicht-Preview-Variante nehmen. `[klein]` gibt es als 4B (Apache 2.0) und 9B
(FLUX Non-Commercial License).

### FLUX Tools (eigene Endpunkte)
- **Outpainting** — Bild wird mit Offset auf eine `(width, height)`-Leinwand gelegt, der Rand
  generiert.
- **Erase** — maskengetrieben, läuft auf FLUX.2 [klein] 9B.
- **Deblur** — **braucht keinen Prompt**.
- **Virtual Try-On** — Personenbild + eine oder mehrere Kleidungsreferenzen.
- **FLUX.1 Kontext / Fill [pro]** — Bestandsmodelle. Die Doku sagt für neue Projekte
  ausdrücklich: FLUX.2 nehmen.

## Inputs

**Eingabe-Modalitäten**
- **Text** — Prompt. **FLUX.2 verarbeitet bis 32K Token** (das großzügigste Limit im
  Roster). Empfehlung der Doku trotzdem: kurz anfangen.
- **Bild (FLUX.2)** — `input_image` bis `input_image_8`. **Die Grenze ist ein Pixelbudget,
  keine feste Zahl:** 9 MP insgesamt für Ein- und Ausgabe zusammen — bei 1 MP Ausgabe bis
  **8** Referenzen, bei 2 MP nur noch **7**. `[klein]` maximal 4. Pfad oder URL.
- **Maske** — nur bei FLUX Erase und FLUX.1 Fill.

**Steuerparameter Bild (`Flux2Inputs`)**
| Parameter | Wert |
|---|---|
| `prompt` | Pflicht |
| `disable_pup` | bool, Default `false` — **Prompt-Upsampling ist bei [pro] und [max] standardmäßig AN** |
| `input_image` … `input_image_8` | Referenzbilder |
| `seed` | Integer |
| `width` / `height` | ≥ 64, Default `0` = automatisch |
| `safety_tolerance` | 0–5, Default **2** (0 strengst, 5 lockerst) |
| `output_format` | Default **jpeg** |
| `webhook_url` / `webhook_secret` | asynchrone Zustellung |

**Geht nicht** — **kein Negative-Prompt** („Most FLUX models do not support negative
prompts"); das 9-MP-Budget für Ein- und Ausgabe zusammen überschreiten; `[klein]` kann keine
Grounding-Suche.

**Ausgabe** — Bild bis **4 MP**, Default **jpeg**. Antworten sind asynchron
(`id` + `polling_url`), optional per Webhook.

## Overrides
FLUX hat einen umfangreichen offiziellen Prompt-Guide. Drei Punkte überschreiben die
Framework-Defaults:

**Kurz anfangen, nicht lang.** Wörtlich: „Start short. Add only what changes the image.
More words do not automatically mean better results." Die Doku staffelt: 10–30 Wörter für
schnelle Konzepte, 30–80 für den Normalfall, 80–300+ nur für komplexe Mehr-Subjekt-Szenen.
Das 32K-Token-Limit ist Kopffreiheit, keine Einladung.

**Reihenfolge:** klares Subjekt → Aktion/Zustand → Stimmung, Kontext und visuelle Richtung
**nur wenn sie das Bild verbessern**. Komponenten: Image type, Subject, Location, Style.
Die Doku nennt das ausdrücklich „a prompt-building aid, not a rule".

**Prompt-Upsampling ist die stillste Falle.** `[pro]`, `[max]` und `[flex]` reichern kurze
Prompts automatisch an. Für exakte Kontrolle, Reproduzierbarkeit und A/B-Tests gehört
`disable_pup: true` in den Request. Auf `[klein]` gilt das Gegenteil — wörtlich: „what you
write is what you get — be descriptive."

**Dokumentierte Spezialtechniken** (eigene Guides, jeweils offiziell):
- **Hex-Farbcodes direkt im Prompt** für exakte Markenfarben
  (`the color of the vase is a gradient starting with #02eb3c`).
- **JSON Structured Prompting** für komplexe Szenen mit vielen Constraints.
- Multi-Language-Prompting (in der Zielsprache prompten wirkt kulturell authentischer),
  Typografie, Infografiken, UI-Mockups.

**Verneinung positiv umformulieren** — wie bei GPT Image, aus demselben Grund: Negation
lenkt die Aufmerksamkeit auf das Unerwünschte.

### Hex-Farben: Signalwort + Code, fest an ein Objekt gebunden
`in color #0047AB` · `in hex #C4725A` · Farbname plus `(#6A0DAD)` · oder eine blanke
Palette `#00FF2F #0D00FF #FF0000`.
Verläufe: `starting with color #X and finishing with color #Y`; radial `from ... at the
center fading outward to ... at the edges`; Drei-Zonen mit Ortsangaben.
**Warnung wörtlich:** `Vague references like 'use #FF0000 somewhere' may produce
inconsistent results`. Der Hex-Wert muss an einem benannten Objekt hängen.

### Kamerasprache
Die Doku führt viele Begriffe für Shot sizes, Angles, Composition, Focus, Lenses und
Lighting, jeder mit Wirkungsbeschreibung und Beispiel-Phrase.
**Kombinationsregel:** ein Framing-Begriff + eine klare Bildaussage. Mehr macht den Shot
unleserlich.


## Gold-Beispiele
<!-- Doc-informiert. Durch erprobte Prompts ersetzen. -->

### 1 · text-to-image mit Hex-Markenfarbe (FLUX.2)
Brief: „Produktshot einer Trinkflasche in exakt unserem Markengrün."

    Product photograph of a matte aluminium water bottle standing on a pale concrete surface. The bottle body is the exact colour #0F5F4A, the cap is brushed steel. Soft top light with a single soft shadow to the right, seamless light grey backdrop, shallow depth of field.

Parameter: `flux-2-pro`, `disable_pup: true`, `width 1536`, `height 2048`,
`output_format png`.

## Don'ts
- **Kein Negative-Prompt** — FLUX unterstützt ihn überwiegend nicht; positiv formulieren.
- **`disable_pup` nicht vergessen**, wenn der Prompt exakt so gelten soll — sonst rendert
  [pro]/[max]/[flex] eine angereicherte Fassung.
- **Auf `[klein]` nicht kurz prompten** — dort gibt es kein Upsampling, was fehlt, fehlt.
- **Preview-Endpunkte nicht für reproduzierbare Workflows** — dafür die gepinnten
  `flux-2-pro` / `flux-2-klein-9b`.
- **Nicht mehr als 8 Referenzbilder** über die API erwarten (Playground kann 10, das ist
  kein API-Versprechen).
- **Deblur keinen Prompt mitgeben** — das Modell braucht keinen.
- **FLUX.1 Kontext nicht für Neues wählen** — die Doku empfiehlt selbst FLUX.2.
- **Das 32K-Token-Limit nicht ausreizen** — die Doku rät ausdrücklich zum kurzen Einstieg.

## Learnings
- 2026-08-22 · **Faktenkorrektur:** Das Referenzbild-Limit ist **kein fester Wert**, sondern
  ein Pixelbudget — 9 MP für Ein- und Ausgabe zusammen. Bei 1 MP Ausgabe passen 8
  Referenzen, bei 2 MP nur 7. Ich hatte `bis zu 8` als feste Zahl im File.
- 2026-08-22 · **Hex braucht ein Objekt.** `use #FF0000 somewhere` ist laut Doku
  unzuverlässig; der Wert muss an einem benannten Ding hängen.
- 2026-08-22 · Erstverifikation gegen docs.bfl.ml. Ein Anbieter deckt Bild, Inpaint,
  Outpaint, Deblur und Try-On ab.
- 2026-08-22 · **BFL liefert die ganze Doku als Markdown** (`llms.txt` + `.md`-URLs, inkl.
  OpenAPI). Für künftige Re-Verifikationen die schnellste Quelle im Roster — kein Rendering,
  kein Raten.
- 2026-08-22 · **Prompt-Upsampling ist bei [pro]/[max]/[flex] standardmäßig an.** Stille
  Falle: der gerenderte Prompt ist nicht der geschriebene — `disable_pup: true` für exakte
  Kontrolle.
- 2026-08-22 · **32K Token Prompt-Limit** — das großzügigste im Roster, aber die Doku rät
  selbst zu 10–80 Wörtern. Limit und Empfehlung sind hier bewusst weit auseinander.

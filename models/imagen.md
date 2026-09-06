---
name: Imagen
aliases: [imagen, imagen 4, google imagen, imagen-4.0]
vendor: Google
type: image
version: imagen-4.0-generate-001 / -ultra- / -fast- — **abgeschaltet seit 2026-08-17**
tasks: [text-to-image]
frameworks:
  text-to-image: text-to-image
status: deprecated
last_verified: 2026-08-22
source: https://ai.google.dev/gemini-api/docs/imagen
source_tier: official
verdikt: Zweitwahl
wann_nutze_ich_es: "Wenn ein fotorealistisches Produkt- oder Personenbild ohne Stilexperiment gebraucht wird."
endpunkt: —
preis: —
notion_rows: [https://app.notion.com/3ab79c4d6b2d818eb8d4f5dd0f1333fa]
---

# Imagen

> ⚠️ **ABGESCHALTET.** Wörtlich aus Googles Doku: „Imagen models are deprecated and will
> shut down on **August 17, 2026**. We recommend migrating to **Nano Banana** for your image
> generation needs." Die Modellseite nennt als Migrationsziel **Gemini 3.1 Flash Image**.
>
> Das Datum ist **verstrichen** (Prüfung am 2026-08-22). Betroffen sind
> `imagen-4.0-generate-001`, `imagen-4.0-ultra-generate-001` und
> `imagen-4.0-fast-generate-001`.
>
> **Routing-Regel:** Keinen Imagen-Prompt mehr bauen. Stattdessen auf die Gemini-nativen
> Bildmodelle (Nano-Banana-Familie) verweisen — dafür gibt es im Skill **noch kein File**
> (bisher nur `vault/wiki/tools/nano-banana.md`, unbestätigt). Alternativen mit
> verifizierten Specs: `models/gpt-image.md`, `models/flux.md`, `models/ideogram.md`,
> `models/recraft.md`.
>
> Bericht: `research/imagen-2026-08-22.md` (shipt nicht).

## Wann nutze ich es

> **Zweitwahl** · ⭐⭐⭐⭐ · —
>
> Wenn ein fotorealistisches Produkt- oder Personenbild ohne Stilexperiment gebraucht wird.

**Stärke (Notion):** Sehr saubere Fotorealistik, besonders bei Menschen und Produktaufnahmen.

**Schwäche (Notion):** Strenge Inhaltsfilter blocken auch harmlose Prompts, wenig Stilkontrolle.

⚠️ **Das Urteil ist hinfällig:** Notion führt Imagen 4 Ultra als `Aktuell`. Die Endpunkte sind seit dem **17.08.2026 abgeschaltet**. Für Simons Auslöser (fotorealistisches Produkt- oder Personenbild ohne Stilexperiment) ist in Notion bereits **Nano Banana Pro** als Daily Driver eingetragen.

## Routing
- **text-to-image** → Framework `text-to-image` — **nur noch historisch**. Vor jeder
  Nutzung auf die Abschaltung hinweisen und ein aktives Modell anbieten.

## Model-Specs
Quelle: Gemini-API-Doku, Stand 2026-08-22. Alle Angaben beschreiben den Stand **vor** der
Abschaltung und sind nur noch für Bestandscode und Migrationen relevant.

| Model-ID | Variante |
|---|---|
| `imagen-4.0-generate-001` | Standard |
| `imagen-4.0-ultra-generate-001` | Ultra |
| `imagen-4.0-fast-generate-001` | Fast |

- Aufruf über `generate_images`; die Antwort war eine eigene Bild-Response.
- Ausgabe: 1 bis 4 Bilder pro Request, **alle mit SynthID-Wasserzeichen**.
- `imageSize` `1K` oder `2K` — **nur Standard und Ultra**, nicht Fast.

### Migration ist kein Umbenennen
Die Gemini-nativen Bildmodelle laufen über **`generate_content`** und liefern Content-Parts,
die Bilddaten enthalten können — nicht die dedizierte Bild-Response von Imagen. Wer migriert,
ändert Request-Pfad, Response-Parsing, Tests und Fehlerbehandlung, nicht nur den Modellnamen.

## Inputs

**Eingabe-Modalitäten**
- **Text** — der Prompt, **maximal 480 Token**. Das war eines der knappsten Prompt-Budgets
  im Roster (GPT Image: 32.000 Zeichen, FLUX.2: 32K Token).
- **Kein Bild-Input, keine Maske, kein Referenzbild** — Imagen war ein reines
  Text-zu-Bild-Modell ohne Edit-Pfad.

**Steuerparameter**
| Parameter | Werte | Default |
|---|---|---|
| `numberOfImages` | 1–4 | **4** |
| `imageSize` | `1K` \| `2K` (nur Standard/Ultra) | `1K` |
| `aspectRatio` | `1:1`, `3:4`, `4:3`, `9:16`, `16:9` | `1:1` |
| `personGeneration` | `dont_allow` \| `allow_adult` \| `allow_all` | `allow_adult` |

**Geht nicht** — **die API ist abgeschaltet**; darüber hinaus gab es kein `negativePrompt`
und kein `sampleImageSize` (beides kursiert, ist aber nicht dokumentiert), keinen
Bild-Input, kein Inpainting, keine Auflösung über 2K, keine anderen Seitenverhältnisse als
die fünf genannten.

**Ausgabe** — 1 bis 4 Bilder, 1K oder 2K, in einem der fünf Seitenverhältnisse, immer mit
SynthID-Wasserzeichen.

## Overrides
Keine modell-spezifischen Abweichungen mehr zu pflegen — das Modell ist abgeschaltet. Die
einzige praktisch relevante Besonderheit war das **480-Token-Prompt-Limit**: Prompts mussten
deutlich verdichtet werden, während `numberOfImages` standardmäßig auf 4 stand und damit
jeder Aufruf vierfach abrechnete, wenn man es nicht änderte.

## Gold-Beispiele
<!-- Historisch, nur zur Orientierung bei Bestandscode. Keine neuen Prompts hierauf bauen. -->

### 1 · Kompakter Prompt am 480-Token-Limit
Brief: „Produktfoto einer Keramikvase, Studiolicht."

    A matte stoneware vase on a pale linen surface, soft top light with a single gentle shadow, seamless light grey backdrop, shallow depth of field, natural clay texture.

Parameter: `aspectRatio "4:3"`, `imageSize "2K"`, `numberOfImages 1`,
`personGeneration "dont_allow"`.

## Don'ts
- **Nicht mehr verwenden** — die Endpunkte sind seit dem 17.08.2026 abgeschaltet.
- **Nicht davon ausgehen, dass ein Modellname-Tausch reicht** — Nano Banana läuft über
  `generate_content` statt `generate_images`.
- **`negativePrompt` nicht erwarten** — war nie dokumentiert.
- **`numberOfImages` nicht auf dem Default lassen**, wenn nur ein Bild gebraucht wird —
  der Default war 4.
- **Kein Bild-Input, kein Inpainting** — Imagen konnte nur Text-zu-Bild.
- **SynthID nicht wegdenken** — jede Ausgabe trug das Wasserzeichen.

## Learnings
- 2026-08-22 · **Abschaltung bestätigt und bereits erfolgt** (17.08.2026). Der Roadmap-Punkt
  4 aus `project_spec.md` ist damit erledigt: `status: deprecated` statt `draft`.
- 2026-08-22 · **Nachfolger ist die Nano-Banana-Familie** (Google nennt Gemini 3.1 Flash
  Image als Migrationsziel). Dafür existiert im Skill **noch kein Model-File** — nur eine
  unbestätigte Vault-Seite. Klarer Roster-Kandidat.
- 2026-08-22 · Google hat Imagen zugunsten der **Gemini-nativen Bild-Modelle**
  (Nano-Banana-Familie) abgeschaltet.

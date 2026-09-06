---
name: Recraft
aliases: [recraft, recraft v3, recraft v4, recraft 4.1, recraftv4, vektor, svg generieren]
vendor: Recraft
type: image
version: recraftv4_1 (Default) — V4.1/V4/V3/V2 je raster und vector, Stand 2026-08-22
tasks: [text-to-image, image-edit, inpaint, outpaint, enhance]
frameworks:
  text-to-image: text-to-image
  image-edit: image-edit
status: active
last_verified: 2026-08-22
source: https://www.recraft.ai/docs/api-reference/endpoints.md
source_tier: official
prompt_guide: https://www.recraft.ai/docs/prompt-engineering-guide/introduction
verdikt: Spezialfall
wann_nutze_ich_es: "Wenn ein Icon, Logo oder eine Illustration als skalierbare Vektordatei gebraucht wird."
endpunkt: fal-ai/recraft/v3/text-to-image
preis: —
notion_rows: [https://app.notion.com/3ab79c4d6b2d811598d3e74b06b0b2cd]
---

# Recraft

> Verifiziert gegen die offizielle Recraft-Doku (Endpoints, Appendix, Prompt-Engineering-
> Guide), Stand 2026-08-22. Bericht: `research/recraft-2026-08-22.md` (shipt nicht).
>
> Recrafts Alleinstellungsmerkmal im Roster: **echte Vektor-Ausgabe**. Jedes Modell auf
> `_vector` erzeugt Vektorgrafik, nicht ein Rasterbild im Vektor-Look.

## Wann nutze ich es

> **Spezialfall** · ⭐⭐⭐ · —
>
> Wenn ein Icon, Logo oder eine Illustration als skalierbare Vektordatei gebraucht wird.

**Stärke (Notion):** Erzeugt echte Vektorgrafik (SVG) statt Pixel, dazu Marken-Stil-Sets.

**Schwäche (Notion):** Fotorealismus deutlich schwächer als Flux oder Seedream.

Der Auslöser ist eng und eindeutig: **echte Vektordatei**. Für alles andere ist Recraft laut Notion schwächer. ⚠️ Notion bewertet **V3**, aktuell ist **V4.1** — und mehrere Steuerfelder (`style`, `negative_prompt`, `text_layout`) gelten weiterhin **nur für V2/V3**.

## Routing
- **text-to-image** → Framework `text-to-image`; das Universal-Template der Doku deckt sich
  weitgehend mit dem 5-Block (siehe Overrides).
- **image-edit** → Framework `image-edit` (`imageToImage`, `variateImage`,
  `replaceBackground`, `generateBackground`, `removeBackground`, `eraseRegion`).
- **inpaint** → **inline**: `images/inpaint` (Maske).
- **outpaint** → **inline**: `images/outpaint`.
- **enhance** → **inline**: `images/crispUpscale` (treu) oder `images/creativeUpscale`
  (anreichernd).
- **Vektorisieren** eines vorhandenen Bildes → `images/vectorize`.

## Model-Specs
Quelle: recraft.ai/docs, Stand 2026-08-22.

### Modelle (`model`, Default `recraftv4_1`)
`recraftv4_1` · `recraftv4_1_vector` · `recraftv4_1_pro` · `recraftv4_1_pro_vector` ·
`recraftv4_1_utility` · `recraftv4_1_utility_vector` · `recraftv4_1_utility_pro` ·
`recraftv4_1_utility_pro_vector` · `recraftv4` · `recraftv4_vector` · `recraftv4_pro` ·
`recraftv4_pro_vector` · `recraftv3` · `recraftv3_vector` · `recraftv2` · `recraftv2_vector`

**Namensschema:** Endung `_vector` = Vektorausgabe, sonst Raster. `_pro` = höhere Qualität.

### Endpunkte (`https://external.api.recraft.ai/v1/`)
`images/generations` — plus die erzwingenden Varianten `…/generations/raster` und
`…/generations/vector`, die einen falschen Modell- oder Style-Typ **ablehnen**. Für
Agenten und Pipelines, die nur ein Ausgabeformat produzieren dürfen, ist das der sichere Weg.

Weiter: `styles` · `imageToImage` · `inpaint` · `outpaint` · `replaceBackground` ·
`generateBackground` · `vectorize` · `removeBackground` · `crispUpscale` ·
`creativeUpscale` · `eraseRegion` · `variateImage` · `explore` · `explore/similar` ·
`prompts/enhance`.

Auth `Authorization: Bearer RECRAFT_API_TOKEN`. Die API ist **OpenAI-kompatibel**
(`base_url='https://external.api.recraft.ai/v1'`); Recraft-eigene Felder gehen dort über
`extra_body`.

### Die Versionsgrenze ist die wichtigste Spec
Mehrere Steuerfelder gelten **nur für die älteren Generationen**:
| Feld | Gilt für |
|---|---|
| `style`, `style_id` | **nur V2/V3** |
| `negative_prompt` | **nur V2/V3** |
| `text_layout` | **nur V3** |
| `controls.artistic_level`, `controls.no_text` | **nur V3** |
| `controls.colors`, `controls.background_color` | alle, bei V4 „partially supported" |

Wer auf `recraftv4_1` (Default) generiert und einen `style` oder `negative_prompt`
mitschickt, bekommt nicht das erwartete Verhalten.

## Inputs

**Eingabe-Modalitäten**
- **Text** — `prompt` (Pflicht). **Längenlimit: 10.000 Zeichen** bei allen V4.1- und
  V4-Varianten, **1.000 Zeichen** bei V3 und V2.
- **Bild** — bei allen Edit-, Upscale-, Vektorisier- und Hintergrund-Endpunkten.
- **Maske** — bei `inpaint` und `eraseRegion`.
- **Bildersatz für einen eigenen Style** — `POST /v1/styles` nimmt mehrere Bilder
  (`files` / `image_urls`) und liefert eine `style_id` (nutzbar mit V2/V3).

**Zwei austauschbare Eingabeformate:** `multipart/form-data` (Felder `image`, `mask`,
`file`, `files`) **oder** `application/json` mit `image_url`, `mask_url`, `image_urls` —
öffentliche URL oder Data-URL. Alle übrigen Parameter sind identisch.

**Steuerparameter**
| Parameter | Wert |
|---|---|
| `n` | 1–6 |
| `model` | siehe Liste, Default `recraftv4_1` |
| `size` | `WxH` oder `w:h`; ohne Angabe wählt das Modell anhand des Prompts |
| `random_seed` | Integer |
| `response_format` | `url` (Default) \| `b64_json` |
| `style` / `style_id` | nur V2/V3 |
| `negative_prompt` | nur V2/V3 |
| `text_layout` | nur V3 |
| `controls` | `colors`, `background_color` (alle) · `artistic_level` 0–5, `no_text` (nur V3) |

**Größen (V4.1 / V4)** — u. a. `1:1` 1024×1024 · `2:1` 1536×768 · `1:2` 768×1536 ·
`3:2` 1280×832 · `2:3` 832×1280 · `4:3` 1216×896 · `3:4` 896×1216 · `5:4` 1152×896.

**Geht nicht** — **kein Negative-Prompt auf V4/V4.1**; keine `style`/`style_id` auf V4/V4.1;
kein `text_layout` und kein `artistic_level` außerhalb V3; mehr als 6 Bilder pro Request;
Vektor-Modelle am `/raster`-Endpunkt (und umgekehrt) werden abgelehnt.

**Ausgabe** — Rasterbild oder **echte Vektorgrafik** (Modelle auf `_vector`), als URL oder
Base64.

## Overrides
Quelle: Recrafts Prompt-Engineering-Guide (19 Seiten, gelesen 2026-08-22).
Bericht: `research/recraft-promptguide-2026-08-22.md`.

**Die Reihenfolge ist vorgeschrieben, nicht empfohlen.**

    Pflicht:   Subject → Composition → Context
    Optional:  Medium → Style → Vibe → Attributes
    Zum Schluss: Visual Format + Level of Detail

Wörtlich: **„Start your prompt with the subject."** Das ist keine Stilfrage — Recraft
gewichtet nach Position: **„Elements placed earlier in the prompt receive higher priority."**

**Context ist das einzige Feld mit einer Dosierungsregel** (wörtlich): „Too little context
leads to unpredictable results, while too much can restrict the outcome." Zu wenig macht
das Ergebnis beliebig, zu viel schnürt es ein.

**Level of Detail ist ein Kontrollregler, kein Qualitätsregler** (wörtlich): „Expand it when
you need specific results, and reduce it when you want variation." Mehr Detail heißt nicht
besseres Bild, sondern engeres Bild.

### Vektor — die sechs Pflichtfelder
Der Grund steht wörtlich im Guide: „Because it does not rely on texture or lighting for
realism, prompts should highlight structure and simplified visual form" — und daraus folgt
die härteste Regel: **„Avoid texture or material-focused language."** Kein „gebürstetes
Metall", kein „weiches Licht". Stattdessen sechs Felder:

| Feld | Inhalt |
|---|---|
| Graphic type | Icon, Logo, Illustration, Pattern |
| Shape logic | aus welchen Grundformen es aufgebaut ist |
| Color system | **strikte Palettendefinition**, nicht „bunt" |
| Line discipline | gleichbleibende Strichstärke, keine Textur |
| Layout structure | Anordnung, Raster, Ränder |
| **Constraints** | was ausgeschlossen ist |

Kurzrezepte des Guides: Vektor = `Silhouette → shape clarity → system consistency`,
Branding = `Geometry → hierarchy → spacing → scalability → constraints`.

**Logos:** „distill identity into simple, recognizable shapes that work at any scale",
getragen von „minimal detail, clear geometry, and a restrained palette". Drei Register:
modern minimal, vintage badge, line icon.

**Icon-Serien:** Anzahl **wörtlich** nennen („exactly 4", „12 … four per row"), jedes Element
einzeln aufzählen, Konsistenz ausdrücklich fordern („identical tiny dot eyes, same size and
placement"). Recraft rät nicht, es zählt nach.

**Text landet in der SVG** (wörtlich): „For vector images, any text included will be
preserved in the exported SVG file." Was im Prompt steht, ist danach editierbarer Text —
Vorteil und Falle zugleich.

### Ausschlüsse auf V4: in den positiven Prompt, negiert
Auf `recraftv4_1` gibt es **kein** `negative_prompt` (nur V2/V3). Der Guide erwähnt das Feld
nirgends — die Ablösung steht in den Beispielprompts: Ausschlüsse kommen als eigener
**Constraints-Slot ans Ende des positiven Prompts**, und zwar negiert formuliert:

    Flat colors only — no gradients, shadows, or texture. No text. No clutter.

**Die Falle, die zwei Regeln verwechselt:** Recrafts Seite `negative-prompts.md` sagt
„write `apples`, not `no apples`". Das gilt **ausschließlich für das separate Feld** der
V2/V3-Modelle. Im **positiven** V4-Prompt ist „no gradients" genau richtig — Recraft macht
es in den eigenen Beispielen durchgängig so vor. Beide Regeln stimmen, an verschiedenen
Orten. Wer sie verwechselt, verliert die Wirkung oder kehrt sie um.

`no_text` (V3-Feld) wird auf V4 durch den Satz **„No text."** ersetzt.

<!-- unverified: Der dokumentierte Zeichensatz gilt ausdrücklich nur für V3 und enthält
     **kein Ä/Ö/Ü** (nur ß/ẞ). Für V4/V4.1 gibt es gar keine Liste. Deutsche Umlaute in
     Logo- und Poster-Text sind damit ungeprüft — vor dem Verlassen darauf empirisch testen. -->


## Gold-Beispiele
<!-- Doc-informiert, nach dem Universal-Template. Durch erprobte Prompts ersetzen. -->

### 1 · Vektor-Icon-Set (echte SVG-Ausgabe)
Brief: „Icon für eine Lieferdienst-App, flach, zwei Farben."

    A delivery scooter with a parcel box seen from the side, centred with generous margins, isolated on a plain background, flat vector illustration, geometric icon style, friendly and confident, two-colour palette of deep teal and warm sand, clean even line weights, no gradients, no text

Request: `POST /v1/images/generations/vector`, `model recraftv4_1_vector`, `size 1:1`,
`controls.colors` mit den beiden Markenfarben.

### 2 · Kurzer Prompt im Interpretive Mode
Brief: „Schnelle Moodbilder für ein Fashion-Shooting."

    Fashion couple portrait, close up.

Request: `model recraftv4_1`, `n 6`, `size 2:3`. (Bewusst kurz — Recraft ergänzt Kadrierung,
Licht und Styling nach eigener Designlogik.)

## Don'ts
- **Kein `negative_prompt` an V4/V4.1** — das Feld gilt nur für V2/V3 und wird sonst wirkungslos.
- **Kein `style` / `style_id` an V4/V4.1** — dieselbe Versionsgrenze.
- **`text_layout` und `artistic_level` nicht außerhalb V3** verwenden.
- **Nicht mehr als 6 Bilder** pro Request.
- **Kein Vektormodell am `/raster`-Endpunkt** (und umgekehrt) — wird abgelehnt.
- **Für Logos kein Rastermodell** mit „vector style" im Prompt — dann kommt ein Bild, keine
  Vektordatei.
- **Prompt-Limit nicht verwechseln** — 10.000 Zeichen bei V4/V4.1, aber nur **1.000** bei
  V3/V2.
- **`size` nicht raten** — ohne Angabe wählt das Modell selbst; freie Maße außerhalb der
  Appendix-Tabelle gibt es nicht.

## Learnings
- 2026-08-22 · **Eigene Regel widerlegt.** Ich hatte hier stehen: „Verneinung positiv
  formulieren, sobald V4 im Spiel ist." Falsch. Auf V4 gehört der Ausschluss **negiert in
  den positiven Prompt** („no gradients, shadows, or texture") — so macht Recraft es in
  allen eigenen Beispielen. Die „positiv formulieren"-Regel gilt nur für das separate
  `negative_prompt`-Feld der V2/V3-Modelle. Zwei Regeln, zwei Orte, leicht zu verwechseln.
- 2026-08-22 · **Position ist Gewichtung:** „Elements placed earlier in the prompt receive
  higher priority." Damit ist die vorgeschriebene Reihenfolge (Subject zuerst) keine
  Konvention, sondern Steuerung.
- 2026-08-22 · **Bei Vektor Materialsprache verboten** — „Avoid texture or material-focused
  language." Das ist der Gegenpol zu allen Foto-Modellen im Roster, wo genau diese Sprache
  die Qualität trägt.
- 2026-08-22 · **Umlaut-Lücke:** Der dokumentierte Zeichensatz gilt nur für V3 und führt
  **kein Ä/Ö/Ü**. Für deutsche Logo- und Postertexte auf V4 gibt es keine Zusage — das ist
  für Simons Arbeit direkt relevant und gehört getestet.
- 2026-08-22 · Erstverifikation gegen recraft.ai/docs. Aktueller Default ist **V4.1**;
  die Landkarte 07-26 nannte „V4.1 (Vektor/SVG)" — passt.
- 2026-08-22 · **Die Versionsgrenze ist die eigentliche Falle:** `style`, `style_id`,
  `negative_prompt`, `text_layout`, `artistic_level` und `no_text` gelten **nur für V2/V3**.
  Auf dem Default-Modell V4.1 verpuffen sie.
- 2026-08-22 · **Recraft ist OpenAI-API-kompatibel** — mit `base_url` umgestellt läuft es
  über die OpenAI-Library, Zusatzfelder über `extra_body`. Praktisch für bestehenden Code.
- 2026-08-22 · Die Endpunkte `/generations/raster` und `/generations/vector` **erzwingen**
  den Ausgabetyp. Für Automatisierung sicherer als sich auf den Modellnamen zu verlassen.
- 2026-08-22 · Recraft hält **kurze Prompts ausdrücklich für einen gültigen Modus**
  („Interpretive Mode") — im Gegensatz zu Modellen, wo Kürze schlicht Kontrollverlust ist.

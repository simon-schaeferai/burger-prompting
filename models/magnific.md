---
name: Magnific
aliases: [magnific, upscale, upscaling, enhance, hochskalieren, freepik api, mystic]
vendor: Magnific (vormals Freepik)
type: image
version: Upscaler Creative + Upscaler Precision (Magnific-eigene Modelle), Stand 2026-08-22
tasks: [enhance]
frameworks: none
status: active
last_verified: 2026-08-22
source: https://docs.magnific.com/api-reference/image-upscaler-creative/post-image-upscaler
source_tier: official
prompt_guide: keine
verdikt: Ungetestet
wann_nutze_ich_es: "Wenn ein fertiges Bild größer werden soll — treu (Precision) oder mit hinzuerfundenem Detail (Creative)."
endpunkt: POST /v1/ai/image-upscaler (Creative) · /v1/ai/image-upscaler-precision-v2
preis: 0,10–0,40 € pro Bild (Doku-Beispiele, nach Ausgabefläche)
notion_rows: []
---

# Magnific

> Verifiziert gegen die offizielle Magnific-Doku (llms.txt-Index, Upscaler Creative inkl.
> OpenAPI-Schema, Upscaler Precision), Stand 2026-08-22.
> Bericht: `research/magnific-2026-08-22.md` (shipt nicht).
>
> **Magnific ist eine Plattform.** Unter demselben Zugang laufen auch andere Bild-Modelle
> (u. a. Flux, Seedream, Z-Image). Dieses File beschreibt die
> **Magnific-eigenen Upscaler**; fremde Modelle gehören in ihre eigenen Files.
>
> **`wann_nutze_ich_es` ist NICHT wörtlich aus Notion** — KI-MODELLE führt für Magnific keine
> Zeile (nur den Crystal Upscaler als Nachbarn). Auslöser aus der Doku formuliert, beim
> nächsten Notion-Abgleich ersetzen. `verdikt: Ungetestet`, weil noch kein Upscale hier abgenommen wurde.

## Wann nutze ich es

Wenn ein fertiges Bild größer werden soll: **Precision** für Text, Logos, UI und Produkttreue
(erfindet nichts hinzu), **Creative** nur, wenn Detail hinzukommen soll. Gegen den Crystal
Upscaler (Notion: Zweitwahl, „ohne dass sich Details verändern") ist Magnific Precision die
Alternative mit URL-Input und Skalierung bis 16x.

## Routing
- **enhance** → **inline** (`frameworks: none`). Magnific ist reglergetrieben, nicht
  blockstrukturiert — es gibt keinen 5-Block-Prompt, sondern acht Parameter und einen
  optionalen Steuer-Prompt.
- **Erste Entscheidung immer:** Creative oder Precision (siehe Overrides). Das ist die
  eigentliche Routing-Frage bei diesem Modell.

## Model-Specs
Quelle: docs.magnific.com, Stand 2026-08-22. Auth: Header **`x-magnific-api-key`**.
Asynchron mit `task_id` und optionalem `webhook_url`; zusätzlich gibt es einen
**MCP-Server** (OAuth, ohne API-Key).

### Zwei Upscaler, zwei Philosophien
| | Creative | Precision |
|---|---|---|
| Endpoint | `POST /v1/ai/image-upscaler` | `POST /v1/ai/image-upscaler-precision` |
| Prinzip | „adds or infers new detail guided by your prompt" | „preserving the original content, texture, and structure … **without inventing new elements**" |
| Wofür (Doku) | Stilisierte, wirkungsstarke Upscales | **Logos, UI, Text, Produktfotos**, E-Commerce, Branding |
| Prompt | ja, steuernd | nicht vorgesehen |

### Preise (Doku-Beispiele, nach Ausgabefläche)
640×480 → 2x = 0,10 € · 4x = 0,20 € | 1280×720 → 2x = 0,10 € · 4x = 0,40 €.

## Inputs

**Eingabe-Modalitäten**
- **Bild** — `image` als Base64 **oder** (empfohlen) als URL. Harte Grenze:
  **„The resulted image can't exceed maximum allowed size of 25.3 million pixels."**
  Das ist eine Grenze für das **Ergebnis** — bei 16x also ein sehr kleines Original.
- **Text** — `prompt`, optional, nur bei Creative. Doku-Hinweis: „Reusing the same prompt
  for AI-generated images will improve the results" — also denselben Prompt wie bei der
  Generierung wiederverwenden.

**Steuerparameter (Creative)**
| Parameter | Werte | Default |
|---|---|---|
| `scale_factor` | `2x` \| `4x` \| `8x` \| `16x` | `2x` |
| `optimized_for` | `standard` · `soft_portraits` · `hard_portraits` · `art_n_illustration` · `videogame_assets` · `nature_n_landscapes` · `films_n_photography` · `3d_renders` · `science_fiction_n_horror` | `standard` |
| `creativity` | Integer **−10 … +10** | `0` |
| `hdr` | Integer **−10 … +10** | `0` |
| `resemblance` | Integer **−10 … +10** — Ähnlichkeit zum Original | `0` |
| `fractality` | Integer **−10 … +10** — Prompt-Stärke und Detaildichte pro Pixelfläche | `0` |
| `engine` | `automatic` \| `magnific_illusio` \| `magnific_sharpy` \| `magnific_sparkle` | — |
| `filter_nsfw` | bool | `false` |
| `webhook_url` | URL | — |

**Geht nicht** — Ergebnisse über **25,3 Megapixel**; Regler außerhalb −10…+10;
prompt-gesteuerte Stilisierung im Precision-Modus; ein Upscale, der Text oder Logos treu
lässt, im Creative-Modus (dafür ist Precision da).

**Ausgabe** — hochskaliertes Bild über den asynchronen Task (`task_id`, `status`,
`generated[]`).

<!-- unverified: die vollständige Parameterliste des Precision-Endpunkts wurde nicht
     ermittelt (das zugehörige OpenAPI-Markdown war nicht abrufbar). Nicht geraten. -->

## Overrides

**Es gibt keinen Prompt-Aufbau zu lernen — es gibt eine Regler-Entscheidung.**
Der `text-to-image`-Denkrahmen führt hier in die Irre. Die vier Regler bedeuten:

⚠️ **Die Regler sind faktisch undokumentiert.** Je ein Halbsatz im OpenAPI-Schema, sonst
nichts: `fractality` und `resemblance` haben im gesamten Prosa-Volldump der Doku (855 KB)
**null Treffer**. Keine Kombinationsempfehlung, keine Presets, keine Warnung.

**Was belegt ist:**
- Magnifics eigenes All-Parameter-Beispiel steht **nahe der Mitte**:
  `creativity 2` · `hdr 1` · `resemblance 0` · `fractality −1`
- Die einzige Dosierungsregel der ganzen Doku lautet für den Bild-Upscaler:
  **`Start with low values and increase gradually`**
- `fractality` ist laut Schema die `strength of the prompt` — also der Prompt-Einfluss,
  nicht nur Detaildichte

<!-- unverified: Die folgende Deutung der vier Regler ist ABGELEITET, nicht dokumentiert.
     Magnific beschreibt weder Wirkrichtung noch Wechselwirkung. Vor dem Verlassen darauf
     empirisch testen — je ein Regler pro Durchlauf. -->

| Regler (abgeleitet) | Nach oben | Nach unten |
|---|---|---|
| `creativity` | erfindet mehr hinzu | hält sich zurück |
| `resemblance` | näher am Original | freier vom Original |
| `fractality` | Prompt wirkt stärker, mehr Detail pro Fläche | ruhiger |
| `hdr` | mehr Mikrokontrast | flacher |

**Magnific selbst löst Treue nicht über die Regler, sondern über die Endpunkt-Wahl** —
Precision statt Creative. Das ist die dokumentierte Strategie.

**Die Modus-Wahl ist wichtiger als jede Reglerstellung.** Die Doku ist unmissverständlich:
Precision für alles, was **Text, Logos, UI oder Produkttreue** enthält; Creative nur, wenn
Detail hinzuerfunden werden **soll**. Ein Logo durch den Creative-Upscaler zu schicken,
zerstört genau das, was es ausmacht.

**Denselben Prompt wiederverwenden.** Bei KI-generierten Bildern empfiehlt die Doku
ausdrücklich, im Upscaler denselben Prompt zu nutzen wie bei der Generierung — der Upscaler
weiß dann, was er vor sich hat.

**Original als URL schicken, nicht als konvertiertes Base64.** Wörtlich: „Send the original
image via URL whenever possible … Avoid canvas conversions and pre-resizing, which cause
quality degradation."

**`optimized_for` ist kein Stil, sondern eine Inhaltsangabe** — es beschreibt, was auf dem
Bild ist (Porträt, Landschaft, 3D-Render), nicht welchen Look man will.

### Precision hat ZWEI Endpunkte, und sie sind verschieden
| | **V1** `/v1/ai/image-upscaler-precision` | **V2** `/v1/ai/image-upscaler-precision-v2` |
|---|---|---|
| Input | `image` (Base64, Pflicht) | auch **URL** |
| `scale_factor` | **gibt es nicht** | **Zahl 2–16** (nicht das 2x/4x-Enum des Creative) |
| `sharpen` | 0–100, Default **50** | 0–100, Default **7** |
| `smart_grain` | 0–100, Default 7 | — |
| `ultra_detail` | 0–100, Default 30 | — |
| `flavor` | — | `sublime` (Illustration) · `photo` · `photo_denoiser` (verrauscht, Low-Light) |
| `prompt`, `engine` | **beides nicht** | **beides nicht** |

V2 stammt vom 23.10.2025 und **fehlt im `llms.txt`-Index** — wer nur den Index liest, findet
ihn nicht.

**Doku-Rat für Precision:** mit den Defaults anfangen, erst 2x bis 4x, und gegen den
„plastic look" `smart_grain` hochziehen.

### Engines: keine Semantik dokumentiert
`magnific_illusio`, `magnific_sharpy`, `magnific_sparkle` haben nur die Sammelbeschreibung
„Magnific model engines". Der einzige belegte Anhaltspunkt steht bei **Relight**, das seine
Engine `illusio` als `Optimized for illustrations and drawings` beschreibt. Für `sharpy` und
`sparkle` gibt es keinerlei Semantik. **Im Zweifel `automatic`.**

### Der Prompt: eine Zeile Doku, kein Muster
Zum `prompt` beim Creative-Upscaler sagt die Doku nur die bekannte Zeile plus
„prompt-guided enhancement that can introduce or infer new detail", dosiert über
`fractality`. **Kein Strukturmuster, kein echtes Beispiel** (der einzige Prompt der ganzen
Doku ist „Crazy dog in the space"), kein Negativ-Prompt.

**Wenn der Originalprompt fehlt:** `POST /v1/ai/image-to-prompt` ist der dokumentierte Weg,
ihn aus dem Bild zu rekonstruieren.

### Relight und Style Transfer sind besser dokumentiert als die Upscaler
- **Relight** kennt eine **Prompt-Gewichtungssyntax**: `(dark scene:1.3)`, Bereich 1 bis 1.4.
  Dazu drei Wege der Lichtübertragung und eine ausdrückliche `change_background`-Warnung für
  Landschaften und Interieurs.
- **Style Transfer** verlangt ein `reference_image` — **Pflichtfeld**.

<!-- unverified: Doku-Widersprüche. Beide Precision-POST-Seiten tragen die
     Creative-Beschreibung "adding new visual elements ... based on the prompt", obwohl es
     dort kein prompt-Feld gibt. Die V1-vs-V2-FAQ deckt sich nicht mit den Schemata. Das
     Base64-Schema widerspricht der URL-Empfehlung. Die 25,3-Mio-Pixel-Grenze ist nur für
     Creative belegt, nicht für Precision. -->


## Gold-Beispiele
<!-- Doc-informiert. Durch erprobte Regler-Kombinationen aus der Praxis ersetzen. -->

### 1 · Produktfoto treu vergrößern (Precision)
Brief: „E-Commerce-Packshot für den Druck, Etikettentext muss lesbar bleiben."

Request: `POST /v1/ai/image-upscaler-precision`, Bild als **URL**.
Kein Prompt, keine Kreativregler — der ganze Zweck ist Treue.

### 2 · KI-Bild aufwerten (Creative, moderat)
Brief: „GPT-Image-Rendering auf 4x, mehr Hautdetail, ohne dass das Gesicht kippt."

Request: `POST /v1/ai/image-upscaler`
`scale_factor 4x` · `optimized_for soft_portraits` · `engine magnific_sparkle` ·
`creativity 2` · `resemblance 4` · `fractality 0` · `hdr 1` ·
`prompt` = derselbe Prompt, mit dem das Bild erzeugt wurde.

(`resemblance` bewusst höher als `creativity`: Detail ja, neues Gesicht nein.)

## Don'ts
- **Logos, UI und Text nie durch den Creative-Upscaler** — dafür ist Precision da.
- **`creativity` und `resemblance` nicht gleichzeitig hochziehen** — sie arbeiten
  gegeneinander.
- **Nicht mehrere Regler auf einmal ändern** — sonst ist das Ergebnis nicht zuzuordnen.
- **Nicht über 25,3 Megapixel Ergebnis** planen — bei 16x ist das schnell erreicht.
- **Original nicht vorher verkleinern oder über Canvas konvertieren** — die Doku warnt
  ausdrücklich vor Qualitätsverlust.
- **Bei KI-Bildern nicht ohne Prompt upscalen** — derselbe Prompt verbessert das Ergebnis.
- **`optimized_for` nicht als Stilwahl missverstehen** — es sagt, was auf dem Bild ist.
- **Magnific nicht mit „Freepik-Modelle" gleichsetzen** — Fremdmodelle wie Flux und Seedream
  laufen dort nur mit; deren Regeln stehen in deren Files.

## Learnings
- 2026-08-22 · **Ehrlichkeits-Korrektur an meinem eigenen File:** Meine Regler-Tabelle
  (creativity/resemblance/fractality/hdr) war **abgeleitet, nicht dokumentiert**. Magnific
  beschreibt weder Wirkrichtung noch Wechselwirkung — `fractality` und `resemblance` haben
  im 855-KB-Prosa-Dump der Doku **null Treffer**. Die Tabelle steht jetzt unter einem
  `unverified`-Marker.
- 2026-08-22 · **Magnific löst Treue über die Endpunkt-Wahl, nicht über die Regler.**
  Precision statt Creative ist die dokumentierte Strategie; die Regler sind Feinschliff.
- 2026-08-22 · **Precision hat zwei Endpunkte.** V2 kann URL-Input und `scale_factor` als
  Zahl 2–16, hat andere Defaults — und **fehlt im `llms.txt`-Index**.
- 2026-08-22 · **Engines ohne Semantik.** Nur `illusio` ist über Relight belegt
  („Optimized for illustrations and drawings"). Sonst `automatic`.
- 2026-08-22 · **Relight ist besser dokumentiert als die Upscaler** und kennt eine
  Gewichtungssyntax `(dark scene:1.3)` — die einzige im ganzen Roster.
- 2026-08-22 · Erstverifikation gegen docs.magnific.com. **Magnific ist heute eine
  Plattform** (u. a. Mystic, Flux, Seedream, Z-Image); die
  Magnific-eigenen Modelle sind die beiden **Upscaler** und **Mystic**.
- 2026-08-22 · **Creative vs. Precision ist die eigentliche Entscheidung.** Die Landkarte
  07-26 führt Magnific als Upscale-Anbieter hinter Topaz — die Precision-Variante („without
  inventing new elements") ist für Marken- und Produktarbeit aber genau richtig.
- 2026-08-22 · **25,3 Megapixel Ergebnis-Obergrenze** — bei 16x limitiert das die
  Eingangsgröße auf etwa 1,6 MP. Praktisch heißt das: hohe Faktoren nur für kleine Originale.
- 2026-08-22 · Vier bipolare Regler (**−10 … +10**), zwei davon gegenläufig
  (`creativity` ↔ `resemblance`). Das ist kein Prompt-Modell — Framework-Denken hilft hier
  nicht.

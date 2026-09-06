---
name: Nano Banana
aliases: [nano banana, nano-banana, nano banana pro, nano banana 2, gemini image, gemini-3-pro-image, gemini-3.1-flash-image]
vendor: Google
type: image
version: gemini-3-pro-image (Pro) · gemini-3.1-flash-image (2) · -lite-image · gemini-2.5-flash-image (Legacy), Stand 2026-08-22
tasks: [text-to-image, image-edit]
frameworks:
  text-to-image: text-to-image
  image-edit: image-edit
status: active
last_verified: 2026-08-29
source: https://ai.google.dev/gemini-api/docs/image-generation
source_tier: official
prompt_guide: https://ai.google.dev/gemini-api/docs/image-generation
verdikt: Daily Driver
wann_nutze_ich_es: "Wenn schnell ein realistisch wirkendes Bild gebraucht wird und der Stil nicht über mehrere Bilder identisch sein muss."
endpunkt: fal-ai/nano-banana-pro
preis: 0,15 $ pro Bild
notion_rows: [https://app.notion.com/3ab79c4d6b2d81aaa2f5e1ecd2a3e509, https://app.notion.com/3ab79c4d6b2d8102b3ecd3880827182e]
---

# Nano Banana

## Wann nutze ich es

> **Daily Driver** · ⭐⭐⭐⭐⭐ · 0,15 $ pro Bild
>
> Wenn schnell ein realistisch wirkendes Bild gebraucht wird und der Stil nicht über mehrere Bilder identisch sein muss.

**Stärke (Notion):** Sehr gute Realismus- und Typografie-Werte bei kurzer Generierungszeit.

**Schwäche (Notion):** Weniger Kontrolle über exakte Bildkomposition als Seedream, Stilkonsistenz über Serien hinweg schwach.

Der zweite Halbsatz des Auslösers ist die eigentliche Regel: **für Serien mit einheitlichem
Look ist Nano Banana die falsche Wahl** — dafür Seedream (dichte Layouts, Textkontrolle)
oder GPT Image mit Style-Referenzen.

Notion führt zusätzlich **Nano Banana 2** (`fal-ai/nano-banana-2`, Zweitwahl, 0,08 $ pro
Bild): „Wenn viele Varianten schnell durchprobiert werden sollen und die Endfassung später
mit einem stärkeren Modell entsteht." Also: **2 zum Suchen, Pro zum Finalisieren.**

Nano Banana ist außerdem der von Google benannte **Nachfolger von Imagen 4**
(abgeschaltet 17.08.2026) → `models/imagen.md`.

## Routing
- **text-to-image** → Framework `text-to-image`.
- **image-edit** → Framework `image-edit`; Referenzbilder sind nach Rolle gestaffelt
  (Objekte, Charaktere, Stil) — siehe Inputs.

## Model-Specs
Quelle: Gemini-API-Doku, Stand 2026-08-22.

| Handelsname | Model-ID | Positionierung (Doku) |
|---|---|---|
| **Nano Banana Pro** | `gemini-3-pro-image` | „premium choice for most complex visual tasks" |
| **Nano Banana 2** | `gemini-3.1-flash-image` | „most versatile model, generalist workhorse" |
| Nano Banana 2 Lite | `gemini-3.1-flash-lite-image` | „fastest and cheapest Gemini image model" |
| Nano Banana (Legacy) | `gemini-2.5-flash-image` | „legacy pioneer of the Nano Banana series" |

**Zwei Oberflächen — nicht verwechseln.** Simons Endpunkte zeigen auf die **fal-Wrapper**
(`fal-ai/nano-banana-pro`, `fal-ai/nano-banana-2`). Die native Schnittstelle ist Googles
**Interactions API**: `POST https://generativelanguage.googleapis.com/v1beta/interactions`
bzw. `client.interactions.create()`. **Nicht** `generate_images` (das war Imagen), **nicht**
der klassische `generate_content`-Pfad. Die Feldnamen unten gelten für die native Seite.

**Thinking ist immer an** — „enabled by default and cannot be disabled". Nur bei
3.1 Flash Image lässt sich die Stufe über `generation_config.thinking_level`
(`minimal` Default | `high`) steuern.

**Google-Search-Grounding** unterstützen 3.1 Flash und 3 Pro. **Image Search kann nur
3.1 Flash** (`"search_types": ["web_search", "image_search"]`).
**Video als Eingabe** kann ebenfalls nur 3.1 Flash (YouTube-URLs und Uploads).

## Inputs

**Eingabe-Modalitäten**
- **Text** — der Prompt.
- **Bild** — Referenzbilder, **maximal 14 insgesamt**, aber **nach Rolle gestaffelt und je
  Modell verschieden**:

| Modell | Objekte | Charaktere | Stil-Referenzen |
|---|---|---|---|
| 3.1 Flash Lite | 14 | keine | keine |
| 3.1 Flash | 10 | 4 | **keine** |
| **3 Pro (Nano Banana Pro)** | **6** | **5** | **3** |

  Formate **PNG, JPEG, GIF, WebP**, base64 oder über die Files API.
- **Video** — nur 3.1 Flash: YouTube-URL oder hochgeladene Datei.
- **Keine Maske.**

**Steuerparameter (`response_format`)**
| Parameter | Werte | Default |
|---|---|---|
| `type` | `image` | Pflicht |
| `mime_type` | `image/jpeg` \| `image/png` | — |
| `aspect_ratio` | `1:1`, `3:2`, `2:3`, `3:4`, `4:3`, **`4:5`**, `5:4`, `9:16`, `16:9`, `21:9` | — |
| `image_size` | `512px (0.5K)` (**nur 3.1 Flash Lite**), `1K`, `2K`, `4K` | **`1K`** |
| `generation_config.thinking_level` | `minimal` \| `high` (**nur 3.1 Flash Image**) | `minimal` |

**Geht nicht** — Thinking abschalten; `512px` außerhalb von 3.1 Flash Lite;
`thinking_level` außerhalb von 3.1 Flash Image; Image-Search-Grounding oder Video-Eingabe
bei **Pro**; mehr Referenzbilder als die Rollen-Tabelle erlaubt; eine Maske.

**Ausgabe** — Bild als JPEG oder PNG, 1K bis 4K, in zehn Seitenverhältnissen (inklusive
**4:5**), **immer mit SynthID-Wasserzeichen**.

## Inputs auf fal
Quelle: fal-OpenAPI `fal-ai/nano-banana-pro`, `…/edit`, `fal-ai/nano-banana-2`, `…/edit`,
gelesen 2026-08-29 (`research/fal-schemas-2026-08-29.md`). **Bei Abweichung gilt fal.**

| fal-Feld | Pflicht | Werte | Hinweis |
|---|---|---|---|
| `prompt` | ja | 3–50.000 Zeichen | |
| `image_urls` (edit) | ja (Pro) / nein (2) | Array, **kein Limit im Schema** | die Rollen-Staffelung 6 Objekte · 5 Charaktere · 3 Stil (nativ) bleibt die Arbeitsregel — fal lehnt nicht ab, das Modell ignoriert Überzähliges |
| `aspect_ratio` | nein | frei (Pro Default `1:1`, edit `auto`); NB2 auch 4:1 · 1:4 · 8:1 · 1:8 | |
| `resolution` | nein | Pro `1K`·`2K`·`4K` (Default 1K) · NB2 zusätzlich `0.5K` | 1K-Default — für Print/4K explizit setzen |
| `num_images` | nein | 1–4 | |
| `seed` | nein | int | nativ nicht dokumentiert |
| `system_prompt` | nein | ≤ 50.000 Zeichen | Persona/Stil über den ganzen Request — fal-spezifisch |
| `enable_web_search` | nein | bool | Modell darf aktuelle Web-Infos ziehen |
| `safety_tolerance` | nein | 1–6 (Default 4) | |
| `limit_generations` | nein | bool (Default true) | eine Generation pro Prompt-Runde |
| `thinking_level` (NB2) | nein | `minimal` · `high` | |
| `video_url` · `audio_url` · `pdf_url` (NB2 edit) | nein | je ≤ 15 MB, Video auch YouTube-URL | **Kontext-Eingaben**, die es bei Pro nicht gibt |

Ausgabe: `images[]` + `description` (Modell-Kommentar). **Keine Maske** auf beiden Endpunkten.

## Overrides
Quelle: Gemini-API-Bildgenerierungs-Doku (gelesen 2026-08-22).
Bericht: `research/nano-banana-promptguide-2026-08-22.md`.

**Szene erzählen, nicht Stichworte listen.** Wörtlich: „Describe the scene, don't just list
keywords." Ein zusammenhängender Absatz schlägt eine Keyword-Kette. Das ist dieselbe Regel
wie bei GPT Image und der Gegenpol zu Modellen, die Tag-Stapel vertragen.

**Prompt beginnt mit einem starken Verb.** Die Doku arbeitet nicht mit einer festen
Feldreihenfolge, sondern mit **aufgabenspezifischen Vorlagen** — sieben fürs Generieren,
sieben fürs Editieren.

**Keine echten Negativ-Prompts**, nur „semantic negative prompts": positiv umformulieren,
also „empty, deserted street" statt „no cars".

**Beim Editieren ersetzt der Satz die Maske.** Ausdrücklich sagen, was **gleich bleibt**:
„Keep everything else exactly the same…". Nano Banana kennt keine Maske — dieser Satz ist
der Ersatz dafür.

### Referenzbilder: die Rolle wird im Prompt vergeben, nicht per Parameter
**Es gibt keinen API-Parameter für den Referenztyp.** Die Bilder gehen als **flache,
geordnete Liste** rein; die Staffelung nach Objekt/Charakter/Stil ist ein modellseitiges
Limit, kein Feld. Die Rolle vergibt der Prompt-Text:

- über die **Ordnung**: „the first image… the second image…", „[element from image 1]"
- über die **Rolle**: „the attached napkin sketch **as the structure**, the fabric sample
  **as the texture**"
- für Personengruppen genügt „these people"

**Regel: Bildreihenfolge = Ansprache im Prompt.**

### Der harte Unterschied Pro gegen 2
| | Pro (`gemini-3-pro-image`) | 2 (`gemini-3.1-flash-image`) |
|---|---|---|
| **Stil-Referenzbilder** | **bis 3** | **keine** — Stil muss sprachlich beschrieben werden |
| Objekte / Charaktere | 6 / 5 | 10 / 4 |
| Thinking | an, **nicht abschaltbar**, kein `thinking_level` | steuerbar, Default **`minimal`** |
| Video-Input, Image-Search | nein | ja |

**Praxisregel daraus:** Wer einen Look über eine Serie halten will, braucht die
**Stil-Referenz — und die gibt es nur bei Pro.** Bei 2 muss der Stil in Worte. Das erklärt
Notions Schwäche-Eintrag („Stilkonsistenz über Serien hinweg schwach") genauer, als es dort
steht.

**Bei Nano Banana 2 für komplexe Kompositionen `thinking_level: high` setzen** — der
Default ist `minimal`. Bei Pro entfällt die Entscheidung, dort denkt das Modell immer voll.

### Text im Bild ist zweistufig
Die Doku empfiehlt unter *Limitations* (nicht im Prompt-Guide): **„first generate the text
and then ask for an image with the text"**. Also erst den Textinhalt festlegen, dann das
Bild damit anfordern. Schrift deskriptiv benennen, Text in Anführungszeichen.

<!-- unverified: Zwei Quellenkonflikte. Vertex AI nennt für Pro 15 Seitenverhältnisse
     (inkl. 1:4, 8:1, 9:21) gegen 10 in der Gemini-API-Doku; und Vertex stuft
     Search-Grounding bei 3.1 Flash als "not supported" ein, was der Gemini-API-Doku
     widerspricht. Im File gelten die Gemini-API-Werte. Ausserdem existiert der
     Prompt-Guide in zwei Fassungen (Interactions- und Legacy-generateContent-Doku); die
     neue Fassung hat das Grundprinzip "describe the scene" und den Hinweis "does not
     support generating a transparent background" verloren, ohne sie zu widerrufen. -->


## Gold-Beispiele
<!-- Doc-informiert. Durch erprobte Prompts ersetzen. -->

### 1 · Schneller Realismus-Shot (Pro)
Brief: „Lifestyle-Foto, Person mit Kaffeebecher am Fenster."

    A candid lifestyle photograph of a woman in a knitted sweater holding a paper coffee cup by a large window, soft overcast daylight from the left, shallow depth of field, natural skin texture, muted warm palette, editorial feel.

Parameter: `gemini-3-pro-image`, `aspect_ratio "4:5"`, `image_size "2K"`,
`mime_type "image/png"`.

### 2 · Variantensuche günstig, Finale teuer
Brief: „Zehn Kompositionen durchprobieren, dann eine final."

Schritt 1: `gemini-3.1-flash-image` (Nano Banana 2, 0,08 $/Bild) — zehn Varianten.
Schritt 2: die gewählte Komposition erneut auf `gemini-3-pro-image` (0,15 $/Bild).
Das ist genau der Auslöser, den Notion für Nano Banana 2 nennt.

## Don'ts
- **Nicht für Serien mit einheitlichem Look** — Stilkonsistenz über mehrere Bilder ist die
  dokumentierte Schwäche; dafür Seedream oder GPT Image mit Style-Referenzen.
- **Thinking nicht abschalten wollen** — geht nicht, und `thinking_level` gibt es nur bei
  3.1 Flash Image.
- **Bei Pro keine Video-Eingabe und kein Image-Search-Grounding** erwarten — beides kann
  nur 3.1 Flash.
- **Referenzbilder nicht als flache Liste** denken — sie sind nach Objekt, Charakter und
  Stil gestaffelt, mit unterschiedlichen Obergrenzen je Modell.
- **`512px` nicht bei Pro oder Flash** anfordern — nur Flash Lite.
- **Kleinen oder dichten Text nicht an Nano Banana 2** geben („bei kleinem Text
  unbrauchbar") — Pro oder Seedream.
- **Nicht `generate_images` aufrufen** — das war der Imagen-Pfad; Nano Banana läuft über
  die Interactions API.
- **SynthID nicht wegdenken** — jede Ausgabe trägt es.

## Learnings
- 2026-08-31 · **Community-Beobachtung (Higgsfield-Breakdown; unbestätigt):** Ein Prop-Sheet
  (TV-Fernbedienung) aus GPT Image 2 kam „flat — no depth, no shadows" und las als 2D-Objekt;
  **derselbe Prompt in Nano Banana Pro** lieferte Tiefe, Highlights und Kantenverlauf. Lehre des Teams:
  „There's no single best model for everything — if the result isn't what you wanted, switch the model."
  Deckt sich mit unserem Firstframe-Befund in Gegenrichtung (GPT Image 2 gewann bei Haut-Echtheit).
  Hypothese: Nano Banana Pro für Objekte/Produkte mit Volumen, GPT Image 2 für Personen. **Testkandidat.**
- 2026-08-31 · **Community-Erfahrungswert (Higgsfield „HIGGS Brand — All Prompts Used" + „Nano Banana Pro
  Prompts (Brand Kit)", Notion; unbestätigt):** Produkt-Referenzblätter als **Spec-Blöcke** statt Prosa —
  `FABRIC & TEXTURE / SILHOUETTE / PANEL CONSTRUCTION / LOGO / COLORWAY / 4 VIEWS / PRESENTATION`, Maße in cm
  („small ~2cm, glossy silver"), **Hex-Farben im Prompt** (`#d1fe17`, `#FFFFFF`, `#0D0D0D`), Negativlisten
  in Großbuchstaben („NO text, NO callouts, NO labels", „ONE single white stripe … not three"). Brand-Kit als
  **Edit-Kette** auf demselben Bild: „Change the color of the logo to white and the color of the liquid to
  orange yellow, keep the original density of the liquid" → Szene wechseln → Lifestyle → Mascot → Landing
  Page → Meme. Rohtexte `research/higgsfield-corpus-2026-08-31/notion/{higgs-brand-all-prompts,nano-banana-pro-brandkit}.txt`.
- 2026-08-31 · **Community-Erfahrungswert (Higgsfield „Nano Banana Pro — Full Prompt Library", Notion;
  unbestätigt)** — Rohtext `research/higgsfield-corpus-2026-08-31/notion/nano-banana-pro-library.txt`.
  Die gezeigten Prompts sind auffallend **kurz und imperativ** („Zoome 100x", „Unpack the items from the bag
  and place them on the bed", „Make an online shop page for this corset", „Create a fingerprint map of this
  finger") und setzen auf **Genre-Rahmung** statt Bildbeschreibung: „Screenshot of youtube thumbnail with …",
  „leaked manga panel … in English", „Behind the scenes of a live-action … movie, filming crew visible",
  „iphone shot of old 2000s holographic glitter sticker". Zeitverläufe als **Split-Frame** („frame split into
  three: 2 pm / 4 pm / 6 pm, analog clock shows the correct time"); Lehrgrafiken als „exploded view … each
  element labeled with name and cost". Gegenpol zu unserer Referenz-schweren Praxis — Hypothese: Nano
  Banana Pro braucht bei Weltwissen-Motiven wenig Text, bei Identität viel Referenz. **Testkandidat.**
- 2026-08-23 · **Die fal-Ebene weicht in drei Punkten von der Gemini-Doku ab** (Endpunkt
  `fal-ai/nano-banana-pro/edit`): das Auflösungsfeld heißt dort **`resolution`**
  (`1K`/`2K`/`4K`), nicht `image_size`; Referenzen gehen als flache `image_urls`-Liste;
  es gibt zusätzlich `safety_tolerance`, `system_prompt` und `limit_generations`.
- 2026-08-23 · **`storage.fal.run` ist tot** (NXDOMAIN). Upload läuft zweistufig:
  POST `rest.alpha.fal.ai/storage/upload/initiate?storage_type=fal-cdn-v3` → presigned
  `upload_url` → PUT der Bytes → `file_url` benutzen. Python-`urllib` hängt beim PUT auf
  `v3b.fal.media`; curl macht denselben Request in unter drei Sekunden.
- 2026-08-23 · **Queue-Polling läuft auf der App-ID, nicht auf dem Sub-Pfad.**
  `queue.fal.run/fal-ai/nano-banana-pro/requests/<id>/status` — mit `/edit` im Pfad
  antwortet fal **405**. Sicherste Variante: `status_url` und `response_url` aus der
  Submit-Antwort nehmen, statt sie zu bauen.
- 2026-08-23 · **"4K" ist bei Pro die lange Kante ab 4096, nicht 3840.** `16:9` + `4K`
  liefert 5504×3072, `1:1` + `4K` liefert 4096×4096.
- 2026-08-23 · **Sechs Bilder, fünf Personen-Referenzen plus eine Stil-Referenz, gehen in
  einem Aufruf** — die Rollentrennung allein über den Prompt-Text ("The first five images…
  The sixth image is the lighting and set reference") hat auf Anhieb gehalten.
- 2026-08-22 · **Faktenkorrektur an meinem eigenen File:** Stil-Referenzbilder hat **nur
  Pro** (bis 3). Ich hatte bei Pro „keine eigene Angabe" stehen und bei 3.1 Flash
  fälschlich 3 Stil-Slots. Genau umgekehrt. Damit ist Pro das Modell für Serien-Looks,
  nicht 2.
- 2026-08-22 · **Die Typisierung der Referenzen ist kein API-Feld**, sondern ein Limit.
  Die Rolle vergibt der Prompt über Reihenfolge und Zuweisung („as the structure",
  „as the texture"). Bildreihenfolge = Ansprache.
- 2026-08-22 · **Text im Bild ist zweistufig** — erst den Text erzeugen, dann das Bild damit
  anfordern. Steht unter *Limitations*, nicht im Prompt-Guide; leicht zu übersehen.
- 2026-08-22 · Der Prompt-Guide existiert in **zwei Doku-Fassungen**, die neuere hat Regeln
  verloren, ohne sie zu widerrufen. Beim Re-Verifizieren beide lesen.
- 2026-08-22 · Nützlich: jede `ai.google.dev`-Seite liefert mit angehängtem **`.md.txt`**
  den Rohtext inklusive Tabellen, ohne Rendering.
- 2026-08-22 · Erstanlage, ausgelöst durch den Notion-Abgleich: **Nano Banana Pro ist
  Simons Daily Driver und hatte kein Model-File.** Der Skill war auf Herstellermarken
  geschnitten, nicht auf tatsächliche Nutzung.
- 2026-08-22 · **Referenzbilder sind typisiert** (Objekt/Charakter/Stil) und je Modell
  unterschiedlich gedeckelt — im Roster einmalig. Pro hat die meisten Charakter-Slots (5).
- 2026-08-22 · **Thinking lässt sich nicht abschalten.** Damit ist Nano Banana das
  Gegenteil von FLUX `[klein]` („what you write is what you get") — erklärt die schwache
  Serien-Konsistenz aus Notions Schwäche-Feld.
- 2026-08-22 · Zwei Oberflächen: Simon ruft die **fal-Wrapper** auf, dokumentiert ist die
  **Interactions API**. Bei Parameter-Abweichungen gilt für Simons Aufrufe fal.

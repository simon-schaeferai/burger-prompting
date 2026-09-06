---
name: GPT Image
aliases: [gpt image, gpt-image, gpt-image-1, gpt-image-2, openai image, dall-e]
vendor: OpenAI
type: image
version: gpt-image-2 (Flaggschiff, Launch 2026-04-21; gpt-image-1 / 1.5 / mini parallel verfügbar)
tasks: [text-to-image, image-edit]
frameworks:
  text-to-image: burger
  image-edit: image-edit
status: active
last_verified: 2026-08-29
source: https://developers.openai.com/api/docs/guides/image-generation
source_tier: official
prompt_guide: https://developers.openai.com/cookbook/examples/multimodal/image-gen-models-prompting-guide
verdikt: Daily Driver
wann_nutze_ich_es: "Wenn ein Visual in Simons CI entstehen soll und Style-Referenzen mitgegeben werden, etwa Infografiken über den Grafiken-Tab."
endpunkt: openai/gpt-image-2
preis: 0,413 $ pro Bild (3840×2160, high, fal edit) · 0,234 $ bei 2560×1440
notion_rows: [https://app.notion.com/3ab79c4d6b2d816bac80c49b3dd9294f, https://app.notion.com/3ab79c4d6b2d8182bf71e56b2ce778a2]
---

# GPT Image

> Verifiziert gegen die offiziellen OpenAI-Docs — **Model-Page**, **API-Reference** (Create image + Create image edit), **Image-Generation-Guide** und **Cookbook-Prompting-Guide** — Stand 2026-07-13. Voller zitierter Report: `research/gpt-image-2-prompting-2026-07-13.md` (shipt nicht).
> Flaggschiff = **gpt-image-2**; die gpt-image-1-Linie (1 / 1.5 / mini) läuft parallel und weicht v. a. bei Transparenz, `input_fidelity` und Streaming ab (siehe Specs).

## Wann nutze ich es

> **Daily Driver** · ⭐⭐⭐⭐⭐ · —
>
> Wenn ein Visual in Simons CI entstehen soll und Style-Referenzen mitgegeben werden, etwa Infografiken über den Grafiken-Tab.

**Stärke (Notion):** Feine Typografie und sehr gute Prompt-Treue bei komplexen Anweisungen. Erzeugt nativ 4:5 ohne Crop.

**Schwäche (Notion):** Langsam im Vergleich zu Flux schnell, und der Stil zieht ohne Style-Referenzen ins Generische.

Für den Edit-Weg führt Notion eine eigene Zeile (`openai/gpt-image-2/edit`, Zweitwahl): „Wenn an einem fertigen Visual nur ein Detail geändert werden soll und der Rest exakt bleiben muss."

**Gemessen (yfood, 2026-08-18):** Der Edit-Weg liefert **schärfere** Kanten als text-to-image (121,7 gegen 96,8) — die Zweitwahl-Einstufung gilt der Kostenfrage, nicht der Qualität.

## Routing
- **text-to-image** → Framework `burger` (6 Schichten: Medium/Subjekt/Aktion/Umgebung/Licht/Stil — Simons Formel, Default). GPT Image ist natürliche-Sprache-first, die gelabelten Burger-Schichten treffen genau die offizielle Struktur-Präferenz (siehe Overrides). Für tag-basiertes Feintuning alternativ das `text-to-image`-5-Block-Framework.
- **image-edit** → Framework `image-edit` (Edit-Endpoint: bis zu 16 Bilder + Instruktion, optional Maske).

## Model-Specs
Quelle: OpenAI Model-Page + API-Reference (Create image / Create image edit) + Image-Generation-Guide + Cookbook-Prompting-Guide (Stand 2026-07-13).

### Generate (`v1/images/generations`)
- **Prompt:** natürliche Sprache, keine Flags/Tags nötig. Max-Länge **32.000 Zeichen** (GPT-Image-Modelle).
- **Kein Negative Prompt, kein Seed** — die API kennt beides nicht → **nicht reproduzierbar**; Verneinung positiv formulieren.
- **Größen (gpt-image-2):** beliebige `BxH` — beide Kanten Vielfache von 16, längste Kante ≤ 3840 px, Aspect Ratio **zwischen 1:3 und 3:1**, Gesamtpixel 655.360–8.294.400; **> 2560×1440 experimentell**. Gängig: 1024×1024, 1536×1024, 1024×1536, 2048×2048, bis 3840×2160 (4K). Plus `auto`.
- **Größen (gpt-image-1 / 1.5 / mini):** Standard-Sets **1024², 1536×1024, 1024×1536** + `auto`. (256²/512² gehören zu **dall-e-2**, nicht zu dieser Familie.)
- **Quality:** `low | medium | high | auto` (Default `auto`).
- **Output-Format:** `png` (Default) · `jpeg` · `webp`; für jpeg/webp `output_compression` 0–100 (jpeg schneller als png).
- **Response:** GPT-Image-Modelle liefern **immer Base64** — `response_format` nicht unterstützt (keine URL).
- **Transparenz:** `background = transparent | opaque | auto` (Default `auto`), braucht Format png/webp. **gpt-image-2 unterstützt `transparent` NICHT** (Guide wörtlich: „Requests with `background: 'transparent'` aren't supported for this model") → für transparente Ausgabe die **gpt-image-1-Familie** nutzen.
- **Streaming:** für **gpt-image-2 nicht unterstützt** (Model-Page). `stream` + `partial_images` (0–3) existieren in der Images-API nur für die **gpt-image-1-Familie**.
- **Weiteres:** `n` = 1–10 (Mehrfach-Output); `moderation: auto | low`; Org-Verifizierung im OpenAI-Dashboard nötig.
- **Nicht unterstützt (Model-Page):** Streaming, Function Calling, Structured Outputs, Fine-Tuning.

### Edit (`v1/images/edits`)
- **Bis zu 16 Input-Bilder** im `image[]`-Feld (API-Ref wörtlich: „For GPT image models, you can provide up to 16 images"). Upload-Reihenfolge = Referenz „image 1 / image 2 …" im Prompt. Output weiterhin `n` ≤ 10.
- **`input_fidelity`:** **gpt-image-2 lehnt den Parameter ab (400)** — verarbeitet jeden Bild-Input automatisch hi-fi. Nur die gpt-image-1-Familie akzeptiert `high | low`.
- **Maske:** optionaler Alpha-Kanal-Inpaint, gilt fürs **erste** Bild, muss dessen Dimensionen matchen; PNG/WebP (JPG hat keinen Alpha-Kanal → häufigster Fehler). Weiß = neu generieren, Schwarz = unangetastet.
- **Größen / Quality / Format / background:** gleiche Wertebereiche wie Generate (inkl. gpt-image-2-Transparenz-Verbot).

## Inputs

Was das Model annimmt (aus denselben Quellen wie `## Model-Specs`, Stand 2026-07-13).

**Eingabe-Modalitäten**
- **Text** — der Prompt, natürliche Sprache. Max. **32.000 Zeichen**.
- **Bild** — nur am Edit-Endpoint (`v1/images/edits`), **bis zu 16 Bilder** im `image[]`-Feld.
  Upload-Reihenfolge = Referenz "image 1 / image 2 …" im Prompt.
- **Maske** — optional, genau **eine**, gilt fürs **erste** Bild und muss dessen Dimensionen
  exakt matchen. **PNG oder WebP mit Alpha-Kanal** (JPG hat keinen → häufigster Fehler).
  Weiß = neu generieren, Schwarz = unangetastet.
- **Kein Video, kein Audio, keine 3D-Eingabe.**

**Steuerparameter**
| Parameter | Wertebereich |
|---|---|
| `size` | `auto` oder `BxH`: beide Kanten Vielfache von 16, längste ≤ 3840 px, AR zwischen 1:3 und 3:1, Gesamtpixel 655.360–8.294.400 (gpt-image-2). gpt-image-1-Familie: 1024², 1536×1024, 1024×1536, `auto` |
| `quality` | `low` \| `medium` \| `high` \| `auto` (Default `auto`) |
| `output_format` | `png` (Default) \| `jpeg` \| `webp` |
| `output_compression` | 0–100, nur bei jpeg/webp |
| `background` | `transparent` \| `opaque` \| `auto` — **`transparent` nur gpt-image-1-Familie** |
| `n` | 1–10 |
| `moderation` | `auto` \| `low` |
| `input_fidelity` | `high` \| `low` — **nur gpt-image-1-Familie**; gpt-image-2 lehnt den Parameter mit 400 ab |

**Geht nicht** — kein Seed, kein Negative-Prompt, kein `response_format` (also nie eine URL),
kein Streaming bei gpt-image-2, kein `input_fidelity` bei gpt-image-2, kein
`background: transparent` bei gpt-image-2, kein Reasoning-/Thinking-Parameter, kein
Function Calling, keine Structured Outputs, kein Fine-Tuning.

**Ausgabe** — immer **Base64** (nie URL), Format png/jpeg/webp, bis 3840 px längste Kante
(über 2560×1440 laut Guide experimentell), 1–10 Bilder pro Request.

## Inputs auf fal
Quelle: fal-OpenAPI `fal-ai/gpt-image-2/edit` und `fal-ai/gpt-image-2`, gelesen 2026-08-29
(Beleg im Repo: `research/fal-schemas-2026-08-29.md`). Das ist der Wrapper, den Simon nutzt —
**bei Abweichung zur nativen API gilt hier fal.**

| fal-Feld | Pflicht | Werte | Abweichung zur OpenAI-API |
|---|---|---|---|
| `prompt` | ja | 2–32.000 Zeichen | — |
| `image_urls` (edit) | ja | **max. 16** URLs | wie nativ (`image[]`) |
| `mask_url` (edit) | nein | eine URL, gilt fürs erste Bild | wie nativ |
| `image_size` | nein | `auto` · Preset (`landscape_4_3` …) · `{width, height}` | nativ `size` als `BxH`-String |
| `quality` | nein | `auto` · `low` · `medium` · `high` — **Default `high`** | nativ Default `auto` — Kosten! |
| `background` | nein | `auto` · `transparent` · `opaque` | `transparent` bei gpt-image-2 nicht belegt |
| `num_images` | nein | **1–4** | nativ `n` 1–10 |
| `output_format` | nein | `png` (Default) · `jpeg` · `webp` | `output_compression` fehlt auf fal |
| `sync_mode` | nein | bool | fal-spezifisch |

**Fehlt auf fal:** `input_fidelity` (400 bei Senden), `output_compression`, `moderation`, Streaming/
Responses-API-Muster. Ausgabe: `images[]`.

## Overrides
Die 5-Block-Struktur (Subject/Composition/Lighting/Camera/Style) funktioniert, ist aber **nicht zwingend** — gpt-image-2 ist natürliche-Sprache- und instruction-following-first. Offizielle Prompt-Präferenzen (Cookbook-Prompting-Guide):

**text-to-image**
- **Struktur-Reihenfolge:** `Szene/Hintergrund → Subject → Key-Details → Constraints`; den **intended use** nennen (ad / UI-mock / infographic) — das setzt „mode" und Politur. Komplexe Prompts in **kurzen gelabelten Segmenten / Zeilenumbrüchen** statt einem langen Absatz.
- **Funktional statt dekorativ:** wie ein Creative-Brief schreiben. **Fotografie-Sprache** (Lens/Lighting/Framing) + echte Textur explizit anfordern (Poren, Stoff-Abnutzung, Imperfektionen). „beautiful/stunning" setzt nur Stimmung, schärft kein Detail.
- **Verneinungen positiv** formulieren (kein Negative Prompt): „empty street" statt „no cars".
- **Front-Loading** (Erfahrung): Kern-Subject/Composition/Style in die ersten ~50 Wörter.
- **Text im Bild:** literalen Text in **"Anführungszeichen" oder ALL CAPS**; Typografie spezifizieren (Style/Size/Color/Placement); schwierige Wörter **Buchstabe für Buchstabe** buchstabieren; **medium/high Quality** für kleinen/dichten/Multi-Font-Text. Ungewollten Auto-Text per **Ausschluss-Klausel** unterdrücken.
- **Transparenz** nur mit der gpt-image-1-Familie (gpt-image-2 kann es nicht).

**image-edit**
- **Reference-by-index/role:** jeden Input mit Index + Rolle benennen („Image 1: product photo … Image 2: style reference …") und die **Interaktion** beschreiben („apply Image 2's style to Image 1").
- **Preserve-Liste explizit** und **bei jeder Iteration wiederholen** → weniger Drift: „change only X" + „keep everything else the same"; für chirurgische Edits zusätzlich verbieten, Saturation/Contrast/Layout/Arrows/Labels/Camera-Angle zu ändern.
- **`input_fidelity` nicht senden** (400 bei gpt-image-2); Referenzen vorher **runterskalieren** — hi-fi-Verarbeitung kostet gleich viel, egal wie groß die Referenz.
- **Restart statt 4. Edit** (Erfahrung): löst der 3. Edit das Problem nicht, neue saubere Prompt-Basis statt Weiter-Iterieren.

> **Kein „Thinking-Mode" am Modell.** gpt-image-2 hat keinen Reasoning-/Thinking-Parameter (Model-Page). Das „Planen vor dem Rendern" entsteht über das **Responses-API-Muster**: ein reasoning-fähiges Mainline-Modell plant (ggf. mit Web-Suche) und ruft dann das `image_generation`-Tool. Community-„Thinking vs. Instant" ist UX, kein Spec.

## Gold-Beispiele
<!-- Doc-informierte Referenz-Beispiele. Durch echte, erprobte Prompts ersetzen, sobald vorhanden. -->

### 1 · Poster mit Bild-Text (Stärke: Text im Bild)
Brief: „Minimalistisches Event-Poster, großer Titel ‚NIGHT MARKET', neon-urban."

    A bold minimalist event poster (intended use: printed event flyer). Centered large title text reading exactly "NIGHT MARKET" in a clean bold sans-serif, high on the frame. A neon-lit night street market glows behind it, wet pavement reflecting pink and cyan signage. High contrast, editorial layout, generous negative space around the title. No extra text, no watermarks, no labels beyond the title.

Parameter: size `1024x1536`, quality `high`, format `png`.

### 2 · Fotorealistische Szene (Struktur: Szene → Subject → Details)
Brief: „Barista übergibt Coffee-to-go, goldenes Fensterlicht."

    A cozy specialty café interior in warm golden-hour light (intended use: lifestyle brand photo). A barista hands a paper coffee cup across a wooden counter, candid mid-motion. Medium shot, subject slightly off-center, shallow depth of field, 50mm-equivalent, eye level. Soft window light from camera-left, gentle wraparound shadows. Real skin texture with visible pores, natural fabric weave on the apron, subtle film grain. Muted warm palette.

Parameter: size `1536x1024`, quality `high`.

### 3 · Edit mit Referenz + Preserve-Liste (image-edit)
Brief: „Produktfoto (Image 1) in eine Premium-Werbeszene setzen, Look von Image 2."

    Image 1: the product (headphones), faithfully reproduced. Image 2: style reference for lighting and mood. Place the product from Image 1 into a clean premium studio scene, applying Image 2's warm rim-lighting and soft gradient background. Change only the background and lighting; keep the product's shape, color, materials and label unchanged. No watermark, no extra text, no added props. Do not alter the product's geometry, saturation or logo.

Parameter (edit): size `1024x1024`, quality `high`; `input_fidelity` NICHT senden.

## Don'ts
- **Keine URL erwarten** — Output ist immer Base64.
- **Bei gpt-image-2 kein `background: transparent`** (400) — dafür die gpt-image-1-Familie nutzen.
- **Keine „no X"-Formulierungen** (kein Negative Prompt) — beschreiben, was DA sein soll.
- **Nicht auf Reproduzierbarkeit bauen** (kein Seed).
- **Kein Keyword-/Adjektiv-Stacking** („8K, ultra-detailed, masterpiece, cinematic, award-winning") — schadet diesem Modell aktiv; funktional beschreiben.
- **Nicht auf einen „Thinking-Mode"-Parameter am Modell verlassen** — den gibt es nicht (nur das Responses-API-Muster).
- **`input_fidelity` bei gpt-image-2 nicht senden** (400) — Inputs sind automatisch hi-fi.
- **JPG nicht als Maske** verwenden (kein Alpha-Kanal) → PNG/WebP.
- **Nicht 20 Constraints auf einmal** — die 5–8 wichtigsten zuerst, bestätigen, dann iterieren (Erfahrung).
- **Keine feste %-Texttreue versprechen** — Technik nutzen (Quotes/ALL CAPS/Quality), es gibt keinen offiziellen Garantie-Wert.

## Learnings
- 2026-08-26 · **Ein Video-Frame allein schlug Frame + 5 Gesichter + Pressefotos — bei
  Echtheit UND Pose.** Lauf 1 (9 Referenzen) las als Render: Showroom-Politur der Pressefotos,
  fremdes Licht der Gesichts-Serie. Lauf 3 mit **nur dem Quellframe** und dem Revuelto in Prosa
  (Sechseck-Lüfter, Y-Motive, Schild, rote Drehschalter) kam 4/4 als Handy-Frame mit
  Lamborghini-Kabine zurück. Regel: **Beim Edit eines vorhandenen Frames ist der Frame die
  Referenz — jede weitere bringt ihr eigenes Licht und ihre eigene Politur mit.** Die
  Fünf-Gesichter-Regel des Firstframe-Packs gilt für Text-zu-Person, nicht für Frame-Edits.
- 2026-08-26 · **Echtheit im Auto kam aus fünf Sätzen:** Gurt quer übers Shirt, Handy am
  Armaturenbrett als Kamera, Himmel ausgefressen („exposed for his face"), Fingerabdrücke/
  Staub/Ladekabel, Spiegelungen auf der Scheibe. Kein einziger davon betrifft das Gesicht.
- 2026-08-26 · **1-Cent-Probe vor dem 4K-Lauf** (1024×576, `low`, `num_images 1`, ≈ 0,011 $):
  prüft Guthaben (fal löscht gesperrte Anfragen nach Minuten — ein 4K-Lauf wäre verloren) und
  zeigt Pose/Richtung. Mit Freigabe-Marke, danach sofort der volle Lauf.
- 2026-08-26 · **Preise auf fal für `fal-ai/gpt-image-2/edit`** (Preisseite, gleicher Tag): high-Quality
  1024² 0,219 $ · 1920×1080 0,158 $ · 2560×1440 0,234 $ · **3840×2160 0,413 $**; medium etwa ein
  Viertel, low ein Zehntel davon. Ein 4K-Supersampling-Bild kostet also unter einem halben
  Dollar — der Qualitäts-Hebel aus dem yfood-Lauf ist bezahlbar.
- 2026-08-26 · **Profil-Konsistenz entscheidet sich an der Kameraseite, nicht am Prompt.**
  Ein Fahrer schaut nach vorn; soll der Kopf wie in der Quelle nach LINKS blicken, muss die
  Kamera links vom Fahrer stehen (Linkslenker: außerhalb der Fahrertür). Vom Beifahrersitz
  wäre das Gesicht gespiegelt — Ohrring, Zopfverlauf, Bartkante drehen mit. Erst die Geometrie
  der Szene auf die Quelle legen, dann prompten. Lauf: `generated/2026-08-26_lamborghini/`.
- 2026-08-26 · **Ein Video-Frame als Bild 1 trägt Licht und Pose fast allein.** Mit „exactly as
  in Image 1" kam sogar der harte Sonnenstreifen auf dem Wangenknochen in 6 von 6 Bildern
  zurück; die fünf Gesichts-Referenzen aus dem Firstframe-Rezept stützten die Identität.
  Was driftete: bei 2 von 6 kippte das strenge Profil ins Dreiviertel (Modell will Gesicht
  zeigen), und der Abstand der Kamera streute (Kopf mal klein, mal groß) — Kopfgröße als
  Anteil der Bildhöhe angeben, nicht nur „same distance".
- 2026-08-23 · **Bei fotorealistischen Menschen liefert GPT Image 2 die überzeugendste
  Oberfläche im Roster.** Weichere Wiedergabe ohne die hohe Kantenschärfe, die bei Nano
  Banana als „KI-scharf" liest, und ein zurückhaltenderer Grade. Wenn ein Bild als echte
  Kameraaufnahme durchgehen soll — Talking Head, Firstframe, Porträt —, ist das der
  entscheidende Vorteil. Rezept: `packs/studio-firstframe.md`.
- 2026-08-23 · **Revision einer eigenen Messung am selben Tag — der erste Vergleich war
  unfair aufgesetzt.** GPT Image 2 lief ohne Setting-Referenz und ohne den
  Geometrie-Absatz, Nano Banana mit beidem; daraus wurde fälschlich „identitätsschwach"
  abgeleitet. Mit gleichen Bedingungen (5 Gesichter + Setting-Referenz + Geometrie-Absatz)
  fiel das Urteil um. **Lehre: beim A/B jede Eingabe angleichen, sonst misst man das Setup
  und nicht das Modell.**
- 2026-08-23 · **Lichtrichtung frame-bezogen angeben, nicht körperbezogen.** „front left"
  und „his right" wurden gespiegelt; „just off the LEFT edge of the frame" plus eine
  Ratio-Angabe („one and a half stops darker") saß auf Anhieb. Gilt vermutlich modellweit.
- 2026-08-23 · **`num_images` bis 4 in einem Aufruf** — bei Gesichtern die günstigste Art
  zu arbeiten, weil die Streuung groß ist und Auswahl mehr bringt als Iteration.
- 2026-08-23 · **Auf fal heißt der Edit-Endpunkt `fal-ai/gpt-image-2/edit`**, Referenzen
  gehen als `image_urls` (bis 16), `quality` ist dort bereits auf `high` vorbelegt, und
  `image_size` nimmt neben den Presets auch ein Objekt `{"width":…,"height":…}` —
  2560×1440 lief sauber durch.
- 2026-08-22 · `## Inputs` nachgetragen und `source_tier: official` gesetzt (Schema-Erweiterung
  des Skills). Keine Spec neu recherchiert — die Sektion zieht nur zusammen, was seit dem
  2026-07-13 aus den offiziellen Docs verifiziert im File stand.
- 2026-07-13 · Erstverifikation gegen offizielle Docs (Guide + API-Reference): `status: draft → active`. Größen und Transparenz unterscheiden gpt-image-2 vs. gpt-image-1 deutlich.
- 2026-07-13 · Die Vault-Landschaft (`vault/wiki/tools/gpt-image.md`, unbestätigt) nennt „Arena-stark, ~99% Texttreue, Reasoning vor dem Rendern" — das ist **nicht** von den offiziellen Docs gedeckt (die sind bei Text vorsichtiger). Als Erfahrungswert behandeln, nicht als Spec.
- 2026-07-13 · Zweitverifikation (Deep Research) gegen **Model-Page + Create-image/edit-Reference + Cookbook-Prompting-Guide** (neu zitiert). Ergänzt: Edit-Specs (16 Input-Bilder, `input_fidelity`-Reject, Masken-Regeln), Streaming-Status, und die offiziellen Prompt-Präferenzen. Report: `research/gpt-image-2-prompting-2026-07-13.md`.
- 2026-07-13 · **Größen-Korrektur:** 256²/512² gehören zu **dall-e-2**, NICHT zur gpt-image-1-Familie (die hat 1024²/1536×1024/1024×1536 + `auto`). Frühere File-Angabe korrigiert.
- 2026-07-13 · **Transparenz jetzt hart belegt:** der Image-Generation-Guide sagt explizit, gpt-image-2 lehnt `background: transparent` ab (vorher nur Vault-„unbestätigt"). Bisherige Aussage bestätigt.
- 2026-07-13 · **„Thinking-Mode" ist kein Modell-Parameter:** Model-Page listet kein Reasoning; das „Planen vor dem Rendern" kommt aus dem Responses-API-Muster (reasoning-Mainline-Modell ruft das `image_generation`-Tool). Community-„Thinking/Instant" = Produkt/UX → Erfahrungswert.
- 2026-08-18 · **Maske schützt nicht, sie steuert** (gemessen, yfood-Karte): bei `edit` mit
  `mask_url` wich der als „unangetastet" maskierte Bereich im Ergebnis um **~9–10 % mittlere
  Pixelabweichung** vom Input ab. gpt-image-2 rendert beim Edit das ganze Frame neu — die
  Maske lenkt nur, wo etwas Neues entstehen soll. **Konsequenz:** Outpainting/Erweitern taugt
  nicht, um ein Bild zu erhalten, das dem Kunden gefällt; dafür lieber mit weiter gefasstem
  Composition-Block neu rendern. Für Kompositing (Packshot → neue Szene) bleibt der Edit-Weg
  richtig, weil dort ohnehin alles neu belichtet wird.
- 2026-08-18 · **Preserve-Liste trägt Etiketten-Text** (yfood): mit expliziter Preserve-Liste
  („reproduce label artwork, wordmark, typography, layout … do not redraw, restyle, translate,
  re-letter") kamen `yfood®`, `THIS IS FOOD`, `AUSGEWOGENE TRINKMAHLZEIT` und die
  Geschmacksnamen wortgetreu durch. Zweiter Pflichtsatz bei freigestellten Packshots: den
  **eingebackenen Schlagschatten explizit verwerfen**, sonst klebt er unter schwebenden Objekten.
- 2026-08-18 · **„Subtle film grain" NICHT bei glatten Farbflächen anfordern** (gemessen, yfood):
  auf einem großen weichen Verlauf liest sich das angeforderte Korn als billiges Rauschen, nicht
  als Film. Messwert Hintergrund-Rauschen 1,48 → **0,59** allein durch Streichen der Grain-Zeile
  plus dem Satz „the backdrop is a perfectly smooth, continuous gradient — completely free of
  grain, noise, speckle, banding, dithering or any visible surface texture". Grain nur bei
  texturreichen Szenen, nie bei Studio-Sweeps.
- 2026-08-18 · **Dunkler Grund macht Rauschen sichtbar.** Rauschen relativ zur Helligkeit war bei
  einem fast schwarzen Hintergrund 15,9 %, bei nativ hell belichtetem Set 2,1 % — gleiches
  Modell, gleiche Auflösung. **Lieber hell rendern und im Layout abdunkeln** als dunkel rendern.
- 2026-08-18 · **Aufhellen in Post verstärkt das Korn.** Lift/Gamma auf ein abgesoffenes Bild hob
  das Rauschen von 1,48 auf 1,90 (soft) bzw. 2,25 (medium). Ein zu dunkles Ergebnis gehört neu
  gerendert (Exposure-Block im Prompt), nicht nachträglich gezogen.
- 2026-08-18 · **Outpainting kostet Auflösung.** Original verkleinert in eine größere Leinwand
  setzen und den Rand füllen lassen heißt: das Motiv geht durch einen Downscale und wird danach
  komplett neu gezeichnet. Für „mehr Rand" immer mit weiter gefasstem Composition-Block **neu
  rendern**, nie erweitern.
- 2026-08-18 · **Supersampling ist der stärkste Qualitäts-Hebel** (gemessen, yfood): in
  **3840×2160** rendern und per Lanczos auf 2048×1152 runterrechnen ergibt **29 % weniger
  Rauschen bei identischer Kantenschärfe** (0,46 gegen 0,65) verglichen mit nativem 2K-Render.
  Für finale Assets immer so. Achtung: Rausch-/Schärfe-Metriken sind **pro Pixel** — 4K und 2K
  erst nach dem Runterrechnen auf gleiche Kantenlänge vergleichen, sonst misst man Unsinn.
- 2026-08-18 · **EDIT ist sauberer und schärfer als T2I** (kontrollierter Test, identische Szene,
  einzige Variable = wie das Produkt reinkommt): t2i ohne Referenz Rauschen 0,69 / Kanten 96,8 —
  edit mit Packshots 0,58 / **121,7**. Rund 25 % schärfere Kanten, weil das Modell eine echte
  Fotografie einkomponiert statt eine zu erfinden. Der Edit-Weg ist also **kein** Qualitätsverlust,
  entgegen der Intuition.
- 2026-08-18 · **Referenzen nicht runterskalieren.** Voll (2500 px) gegen 1024 px war messtechnisch
  nicht unterscheidbar (0,60/119,4 gegen 0,58/121,7 — ein Roll je Variante trennt Zufall nicht von
  System), und hi-fi kostet ohnehin gleich viel. Also volle Auflösung schicken; frühere Empfehlung
  zum Runterskalieren war eine reine Kosten-Annahme ohne Nutzen.
- 2026-08-18 · **Hex-Werte inline funktionieren.** `hex #002B26` o. Ä. direkt im Prompt wird
  sauber getroffen. Dazu der Satz „all the colour lives in the light and the set, never as a
  flat filter over the picture" — ohne ihn kommt eine eingefärbte Aufnahme statt eines Sets
  in der Farbe.
- 2026-07-13 · **Texttreue:** offizielle Docs geben **keine** %-Garantie (technik-fokussiert: Quotes/ALL CAPS/Quality medium-high, schwierige Wörter buchstabieren, Ausschluss-Klausel gegen Auto-Text). „~95–99%" bleibt Erfahrungswert.

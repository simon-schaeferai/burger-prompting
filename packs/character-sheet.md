---
name: Character Sheet
aliases: [character sheet, charakter sheet, charaktersheet, model sheet, reference sheet, turnaround, figurenblatt, personen-referenzblatt]
kind: pack
goal: Aus Fotos einer realen Person einen Satz konsistenter Referenzansichten bauen, der als Charakter-Referenz für alle Folgegenerierungen dient.
models: [nano-banana, seedream, gpt-image]
tasks: [image-edit]
status: active
last_verified: 2026-08-23
source: intern — erprobte Fassung, abgeleitet aus models/nano-banana.md (Referenz-Rollen, semantische Negation, Preserve-Klausel)
---

# Character Sheet

## Wann

Wenn eine **reale Person** über viele spätere Bilder hinweg wiedererkennbar
bleiben soll. Das Sheet ist nicht das Deliverable — es ist die **Referenz**, die man ab
dann in jede Folgegenerierung reinreicht.

Nicht dafür: eine erfundene Figur (dann text-to-image ohne Referenzen), oder ein einzelnes
schönes Porträt (dann `frameworks/text-to-image.md`).

## Vorbereitung

**Referenzauswahl ist der größte Qualitätshebel — größer als jede Prompt-Formulierung.**
Nano Banana Pro nimmt **maximal 5 Charakter-Referenzen** (`models/nano-banana.md`), also
werden sie ausgewählt, nicht gesammelt.

Auswahlregeln, in dieser Reihenfolge:

0. **Zuerst die Kamera prüfen, dann alles andere.** Bei Handy-Referenzen: **Hauptkamera,
   niemals Frontkamera.** Die Selfie-Kamera liefert weniger Auflösung und glättet die Haut
   schon in der eigenen Bildpipeline — sie liefert also ein **bereits retuschiertes**
   Gesicht als Identitätsanker, und kein Prompt holt Poren zurück, die im Input fehlen.
   Am iPhone maschinell unterscheidbar über `LensModel` im EXIF (`back` gegen `front`)
   oder an der Auflösung. Diese Regel steht vor der Winkelabdeckung: eine Frontalansicht
   aus der Hauptkamera schlägt vier Winkel aus der Frontkamera.
1. **Winkelabdeckung vor Bildqualität** — innerhalb derselben Kamera. Fünf gute
   Frontalbilder sind schlechter als Frontal + 3/4 + Profil + Ganzkörper + Rücken. Jede
   Ansicht, die keine Referenz hat, wird vom Modell erfunden.
1b. **Gesichter nativ zuschneiden, nicht das ganze Bild schicken.** Wer ein
   Ganzkörperbild auf 2048 px herunterrechnet, gibt dem Modell ein 500-px-Gesicht. Ein
   enger Kopf-Schulter-Schnitt aus derselben Datei liefert bei gleicher Dateigröße ein
   dreimal größeres Gesicht.
2. **Neutrales, weiches Licht.** Harte Schlagschatten, Gegenlicht und farbige Beleuchtung
   schreiben falsche Hautwerte fest. Bewölkter Tag oder Fensterlicht schlägt Studioblitz.
3. **Neutrale Mimik, Mund zu.** Lachfotos verzerren Wangen, Augenpartie und Kieferlinie —
   das Modell hält die Verzerrung für die Gesichtsform.
4. **Lange Brennweite, keine Selfies aus Armlänge.** Weitwinkelnah vergrößert die Nase und
   verschmälert die Ohren. Wer nur Selfies hat, nimmt die mit dem größten Abstand.
5. **Aktuell und konsistent.** Alle Referenzen aus derselben Lebensphase — gleiche
   Haarlänge, gleicher Bartstand, gleiches Gewicht. Gemischte Jahrgänge erzeugen ein
   Durchschnittsgesicht, das niemandem gehört.
6. **Ein Outfit festlegen** und dessen Referenzen mitgeben, wenn das Sheet ein bestimmtes
   Outfit tragen soll.

**Reihenfolge zählt.** Die Rolle einer Referenz vergibt bei Nano Banana der Prompt-Text
über die Reihenfolge, nicht über einen Parameter (`models/nano-banana.md`, „Bildreihenfolge
= Ansprache im Prompt"). Referenzen deshalb in fester Ordnung anhängen: **Frontal → 3/4 →
Profil → Ganzkörper → Rücken/Detail**.

## Modelle

| Modell | Rolle | Grenze |
|---|---|---|
| **Nano Banana Pro** (`gemini-3-pro-image`) | **Primär.** 5 Charakter-Referenz-Slots — Maximum im Roster; Thinking immer an; bis 4K | Stilkonsistenz über Serien ist die dokumentierte Schwäche — deshalb ist das Sheet ja die Referenz |
| Seedream 5 Pro Edit | Alternative bei vielen Referenzen (bis 10) | **Hart bei 2048 px gedeckelt** → für ein Mehrfach-Panel-Sheet zu wenig Detailbudget. Nur für Einzelansichten. |
| GPT Image | Alternative, wenn das Sheet in Simons CI stehen soll | Weniger Kontrolle über exakte Panel-Geometrie |

Details je Modell: `../models/nano-banana.md`, `../models/seedream.md`, `../models/gpt-image.md`.

## Slots

| Slot | Bedeutung | Default |
|---|---|---|
| `{{OUTFIT}}` | Das Outfit in einem Satz, falls vorgegeben. Sonst leer lassen — dann übernimmt das Modell das Outfit aus den Referenzen. | `the same outfit as in the reference images` |
| `{{BACKGROUND}}` | Hintergrundfarbe des Sheets | `plain neutral white (#FFFFFF)` |
| `{{ANCHORS}}` | 1–2 Sätze mit den unverwechselbaren Merkmalen der Person (Brille, Bart, Muttermal, Haarlänge, Statur). Verstärkt den Identity-Lock spürbar. | leer |
| `{{HEAD_AR}}` | Aspect Ratio Kopf-Sheet | `1:1` (2×2-Raster) |
| `{{BODY_AR}}` | Aspect Ratio Body-Sheet | `16:9` (1×3-Reihe) |

## Prompt

Zwei Sheets, getrennt gerendert. **Der Split ist kein Stil, sondern Arithmetik:** sieben
Ansichten in einem Frame lassen pro Ganzkörperfigur zu wenig Pixel für das Gesicht übrig —
und genau die Gesichtsdetails sind der Zweck des Sheets.

### Sheet 1 · Kopf (4 Ansichten)

```
Create a professional character reference sheet of the exact person shown in the attached reference images. Every attached image shows the same single individual — treat them as one person and reproduce that person, not a lookalike.

Compose one sheet on a {{BACKGROUND}} background as a clean 2x2 grid of four equally sized panels that sit directly on one continuous background field. The sheet carries only the four portraits and nothing else. Each panel holds one head-and-shoulders portrait of the same person at identical scale, photographed from the same distance and the same camera height at eye level, cropped from just above the crown of the head down to the collarbone.

Top left panel: straight-on front view, face square to camera, eyes looking directly into the lens.
Top right panel: exact 90-degree left profile, the nose pointing to the left edge of the panel.
Bottom left panel: exact 90-degree right profile, the nose pointing to the right edge of the panel.
Bottom right panel: rear view of the head, the back of the skull toward the camera, showing the hairline at the nape and the silhouette of both ears.

Align the four heads so the eye line sits at the same height in every panel and the head fills the same proportion of every panel. Hold a neutral, relaxed expression in all four views: lips closed and at rest, jaw unclenched, brows relaxed, eyes open normally.

Reproduce the identity exactly as the references show it — bone structure, face width, jawline, chin shape, nose shape and width, brow ridge, eye spacing and eye shape, lip shape, ear shape and position, hairline and hair density. Match the reference face weight: the same cheek fullness, the same neck and jaw volume. Preserve the natural asymmetry of the face. Keep the skin exactly as the camera recorded it, with visible pores, natural texture, moles, freckles, scars, fine lines, uneven tone and stubble pattern intact. Keep the exact iris colour and iris pattern including the limbal ring, with natural corneal moisture and one soft catchlight in each eye. Keep hair colour, hair texture and the identical styling and parting in all four views. {{ANCHORS}}

Show the person at their true age and true proportions. This is a documentary likeness: accuracy over flattery.

Dress the person in {{OUTFIT}}, identical in all four views, with the same collar and neckline from every angle.

If none of the references shows the back of the head, derive that view from the visible hair length, density, colour, parting and hairline so it reads as the same person seen from behind.

Light the person with one large soft frontal source plus gentle fill from both sides, so the face is evenly and clearly lit while subtle three-dimensional modelling still shows on the nose, cheekbones and jaw. Neutral white balance, daylight colour temperature, an even background of uniform brightness. Shoot on a long lens at portrait distance, roughly 105mm equivalent, so facial proportions stay true and the perspective reads nearly flat across all panels. Sharp focus across the entire face in every panel, deep depth of field, high micro-detail, natural photographic grain, unretouched raw photographic quality.
```

**Parameter:** `fal-ai/nano-banana-pro` (`gemini-3-pro-image`) · `aspect_ratio "{{HEAD_AR}}"` ·
`image_size "4K"` · `mime_type "image/png"` · bis 5 Charakter-Referenzen in fester Reihenfolge.

### Sheet 2 · Ganzkörper (3 Ansichten)

```
Create a professional character reference sheet of the exact person shown in the attached reference images. Every attached image shows the same single individual — treat them as one person and reproduce that person, not a lookalike.

Compose one horizontal sheet on a {{BACKGROUND}} background as three equally sized panels side by side on one continuous background field. The sheet carries only the three figures and nothing else. Each panel shows the same person head to toe at identical scale, photographed from the same distance and from the same camera height at chest level.

Left panel: full body front view, facing camera, eyes to the lens.
Centre panel: full body exact 90-degree side view, the person facing the right edge of the panel.
Right panel: full body rear view, back to camera.

Hold the identical pose in all three panels: a relaxed A-pose, standing upright, weight evenly on both feet, feet shoulder-width apart, arms hanging about 20 degrees away from the torso, palms facing the thighs, fingers relaxed and separated, shoulders level and square, head upright and level. The three views read as one rotation of the same standing person.

Align the figures so the soles of the feet rest on one shared horizontal ground line and the top of the head reaches the same height in all three panels; the figure fills the same proportion of every panel.

Reproduce the real body exactly as the references show it — true height-to-width proportion, shoulder width, chest and waist volume, hip width, limb length and thickness, natural posture and stance, and a true head-to-body ratio. Keep the face fully recognisable and sharp at this distance, with the same bone structure, skin texture, hair colour, hair texture and styling as in the head references. Match the reference body weight. {{ANCHORS}}

Show the person at their true age, true build and true proportions. This is a documentary likeness: accuracy over flattery.

Dress the figure in {{OUTFIT}}, identical in all three panels — the same garments, colours, fit, fabric, collar, sleeve and hem length, the same shoes and the same accessories, with consistent seams, folds and construction details from every angle.

If none of the references shows the person from behind, derive the rear view of hair, garments and shoes from the visible construction so it reads as the same outfit on the same person seen from behind.

Light the figure with one large soft frontal source plus gentle fill from both sides, so the whole body is evenly and clearly lit from head to feet while subtle modelling still shows the form of the body and the drape of the fabric. Neutral white balance, an even background of uniform brightness. Shoot on a long lens at full-length distance, roughly 135mm equivalent, so body proportions stay true and the perspective reads nearly flat across all panels. Sharp focus from head to feet in every panel, deep depth of field, high micro-detail in skin and fabric, natural photographic grain, unretouched raw photographic quality.
```

**Parameter:** `fal-ai/nano-banana-pro` (`gemini-3-pro-image`) · `aspect_ratio "{{BODY_AR}}"` ·
`image_size "4K"` · `mime_type "image/png"` · dieselben Referenzen wie Sheet 1, plus die
Ganzkörper-Referenz zuerst.

### Varianten

- **Klassischer Streifen statt 2×2** beim Kopf-Sheet: `{{HEAD_AR}}` auf `21:9`, im Prompt
  „a clean 2x2 grid" durch „a single horizontal row" ersetzen und die vier Panel-Zeilen von
  „Top left / Top right / Bottom left / Bottom right" auf „Panel 1 … Panel 4" umstellen.
  Kostet Gesichtsauflösung, sieht als Blatt klassischer aus.
- **360°-Turnaround** statt drei Body-Ansichten: fünf Panels bei 0°, 45°, 90°, 135°, 180°,
  `{{BODY_AR}}` auf `21:9`. Mehr Winkelabdeckung für spätere Generierungen, weniger Pixel
  pro Figur.

## Don'ts

- **Keine Ästhetik-Adjektive im Prompt.** `photorealistic`, `cinematic`, `sharp micro
  detail`, `raw photographic quality` liegen im Modell direkt neben kommerzieller
  Beauty-Retusche — sie erzeugen genau den Plastik-Look, den sie verhindern sollen.
  Stattdessen die Unvollkommenheiten **einzeln benennen** (Hautglanz, ungleicher Hautton,
  offene Poren, verheilte Male, eingewachsene Haare, ungleich wachsender Bart) und das
  Bild als nüchternes Dokument rahmen.
- **Kein Negativ-Prompt.** Nano Banana kennt nur semantische Negation
  (`models/nano-banana.md`) — „no shadows" produziert Schatten. Deshalb steht im
  Prompt-Körper keine einzige Verneinung, sondern durchgehend die positive Fassung.
- **Nicht „flat, even, no shadows" fordern.** Schattenloses Licht löscht die
  Gesichtsmodellierung, die das Sheet abbilden soll. Weich und gerichtet, nicht flach.
- **Nicht alle sieben Ansichten in einen Frame.** Arithmetik, nicht Geschmack: die
  Ganzkörper-Gesichter fallen unter die Detailgrenze.
- **Kamera-Bodynamen ersetzen keine Optik-Angabe.** „Hasselblad X2D 100C" sagt nichts über
  Perspektive; die Brennweite tut es. Deshalb steht die Brennweite im Prompt, nicht der Body.
- **Den Identity-Lock nicht kürzen.** Der häufigste Failure-Mode ist Beautification —
  schmaleres Gesicht, glattere Haut, korrigierte Zähne, jüngeres Alter. Die Sätze zu
  Gesichtsgewicht, Hauttextur und wahrem Alter sind die Gegenwehr, nicht Deko.
- **Referenzen nicht mischen über Lebensphasen** — ergibt ein Durchschnittsgesicht.
- **Nicht bei Seedream rendern**, solange ein Mehrfach-Panel-Sheet gefragt ist: 2048 px
  Kantenlimit (`models/seedream.md`).

## Learnings
- 2026-08-31 · **Produktionsregeln der Higgsfield-Studio-Filme für Sheets (Hell Grind, Oneiric, Love Story;
  unbestätigt):** (1) **Kopfloser Ganzkörper:** Sheet = Gesichts-Close-up + Ganzkörper vorn **ohne Kopf** +
  Ganzkörper hinten — „on wide shots the model kept taking the face from the small full-body figure, where the
  face is tiny and blurry. Remove that head, and the model has only one face to take." (2) **Glaubwürdig statt
  schön:** aus mehreren Gesichts-Varianten „the most believable one, not the most beautiful one"; Augen
  prüfen — auch dunkle Augen brauchen ein Glanzlicht in der Pupille. (3) **Kein Kino-Look im Sheet:** grau,
  flaches Licht, echte Poren, **kein Grain, keine Kino-Optik** — „bake film grain and cinematic lenses into the
  sheet, and the character … stops reacting to new light"; der Look lebt in den Folge-Prompts, nicht im Sheet.
  (4) **Gesicht in zwei Pässen:** Close-up-Gesicht als Identitätsanker (immer im Close-up generiert), Looks
  separat; Zusammenbau im Editor, **das Original-Porträt läuft nie wieder durch ein Modell**, Änderungen
  (Jacke, Narbe, Blut) per Maske auf das Original. (5) **Hybrid für reale Personen:** Kostüm und Körper
  generiert, „then paste the person's real photo onto the portrait panel — that's what makes the faces read
  as the actual people instead of lookalikes." (6) Zustände = eigene Sheets (`@s_hero`, `@s_hero_wet`).
  Rohtexte `research/higgsfield-corpus-2026-08-31/pages/_higgsfield_studio_projects_*.txt`.
- 2026-08-31 · **Community-Praxis (Higgsfield-Breakdowns, unbestätigt): dasselbe Sheet-Prinzip für Locations
  und Props.** Location-Sheet: „two horizontal rows — top: straight-on frontal, left angled, right angled,
  reverse wide; bottom: three detailed close-ups", Stil und Licht der Referenz exakt halten; Prop-Sheet:
  „multiple orthographic views (front, side, back, top), exploded view", grauer Hintergrund. Team-Routine:
  Soul Cinema für den rohen Pass (Variantenbreite), GPT Image 2 für Edits und das saubere finale Sheet;
  Sheet als benanntes Element speichern, in Folge-Prompts per `@name` referenzieren. Für unser Pack heißt das:
  der Firstframe-Ansatz (ein Bild = Bildregie) und der Sheet-Ansatz (mehrere Ansichten = Identitäts-Lock
  über Shots) sind zwei Werkzeuge — Sheet, wenn die Figur über mehrere Einstellungen konsistent bleiben muss.
- 2026-08-31 · **Community-Alternative (Higgsfield „Character Sheet Prompt/Guide", Notion; unbestätigt):**
  Layout **zwei Reihen** — oben vier Ganzkörper (front · left profile · right profile · back), unten drei
  Porträts (front · left · right), „relaxed A-pose", „consistent head height across the full-body lineup and
  consistent facial scale across the portraits", Licht in allen Panels identisch, neutraler Hintergrund,
  „technical model turnaround" im Realismus-Stil der Referenz. Die Guide-Regeln für das **Basisbild**:
  Gesicht, Haare, Kleidung sichtbar; keine Sonnenbrille, keine harten Schatten im Gesicht, keine
  Weitwinkel-Selfies, möglichst kein Grade. Unser Pack bevorzugt Fünf-Gesichter + Statur; die 4+3-Variante
  ist der Kandidat, wenn ein Folge-Modell mehrere Profile als Referenz braucht.
  Rohtexte `research/higgsfield-corpus-2026-08-31/notion/character-sheet-*.txt`.
- 2026-08-31 · **Community-Erfahrungswert (Higgsfield „AI vs VFX", unbestätigt):** drei Sheet-Tricks für
  Folge-Referenzen — (1) **neutral grauer Hintergrund** statt Weiß (weniger Ausreißer, im Folge-Prompt
  „ignore the sheet's background"), (2) **Face-Lock**: das Kopf-Close-up zusätzlich als eigenes Referenzbild
  beschneiden, damit das Folge-Modell nur eine Gesichtsquelle hat, (3) **Size-Reference-Sheet**: ein
  Extra-Bild mit zwei Figuren zusammen (Top-Panel Seitenansicht, zwei Bottom-Panels), Skala in
  Menschenlängen ausgeschrieben.
- 2026-08-23 · **Der teuerste Fehler des ersten Laufs war die Kamera, nicht der Prompt.**
  Vier von fünf Kopf-Referenzen kamen aus der iPhone-**Frontkamera** (7 MP, in-camera
  geglättet), die Ganzkörper aus der **Hauptkamera** (24 MP). Ergebnis: „sieht glatt aus
  und nicht wie ich". Mit denselben Winkeln aus der Hauptkamera und nativ zugeschnittenen
  Gesichtern kippte das in einem Lauf. **Referenz-Diagnose kommt vor Prompt-Iteration.**
- 2026-08-23 · **Ein konkreter Geometrie-Absatz schlägt jeden Treue-Appell.** Details und
  Formulierung in `studio-firstframe.md`; gilt für Sheets genauso.
- 2026-08-23 · **Panel-Maßgleichheit braucht eine Zahl.** „gleiche Kopfhöhe" wurde ignoriert,
  „the head measures about 62 percent of the panel height" wurde eingehalten. Dasselbe beim
  Body-Sheet mit 88 Prozent und geteilter Grundlinie.
- 2026-08-23 · **Das Haarmuster braucht einen eigenen Invarianz-Satz** („the same number of
  rows, running the same way, in every panel"), sonst erfindet das Modell den Verlauf pro
  Panel neu. Danach war die Asymmetrie korrekt — geschwungene Partie links, gerade Reihen
  rechts, so wie es in echt ist.
- 2026-08-23 · **Erster Lauf gegen Nano Banana Pro: beide Sheets saßen im ersten Versuch.**
  Der Identity-Lock trägt — Porentextur, Bartkante am Wangenknochen, Ohrstecker,
  Unterarm-Tattoo und Handgelenkuhr kamen ungefragt mit, ohne Beautification am
  Gesichtsgewicht. Der Pack ist damit von doc-informiert auf erprobt hochgestuft.
- 2026-08-23 · **Vollständige Winkelabdeckung schlägt alles andere.** Mit einer echten
  Hinterkopf-Referenz wurde die Rückansicht — sonst der schwächste Panel eines Sheets —
  der stärkste. Der Ableitungs-Satz im Prompt blieb ungenutzt, und genau so soll es sein.
- 2026-08-23 · **Zwei Restfehler, die der Prompt noch nicht abfängt:** das Zopf-/Haarmuster
  ist zwischen den vier Kopf-Panels nicht exakt identisch (das Modell erfindet den Verlauf
  pro Panel neu), und die drei Ganzkörper-Figuren stehen nicht exakt maßgleich, obwohl der
  Prompt gemeinsame Grundlinie und gleiche Kopfhöhe verlangt. Nächster Versuch: Haarmuster
  als eigenen Satz mit Verlaufsbeschreibung, Maßgleichheit über eine Kopfhöhen-Angabe in
  Prozent der Panelhöhe.

- 2026-08-23 · Erstanlage. Auslöser: ein Sheet-Prompt mit vier klassischen Fehlern —
  sieben Ansichten in einem Frame, echte Negationen, „flat, no shadows" gegen
  „RAW, micro detail", und kein Identity-Lock gegen Beautification.
- 2026-08-23 · **Die Referenzauswahl schlägt die Prompt-Formulierung.** Bei fünf
  Charakter-Slots entscheidet die Winkelabdeckung, nicht die Bildqualität — jede nicht
  referenzierte Ansicht ist Erfindung.

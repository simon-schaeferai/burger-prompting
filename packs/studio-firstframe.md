---
name: Studio Firstframe
aliases: [firstframe, first frame, startframe, studio firstframe, talking head still, studio-standbild, mich ins studio setzen]
kind: pack
goal: Eine reale Person fotorealistisch in ein Studio-Setting setzen, als überzeugendes, echt wirkendes Standbild.
models: [gpt-image, nano-banana]
tasks: [image-edit]
status: active
last_verified: 2026-08-23
source: intern — erprobt; reproduzierbarer Beleg-Lauf im Repo unter generated/REZEPT_studio-firstframe/ (shipt nicht mit)
---

# Studio Firstframe

## Wann

Wenn eine reale Person in einem Setting sitzen soll, in dem sie nie war, und das Ergebnis
als **echt wirkendes Standbild** durchgehen muss. Das Bild muss nicht schön sein, es muss
**echt** sein — es soll als Kameraaufnahme durchgehen, nicht als gutes Porträt.

*(Ein vollständig ausgefüllter Beispiel-Lauf mit Referenzen und angenommenen Ergebnissen
liegt im privaten Autoren-Repo und ist nicht Teil dieses Skills — der Prompt-Körper unten
steht für sich.)*

## Vorbereitung

**Die Referenzarbeit entscheidet mehr als der Prompt.** Vier Schritte, in dieser Reihenfolge:

**1 · Kamera-Filter, vor allem anderen.** Bei Handy-Referenzen nur **Hauptkamera**.
Die Selfie-Kamera hat weniger Auflösung und glättet die Haut schon in der eigenen
Bildpipeline — sie liefert ein **bereits retuschiertes** Gesicht als Identitätsanker, und
kein Prompt holt Poren zurück, die im Input fehlen. Maschinell über EXIF `LensModel`
(`back` gegen `front`).

**2 · Fünf Slots, alle ins Gesicht.** Der Frame endet bei Brusthöhe, also bringt eine
Ganzkörper-Referenz fast nichts. Gemessen besser: **drei Frontale, eine Dreiviertel, ein
Profil** — neutrale Mimik, Mund zu, alles aus einer Session.

**3 · Gesichter nativ zuschneiden.** Ein ganzes Bild auf 2048 px gerechnet gibt ein
500-px-Gesicht; ein enger Kopf-Schulter-Schnitt aus derselben Datei bei gleicher
Dateigröße ein dreimal größeres. Erst schneiden, dann skalieren.

**4 · Eine Setting-Referenz als sechstes Bild.** Sie verbessert nicht nur den Raum,
sondern **auch die Ähnlichkeit** — ohne sie kommt zweimal reproduziert ein breiteres
Gesicht zurück.

**5 · Referenz-Kriterien sind merkmalsspezifisch, nicht seriell.** Die Hauptkamera-Regel
aus Schritt 1 gilt für **Hauttextur**. Für andere Merkmale kann eine andere Quelle besser
sein: für **Zahn-Geometrie** schlägt eine Frontkamera-Nahaufnahme das 24-MP-Torsobild,
weil der Mund dort ein Vielfaches der Bildfläche einnimmt. Pro Merkmal die beste Quelle
wählen, nicht pauschal eine Serie ausschließen.

**6 · Was in keiner Referenz sichtbar ist, wird erfunden — Zähne sind der blinde Fleck.**
Wer die Gesichts-Referenzen nach „Mund geschlossen, neutral" filtert (richtig für die
Gesichtsform), hat danach **null Information über die Zähne**. Das fällt am Standbild nicht
auf und am Video sofort. Zwei bis drei Mund-Nahaufnahmen dazulegen und die Zahnreihe
beschreiben. **Kapazität ist da: GPT Image 2 nimmt bis zu 16 Bilder** — Merkmals-Referenzen
kosten keinen Gesichts-Slot.

**7 · Fremde Marken einzeln ausschließen und ersetzen.** Der Satz „rebuild the room in that
spirit rather than copying its objects" senkt die Quote, reicht aber nicht: aus einer
Setting-Referenz mit YouTube-Play-Button im Regal kam der Play-Button in einem von zwei
Läufen mit. Ein markantes Objekt muss **benannt und positiv ersetzt** werden:

    Every award, plaque, logo and piece of branded merchandise from the room reference is
    left out — the shelf carries books, a small lamp and plants instead.

**Reihenfolge = Rollenvergabe.** Es gibt keinen API-Parameter für den Referenztyp; der
Prompt-Text vergibt sie über die Position. Reihenfolge ändern heißt Rollen ändern.

## Modelle

| Modell | Rolle | Befund |
|---|---|---|
| **GPT Image 2** (`quality: high`) | **Primär** | Überzeugendste Oberfläche im Roster: weich, moderat scharf, zurückhaltend gegradet, eigenes feines Rauschen. Braucht **keinen** Film-Look-Pass. |
| Nano Banana Pro | Zweitwahl | Etwas präzisere Geometrie, aber sehr hohe Kantenschärfe, die als generiert liest — dann Film-Look-Pass nötig. |

Beide brauchen **dieselben Eingaben**. Wer beim Vergleich eine weglässt, misst das Setup
und nicht das Modell (`../models/gpt-image.md`).

**`num_images: 3` und von Hand auswählen.** Die Streuung bei Gesichtern ist groß; drei
Varianten in einem Aufruf schlagen drei Prompt-Iterationen und kosten weniger. Im
erprobten Lauf waren **zwei von drei** Varianten verwendbar.

**Bei offener Suche breit fahren, nicht tief.** Mehrere Prompt-Varianten × `num_images: 3`
und danach auswählen bringt mehr als ein Prompt, der iterativ verbessert wird — die Streuung
des Modells ist größer als der Effekt der meisten Prompt-Änderungen. Erst wenn die Richtung
steht, lohnt das Feilen am Wortlaut.

## Slots

| Slot | Bedeutung |
|---|---|
| `{{HAUT}}` | Hautton, Glanzzonen, Poren, Linien, Male — als Beobachtung, nicht als Wertung |
| `{{BART}}` | Bartform **und wie ungleichmäßig er wächst** |
| `{{HAAR}}` | Frisur mit Verlauf; bei Flechtfrisuren die Musterführung |
| `{{AUGEN}}` | Farbe, Ring um die Iris, Feuchte, Asymmetrie der Lider |
| `{{GEOMETRIE}}` | **Kopfform in Maßverhältnissen.** Stärkster Einzelhebel — siehe unten |
| `{{OUTFIT}}` | Kleidung mit Stoffverhalten |
| `{{RAUM}}` | Der Raum in Prosa, auch wenn eine Setting-Referenz mitgeht |
| `{{REFERENZLICHT}}` | Unter welchem Licht die Referenzfotos entstanden sind |

## Prompt

Verbatim-Vorlage — die Slots unten einsetzen, den Körper sonst wörtlich übernehmen.

```
A frame grab from a video recording of the man in the attached reference photographs, sitting in his dark home studio. The first five images show his face from different angles. He is one specific real person — reproduce him, not someone who resembles him.

He sits centred, framed from mid-chest up, shoulders square to the camera, head upright, looking straight into the lens with a calm, ordinary expression, lips closed.

His face exactly as the references record it: {{HAUT}}

His beard {{BART}}

His hair {{HAAR}}

His eyes {{AUGEN}}

The shape of his head, precisely: {{GEOMETRIE}} Keep these proportions exactly — do not widen the face, do not broaden the jaw, do not enlarge the eyes. He is the age the references show him to be and he looks it.

He wears {{OUTFIT}}.

Behind him {{RAUM}}

The key light is a large soft source standing just off the LEFT edge of the frame, a little above his eye line and angled down about twenty degrees. The half of his face nearer the left edge of the frame is clearly the brighter half, and the shadow of his nose falls down and to the right across his cheek. The half nearer the right edge sits about one and a half stops darker but stays readable, never black. A narrow cool cyan edge from the tube on the right runs down the right side of his forehead, his cheekbone, his jaw and the outer braids, no wider than a finger. Small specular highlights sit on the tip of his nose, on the top of his forehead and on the upper curve of his cheekbones, and the shadow under his chin falls onto his collar.

His face is the brightest thing in the frame and it is correctly exposed — the skin sits in the upper middle of the tonal range, bright enough to read every feature, never dim or murky. The wall behind him sits about three stops below his face, but the framed prints, the shelf, the books and the lamps all stay clearly readable instead of sinking into black.

The image is not heavily colour-graded: the whites in the frame stay neutral and his skin keeps its natural warm brown rather than being pushed towards teal or orange. It is slightly soft rather than clinically sharp — properly focused on the eyes with a natural falloff, and without any digital edge sharpening or halo along the contours.

{{REFERENZLICHT}} None of that light belongs in this frame — only his face and his build carry over. The colour, direction and quality of the light here come from this room.

A black microphone on a dark boom arm reaches in from the lower left and sits in front of his chest, out of focus, its shadow just touching the sweater.

Recorded on a mirrorless camera with an 85mm lens at f/2, focus on his eyes, the background falling into soft round out-of-focus circles. Shot at ISO 1600, so a fine grain sits in the shadows and across the dark wall. This is a plain document of a man at his desk, not a polished portrait.

The sixth image is the room reference. Take its room, its objects and its lighting — but it is a polished, colour-graded video still, and its finish does not carry over. The surface of this image is the plain, grainy, slightly uneven document described above.
```

**Parameter:** `fal-ai/gpt-image-2/edit` · `image_size {"width":2560,"height":1440}` ·
`quality "high"` · `output_format "png"` · `num_images 3` · 5 Gesichts- + 1 Setting-Referenz.

### Die fünf tragenden Bausteine

| # | Baustein | Warum er drin ist |
|---|---|---|
| 1 | **Rahmung als Dokument** | erster und letzter Satz. Verhindert, dass das Modell ein Porträt baut |
| 2 | **Geometrie in Maßverhältnissen** | „länger als breit", „Kiefer schmaler als die Wangenknochen" + drei `do not`-Klauseln. Ohne das verbreitern alle Modelle das Gesicht |
| 3 | **Benannte Unvollkommenheiten** | Glanz, ungleicher Ton, Poren, verheilte Male, eingewachsene Haare, ungleich wachsender Bart, unterschiedlich hohe Lider |
| 4 | **Licht frame-bezogen mit Ratio** | körperbezogene Angaben werden gespiegelt. Dazu Belichtungs- und Lesbarkeitssatz gegen absaufenden Hintergrund |
| 5 | **Umbelichtung ausdrücklich** | sonst schleppt das Modell das Licht der Referenzfotos mit |

## Nachbearbeitung — nur bei Bedarf

> **Hinweis:** Das hier beschriebene `filmlook.py` ist **Autoren-Tooling und nicht Teil dieses
> Skills** — es wird nicht mitgeliefert. Der Abschnitt bleibt als *Rezept*: er sagt, welche vier
> Dinge ein Film-Look-Pass leisten muss (Halation, Schwarzhub, Tiefen-Entsättigung, Korn), falls
> du dir ein eigenes Skript baust oder ein anderes Werkzeug nutzt. Die Prompt-Erzeugung braucht es
> nicht.

Ein solcher Film-Look-Pass legt Halation, Schwarzhub, Tiefen-Entsättigung und Korn auf ein
Bild — die vier Dinge, die echte Kameras tun und Generatoren nicht.

**Kein Standardschritt, sondern ein Reparaturwerkzeug.** Bei GPT Image 2 stimmt die
Oberfläche nativ; ein zusätzlicher Korn-Pass legt eine zweite Rauschstruktur darüber und
macht das Bild schlechter. Anwenden bei zu sauberen Ausgaben (Nano Banana, Flux). Immer
erst roh ansehen und beide vergleichen.

Zwei Regeln für jeden Film-Look-Pass: **erst skalieren, dann körnen** (Korn auf einem 5K-Master
überlebt das Downscaling nicht), und **die Korndosis richtet sich nach der Gesichtsgröße
im Bild, nicht nach der Bildbreite.**

## Don'ts

- **Keine Ästhetik-Adjektive.** `photorealistic`, `cinematic`, `premium`, `micro-detail`,
  `raw photographic quality` liegen neben kommerzieller Beauty-Retusche und erzeugen genau
  den Plastik-Look, den sie verhindern sollen.
- **Nicht „match the face weight" schreiben** — zu abstrakt. Geometrie in Maßen.
- **Lichtrichtung nie körperbezogen** („front left", „his right") — wird gespiegelt.
- **Die Setting-Referenz nicht weglassen**, um Politur zu vermeiden — das kostet
  Ähnlichkeit. Stattdessen der Anti-Politur-Satz.
- **Frontkamera-Selfies nicht als Gesichts-Referenz.**
- **Film-Look-Pass nicht blind fahren.**
- **Hände aus dem Frame halten**, solange nichts dagegen spricht.

## Learnings
- 2026-08-26 · **Die Fünf-Gesichter-Regel gilt für Text-zu-Person, nicht für Frame-Edits.**
  Wird ein vorhandenes Standbild bearbeitet (Lamborghini-Lauf), ist der Frame allein die
  bessere Referenz — jede weitere bringt eigenes Licht und eigene Politur mit (4/4 Treffer
  ohne Gesichts-Serie gegen Render-Look mit ihr). Details: `models/gpt-image.md` Learnings.
- 2026-08-24 · **Ich hatte zehn Referenz-Slots verschenkt.** GPT Image 2 nimmt 16 Bilder,
  ich habe konsequent 6 geschickt, weil ich das 5-Charakter-Limit von Nano Banana Pro
  gedanklich mitgeschleppt hatte. **Limits gelten pro Modell, nicht pro Aufgabe** — beim
  Modellwechsel die Kapazität neu prüfen.
- 2026-08-24 · **Eine eigene Auswahlregel kann für ein anderes Merkmal falsch sein.** Die
  Frontkamera-Sperre war als Hauttextur-Regel richtig und als allgemeine Regel falsch;
  ausgerechnet die ausgeschlossene Serie enthielt das beste Zahn-Material. **Beim Aussortieren
  notieren, WOFÜR aussortiert wurde.**

- 2026-08-23 · **Der Kunde wählte die ROHE Fassung.** Ich hatte den Film-Look-Pass als
  Pflichtschritt deklariert; ausgewählt wurde das unbearbeitete Bild. GPT Image 2 bringt
  die Oberfläche mit, und ein zweiter Korn-Layer darüber verschlechtert sie. **Lehre: eine
  selbst gebaute Verbesserung erst gegen das Original zeigen, statt sie zum Standard zu
  erklären.**
- 2026-08-23 · **Zwei von drei Varianten aus einem Aufruf wurden angenommen.** Das ist der
  Beleg, dass die Rezeptur trägt statt zu treffen. `num_images: 3` ist deshalb Teil des
  Rezepts, nicht Bequemlichkeit.
- 2026-08-23 · **Ähnlichkeit und Echtheit sind zwei Urteile — der Kunde wählt nach
  Echtheit.** Mein Ranking nach Ähnlichkeit setzte Nano Banana vorn, gewählt wurde GPT
  Image 2 wegen der weicheren Oberfläche. Beim Vorlegen beide Achsen getrennt benennen.
- 2026-08-23 · **Ein A/B ist wertlos, wenn die Eingaben ungleich sind.** Der erste
  GPT-Image-2-Lauf hatte weder Setting-Referenz noch Geometrie-Absatz. Mit gleichen
  Bedingungen kippte das Urteil.
- 2026-08-23 · **Der Geometrie-Absatz ist der stärkste Einzelhebel gegen Identitätsdrift.**
  Alle Modelle ziehen ein Gesicht Richtung ihres generischen Durchschnitts, also breiter
  und runder.
- 2026-08-23 · **Die Setting-Referenz verbessert die Ähnlichkeit, nicht nur den Raum.**
  Zweimal reproduziert, gegenintuitiv.
- 2026-08-23 · **Fünf Gesichter schlagen vier Gesichter plus Statur**, wenn der Frame bei
  Brusthöhe endet.
- 2026-08-24 · **Frame-bezogenes Licht trägt auch gegen die Gewohnheit.** In einem Setup mit
  Key von RECHTS (sichtbare Softbox am rechten Bildrand) saß die Richtung auf Anhieb, obwohl
  alle vorherigen Läufe links gekeyt waren. Die Regel ist damit nicht nur eine
  Spiegelungs-Vermeidung, sondern echte Steuerung.
- 2026-08-24 · **Je heller und flacher das Licht, desto stärker driftet das Gesicht — und
  desto glatter wird die Haut.** Gilt für die **Ähnlichkeit**: das helle Setup mit niedrigem
  Kontrast hatte messbar die schwächste Geometrie und die glatteste Haut, die dunklen Setups
  mit gerichtetem Key die besten. Mechanismus: gerichtetes Licht liefert
  Schattierungs-Hinweise, die Knochenstruktur tragen.
  **⚠️ Aber: daraus folgt NICHT, dass es echter wirkt — siehe nächster Eintrag.**
- 2026-08-24 · **Hypothese widerlegt, und zwar von der Sorte, die man ernst nehmen muss.**
  Ich hatte das helle Home-Office-Setup als schwächstes vorhergesagt, weil dort die
  Ähnlichkeit am schwächsten war. **Gewählt wurde genau dieses Setup** — als das echteste.
  Damit ist belegt: **Echtheit und Ähnlichkeit sind nicht nur zwei Urteile, sie können
  gegenläufig sein.**
- 2026-08-24 · **Woraus Echtheit tatsächlich entsteht — vier Faktoren, keiner davon im
  Gesicht:**
  1. **Der Raum ist ein Arbeitszimmer, kein Set.** Bürostuhl, Whiteboard, Kabel am Boden,
     nichts für die Kamera arrangiert.
  2. **Die Technik ist sichtbar.** Softbox im Bild, Mikroarm quer durch den Rand,
     Stativbein. Sichtbarer Apparat sagt Dokument.
  3. **Der Hintergrund ist lesbar.** 50 mm bei f/2.8 statt 85 mm bei f/2 — großer
     Bokeh-Hintergrund ist die Signatur des KI-Porträts.
  4. **Tageslicht, niedriger Kontrast, kein Grade.** Gerichtetes Warmlicht mit dunklen
     Rändern liest als gebaut.
  **Regel: für maximale Ähnlichkeit gerichtetes Licht — für maximale Echtheit einen
  gewöhnlichen Raum mit sichtbarem Apparat. Wer beides will, muss sich entscheiden, welches
  Urteil zählt.**
- 2026-08-24 · **Jeder Echtheits-Regler hat ein OPTIMUM, keine Richtung — und ich habe
  zweimal darüber hinaus gedreht.** Erst die Filmtechnik (Mikroarm am Rand hilft,
  bildbeherrschende Softbox schadet), dann die Benutzungsspuren (Tastatur und Notizbuch
  helfen, herumfliegende Tassen schaden). Beide Male hatte ich einen bestätigten Befund
  genommen und ihn maximiert, bis er kippte. **Arbeitsregel: wenn ein Hebel bestätigt ist,
  ist der nächste Schritt seine Obergrenze zu finden — nicht ihn zu erhöhen.**
- 2026-08-24 · **Benutzungsspuren sind nicht Unordnung.** Ein aufgeräumter Raum mit einem
  einzigen bewohnten Detail — Tastatur an der Tischkante ausgerichtet, ein geschlossenes
  Notizbuch daneben, sonst nichts — liest echter als ein Raum voller Kram. Verstreute
  Gegenstände lesen als **arrangierte** Unordnung, also wieder als Set. Der Satz, der
  funktioniert, ist positiv formuliert: „the room is lived in but kept in order, the way
  someone keeps a room they work in every day."
- 2026-08-24 · **Anweisungen stapeln sich unbemerkt in langen Prompts.** Die Unordnung stand
  an drei Stellen gleichzeitig: in der Anti-Marken-Zeile („papers, a mug, cables, a
  notebook"), im Schreibtisch-Satz („the ordinary clutter of a room that gets used") und in
  jedem Raum-Block einzeln. Keine der drei war für sich falsch, die Summe war es. **Bei über
  1000 Wörtern vor jeder Ergänzung prüfen, ob dieselbe Wirkung schon woanders im Prompt
  steht.** Nebenbei: eine Ausschluss-Zeile darf nichts ersetzen — „nothing replaces it, that
  part of the shelf simply stays empty" statt einer Ersatzliste.
- 2026-08-24 · **Nicht das Studio gewinnt, sondern das Register.** Gewählt wurde das helle
  Home-Office — aber übertragbar ist nicht der Raum, sondern die Erzählweise: lesbarer
  Hintergrund (35–50 mm statt 85 mm), Benutzungsspuren im Bild, Mikro am Rand, korrekt
  belichtetes Gesicht, kein Grade, leicht schräge Schultern. Dieselbe dunkle Palette in
  diesem Register gerendert ist etwas anderes als dieselbe Palette cineastisch gerendert.
  **Wer den Gewinner „Studio 3" nennt, kann ihn nicht übertragen; wer ihn „gewöhnliches
  Register" nennt, schon.**
- 2026-08-24 · **Der Treiber sind Benutzungsspuren, nicht Filmtechnik.** Der Gegentest zeigte:
  ein Mikroarm am Rand hilft, eine bildbeherrschende Softbox schadet (es wird ein Set *über*
  das Filmen), und ganz ohne Technik verliert der Raum Spezifität. Was zieht, sind Tastatur,
  Tasse, Kabel, offenes Notizbuch, aufgelegter Unterarm — Belege, dass hier gearbeitet wird.
  Filmgerät ist nur einer dieser Belege und der am leichtesten überdosierte.
- 2026-08-24 · **Die weitere Rahmung schlägt die enge.** 35 mm bei f/4 mit Schreibtischkante
  im Bild und aufgelegtem Arm wurde zweimal von drei Plätzen gewählt. Man sieht, **wo** er
  sitzt, nicht nur **dass** er sitzt.
- 2026-08-24 · **Streuung innerhalb einer Prompt-Variante ist kleiner als zwischen Varianten**
  — bei Räumen. Bei Gesichtern war es umgekehrt. Heißt: solange die Richtung offen ist, mehr
  Prompt-Ansätze; sobald sie steht, mehr Bilder pro Ansatz.
- 2026-08-24 · **Derselbe Kategorienfehler zum zweiten Mal begangen.** Ich hatte nach dem
  GPT-Image-2-Vergleich selbst notiert, dass Ähnlichkeit und Echtheit getrennt zu bewerten
  sind — und habe dann wieder nach Ähnlichkeit sortiert und Echtheit daraus vorhergesagt.
  **Lehre für die Arbeitsweise: eine notierte Lehre wirkt nicht, solange sie nicht die
  Reihenfolge der eigenen Bewertung ändert.** Beim Vorlegen zuerst nach Echtheit sortieren,
  dann die Ähnlichkeit als zweite Spalte danebenstellen.
- 2026-08-24 · **Ein weißes Shirt kostet im dunklen Studio etwas Ähnlichkeit.** Isolierter
  Vergleich bei identischem Prompt und Raum: mit schwarzem Shirt saß das Gesicht näher an
  der Referenz. Ein Datenpunkt, kein Beweis — plausibler Mechanismus ist die große helle
  Fläche neben dem Gesicht, die den Gesamtkontrast senkt, also derselbe Effekt wie beim
  hellen Setup.
- 2026-08-24 · **Der Anti-Kopier-Satz reicht für markante Objekte nicht** — siehe
  Vorbereitung Schritt 5.

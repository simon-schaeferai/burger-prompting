# Creative-Brief-Schema

Die model-agnostische Zwischenschicht. Jede User-Anfrage wird zuerst hierin
normalisiert — erst danach für ein konkretes Model gerendert. So lässt sich ein
Konzept über mehrere Models hinweg wiederverwenden ("ein Brief, mehrere Prompts").

Das Brief ist intern: es wird nicht an den User ausgegeben (dafür ist der
output-contract da), sondern dient als sauberer Input fürs Rendering.

## Felder

Die Felder zerfallen in **zwei Klassen mit gegensätzlicher Regel**:

**Fakten-Felder — nie erfinden.** Was hier nicht aus der Anfrage hervorgeht, bleibt leer
oder wird erfragt. **Erste Quelle ist das aktive Projekt** (`projects/ACTIVE.md` →
`projects/<slug>.md`): Palette, Zielformate, Assets und Verbote stehen dort und sind
gesetzt. Erst was das Projekt offen lässt, wird erfragt. *(Standalone/ohne Projekt-Ordner:
gibt es keinen `projects/`, fragen, welche Marken-/Format-Vorgaben gelten — nie raten.)*

| Feld | Bedeutung | Pflicht |
|---|---|---|
| `subject` | Das Kernmotiv — wer/was ist zu sehen. | ja |
| `intent` | Zweck/Kontext (Ad, Hero-Shot, UGC, Concept …). | ja |
| `constraints` | Aspect-Ratio, Auflösung, must-include / must-avoid. | wenn genannt |
| `references` | Input-Bild (image-edit, enhance, inpaint, outpaint). | task |

**Handwerks-Felder — Vorschlagspflicht.** Diese Felder bleiben **nie** leer. Sagt der User
nichts dazu, kommt ein begründeter Vorschlag aus der Tag-Bibliothek.

| Feld | Bedeutung | Quelle des Vorschlags |
|---|---|---|
| `composition` | Framing, Kamerawinkel, Shot-Size. | `modifiers/image/shots`, `framing`, `angles` |
| `lighting` | Lichtstimmung, Lichtführung. | `modifiers/image/lighting` |
| `style` | Ästhetik/Look. | `cinematic-styles`, `commercial-styles`, `film-stocks`, `lenses` |
| `setting` | Umgebung, Ort, Hintergrund. | aus `subject` + `intent` ableiten |
| `mood` | Ton/Emotion. | `modifiers/image/emotions` |
| `color` | Farbwelt/Palette. | Markenfarben, sonst `grading` |

## Fill-in

```yaml
subject:
intent:
setting:
style:
composition:
lighting:
mood:
color:
constraints:
  aspect_ratio:
  must_include:
  must_avoid:
references:      # task-abhängig
```

## Regeln

**Erfinden ist bei Fakten verboten und beim Handwerk Pflicht.**

- **Fakten-Felder:** nur füllen, was aus der Anfrage hervorgeht oder eine sichere Ableitung
  ist. Nichts erfinden, um Felder zu füllen — leer ist erlaubt und ehrlich.
- **Handwerks-Felder: Vorschlagspflicht.** Kein Feld bleibt leer, weil der User nichts dazu
  gesagt hat. Ein Kameramann lässt „Licht" nicht offen — er schlägt ein Setup vor und sagt
  warum. Format des Vorschlags:

      lighting: LIGHT-RIM  (Vorschlag: trennt das Produkt vom dunklen Grund)

  Also **Tag-ID** plus **eine Zeile Begründung**, sichtbar als Vorschlag markiert.
- **Was der User sagt, gewinnt.** Hat er ein Feld selbst bestimmt, wird dort **nicht**
  vorgeschlagen. Ein einmal überstimmter Vorschlag bleibt für die Session überstimmt.
- **Tag-Text verbatim.** Vorgeschlagen wird die Tag-ID; beim Rendern kommt der Text
  wörtlich aus `modifiers/` (siehe die jeweilige `USAGE.md`, Sweet Spot 3–5 Tags).
- **Nur was das Model kann.** Ein Vorschlag darf nichts enthalten, was die `## Inputs`-
  Sektion des Model-Files ausschließt.
- Getroffene Annahmen und Vorschläge später im output-contract unter "Annahmen" ausweisen.
- Welche Felder ein Model tatsächlich nutzt, entscheidet das Model-File beim
  Rendering; das Brief hält alles neutral bereit.

## Verhältnis zum Director's Pass

Das Brief ist das **Ergebnis** des Director's Pass, nicht sein Ersatz. Der Pass
(`director-pass.md`) baut zwei bis drei Treatments und lässt wählen; die Felder des
gewählten Treatments landen dann als Handwerks-Felder im Brief. Wird der Pass übersprungen
(User nennt Modell und Treatment selbst), gilt die Vorschlagspflicht trotzdem für die
Felder, die er offen gelassen hat.

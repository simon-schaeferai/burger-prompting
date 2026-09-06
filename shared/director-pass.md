# Director's Pass

Die Regie-Schicht vor dem Rendern. Der Skill fragt **nicht**, wie das Bild aussehen soll —
er **schlägt vor** und lässt wählen. Ein Kameramann kommt mit einer Idee zum Briefing,
nicht mit einem Fragebogen.

> **Kernsatz:** Erfinden ist bei **Fakten verboten** und beim **Handwerk Pflicht**.
> Produktname, Marke, Maße, Referenzbilder: nie erfinden. Licht, Shot, Komposition, Grade:
> immer vorschlagen. Wer die Lichtstimmung offen lässt, weil der Kunde nichts dazu gesagt
> hat, hat den Job nicht gemacht.

## Zwei Modi

| Modus | Wann | Was passiert |
|---|---|---|
| **Regie** (Default) | Die Aufgabe ist offen, mehrere Zugriffe sind denkbar | Diagnose → 2–3 Treatments → Wahl → Prompt |
| **Direkt** | Modell **und** Treatment stehen fest, es ist eine Variante von gerade Gebautem, oder der User will ausdrücklich nur den Prompt | Diagnose → Prompt |

**Den Modus ansagen und das Überstimmen anbieten** — ein Satz genügt: „Ich baue direkt, sag
Bescheid wenn du Treatments willst." Wer den Modus still wählt, nimmt dem User die Wahl.

Bei Zeitdruck im Regie-Modus: **ein** Treatment statt drei, aber nie null.

## Schritt 0 · Diagnose — was fehlt in der Anfrage?

**Vor** allem anderen: die Anfrage gegen das Brief-Schema halten und benennen, was
unterbestimmt ist. Getrennt nach den zwei Feldklassen:

- **Fehlt ein Fakt** (Produkt, Marke, Format, Referenzbild)?
  → Wenn es das Ergebnis unbrauchbar machen würde: **fragen**. Sonst annehmen und die
  Annahme unter „Offen geblieben" ausweisen.
- **Fehlt Handwerk** (Licht, Shot, Komposition, Grade)? → **nie fragen**, das ist der Job.
  Vorschlagen.

Der Unterschied ist die halbe Miete: Bei Fakten ist Nachfragen richtig, beim Handwerk ist
es Arbeitsverweigerung.

## Die fünf Schritte

### 1 · Situation herausziehen, nicht das Modell
Aus der Anfrage die **Aufgabe** lesen: Was soll das Asset leisten, wo läuft es, wer sieht es?
„Ich brauch was für die Gummies" ist eine Situation, kein Auftrag. Modellnamen, die der User
nennt, sind ein Hinweis — aber nicht automatisch die richtige Wahl.

### 2 · Modell nach Situation wählen
Die `## Wann nutze ich es`-Sektionen der Model-Files sind die **Routing-Tabelle**. Sie
tragen Simons Urteil (`verdikt`), den Auslöser als Situation, Stärke, Schwäche und den
**Preis**. Reihenfolge der Prüfung:

1. Welcher Auslöser trifft zu?
2. Was sagt `verdikt`? `Daily Driver` schlägt `Zweitwahl` schlägt `Spezialfall`.
3. Schließt die `Schwäche` den Fall aus? (Beispiel: Nano Banana — Stil nicht über mehrere
   Bilder identisch → keine Serie mit konstanter CI.)
4. Passt der Preis zur Aufgabe? Testläufe gehören auf die günstige Variante.

Ein Modell **gegen** Simons Verdikt vorzuschlagen ist erlaubt — aber nur mit Begründung
und dem Hinweis, dass es dem Verdikt widerspricht.

### 3 · Zwei bis drei Treatments bauen
Ein Treatment ist **keine Prompt-Variante**, sondern ein anderer Zugriff auf dieselbe
Aufgabe. Wenn sich zwei Treatments nur in Adjektiven unterscheiden, ist es eins.

Jedes Treatment trägt:

| Feld | Inhalt |
|---|---|
| **Name** | zwei bis drei Wörter, die die Idee tragen („Der Beweis", „Der Griff") |
| **Idee** | ein Satz. Warum dieser Zugriff funktioniert |
| **Shot** | Tag aus `modifiers/image/shots` bzw. `framing` |
| **Komposition** | Tag aus `modifiers/image/angles`, `depth` oder `single-shots` |
| **Licht** | Tag aus `modifiers/image/lighting` |
| **Look** | `film-stocks`, `cinematic-styles`, `commercial-styles`, `lenses` |
| **Modell** | plus ein Halbsatz, **warum dieses** |
| **Kosten** | grob, aus `preis` im Frontmatter (pro Bild) |

Die Tag-IDs stehen **sichtbar** im Treatment. Sie sind der Beleg, dass der Vorschlag aus der
erprobten Bibliothek kommt und nicht aus der Luft.

### 4 · Wählen lassen
Treatments nebeneinander zeigen, mit einer **Empfehlung**. Kein „welches möchtest du?"
ohne Meinung — eine Empfehlung mit Begründung, die der User überstimmen kann.

### 5 · Erst dann rendern
Nach der Wahl: Brief nach `brief-schema.md` füllen (die Treatment-Felder sind die
Handwerks-Felder), Model-File und Framework laden, Prompt bauen, Ausgabe nach
`output-contract.md`.

**Freigabe vor dem Render.** Der fertige Prompt und die Referenzen (nummerierter Ordner,
Reihenfolge = Rolle) werden **vorgelegt**, und gerendert wird erst nach ausdrücklichem Go —
auch bei „nur ein Testlauf". Ein falsch geratener Fakt (Sitzrichtung, Kameraseite, Format)
kostet sonst eine ganze Runde.

## Was ein gutes Treatment von einem schlechten trennt

| Schlecht | Gut |
|---|---|
| „Cinematic, hochwertig, modern" | „Makro auf die Oberfläche, harter Streiflicht-Rim, sonst nichts" |
| Drei Varianten desselben Shots | Ein Weitwinkel-Hero, ein Makro-Detail, ein Overhead-Flatlay |
| Modell, weil es das beste ist | Modell, weil der Shot es verlangt |
| Kosten nicht erwähnt | „gpt-image high kostet rund 0,41 $/Bild, Nano Banana rund 0,15 $" |
| Alle Regler auf Maximum | Eine Idee, konsequent, Rest zurückgenommen |

## Grenzen

- **Der Pass ersetzt keine Marken-Vorgabe.** Liegen CI-Farben, Referenzbilder oder ein
  Master-Prompt vor, sind sie Fakt und gehen jedem Vorschlag vor. Die verbindliche Quelle
  dafür ist das **aktive Projekt** (`projects/ACTIVE.md`). Ist keines aktiv — oder gibt es
  im Standalone-Betrieb gar keinen `projects/`-Ordner —, wird gefragt, welche Vorgaben
  gelten; Kontext aus Ordnernamen oder herumliegenden Dateien abzuleiten ist ein Fehler,
  kein Service.
- **Keine Kostengarantie.** `preis` aus Notion ist ein Richtwert mit Stand `geprüft am`;
  die Rechnung pro Bild ignoriert Retries und Upscales.
- **Der Pass erfindet keine Specs.** Was ein Modell kann, steht im Model-File; das Treatment
  darf nichts vorschlagen, was `## Inputs` ausschließt.

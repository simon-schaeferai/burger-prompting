# Output-Contract

Einheitliches Rückgabeformat für jeden generierten Prompt. Immer so ausgeben —
egal welches Model, welcher Task.

## Format

Genau diese Struktur (der Prompt-Block ist ein echter Code-Block zum Kopieren):

    **Model:** <Name> · **Task:** <task> · **Framework:** <framework | inline>

    ```
    <der fertige, copy-paste-fähige Prompt>
    ```

    **Parameter:** <nur was das Model braucht: aspect ratio, duration,
    resolution, seed, negative-prompt-Feld … — sonst weglassen>

    **Warum so:** <2–4 Zeilen. Welche Handwerks-Entscheidungen getroffen wurden
    (mit Tag-ID) und welche modelspezifische Regel den Prompt geformt hat, mit
    Verweis aufs Model-File. Kein Lob, keine Wiederholung des Prompts.>

    **Offen geblieben:** <was an der ANFRAGE unterbestimmt war und wie ich es
    aufgelöst habe — sonst "nichts">

    **Varianten:** <optional 1–2 alternative Prompt-Fassungen, wenn sinnvoll>

## Regeln

- Der Prompt selbst steht allein in einem Code-Block, damit er 1:1 kopierbar ist.
  Keine Erklärungen im Prompt-Block.
- **Kein Denk-Gerüst im Prompt.** Framework-Schicht-Labels (z. B. „Medium:", „Subjekt:",
  „Subject:", „Composition:") sind die interne Checkliste, NICHT der Output. Der Prompt ist
  fließende, natürliche Sprache; die Schichten sind eingewebt, nicht als Feldnamen sichtbar.
- **Referenzbilder werden im Prompt als `@<bildname>` benannt** (z. B. „das Produkt aus
  `@flasche.png`, originalgetreu"), nie unbenannt oder nur „Bild 1". Jede mitgegebene Referenz
  bekommt ihren `@`-Tag mit ihrer Rolle; ohne mitgegebene Referenz keinen erfinden.
- Modelspezifische Negativ-Prompts / "avoid"-Felder gehören zu **Parameter**,
  nicht in den Haupt-Prompt — außer das Model-File verlangt sie inline.
- Kurz halten. Kein Fließtext um den Prompt "herum" — **außer im Warum-Block**,
  und der bleibt bei 2–4 Zeilen.
- **Der Warum-Block ist Pflicht, nicht Kür.** Ein Prompt ohne Begründung macht den
  User abhängig statt besser. Er nennt konkret: welche Tags gewählt wurden und
  warum, und welche Regel aus dem Model-File den Ausschlag gab — zum Beispiel
  „gpt-image-2 kennt keinen Negative-Prompt, deshalb ‚kein Text' positiv als glatte,
  unbeschriftete Fläche formuliert (models/gpt-image.md)".
- **„Offen geblieben" ist der Diagnose-Schritt**, nicht dasselbe wie eine Annahme:
  es benennt die Lücke in der Anfrage, nicht nur die eigene Ableitung. Wer nichts
  zu Format und Länge gesagt hat, soll das schwarz auf weiß sehen.
- Greift ein Fehlerpfad (siehe SKILL.md), statt dieses Formats die entsprechende
  Rückfrage/Warnung ausgeben — nichts generieren.

# Conventions

Bindende Regeln für alle Dateien dieses Skills. Bei Widerspruch zwischen einer
allgemeinen Konvention und einem konkreten Model-File gewinnt das Model-File.

> **Hinweis zu den Prüfer-Skripten:** Die in dieser Datei erwähnten `scripts/check-*.sh`
> (`check-models.sh`, `check-sync.sh`, `check-projects.sh`, `check-structure.sh`,
> `build-index.sh`) sind **Autoren-Tooling aus dem Entwicklungs-Repo und nicht Teil des
> ausgelieferten Skills**. Sie beschreiben, *welche Regel* jeweils gilt — der Skill funktioniert
> ohne sie. Mitgeliefert ist nur `scripts/check-staleness.sh` (Staleness-Check).

## Model-File-Frontmatter (Contract)

Jedes `models/<model>.md` beginnt mit exakt diesem Frontmatter:

```yaml
---
name:          # Anzeigename, z. B. "GPT Image"
aliases: []    # Routing-Strings, lowercase, wie der User das Model nennt
vendor:        # OpenAI, ByteDance, BFL, Magnific …
type:          # image   (Modalität des Outputs)
version:       # optional: gepinnte Modell-Version, z. B. gpt-image-2 (Anbieter ≠ Modell)
tasks: []      # unterstützte Tasks: text-to-image, image-edit, enhance, inpaint, outpaint
               # (Operation → Task: shared/operations.md)
frameworks:    # Task→Framework-Mapping ODER das Wort "none"
status:        # active | experimental | deprecated | draft
last_verified: # YYYY-MM-DD der letzten Prüfung gegen offizielle Docs
source:        # URL zu den offiziellen Docs
source_tier:   # official | platform  (Pflicht ab status != draft, siehe unten)
prompt_guide:  # URL des Anbieter-Prompt-Guides (Pflicht bei active/experimental)
               # Ausnahmen: "blockiert" (Captcha/Login) oder "keine" (Anbieter hat keinen)
               # — beide verlangen einen <!-- unverified --> Marker im Body

# Kopplung an die Notion-Datenbank KI-MODELLE (siehe eigener Abschnitt):
verdikt:            # Daily Driver | Zweitwahl | Spezialfall | Nur wenn nötig | Ungetestet
wann_nutze_ich_es:  # der Auslöser als Situation, WÖRTLICH aus Notion
endpunkt:           # fal-/API-ID aus Notion, oder — wenn Notion keine führt
preis:              # Klartext aus Notion, oder — wenn Notion keinen führt
notion_rows: []     # URLs der Notion-Zeilen, die dieses File abdeckt
---
```

`frameworks` als Mapping, Task-Key → Framework-Dateiname (ohne Pfad/Endung):

```yaml
frameworks:
  text-to-image: text-to-image
  image-edit: image-edit
```

Oder, wenn das Model komplett inline beschrieben ist:

```yaml
frameworks: none
```

Nur Tasks aufführen, die das Model wirklich kann. Ein Task in `tasks:` ohne
Eintrag in `frameworks:` bedeutet: inline im Model-File beschrieben.

## Body-Sektionen jedes Model-Files

In dieser Reihenfolge:

1. `## Routing` — Task → Framework (oder "inline"). Deckt sich mit dem Frontmatter.
2. `## Model-Specs` — verifizierte Fakten: Prompt-Format, Parameter, Limits,
   Auflösungen/Dauer, Aspect-Ratios. Jede Zeile so knapp wie möglich.
3. `## Inputs` — **was das Model annimmt** (siehe eigener Abschnitt unten).

Bei gekoppelten Files steht **`## Wann nutze ich es` als ERSTE Sektion, vor `## Routing`** —
der Router liest zuerst die Situation, dann die Mechanik.
4. `## Overrides` — wo das Model von der Framework-Default-Struktur abweicht.
5. `## Gold-Beispiele` — 1–2 Few-Shot-Beispiele (Brief → fertiger Prompt).
6. `## Don'ts` — typische Failure-Modes dieses Models.
7. `## Learnings` — datierte Einzeiler aus der Praxis. Wächst über Zeit.

Ein File mit `status: draft` trägt statt der Pflicht-Sektionen ein `## Recherche-Log`,
das die Quellenlücke belegt: welche Quellen geprüft wurden und warum sie nicht reichen.
Ohne diesen Beleg ist ein draft-File nicht zulässig — sonst lässt sich "noch nicht
recherchiert" nicht von "still übersprungen" unterscheiden.

## Die `## Inputs`-Sektion (Pflicht ab `status != draft`)

Der Router muss vor dem Prompten wissen, **was das Model überhaupt entgegennimmt** —
sonst baut er einen Prompt für eine Eingabe, die das Model gar nicht kennt. Mindestinhalt:

- **Eingabe-Modalitäten:** Text, Bild, Maske, Referenzbilder.
- **Anzahl- und Formatlimits je Modalität** (z. B. "bis 16 Bilder", "Maske nur PNG/WebP
  mit Alpha-Kanal").
- **Prompt-Limit** in Zeichen oder Token.
- **Steuerparameter mit Wertebereich:** seed, negative prompt, cfg/guidance,
  Aspect Ratios, Auflösungen.
- **Eine explizite "geht nicht"-Zeile** — was das Model NICHT annimmt (z. B. "kein Seed,
  kein Negative-Prompt"). Diese Zeile ist der eigentliche Wert der Sektion: Abwesenheit
  einer Fähigkeit steht sonst nirgends und wird sonst geraten.
- **Kurz die Ausgabeseite:** Formate, Auflösungen, Dauer.

## `prompt_guide` — Specs sind nicht Best Practices

`source` belegt, **was** ein Model annimmt. `prompt_guide` belegt, **wie** der Anbieter das
Prompten empfiehlt. Das sind zwei verschiedene Dokumente und zwei verschiedene Wissensstufen —
ein File mit sauberer API-Referenz und ohne Prompt-Guide beschreibt Parameter, nicht Handwerk.

| Wert | Bedeutung |
|---|---|
| URL | Der Anbieter-Guide, aus dem `## Overrides` stammt |
| `blockiert` | Guide existiert, liegt aber hinter Captcha oder Login. **Nicht umgehen** — als Lücke belegen |
| `keine` | Der Anbieter veröffentlicht keinen Prompt-Guide |

Bei `blockiert` und `keine` verlangt `scripts/check-models.sh` einen
`<!-- unverified … -->`-Marker im Body. So ist maschinell unterscheidbar, ob `## Overrides`
auf einer Anbieter-Empfehlung steht oder auf Ableitung aus den API-Limits.

**Versionsfalle:** Prüfen, ob es je Modell-Generation einen **eigenen** Guide gibt. Ein
Serien-Guide (z. B. für eine ganze Seedream- oder FLUX-Reihe) gilt nicht automatisch für
eine neue Version — Regeln können sich zwischen den Generationen widersprechen. Ein
Serien-Guide ist kein Versions-Guide.

## `source_tier` — Quellen-Disziplin

Nicht jedes Model hat eine Vendor-Doku. Damit trotzdem sichtbar bleibt, wie belastbar
eine Spec ist, trägt jedes nicht-draft File eine Quellen-Ebene:

| Wert | Bedeutung |
|---|---|
| `official` | Doku des Anbieters selbst (OpenAI, Google, BFL, ByteDance …). Erste Wahl. |
| `platform` | API-Referenz einer Hosting-Plattform (fal.ai, Replicate, OpenRouter), wenn es keine Vendor-Doku gibt. |

Bei `platform` **muss im File stehen**, dass die Parameter die Wrapper-Ebene beschreiben
und nicht zwingend die native API — sonst wird eine Plattform-Eigenheit als Model-Spec
gelesen. Community-Guides, Foren und Arena-Stände sind **keine** Spec-Quelle; sie dürfen
nur als Erfahrungswert unter `## Learnings` auftauchen, klar als solcher markiert.

## Kopplung an die Notion-Datenbank KI-MODELLE

Der Skill weiß, **wie** man ein Model promptet. Simons Notion-Datenbank **KI-MODELLE** weiß,
**wann** man es nimmt und was es kostet. Beides gehört zusammen, ohne sich zu doppeln.

**Datenbank:** https://app.notion.com/p/3ab79c4d6b2d80fc9636cfb736f2b4bd
**Snapshot im Repo:** `research/notion-core-2026-08-22.json` (Tier `Core`, Kategorie
Bildgenerierung) — liegt im Entwicklungs-Repo, **nicht im
ausgelieferten Skill**; auf claude.ai gilt die Notion-Datenbank direkt.

| Feld | Herkunft | Regel |
|---|---|---|
| `verdikt` | Notion | wörtlich übernehmen |
| `wann_nutze_ich_es` | Notion | **wörtlich** übernehmen, nicht umformulieren |
| `endpunkt` | Notion | wörtlich; `—` wenn Notion keinen führt |
| `preis` | Notion | wörtlich; `—` wenn Notion keinen führt |
| `notion_rows` | Zuordnung | eine oder **mehrere** Zeilen-URLs |

**Warum `notion_rows` eine Liste ist:** Notion zählt **Endpunkte**, der Skill zählt
**Modellfamilien**. Ein Modell kann in Notion als mehrere Endpunkt-Varianten (z. B. text-to-image
und image-edit) in getrennten Zeilen liegen; im Skill ist das ein einziges Model-File. Die Liste ist der
Mapping-Schlüssel zwischen beiden Zählweisen.

**Simons Urteil ist nicht zu redigieren.** `verdikt`, `wann_nutze_ich_es`, `Stärke` und
`Schwäche` sind kuratierte Bewertungsarbeit. Sie werden übernommen, nie „verbessert" —
`scripts/check-sync.sh` vergleicht sie normalisiert gegen den Snapshot und schlägt bei
Umformulierung fehl.

**Bei Widerspruch Notion ↔ offizielle Docs wird nichts stillschweigend aufgelöst:** die
verifizierte Spec steht im Body, Simons Urteil im Frontmatter, und der Widerspruch gehört
in den Lauf-Report als Änderungsvorschlag. Beispiel: Notion verweist auf einen älteren
Endpunkt, während die Doku eine neuere Modell-Version als Flaggschiff führt.

## Workflow-File-Frontmatter (Contract)

Jedes `workflows/<name>.md` beginnt mit:

```yaml
---
name:          # Anzeigename, z. B. "Multishot 2x2 Grid"
aliases: []    # Routing-Strings, lowercase
kind: workflow
goal:          # was das Rezept erreicht, ein Satz
models: []     # genutzte Modalität (image) oder konkrete Models
tasks: []      # kombinierte Tasks, z. B. [text-to-image, image-edit]
status:        # active | experimental | draft
last_verified: # YYYY-MM-DD
source:        # URL/Referenz, falls die Technik dokumentiert ist
---
```

Body-Sektionen: `## Wann` · `## Zutaten` (welche Models/Frameworks) · `## Schritte`
(die Sequenz) · `## Prompt-Bausteine` (Snippet je Schritt) · `## Gold-Beispiel` ·
`## Don'ts` · `## Learnings`.

**Workflow ≠ Framework:** Ein Framework strukturiert EINEN Prompt; ein Workflow
orchestriert mehrere Schritte/Models. Ein Workflow erfindet keine Model-Specs — er
verweist auf die Model-Files (Ground Truth).

## Pack-File-Frontmatter (Contract)

Jedes `packs/<name>.md` beginnt mit:

```yaml
---
name:          # Anzeigename, z. B. "Character Sheet"
aliases: []    # Routing-Strings, lowercase, wie der User den AUFTRAG nennt
kind: pack
goal:          # welchen wiederkehrenden Auftrag der Pack bedient, ein Satz
models: []     # empfohlene Models, Primärmodell zuerst
tasks: []      # die Tasks, die der Prompt-Körper bedient
status:        # active | experimental | draft
last_verified: # YYYY-MM-DD
source:        # "intern — erprobt" oder URL
---
```

Body-Sektionen: `## Wann` · `## Vorbereitung` (was der User liefern muss) ·
`## Modelle` (Primär + Alternativen mit ihrer harten Grenze) · `## Slots` (Tabelle mit
Default) · `## Prompt` (verbatim Code-Block je Prompt, Parameter darunter) · `## Don'ts` ·
`## Learnings`.

**Pack ≠ Framework ≠ Workflow** — die Achse ist der Unterschied: ein Framework gibt EINEM
Prompt seine **Struktur**, ein Workflow orchestriert **Schritte**, ein Pack liefert einen
fertigen **Körper mit Slots**. Ein Pack darf mehrere Prompts enthalten, solange sie EINEN
Auftrag bedienen und nicht aufeinander aufbauen; sobald Schritt 2 den Output von Schritt 1
braucht, ist es ein Workflow.

**Ein Pack entsteht ab dem zweiten Mal.** Einmal gebraucht ist ein Prompt, zweimal
gebraucht ist ein Pack. Der Prompt-Körper wird verbatim übernommen, nie umformuliert —
Änderungen erst als datierte Zeile unter `## Learnings`, dann in den Körper.
Abgrenzung ausführlich: `../packs/README.md`.

## Naming

- Dateinamen kebab-case, Model = Produktname (`gpt-image.md`, nicht `openai.md`).
- Framework-Dateien heißen exakt nach dem Task (`text-to-image.md`).
- Workflow-Dateien beschreiben das Rezept (`multishot-2x2-grid.md`).
- Alias-Strings lowercase; alle plausiblen Schreibweisen aufnehmen.

## `last_verified`-Regeln

- Nur setzen, nachdem die Angaben gegen die offizielle `source`-Doc geprüft wurden.
- Format `YYYY-MM-DD`.
- Älter als 3 Monate = stale → beim "check" melden (siehe SKILL.md).
- Bei jeder inhaltlichen Änderung an den Specs neu setzen.

## Framework-Auslagerungs-Heuristik

Ein `frameworks/<task>.md` entsteht erst, wenn **≥ 2 Models denselben Task
teilen**. Logik, die nur ein einziges Model braucht, lebt inline im Model-File
(`## Overrides`), nicht als eigenes Framework. So bleibt jedes Framework ein
echter gemeinsamer Nenner.

## Operationen (Operations-Map)

Konkrete Operationen (relight, upscale, inpaint, outpaint, freistellen, style-transfer …)
werden in `shared/operations.md` auf Task + Framework + Modifier + Model-Hinweis gemappt.
Lean-Tasks-Regel: ein neuer Task entsteht nur bei anderer Mechanik (Maske → `inpaint`,
Canvas → `outpaint`, Regler → `enhance`); sonst ist es eine Operation im Edit-Flow.

## Modifier-Library (`modifiers/`)

Die Bild-Frameworks nutzen eine vendored Tag-Bibliothek unter
`modifiers/image/` (Herkunft: Tchibo prompting-agent prompt-lib). Regeln:
Tag-Texte **verbatim** übernehmen, nie umschreiben oder kürzen; Stacking/Conflict nach
`modifiers/image/USAGE.md`. Index/Routing: `modifiers/README.md`. Tag-ID-Format
`CATEGORY-NAME` (screaming-kebab).

## Projektschicht (`projects/`, außerhalb des Skills)

Drei Wissensarten, drei Orte — die Trennung ist das Wesentliche:

| Wissen | Ort | Beispiel |
|---|---|---|
| Wie prompted man ein Modell | `models/<model>.md` | „gpt-image-2 kennt keinen Negative-Prompt" |
| Wann nimmt man welches | Notion + `verdikt` im Frontmatter | „Daily Driver für Infografiken" |
| **Worum geht es gerade** | **`projects/<slug>.md`** | „Palette, 4:5, dieser Packshot" |

`projects/` liegt **außerhalb** von `skill/` — Kundendaten gehören nicht ins ZIP für
claude.ai. Der Router liest `projects/ACTIVE.md` **vor** allem anderen; steht dort `keins`,
wird gefragt statt geraten. *(Standalone/ohne Projekt-Ordner: gibt es keinen `projects/`,
fragen, welche Vorgaben gelten — nie raten.)*

**Learnings sortieren:** modellweit → Model-File. Kundenspezifisch → Projekt. Wer das
vermischt, macht die Model-Files unbrauchbar oder verliert das Projektwissen beim Wechsel.

## Konflikt-Regel

Framework = Default-Struktur (Konvention). Model-File = Ground Truth.
**Bei jedem Widerspruch gewinnt das Model-File.**

## Ehrlichkeit

- Keine Model-Specs erfinden. Jede Spec stammt aus der offiziellen `source`-Doc.
- Framework-Reihenfolgen sind "bewährte Defaults" (Community-/Praxis-Konvention, z. B. aus
  der Tchibo-prompt-lib), kein offizieller Model-Standard — im Framework-File mit `source`
  so kennzeichnen.
- Unsicheres als unsicher markieren (HTML-Kommentar `unverified`), nicht plausibel
  klingend füllen.

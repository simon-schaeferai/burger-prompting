---
name:
aliases: []
vendor:
type:            # image
version:         # optional: gepinnte Modell-Version (z. B. gpt-image-2)
tasks: []        # text-to-image | image-edit | enhance | inpaint | outpaint
frameworks:      # Task→Framework-Mapping ODER "none"
status: draft    # active | experimental | deprecated | draft
last_verified:   # YYYY-MM-DD nach Prüfung gegen source
source:          # URL offizielle Docs
source_tier:     # official | platform — Pflicht ab status != draft
prompt_guide:    # URL des Anbieter-Prompt-Guides, sonst "blockiert" | "keine"
                 # (Pflicht bei active/experimental; Ausnahmen brauchen unverified-Marker)

# Kopplung an Notion KI-MODELLE (siehe ../shared/conventions.md)
verdikt:            # Daily Driver | Zweitwahl | Spezialfall | Nur wenn nötig | Ungetestet
wann_nutze_ich_es:  # WÖRTLICH aus Notion, nicht umformulieren
endpunkt:           # aus Notion, sonst —
preis:              # aus Notion, sonst —
notion_rows: []     # URLs der abgedeckten Notion-Zeilen
---

# <Model-Name>

> Vorlage. Kopieren nach `models/<model>.md`, Frontmatter + Sektionen befüllen.
> Specs nur aus Docs (`source`) — nichts erfinden. Regeln: `../shared/conventions.md`.

## Wann nutze ich es

<!-- ERSTE Sektion bei gekoppelten Files. Der Auslöser als Situation, wörtlich aus
     Notion, danach optional ein bis zwei Sätze Einordnung gegen die Alternativen. -->

## Routing

<!-- Task → Framework (oder "inline"). Muss zum Frontmatter passen. -->

## Model-Specs

<!-- Verifizierte Fakten: Prompt-Format, Parameter, Limits, Auflösung/Dauer,
     Aspect-Ratios. Jede Angabe wird von source gedeckt. -->

## Inputs

<!-- Was das Model ANNIMMT. Pflicht ab status != draft. Mindestens:
     - Eingabe-Modalitäten (Text, Bild, Maske, Referenzen)
     - Anzahl-/Formatlimits je Modalität
     - Prompt-Limit (Zeichen/Token)
     - Steuerparameter mit Wertebereich (seed, negative prompt, cfg, AR, Auflösung)
     - eine explizite "geht nicht"-Zeile
     - kurz die Ausgabeseite (Formate, Auflösungen) -->

## Overrides

<!-- Wo dieses Model von der Framework-Default-Struktur abweicht. -->

## Gold-Beispiele

<!-- 1–2 Few-Shot: Brief → fertiger Prompt. -->

## Don'ts

<!-- Typische Failure-Modes dieses Models. -->

## Learnings

<!-- Datierte Einzeiler aus der Praxis. Wächst über Zeit. -->

<!-- Solange status: draft gilt, steht hier statt der Pflicht-Sektionen ein
## Recherche-Log
das belegt, welche Quellen geprüft wurden und warum sie nicht reichen. -->

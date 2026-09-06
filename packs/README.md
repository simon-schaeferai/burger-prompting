# Packs

Ein **Pack** ist ein erprobter, parametrisierter Fertig-Prompt für einen
wiederkehrenden Auftrag. Er wird nicht neu erfunden, sondern aufgerufen und mit
Slots gefüllt.

## Abgrenzung — die drei Ebenen nicht vermischen

| Ebene | Was sie ist | Beispiel |
|---|---|---|
| `frameworks/<task>.md` | **Struktur** für EINEN Prompt eines Tasks | „so ist ein image-edit-Prompt gebaut" |
| `workflows/<name>.md` | **Orchestrierung** mehrerer Schritte/Models | „Grundbild bauen → Figur über mehrere Shots konsistent halten" |
| `packs/<name>.md` | **Fertiger Prompt-Körper** für einen konkreten Auftrag | „Character Sheet von einer realen Person" |

Der Unterschied zum Workflow ist die Achse: ein Workflow hat **Schritte**, ein Pack
hat **Slots**. Ein Pack darf mehrere Prompts enthalten (z. B. Kopf-Sheet und
Body-Sheet), solange sie EINEN Auftrag bedienen und nicht aufeinander aufbauen.

## Warum es Packs gibt

Der Router baut Prompts aus Brief + Framework + Model-File. Das ist richtig für
offene Aufträge. Bei wiederkehrenden Aufträgen ist es Verschwendung und riskant:
jedes Mal neu gebaut heißt jedes Mal andere Formulierung, und die Lehren aus dem
letzten Lauf gehen verloren. Ein Pack friert das Erprobte ein und lässt nur die
Slots offen.

## Regeln

1. **Ein Pack erfindet keine Model-Specs.** Parameter und Limits stehen im
   Model-File; der Pack verweist darauf.
2. **Der Prompt-Körper ist verbatim.** Wer ihn umformuliert, verliert die Erprobung.
   Änderungen gehören als datierte Zeile unter `## Learnings` — dann in den Körper.
3. **Slots in doppelten geschweiften Klammern**, `{{GROSSBUCHSTABEN}}`, jeder Slot
   in `## Slots` erklärt und mit Default.
4. **Ein Pack entsteht ab dem zweiten Mal.** Einmal gebraucht ist ein Prompt,
   zweimal gebraucht ist ein Pack.
5. **Modell-Zuordnung ist Empfehlung, nicht Bindung.** `## Modelle` nennt das
   Primärmodell mit Begründung und die belegten Alternativen samt ihrer Grenze.

## Neuen Pack anlegen

1. `_TEMPLATE.md` nach `packs/<name>.md` kopieren.
2. Frontmatter + Sektionen befüllen.
3. Eine Zeile in den Pack-Roster in `../SKILL.md`.

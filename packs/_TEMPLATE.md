---
name:            # Anzeigename, z. B. "Character Sheet"
aliases: []      # Routing-Strings, lowercase, wie der User den Auftrag nennt
kind: pack
goal:            # welchen Auftrag der Pack bedient, ein Satz
models: []       # empfohlene Models, Primärmodell zuerst
tasks: []        # text-to-image | image-edit | enhance | inpaint | outpaint
status: draft    # active | experimental | draft
last_verified:   # YYYY-MM-DD
source:          # woher der Prompt-Körper stammt (intern/erprobt oder URL)
---

# <Pack-Name>

> Vorlage. Kopieren nach `packs/<name>.md`. Regeln: `README.md` + `../shared/conventions.md`.
> Ein Pack hat SLOTS, kein Workflow-Schrittwerk. Prompt-Körper verbatim übernehmen.

## Wann
<!-- Der Auslöser als Situation, nicht als Feature. -->

## Vorbereitung
<!-- Was der User liefern muss, bevor der Prompt läuft (Referenzen, Assets, Fakten).
     Bei Referenzbildern: welche Ansichten, welche Qualität, welche Reihenfolge. -->

## Modelle
<!-- Primärmodell + warum. Alternativen + ihre harte Grenze. Verweis auf models/<x>.md. -->

## Slots
| Slot | Bedeutung | Default |
|---|---|---|
| `{{SLOT}}` |  |  |

## Prompt
<!-- Der verbatim Prompt-Körper im Code-Block. Mehrere Blöcke erlaubt, wenn sie
     denselben Auftrag bedienen. Parameter je Block darunter. -->

## Don'ts
<!-- Typische Failure-Modes dieses Auftrags. -->

## Learnings
<!-- Datierte Einzeiler aus der Praxis. -->

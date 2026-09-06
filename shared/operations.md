# Operations-Map

Routing-Schicht: konkrete Operation (was der User will) → **Task** + **Framework** +
**Modifier-Kategorien** + **Model-Hinweis**. Der Router konsultiert diese Tabelle, wenn
der User eine spezifische Operation nennt („relight", „upscale", „inpaint",
„hintergrund weg", „im Stil von" …).

**Lean-Tasks-Prinzip:** Ein neuer Task (mit eigenem Framework) entsteht nur, wenn die
MECHANIK anders ist — Maske (inpaint), Canvas-Erweiterung (outpaint), Regler (enhance).
Sonst ist es eine Operation im Edit-Flow (`image-edit`), unterschieden durch
Modifier + Model-Specs.

## Bild-Operationen

| Operation | Trigger (Beispiele) | Task | Modifier / Hinweis |
|---|---|---|---|
| Generieren | generate, create, „Bild von" | text-to-image | 5-Block-Framework |
| Editieren (allg.) | change, add, remove, transform | image-edit | Edit-Flow |
| Relighting | relight, Licht ändern, neu ausleuchten | image-edit | `modifiers/image/lighting` |
| Style-Transfer | „im Stil von", style transfer | image-edit | `cinematic-styles` / `commercial-styles`, ggf. Referenz |
| Objekt add/remove/replace | add/remove/replace object | image-edit | Änderung verbatim beschreiben |
| Reframe | reframe, gleicher Moment neue Position | image-edit | `modifiers/image/single-shots` |
| Outpainting / Expand | outpaint, erweitern, mehr zeigen, zoom out | **outpaint** \* | `modifiers/image/scene-extender` |
| Inpainting | inpaint, Maske, Bereich ersetzen | **inpaint** \* | Maske + Prompt (model-spezifisch) |
| BG-Removal | remove background, freistellen | image-edit | oft Ein-Klick / Model-Spec, kein Prompt |
| Upscaling | upscale, größer, hochskalieren | enhance | reglergetrieben (z. B. Magnific) |
| Restore / Denoise / Face-Fix | restore, entrauschen, Gesicht fixen | enhance | reglergetrieben |
| Face-Swap / Virtual Try-On | face swap, anprobieren | model-spezifisch | referenzbasiert → Model-Specs |

\* `inpaint`/`outpaint` = eigene Mechanik (Maske bzw. Canvas). Als Task registriert; ein
eigenes `frameworks/`-File entsteht erst, wenn **≥ 2 Models** es teilen — bis dahin inline
im Model-File (`## Overrides`).

## Regeln
- Erst Operation erkennen → dann Task → dann Framework/Modifier/Model laden.
- Kann das gewählte Model die Operation nicht (nicht in seinem `tasks:`), Fehlerpfad
  (SKILL.md): sagen, nicht generieren.
- Neue Operation = eine Zeile hier + ggf. neuer Task/Framework nach der ≥2-Regel.

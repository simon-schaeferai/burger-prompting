# INDEX — Routing nach Situation

> **Generiert.** Nicht von Hand bearbeiten — `bash scripts/build-index.sh` (Entwicklungs-Repo, nicht im ZIP).
> Quelle ist das Frontmatter der Model-Files; `scripts/check-structure.sh` (ebenfalls Repo)
> prüft, dass diese Datei ohne Diff neu erzeugbar ist.

Der Router liest **diese Datei zuerst**: Situation → Modell. Erst danach das
Model-File des Treffers. Ein Read statt achtzehn.

## Aktive Modelle — nach Verdikt

| Wann nutze ich es | Modell | Verdikt | Typ | Preis | File |
|---|---|---|---|---|---|
| Wenn an einem vorhandenen Bild etwas Bestimmtes geändert werden soll, etwa ein Objekt tauschen oder Text ersetzen. | **FLUX** | Daily Driver | image | — | `models/flux.md` |
| Wenn ein Visual in Simons CI entstehen soll und Style-Referenzen mitgegeben werden, etwa Infografiken über den Grafiken-Tab. | **GPT Image** | Daily Driver | image | 0,413 $ pro Bild (3840×2160, high, fal edit) · 0,234 $ bei 2560×1440 | `models/gpt-image.md` |
| Wenn schnell ein realistisch wirkendes Bild gebraucht wird und der Stil nicht über mehrere Bilder identisch sein muss. | **Nano Banana** | Daily Driver | image | 0,15 $ pro Bild | `models/nano-banana.md` |
| Wenn Text im Bild lesbar sein muss oder das Layout dicht ist, etwa Infografiken, Cheatsheets und Karussell-Seiten. | **Seedream** | Daily Driver | image | 0,0675 $ pro Bild | `models/seedream.md` |
| Wenn ein Plakat- oder Logo-Layout mit viel Typografie gebraucht wird und Seedream nicht verfügbar ist. | **Ideogram** | Zweitwahl | image | — | `models/ideogram.md` |
| Wenn ein Icon, Logo oder eine Illustration als skalierbare Vektordatei gebraucht wird. | **Recraft** | Spezialfall | image | — | `models/recraft.md` |
| Wenn ein fertiges Bild größer werden soll — treu (Precision) oder mit hinzuerfundenem Detail (Creative). | **Magnific** | Ungetestet | image | 0,10–0,40 € pro Bild (Doku-Beispiele, nach Ausgabefläche) | `models/magnific.md` |

## Tasks je Modell

| Modell | Tasks |
|---|---|
| **FLUX** | text-to-image, image-edit, enhance, inpaint, outpaint |
| **GPT Image** | text-to-image, image-edit |
| **Nano Banana** | text-to-image, image-edit |
| **Seedream** | text-to-image, image-edit |
| **Ideogram** | text-to-image, image-edit, inpaint, outpaint, enhance |
| **Recraft** | text-to-image, image-edit, inpaint, outpaint, enhance |
| **Magnific** | enhance |

## Nicht aktiv

| Modell | Status | Hinweis | File |
|---|---|---|---|
| Imagen | deprecated | nicht mehr verwenden, Nachfolger im File | `models/imagen.md` |
| Midjourney | draft | noch nicht eingepflegt, nicht darauf generieren | `models/midjourney.md` |


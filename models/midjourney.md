---
name: Midjourney
aliases: [midjourney, mj, mid journey]
vendor: Midjourney
type: image
tasks: []          # TODO: gegen Docs verifizieren
frameworks:        # TODO: nach tasks setzen
status: draft
last_verified:     # TODO
source:            # TODO: offizielle Docs
verdikt: Spezialfall
wann_nutze_ich_es: "Wenn ein Hero-Visual maximale Bildästhetik braucht und Handarbeit vertretbar ist."
endpunkt: —
preis: —
notion_rows: [https://app.notion.com/3ab79c4d6b2d8104a771ea826513d92a]
---

# Midjourney

> DRAFT — noch nicht eingepflegt. Kein Prompt auf Basis dieses Files generieren,
> bis Specs (aus offiziellen Docs + ggf. CustomGPT-Instructions) eingetragen und
> `last_verified` gesetzt sind. `vendor`/`type` sind Allgemeinwissen; Tasks,
> Frameworks, Prompt-Format und Parameter sind offen und dürfen NICHT geraten werden.

## Wann nutze ich es

> **Spezialfall** · ⭐⭐⭐ · —
>
> Wenn ein Hero-Visual maximale Bildästhetik braucht und Handarbeit vertretbar ist.

**Stärke (Notion):** Ästhetisch stärkste Ausgabe am Markt, besonders bei stilisierten und künstlerischen Motiven.

**Schwäche (Notion):** Keine offizielle API, läuft über Discord oder Web-App, damit nicht automatisierbar. Typografie unbrauchbar.

Notions Schwäche-Feld nennt exakt den Grund, warum dieses File `draft` bleibt: **keine offizielle API**, Handarbeit über Discord oder Web-App — und die Doku ist Cloudflare-geschützt.

## Recherche-Log

**2026-08-22 — Quellenlücke, File bleibt bewusst `draft`.**

Alle offiziellen Midjourney-Quellen sind hinter einer Cloudflare-Bot-Prüfung:
`docs.midjourney.com/docs/parameter-list` antwortet WebFetch mit **HTTP 403**; die
gerenderte Parameterliste, `docs.midjourney.com/` und `www.midjourney.com/updates` zeigen
alle die Bot-Prüfung. Die Sperre wurde **nicht umgangen** (Eskalationsregel des Goal-Plans:
Quellen hinter Login, Paywall oder Captcha werden dokumentiert, nicht überlistet).

**Kein Ersatz über die Plattform-Ebene möglich:** Midjourney hat keine öffentliche API —
Parameterlisten auf fal.ai, Replicate oder in Community-Wikis stammen von inoffiziellen
Wrappern bzw. sind laut Quellen-Politik dieses Skills keine Spec-Quelle.

Version, Parameter-Syntax (`--ar`, `--stylize`, `--sref` …) und Limits sind daher **nicht**
eingetragen, obwohl sie als Allgemeinwissen kursieren. Plausibel ist nicht verifiziert.

Nächster Schritt: Parameterliste manuell im Browser abrufen und als Roh-Dump ablegen, oder
entscheiden, dass Midjourney als reines Web-UI-Tool ein Prompt-Syntax-File aus erprobter
Praxis bekommt statt einer API-Spec. Details: `research/midjourney-2026-08-22.md`.

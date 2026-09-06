#!/usr/bin/env bash
# check-staleness.sh — listet Model-Files, deren last_verified älter als N Tage
# ist (Default 90) oder fehlt. Aufruf: scripts/check-staleness.sh [max_days]
set -euo pipefail

MAX_DAYS="${1:-90}"
DIR="$(cd "$(dirname "$0")/.." && pwd)/models"
today_epoch="$(date +%s)"

# YYYY-MM-DD -> epoch seconds, funktioniert mit GNU- und BSD-date (macOS)
to_epoch() {
  if date -d "$1" +%s >/dev/null 2>&1; then
    date -d "$1" +%s
  else
    date -j -f "%Y-%m-%d" "$1" +%s 2>/dev/null
  fi
}

stale=0
for f in "$DIR"/*.md; do
  [ -e "$f" ] || continue
  base="$(basename "$f")"
  [ "$base" = "_TEMPLATE.md" ] && continue

  # last_verified aus dem Frontmatter ziehen, Kommentare/Whitespace strippen
  lv="$(awk -F': *' '/^last_verified:/ {gsub(/[ \t#].*$/,"",$2); print $2; exit}' "$f")"

  if [ -z "${lv:-}" ]; then
    echo "STALE (kein last_verified): $base"
    stale=$((stale+1))
    continue
  fi

  lv_epoch="$(to_epoch "$lv" || true)"
  if [ -z "${lv_epoch:-}" ]; then
    echo "WARN (last_verified unlesbar '$lv'): $base"
    continue
  fi

  age_days=$(( (today_epoch - lv_epoch) / 86400 ))
  if [ "$age_days" -gt "$MAX_DAYS" ]; then
    echo "STALE (${age_days}d alt, source prüfen): $base"
    stale=$((stale+1))
  fi
done

if [ "$stale" -eq 0 ]; then
  echo "OK — alle Model-Files innerhalb ${MAX_DAYS} Tage verifiziert."
else
  echo "--- $stale Model-File(s) zu re-verifizieren."
fi

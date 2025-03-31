#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# 📦 _include.sh – Bash-Funktionsbibliothek
# -----------------------------------------------------------------------------

# Pfade
FORCER_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCER_PROJECT_DIR="$(cd "$FORCER_LIB_DIR/../.." && pwd)"


# .env-Dateien einlesen
if [ -f "$FORCER_PROJECT_DIR/.env" ]; then
  set -a
  source "$FORCER_PROJECT_DIR/.env"
  set +a
fi

if [ -f "$FORCER_PROJECT_DIR/.env.local" ]; then
  set -a
  source "$FORCER_PROJECT_DIR/.env.local"
  set +a
fi


# 📦 Automatisches Einlesen aller Funktionen
if [[ -d "$FORCER_LIB_DIR/functions" ]]; then
  for file in $(find "$FORCER_LIB_DIR/functions" -maxdepth 1 -type f -name "*.sh" | sort); do
    source "$file"
  done
fi


# Globale Export-Variablen
export FORCER_LIB_DIR
export FORCER_PROJECT_DIR

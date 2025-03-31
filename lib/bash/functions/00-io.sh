#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# 📦 io.sh – Wiederverwendbare Ausgaben und Logging für Bash-Projekte
# -----------------------------------------------------------------------------
#
# Enthaltene Funktionen:
#
# - log <text>                   → Grüne Erfolgsnachricht
# - info <text>                  → Blaue Info-Nachricht
# - warn <text>                  → Gelbe Warnung
# - error <text>                 → Rote Fehlermeldung
# - fatal <text>                 → Fehler + Skriptabbruch
# - debug <text>                 → Graue Debug-Nachricht (nur bei FORCER_DEBUG=true)
# - debug_var <name> <value>     → Debug-Ausgabe für Variablen
# - timer_start                  → Startet Zeitmessung
# - timer_end                    → Gibt verstrichene Zeit seit timer_start aus
# - ask_yes_no <frage> [default] → Ja/Nein-Abfrage mit optionalem Default
# - ask_string <frage> <var>     → Zeichenkette vom Benutzer abfragen
# - title <text>                 → Formatierter Blocktitel
# - step <text>                  → Einzelschritt-Ausgabe mit Pfeil
# - textblock <text>             → Mehrzeilige Ausgabe mit automatischem Umbruch
# - note <text>                  → Grauer Hinweis
# - success <text>               → Grüne Erfolgsanzeige mit Häkchen
# - fail <text>                  → Rote Fehlermeldung mit X
#
# -----------------------------------------------------------------------------

emptyline() {
  local count=${1:-1}
  for ((i = 0; i < count; i++)); do
    echo ""
  done
}

log()       { echo -e "\033[1;32m[✔] $1\033[0m"; }
info()      { echo -e "\033[1;34m[i] $1\033[0m"; }
warn()      { echo -e "\033[1;33m[!] $1\033[0m"; }
error()     { echo -e "\033[1;31m[✘] $1\033[0m"; }

fatal() {
  echo -e "\033[1;31m[✘] $1 – Skript wird abgebrochen.\033[0m"
  exit 1
}

debug() {
  if [[ "$FORCER_DEBUG" == "true" ]]; then
    echo -e "\033[90m[debug] $1\033[0m"
  fi
}

debug_var() {
  if [[ "$FORCER_DEBUG" == "true" ]]; then
    local name="$1"
    local value="$2"
    echo -e "\033[90m[debug] $name = $value\033[0m"
  fi
}

timer_start() {
  TIMER_START=$(date +%s)
}

timer_end() {
  if [[ -n "$TIMER_START" ]]; then
    local end=$(date +%s)
    local duration=$((end - TIMER_START))
    echo -e "\033[1;36m⏱  Dauer: ${duration}s\033[0m"
    unset TIMER_START
  else
    warn "Timer wurde nicht gestartet."
  fi
}

ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"
  local answer

  read -rp "$prompt [y/N] " answer
  answer="${answer,,}"
  [[ -z "$answer" ]] && answer="$default"

  [[ "$answer" == "y" || "$answer" == "yes" ]]
}

ask_string() {
  local prompt="$1"
  local varname="$2"
  read -rp "$prompt: " input
  eval "$varname=\"\$input\""
}

title() {
  echo -e "\n\033[1;35m# ---------------------------------------------------"
  echo -e "# $1"
  echo -e "# ---------------------------------------------------\033[0m"
}

step() {
  echo -e "\033[1;36m➤ $1\033[0m"
}

textblock() {
  echo -e "\033[0;37m"
  echo "$1" | fold -s -w 80
  echo -e "\033[0m"
}

note() {
  echo -e "\033[1;30m💡 $1\033[0m"
}

success() {
  echo -e "\033[1;32m✅ $1\033[0m"
}

fail() {
  echo -e "\033[1;31m❌ $1\033[0m"
}

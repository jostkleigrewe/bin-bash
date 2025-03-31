#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# 🔧 fs.sh – Datei- & Pfadfunktionen
# -----------------------------------------------------------------------------
#
# Enthaltene Funktionen:
#
# - ensure_dir <pfad>                → Legt Verzeichnis an, falls nicht vorhanden
# - file_exists <datei>              → true wenn Datei existiert
# - dir_exists <verzeichnis>         → true wenn Verzeichnis existiert
# - read_file_line <datei>           → Gibt erste Zeile der Datei aus
# - read_file <datei>                → Gibt gesamten Inhalt der Datei aus
# - write_file <datei> <inhalt>      → Schreibt Inhalt in Datei (überschreibt)
# - append_file <datei> <inhalt>     → Hängt Inhalt an Datei an
# - delete_file <datei>              → Löscht Datei, falls vorhanden
# - delete_dir <verzeichnis>         → Löscht Verzeichnis rekursiv
# - symlink_force <ziel> <linkname>  → Erstellt/überschreibt symbolischen Link
# - list_files <verzeichnis>         → Gibt alle Dateien im Verzeichnis aus
# - list_dirs <verzeichnis>          → Gibt alle Unterverzeichnisse aus
#
# -----------------------------------------------------------------------------

# 📁 Verzeichnis anlegen, wenn es noch nicht existiert
ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    [[ "$(type -t log)" == "function" ]] && log "Verzeichnis erstellt: $dir"
  fi
}

# 📄 Datei prüfen – existiert?
file_exists() {
  [[ -f "$1" ]]
}

# 📁 Ordner prüfen – existiert?
dir_exists() {
  [[ -d "$1" ]]
}

# 📄 Dateiinhalt einlesen (1. Zeile)
read_file_line() {
  local file="$1"
  [[ -f "$file" ]] && head -n 1 "$file"
}

# 📄 Dateiinhalt vollständig einlesen
read_file() {
  local file="$1"
  [[ -f "$file" ]] && cat "$file"
}

# 📝 Datei schreiben (überschreibt!)
write_file() {
  local file="$1"
  local content="$2"
  echo "$content" > "$file"
}

# 📝 Datei anhängen
append_file() {
  local file="$1"
  local content="$2"
  echo "$content" >> "$file"
}

# ❌ Datei löschen (falls vorhanden)
delete_file() {
  local file="$1"
  [[ -f "$file" ]] && rm "$file"
}

# ❌ Verzeichnis löschen (rekursiv)
delete_dir() {
  local dir="$1"
  [[ -d "$dir" ]] && rm -rf "$dir"
}

# 🔄 Symbolischen Link erstellen oder aktualisieren
symlink_force() {
  local target="$1"
  local link_name="$2"
  ln -sf "$target" "$link_name"
}

# 📁 Alle Dateien in Verzeichnis auflisten
list_files() {
  local dir="$1"
  [[ -d "$dir" ]] && find "$dir" -maxdepth 1 -type f
}

# 📂 Alle Ordner in Verzeichnis auflisten
list_dirs() {
  local dir="$1"
  [[ -d "$dir" ]] && find "$dir" -maxdepth 1 -type d ! -path "$dir"
}

#!/usr/bin/env bash

set -e

# -----------------------------------------------------------------------------
# 📦 Konfiguration
# -----------------------------------------------------------------------------
PROJECT_REPOSITORY="https://github.com/jostkleigrewe/bin-bash.git"
PROJECT_DIR="$HOME/bin-bash"
BASHRC="$HOME/.bashrc"
USERNAME="wsl"
PASSWORD="wsl"
BLOCK_START="# >>> bin-bash project bashrc.d loader >>>"
BLOCK_END="# <<< bin-bash project bashrc.d loader <<<"


# -----------------------------------------------------------------------------
# 🧾 Logging-Funktionen
# -----------------------------------------------------------------------------
title() {
  echo -e "\n\n\033[1;35m# ---------------------------------------------------"
  echo -e "# $1"
  echo -e "# ---------------------------------------------------\033[0m\n"
}
log()       { echo -e "\033[1;32m[✔] $1\033[0m"; }
info()      { echo -e "\033[1;34m[i] $1\033[0m"; }
warn()      { echo -e "\033[1;33m[!] $1\033[0m"; }
error()     { echo -e "\033[1;31m[✘] $1\033[0m"; }
success()   { echo -e "\033[1;32m✅ $1\033[0m"; }
emptyline() {
  local count=${1:-1}
  for ((i = 0; i < count; i++)); do
    echo ""
  done
}

# -----------------------------------------------------------------------------
# 👤 Start
# -----------------------------------------------------------------------------
title "🛠 BIN-BASH INSTALLATION"
info "Starte initiale Einrichtung deiner WSL-Entwicklungsumgebung (Benutzer, sudo, Git, SSH, Bash-Setup usw.)."
info "Bitte habe ggf. dein Passwort bereit – je nach Konfiguration können Root-Rechte benötigt werden."


# -----------------------------------------------------------------------------
# 👤 ROOT-MODUS: Benutzer & Konfiguration
# -----------------------------------------------------------------------------
if [[ "$EUID" -eq 0 ]]; then

  title "📦 Projektinstallation im Root-Context"
  info "Setup läuft als root – Benutzer & WSL-Konfiguration werden vorgenommen."
  emptyline

  # Benutzer existiert bereits
  if id "$USERNAME" &>/dev/null; then
    log "Benutzer '$USERNAME' existiert bereits."

  # Benutzer anlegen
  else
    info "Lege Benutzer '$USERNAME' an ..."
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    usermod -aG sudo "$USERNAME"
    success "Benutzer '$USERNAME' wurde angelegt & hat sudo-Rechte."
  fi

  # sudo ohne Passwort
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/99-${USERNAME}-nopass > /dev/null
  chmod 0440 /etc/sudoers.d/99-${USERNAME}-nopass
  log "Sudo-Zugriff ohne Passwort aktiviert."

  info "Setze '$USERNAME' als Standardbenutzer in /etc/wsl.conf ..."
  cat <<EOF > /etc/wsl.conf
[user]
default=$USERNAME
EOF
  log "/etc/wsl.conf wurde aktualisiert."

  emptyline
  success "Benutzer '$USERNAME' wurde erfolgreich eingerichtet."
  emptyline

  info "Bitte führe jetzt in der Windows-Shell aus:"
  info "   wsl --terminate <Name>"
  info "   wsl -d <Name>"
  emptyline
  exit 0
fi


# -----------------------------------------------------------------------------
# 👤 Nicht-root: Benutzer-Setup
# -----------------------------------------------------------------------------
title "📦 Projektinstallation im Benutzerkontext"
info "Setup läuft als Benutzer – Installation der Shell-Erweiterung ..."


# -----------------------------------------------------------------------------
# 🔐 Sudo-Rechte & NOPASSWD setzen (nur wenn nicht vorhanden)
# -----------------------------------------------------------------------------
title "🔐 Sudo-Rechte & Passwortlose Nutzung konfigurieren"

# Prüfe, ob der Benutzer bereits in der sudo-Gruppe ist
if id -nG "$USER" | grep -qw sudo; then
  info "🔑 Der Benutzer '$USER' ist bereits in der sudo-Gruppe."
else
  if command -v sudo &>/dev/null; then
    info "🔑 Füge '$USER' zur sudo-Gruppe hinzu ..."
    sudo usermod -aG sudo "$USER" && success "➕ Benutzer '$USER' wurde zur sudo-Gruppe hinzugefügt."
    info "⚠️ Bitte starte die Shell oder WSL-Instanz neu, damit die Gruppenzugehörigkeit wirksam wird."
    exit 0
  else
    error "Keine Möglichkeit gefunden, sudo-Rechte zu setzen – bitte manuell prüfen."
    exit 1
  fi
fi

# Setze NOPASSWD für den Benutzer, falls noch nicht vorhanden
SUDOERS_FILE="/etc/sudoers.d/99-${USER}-nopass"

if sudo test -f "$SUDOERS_FILE"; then
  info "📝 Sudoers-Datei existiert bereits ($SUDOERS_FILE)"
else
  info "🔑 Setze NOPASSWD für '$USER' ..."
  echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDOERS_FILE" > /dev/null
  sudo chmod 0440 "$SUDOERS_FILE"
  success "➕ NOPASSWD-Sudo-Zugriff aktiviert für '$USER' ($SUDOERS_FILE)"
fi


# -----------------------------------------------------------------------------
# 📦 System-Update
# -----------------------------------------------------------------------------
title "📦 System-Update"

info "System wird aktualisiert ..."
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y

info "Git wird installiert ..."
sudo apt install -y git
success "Systempakete aktualisiert."


# -----------------------------------------------------------------------------
# 📦 Projekt klonen
# -----------------------------------------------------------------------------
title "📦 BIN-BASH Projekt klonen"

cd ~

if [[ ! -d "$PROJECT_DIR" ]]; then
  info "Klone Repository: $PROJECT_REPOSITORY"
  git clone "$PROJECT_REPOSITORY" "$PROJECT_DIR"
  cd "$PROJECT_DIR"
  success "Repository wurde erfolgreich nach '$PROJECT_DIR' geklont."
else
  warn "Projektverzeichnis '$PROJECT_DIR' existiert bereits – Aktualisiere Repository."
  cd "$PROJECT_DIR"
  git pull
  success "Repository wurde aktualisiert."
fi


# -----------------------------------------------------------------------------
# 📜 bashrc.d Loader-Block in .bashrc integrieren
# -----------------------------------------------------------------------------
title "🧠 Bash-Konfiguration vorbereiten"
info "Aktualisiere .bashrc um Loader für bashrc.d ..."

# Block erstellen
LOADER_BLOCK=$(cat <<EOF
$BLOCK_START
if [ -d "$PROJECT_DIR/bashrc.d" ]; then
shopt -s nullglob
for f in "$PROJECT_DIR/bashrc.d/"*.sh; do
  [ -r "\$f" ] && source "\$f"
done
fi
$BLOCK_END
EOF
)

# Block einfügen/ersetzen
if grep -Fq "$BLOCK_START" "$BASHRC"; then
  TMP_FILE=$(mktemp)
  echo "$LOADER_BLOCK" > "$TMP_FILE"
  sed -i "/$BLOCK_START/,/$BLOCK_END/d" "$BASHRC"
  echo "" >> "$BASHRC"
  cat "$TMP_FILE" >> "$BASHRC"
  rm "$TMP_FILE"
  log "bashrc-Loader ersetzt."
else
  echo -e "\n$LOADER_BLOCK" >> "$BASHRC"
  log "bashrc-Loader hinzugefügt."
fi


# -----------------------------------------------------------------------------
# 🔄 .bashrc neu laden
# -----------------------------------------------------------------------------
if [[ $- == *i* ]]; then
  if [[ -f "$BASHRC" ]]; then
    source "$BASHRC"
    log ".bashrc neu geladen."
  else
    warn ".bashrc nicht gefunden – bitte manuell prüfen."
  fi
else
  warn "Nicht-interaktive Shell – bitte führe 'source ~/.bashrc' manuell aus."
fi


# -----------------------------------------------------------------------------
# 🔐 SSH-Konfiguration
# -----------------------------------------------------------------------------
title "🔐 SSH-Konfiguration vorbereiten"

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  info "🔐 Erstelle einen neuen SSH-Key (falls noch keiner existiert)"
  ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
  success "Neuer SSH-Key wurde erstellt: $HOME/.ssh/id_ed25519"
else
  info "🔐 SSH-Key ist bereits vorhanden: $HOME/.ssh/id_ed25519"
fi

emptyline
log "👉 Dein Public Key (zum Einfügen bei GitHub, GitLab, etc.):"
echo -e "\n\033[1;36m$(cat "$HOME/.ssh/id_ed25519.pub")\033[0m"
emptyline
info "📁 Alternativ kannst du bestehende SSH-Schlüssel in den Ordner ~/.ssh kopieren."
info "💡 Vergiss nicht, die Berechtigungen korrekt zu setzen (chmod 600 für private Keys)."


# -----------------------------------------------------------------------------
# 🎉 Abschlussmeldung
# -----------------------------------------------------------------------------
title "🛠 Bin-Bash Setup abgeschlossen"
success "Deine WSL-Umgebung wurde erfolgreich eingerichtet."
emptyline
info "📦 WSL jetzt sauber beenden & wieder starten:"
echo -e "\n   wsl --terminate <Name>\n   wsl -d <Name>"
emptyline 2





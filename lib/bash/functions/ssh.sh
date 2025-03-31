#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# 🔧 git.sh – Git-Shortcuts, Branch, Repo-Check
# -----------------------------------------------------------------------------
setup_ssh_key() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  local key="$HOME/.ssh/id_ed25519"

  if [[ ! -f "$key" ]]; then
    info "🔐 Erstelle SSH-Key ..."
    ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f "$key" -N ""
    success "SSH-Key erstellt: $key"
  else
    info "🔐 SSH-Key existiert bereits: $key"
  fi

  chmod 600 "$key"
  chmod 644 "$key.pub"

  log "👉 Dein Public Key:"
  echo -e "\n\033[1;36m$(cat "$key.pub")\033[0m"
}

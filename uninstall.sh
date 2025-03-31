#!/usr/bin/env bash
set -e

# Logging
log()   { echo -e "\033[1;32m[✔] $1\033[0m"; }
info()  { echo -e "\033[1;34m[i] $1\033[0m"; }
warn()  { echo -e "\033[1;33m[!] $1\033[0m"; }

BASHRC="$HOME/.bashrc"
BLOCK_START="# >>> bin-bash project bashrc.d loader >>>"
BLOCK_END="# <<< bin-bash project bashrc.d loader <<<"

if grep -Fq "$BLOCK_START" "$BASHRC"; then
  sed -i "/$BLOCK_START/,/$BLOCK_END/d" "$BASHRC"
  log "bashrc-Loader entfernt."
else
  warn "Kein bashrc-Loader gefunden – nichts zu tun."
fi

if [[ $- == *i* ]]; then
  source "$BASHRC"
  log "bashrc neu geladen."
fi

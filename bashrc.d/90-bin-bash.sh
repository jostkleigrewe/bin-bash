## ----------------------------------------------
## 🧠 BIN BASH: Nützliche Funktionen
## ----------------------------------------------


# ----------------------------------------------
# 🎨 Optional: farbiger Prompt mit Git-Branch
# ----------------------------------------------

# Nur anzeigen, wenn interaktive Shell
if [[ $- == *i* ]]; then
  parse_git_branch() {
    git branch 2>/dev/null | grep '\*' | sed 's/* \(.*\)/ (\1)/'
  }

  export PS1="\[\e[0;32m\]\u@\h \[\e[0;34m\]\w\[\e[33m\]\$(parse_git_branch)\[\e[0m\]\n\$ "
fi

## NVM
#export NVM_DIR="\$HOME/.nvm"
#[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
#
## Composer
#export PATH="\$HOME/.config/composer/vendor/bin:\$PATH"
#
## Symfony
#export PATH="\$HOME/.local/bin:\$PATH"
#

## ----------------------------------------------
## 🧠 Nützliche Funktionen (Beispiel)
## ----------------------------------------------
#
#function mkcd() {
#  mkdir -p "$1" && cd "$1"
#}
#
#function extract() {
#  if [ -f "$1" ]; then
#    case "$1" in
#      *.tar.bz2) tar xjf "$1" ;;
#      *.tar.gz)  tar xzf "$1" ;;
#      *.bz2)     bunzip2 "$1" ;;
#      *.gz)      gunzip "$1" ;;
#      *.tar)     tar xf "$1" ;;
#      *.tbz2)    tar xjf "$1" ;;
#      *.tgz)     tar xzf "$1" ;;
#      *.zip)     unzip "$1" ;;
#      *.rar)     unrar x "$1" ;;
#      *.7z)      7z x "$1" ;;
#      *)         echo "'$1' kann nicht automatisch entpackt werden." ;;
#    esac
#  else
#    echo "'$1' ist keine gültige Datei"
#  fi
#}
#
alias f-cd='cd ~/bin-bash'
alias f-update='cd ~/bin-bash; git pull'
alias f-p='cd ~/projects'

echo "BIN-BASH functions added"

## ----------------------------------------------
## 🧠 PATHS
## ----------------------------------------------

# 🔧 Projekt-Bin-Verzeichnis (automatisch ermittelt)
BIN_BASH_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -d "$BIN_BASH_PROJECT_DIR/bin" ]; then
  export PATH="$BIN_BASH_PROJECT_DIR/bin:$PATH"
fi


# 📁 Eigene Scriptsammlung (falls vorhanden)
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"


#export PATH="$HOME/.local/bin:$PATH"

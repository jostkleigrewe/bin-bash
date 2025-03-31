# 🐧 WSL Ubuntu 24.04 Entwicklungsumgebung für PHP-Developer


[![Author](https://img.shields.io/badge/Author-jostkleigrewe-blue)](https://github.com/jostkleigrewe)
[![Last Commit](https://img.shields.io/github/last-commit/jostkleigrewe/bin-bash)](https://github.com/jostkleigrewe/bin-bash/commits/master)
[![License](https://img.shields.io/github/license/jostkleigrewe/bin-bash)](https://github.com/jostkleigrewe/bin-bash/blob/master/LICENSE)
[![Stars](https://img.shields.io/github/stars/jostkleigrewe/bin-bash?style=social)](https://github.com/jostkleigrewe/bin-bash/stargazers)
[![Forks](https://img.shields.io/github/forks/jostkleigrewe/bin-bash?style=social)](https://github.com/jostkleigrewe/bin-bash/network/members)
[![Issues](https://img.shields.io/github/issues/jostkleigrewe/bin-bash)](https://github.com/jostkleigrewe/bin-bash/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/jostkleigrewe/bin-bash)](https://github.com/jostkleigrewe/bin-bash/pulls)
[![Language](https://img.shields.io/github/languages/top/jostkleigrewe/bin-bash)](https://github.com/jostkleigrewe/bin-bash/search?l=shell)

Dieses Projekt richtet sich an PHP-Entwickler, die eine **modulare Entwicklungsumgebung unter WSL2** mit Bash-Skripten aufbauen wollen.

Es stellt ein vollständiges Bash-basiertes Installations- und Konfigurations-Framework für eine moderne PHP-/Node-/Docker-Entwicklungsumgebung unter WSL (Windows Subsystem for Linux) bereit – mit sauberem Userkontext (nicht root).

---

## 🔧 Features & Tools

- 🐘 PHP 8.2 + 8.3 (mit `usephp82`, `usephp83`)
- 🎼 Composer
- 🟢 Node.js mit mehreren Versionen via NVM
- 🐳 Docker CLI & Compose
- 🎵 Symfony CLI
- 🧰 Viele nützliche Dev-Tools

---

## 🚀 Installationsplan

### 1. Voraussetzungen

- Windows 11 mit aktivierter WSL2-Unterstützung
- Windows Terminal und PowerShell

```powershell
# ----------------------------------------
# ⚙️  PowerShell (WSL installieren)
# ----------------------------------------
wsl --install
```

### 2. WSL-Distribution installieren

#### Option A – Benutzerverzeichnis (empfohlen, einfach)

Der einfache Weg: Du kannst die Distribution von Ubuntu direkt aus dem
Microsoft-Store in dein Benutzerverzeichnis installieren.

So listet du alle Distribution auf, die du auf diesem Wege installieren kannst.

```powershell
# ----------------------------------------
# ⚙️  Distribution auflisten (PowerShell)
# ----------------------------------------
wsl --list --online
```

In unserem Fall nehmen wir natürlich "Ubuntu-24.04" und istallieren die Distribution.


```powershell
# ----------------------------------------
# ⚙️  Ubuntu-24.04 installieren (PowerShell)
# ----------------------------------------
wsl --install -d Ubuntu-24.04
```

Dann öffnen wir ein Terminal und legen den Standard-Benutzer an.

Du wirst beim ersten Start nach einem Benutzer gefragt (z.B. `wsl`)
und musst dann zweimal ein Benutzerpasswort eingeben. Merke es dir
für die Sudo-Einrichtung im späteren Verlauf.

```powershell
# ----------------------------------------
# ⚙️  Ubuntu-24.04 Shell starten (PowerShell)
# ----------------------------------------
wsl -d Ubuntu-24.04
```

Logge dich nach dem Anlegen des neuen Benutzer aus.

```powershell
# ----------------------------------------
# ⚙️  Linux-Shell
# ----------------------------------------
exit
```


#### Option B – Individuelles Verzeichnis (z. B. D:\WSL\Ubuntu-2404)

Wenn du die WSL-Distribution nicht in deinem Benutzerverzeichnis von Windows
installiert haben möchtest, dann können wir auch ein ROOTFS importieren.
Hier kannst du den Namen und das Zielverzeichnis der Distribution anpassen.

Passe die folgenden Parameter deinen Wünschen entsprechend aus und führe sie
in einer Powershell aus.

```powershell
# ----------------------------------------
# ⚙️  KONFIGURATION (PowerShell)
# ----------------------------------------

# Name deiner neuen WSL-Distribution
$WSL_NAME   = "Ubuntu-2404-Distribution"

# Zielverzeichnis, in das die WSL-Instanz installiert wird
$TARGET_DIR = "D:\WSL\$WSL_NAME"

# Ort, an dem die RootFS gespeichert wird
$DOWNLOAD_DIR = "$HOME\Downloads"
$ROOTFS_NAME = "ubuntu-noble-wsl.rootfs.tar.gz"
$ROOTFS_PATH = "$DOWNLOAD_DIR\$ROOTFS_NAME"


# ----------------------------------------
# ⬇️  ROOTFS HERUNTERLADEN (falls nicht vorhanden)
# ----------------------------------------

cd $DOWNLOAD_DIR

if (-Not (Test-Path $ROOTFS_PATH)) {
    Write-Host "🔽 Lade Ubuntu RootFS herunter ..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://cloud-images.ubuntu.com/wsl/releases/24.04/current/$ROOTFS_NAME" -OutFile $ROOTFS_NAME
} else {
    Write-Host "✅ RootFS bereits vorhanden: $ROOTFS_PATH" -ForegroundColor Green
}


# ----------------------------------------
# 📦 WSL IMPORTIEREN
# ----------------------------------------

if (-Not (Test-Path $TARGET_DIR)) {
    Write-Host "📁 Erstelle Zielverzeichnis: $TARGET_DIR" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $TARGET_DIR | Out-Null
}

Write-Host "📦 Importiere WSL-Distribution '$WSL_NAME' ..." -ForegroundColor Cyan
wsl --import $WSL_NAME $TARGET_DIR $ROOTFS_PATH --version 2


# ----------------------------------------
# ▶️ WSL STARTEN
# ----------------------------------------

Write-Host "🚀 Starte Distribution '$WSL_NAME'" -ForegroundColor Cyan
wsl -d $WSL_NAME

```

(Auch als Script zum Download verfügbar unter [setup-wsl-ubuntu-2404.ps1](https://raw.githubusercontent.com/jostkleigrewe/bin-bash/master/setup-wsl-ubuntu-2404.ps1))

Wenn du mit `--import` arbeitest, startet WSL zunächst als `root`.


### 3. Installation des bin-bash Projekts

🧠 Hinweis: Im weiteren Verlauf gehe ich davon aus, das die Distribution "Ubuntu-24.04" heißt.

➡️ Führe diesen Befehl in deiner gestarteten Ubuntu-WSL-Distribution aus (nicht in PowerShell oder CMD):

Ubuntu-24.04 Shell starten:

```powershell
# ----------------------------------------
# ⚙️  Ubuntu-24.04 Shell starten (PowerShell)
# ----------------------------------------
wsl -d Ubuntu-24.04
```

Installationsscript starten:

```bash
# ----------------------------------------
# ⚙️  INSTALLATION DER BIN-BASH LIBRARY (Linux-Shell)
# ----------------------------------------
bash <(curl -s "https://raw.githubusercontent.com/jostkleigrewe/bin-bash/master/install.sh?ts=$(date +%s)")
```

🧠 Hinweise:

- Dieser Befehl lädt das Setup-Skript aus dem GitHub-Repository und führt es direkt aus.
- Das Skript erkennt, ob du als root oder als Benutzer gestartet bist, und richtet bei Bedarf automatisch den Benutzer wsl ein.
- Anschließend installiert es automatisch alle benötigten Tools (PHP, Node, Composer, Docker CLI, Symfony CLI etc.).

✅ Nach der Ausführung:

- Du erhältst einen Hinweis, ob ein Neustart notwendig ist (wsl --terminate).
- Danach kannst du sofort in deiner neuen Entwicklungsumgebung loslegen.

### Das Skript installiert:
- einen User (z. B. `wsl`) falls nötig
- PHP 8.2, 8.3 inkl. Module
- Composer, Node.js via NVM
- Docker CLI, Symfony CLI
- Git, Vim, xclip, ffmpeg etc.
- erweitert `.bashrc` um `bashrc.d`-Loader

### 4. Nach dem Setup (wenn root)

Falls das Skript einen neuen Benutzer anlegt, starte die Distribution über die Windows Shell neu:

```powershell
wsl --terminate Ubuntu-2404
wsl -d Ubuntu-2404
```

---

## 📘 WSL-Befehlsübersicht

| Aktion                         | Befehl                                 |
|--------------------------------|----------------------------------------|
| WSL installieren               | `wsl --install`                        |
| Distributionen anzeigen        | `wsl --list --online`                  |
| Installierte anzeigen          | `wsl --list --verbose`                 |
| Distribution starten           | `wsl -d <Name>`                        |
| Distribution beenden           | `wsl --terminate <Name>`               |
| Distribution löschen           | `wsl --unregister <Name>`              |
| Alle Distributionen stoppen    | `wsl --shutdown`                       |
| Standard setzen                | `wsl --set-default <Name>`             |

---


## 🧠 Hinweis

Das Setup wurde für WSL optimiert und ist nicht als generisches Linux-Installscript gedacht.

---

© [jostkleigrewe/bin-bash](https://github.com/jostkleigrewe/bin-bash)
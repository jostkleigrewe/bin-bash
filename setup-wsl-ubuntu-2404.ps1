# ----------------------------------------
# 🐧 Ubuntu 24.04 WSL Distribution Setup (PowerShell Script)
# ----------------------------------------

# ⚙️ KONFIGURATION
$WSL_NAME   = "Ubuntu-2404-Distribution"
$TARGET_DIR = "D:\WSL\$WSL_NAME"
$DOWNLOAD_DIR = "$HOME\Downloads"
$ROOTFS_NAME = "ubuntu-noble-wsl.rootfs.tar.gz"
$ROOTFS_PATH = "$DOWNLOAD_DIR\$ROOTFS_NAME"

# ⬇️ ROOTFS HERUNTERLADEN (nur wenn nicht vorhanden)
cd $DOWNLOAD_DIR
if (-Not (Test-Path $ROOTFS_PATH)) {
    Write-Host "🔽 Lade Ubuntu RootFS herunter ..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://cloud-images.ubuntu.com/wsl/releases/24.04/current/$ROOTFS_NAME" -OutFile $ROOTFS_NAME
} else {
    Write-Host "✅ RootFS bereits vorhanden: $ROOTFS_PATH" -ForegroundColor Green
}

# 📦 WSL IMPORTIEREN
if (-Not (Test-Path $TARGET_DIR)) {
    Write-Host "📁 Erstelle Zielverzeichnis: $TARGET_DIR" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $TARGET_DIR | Out-Null
}
Write-Host "📦 Importiere WSL-Distribution '$WSL_NAME' ..." -ForegroundColor Cyan
wsl --import $WSL_NAME $TARGET_DIR $ROOTFS_PATH --version 2

# ▶️ WSL STARTEN
Write-Host "🚀 Starte Distribution '$WSL_NAME'" -ForegroundColor Cyan
wsl -d $WSL_NAME

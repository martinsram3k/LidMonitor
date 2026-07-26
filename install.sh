#!/bin/bash

# Automatická instalace LidMonitor se všema potřebnými permisemi

set -e

echo "🔧 LidMonitor - Automatická instalace"
echo "======================================"
echo ""

PROJECT_DIR="$HOME/LidMonitor"

# Kontrola, zda je binární zkompilován
if [ ! -f "$PROJECT_DIR/lid-monitor" ]; then
    echo "❌ Chyba: lid-monitor binary se nenašel"
    echo "Nejdříve zkompilujte:"
    echo "  cd $PROJECT_DIR"
    echo "  swiftc -o lid-monitor LidMonitor.swift"
    exit 1
fi

echo "✅ Binární soubor nalezen"
chmod +x "$PROJECT_DIR/lid-monitor"

# Nastavení sudo oprávnění
echo ""
echo "🔐 Nastavuji sudo oprávnění..."

SUDOERS_FILE="/private/etc/sudoers.d/99_lidmonitor"

# Kontrola, zda je už nastaveno
if [ -f "$SUDOERS_FILE" ]; then
    echo "⚠️  Sudoers soubor už existuje"
else
    # Vytvoření dočasného souboru
    TEMP_FILE="/tmp/lidmonitor_sudoers.txt"
    
    cat > "$TEMP_FILE" << 'EOF'
ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset
ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript
EOF
    
    # Přesunutí a nastavení správných oprávnění
    sudo mv "$TEMP_FILE" "$SUDOERS_FILE"
    sudo chmod 0440 "$SUDOERS_FILE"
    
    echo "✅ Sudoers oprávnění nastavena"
fi

# Nastavení LaunchAgent
echo ""
echo "🚀 Nastavuji automatické spuštění..."

LAUNCHD_DIR="$HOME/Library/LaunchAgents"
PLIST_FILE="$LAUNCHD_DIR/com.user.lidmonitor.plist"

mkdir -p "$LAUNCHD_DIR"

# Kopírování plist souboru
cp "$PROJECT_DIR/com.user.lidmonitor.plist" "$PLIST_FILE"
chmod 644 "$PLIST_FILE"

# Načtení launchd služby
launchctl unload "$PLIST_FILE" 2>/dev/null || true
launchctl load "$PLIST_FILE"

echo "✅ LaunchAgent nakonfigurován"

echo ""
echo "======================================"
echo "✨ Instalace úspěšně dokončena!"
echo "======================================"
echo ""
echo "LidMonitor je nyní spuštěn a bude se automaticky spouštět při startu."
echo ""
echo "📊 Ověření:"
echo "  ps aux | grep lid-monitor"
echo ""
echo "📋 Logy:"
echo "  tail -f /var/log/lidmonitor.log"
echo "  tail -f /var/log/lidmonitor-error.log"
echo ""
echo "🛑 Zastavení:"
echo "  launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist"
echo "  killall lid-monitor"
echo ""

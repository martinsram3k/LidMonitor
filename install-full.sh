#!/bin/bash

# LidMonitor - Jednoduché nastavení a spuštění

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         🍎 LidMonitor - Instalační průvodce              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="$HOME/LidMonitor"

# Kontrola, zda project existuje
if [ ! -f "$PROJECT_DIR/lid-monitor" ]; then
    echo "❌ Chyba: Projekt nebyl nalezen na $PROJECT_DIR"
    echo ""
    echo "Ujistěte se, že projekt existuje v ~/LidMonitor/"
    exit 1
fi

echo "✅ Projekt nalezen: $PROJECT_DIR"
echo ""

# Nastavení sudo oprávnění
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  Nastavení sudo oprávnění"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Pro automatické spouštění příkazů bez hesla, budete muset zadat"
echo "své heslo jednou pro sudo konfiguraci:"
echo ""

SUDOERS_FILE="/private/etc/sudoers.d/99_lidmonitor"

if [ -f "$SUDOERS_FILE" ]; then
    echo "⚠️  Sudoers soubor již existuje"
    echo "   Cesta: $SUDOERS_FILE"
else
    # Vytvoříme dočasný soubor
    TEMP_FILE="/tmp/lidmonitor_sudoers.txt"
    
    cat > "$TEMP_FILE" << 'EOF'
ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset
ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript
EOF
    
    # Přesunutí a nastavení oprávnění s sudo
    echo "   Nastavujem sudo konfiguraci..."
    echo ""
    sudo mv "$TEMP_FILE" "$SUDOERS_FILE"
    sudo chmod 0440 "$SUDOERS_FILE"
    
    echo "✅ Sudo oprávnění nastavena"
fi

echo ""

# Nastavení LaunchAgent
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Nastavení automatického spuštění"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

LAUNCHD_DIR="$HOME/Library/LaunchAgents"
PLIST_FILE="$LAUNCHD_DIR/com.user.lidmonitor.plist"

mkdir -p "$LAUNCHD_DIR"

# Kopírování plist souboru
if [ -f "$PLIST_FILE" ]; then
    echo "⚠️  LaunchAgent soubor již existuje"
else
    cp "$PROJECT_DIR/com.user.lidmonitor.plist" "$PLIST_FILE"
    chmod 644 "$PLIST_FILE"
    echo "✅ LaunchAgent zkopírován"
fi

echo ""

# Načtení launchd služby
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  Spuštění služby"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Nejdříve se pokusíme zrušit existující
launchctl unload "$PLIST_FILE" 2>/dev/null || true
sleep 1

# Pak ji načteme
launchctl load "$PLIST_FILE"

echo "✅ Služba spuštěna"
echo ""

# Ověření
sleep 2
if pgrep -f "lid-monitor" > /dev/null; then
    PID=$(pgrep -f "lid-monitor")
    echo "✅ LidMonitor běží (PID: $PID)"
else
    echo "⚠️  LidMonitor se nespustil - zkontrolujte logy"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              ✨ Instalace úspěšně dokončena!             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Užitečné příkazy:"
echo ""
echo "   Kontrola stavu:"
echo "   $ launchctl list | grep lidmonitor"
echo ""
echo "   Prohlížení logů:"
echo "   $ tail -f /var/log/lidmonitor.log"
echo ""
echo "   Zastavení:"
echo "   $ launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist"
echo ""
echo "   Restart:"
echo "   $ launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist"
echo "   $ launchctl load ~/Library/LaunchAgents/com.user.lidmonitor.plist"
echo ""
echo "📖 Více informací: $PROJECT_DIR/README.md"
echo ""

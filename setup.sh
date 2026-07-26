#!/bin/bash

# Skript pro monitoring stavu MacBooku a automatické nastavení spánku/jasu

echo "⚙️  LidMonitor - Setup"
echo "===================="
echo ""

# Kontrola, zda je binární spustitelný
if [ ! -x "$(dirname "$0")/lid-monitor" ]; then
    echo "❌ Binární soubor se nenašel nebo není spustitelný"
    echo "Zkompilujte nejdříve: cd $(dirname "$0") && swiftc -o lid-monitor LidMonitor.swift"
    exit 1
fi

echo "✅ Binární soubor nalezen"
echo ""

# Nastavení sudoers
echo "🔐 Nastavování sudo oprávnění..."
echo ""
echo "Pro automatické spuštění pmset bez hesla, musíte spustit:"
echo ""
echo "  sudo visudo -f /etc/sudoers.d/99_lidmonitor"
echo ""
echo "A přidat následující řádky:"
echo "  ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset"
echo "  ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript"
echo ""
echo "Nebo spusťte přímo:"
echo "  echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset' | sudo tee /etc/sudoers.d/99_lidmonitor"
echo "  echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript' | sudo tee -a /etc/sudoers.d/99_lidmonitor"
echo "  sudo chmod 0440 /etc/sudoers.d/99_lidmonitor"
echo ""
echo "===================="
echo ""
echo "🚀 Spuštění LidMonitor:"
echo ""
echo "Manuálně (testování):"
echo "  cd $(dirname "$0") && ./lid-monitor"
echo ""
echo "Automaticky při startu:"
echo "  cp $(dirname "$0")/com.user.lidmonitor.plist ~/Library/LaunchAgents/"
echo "  launchctl load ~/Library/LaunchAgents/com.user.lidmonitor.plist"
echo ""


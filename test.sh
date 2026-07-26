#!/bin/bash

# Test skript pro LidMonitor - testuje bez sudo

echo "🧪 LidMonitor - Test mód"
echo "========================"
echo ""

PROJECT_DIR="$HOME/LidMonitor"

if [ ! -f "$PROJECT_DIR/lid-monitor" ]; then
    echo "❌ Binární soubor se nenašel"
    exit 1
fi

echo "🔍 Testování senzoru..."
echo ""

# Test 1: Kontrola dostupnosti senzoru
echo "1. Kontrola AppleClamshellState senzoru:"
if ioreg -p IOService -n AppleClamshellState 2>/dev/null | grep -i clamshell > /dev/null; then
    echo "   ✅ Senzor nalezen"
else
    echo "   ⚠️  Senzor nenalezen - zkouším alternativu"
fi

echo ""
echo "2. Kontrola pmset:"
if pmset -g | grep -i clamshell > /dev/null; then
    echo "   ✅ pmset config nalezen"
    pmset -g | grep -i clamshell
else
    echo "   ⚠️  pmset config nenalezen"
fi

echo ""
echo "3. Spuštění aplikace v TEST módu (5 sekund)..."
echo ""

# Spuštění aplikace na 5 sekund
timeout 5 "$PROJECT_DIR/lid-monitor" 2>&1 || true

echo ""
echo "✅ Test mód ukončen"

# 🍎 LidMonitor - MacBook Clamshell Sensor Monitor

Automatická aplikace pro macOS, která monitoruje zavírání/otevírání MacBooku a reaguje na změny stavu.

## ✨ Funkcionalita

### Když se MacBook zavírá 🔒:
- Zakáže spánek: `sudo pmset -a disablesleep 1`
- Sníží jas na 0%

### Když se MacBook otevírá ✅:
- Povolí spánek: `sudo pmset -a disablesleep 0`
- Obnoví jas na 80%

## 📋 Požadavky

- macOS 10.15+
- Swift 5.5+ (obvykle včetně Command Line Tools)
- Sudo přístup (pro `pmset` a `osascript`)

## 🚀 Instalace

### 1️⃣ Příprava

Zkopírujte projekt do domovského adresáře:

```bash
# Projekt je v ~/LidMonitor
cd ~/LidMonitor
```

### 2️⃣ Kompilace

Aplikace je již zkompilována, ale pokud potřebujete znovu zkompilovat:

```bash
swiftc -o lid-monitor LidMonitor.swift
```

### 3️⃣ Nastavení sudo oprávnění (DŮLEŽITÉ!)

Aby aplikace mohla spouštět `pmset` bez průběžného dotazování na heslo, nastavte sudo:

```bash
# Možnost A: Automaticky (vyžaduje heslo)
echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset' | sudo tee /etc/sudoers.d/99_lidmonitor
echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript' | sudo tee -a /etc/sudoers.d/99_lidmonitor
sudo chmod 0440 /etc/sudoers.d/99_lidmonitor

# Možnost B: Manuálně
sudo visudo -f /etc/sudoers.d/99_lidmonitor
# Přidejte tyto řádky:
# ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset
# ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript
```

### 4️⃣ Spuštění aplikace

#### Manuálně (pro testování):
```bash
~/LidMonitor/lid-monitor
```

#### Automaticky při startu (doporučeno):

Kopírujte launch agent:
```bash
cp ~/LidMonitor/com.user.lidmonitor.plist ~/Library/LaunchAgents/
```

Zapните ho:
```bash
launchctl load ~/Library/LaunchAgents/com.user.lidmonitor.plist
```

Ověřte, že běží:
```bash
ps aux | grep lid-monitor
```

## 📊 Monitorování

### Kontrola, zda aplikace běží:
```bash
ps aux | grep lid-monitor
```

### Prohlížení logů:
```bash
tail -f /var/log/lidmonitor.log
tail -f /var/log/lidmonitor-error.log
```

### Kontrola stavu launchd služby:
```bash
launchctl list | grep lidmonitor
```

## 🛑 Zastavení / Odinstalace

### Zastavit dočasně:
```bash
killall lid-monitor
```

### Vypnout automatické spuštění:
```bash
launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist
```

### Kompletní odinstalace:
```bash
launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist
rm ~/Library/LaunchAgents/com.user.lidmonitor.plist
sudo rm /etc/sudoers.d/99_lidmonitor
```

## 🔧 Řešení problémů

### Aplikace se nespustí
```bash
# Zkontrolujte, zda je binární spustitelný
ls -la ~/LidMonitor/lid-monitor

# Nastavte práva
chmod +x ~/LidMonitor/lid-monitor
```

### Senzor se nedetekuje
```bash
# Zkontrolujte dostupnost senzoru
ioreg -p IOService -n AppleClamshellState

# Alternativní příkazy:
pmset -g
system_profiler SPHardwareDataType
```

### Jas se nemění
```bash
# Zkontrolujte, zda máte přístup k nastavení obrazovky
osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to 80'

# Možná bude potřeba třeba v System Preferences > Security & Privacy
# povolit Assistive Device přístup pro osascript
```

### PMSet příkazy nefungují
```bash
# Zkontrolujte práva
sudo pmset -a disablesleep 1

# Pokud funguje se sudo, ale ne z aplikace, zkontrolujte
# /etc/sudoers.d/99_lidmonitor
cat /etc/sudoers.d/99_lidmonitor
```

## 📝 Poznámky

- **Bezpečnost**: Soubor `99_lidmonitor` povoluje spouštění `pmset` a `osascript` bez hesla. To je bezpečné pro osobní počítač.
- **Výkon**: Aplikace kontroluje stav každých 2 sekundy. To má minimální dopad na výkon.
- **Kompatibilita**: Byla testována na macOS 12+, měla by fungovat i na starších verzích.

## 📜 Licence

MIT - Volně k použití a úpravám.

---

Vytvořeno pro macOS s ❤️


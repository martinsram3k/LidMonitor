# 🧪 LidMonitor - Testing Tutorial

Praktický návod jak vyzkoušet aplikaci na tvém MacBooku.

## ⏱️ Doba: ~10 minut

---

## 1️⃣ Ověření požadavků (2 minuty)

Nejdřív si zkontroluj, zda máš všechno potřebné:

### A) Git a GitHub CLI
```bash
git --version
gh auth status
```

Měl by ti ukázat, že jsi přihlášený na GitHub.

### B) Swift kompilátor
```bash
swift --version
```

Měl by vrátit verzi (např. `Swift version 5.8`). Pokud ne:
```bash
xcode-select --install
```

✅ Všechno máš? Jdeme dál!

---

## 2️⃣ Klonování projektu (1 minuta)

```bash
cd ~
git clone https://github.com/martinsram3k/LidMonitor.git
cd LidMonitor
```

Zkontroluj, že projektu existuje:
```bash
ls -la
```

Měl bys vidět:
```
README.md
LidMonitor.swift
lid-monitor (zkompilovaný binární)
install-full.sh
com.user.lidmonitor.plist
...
```

---

## 3️⃣ Testování bez instalace (3 minuty)

Teď si aplikaci vyzkoušíme bez permanentní instalace.

### A) Spusti aplikaci manuálně
```bash
cd ~/LidMonitor
./lid-monitor
```

Měl bys vidět:
```
🔍 LidMonitor spuštěn - sledování stavu MacBooku...
   Detekce: monitorování stavů spánku a probouzení
```

✅ Aplikace běží! Teď ji testujeme.

### B) Otevři nový Terminal (druhé okno)

V novém terminálu si můžeš sledovat co se děje:

```bash
# Sleduj logy (pokud existují)
tail -f /var/log/lidmonitor.log 2>/dev/null || echo "Logy zatím neexistují"

# Nebo sleduj procesy
watch "ps aux | grep lid-monitor"
```

### C) Fyzický test - Zavírání/Otevírání MacBooku

1. **Zavři lid** MacBooku (aplikace v prvním terminálu by měla reagovat)
2. Čekej 2-3 sekundy
3. **Otevři lid** MacBooku
4. Sleduj co se stane v terminálu

### D) Manuální test příkazů

Pokud chceš vidět příkazy přímo, spusť je ručně:

```bash
# Test zmrazení spánku (POZOR: MacBook nebude spáti!)
sudo pmset -a disablesleep 1
sleep 3

# Vrátit spánek do normálu
sudo pmset -a disablesleep 0

# Test jasu
osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to 0'
sleep 2

osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to 80'
```

---

## 4️⃣ Zastavení testování (1 minuta)

### Zastaví aplikaci
V prvním terminálu (kde běží `./lid-monitor`) stiskni:
```
CTRL + C
```

Měl bys vidět:
```
^C
% 
```

✅ Aplikace je zastavená.

---

## 5️⃣ Instalace pro automatické spuštění (3 minuty) - OPTIONAL

Pokud se ti aplikace líbí, můžeš ji nainstalovat tak, aby se spouštěla automaticky:

```bash
cd ~/LidMonitor
chmod +x install-full.sh
./install-full.sh
```

Skript ti požádá o heslo pro sudo konfiguraci. Vše ostatní se provede automaticky.

### Ověření instalace
```bash
# Běží aplikace?
ps aux | grep lid-monitor

# Je registrovaná jako launchd služba?
launchctl list | grep lidmonitor

# Podívej se na logy
tail -20 /var/log/lidmonitor.log
```

---

## 6️⃣ Co teď vyzkoušet

### ✅ Test 1: Základní funkce
- [ ] Spustit aplikaci
- [ ] Zavřít MacBook lid
- [ ] Otevřít MacBook lid
- [ ] Vidět zprávy v terminálu

### ✅ Test 2: Jas
- [ ] Při zavření se jas sníží
- [ ] Při otevření se jas obnoví

### ✅ Test 3: Spánek
- [ ] Zkontrolovat `pmset -g | grep disablesleep`
- [ ] Mělo by se měnit mezi 0 a 1

### ✅ Test 4: Logy
- [ ] `tail -f /var/log/lidmonitor.log`
- [ ] Vidět zprávy při změně stavu

---

## 7️⃣ Troubleshooting během testování

### Problem: "Permission denied" při spuštění
```bash
chmod +x ~/LidMonitor/lid-monitor
./lid-monitor
```

### Problem: "Command not found: swift"
```bash
xcode-select --install
```

### Problem: Nic se neděje při zavření/otevření
```bash
# Zkontroluj, zda senzor existuje
ioreg -p IOService -n AppleClamshellState | head -5

# Nebo
pmset -g | grep -i clamshell
```

### Problem: Chyba s osascript (jas)
```bash
# Ručně test
osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to 50'

# Pokud to nefunguje, možná je potřeba
# System Preferences > Security & Privacy > Accessibility
# Přidat Terminal do seznamu aplikací
```

---

## 📊 Co vidíš v terminálu - Vysvětlení

```
🔍 LidMonitor spuštěn - sledování stavu MacBooku...
   Detekce: monitorování stavů spánku a probouzení

✅ [12:30:45] MacBook OPENED - restoring normal mode
   → Příkaz: osascript -e '...' [Status: 0]
   → Příkaz: sudo pmset -a disablesleep 0 [Status: 0]

🔒 [12:30:52] MacBook CLOSED - starting sleep mode
   → Příkaz: sudo pmset -a disablesleep 1 [Status: 0]
   → Příkaz: osascript -e '...' [Status: 0]
```

- ✅ = MacBook se otevřel
- 🔒 = MacBook se zavřel
- `[Status: 0]` = Příkaz se úspěšně provedl
- Časové razítko = Kdy se to stalo

---

## 🎯 Očekávaný výsledek

Po spuštění aplikace a zavření/otevření MacBooku:

1. ✅ Vidíš zprávy v terminálu
2. ✅ Jas se změní
3. ✅ Spánek se zapne/vypne
4. ✅ Žádné chyby v logy

---

## 🧹 Vyčištění po testování

### Pokud jsi NEINSTALOVAL aplikaci
```bash
# Prostě CTRL+C v terminálu a hotovo
# Nic se neinstaluje, nic se nemění v systému
```

### Pokud jsi INSTALOVAL aplikaci
```bash
# Zastavit aplikaci
launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist

# Smazat sudo konfiguraci
sudo rm /etc/sudoers.d/99_lidmonitor

# Smazat launchd konfiguraci
rm ~/Library/LaunchAgents/com.user.lidmonitor.plist
```

---

## ❓ Často Kladené Otázky

**Q: Bude aplikace sežrat baterii?**
A: Ne, používá minimálně zdrojů. Kontroluje jen každé 2 sekundy.

**Q: Je to bezpečné?**
A: Ano. Jenom zmrazuje spánek a mění jas. Žádný přístup k datům.

**Q: Mohu to spouštět na pozadí?**
A: Ano, to je přesně to, k čemu je `install-full.sh` - instaluje to jako službu.

**Q: Co se stane, když aplikace spadne?**
A: Pokud je instalovaná jako launchd služba, restartuje se automaticky.

**Q: Mohu si upravit jas/ostatní nastavení?**
A: Ano! Edituj `LidMonitor.swift` a změň hodnoty v funkcích.

---

## ✨ Další kroky po testování

1. **Přispívání kódem?**
   - Forkni repository
   - Udělej změny
   - Vytvoř Pull Request

2. **Našel si bug?**
   - Otevři GitHub Issue
   - Popři přesně co se stalo

3. **Máš nápad na feature?**
   - Vytvoř Feature Request issue
   - Diskutuj s ostatními

4. **Chceš aplikaci sdílet?**
   - Sharey GitHub link
   - Doporuči ji MacBook uživatelům

---

## 📞 Potřebuješ pomoc?

- **GitHub Issues**: https://github.com/martinsram3k/LidMonitor/issues
- **README**: https://github.com/martinsram3k/LidMonitor/blob/main/README.md
- **Installation Guide**: https://github.com/martinsram3k/LidMonitor/blob/main/INSTALLATION.md

---

**Enjoy! 🍎** Máš všechno co potřebuješ pro testování!

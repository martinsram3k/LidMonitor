import Foundation

class LidMonitor {
    private var lastLidState: Bool? = nil
    private let checkInterval: TimeInterval = 2.0
    
    func start() {
        print("🔍 LidMonitor spuštěn - sledování stavu MacBooku...")
        print("   Detekce: monitorování stavů spánku a probouzení\n")
        
        // Spustíme monitoring v hlavní smyčce
        monitorSystemEvents()
    }
    
    private func monitorSystemEvents() {
        // Monitorujeme stav přes IOKit notifikace a pravidelné kontroly
        
        // Spustíme pravidelné kontroly v pozadí
        let thread = Thread {
            while true {
                self.checkLidStateViaSystemEvents()
                Thread.sleep(forTimeInterval: self.checkInterval)
            }
        }
        thread.start()
        
        // Udržujeme aplikaci živou
        RunLoop.main.run()
    }
    
    private func checkLidStateViaSystemEvents() {
        // Kontrolujeme stav přes kern.wakereason a log soubory
        
        if let isOpen = readClamshellState() {
            if self.lastLidState != isOpen {
                self.lastLidState = isOpen
                handleLidStateChange(isOpen: isOpen)
            }
        }
    }
    
    private func readClamshellState() -> Bool? {
        // Zkusíme detekovat stav z více zdrojů
        
        // 1. Kontrola ioreg
        if let state = checkIOReg() {
            return state
        }
        
        // 2. Kontrola system logů
        if let state = checkSystemLogs() {
            return state
        }
        
        // 3. Kontrola IOKit registry
        if let state = checkIOKitRegistry() {
            return state
        }
        
        return nil
    }
    
    private func checkIOReg() -> Bool? {
        let task = Process()
        task.launchPath = "/usr/sbin/ioreg"
        task.arguments = ["-p", "IOService", "-n", "AppleClamshellState", "-r"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)?.lowercased() ?? ""
            
            if output.contains("\"clamshellstate\" = 1") || output.contains("\"clamshelllid\" = 1") {
                return false // Zavřený
            } else if output.contains("\"clamshellstate\" = 0") || output.contains("\"clamshelllid\" = 0") {
                return true // Otevřený
            }
        } catch {
            // Ignorujeme chyby
        }
        
        return nil
    }
    
    private func checkIOKitRegistry() -> Bool? {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "ioreg -c IOHIDDevice | grep -i 'clamshell\\|screen' | head -5"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            if !output.isEmpty {
                // Pokud je výstup s HID zařízeními, potom je MacBook otevřený
                return true
            }
        } catch {
            // Ignorujeme chyby
        }
        
        return nil
    }
    
    private func checkSystemLogs() -> Bool? {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "log show --predicate 'eventMessage contains \"clamshell\" or eventMessage contains \"lid\" or eventMessage contains \"display\"' --last 30s 2>/dev/null | tail -1"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)?.lowercased() ?? ""
            
            if output.contains("close") || output.contains("closed") {
                return false
            } else if output.contains("open") || output.contains("opened") {
                return true
            }
        } catch {
            // Ignorujeme chyby
        }
        
        return nil
    }
    
    private func handleLidStateChange(isOpen: Bool) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        
        if isOpen {
            print("✅ [\(timestamp)] MacBook OTEVŘEN - obnovuji normální režim")
            enableSleep()
            restoreBrightness()
        } else {
            print("🔒 [\(timestamp)] MacBook ZAVŘEN - spouštím režim spánku")
            disableSleep()
            setBrightness(to: 0)
        }
    }
    
    private func disableSleep() {
        executeCommand("sudo pmset -a disablesleep 1")
    }
    
    private func enableSleep() {
        executeCommand("sudo pmset -a disablesleep 0")
    }
    
    private func setBrightness(to value: Int) {
        let script = """
        osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to \(value)'
        """
        executeCommand(script)
    }
    
    private func restoreBrightness() {
        let script = """
        osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to 80'
        """
        executeCommand(script)
    }
    
    private func executeCommand(_ command: String) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        do {
            try task.run()
            task.waitUntilExit()
            let status = task.terminationStatus
            print("   → Příkaz: \(command) [Status: \(status)]")
        } catch {
            print("❌ Chyba při spuštění: \(error)")
        }
    }
}

let monitor = LidMonitor()
monitor.start()

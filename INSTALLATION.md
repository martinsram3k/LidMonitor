# Installation Guide

## Supported Systems

- macOS 10.15 (Catalina) or later
- Works on Intel and Apple Silicon Macs

## Prerequisites

- Administrator access on your Mac
- Terminal access
- Git (for cloning)

## Step-by-Step Installation

### Option 1: Automatic Installation (Recommended)

#### 1. Clone the Repository
```bash
git clone https://github.com/martinsram3k/LidMonitor.git
cd LidMonitor
```

#### 2. Run Installation Script
```bash
chmod +x install-full.sh
./install-full.sh
```

**What this script does:**
- ✅ Configures sudo permissions
- ✅ Sets up LaunchAgent for auto-start
- ✅ Starts the service
- ✅ Verifies installation

The script will prompt you for your password once for sudo configuration.

#### 3. Verify Installation
```bash
ps aux | grep lid-monitor
```

You should see the `lid-monitor` process running.

---

### Option 2: Manual Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/martinsram3k/LidMonitor.git
cd LidMonitor
```

#### 2. Compile from Source
```bash
swiftc -o lid-monitor LidMonitor.swift
```

**Note:** This requires Xcode Command Line Tools. If you don't have them:
```bash
xcode-select --install
```

#### 3. Configure Sudo Permissions

To run commands without requiring your password every time:

```bash
# Create sudoers configuration
echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/pmset' | sudo tee /etc/sudoers.d/99_lidmonitor
echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/osascript' | sudo tee -a /etc/sudoers.d/99_lidmonitor

# Set proper permissions (read-only)
sudo chmod 0440 /etc/sudoers.d/99_lidmonitor
```

**Verify sudoers configuration:**
```bash
sudo cat /etc/sudoers.d/99_lidmonitor
```

#### 4. Set Up Auto-Start (LaunchAgent)

```bash
# Copy the plist file to LaunchAgents directory
cp com.user.lidmonitor.plist ~/Library/LaunchAgents/

# Set proper permissions
chmod 644 ~/Library/LaunchAgents/com.user.lidmonitor.plist

# Load the service
launchctl load ~/Library/LaunchAgents/com.user.lidmonitor.plist
```

#### 5. Verify It's Running

```bash
# Check if process is running
ps aux | grep lid-monitor

# Check LaunchAgent status
launchctl list | grep lidmonitor
```

---

## Post-Installation

### Check Status
```bash
launchctl list | grep lidmonitor
```

### View Logs
```bash
# Main log
tail -f /var/log/lidmonitor.log

# Error log
tail -f /var/log/lidmonitor-error.log

# Last 50 lines
tail -50 /var/log/lidmonitor.log
```

### Test Functionality
1. Open your MacBook lid
2. Close your MacBook lid
3. Wait a few seconds
4. Check logs to see state changes

Example log output:
```
✅ [12:30:45] MacBook OPENED - restoring normal mode
🔒 [12:30:52] MacBook CLOSED - starting sleep mode
```

---

## First-Time Setup Checklist

- [ ] Repository cloned successfully
- [ ] Application compiled without errors
- [ ] Sudo permissions configured
- [ ] LaunchAgent installed
- [ ] Service is running (`ps aux | grep lid-monitor`)
- [ ] Logs show no errors (`tail -f /var/log/lidmonitor.log`)
- [ ] Opening/closing lid triggers state changes

---

## Troubleshooting Installation

### "Permission denied" when running script
```bash
# Make scripts executable
chmod +x install-full.sh
chmod +x install.sh
```

### "Command not found: swiftc"
```bash
# Install Xcode Command Line Tools
xcode-select --install
```

### "sudo: /etc/sudoers.d/99_lidmonitor: syntax error"
```bash
# Check syntax
sudo visudo -c -f /etc/sudoers.d/99_lidmonitor

# If error, edit manually
sudo visudo -f /etc/sudoers.d/99_lidmonitor
```

### LaunchAgent won't load
```bash
# Unload and try again
launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist

# Wait a second
sleep 1

# Load again
launchctl load ~/Library/LaunchAgents/com.user.lidmonitor.plist

# Check for errors
launchctl list | grep lidmonitor
```

### Binary won't compile
```bash
# Make sure Swift compiler is available
swift --version

# If not installed, install Command Line Tools
xcode-select --install

# Then try compiling again
swiftc -o lid-monitor LidMonitor.swift
```

---

## Uninstalling

### Quick Uninstall
```bash
# Stop the service
launchctl unload ~/Library/LaunchAgents/com.user.lidmonitor.plist

# Remove files
rm ~/Library/LaunchAgents/com.user.lidmonitor.plist
sudo rm /etc/sudoers.d/99_lidmonitor

# Optional: Remove the entire project directory
rm -rf ~/LidMonitor
```

### Cleanup
```bash
# Remove logs (optional)
rm /var/log/lidmonitor.log
rm /var/log/lidmonitor-error.log
```

---

## Next Steps

- Read the [README](README_EN.md) for detailed usage
- Check [Contributing Guide](CONTRIBUTING.md) if you want to contribute
- Open an issue if you encounter any problems

---

## Getting Help

### Documentation
- [README_EN.md](README_EN.md) - Full documentation
- [CONTRIBUTING.md](CONTRIBUTING.md) - Development guide
- [LICENSE](LICENSE) - MIT License

### Support
- GitHub Issues: [Report problems](https://github.com/martinsram3k/LidMonitor/issues)
- Discussions: [Ask questions](https://github.com/martinsram3k/LidMonitor/discussions)

---

Happy monitoring! 🍎

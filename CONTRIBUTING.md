# Contributing to LidMonitor

Thank you for your interest in contributing to LidMonitor! We welcome contributions from everyone.

## Code of Conduct

- Be respectful and inclusive
- Focus on the code, not the person
- Help others learn and grow
- Report issues constructively

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/LidMonitor.git
   cd LidMonitor
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Prerequisites
- macOS 10.15+
- Swift 5.5+ (via Xcode Command Line Tools)
- Git

### Compiling
```bash
swiftc -o lid-monitor LidMonitor.swift
```

### Testing
```bash
# Run the application manually
./lid-monitor

# Check it detects state changes
# Open and close your MacBook lid
```

### Code Style

- Keep the code clean and readable
- Add comments only where necessary (code should be self-documenting)
- Use Swift naming conventions
- Follow existing code patterns

### Making Changes

1. Make your changes in a feature branch
2. Test thoroughly on your MacBook
3. Ensure the binary still compiles without errors
4. Write a clear commit message:
   ```bash
   git commit -m "Add feature: clear description of what was added"
   ```

## Commit Message Guidelines

- Use present tense: "Add feature" not "Added feature"
- Use imperative mood: "Move cursor to" not "Moves cursor to"
- Limit first line to 50 characters
- Reference issues and pull requests liberally after the first line

Examples:
```
Add support for external displays
Fix brightness detection on M1 Macs
Improve clamshell sensor polling accuracy
Update documentation for installation
```

## Types of Contributions

### Bug Fixes 🐛
- Identify the bug
- Create an issue if one doesn't exist
- Write a clear fix
- Test thoroughly
- Submit a PR

### New Features ✨
- Discuss the feature idea in an issue first
- Implement following the code style
- Add any necessary documentation
- Test on multiple macOS versions if possible

### Documentation 📝
- Fix typos or clarify explanations
- Add examples
- Improve organization
- Translate to other languages

### Performance Improvements ⚡
- Profile before optimizing
- Show measurable improvements
- Don't sacrify readability

## Pull Request Process

1. **Update the README** if you're adding new features
2. **Add comments** to complex logic
3. **Test your changes** thoroughly
4. **Write a clear PR description**:
   - What does it do?
   - Why is it needed?
   - How to test it?

5. **Link related issues** in the PR description:
   ```
   Fixes #123
   Related to #456
   ```

6. **Be responsive** to review feedback

## Review Process

- At least one maintainer will review your PR
- Be patient - reviews take time
- Address feedback constructively
- Push updates to your branch (no need to create new PR)

## Reporting Issues

### Before Creating an Issue
- Search existing issues to avoid duplicates
- Check the troubleshooting section in README

### When Creating an Issue
Include:
- **macOS version** (e.g., Sonoma 14.1)
- **MacBook model** (e.g., MacBook Pro 14", M2)
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **Relevant logs** (from `/var/log/lidmonitor.log`)

Example:
```markdown
**macOS Version:** Sonoma 14.1
**MacBook:** MacBook Pro 14" (M2, 2022)

**Steps to reproduce:**
1. Start LidMonitor
2. Close the lid
3. Wait 5 seconds
4. Open the lid

**Expected:** Brightness should restore to 80%
**Actual:** Brightness stays at 0%

**Logs:**
[paste relevant logs here]
```

## Development Tips

### Debugging

Run with verbose output:
```bash
./lid-monitor
# Watch for state change messages
```

Check system logs:
```bash
tail -f /var/log/lidmonitor.log
```

Monitor processes:
```bash
ps aux | grep lid-monitor
```

### Testing State Changes

```bash
# Check current clamshell state
ioreg -p IOService -n AppleClamshellState

# Check power settings
pmset -g

# Test brightness command
osascript -e 'tell application "System Events" to set brightness of (first display whose enabled is true) to 50'
```

## Areas for Contribution

- [ ] Support for multiple displays
- [ ] Configuration file support
- [ ] GUI settings app
- [ ] Additional language translations
- [ ] Performance optimizations
- [ ] Enhanced sensor detection
- [ ] User documentation
- [ ] CI/CD pipeline setup

## Questions?

- Open a GitHub discussion
- Create an issue with the `question` label
- Check existing issues and PRs first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make LidMonitor better! 🙏

# countdown

[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square)](https://github.com/Wilgat/countdown)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

**Lightweight, per-user named countdown timers** for the terminal.  
Extremely robust, zero dependencies, and built with a strong defensive philosophy to survive harsh environments.

---

## ✨ Features

- **Per-user isolation** — each user has completely independent timers
- **Named countdowns** — `default`, `work`, `pomodoro`, `meeting`, `build`, etc.
- **Two storage modes**:
  - **Volatile** (default): Fast in-memory storage using `/dev/shm`
  - **Persistent** (`--persist`): Survives reboots (`~/.cache/countdown/`)
- Smart fallbacks for `/dev/shm`, missing `$HOME`, restricted containers, and Git Bash
- One-liner install via `curl | sh`
- Supports both user (`~/.local/bin`) and system-wide (`/usr/local/bin`) installation
- Built-in self-update, version check, and diagnostics (`about`)
- Full **JSON output** support for scripting and automation
- Works reliably on minimal shells (`dash`, BusyBox `ash`) and edge-case environments

---

## 🚀 Quick Installation

**For normal users (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

**System-wide installation (requires root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sudo sh
```

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`) so `~/.local/bin` is added to your `$PATH`.

---

## 📖 Usage

### Core Commands

```sh
countdown start 25m                    # Start default countdown for 25 minutes
countdown start work 1h30m             # Start named countdown
countdown start --persist pomodoro 25m # Persistent countdown (flag anywhere)

countdown status                       # Show remaining time for default
countdown status work

countdown stop                         # Stop and report remaining time
countdown stop work

countdown list                         # List active volatile countdowns
countdown list --persist               # List active persistent countdowns

countdown kill work                    # Discard a countdown
countdown reset work                   # Same as kill (friendlier message)
```

### Maintenance & Info

```sh
countdown about           # Show installation diagnostics and environment info
countdown version
countdown version-check   # Compare local vs latest GitHub version
countdown self-update     # Update to the latest version
countdown self-uninstall  # Remove from the system
countdown help
```

### Options

- `--persist`      — Use persistent storage (survives reboot)
- `--quiet, -q`    — Suppress all non-error messages
- `--json`         — Output machine-readable JSON (implies `--quiet`)

### Duration Formats

- `25m` → 25 minutes
- `90s` → 90 seconds
- `1h30m` → 1 hour 30 minutes
- `2h15m45s` → 2 hours 15 min 45 sec
- `45` → 45 seconds (plain number is treated as seconds)

---

## Examples

```sh
# Start a 25-minute Pomodoro
countdown start --persist pomodoro 25m

# Check status in JSON (perfect for scripts)
countdown status work --json

# List all active timers
countdown list

# Stop quietly
countdown stop --quiet default
```

---

## Why So Defensive?

This script is **intentionally verbose** and heavily commented.  

The repetition and safety checks exist to handle real-world edge cases reliably:
- `curl | sh` in non-interactive shells
- Minimal environments (Alpine, BusyBox `ash`, Git Bash)
- Missing `$HOME` or `/dev/shm`
- Containers with restricted filesystems

The many `!!! DO NOT MODIFY OR SIMPLIFY !!!` warnings protect against well-meaning "cleanups" that often break subtle but critical behaviors. This same philosophy powers other tools by Wilgat.

It may look over-engineered, but it has proven extremely reliable across diverse systems.

---

## Platform Compatibility

| Platform              | Shell                | Status     | Notes                              |
|-----------------------|----------------------|------------|------------------------------------|
| Alpine Linux          | BusyBox ash          | Excellent  | Primary minimal target             |
| Git Bash (Windows)    | Bash                 | Excellent  | Full fallback support              |
| Rocky Linux / RHEL    | Bash                 | Excellent  | Enterprise environments            |
| macOS                 | Bash / zsh           | Excellent  | Fully supported                    |
| Most Linux distros    | dash / bash          | Excellent  | Broad compatibility                |

---

## Project Philosophy

The entire tool is a **single self-contained shell script**.  
All output goes through centralized functions (`output_text` and `output_json`). Storage decisions are handled by one smart resolver with intelligent fallbacks.  

This design keeps the code maintainable while prioritizing robustness over elegance.

---

## Contributing

Contributions are welcome!  

Please **preserve the defensive style** and existing safety comments — especially around installation, output handling, and storage fallbacks.

---

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

**Made with care and a healthy dose of paranoia.** ⏱️

*Last updated April 2026*

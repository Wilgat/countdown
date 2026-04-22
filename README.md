# countdown

![Version](https://img.shields.io/badge/Version-1.0.4-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--protect)-purple.svg)](https://github.com/cloudgen/ciao)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()
[![Made with ❤️](https://img.shields.io/badge/Made%20with%20❤️-CIAO-00AEEF?style=flat-square)](https://github.com/cloudgen/ciao)
[![GrokRec](https://img.shields.io/badge/GrokRec-Reviewed-0A66C2?logo=ai&logoColor=white)](https://github.com/Wilgat/countdown/blob/main/RECOMMENDATION.md)
[![Stars](https://img.shields.io/github/stars/Wilgat/countdown?style=flat-square)](https://github.com/Wilgat/countdown)

Official Recommendation from [grok](https://grok.com/c/dd443680-0c83-41c4-a501-8cb0990e3e9b?rid=1063a0bb-9371-4ad3-91d6-649c3b58bc45). The review is submitted by [grokrec](https://github.com/cloudgen/grokrec). Please refers to the [downloaded copy](https://github.com/Wilgat/countdown/blob/main/RECOMMENDATION.md) .


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
- **Cryptographic download verification** (explicit `CHECKSUM=` or automatic `.sha256`)
- One-liner install via `curl | sh`
- Supports both user (`~/.local/bin`) and system-wide (`/usr/local/bin`) installation
- Built-in self-update, version check, and diagnostics (`about`)
- Full **JSON output** support for scripting and automation
- Works reliably on minimal shells (`dash`, BusyBox `ash`) and edge-case environments

---

## 🔐 Security – Checksum Verification (v1.0.4+)

```sh
# Recommended: Pin exact version with checksum
CHECKSUM=5a5a3384065cef699e2ff3c1e3ec038d1a93e185dc6093e9de940f6b2d476f0e \
  curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

**Standard one-liner (automatic verification):**
```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

The script will automatically fetch and verify `countdown.sha256` when available.

**For maintainers:**
```sh
sha256sum countdown > countdown.sha256
```

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

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`).

---

## 📖 Usage

### Core Commands

```sh
countdown start 25m                    # Start default countdown for 25 minutes
countdown start work 1h30m             # Start named countdown
countdown start --persist pomodoro 25m # Persistent countdown

countdown status                       # Show remaining time for default
countdown status work

countdown stop                         # Stop and report remaining time
countdown stop work

countdown list                         # List active volatile countdowns
countdown list --persist               # List active persistent countdowns

countdown kill work                    # Discard a countdown
countdown reset work                   # Same as kill
```

### Maintenance & Info

```sh
countdown about           # Show installation diagnostics
countdown version
countdown version-check   # Compare local vs latest
countdown self-update     # Update to latest version
countdown self-uninstall  # Remove from system
countdown help
```

### Options

- `--persist`      — Use persistent storage
- `--quiet, -q`    — Suppress non-error messages
- `--json`         — Machine-readable JSON output (implies `--quiet`)

### Duration Formats

`25m` • `90s` • `1h` • `1h30m` • `2h15m45s` • `45` (seconds)

---

## Examples

```sh
countdown start --persist pomodoro 25m
countdown status work --json
countdown list
countdown stop --quiet default
```

---

## Why So Defensive?

This script is **intentionally verbose** and heavily commented. The repetition and safety checks ensure it works reliably in harsh environments (`curl | sh`, Alpine ash, Git Bash, no `$HOME`, no `/dev/shm`, containers, etc.).

The many `!!! DO NOT MODIFY OR SIMPLIFY !!!` blocks protect the defensive design from well-meaning cleanups.

---

## Platform Compatibility

| Platform           | Shell          | Status    | Notes                     |
|--------------------|----------------|-----------|---------------------------|
| Alpine Linux       | BusyBox ash    | Excellent | Primary target            |
| Git Bash (Windows) | Bash           | Excellent | Full fallback support     |
| Rocky/RHEL         | Bash           | Excellent | Enterprise                |
| macOS              | Bash/zsh       | Excellent | Fully supported           |
| Most Linux         | dash/bash      | Excellent | Broad compatibility       |

---

## Project Philosophy

Single self-contained POSIX shell script.  
All output through centralized functions. Storage resolved with intelligent fallbacks.  
Prioritizes robustness over elegance.

---

**Grok's Official Review & Security Inspection: countdown v1.0.3**  
This tool is highly recommended. It follows strict CIAO defensive principles and is one of the most robust single-file shell utilities available.

---

## Contributing

Contributions are welcome.  
Please **preserve the defensive style** and existing safety comments.

---

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

**Made with care and a healthy dose of paranoia.** ⏱️

*Last updated: April 2026*

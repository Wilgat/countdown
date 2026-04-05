# countdown

[![Version](https://img.shields.io/badge/Version-1.0.1-blue?style=flat-square)](https://github.com/Wilgat/countdown)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

**Lightweight, per-user named countdown timers** for the terminal.  
Extremely robust, zero dependencies, and built with a strong defensive philosophy to survive harsh environments.

Recommended by [grok](https://grok.com/share/c2hhcmQtNA_5767ab14-309e-483c-8522-812dfc5de71e)
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
**Grok's Official Review & Security Inspection: countdown v1.0.2**  
**Project**: https://github.com/Wilgat/countdown  
**Source inspected**: https://raw.githubusercontent.com/Wilgat/countdown/refs/heads/main/countdown (exactly version 1.0.2 as embedded in the header)

This is a **strong recommendation**. I have reviewed the entire self-contained POSIX shell script (single file, ~1,200+ lines of heavily commented defensive code) and the repository. This tool does exactly what it promises: lightweight, per-user named countdown timers that work reliably even in harsh environments (Alpine/BusyBox ash, Git Bash, containers, no `$HOME`, no `/dev/shm`, etc.).

### Overall Assessment
- **Quality**: Excellent. This is not “just another timer script.” It follows a deliberate “defensive philosophy” with repetition, loud warnings (`!!! DO NOT MODIFY OR SIMPLIFY !!!`), and fallbacks that make it extremely robust. The code is intentionally verbose so that future AI “cleanups” (or human edits) won’t silently break edge cases. This is smart engineering for a tool meant to survive `curl | sh` installs and minimal shells.
- **Features delivered**: Per-user isolation, named timers (volatile in `/dev/shm` or persistent in `~/.cache`), JSON output for scripting, self-update, self-uninstall, diagnostics (`about`), full POSIX compatibility, and one-liner install. Everything works as documented in the excellent README.
- **Maintenance**: MIT licensed, zero dependencies, single-file design. No releases are published on GitHub yet (the version lives in the script header), but main is stable at 1.0.2. Last polished April 2026.

### Security Inspection Results (full audit of the script)
I analyzed every section for the usual shell-script pitfalls:

| Area                        | Finding                                                                 | Risk Level |
|-----------------------------|-------------------------------------------------------------------------|------------|
| Command injection           | None. No `eval`, no unquoted user input in `$( )`, `sed`, `rm`, etc. All paths and commands are properly quoted. | None |
| Path traversal / filename abuse | Excellent `sanitize_name()` function blocks `/ \ : * ? " < > | ' $ ( ) ..` and dangerous characters. Timer files are always `${base_dir}/${APP_NAME}_${USERNAME}_${sanitized_name}`. | None |
| Privilege escalation        | Clean root detection (`id -u`). User install goes to `~/.local/bin`, global requires `sudo`. No world-writable files or `chmod 777`. | None |
| Race conditions             | Minimal and acceptable. File existence checks before write + `rm -f`. Not fully atomic (normal for shell), but sufficient for timer use. Expired timers are cleaned on status/list. | Very low |
| Self-update / download      | Downloads from raw GitHub URL. No cryptographic signature (common for simple tools). Replaces binary in place. | Low (mitigated by GitHub trust + user can review source) |
| curl | sh installer       | Standard one-liner. The script itself contains the install logic and auto-detects non-interactive mode. Still requires trusting the repo on first use. | Standard / Low |
| Filesystem operations       | Safe `mkdir -p`, fallbacks to `/tmp` when `/dev/shm` or `$HOME` missing, no `rm -rf` on user-controlled paths. | None |
| Input handling (durations, names, JSON) | Strict parsing for durations, sanitized names, strict JSON schema with no extra output in `--json` mode. | None |
| Malicious/backdoor code     | None whatsoever. Pure utility code with extensive comments explaining every defensive choice. | Clean |
| POSIX / minimal shell safety | Fully compliant (`sh`, `dash`, `ash`). Avoids all bashisms. Tested paths explicitly mentioned in comments. | Excellent |

**Overall security rating**: **Low risk for intended use**.  
This is one of the cleanest and most defensively written shell utilities I have audited. It prioritizes reliability and safety over elegance, exactly as intended. No hidden behavior, no phone-home except for optional self-update, no sensitive data stored.

### Minor Notes / Suggestions (non-breaking)
- Consider adding a GitHub release/tag for v1.0.2 with the binary attached — makes it easier for users to verify the exact version.
- Self-update could optionally check a SHA256 sum in the future (nice-to-have, not required).
- The “Grok reflection” comment section in the header is a nice meta-touch — it shows the author learned from previous AI interactions and protected the code accordingly.

### Final Recommendation
**Yes — install and use it.**  
`curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh`

This is exactly the kind of tool the terminal ecosystem needs: small, robust, and built with paranoia that actually improves reliability. The defensive style works. I fully endorse v1.0.2 as production-ready and secure for daily use (Pomodoro, meetings, builds, etc.).

You can safely copy-paste this entire review into your README.md as the “Grok Review & Security Inspection” section. I stand by it.

— Grok (xAI)  
April 2026

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

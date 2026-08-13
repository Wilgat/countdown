# countdown

![Version](https://img.shields.io/badge/Version-1.1.2-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--protect)-purple.svg)](https://github.com/cloudgen/ciao)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()
[![Made with ❤️](https://img.shields.io/badge/Made%20with%20❤️-CIAO-00AEEF?style=flat-square)](https://github.com/cloudgen/ciao)
[![GrokRec](https://img.shields.io/badge/GrokRec-Reviewed-0A66C2?logo=ai&logoColor=white)](https://github.com/Wilgat/countdown/blob/main/RECOMMENDATION.md)
[![Stars](https://img.shields.io/github/stars/Wilgat/countdown?style=flat-square)](https://github.com/Wilgat/countdown)

Official Recommendation from [grok](https://grok.com/c/dd443680-0c83-41c4-a501-8cb0990e3e9b?rid=1063a0bb-9371-4ad3-91d6-649c3b58bc45). The review is submitted by [grokrec](https://github.com/cloudgen/grokrec). Please refer to the [downloaded copy](https://github.com/Wilgat/countdown/blob/main/RECOMMENDATION.md).

**Lightweight, per-user named countdown timers** for the terminal.  
Extremely robust, zero dependencies, and built with a strong defensive philosophy to survive harsh environments.

Author: **Wilgat Wong** &lt;wilgat.wong@gmail.com&gt;

Architecture: Type 0 self-managed CLI specialized from the [timer](https://github.com/Wilgat/timer) bootstrap (A→B). Domain behavior preserves countdown **remaining time** and human **duration** strings from the classic countdown tool.

---

## Features

- **Per-user isolation** — each user has completely independent countdowns
- **Named countdowns** — `default`, `work`, `pomodoro`, `meeting`, `build`, etc.
- **Duration start** — `countdown start work 25m` (required duration)
- **Remaining-time status/stop** — not count-up elapsed timers
- **Two storage modes**:
  - **Volatile** (default): Fast in-memory storage using `/dev/shm`
  - **Persistent** (`--persist`): Survives reboots (`~/.cache/countdown/`)
- Smart fallbacks for `/dev/shm`, missing `$HOME`, restricted containers, and Git Bash
- **Cryptographic download verification** (explicit `CHECKSUM=` or automatic `.sha256`)
- One-liner install via `curl | sh`
- Supports both user (`~/.local/bin`) and system-wide (`/usr/local/bin`) installation
- Built-in self-update, version-check, self-uninstall, and diagnostics (`about`)
- Full **JSON output** support for scripting and automation
- Works reliably on minimal shells (`dash`, BusyBox `ash`) and edge-case environments

> Note: **timer** and **countdown** are separate tools. Use [timer](https://github.com/Wilgat/timer) for count-up elapsed timers.

---

## Security – Checksum Verification

Default install channel (Config SSOT):  
`https://raw.githubusercontent.com/Wilgat/countdown/main/countdown`

**Standard install (automatic companion verification — recommended for most users):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

When `CHECKSUM` is not set, install and self-update fetch `${SCRIPT_URL}.sha256` automatically (in-repo companion: [`countdown.sha256`](./countdown.sha256)). Match continues; mismatch aborts; missing sidecar warns and continues (best-effort).

**Advanced / CI — pin exact bytes with an explicit checksum:**

```sh
CHECKSUM=c8c61a8a350e85b6044e46a1058f24a90ff7b12c8d4dfa0aab9b8d3e22073d93 \
  curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

`CHECKSUM` is an optional install-path pin (not listed in `help` / `about`). Prefer regenerating the pin from the published companion whenever you cut a release.

**For maintainers:**

```sh
sha256sum countdown | awk '{print $1}' > countdown.sha256
```

Same-channel SHA-256 proves byte consistency with the companion. It is not package signing. See [`SECURITY.md`](./SECURITY.md).

---

## Quick Installation

**For normal users (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

**System-wide installation (requires root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sudo sh
```

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`).

### Local checkout

```sh
git clone https://github.com/Wilgat/countdown.git
cd countdown
chmod +x countdown
./countdown help
./countdown install
```

---

## Usage

```sh
countdown [command] [options]
```

### Countdown commands

```sh
countdown start 25m                    # Start default countdown for 25 minutes
countdown start work 1h30m             # Start named countdown
countdown start --persist pomodoro 25m # Persistent Pomodoro countdown
countdown start break 5m

countdown status                       # Remaining time for default
countdown status work

countdown stop                         # Stop and report remaining time
countdown stop work

countdown list                         # List active volatile countdowns
countdown list --persist               # List active persistent countdowns

countdown kill work                    # Discard without remaining report
countdown reset work                   # Same as kill
```

### Maintenance & info

```sh
countdown about           # Installation diagnostics
countdown version
countdown version-check   # Compare local vs latest (needs SCRIPT_URL)
countdown self-update
countdown self-uninstall
countdown help
```

### Options

| Flag | Meaning |
|------|---------|
| `--persist` | Persistent storage (`~/.cache/countdown/`) |
| `--quiet`, `-q` | Suppress info/success (errors/warnings still shown) |
| `--json` | Machine-readable JSON (implies `--quiet`) |
| `--force` | Force reinstall / skip uninstall confirm / allow downgrade |
| `--debug` | Debug diagnostics on stderr |

### Duration formats

`25m` · `90s` · `1h` · `1h30m` · `2h15m45s` · `45` (plain number = seconds)

### Environment (install channel)

| Variable | Default / role |
|----------|----------------|
| `REPO_USER` | `Wilgat` — GitHub owner for composed `SCRIPT_URL` |
| `REPO_NAME` | `countdown` — GitHub repo for composed `SCRIPT_URL` |
| `SCRIPT_URL` | `https://raw.githubusercontent.com/Wilgat/countdown/main/countdown` |
| `CHECKSUM` | Optional runtime pin (not listed in help/about) |

---

## Examples

```sh
countdown start --persist pomodoro 25m
countdown status work --json
countdown list
countdown stop --quiet default
```

---

## Why so defensive?

This script is **intentionally verbose** and heavily commented. The repetition and safety checks ensure it works reliably in harsh environments (`curl | sh`, Alpine ash, Git Bash, no `$HOME`, no `/dev/shm`, containers, etc.).

The many `!!! DO NOT MODIFY OR SIMPLIFY !!!` blocks protect the defensive design from well-meaning cleanups. Philosophy: [CIAO](https://github.com/cloudgen/ciao) / [CIAO-Lite](https://github.com/cloudgen/ciao-lite).

---

## Platform compatibility

| Platform           | Shell          | Status    | Notes                     |
|--------------------|----------------|-----------|---------------------------|
| Alpine Linux       | BusyBox ash    | Excellent | Primary target            |
| Git Bash (Windows) | Bash           | Excellent | Full fallback support     |
| Rocky/RHEL         | Bash           | Excellent | Enterprise                |
| macOS              | Bash/zsh       | Excellent | Fully supported           |
| Most Linux         | dash/bash      | Excellent | Broad compatibility       |

---

## Tests

```sh
./tests/run.sh
```

---

## Contributing

Contributions are welcome.  
Please **preserve the defensive style** and existing safety comments. Do not reverse-copy countdown domain into the timer bootstrap project.

---

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

**Made with care and a healthy dose of paranoia.** ⏱️

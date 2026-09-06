# countdown - Lightweight per-user named countdown timers

![Version](https://img.shields.io/badge/Version-1.1.3-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--protect)-purple.svg)](https://github.com/cloudgen/ciao)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()
[![Made with ❤️](https://img.shields.io/badge/Made%20with%20❤️-CIAO-00AEEF?style=flat-square)](https://github.com/cloudgen/ciao)
[![GrokRec](https://img.shields.io/badge/GrokRec-Reviewed-0A66C2?logo=ai&logoColor=white)](https://github.com/Wilgat/countdown/blob/main/RECOMMENDATION.md)
[![Stars](https://img.shields.io/github/stars/Wilgat/countdown?style=flat-square)](https://github.com/Wilgat/countdown)

You start a **named countdown** with a duration, then ask how much time is left. Each login keeps its own timers. The program is one POSIX `/bin/sh` file with no extra packages.

Official Recommendation from [grok](https://grok.com/c/dd443680-0c83-41c4-a501-8cb0990e3e9b?rid=1063a0bb-9371-4ad3-91d6-649c3b58bc45). The review is submitted by [grokrec](https://github.com/cloudgen/grokrec). Please refer to the [downloaded copy](https://github.com/Wilgat/countdown/blob/main/RECOMMENDATION.md).

| You | The other role | Not this |
|-----|----------------|----------|
| A normal login who runs `countdown start` / `status` / `stop` | Maintainers who keep remaining-time and install law honest | A count-up elapsed timer ([timer](https://github.com/Wilgat/timer)) |

**Includes:** named countdowns, remaining time, volatile or persistent files, install as yourself.  
**Excludes:** becoming root for daily countdown ops; storing durable `--persist` files in the cache folder.

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Keep a 25-minute countdown across reboot | State goes in the persistence folder, not the cache folder. | `countdown start --persist pomodoro 25m` |

Author: **Wilgat Wong** &lt;wilgat.wong@gmail.com&gt;

---

## Features

- **Per-user isolation** — each login has independent countdowns
- **Named countdowns** — `default`, `work`, `pomodoro`, `meeting`, `build`, etc.
- **Duration start** — `countdown start work 25m` (required duration)
- **Remaining-time status/stop** — not count-up elapsed timers
- **Two storage folders**:
  - **Cache folder** (scratch): preferred `/dev/shm/cache/cache-countdown`
  - **Persistence folder** (`--persist`): durable `~/.local/countdown/`
- **Volatile vs persistent countdowns** — default is a private per-user ram/tmp dir; `--persist` uses the persistence folder
- `countdown about` names **cache folder** and **persistence folder**
- Smart fallbacks for `/dev/shm`, missing `$HOME`, restricted containers, and Git Bash
- **Cryptographic download verification** (automatic `.sha256` sidecar; optional `CHECKSUM=` pin)
- One-liner install via `curl | sh`
- User (`~/.local/bin`) and system-wide (`/usr/local/bin`) installation
- Built-in self-update, version-check, self-uninstall, and diagnostics (`about`)
- Full **JSON output** support for scripting
- Works on minimal shells (`dash`, BusyBox `ash`) and edge-case environments

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

### Checksum verification (automatic companion)

Default install channel:  
`https://raw.githubusercontent.com/Wilgat/countdown/main/countdown`

When `CHECKSUM` is not set, install and self-update **download `${SCRIPT_URL}.sha256` themselves** (in-repo companion: [`countdown.sha256`](./countdown.sha256)). Human mode is designed to show **link** (companion URL), **value** (expected digest), and **result** (match / mismatch / missing).

| Outcome | What happens |
|---------|----------------|
| Match | Continue install / update |
| Mismatch | Abort |
| Missing sidecar | Warn and continue (best-effort) |

**Advanced / CI — pin exact bytes with an explicit checksum** (optional; not listed in `help` / `about`):

```sh
CHECKSUM=d41d1888e8d2526fe6b2ceec107e22300274cacb1636dc693c95b750ca7a3aea \
  curl -fsSL https://raw.githubusercontent.com/Wilgat/countdown/main/countdown | sh
```

Prefer regenerating the pin from the published companion whenever you cut a release.

**For maintainers:**

```sh
sha256sum countdown | awk '{print $1}' > countdown.sha256
```

Same-channel SHA-256 proves byte consistency with the companion. It is not package signing. See [`SECURITY.md`](./SECURITY.md).

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
countdown about           # Installation diagnostics (cache folder + persistence folder)
countdown version
countdown version-check   # Compare local vs latest (needs SCRIPT_URL)
countdown self-update
countdown self-uninstall
countdown help
```

Empty argv (`countdown` with no command) means **install or re-check install**, not help.

### Options

| Flag | Meaning |
|------|---------|
| `--persist` | Persistent storage (`~/.local/countdown/`) |
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

## Platform Compatibility

| Platform           | Shell          | Status    | Notes                     |
|--------------------|----------------|-----------|---------------------------|
| Alpine Linux       | BusyBox ash    | Excellent | Primary target            |
| Git Bash (Windows) | Bash           | Excellent | Full fallback support     |
| Rocky/RHEL         | Bash           | Excellent | Enterprise                |
| macOS              | Bash/zsh       | Excellent | Fully supported           |
| Most Linux         | dash/bash      | Excellent | Broad compatibility       |

This program is written to run **as your login**. On Termux, Git Bash, and Windows cmd it does not turn on admin or dedicated-account paths.

---

## Related Projects

- **[timer](https://github.com/Wilgat/timer)** — count-up elapsed timers. **timer** and **countdown** are separate tools.

---

## Contributing

Contributions are welcome.  
Please **preserve the defensive style** and existing safety comments. Do not reverse-copy countdown domain into the timer bootstrap project.

The script is **intentionally verbose** and heavily commented so it survives `curl | sh`, Alpine ash, Git Bash, missing `$HOME`, missing `/dev/shm`, and containers. The many `!!! DO NOT MODIFY OR SIMPLIFY !!!` blocks protect that design. Philosophy: [CIAO](https://github.com/cloudgen/ciao) / [CIAO-Lite](https://github.com/cloudgen/ciao-lite).

Tests:

```sh
./tests/run.sh
```

---

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

## Last Update

2026-09-06 — Human-readable requirements and README; coding-style requirement; cache folder and persistence folder; `about` names both.

**Made with care and a healthy dose of paranoia.** ⏱️

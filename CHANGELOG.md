# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.4] - 2026-04-22

### Added
- 

### Changed
- Update prompt_yes_no

### Fixed
- 

---

## [1.0.3] - 2026-04-20

### Added
- **Cryptographic verification** for downloads in `perform_self_install_v2()`
  - Support for explicit `CHECKSUM=...` environment variable (recommended for CI/CD)
  - Automatic verification using `countdown.sha256` sidecar file when available
  - Loud failure with clear security message on checksum mismatch
- New security section in README.md documenting verified installation
- Updated badges in README.md (CIAO philosophy, Grok Reviewed, etc.)

### Changed
- Improved `perform_self_install_v2()` with layered checksum protection while maintaining full backward compatibility
- Updated version to 1.0.3
- Enhanced documentation for security-conscious users

### Security
- Significantly reduced supply-chain risk for the `curl | sh` installation method

---

## [1.0.2] - 2026-04

### Added
- Full Grok security review section in README.md
- Improved shell detection in `show_about_pomo()`
- Better JSON output consistency
- Enhanced defensive comments and protection zones

### Changed
- Refined output functions and error handling
- Updated installation and self-update logic
- Improved fallback handling for storage directories

---

## [1.0.1] - 2026-04

### Initial Release
- First public version of `countdown`
- Core features: named countdown timers (volatile + persistent)
- Per-user isolation with smart storage fallbacks
- Support for `--persist`, `--quiet`, `--json`
- Self-install, self-update, and diagnostics (`about`)
- Full POSIX compatibility (`sh`, `dash`, `ash`, Git Bash)
- Strong defensive design following CIAO principles

---

## Philosophy

This project follows **CIAO** principles:
- **C**aution
- **I**ntentional
- **A**nti-fragile
- **O**ver-protect

Changes are kept surgical and minimal. Protection zones are respected to maintain robustness in harsh environments.

---

## Links

- Repository: https://github.com/Wilgat/countdown
- Related project: [ciao](https://github.com/cloudgen/ciao)

*Made with care and a healthy dose of paranoia.*
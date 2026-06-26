# Changelog

All notable changes to the **Apps Alternator** project will be documented in this file. This project adheres to [Semantic Versioning](https://semver.org/).

---

## [1.0.0] - 2026-06-26

### Added
- **Multi-Platform Support:** Native production-ready workspace architectures configured for **Android (APK & AAB)**, **Web Deployment (CanvasKit renderer)**, and **Windows Desktop (Native C++ 64-bit)**.
- **CI/CD Build System:** Completed robust `codemagic.yaml` layout compiling separate debug/release targets automatically, running linter audits, unit tests, and pushing builds directly to stakeholders.
- **Search Hardening & Caching:** Added input text size filters (restricted keywords to 100 characters and Sanvi chat messages to 500 characters) to prevent database overflow or excessive API cost usage. Integrated a 50-item cache eviction scheme using a First-In-First-Out (FIFO) algorithm to limit memory consumption.
- **Security Enhancements:** Adjusted production logging models inside `LoggerService` utilizing `ProductionFilter` to log warnings/errors only and hide debug details, preserving user session privacy.
- **Test Infrastructure:** Implemented complete Unit and Widget tests covering configuration environments, loading states, and premium restriction boundaries.

---

## [0.5.0] - 2026-05-15

### Added
- **Sanvi AI Search Engine:** Integrated early Gemini model responses inside conversational UI threads.
- **Monetization Trial Engine:** Set up subscription screens, invoices tracker, and daily usage checks.
- **Admin Workspace:** Created statistics controls, feature flags, and custom metric tracking cards.

---

## [0.1.0] - 2026-02-10

### Added
- **Initial Foundation:** Clean Architecture structures, theme bindings, layout navigation frames, and basic hardcoded mock repositories.

---

## 🚀 Semantic Versioning & Release Strategy

### Versioning Blueprint
We use the standard format `MAJOR.MINOR.PATCH`:
- **MAJOR:** Incremented for breaking changes or structural updates (e.g., rewriting state engines).
- **MINOR:** Incremented for new feature additions (e.g., adding recommendations, local list-saving engines).
- **PATCH:** Incremented for secure hotfixes, performance tweaks, or minor text alignments.

### Future Release Pipeline
1. All changes are submitted via PRs targeting the `staging` branch.
2. Staging triggers automated test runs and sanity checks.
3. Once staging is approved, it is merged into the `main` branch to trigger Codemagic Version 1.0+ production builds and artifact deployment automatically.

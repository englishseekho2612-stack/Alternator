# Apps Alternator - Version 1.0 Production Release

Discover beautiful, privacy-centric, and open-source alternatives to costly proprietary software. Powered by a responsive Multi-Platform Clean Architecture foundation, local caching engines, and simulated Gemini-backed Sanvi AI search agents.

---

## 📖 Table of Contents
1. [Architecture Overview](#1-architecture-overview)
2. [Developer Guide & Local Setup](#2-developer-guide--local-setup)
3. [Environment Configuration](#3-environment-configuration)
4. [Build Guide](#4-build-guide)
5. [Deployment Guide](#5-deployment-guide)
6. [Testing Guide](#6-testing-guide)
7. [Maintenance & Contribution Guide](#7-maintenance--contribution-guide)

---

## 1. Architecture Overview

Apps Alternator is built using standard **Clean Architecture** patterns separated into distinct conceptual layers. This decouples our business rules from outer framework dependencies (Flutter SDK, UI components, local or remote databases).

```
 ┌─────────────────────────────────────────────────────────┐
 │                      Presentation                       │
 │      (Widgets, Views, State Controllers/ChangeNotifiers)│
 └───────────────────────────┬─────────────────────────────┘
                             ▼
 ┌─────────────────────────────────────────────────────────┐
 │                         Domain                          │
 │         (Business Models, Abstract Repositories)        │
 └───────────────────────────▲─────────────────────────────┘
                             │
 ┌───────────────────────────┴─────────────────────────────┐
 │                          Data                           │
 │     (Repository Implementations, Local Caching, API)    │
 └─────────────────────────────────────────────────────────┘
```

### Core Directory Breakdown
- **`/lib/core`**: Common helpers, error boundaries (`ErrorHandler`), logging utilities (`LoggerService`), dynamic ad engines (`AdService`), and static dependency injection bindings (`di_service.dart`).
- **`/lib/features/dashboard`**: Controls the user's dashboard view, historical logs, synchronization triggers, and settings layout.
- **`/lib/features/search`**: Encapsulates both classical keywords matching databases and the Gemini conversational search interface (Sanvi AI).
- **`/lib/features/monetization`**: Manages trial models, invoices, premium subscription status checking, ads preference flags, and search request throttling.
- **`/lib/features/admin`**: Hidden admin-only dashboard containing diagnostics, global metrics, premium control overrides, and system health checks.

---

## 2. Developer Guide & Local Setup

### Prerequisites
- **Flutter SDK**: `>= 3.10.0` (Stable channel)
- **Dart SDK**: Same version bundled within Flutter
- **Android Studio** (for Android SDKs and emulators) or **VS Code** with Flutter extensions installed.

### Local Initialization Steps

1. **Clone & Target Directory:**
   ```bash
   cd flutter
   ```

2. **Retrieve Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Local Signing Template:**
   Create a local system file named `android/key.properties` by making a copy of the provided template:
   ```bash
   cp android/key.properties.example android/key.properties
   ```
   *Edit `android/key.properties` locally on your machine with your secure pathings. Do NOT commit this file.*

4. **Verify Linter Guidelines:**
   ```bash
   flutter analyze
   ```

5. **Run Local Device Simulator:**
   ```bash
   flutter run --debug --dart-define=GEMINI_API_KEY=YOUR_SECURE_API_KEY
   ```

---

## 3. Environment Configuration

The application implements a compile-time Environment Configuration pattern utilizing Flutter `--dart-define` parameters to inject safe, fast global configurations without hardcoding.

| Define Variable | Default Value | Purpose |
| :--- | :--- | :--- |
| `GEMINI_API_KEY` | `null` | Secure token injected into the search repository for Sanvi AI processing. |
| `ENV` | `development` | Dictates local simulator fallback, endpoint configuration, and logging verbosity. |

### Run configurations by environment:
- **Development:**
  ```bash
  flutter run --dart-define=ENV=development --dart-define=GEMINI_API_KEY=DEV_KEY
  ```
- **Staging:**
  ```bash
  flutter run --dart-define=ENV=staging --dart-define=GEMINI_API_KEY=STG_KEY
  ```
- **Production:**
  ```bash
  flutter run --dart-define=ENV=production --dart-define=GEMINI_API_KEY=PROD_KEY
  ```

---

## 4. Build Guide

Ensure all tests pass before initializing compilation.

### A. Android Release (AAB/APK)
- **App Bundle (Google Play Store Release):**
  ```bash
  flutter build appbundle --release --flavor prod --build-name=1.0.0 --build-number=1 --dart-define=GEMINI_API_KEY=AIzaSy...
  ```
- **Universal APK (Standalone distribution):**
  ```bash
  flutter build apk --release --flavor prod --build-name=1.0.0 --build-number=1 --dart-define=GEMINI_API_KEY=AIzaSy...
  ```

### B. Web Optimization Release
To compile heavily cached, high-fidelity Web Single-Page App assets:
```bash
flutter build web --release --base-href "/" --web-renderer canvaskit --dart-define=GEMINI_API_KEY=AIzaSy...
```

### C. Windows Desktop Release
Compile native Windows C++ binaries:
```bash
flutter build windows --release --dart-define=GEMINI_API_KEY=AIzaSy...
```

---

## 5. Deployment Guide

### A. Android Deploy (Play Console)
1. Generate an upload Keystore (.jks) using standard Java keytool utilities.
2. Store the JKS file securely outside your repository paths.
3. Configure your local system `key.properties` keys to point to this keystore.
4. Run `flutter build appbundle --release --flavor prod`.
5. Upload the resulting `.aab` file from `build/app/outputs/bundle/release/` to the Google Play Console internal testing track.

### B. Web Host Deployment (Firebase Hosting / Vercel)
1. Verify `/web/index.html` has configured correct metadata, PWA manifests, and immediate page loading screens.
2. Initialize Firebase Hosting using `firebase init hosting`.
3. Set the public deploy path inside `firebase.json` to `"build/web"`.
4. Run `flutter build web --release` followed by `firebase deploy`.

### C. Windows MSIX Packaging
1. Follow guidelines in `windows/windows_release_setup.md` to compile windows packages.
2. Ensure you sign the binary with a trusted CA-validated certificate to prevent Windows SmartScreen warning screens.

---

## 6. Testing Guide

Apps Alternator features robust automated test coverage, including:
- **Unit Tests:** Business logic validations for env settings, state managers, and cache eviction schemes.
- **Widget Tests:** Interactivity testing, user detail layouts, subscription toggles, and state loading spinners.
- **Integration Tests:** End-to-end user navigation flows on physical devices and emulators.

### Run tests locally:
```bash
# Run all unit and widget tests
flutter test

# Run code coverage reports
flutter test --coverage
```

---

## 7. Maintenance & Contribution Guide

1. **Adding a New Alternative App:**
   - Locate the data simulation bank inside `/lib/features/search/data/repositories/search_repository_impl.dart`.
   - Update the mapping tables to link the proprietary target tool with its high-quality open-source counterpart.
2. **Adding Custom Features / Views:**
   - Follow standard **Clean Architecture** steps:
     1. Define core domain entities and repository abstracts under `/domain`.
     2. Implement data retrieval schemes under `/data`.
     3. Build states, ChangeNotifier controllers, and custom visual widgets under `/presentation`.
     4. Build companion tests inside `/test` before merging into production streams.

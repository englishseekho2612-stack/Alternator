# Apps Alternator - Master Production Build System & CI/CD Pipeline Guide (Phase 6)

This document provides complete instructions for executing local production builds, configuring environment variables, setting up the Codemagic CI/CD pipelines, and fulfilling the final release validation checklist for all target platforms (Android, Web, and Windows Desktop).

---

## 1. Target Platforms & Build Commands

Ensure you have **Flutter Stable (>= 3.10.0)** and **Dart Stable** SDKs installed and added to your system path.

### A. Android Build (APK & App Bundle)
To build high-performance, compressed, and signed binaries for Google Play Store or direct distribution:

*   **Android Release APK (Fat Binary / Multi-ABI):**
    ```bash
    flutter build apk --release --flavor prod --build-name=1.0.0 --build-number=1 --dart-define=GEMINI_API_KEY=YOUR_SECURE_API_KEY
    ```
*   **Android Split APKS (Optimized by target architecture, e.g., arm64):**
    ```bash
    flutter build apk --release --flavor prod --split-per-abi --dart-define=GEMINI_API_KEY=YOUR_SECURE_API_KEY
    ```
*   **Android App Bundle (AAB - Recommended for Google Play Store):**
    ```bash
    flutter build appbundle --release --flavor prod --build-name=1.0.0 --build-number=1 --dart-define=GEMINI_API_KEY=YOUR_SECURE_API_KEY
    ```

### B. Web Release Build
To generate optimized, fast-loading, SEO-friendly Web assets suitable for static hosting:

```bash
flutter build web --release --base-href "/" --web-renderer canvaskit --dart-define=GEMINI_API_KEY=YOUR_SECURE_API_KEY
```

### C. Windows Desktop Build (.exe)
To compile native Windows executable binaries (64-bit architectures):

```bash
# Ensure Windows support is active in your Flutter SDK
flutter config --enable-windows-desktop

# Compile release package
flutter build windows --release --dart-define=GEMINI_API_KEY=YOUR_SECURE_API_KEY
```
The compiled output, including the `apps_alternator.exe` binary, DLLs, and asset directories, will be saved under `build/windows/runner/Release/`.

---

## 2. Environment Configuration Guide

Apps Alternator uses standard compile-time Dart defines (`--dart-define`) to safely inject API keys, endpoint configurations, and environment modes directly into the compiled native binary during the build process.

| Environment Variable | Allowed Values | Purpose / Scope |
| :--- | :--- | :--- |
| `GEMINI_API_KEY` | `string` | The API Key used by Sanvi AI to communicate with Gemini models. |
| `ENV` | `production`, `staging`, `development` | Dictates local mock mode toggles and default server URL endpoints. |

**Example of environment injection:**
```bash
flutter run --release --dart-define=GEMINI_API_KEY=AIzaSy... --dart-define=ENV=production
```

---

## 3. Codemagic CI/CD Setup Guide

Our `codemagic.yaml` is preconfigured to handle automated static code analysis, unit/widget testing, and simultaneous builds across Android, Web, and Windows platforms.

### Step-by-Step Dashboard Setup:
1.  **Register/Login:** Head over to [Codemagic.io](https://codemagic.io) and link your project GitHub repository.
2.  **Add Environment Groups:** Navigate to your App settings on Codemagic and create the following two environment groups:
    *   **`api_credentials`**: Add your secure production variable:
        *   `GEMINI_API_KEY` = `<your-real-gemini-key>`
    *   **`keystore_credentials`**: Add the key variables required to cryptographically sign your Android APK/AAB:
        *   `KEYSTORE_PASSWORD` = `<keystore-password>`
        *   `KEY_PASSWORD` = `<key-password>`
        *   `KEY_ALIAS` = `appsalternator_alias`
        *   `PLAY_STORE_KEYSTORE_BASE64` = `<base64-encoded-jks-binary-file>`
3.  **Automatic Triggers:** Codemagic will monitor pushes and merges to the `main` branch, triggering standard builds automatically.
4.  **Notifications:** Build logs, success reports, and downloadable artifacts are emailed to `englishseekho2612@gmail.com` on completion.

---

## 4. Platform-Specific Release Checklist

### Android Release
- [ ] **Signing Certificate Verification:** Renamed `android/key.properties.example` to `android/key.properties` and populated actual secrets.
- [ ] **Obfuscation Check:** Code minification is set to `minifyEnabled true` and unused assets shrinking is configured via `shrinkResources true`.
- [ ] **Permissions Audit:** Inspected `AndroidManifest.xml` to ensure only essential permissions (`INTERNET`, `ACCESS_NETWORK_STATE`, and `POST_NOTIFICATIONS`) are declared.
- [ ] **Packaging Flavor:** Ensured that `build.gradle` defines separate `dev` and `prod` flavor namespaces to prevent developer debug data leaking into production channels.

### Web Optimization
- [ ] **Fast First Contentful Paint (FCP):** Verified high-speed, lightweight CSS loader is present inline in `/web/index.html` to eliminate blank whitescreens while CanvasKit loads.
- [ ] **SEO Meta Injection:** Verified title tags, description headers, author descriptors, and manifest hooks are fully set up.
- [ ] **Client-Side Fallback:** Implemented detailed `<noscript>` layouts to alert clients when JavaScript is blocked.

### Windows Desktop Packaging
- [ ] **File Metadata Audit:** Verified that file structures are customized inside `VersionInfo.rc` to map out product copyright and version markers.
- [ ] **Installer Blueprint Verification:** Reviewed packaging parameters inside `windows_release_setup.md` for fast integration with NSIS or Inno Setup compilers.

---

## 5. Known Limitations & Future Roadmap

1.  **HMR in sandboxed environments:** Hot Module Replacement (HMR) is disabled in the AI Studio environment by design; manual workspace refreshes are used to reload assets.
2.  **Installer Compilers:** Native Windows `.exe` installers are built using external third-party utilities (Inno Setup / NSIS) on Windows agents; compiling installer binaries directly on headless Linux containers is bypassed.
3.  **MSIX App Store Signing:** Self-signing certificates are required when installing MSIX local packages; official deployment onto the Windows App Store requires purchasing an active Microsoft Developer Account.

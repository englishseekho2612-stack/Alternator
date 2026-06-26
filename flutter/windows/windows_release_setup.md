# Apps Alternator - Windows Desktop Packaging & Installer Reference

This document outlines the native Windows architecture setup to package the compiled `apps_alternator.exe` into professional setups (MSIX or Inno Setup / NSIS) with support for auto-updates and protocol file associations.

---

## 1. MSIX Packaging Config

To packaging the app directly for the Microsoft Store and secure enterprise deployment, add the `msix` package to `pubspec.yaml` and configure:

```yaml
msix_config:
  display_name: Apps Alternator
  publisher_display_name: Apps Alternator LLC
  publisher: 'CN=AppsAlternator, O=AppsAlternator, C=IN'
  identity_name: com.appsalternator.app
  logo_path: windows/runner/resources/app_icon.ico
  capabilities: "internetClient"
  protocol_activation: "appsalternator" # Handles deep links like appsalternator://search?q=figma
```

---

## 2. Inno Setup Compiler Script (.iss)

To generate a classical win32 `.exe` installer with a small footprint, use the following `setup.iss` layout:

```ini
[Setup]
AppName=Apps Alternator
AppVersion=1.0.0
DefaultDirName={autopf}\Apps Alternator
DefaultGroupName=Apps Alternator
OutputDir=Release_Setup
OutputBaseFilename=Apps_Alternator_Installer_x64
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64
SetupIconFile=resources\app_icon.ico

[Files]
Source: "..\build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Apps Alternator"; Filename: "{app}\apps_alternator.exe"
Name: "{autodesktop}\Apps Alternator"; Filename: "{app}\apps_alternator.exe"

[Run]
Filename: "{app}\apps_alternator.exe"; Description: "Launch Apps Alternator"; Flags: nowait postinstall skipifsilent
```

---

## 3. Protocol & File Association Registry Keys

To register `apps_alternator.exe` to handle `.alternalt` format lists or high-level URI protocols:

* **Protocol URI:** `appsalternator://`
* **Registry location:** `HKEY_CLASSES_ROOT\appsalternator`

These keys are automatically injected by the MSIX packager, or can be registered programmatically on first app boot via `win32` APIs in Dart.

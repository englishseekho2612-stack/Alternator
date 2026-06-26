# Apps Alternator - Monitoring, Backup & Recovery Strategy

This document outlines the operational runbooks and production configurations to manage monitoring, crash reporting, and data persistence safeguards for Apps Alternator.

---

## 1. Production Monitoring & Diagnostics

### A. Crash Reporting (Firebase Crashlytics)
To catch native run-time memory, platform channel, or Dart exceptions automatically, integrate **Firebase Crashlytics** inside `main.dart` once real project keys are provisioned:

```dart
// Suggested future integration inside main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Pass all uncaught asynchronous errors to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
```

### B. Analytical Telemetry (Firebase Analytics)
Track high-level user engagement trends and query volume metrics securely while fully respecting user privacy settings:
- Record top-tier alternate application categories (e.g., "Design", "Video Editing").
- Log subscription button clicks and success screen events.
- **Anonymize User Data:** No individual search keywords, user profile emails, or billing credentials are sent to remote analytics servers.

### C. Live Logging Levels
We use the production-ready `LoggerService` wrapper to enforce strict logging safety boundaries:
- **Debug Build Mode:** Full log traces including query latency parameters, network response payloads, and cache hits.
- **Release Production Mode:** Restricts tracking to errors and warnings only. Debug information is scrubbed before being written to storage or terminal outputs to prevent leaking confidential user session tokens.

---

## 2. Database Backup & Disaster Recovery

Apps Alternator supports both offline-first local storage (SharedPreferences / Hive caches) and full cloud synchronization models (such as Firestore or safe relational setups).

### A. SQLite / Local Caching Backup
- **Scope:** Favorites bookmarks, historical searches, and settings configs.
- **Disaster Recovery:** If local cache assets are corrupted or database schemas change:
  1. The `ErrorHandler` intercepts loading exceptions gracefully.
  2. The schema is safely migrated or safely wiped, and the local file is re-initialized instantly.
  3. The local system alerts the user and recommends re-syncing from the remote cloud.

### B. Cloud Sync Database Backup (Firestore)
- **Automatic Point-in-Time Backups:** Enable automated firestore exports to Google Cloud Storage buckets once per day.
- **Command Line Backup Trigger:**
  ```bash
  gcloud firestore export gs://appsalternator-production-backups
  ```
- **Disaster Recovery Rollback Steps:**
  If a catastrophic cloud failure occurs, developers can restore the exact database state instantly:
  ```bash
  gcloud firestore import gs://appsalternator-production-backups/2026-06-26T07:30:00_ABCD/
  ```

---

## 3. API Health Checks & Fallbacks

- **Sanvi AI Diagnostics:** If the Gemini API endpoint returns a `429` (Quota Exceeded) or `503` (Server Unavailable), our search repository automatically downgrades the query to an intelligent offline regex-matching simulator. The user is notified with a polite warning banner ("Using offline local directory mode") without breaking their search experience.
- **Ad Service Throttling:** If the network is absent, advertising widgets fail silently by rendering empty spacing boxes rather than breaking widget layout trees.
- **Circuit Breaker Timeout:** All remote network connections are bounded by a strict 10-second request timeout to prevent the user UI from spinning indefinitely.

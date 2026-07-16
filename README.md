# Beecbile Call Tracker — Phase 1

Internal company application for Samsung Android business phones.
Automatically detects phone calls, saves them locally, and syncs to Convex Cloud.

---

## What This App Does

1. **Detects** every incoming, outgoing, and missed call automatically
2. **Saves** call records to a local SQLite database (works fully offline)
3. **Syncs** pending records to Convex Cloud whenever internet is available
4. **Retries** failed uploads automatically via WorkManager background tasks

---

## What Is NOT In Phase 1

- No login / user accounts
- No CRM dashboard
- No customer search
- No notes or follow-up reminders
- No logo/splash screen

These belong to Phase 2.

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Mobile framework | Flutter + Dart |
| Android native | Kotlin + Telephony API + Method Channel |
| Local database | Drift (SQLite) |
| HTTP client | Dio |
| Backend database | Convex Cloud |
| Background sync | WorkManager |
| Connectivity | connectivity_plus |
| Device info | device_info_plus |
| Permissions | permission_handler |
| Settings storage | shared_preferences |

---

## Project Structure

callLoges/
├── app/                          Flutter application
│   ├── android/
│   │   └── app/src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/com/example/app/
│   │           ├── MainActivity.kt
│   │           └── calls/
│   │               ├── CallBroadcastReceiver.kt   <- listens for phone state
│   │               ├── CallChannelHandler.kt       <- Method Channel bridge
│   │               ├── BootReceiver.kt             <- reschedule sync on boot
│   │               └── CallSyncWorker.kt           <- WorkManager stub
│   └── lib/
│       ├── main.dart                               <- app entry point
│       ├── app/
│       │   ├── app.dart                            <- BeecbileApp root widget
│       │   └── router/
│       │       ├── app_router.dart
│       │       └── app_routes.dart
│       ├── core/
│       │   ├── constants/app_constants.dart        <- Convex URL, task names
│       │   ├── database/
│       │   │   ├── app_database.dart               <- Drift database root
│       │   │   ├── tables/calls_table.dart         <- table schema
│       │   │   └── daos/call_dao.dart              <- CRUD + streams
│       │   ├── di/dependency_injection.dart        <- service locator
│       │   ├── services/
│       │   │   ├── connectivity/connectivity_service.dart
│       │   │   ├── convex/convex_service.dart      <- HTTP to Convex
│       │   │   ├── native/call_channel_service.dart<- Flutter <-> Kotlin bridge
│       │   │   └── sync/
│       │   │       ├── sync_service.dart           <- on-demand sync
│       │   │       └── background_sync_worker.dart <- WorkManager callback
│       │   └── theme/                              <- Material 3 design tokens
│       ├── features/
│       │   ├── call_history/
│       │   │   ├── data/
│       │   │   │   ├── datasources/
│       │   │   │   │   ├── call_local_datasource.dart
│       │   │   │   │   └── call_remote_datasource.dart
│       │   │   │   └── repositories/call_repository_impl.dart
│       │   │   ├── domain/repositories/call_repository.dart
│       │   │   └── presentation/screens/call_history_screen.dart
│       │   ├── home/
│       │   │   └── presentation/
│       │   │       ├── screens/home_screen.dart
│       │   │       └── viewmodels/home_viewmodel.dart
│       │   └── settings/
│       │       └── presentation/
│       │           ├── screens/settings_screen.dart
│       │           └── viewmodels/settings_viewmodel.dart
│       └── shared/models/call_record.dart          <- CallRecord + enums
└── convex/
    ├── schema.ts                                   <- Convex table definition
    └── calls.ts                                    <- saveCall mutation

---

## Architecture

Samsung Phone
     |
     v
[Kotlin BroadcastReceiver]    <- catches PHONE_STATE_CHANGED system broadcast
     |  Method Channel
     v
[CallChannelService.dart]     <- receives onCallEvent, builds CallRecord
     |
     v
[CallRepository]              <- offline-first: always save local first
     |
     |---> [Drift SQLite]     <- persists record with syncStatus=PENDING
     |
     '---> [SyncService]      -- if connected --> [ConvexService]
                                                       |
                                                       v
                                               [Convex Cloud Database]
                                                       |
                                                       v
                                               [Future Next.js CRM]

Background (WorkManager):
  Every 15 min when connected:
    read PENDING rows -> upload -> mark SYNCED

### Call Type Detection (Kotlin state machine)

| Phone State Sequence | Detected As |
|----------------------|------------|
| RINGING -> OFFHOOK -> IDLE | INCOMING |
| OFFHOOK -> IDLE (no RINGING) | OUTGOING |
| RINGING -> IDLE (no OFFHOOK) | MISSED |

### Sync Status Flow

Call ends
    |
    v
Save to SQLite (syncStatus = PENDING)
    |
    |--- Internet available? --YES--> Upload to Convex --> SYNCED
    |
    '--- No internet ----------------> Stay PENDING
                                            |
                                      WorkManager retries
                                      every 15 min
                                            |
                                       Upload --> SYNCED
                                       Fails  --> FAILED (retried next cycle)

---

## Database Schema

### Local SQLite (beecbile_calls_db)

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PK | Auto-increment |
| phoneNumber | TEXT | Caller/callee number |
| callType | TEXT | INCOMING / OUTGOING / MISSED |
| startTime | DATETIME | Call start (UTC) |
| endTime | DATETIME? | Call end (UTC) |
| duration | INTEGER | Duration in seconds (0 for missed) |
| deviceId | TEXT | Android ANDROID_ID |
| syncStatus | TEXT | PENDING / SYNCED / FAILED |
| createdAt | DATETIME | Record creation time (UTC) |

### Convex Cloud (calls table)

Same fields as above minus id and syncStatus (Convex manages its own IDs).
Indexes: by_device, by_created_at.

---

## Android Permissions

| Permission | Why Required |
|-----------|-------------|
| READ_PHONE_STATE | Detect call state changes (ringing / answered / ended) |
| READ_CALL_LOG | Read call log for full call details |
| PROCESS_OUTGOING_CALLS | Detect outgoing call numbers (below Android 10) |
| FOREGROUND_SERVICE | Keep call detection alive in background |
| FOREGROUND_SERVICE_PHONE_CALL | Required on Android 14+ for phone foreground services |
| RECEIVE_BOOT_COMPLETED | Re-schedule WorkManager sync after device reboot |
| INTERNET | Upload call records to Convex |
| ACCESS_NETWORK_STATE | Check connectivity before syncing |
| WAKE_LOCK | Allow WorkManager to keep CPU awake during sync |

Note: READ_PHONE_STATE and READ_CALL_LOG are dangerous permissions and require
runtime approval from the user. The app requests them at launch.

---

## Setup & Build Instructions

### Prerequisites

- Flutter SDK >= 3.10
- Dart SDK >= 3.10
- Android SDK with API 23+ (minSdk)
- A Convex account: https://convex.dev

### 1 — Install Flutter dependencies

    cd app
    flutter pub get

### 2 — Generate Drift database code

Run once, and again whenever you change a Drift table or DAO:

    cd app
    dart run build_runner build --delete-conflicting-outputs

This generates:
- lib/core/database/app_database.g.dart
- lib/core/database/daos/call_dao.g.dart

### 3 — Deploy Convex backend

    # From the repo root
    npx convex deploy

After deploy, Convex prints your deployment URL, e.g.:
https://capable-fox-123.convex.cloud

### 4 — Configure Convex URL

Pass the URL at build time:

    flutter run --dart-define=CONVEX_URL=https://capable-fox-123.convex.cloud

For a release APK:

    flutter build apk --dart-define=CONVEX_URL=https://capable-fox-123.convex.cloud

Alternatively edit lib/core/constants/app_constants.dart and replace the defaultValue.

### 5 — Run the app

    flutter run

---

## Screens

### Home Screen
- Status banner: shows ACTIVE when call detection is running
- Registered Calls: total call count from local database
- Internet: current connectivity status
- Last Sync: timestamp of last successful Convex upload
- Recent Calls list: live stream from SQLite with sync status indicators
- Sync button in toolbar for manual upload

### Settings Screen
- Call Tracking Service toggle: ON/OFF (persisted)
- Sync Now button: manual upload with feedback message
- Device ID: shows ANDROID_ID, tap to copy

---

## Convex API

The Flutter app posts to:

POST https://<deployment>.convex.cloud/api/mutation

Body:
{
  "path": "calls:saveCall",
  "args": {
    "phoneNumber": "0612345678",
    "callType": "INCOMING",
    "duration": 120,
    "startTime": "2026-07-16T09:00:00.000Z",
    "endTime": "2026-07-16T09:02:00.000Z",
    "deviceId": "abc123def456",
    "createdAt": "2026-07-16T09:02:01.000Z"
  },
  "format": "json"
}

---

## Phase 2 Roadmap

- Agent login and registration
- Customer dashboard
- Customer search and profiles
- Call notes
- Follow-up reminders
- Next.js CRM web interface reading from the same Convex database

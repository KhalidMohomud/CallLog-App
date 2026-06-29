# CallLog-App

CallLoges is a Flutter-based call logging and dashboard app. The main Flutter project lives inside the `app/` directory.

## Overview

- Flutter application source: `app/`
- Screens: splash, home dashboard, call history, settings
- Navigation powered by `go_router`
- Shared call model with JSON serialization
- Light and dark theme support

## Project structure

- `app/lib/main.dart` — app entrypoint
- `app/lib/app/app.dart` — MaterialApp.router configuration
- `app/lib/app/router/` — routes and route definitions
- `app/lib/features/` — feature folders for home, call history, splash, settings
- `app/lib/core/` — theme, dependency injection, utilities
- `app/lib/shared/` — shared models and widgets

## Getting started

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Open the project in your editor
3. Change into the Flutter app folder:
   ```bash
   cd app
   ```
4. Get dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Useful commands

- `flutter pub get` — install dependencies
- `flutter run` — launch the app on a connected device or emulator
- `flutter build apk` — build Android APK
- `flutter build ios` — build iOS app
- `flutter test` — run Flutter tests

## Dependencies

- `go_router` — routing and navigation
- `equatable` — value equality for model classes
- `cupertino_icons` — icon fonts

## Notes

- The app currently uses sample call data defined in local feature widgets.
- Update `app/lib/shared/models/call_model.dart` for additional call data handling.


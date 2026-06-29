# CallLoges

CallLoges is a Flutter app for viewing recent call activity, exploring call history, and accessing app settings.

## App structure

- `lib/main.dart` — application entrypoint
- `lib/app/app.dart` — root widget and theme/router setup
- `lib/app/router/` — route definitions and navigation
- `lib/features/home/` — home dashboard UI
- `lib/features/call_history/` — call history screen and data
- `lib/features/settings/` — settings screen
- `lib/features/splash/` — splash screen
- `lib/core/theme/` — theming and Material 3 support
- `lib/shared/models/` — shared data models

## Run locally

From the `app/` folder:

```bash
flutter pub get
flutter run
```

## Build targets

- Android: `flutter build apk`
- iOS: `flutter build ios`
- Web: `flutter build web`

## Dependencies

- `go_router` for application routing
- `equatable` for model equality
- `cupertino_icons` for UI icons

## Notes

The current implementation uses hardcoded sample call history data. Extend the app by connecting `call_history` to a platform call log API or remote service.

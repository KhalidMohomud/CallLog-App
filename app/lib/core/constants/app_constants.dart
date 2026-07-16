abstract final class AppConstants {
  // ── Convex Cloud ────────────────────────────────────────────────────────────
  // Set your deployment URL via --dart-define=CONVEX_URL=https://xxx.convex.cloud
  // or replace the defaultValue before building.
  static const String convexDeploymentUrl = String.fromEnvironment(
    'CONVEX_URL',
    defaultValue: 'https://YOUR_DEPLOYMENT.convex.cloud',
  );

  // Convex mutation path  →  convex/calls.ts : saveCall
  static const String convexSaveCallPath = 'calls:saveCall';

  // ── WorkManager ─────────────────────────────────────────────────────────────
  static const String syncTaskName = 'beecbile_call_sync';
  static const String syncTaskTag  = 'beecbile_sync';

  // ── SharedPreferences keys ──────────────────────────────────────────────────
  static const String prefLastSyncTime   = 'last_sync_time';
  static const String prefServiceEnabled = 'service_enabled';
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/app.dart';
import 'core/di/dependency_injection.dart';
import 'core/services/sync/background_sync_worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialise dependency graph (DB, services, etc.)
  await DI.instance.init();

  // 2. Register WorkManager background sync (runs every 15 min when connected)
  await registerBackgroundSync();

  // 3. Request Android runtime permissions
  await _requestPermissions();

  runApp(const BeecbileApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.phone,      // READ_PHONE_STATE
    Permission.contacts,   // used for display names (Phase 2)
  ].request();

  // READ_CALL_LOG requires a separate request on some devices
  final callLogStatus = await Permission.phone.status;
  if (callLogStatus.isDenied) {
    await Permission.phone.request();
  }
}

import 'package:workmanager/workmanager.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/convex/convex_service.dart';
import '../../../core/services/connectivity/connectivity_service.dart';
import '../../../features/call_history/data/datasources/call_local_datasource.dart';
import '../../../features/call_history/data/datasources/call_remote_datasource.dart';
import '../../../shared/models/call_record.dart';

/// Top-level callback required by the workmanager package.
/// Runs in an Isolate – must be annotated with @pragma('vm:entry-point').
@pragma('vm:entry-point')
void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != AppConstants.syncTaskName) {
      return Future.value(true);
    }

    // Each background isolate needs its own DB + service instances.
    final db = AppDatabase();
    final localDs = CallLocalDatasource(db.callDao);
    final remoteDs = CallRemoteDatasource(ConvexService());
    final connectivity = ConnectivityService();

    try {
      final connected = await connectivity.isConnected();
      if (!connected) {
        await db.close();
        return Future.value(true); // retry later via WorkManager policy
      }

      final pending = await localDs.getPendingCalls();
      for (final record in pending) {
        if (record.id == null) continue;
        try {
          await remoteDs.saveCall(record);
          await localDs.updateSyncStatus(record.id!, SyncStatus.synced);
        } catch (_) {
          await localDs.updateSyncStatus(record.id!, SyncStatus.failed);
        }
      }

      await db.close();
      return Future.value(true);
    } catch (_) {
      await db.close();
      return Future.value(false);
    }
  });
}

/// Registers the periodic background sync task.
/// Call once from main() before [runApp].
Future<void> registerBackgroundSync() async {
  await Workmanager().initialize(
    callBackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
    AppConstants.syncTaskName,
    AppConstants.syncTaskName,
    tag: AppConstants.syncTaskTag,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: const Duration(minutes: 1),
  );
}

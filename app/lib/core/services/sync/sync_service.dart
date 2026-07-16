import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/call_history/domain/repositories/call_repository.dart';
import '../../constants/app_constants.dart';
import '../connectivity/connectivity_service.dart';

/// Orchestrates on-demand sync: checks connectivity, uploads pending records,
/// and persists the last-sync timestamp.
class SyncService {
  SyncService({
    required CallRepository repository,
    required ConnectivityService connectivity,
  })  : _repository = repository,
        _connectivity = connectivity;

  final CallRepository _repository;
  final ConnectivityService _connectivity;

  Future<bool> syncNow() async {
    final connected = await _connectivity.isConnected();
    if (!connected) return false;

    await _repository.syncPendingCalls();
    await _persistLastSync();
    return true;
  }

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(AppConstants.prefLastSyncTime);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> _persistLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppConstants.prefLastSyncTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}

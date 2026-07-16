import '../../../../shared/models/call_record.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_local_datasource.dart';
import '../datasources/call_remote_datasource.dart';

class CallRepositoryImpl implements CallRepository {
  const CallRepositoryImpl({
    required CallLocalDatasource local,
    required CallRemoteDatasource remote,
  })  : _local = local,
        _remote = remote;

  final CallLocalDatasource _local;
  final CallRemoteDatasource _remote;

  @override
  Future<void> saveCall(CallRecord record) => _local.insertCall(record);

  @override
  Future<List<CallRecord>> getAllCalls() => _local.getAllCalls();

  @override
  Stream<List<CallRecord>> watchAllCalls() => _local.watchAllCalls();

  @override
  Future<int> getTotalCount() => _local.getTotalCount();

  @override
  Stream<int> watchTotalCount() => _local.watchTotalCount();

  @override
  Future<void> syncPendingCalls() async {
    final pending = await _local.getPendingCalls();
    for (final record in pending) {
      if (record.id == null) continue;
      try {
        await _remote.saveCall(record);
        await _local.updateSyncStatus(record.id!, SyncStatus.synced);
      } catch (_) {
        await _local.updateSyncStatus(record.id!, SyncStatus.failed);
      }
    }
  }
}

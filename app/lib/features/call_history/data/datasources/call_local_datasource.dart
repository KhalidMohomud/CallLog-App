import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/call_dao.dart';
import '../../../../core/database/tables/calls_table.dart';
import '../../../../shared/models/call_record.dart';

class CallLocalDatasource {
  const CallLocalDatasource(this._dao);

  final CallDao _dao;

  Future<void> insertCall(CallRecord record) async {
    await _dao.insertCall(
      CallsTableCompanion.insert(
        phoneNumber: record.phoneNumber,
        callType: record.callType.value,
        startTime: record.startTime,
        endTime: Value(record.endTime),
        duration: Value(record.duration),
        deviceId: record.deviceId,
        syncStatus: Value(record.syncStatus.value),
        createdAt: record.createdAt,
      ),
    );
  }

  Future<void> updateSyncStatus(int id, SyncStatus status) async {
    await _dao.updateSyncStatus(id, status.value);
  }

  Future<List<CallRecord>> getAllCalls() async {
    final rows = await _dao.getAllCalls();
    return rows.map(_toRecord).toList();
  }

  Future<List<CallRecord>> getPendingCalls() async {
    final rows = await _dao.getPendingCalls();
    return rows.map(_toRecord).toList();
  }

  Future<int> getTotalCount() => _dao.getTotalCount();

  Stream<List<CallRecord>> watchAllCalls() =>
      _dao.watchAllCalls().map((rows) => rows.map(_toRecord).toList());

  Stream<int> watchTotalCount() => _dao.watchTotalCount();

  static CallRecord _toRecord(CallsTableData row) => CallRecord(
    id: row.id,
    phoneNumber: row.phoneNumber,
    callType: CallType.fromValue(row.callType),
    startTime: row.startTime,
    endTime: row.endTime,
    duration: row.duration,
    deviceId: row.deviceId,
    syncStatus: SyncStatus.fromValue(row.syncStatus),
    createdAt: row.createdAt,
  );
}

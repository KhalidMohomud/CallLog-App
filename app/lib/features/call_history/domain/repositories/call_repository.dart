import '../../../../shared/models/call_record.dart';

abstract interface class CallRepository {
  /// Persist a completed call locally (SQLite).
  Future<void> saveCall(CallRecord record);

  /// Return all locally stored calls, newest first.
  Future<List<CallRecord>> getAllCalls();

  /// Watch all locally stored calls as a live stream.
  Stream<List<CallRecord>> watchAllCalls();

  /// Return the total number of stored calls.
  Future<int> getTotalCount();

  /// Watch total call count as a live stream.
  Stream<int> watchTotalCount();

  /// Upload pending records to Convex; mark them SYNCED or FAILED.
  Future<void> syncPendingCalls();
}

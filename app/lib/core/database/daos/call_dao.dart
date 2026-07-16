import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../database/tables/calls_table.dart';

part 'call_dao.g.dart';

@DriftAccessor(tables: [CallsTable])
class CallDao extends DatabaseAccessor<AppDatabase> with _$CallDaoMixin {
  CallDao(super.db);

  // ── Writes ─────────────────────────────────────────────────────────────────

  Future<int> insertCall(CallsTableCompanion entry) =>
      into(callsTable).insert(entry);

  Future<void> updateSyncStatus(int id, String status) =>
      (update(callsTable)..where((t) => t.id.equals(id)))
          .write(CallsTableCompanion(syncStatus: Value(status)));

  // ── Reads ──────────────────────────────────────────────────────────────────

  Future<List<CallsTableData>> getAllCalls() =>
      (select(callsTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<CallsTableData>> getPendingCalls() =>
      (select(callsTable)..where((t) => t.syncStatus.equals('PENDING'))).get();

  Future<int> getTotalCount() async {
    final countExpr = callsTable.id.count();
    final query = selectOnly(callsTable)..addColumns([countExpr]);
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  // ── Streams ────────────────────────────────────────────────────────────────

  Stream<List<CallsTableData>> watchAllCalls() =>
      (select(callsTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Stream<int> watchTotalCount() {
    final countExpr = callsTable.id.count();
    final query = selectOnly(callsTable)..addColumns([countExpr]);
    return query.map((row) => row.read(countExpr) ?? 0).watchSingle();
  }
}

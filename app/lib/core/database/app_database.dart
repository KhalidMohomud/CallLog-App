import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/call_dao.dart';
import 'tables/calls_table.dart';

part 'app_database.g.dart';

/// Drift SQLite database.
///
/// After editing this file or any table/DAO, regenerate with:
///   dart run build_runner build --delete-conflicting-outputs
@DriftDatabase(tables: [CallsTable], daos: [CallDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'beecbile_calls_db');
  }
}

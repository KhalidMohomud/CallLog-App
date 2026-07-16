import 'package:drift/drift.dart';

/// Drift table definition for the local call log.
///
/// Column types:
///  - callType   → "INCOMING" | "OUTGOING" | "MISSED"
///  - syncStatus → "PENDING"  | "SYNCED"   | "FAILED"
class CallsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get phoneNumber => text()();

  TextColumn get callType => text()();

  DateTimeColumn get startTime => dateTime()();

  DateTimeColumn get endTime => dateTime().nullable()();

  IntColumn get duration =>
      integer().withDefault(const Constant(0))();

  TextColumn get deviceId => text()();

  TextColumn get syncStatus =>
      text().withDefault(const Constant('PENDING'))();

  DateTimeColumn get createdAt => dateTime()();
}

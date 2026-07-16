// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_dao.dart';

// ignore_for_file: type=lint
mixin _$CallDaoMixin on DatabaseAccessor<AppDatabase> {
  $CallsTableTable get callsTable => attachedDatabase.callsTable;
  CallDaoManager get managers => CallDaoManager(this);
}

class CallDaoManager {
  final _$CallDaoMixin _db;
  CallDaoManager(this._db);
  $$CallsTableTableTableManager get callsTable =>
      $$CallsTableTableTableManager(_db.attachedDatabase, _db.callsTable);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CallsTableTable extends CallsTable
    with TableInfo<$CallsTableTable, CallsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _callTypeMeta = const VerificationMeta(
    'callType',
  );
  @override
  late final GeneratedColumn<String> callType = GeneratedColumn<String>(
    'call_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phoneNumber,
    callType,
    startTime,
    endTime,
    duration,
    deviceId,
    syncStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calls_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CallsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('call_type')) {
      context.handle(
        _callTypeMeta,
        callType.isAcceptableOrUnknown(data['call_type']!, _callTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_callTypeMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      callType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}call_type'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CallsTableTable createAlias(String alias) {
    return $CallsTableTable(attachedDatabase, alias);
  }
}

class CallsTableData extends DataClass implements Insertable<CallsTableData> {
  final int id;
  final String phoneNumber;
  final String callType;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration;
  final String deviceId;
  final String syncStatus;
  final DateTime createdAt;
  const CallsTableData({
    required this.id,
    required this.phoneNumber,
    required this.callType,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.deviceId,
    required this.syncStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['call_type'] = Variable<String>(callType);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['duration'] = Variable<int>(duration);
    map['device_id'] = Variable<String>(deviceId);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CallsTableCompanion toCompanion(bool nullToAbsent) {
    return CallsTableCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      callType: Value(callType),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      duration: Value(duration),
      deviceId: Value(deviceId),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
    );
  }

  factory CallsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallsTableData(
      id: serializer.fromJson<int>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      callType: serializer.fromJson<String>(json['callType']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      duration: serializer.fromJson<int>(json['duration']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'callType': serializer.toJson<String>(callType),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'duration': serializer.toJson<int>(duration),
      'deviceId': serializer.toJson<String>(deviceId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CallsTableData copyWith({
    int? id,
    String? phoneNumber,
    String? callType,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    int? duration,
    String? deviceId,
    String? syncStatus,
    DateTime? createdAt,
  }) => CallsTableData(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    callType: callType ?? this.callType,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    duration: duration ?? this.duration,
    deviceId: deviceId ?? this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  CallsTableData copyWithCompanion(CallsTableCompanion data) {
    return CallsTableData(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      callType: data.callType.present ? data.callType.value : this.callType,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallsTableData(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('callType: $callType, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phoneNumber,
    callType,
    startTime,
    endTime,
    duration,
    deviceId,
    syncStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallsTableData &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.callType == this.callType &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.duration == this.duration &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt);
}

class CallsTableCompanion extends UpdateCompanion<CallsTableData> {
  final Value<int> id;
  final Value<String> phoneNumber;
  final Value<String> callType;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> duration;
  final Value<String> deviceId;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  const CallsTableCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.callType = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CallsTableCompanion.insert({
    this.id = const Value.absent(),
    required String phoneNumber,
    required String callType,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    required String deviceId,
    this.syncStatus = const Value.absent(),
    required DateTime createdAt,
  }) : phoneNumber = Value(phoneNumber),
       callType = Value(callType),
       startTime = Value(startTime),
       deviceId = Value(deviceId),
       createdAt = Value(createdAt);
  static Insertable<CallsTableData> custom({
    Expression<int>? id,
    Expression<String>? phoneNumber,
    Expression<String>? callType,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? duration,
    Expression<String>? deviceId,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (callType != null) 'call_type': callType,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'duration': duration,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CallsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? phoneNumber,
    Value<String>? callType,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<int>? duration,
    Value<String>? deviceId,
    Value<String>? syncStatus,
    Value<DateTime>? createdAt,
  }) {
    return CallsTableCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      callType: callType ?? this.callType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (callType.present) {
      map['call_type'] = Variable<String>(callType.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallsTableCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('callType: $callType, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CallsTableTable callsTable = $CallsTableTable(this);
  late final CallDao callDao = CallDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [callsTable];
}

typedef $$CallsTableTableCreateCompanionBuilder =
    CallsTableCompanion Function({
      Value<int> id,
      required String phoneNumber,
      required String callType,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<int> duration,
      required String deviceId,
      Value<String> syncStatus,
      required DateTime createdAt,
    });
typedef $$CallsTableTableUpdateCompanionBuilder =
    CallsTableCompanion Function({
      Value<int> id,
      Value<String> phoneNumber,
      Value<String> callType,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<int> duration,
      Value<String> deviceId,
      Value<String> syncStatus,
      Value<DateTime> createdAt,
    });

class $$CallsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CallsTableTable> {
  $$CallsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get callType => $composableBuilder(
    column: $table.callType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CallsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CallsTableTable> {
  $$CallsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get callType => $composableBuilder(
    column: $table.callType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CallsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallsTableTable> {
  $$CallsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get callType =>
      $composableBuilder(column: $table.callType, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CallsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CallsTableTable,
          CallsTableData,
          $$CallsTableTableFilterComposer,
          $$CallsTableTableOrderingComposer,
          $$CallsTableTableAnnotationComposer,
          $$CallsTableTableCreateCompanionBuilder,
          $$CallsTableTableUpdateCompanionBuilder,
          (
            CallsTableData,
            BaseReferences<_$AppDatabase, $CallsTableTable, CallsTableData>,
          ),
          CallsTableData,
          PrefetchHooks Function()
        > {
  $$CallsTableTableTableManager(_$AppDatabase db, $CallsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> callType = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CallsTableCompanion(
                id: id,
                phoneNumber: phoneNumber,
                callType: callType,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
                deviceId: deviceId,
                syncStatus: syncStatus,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String phoneNumber,
                required String callType,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
                required String deviceId,
                Value<String> syncStatus = const Value.absent(),
                required DateTime createdAt,
              }) => CallsTableCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                callType: callType,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
                deviceId: deviceId,
                syncStatus: syncStatus,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CallsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CallsTableTable,
      CallsTableData,
      $$CallsTableTableFilterComposer,
      $$CallsTableTableOrderingComposer,
      $$CallsTableTableAnnotationComposer,
      $$CallsTableTableCreateCompanionBuilder,
      $$CallsTableTableUpdateCompanionBuilder,
      (
        CallsTableData,
        BaseReferences<_$AppDatabase, $CallsTableTable, CallsTableData>,
      ),
      CallsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CallsTableTableTableManager get callsTable =>
      $$CallsTableTableTableManager(_db, _db.callsTable);
}

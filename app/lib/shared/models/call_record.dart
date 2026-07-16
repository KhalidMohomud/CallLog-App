import 'package:equatable/equatable.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

enum CallType {
  incoming('INCOMING'),
  outgoing('OUTGOING'),
  missed('MISSED');

  const CallType(this.value);
  final String value;

  static CallType fromValue(String v) =>
      CallType.values.firstWhere((e) => e.value == v.toUpperCase(),
          orElse: () => CallType.incoming);
}

enum SyncStatus {
  pending('PENDING'),
  synced('SYNCED'),
  failed('FAILED');

  const SyncStatus(this.value);
  final String value;

  static SyncStatus fromValue(String v) =>
      SyncStatus.values.firstWhere((e) => e.value == v.toUpperCase(),
          orElse: () => SyncStatus.pending);
}

// ─────────────────────────────────────────────────────────────────────────────
// Domain entity
// ─────────────────────────────────────────────────────────────────────────────

class CallRecord extends Equatable {
  const CallRecord({
    this.id,
    required this.phoneNumber,
    required this.callType,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.deviceId,
    required this.syncStatus,
    required this.createdAt,
  });

  final int? id;
  final String phoneNumber;
  final CallType callType;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration;       // seconds
  final String deviceId;
  final SyncStatus syncStatus;
  final DateTime createdAt;

  CallRecord copyWith({
    int? id,
    String? phoneNumber,
    CallType? callType,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? deviceId,
    SyncStatus? syncStatus,
    DateTime? createdAt,
  }) {
    return CallRecord(
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

  /// Serialise to the JSON body expected by the Convex saveCall mutation.
  Map<String, dynamic> toConvexJson() => <String, dynamic>{
        'phoneNumber': phoneNumber,
        'callType': callType.value,
        'duration': duration,
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime?.toUtc().toIso8601String(),
        'deviceId': deviceId,
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  @override
  List<Object?> get props => <Object?>[
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
}

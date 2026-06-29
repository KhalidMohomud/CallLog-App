import 'package:equatable/equatable.dart';

class CallModel extends Equatable {
  const CallModel({
    required this.phoneNumber,
    required this.calledAt,
    required this.status,
    required this.duration,
    required this.deviceId,
  });

  final String phoneNumber;
  final DateTime calledAt;
  final String status;
  final int duration;
  final String deviceId;

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      phoneNumber: json['phoneNumber'] as String,
      calledAt: DateTime.parse(json['calledAt'] as String),
      status: json['status'] as String,
      duration: json['duration'] as int,
      deviceId: json['deviceId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'calledAt': calledAt.toIso8601String(),
      'status': status,
      'duration': duration,
      'deviceId': deviceId,
    };
  }

  CallModel copyWith({
    String? phoneNumber,
    DateTime? calledAt,
    String? status,
    int? duration,
    String? deviceId,
  }) {
    return CallModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      calledAt: calledAt ?? this.calledAt,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    phoneNumber,
    calledAt,
    status,
    duration,
    deviceId,
  ];
}

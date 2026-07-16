import 'dart:async';

import 'package:flutter/services.dart';

import '../../../shared/models/call_record.dart';

/// Flutter-side proxy for the Kotlin CallChannelHandler.
///
/// Sends "startListening" / "stopListening" method calls to native and
/// receives "onCallEvent" callbacks which are parsed into [CallRecord] objects.
class CallChannelService {
  CallChannelService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel(_channelName);

  static const String _channelName = 'com.example.app/calls';

  final MethodChannel _channel;
  final StreamController<CallRecord> _controller =
      StreamController<CallRecord>.broadcast();

  Stream<CallRecord> get callEvents => _controller.stream;

  void initialize() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  Future<void> startListening() async {
    initialize();
    await _channel.invokeMethod<void>('startListening');
  }

  Future<void> stopListening() async {
    await _channel.invokeMethod<void>('stopListening');
  }

  Future<void> dispose() async {
    await stopListening();
    _channel.setMethodCallHandler(null);
    await _controller.close();
  }

  Future<void> _handleNativeCall(MethodCall call) async {
    if (call.method != 'onCallEvent') return;
    final args = call.arguments;
    if (args is! Map) return;

    final Map<String, dynamic> json = Map<String, dynamic>.from(args);
    final record = CallRecord(
      phoneNumber: json['phoneNumber'] as String? ?? '',
      callType: CallType.fromValue(json['callType'] as String? ?? 'INCOMING'),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'] as String)
          : null,
      duration: json['duration'] as int? ?? 0,
      deviceId: json['deviceId'] as String? ?? '',
      syncStatus: SyncStatus.pending,
      createdAt: DateTime.now().toUtc(),
    );

    _controller.add(record);
  }
}

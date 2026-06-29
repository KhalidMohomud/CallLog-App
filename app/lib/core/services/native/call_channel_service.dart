import 'dart:async';

import 'package:flutter/services.dart';

import '../../../shared/models/call_model.dart';

class CallChannelService {
  CallChannelService({MethodChannel? methodChannel})
    : _methodChannel = methodChannel ?? const MethodChannel(_channelName);

  static const String _channelName = 'com.example.app/calls';

  final MethodChannel _methodChannel;
  final StreamController<CallModel> _callEventsController =
      StreamController<CallModel>.broadcast();

  MethodChannel get methodChannel => _methodChannel;

  Stream<CallModel> get callEvents => _callEventsController.stream;

  void initialize() {
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> startListening() {
    initialize();

    return _methodChannel.invokeMethod<void>('startListening');
  }

  Future<void> stopListening() {
    return _methodChannel.invokeMethod<void>('stopListening');
  }

  Future<void> dispose() async {
    await stopListening();
    _methodChannel.setMethodCallHandler(null);
    await _callEventsController.close();
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method != 'onCallEvent') {
      return;
    }

    final Object? arguments = call.arguments;
    if (arguments is! Map) {
      return;
    }

    final Map<String, dynamic> json = Map<String, dynamic>.from(arguments);
    _callEventsController.add(CallModel.fromJson(json));
  }
}

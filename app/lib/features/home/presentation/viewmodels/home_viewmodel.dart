import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/sync/sync_service.dart';
import '../../../../shared/models/call_record.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    _init();
  }

  final DI _di = DI.instance;

  // ── State ──────────────────────────────────────────────────────────────────

  List<CallRecord> recentCalls = const [];
  int totalCallCount = 0;
  bool isConnected = false;
  bool serviceActive = true;
  DateTime? lastSyncTime;
  bool isSyncing = false;
  String? errorMessage;

  StreamSubscription<List<CallRecord>>? _callsSub;
  StreamSubscription<bool>? _connectivitySub;
  StreamSubscription<CallRecord>? _newCallSub;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> _init() async {
    await _loadPrefs();

    // Watch database for live call list
    _callsSub = _di.callRepository.watchAllCalls().listen((calls) {
      recentCalls = calls;
      totalCallCount = calls.length;
      notifyListeners();
    });

    // Watch connectivity changes
    _connectivitySub =
        _di.connectivityService.onConnectivityChanged.listen((connected) {
      isConnected = connected;
      notifyListeners();
      if (connected) _backgroundSync();
    });

    // Check current connectivity
    isConnected = await _di.connectivityService.isConnected();
    notifyListeners();

    // Start listening to native phone events
    if (serviceActive) {
      await _startCallListening();
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    serviceActive =
        prefs.getBool(AppConstants.prefServiceEnabled) ?? true;
    final ms = prefs.getInt(AppConstants.prefLastSyncTime);
    if (ms != null) {
      lastSyncTime = DateTime.fromMillisecondsSinceEpoch(ms);
    }
  }

  Future<void> _startCallListening() async {
    try {
      await _di.callChannelService.startListening();
      _newCallSub = _di.callChannelService.callEvents.listen(_onNewCall);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _onNewCall(CallRecord record) async {
    await _di.callRepository.saveCall(record);
    if (isConnected) {
      _backgroundSync();
    }
  }

  Future<void> _backgroundSync() async {
    if (isSyncing) return;
    isSyncing = true;
    notifyListeners();
    try {
      final success = await _di.syncService.syncNow();
      if (success) {
        lastSyncTime = DateTime.now();
      }
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  // ── Public actions ─────────────────────────────────────────────────────────

  Future<void> syncNow() => _backgroundSync();

  @override
  void dispose() {
    _callsSub?.cancel();
    _connectivitySub?.cancel();
    _newCallSub?.cancel();
    _di.callChannelService.stopListening();
    super.dispose();
  }
}

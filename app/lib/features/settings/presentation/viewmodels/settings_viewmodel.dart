import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../shared/models/call_record.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel() {
    _init();
  }

  final DI _di = DI.instance;

  // ── State ──────────────────────────────────────────────────────────────────

  bool serviceEnabled = true;
  String deviceId = '';
  DateTime? lastSyncTime;
  bool isSyncing = false;
  String? syncMessage;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> _init() async {
    await _loadPrefs();
    await _loadDeviceId();
    lastSyncTime = await _di.syncService.getLastSyncTime();
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    serviceEnabled = prefs.getBool(AppConstants.prefServiceEnabled) ?? true;
  }

  Future<void> _loadDeviceId() async {
    final info = DeviceInfoPlugin();
    final android = await info.androidInfo;
    deviceId = android.id;
    notifyListeners();
  }

  // ── Public actions ─────────────────────────────────────────────────────────

  Future<void> toggleService(bool enabled) async {
    serviceEnabled = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefServiceEnabled, enabled);

    if (enabled) {
      await _di.callChannelService.startListening();
    } else {
      await _di.callChannelService.stopListening();
    }
  }

  Future<void> syncNow() async {
    if (isSyncing) return;
    isSyncing = true;
    syncMessage = null;
    notifyListeners();

    try {
      final success = await _di.syncService.syncNow();
      if (success) {
        lastSyncTime = DateTime.now();
        syncMessage = 'Sync completed successfully.';
      } else {
        syncMessage = 'No internet connection. Records queued.';
      }
    } catch (e) {
      syncMessage = 'Sync failed: $e';
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }
}

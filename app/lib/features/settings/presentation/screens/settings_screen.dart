import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = SettingsViewModel();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) => _SettingsView(vm: _vm),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView({required this.vm});

  final SettingsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Call Service toggle ───────────────────────────────────────────
          SwitchListTile(
            secondary: const Icon(Icons.phone_outlined),
            title: const Text('Call Tracking Service'),
            subtitle: Text(vm.serviceEnabled ? 'ON — Detecting calls' : 'OFF — Paused'),
            value: vm.serviceEnabled,
            onChanged: vm.toggleService,
          ),
          const Divider(),

          // ── Sync Now ─────────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: const Text('Sync Now'),
            subtitle: vm.lastSyncTime != null
                ? Text('Last sync: ${_formatDateTime(vm.lastSyncTime!)}')
                : const Text('Never synced'),
            trailing: vm.isSyncing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: vm.isSyncing ? null : vm.syncNow,
          ),

          // ── Sync feedback ─────────────────────────────────────────────────
          if (vm.syncMessage != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                vm.syncMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
          const Divider(),

          // ── Device ID ─────────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.smartphone_outlined),
            title: const Text('Device ID'),
            subtitle: Text(
              vm.deviceId.isEmpty ? 'Loading…' : vm.deviceId,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            trailing: vm.deviceId.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Copy',
                    icon: const Icon(Icons.copy_outlined),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: vm.deviceId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Device ID copied'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),

          // ── App version ──────────────────────────────────────────────────
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            subtitle: Text('Beecbile Call Tracker v1.0.0 – Phase 1'),
          ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime dt) {
  final local = dt.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$month/$day/${local.year}  $hour:$minute $period';
}

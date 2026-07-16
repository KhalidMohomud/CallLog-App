import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/models/call_record.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = HomeViewModel();
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
      builder: (context, _) => _HomeView(vm: _vm),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beecbile Call Tracker'),
        actions: [
          if (vm.isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            tooltip: 'Sync now',
            onPressed: vm.isSyncing ? null : vm.syncNow,
            icon: const Icon(Icons.sync_outlined),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.goNamed(AppRoute.settings.name),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Status banner ─────────────────────────────────────────────────
          _StatusBanner(
            serviceActive: vm.serviceActive,
            isConnected: vm.isConnected,
            lastSyncTime: vm.lastSyncTime,
          ),
          const SizedBox(height: 16),

          // ── Metric cards ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.phone_in_talk_outlined,
                  label: 'Registered Calls',
                  value: '${vm.totalCallCount}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  icon: vm.isConnected
                      ? Icons.cloud_done_outlined
                      : Icons.cloud_off_outlined,
                  label: 'Internet',
                  value: vm.isConnected ? 'Connected' : 'Offline',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Error message ─────────────────────────────────────────────────
          if (vm.errorMessage != null) ...[
            _ErrorBanner(message: vm.errorMessage!),
            const SizedBox(height: 16),
          ],

          // ── Recent calls list ─────────────────────────────────────────────
          Text('Recent Calls', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          if (vm.recentCalls.isEmpty)
            const _EmptyCallsPlaceholder()
          else
            for (final call in vm.recentCalls.take(20)) ...[
              _CallCard(record: call),
              const SizedBox(height: 8),
            ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.callHistory.name),
        icon: const Icon(Icons.history_outlined),
        label: const Text('Full History'),
      ),
    );
  }
}

// ─── Status banner ──────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.serviceActive,
    required this.isConnected,
    required this.lastSyncTime,
  });

  final bool serviceActive;
  final bool isConnected;
  final DateTime? lastSyncTime;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  serviceActive ? Icons.check_circle : Icons.cancel,
                  color: serviceActive ? const Color(0xFF2E7D32) : colors.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: ${serviceActive ? 'ACTIVE' : 'INACTIVE'}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            if (lastSyncTime != null) ...[
              const SizedBox(height: 6),
              Text(
                'Last Sync: ${_formatTime(lastSyncTime!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onPrimaryContainer,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Metric card ─────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.primary),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ─── Call card ───────────────────────────────────────────────────────────────

class _CallCard extends StatelessWidget {
  const _CallCard({required this.record});

  final CallRecord record;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor(colors),
          foregroundColor: colors.surface,
          child: Icon(_icon()),
        ),
        title: Text(
          record.phoneNumber.isEmpty ? 'Unknown' : record.phoneNumber,
        ),
        subtitle: Text(_formatTime(record.startTime)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TypeChip(callType: record.callType),
            const SizedBox(height: 4),
            _SyncDot(status: record.syncStatus),
          ],
        ),
      ),
    );
  }

  IconData _icon() {
    return switch (record.callType) {
      CallType.incoming => Icons.call_received,
      CallType.outgoing => Icons.call_made,
      CallType.missed => Icons.call_missed,
    };
  }

  Color _bgColor(ColorScheme c) {
    return switch (record.callType) {
      CallType.incoming => const Color(0xFF2E7D32),
      CallType.outgoing => c.primary,
      CallType.missed => c.error,
    };
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.callType});

  final CallType callType;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          callType.value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSecondaryContainer,
              ),
        ),
      ),
    );
  }
}

class _SyncDot extends StatelessWidget {
  const _SyncDot({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SyncStatus.synced => const Color(0xFF2E7D32),
      SyncStatus.failed => Theme.of(context).colorScheme.error,
      SyncStatus.pending => Colors.orange,
    };
    final label = switch (status) {
      SyncStatus.synced => 'Synced',
      SyncStatus.failed => 'Failed',
      SyncStatus.pending => 'Pending',
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _EmptyCallsPlaceholder extends StatelessWidget {
  const _EmptyCallsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.phone_missed_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'No calls recorded yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: TextStyle(color: colors.onErrorContainer),
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

String _formatTime(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../shared/models/call_record.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call History')),
      body: StreamBuilder<List<CallRecord>>(
        stream: DI.instance.callRepository.watchAllCalls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final calls = snapshot.data ?? const [];

          if (calls.isEmpty) {
            return const Center(
              child: Text('No call records stored yet.'),
            );
          }

          return Column(
            children: [
              _CountBanner(count: calls.length),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: calls.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _CallHistoryCard(record: calls[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CountBanner extends StatelessWidget {
  const _CountBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.history_outlined, color: colors.onPrimaryContainer),
              const SizedBox(width: 12),
              Text(
                '$count stored calls',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallHistoryCard extends StatelessWidget {
  const _CallHistoryCard({required this.record});

  final CallRecord record;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _avatarColor(colors),
              foregroundColor: colors.surface,
              child: Icon(_icon()),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.phoneNumber.isEmpty ? 'Unknown' : record.phoneNumber,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDateTime(record.startTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                  if (record.callType != CallType.missed) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDuration(record.duration),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _TypeBadge(callType: record.callType),
                const SizedBox(height: 4),
                _SyncBadge(status: record.syncStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon() => switch (record.callType) {
        CallType.incoming => Icons.call_received,
        CallType.outgoing => Icons.call_made,
        CallType.missed => Icons.call_missed,
      };

  Color _avatarColor(ColorScheme c) => switch (record.callType) {
        CallType.incoming => const Color(0xFF2E7D32),
        CallType.outgoing => c.primary,
        CallType.missed => c.error,
      };
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.callType});

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

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SyncStatus.synced => const Color(0xFF2E7D32),
      SyncStatus.failed => Theme.of(context).colorScheme.error,
      SyncStatus.pending => Colors.orange,
    };
    return Text(
      status.value,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
    );
  }
}

String _formatDateTime(DateTime dt) {
  final l = dt.toLocal();
  final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
  final m = l.minute.toString().padLeft(2, '0');
  final p = l.hour >= 12 ? 'PM' : 'AM';
  return '${l.month}/${l.day}/${l.year}  $h:$m $p';
}

String _formatDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '${m}m ${s}s';
}

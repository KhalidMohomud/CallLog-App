import 'package:flutter/material.dart';

import '../../../../shared/models/call_model.dart';

final List<CallModel> _callHistory = <CallModel>[
  CallModel(
    phoneNumber: '+252 61 234 5678',
    calledAt: DateTime(2026, 6, 29, 9, 24),
    status: 'Incoming',
    duration: 84,
    deviceId: 'android-primary',
  ),
  CallModel(
    phoneNumber: '+252 63 987 1200',
    calledAt: DateTime(2026, 6, 29, 11, 8),
    status: 'Missed',
    duration: 0,
    deviceId: 'android-primary',
  ),
  CallModel(
    phoneNumber: '+252 65 456 9012',
    calledAt: DateTime(2026, 6, 29, 14, 42),
    status: 'Outgoing',
    duration: 221,
    deviceId: 'android-primary',
  ),
  CallModel(
    phoneNumber: '+252 68 771 4400',
    calledAt: DateTime(2026, 6, 28, 18, 6),
    status: 'Incoming',
    duration: 132,
    deviceId: 'android-primary',
  ),
];

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Call History')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.history_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_callHistory.length} recent calls',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final CallModel call in _callHistory) ...<Widget>[
            _CallHistoryCard(call: call),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CallHistoryCard extends StatelessWidget {
  const _CallHistoryCard({required this.call});

  final CallModel call;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.onTertiaryContainer,
                  child: const Icon(Icons.phone_outlined),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    call.phoneNumber,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _StatusChip(status: call.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: _CallMetaItem(
                    label: 'Date',
                    value: _formatDate(call.calledAt),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CallMetaItem(
                    label: 'Time',
                    value: _formatTime(call.calledAt),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          status,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

class _CallMetaItem extends StatelessWidget {
  const _CallMetaItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 3),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final String day = value.day.toString().padLeft(2, '0');
  final String month = value.month.toString().padLeft(2, '0');

  return '$month/$day/${value.year}';
}

String _formatTime(DateTime value) {
  final int hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final String minute = value.minute.toString().padLeft(2, '0');
  final String period = value.hour >= 12 ? 'PM' : 'AM';

  return '$hour:$minute $period';
}

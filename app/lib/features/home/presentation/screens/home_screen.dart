import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/models/call_model.dart';

final List<CallModel> _latestCalls = <CallModel>[
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
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.goNamed(AppRoute.settings.name),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _MetricCard(
                  title: "Today's Calls",
                  value: '${_latestCalls.length}',
                  icon: Icons.today_outlined,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _MetricCard(
                  title: 'Total Calls',
                  value: '128',
                  icon: Icons.phone_in_talk_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Latest Calls', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final CallModel call in _latestCalls) ...<Widget>[
            _CallCard(call: call),
            const SizedBox(height: 12),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Call History',
        onPressed: () => context.goNamed(AppRoute.callHistory.name),
        child: const Icon(Icons.history_outlined),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 18),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _CallCard extends StatelessWidget {
  const _CallCard({required this.call});

  final CallModel call;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.call_outlined),
        ),
        title: Text(call.phoneNumber),
        subtitle: Text(
          '${_formatDate(call.calledAt)}  ${_formatTime(call.calledAt)}',
        ),
        trailing: _StatusPill(status: call.status),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

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

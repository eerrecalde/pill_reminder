import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/today_dashboard.dart';

class TodayReminderCard extends StatelessWidget {
  const TodayReminderCard({
    required this.item,
    required this.onMarkHandled,
    super.key,
  });

  final TodayReminderItem item;
  final ValueChanged<TodayReminderItem> onMarkHandled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final statusText = _statusText(l10n, item.status);
    final timeText = DateFormat.jm(
      Localizations.localeOf(context).toString(),
    ).format(item.scheduledDateTime);
    final semanticsLabel = item.dosageLabel.isEmpty
        ? l10n.todayReminderSemantics(item.medicationName, timeText, statusText)
        : l10n.todayReminderSemanticsWithDose(
            item.medicationName,
            item.dosageLabel,
            timeText,
            statusText,
          );

    return Semantics(
      label: semanticsLabel,
      button: item.canMarkHandled,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: item.status == TodayReminderStatus.dueNow
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: item.status == TodayReminderStatus.dueNow
                  ? colorScheme.primary
                  : colorScheme.outline,
              width: item.status == TodayReminderStatus.dueNow ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _StatusChip(status: item.status, label: statusText),
                    Text(
                      timeText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.medicationName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (item.dosageLabel.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.dosageLabel,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                if (item.canMarkHandled) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: Key('mark-handled-${item.id}'),
                      onPressed: () => onMarkHandled(item),
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(l10n.todayMarkHandled),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusText(AppLocalizations l10n, TodayReminderStatus status) {
    return switch (status) {
      TodayReminderStatus.dueNow => l10n.todayReminderStatusDueNow,
      TodayReminderStatus.upcoming => l10n.todayReminderStatusUpcoming,
      TodayReminderStatus.missed => l10n.todayReminderStatusMissed,
      TodayReminderStatus.handled => l10n.todayReminderStatusHandled,
    };
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.label});

  final TodayReminderStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = switch (status) {
      TodayReminderStatus.dueNow => Icons.notifications_active_outlined,
      TodayReminderStatus.upcoming => Icons.schedule,
      TodayReminderStatus.missed => Icons.error_outline,
      TodayReminderStatus.handled => Icons.check_circle_outline,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

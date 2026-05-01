import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/due_reminder.dart';

class DueReminderBanner extends StatelessWidget {
  const DueReminderBanner({
    required this.reminders,
    required this.onOpenReminder,
    super.key,
  });

  final List<DueReminder> reminders;
  final ValueChanged<DueReminder> onOpenReminder;

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.dueReminderBannerSemantics(reminders.length),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.dueReminderBannerTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final reminder in reminders)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton.icon(
                    key: Key('open-due-reminder-${reminder.id}'),
                    onPressed: () => onOpenReminder(reminder),
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: Text(
                      l10n.dueReminderBannerItem(reminder.medicationName),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

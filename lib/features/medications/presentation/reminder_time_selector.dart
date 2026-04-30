import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/reminder_schedule.dart';

class ReminderTimeSelector extends StatelessWidget {
  const ReminderTimeSelector({
    required this.times,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
    this.errorText,
    super.key,
  });

  final List<ReminderTime> times;
  final VoidCallback onAdd;
  final ValueChanged<ReminderTime> onEdit;
  final ValueChanged<ReminderTime> onRemove;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sortedTimes = [...times]..sort();
    return Semantics(
      label: l10n.reminderTimesSemantics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.reminderTimesTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reminderTimesHelp,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final time in sortedTimes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ReminderTimeRow(
                time: time,
                onEdit: () => onEdit(time),
                onRemove: () => onRemove(time),
              ),
            ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              errorText!,
              key: const Key('schedule-validation-message'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            key: const Key('add-reminder-time-button'),
            onPressed: onAdd,
            icon: const Icon(Icons.add_alarm),
            label: Text(l10n.addReminderTime),
          ),
        ],
      ),
    );
  }
}

class _ReminderTimeRow extends StatelessWidget {
  const _ReminderTimeRow({
    required this.time,
    required this.onEdit,
    required this.onRemove,
  });

  final ReminderTime time;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = _formatTime(context, time);
    return Semantics(
      label: l10n.reminderTimeSemantics(text),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.schedule),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: l10n.editReminderTime,
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: l10n.removeReminderTime,
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatReminderTime(BuildContext context, ReminderTime time) {
  return _formatTime(context, time);
}

String _formatTime(BuildContext context, ReminderTime time) {
  return TimeOfDay(hour: time.hour, minute: time.minute).format(context);
}

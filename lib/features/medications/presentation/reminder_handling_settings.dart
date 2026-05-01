import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/reminder_handling_preferences.dart';

class ReminderHandlingSettings extends StatelessWidget {
  const ReminderHandlingSettings({
    required this.preferences,
    required this.onChanged,
    super.key,
  });

  final ReminderHandlingPreferences preferences;
  final ValueChanged<ReminderHandlingPreferences> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reminderHandlingSettingsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          key: const Key('remind-again-later-interval-field'),
          initialValue: preferences.remindAgainLaterIntervalMinutes,
          decoration: InputDecoration(
            labelText: l10n.reminderHandlingIntervalLabel,
          ),
          items: const [10, 15, 30, 60]
              .map(
                (minutes) => DropdownMenuItem<int>(
                  value: minutes,
                  child: Text('$minutes minutes'),
                ),
              )
              .toList(),
          onChanged: (minutes) {
            if (minutes == null) return;
            onChanged(
              preferences.copyWith(
                remindAgainLaterIntervalMinutes: minutes,
                updatedAt: DateTime.now(),
              ),
            );
          },
        ),
      ],
    );
  }
}

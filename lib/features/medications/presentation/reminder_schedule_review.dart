import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication.dart';
import '../domain/reminder_schedule.dart';
import 'reminder_time_selector.dart';

class ReminderScheduleReview extends StatelessWidget {
  const ReminderScheduleReview({
    required this.medication,
    required this.times,
    required this.notificationMessage,
    this.endDate,
    this.errorText,
    super.key,
  });

  final Medication medication;
  final List<ReminderTime> times;
  final DateTime? endDate;
  final String notificationMessage;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sortedTimes = [...times]..sort();
    final timeText = sortedTimes
        .map((time) => formatReminderTime(context, time))
        .join(', ');
    final endText = endDate == null
        ? l10n.scheduleRepeatsIndefinitely
        : l10n.scheduleStopsOn(_formatDate(context, endDate!));
    return Semantics(
      label:
          '${l10n.reviewScheduleTitle}. ${medication.name}. $timeText. $endText. $notificationMessage',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.reviewScheduleTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(l10n.scheduleMedicationSummary(medication.name)),
              const SizedBox(height: 8),
              Text(l10n.scheduleTimesSummary(timeText)),
              const SizedBox(height: 8),
              Text(endText),
              const SizedBox(height: 8),
              Text(notificationMessage),
              if (errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorText!,
                  key: const Key('schedule-review-validation-message'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String formatReminderDate(BuildContext context, DateTime date) {
  return _formatDate(context, date);
}

String _formatDate(BuildContext context, DateTime date) {
  return DateFormat.yMMMd(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(date);
}

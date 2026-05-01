import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication_history.dart';

class MedicationHistoryStatusLabel extends StatelessWidget {
  const MedicationHistoryStatusLabel({required this.status, super.key});

  final MedicationHistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = textFor(AppLocalizations.of(context), status);
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
            Icon(_iconFor(status), size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String textFor(AppLocalizations l10n, MedicationHistoryStatus status) {
    return switch (status) {
      MedicationHistoryStatus.taken => l10n.medicationHistoryStatusTaken,
      MedicationHistoryStatus.skipped => l10n.medicationHistoryStatusSkipped,
      MedicationHistoryStatus.missed => l10n.medicationHistoryStatusMissed,
      MedicationHistoryStatus.snoozed => l10n.medicationHistoryStatusSnoozed,
    };
  }

  IconData _iconFor(MedicationHistoryStatus status) {
    return switch (status) {
      MedicationHistoryStatus.taken => Icons.check_circle_outline,
      MedicationHistoryStatus.skipped => Icons.remove_circle_outline,
      MedicationHistoryStatus.missed => Icons.schedule_outlined,
      MedicationHistoryStatus.snoozed => Icons.notifications_paused_outlined,
    };
  }
}

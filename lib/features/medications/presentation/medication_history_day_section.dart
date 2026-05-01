import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication_history.dart';
import 'medication_history_status_label.dart';

class MedicationHistoryDaySection extends StatelessWidget {
  const MedicationHistoryDaySection({required this.group, super.key});

  final MedicationHistoryDayGroup group;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toString();
    final dayText = DateFormat.yMMMMEEEEd(localeName).format(group.localDate);
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            label: AppLocalizations.of(
              context,
            ).medicationHistoryDaySemantics(dayText),
            child: Text(dayText, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 12),
          for (final entry in group.entries) _HistoryRow(entry: entry),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final MedicationHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final timeText = DateFormat.jm(
      Localizations.localeOf(context).toString(),
    ).format(entry.scheduledAt);
    final statusText = MedicationHistoryStatusLabel.textFor(l10n, entry.status);
    final dayText = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toString(),
    ).format(entry.localDate);
    final semanticsLabel = entry.dosageLabel.isEmpty
        ? l10n.medicationHistoryRowSemantics(
            dayText,
            entry.medicationName,
            timeText,
            statusText,
          )
        : l10n.medicationHistoryRowSemanticsWithDose(
            dayText,
            entry.medicationName,
            entry.dosageLabel,
            timeText,
            statusText,
          );

    return Semantics(
      label: semanticsLabel,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
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
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    MedicationHistoryStatusLabel(status: entry.status),
                    Text(
                      timeText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  entry.medicationName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (entry.dosageLabel.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    entry.dosageLabel,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

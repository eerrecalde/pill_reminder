import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication.dart';
import 'medication_status_label.dart';

class MedicationListSection extends StatelessWidget {
  const MedicationListSection({
    required this.medications,
    this.onScheduleMedication,
    super.key,
  });

  final List<Medication> medications;
  final ValueChanged<Medication>? onScheduleMedication;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (medications.isEmpty) {
      return Semantics(
        label: '${l10n.medicationsEmptyTitle}. ${l10n.medicationsEmptyBody}',
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.medicationsEmptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.medicationsEmptyBody,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.medicationsSectionTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...medications.map(
          (medication) => _MedicationTile(
            medication,
            onScheduleMedication: onScheduleMedication,
          ),
        ),
      ],
    );
  }
}

class _MedicationTile extends StatelessWidget {
  const _MedicationTile(this.medication, {this.onScheduleMedication});

  final Medication medication;
  final ValueChanged<Medication>? onScheduleMedication;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final details = [
      if (medication.dosageLabel.isNotEmpty) medication.dosageLabel,
      if (medication.notes.isNotEmpty) medication.notes,
      medication.isActive
          ? l10n.medicationAvailableForReminders
          : l10n.medicationStoredInactive,
    ];

    return Padding(
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
              Text(
                medication.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              MedicationStatusLabel(status: medication.status),
              const SizedBox(height: 10),
              for (final detail in details)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    detail,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (onScheduleMedication != null) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  key: Key('schedule-medication-${medication.id}'),
                  onPressed: medication.isActive
                      ? () => onScheduleMedication!(medication)
                      : null,
                  icon: const Icon(Icons.schedule),
                  label: Text(l10n.scheduleReminderTitle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

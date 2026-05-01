import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication.dart';
import 'medication_status_label.dart';

class MedicationListSection extends StatelessWidget {
  const MedicationListSection({
    required this.medications,
    this.onScheduleMedication,
    this.onEditMedication,
    this.onPauseMedication,
    this.onResumeMedication,
    this.onDeleteMedication,
    super.key,
  });

  final List<Medication> medications;
  final ValueChanged<Medication>? onScheduleMedication;
  final ValueChanged<Medication>? onEditMedication;
  final ValueChanged<Medication>? onPauseMedication;
  final ValueChanged<Medication>? onResumeMedication;
  final ValueChanged<Medication>? onDeleteMedication;

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
            onEditMedication: onEditMedication,
            onPauseMedication: onPauseMedication,
            onResumeMedication: onResumeMedication,
            onDeleteMedication: onDeleteMedication,
          ),
        ),
      ],
    );
  }
}

class _MedicationTile extends StatelessWidget {
  const _MedicationTile(
    this.medication, {
    this.onScheduleMedication,
    this.onEditMedication,
    this.onPauseMedication,
    this.onResumeMedication,
    this.onDeleteMedication,
  });

  final Medication medication;
  final ValueChanged<Medication>? onScheduleMedication;
  final ValueChanged<Medication>? onEditMedication;
  final ValueChanged<Medication>? onPauseMedication;
  final ValueChanged<Medication>? onResumeMedication;
  final ValueChanged<Medication>? onDeleteMedication;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final details = [
      if (medication.dosageLabel.isNotEmpty) medication.dosageLabel,
      if (medication.notes.isNotEmpty) medication.notes,
      if (medication.isActive) l10n.medicationAvailableForReminders,
      if (medication.isPaused) l10n.medicationPausedExplanation,
      if (medication.status == MedicationStatus.inactive)
        l10n.medicationStoredInactive,
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
              if (_hasActions) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (onEditMedication != null)
                      OutlinedButton.icon(
                        key: Key('edit-medication-${medication.id}'),
                        onPressed: () => onEditMedication!(medication),
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(l10n.editMedicationAction),
                      ),
                    if (onScheduleMedication != null)
                      OutlinedButton.icon(
                        key: Key('schedule-medication-${medication.id}'),
                        onPressed: medication.isActive || medication.isPaused
                            ? () => onScheduleMedication!(medication)
                            : null,
                        icon: const Icon(Icons.schedule),
                        label: Text(l10n.scheduleReminderTitle),
                      ),
                    if (medication.isPaused && onResumeMedication != null)
                      FilledButton.icon(
                        key: Key('resume-medication-${medication.id}'),
                        onPressed: () => onResumeMedication!(medication),
                        icon: const Icon(Icons.play_arrow_outlined),
                        label: Text(l10n.resumeRemindersAction),
                      )
                    else if (medication.isActive && onPauseMedication != null)
                      OutlinedButton.icon(
                        key: Key('pause-medication-${medication.id}'),
                        onPressed: () => onPauseMedication!(medication),
                        icon: const Icon(Icons.notifications_paused_outlined),
                        label: Text(l10n.pauseRemindersAction),
                      ),
                    if (onDeleteMedication != null)
                      TextButton.icon(
                        key: Key('delete-medication-${medication.id}'),
                        onPressed: () => onDeleteMedication!(medication),
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.deleteMedicationAction),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasActions =>
      onScheduleMedication != null ||
      onEditMedication != null ||
      onPauseMedication != null ||
      onResumeMedication != null ||
      onDeleteMedication != null;
}

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication.dart';

enum MedicationDeleteConfirmationTarget { schedule, medication }

Future<bool> showMedicationDeleteConfirmationDialog({
  required BuildContext context,
  required Medication medication,
  required MedicationDeleteConfirmationTarget target,
}) async {
  final l10n = AppLocalizations.of(context);
  final title = switch (target) {
    MedicationDeleteConfirmationTarget.schedule =>
      l10n.deleteScheduleConfirmationTitle,
    MedicationDeleteConfirmationTarget.medication =>
      l10n.deleteMedicationConfirmationTitle,
  };
  final message = switch (target) {
    MedicationDeleteConfirmationTarget.schedule =>
      l10n.deleteScheduleConfirmationMessage(medication.name),
    MedicationDeleteConfirmationTarget.medication =>
      l10n.deleteMedicationConfirmationMessage(medication.name),
  };
  final confirm = switch (target) {
    MedicationDeleteConfirmationTarget.schedule => l10n.deleteScheduleAction,
    MedicationDeleteConfirmationTarget.medication =>
      l10n.deleteMedicationAction,
  };

  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Semantics(
            label: '$title. $message. ${l10n.deleteFinalWarning}',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                const SizedBox(height: 12),
                Text(l10n.deleteFinalWarning),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_outline),
              label: Text(confirm),
            ),
          ],
        ),
      ) ??
      false;
}

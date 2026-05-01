import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication.dart';

class MedicationStatusLabel extends StatelessWidget {
  const MedicationStatusLabel({required this.status, super.key});

  final MedicationStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (status) {
      MedicationStatus.active => l10n.medicationStatusActive,
      MedicationStatus.paused => l10n.medicationStatusPaused,
      MedicationStatus.inactive => l10n.medicationStatusInactive,
    };
    final semanticsLabel = switch (status) {
      MedicationStatus.active => l10n.medicationStatusActiveSemantics,
      MedicationStatus.paused => l10n.medicationStatusPausedSemantics,
      MedicationStatus.inactive => l10n.medicationStatusInactiveSemantics,
    };
    final icon = switch (status) {
      MedicationStatus.active => Icons.check_circle_outline,
      MedicationStatus.paused => Icons.notifications_paused_outlined,
      MedicationStatus.inactive => Icons.pause_circle_outline,
    };
    final color = switch (status) {
      MedicationStatus.active => Theme.of(context).colorScheme.primaryContainer,
      MedicationStatus.paused => Theme.of(
        context,
      ).colorScheme.secondaryContainer,
      MedicationStatus.inactive => Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest,
    };

    return Semantics(
      label: semanticsLabel,
      child: Chip(
        avatar: Icon(icon),
        label: Text(label),
        backgroundColor: color,
      ),
    );
  }
}

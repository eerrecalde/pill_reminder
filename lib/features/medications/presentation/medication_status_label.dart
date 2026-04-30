import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/medication.dart';

class MedicationStatusLabel extends StatelessWidget {
  const MedicationStatusLabel({required this.status, super.key});

  final MedicationStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isActive = status == MedicationStatus.active;
    final label = isActive
        ? l10n.medicationStatusActive
        : l10n.medicationStatusInactive;
    final semanticsLabel = isActive
        ? l10n.medicationStatusActiveSemantics
        : l10n.medicationStatusInactiveSemantics;

    return Semantics(
      label: semanticsLabel,
      child: Chip(
        avatar: Icon(
          isActive ? Icons.check_circle_outline : Icons.pause_circle_outline,
        ),
        label: Text(label),
        backgroundColor: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

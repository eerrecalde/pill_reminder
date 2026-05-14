import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class DataDeletionConfirmationDialog extends StatelessWidget {
  const DataDeletionConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.settingsDeleteConfirmationTitle),
      content: Text(l10n.settingsDeleteConfirmationBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.settingsDeleteConfirmAction),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/due_reminder.dart';

class DueReminderActions extends StatelessWidget {
  const DueReminderActions({
    required this.onAction,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<ReminderActionType> onAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _ActionButton(
          key: const Key('due-reminder-taken-button'),
          icon: Icons.check_circle_outline,
          label: l10n.dueReminderTakenAction,
          enabled: enabled,
          onPressed: () => onAction(ReminderActionType.taken),
        ),
        _ActionButton(
          key: const Key('due-reminder-skip-button'),
          icon: Icons.block,
          label: l10n.dueReminderSkipAction,
          enabled: enabled,
          onPressed: () => onAction(ReminderActionType.skipped),
        ),
        _ActionButton(
          key: const Key('due-reminder-later-button'),
          icon: Icons.snooze,
          label: l10n.dueReminderLaterAction,
          enabled: enabled,
          onPressed: () => onAction(ReminderActionType.remindAgainLater),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56, minWidth: 148),
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

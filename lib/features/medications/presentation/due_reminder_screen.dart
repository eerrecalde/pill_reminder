import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/reminder_action_handler.dart';
import '../../setup/domain/notification_permission_status.dart';
import '../domain/due_reminder.dart';
import 'due_reminder_actions.dart';

class DueReminderScreen extends StatefulWidget {
  const DueReminderScreen({
    required this.initialReminder,
    required this.actionHandler,
    required this.notificationPermissionStatus,
    super.key,
  });

  final DueReminder initialReminder;
  final ReminderActionHandler actionHandler;
  final SetupNotificationPermissionStatus notificationPermissionStatus;

  @override
  State<DueReminderScreen> createState() => _DueReminderScreenState();
}

class _DueReminderScreenState extends State<DueReminderScreen> {
  late DueReminder _reminder = widget.initialReminder;
  bool _saving = false;

  Future<void> _handleAction(ReminderActionType action) async {
    setState(() => _saving = true);
    final result = await widget.actionHandler.handle(
      dueReminderId: _reminder.id,
      actionType: action,
      source: ReminderActionSource.inApp,
    );
    if (!mounted) return;
    setState(() {
      _reminder = result?.reminder ?? _reminder;
      _saving = false;
    });
    SemanticsService.sendAnnouncement(
      View.of(context),
      _stateText(context, _reminder),
      Directionality.of(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stateText = _stateText(context, _reminder);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dueReminderTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    _reminder.medicationName,
                    key: const Key('due-reminder-medication-name'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 12),
                if (_reminder.dosageLabel.isNotEmpty)
                  Text(
                    _reminder.dosageLabel,
                    key: const Key('due-reminder-dosage-label'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                const SizedBox(height: 12),
                Text(
                  l10n.dueReminderScheduledTime(
                    _formatTime(context, _reminder.scheduledAt),
                  ),
                  key: const Key('due-reminder-scheduled-time'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  label: stateText,
                  child: Text(
                    stateText,
                    key: const Key('due-reminder-state'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (!_notificationsAvailable(
                  widget.notificationPermissionStatus,
                ))
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _permissionText(
                        context,
                        widget.notificationPermissionStatus,
                      ),
                      key: const Key('due-reminder-permission-guidance'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                const SizedBox(height: 24),
                DueReminderActions(
                  enabled: !_saving && !_reminder.isFinal,
                  onAction: _handleAction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _notificationsAvailable(SetupNotificationPermissionStatus status) {
    return status == SetupNotificationPermissionStatus.granted;
  }

  String _stateText(BuildContext context, DueReminder reminder) {
    final l10n = AppLocalizations.of(context);
    return switch (reminder.state) {
      DueReminderState.taken => l10n.dueReminderStateTaken,
      DueReminderState.skipped => l10n.dueReminderStateSkipped,
      DueReminderState.remindAgainLater => l10n.dueReminderStateLater,
      DueReminderState.unresolved => l10n.dueReminderStateUnresolved,
    };
  }

  String _permissionText(
    BuildContext context,
    SetupNotificationPermissionStatus status,
  ) {
    final l10n = AppLocalizations.of(context);
    return switch (status) {
      SetupNotificationPermissionStatus.blocked =>
        l10n.dueReminderPermissionBlocked,
      SetupNotificationPermissionStatus.unavailable =>
        l10n.dueReminderPermissionUnavailable,
      _ => l10n.dueReminderPermissionNeeded,
    };
  }

  String _formatTime(BuildContext context, DateTime time) {
    return DateFormat.jm(
      Localizations.localeOf(context).toString(),
    ).format(time);
  }
}

import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/services/reminder_action_handler.dart';

import 'fake_due_reminder_repository.dart';
import 'fake_reminder_notification_scheduler.dart';

class FakeReminderActionHandler extends ReminderActionHandler {
  FakeReminderActionHandler({required this.reminder})
    : super(
        repository: FakeDueReminderRepository([reminder]),
        notificationScheduler: FakeReminderNotificationScheduler(),
      );

  DueReminder reminder;
  final List<ReminderActionType> actions = [];

  @override
  Future<ReminderActionResult?> handle({
    required String dueReminderId,
    required ReminderActionType actionType,
    required ReminderActionSource source,
    DateTime? now,
  }) async {
    actions.add(actionType);
    final timestamp = now ?? DateTime(2026, 5, 1, 8);
    reminder = switch (actionType) {
      ReminderActionType.taken => reminder.markTaken(
        at: timestamp,
        source: source,
      ),
      ReminderActionType.skipped => reminder.markSkipped(
        at: timestamp,
        source: source,
      ),
      ReminderActionType.remindAgainLater => reminder.remindAgainLater(
        requestedAt: timestamp,
        intervalMinutes: 10,
        source: source,
      ),
    };
    return ReminderActionResult(reminder: reminder, changed: true);
  }
}

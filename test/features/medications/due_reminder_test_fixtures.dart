import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/medications/domain/reminder_handling_preferences.dart';

DueReminder dueReminderFixture({
  String medicationId = 'med-1',
  String scheduleId = 'schedule-1',
  DateTime? scheduledAt,
  String medicationName = 'Aspirin',
  String dosageLabel = '1 tablet',
  DueReminderState state = DueReminderState.unresolved,
}) {
  final dueAt = scheduledAt ?? DateTime(2026, 5, 1, 8);
  final createdAt = DateTime(2026, 5, 1, 8, 1);
  final base = DueReminder.create(
    medicationId: medicationId,
    scheduleId: scheduleId,
    scheduledAt: dueAt,
    medicationName: medicationName,
    dosageLabel: dosageLabel,
    now: createdAt,
  );
  return switch (state) {
    DueReminderState.taken => base.markTaken(
      at: createdAt,
      source: ReminderActionSource.inApp,
    ),
    DueReminderState.skipped => base.markSkipped(
      at: createdAt,
      source: ReminderActionSource.inApp,
    ),
    DueReminderState.remindAgainLater => base.remindAgainLater(
      requestedAt: createdAt,
      intervalMinutes:
          ReminderHandlingPreferences.defaultRemindAgainLaterIntervalMinutes,
      source: ReminderActionSource.inApp,
    ),
    DueReminderState.unresolved => base,
  };
}

NotificationActionRequest notificationActionRequestFixture({
  required String dueReminderId,
  ReminderActionType actionType = ReminderActionType.taken,
}) {
  return NotificationActionRequest(
    dueReminderId: dueReminderId,
    actionType: actionType,
    receivedAt: DateTime(2026, 5, 1, 8, 5),
  );
}

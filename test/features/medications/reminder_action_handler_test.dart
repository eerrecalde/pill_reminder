import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/medications/domain/reminder_handling_preferences.dart';
import 'package:pill_reminder/services/reminder_action_handler.dart';

import 'due_reminder_test_fixtures.dart';
import 'fakes/fake_due_reminder_repository.dart';
import 'fakes/fake_reminder_notification_scheduler.dart';

void main() {
  test('handles in-app taken, skipped, and remind later actions', () async {
    final reminder = dueReminderFixture();
    final repository = FakeDueReminderRepository([reminder]);
    repository.preferences = const ReminderHandlingPreferences(
      remindAgainLaterIntervalMinutes: 15,
    );
    final scheduler = FakeReminderNotificationScheduler();
    final handler = ReminderActionHandler(
      repository: repository,
      notificationScheduler: scheduler,
    );

    await handler.handle(
      dueReminderId: reminder.id,
      actionType: ReminderActionType.remindAgainLater,
      source: ReminderActionSource.inApp,
      now: DateTime(2026, 5, 1, 8, 1),
    );

    final later = await repository.loadDueReminder(reminder.id);
    expect(later?.state, DueReminderState.remindAgainLater);
    expect(later?.remindAgainLaterRequest?.intervalMinutes, 15);
    expect(scheduler.laterReminders, hasLength(1));
  });

  test(
    'notification actions keep final state unchanged after stale action',
    () async {
      final reminder = dueReminderFixture();
      final repository = FakeDueReminderRepository([reminder]);
      final handler = ReminderActionHandler(
        repository: repository,
        notificationScheduler: FakeReminderNotificationScheduler(),
      );

      await handler.handle(
        dueReminderId: reminder.id,
        actionType: ReminderActionType.taken,
        source: ReminderActionSource.notification,
        now: DateTime(2026, 5, 1, 8, 1),
      );
      await handler.handle(
        dueReminderId: reminder.id,
        actionType: ReminderActionType.skipped,
        source: ReminderActionSource.notification,
        now: DateTime(2026, 5, 1, 8, 2),
      );

      final saved = await repository.loadDueReminder(reminder.id);
      expect(saved?.state, DueReminderState.taken);
      expect(saved?.outcome?.outcomeType, ReminderActionType.taken);
    },
  );

  test('repeated remind later replaces pending request', () async {
    final reminder = dueReminderFixture();
    final repository = FakeDueReminderRepository([reminder]);
    final handler = ReminderActionHandler(
      repository: repository,
      notificationScheduler: FakeReminderNotificationScheduler(),
    );

    await handler.handle(
      dueReminderId: reminder.id,
      actionType: ReminderActionType.remindAgainLater,
      source: ReminderActionSource.inApp,
      now: DateTime(2026, 5, 1, 8, 1),
    );
    await handler.handle(
      dueReminderId: reminder.id,
      actionType: ReminderActionType.remindAgainLater,
      source: ReminderActionSource.notification,
      now: DateTime(2026, 5, 1, 8, 5),
    );

    final saved = await repository.loadDueReminder(reminder.id);
    expect(saved?.remindAgainLaterRequest?.requestedAt.minute, 5);
  });
}

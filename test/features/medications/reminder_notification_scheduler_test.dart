import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/services/reminder_notification_scheduler.dart';

import 'due_reminder_test_fixtures.dart';
import 'fakes/fake_reminder_notification_scheduler.dart';
import 'reminder_schedule_test_fixtures.dart';

void main() {
  test('maps permission states to delivery results', () async {
    final scheduler = FakeReminderNotificationScheduler();
    final schedule = reminderScheduleFixture();

    expect(
      (await scheduler.schedule(
        schedule,
        title: 'Title',
        body: 'Body',
        permissionStatus: SetupNotificationPermissionStatus.granted,
      )).status,
      ReminderNotificationScheduleStatus.scheduled,
    );
    expect(
      (await scheduler.schedule(
        schedule,
        title: 'Title',
        body: 'Body',
        permissionStatus: SetupNotificationPermissionStatus.denied,
      )).deliveryState,
      isNotNull,
    );
  });

  test(
    'records due reminder notification and later reminder scheduling',
    () async {
      final scheduler = FakeReminderNotificationScheduler();
      final reminder = dueReminderFixture();

      await scheduler.showDueReminder(
        reminder,
        title: 'Aspirin',
        body: '1 tablet',
        permissionStatus: SetupNotificationPermissionStatus.granted,
      );
      await scheduler.scheduleLaterReminder(
        reminder.remindAgainLater(
          requestedAt: DateTime(2026, 5, 1, 8),
          intervalMinutes: 10,
          source: reminder.lastActionSource,
        ),
      );

      expect(scheduler.shownDueReminders, [reminder]);
      expect(scheduler.laterReminders, hasLength(1));
    },
  );
}

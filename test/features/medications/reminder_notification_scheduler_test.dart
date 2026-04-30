import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/services/reminder_notification_scheduler.dart';

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
}

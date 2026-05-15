import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/services/reminder_notification_scheduler.dart';

import '../notifications/fakes/fake_notification_ringtone_repository.dart';
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
    'tracks current-day suppression for an upcoming handled reminder',
    () async {
      final scheduler = FakeReminderNotificationScheduler();
      final schedule = reminderScheduleFixture();
      final time = reminderTimeFixture(hour: 20);

      await scheduler.suppressTodayForTime(
        schedule,
        time,
        title: 'Title',
        body: 'Body',
        permissionStatus: SetupNotificationPermissionStatus.granted,
      );

      expect(scheduler.suppressedTimes, [time]);
    },
  );

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

  test(
    'builds selected ringtone details for recurring and due notifications',
    () async {
      final ringtoneRepository = FakeNotificationRingtoneRepository(
        selectedRingtoneId: 'gentle_chime',
      );
      final scheduler = LocalReminderNotificationScheduler(
        ringtoneRepository: ringtoneRepository,
      );

      final daily = await scheduler.dailyNotificationDetailsForTest();
      final due = await scheduler.dueNotificationDetailsForTest();

      expect(
        daily.android!.channelId,
        'daily_medication_reminders_gentle_chime',
      );
      expect(daily.iOS!.sound, 'gentle_chime.wav');
      expect(
        (daily.android!.sound as RawResourceAndroidNotificationSound).sound,
        'gentle_chime',
      );
      expect(daily.android!.actions, isNotEmpty);

      expect(due.android!.channelId, 'due_medication_reminders_gentle_chime');
      expect(due.iOS!.categoryIdentifier, reminderNotificationCategoryId);
    },
  );

  test(
    'uses default sound details when saved ringtone is unavailable',
    () async {
      const unavailableOption = RingtoneOption(
        id: 'old_chime',
        displayNameKey: 'notificationRingtoneGentleChime',
        previewAssetPath: 'assets/audio/notifications/gentle_chime.wav',
        androidRawResourceName: 'gentle_chime',
        iosSoundFileName: 'gentle_chime.wav',
        isDefault: false,
        isAvailable: false,
      );
      final scheduler = LocalReminderNotificationScheduler(
        ringtoneRepository: FakeNotificationRingtoneRepository(
          options: [...bundledNotificationRingtones, unavailableOption],
          selectedRingtoneId: 'old_chime',
        ),
      );

      final daily = await scheduler.dailyNotificationDetailsForTest(
        includeActions: false,
      );

      expect(daily.android!.channelId, 'daily_medication_reminders');
      expect(daily.android!.sound, isNull);
      expect(daily.iOS!.sound, isNull);
      expect(daily.android!.actions, isNull);
    },
  );
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../features/medications/domain/due_reminder.dart';
import '../features/medications/domain/reminder_schedule.dart';
import '../features/notifications/data/local_notification_ringtone_repository.dart';
import '../features/notifications/data/notification_ringtone_repository.dart';
import '../features/notifications/domain/notification_ringtone.dart';
import '../features/setup/domain/notification_permission_status.dart';

const reminderActionTakenId = 'taken';
const reminderActionSkippedId = 'skipped';
const reminderActionLaterId = 'remindAgainLater';
const reminderNotificationCategoryId = 'medication_due_reminder';

enum ReminderNotificationScheduleStatus {
  scheduled,
  deferredForPermission,
  blocked,
  unavailable,
}

class ReminderNotificationScheduleResult {
  const ReminderNotificationScheduleResult(this.status);

  final ReminderNotificationScheduleStatus status;

  ReminderNotificationDeliveryState get deliveryState {
    return switch (status) {
      ReminderNotificationScheduleStatus.scheduled =>
        ReminderNotificationDeliveryState.deliverable,
      ReminderNotificationScheduleStatus.deferredForPermission =>
        ReminderNotificationDeliveryState.permissionNeeded,
      ReminderNotificationScheduleStatus.blocked =>
        ReminderNotificationDeliveryState.blocked,
      ReminderNotificationScheduleStatus.unavailable =>
        ReminderNotificationDeliveryState.unavailable,
    };
  }
}

abstract class ReminderNotificationScheduler {
  Future<void> initialize();

  Future<ReminderNotificationScheduleResult> schedule(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  });

  Future<void> cancelForSchedule(ReminderSchedule schedule);

  Future<void> cancelAllForSchedules(List<ReminderSchedule> schedules);

  Future<ReminderNotificationScheduleResult> refreshForMedication(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  });

  Future<void> cancelForMedication(ReminderSchedule schedule);

  Future<void> cancelDueAndLaterForMedication(List<DueReminder> reminders);

  Future<void> suppressTodayForTime(
    ReminderSchedule schedule,
    ReminderTime reminderTime, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  });

  Future<void> showDueReminder(
    DueReminder reminder, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  });

  Future<void> scheduleLaterReminder(DueReminder reminder);

  Future<void> cancelDueReminder(DueReminder reminder);
}

class LocalReminderNotificationScheduler
    implements ReminderNotificationScheduler {
  LocalReminderNotificationScheduler({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
    NotificationRingtoneRepository? ringtoneRepository,
  }) : _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin(),
       _ringtoneRepository =
           ringtoneRepository ?? const DefaultNotificationRingtoneRepository();

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final NotificationRingtoneRepository _ringtoneRepository;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await _configureLocalTimeZone();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          reminderNotificationCategoryId,
          actions: [
            DarwinNotificationAction.plain(reminderActionTakenId, 'Taken'),
            DarwinNotificationAction.plain(reminderActionSkippedId, 'Skip'),
            DarwinNotificationAction.plain(
              reminderActionLaterId,
              'Remind later',
            ),
          ],
        ),
      ],
    );
    final settings = InitializationSettings(android: android, iOS: darwin);
    await _notificationsPlugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<void> _configureLocalTimeZone() async {
    tz_data.initializeTimeZones();
    if (kIsWeb || Platform.isLinux || Platform.isWindows) return;

    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } on Object {
      // Keep timezone's default local location when the platform plugin cannot
      // resolve the device timezone. Scheduling still works, but less precisely.
    }
  }

  @override
  Future<ReminderNotificationScheduleResult> schedule(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    await initialize();
    final unavailableResult = _resultForPermission(permissionStatus);
    if (unavailableResult != null) return unavailableResult;

    for (final time in schedule.sortedReminderTimes) {
      await _notificationsPlugin.zonedSchedule(
        id: _notificationId(schedule, time),
        title: title,
        body: body,
        scheduledDate: _nextDailyReminder(time),
        notificationDetails: await _dailyNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
    return const ReminderNotificationScheduleResult(
      ReminderNotificationScheduleStatus.scheduled,
    );
  }

  @override
  Future<void> cancelForSchedule(ReminderSchedule schedule) async {
    await initialize();
    for (final time in schedule.reminderTimes) {
      await _notificationsPlugin.cancel(id: _notificationId(schedule, time));
    }
  }

  @override
  Future<void> cancelAllForSchedules(List<ReminderSchedule> schedules) async {
    for (final schedule in schedules) {
      await cancelForSchedule(schedule);
    }
  }

  @override
  Future<ReminderNotificationScheduleResult> refreshForMedication(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    await cancelForSchedule(schedule);
    return this.schedule(
      schedule,
      title: title,
      body: body,
      permissionStatus: permissionStatus,
    );
  }

  @override
  Future<void> cancelForMedication(ReminderSchedule schedule) {
    return cancelForSchedule(schedule);
  }

  @override
  Future<void> cancelDueAndLaterForMedication(
    List<DueReminder> reminders,
  ) async {
    for (final reminder in reminders) {
      await cancelDueReminder(reminder);
    }
  }

  @override
  Future<void> suppressTodayForTime(
    ReminderSchedule schedule,
    ReminderTime reminderTime, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    await initialize();
    if (_resultForPermission(permissionStatus) != null) return;

    await _notificationsPlugin.cancel(
      id: _notificationId(schedule, reminderTime),
    );
    await _notificationsPlugin.zonedSchedule(
      id: _notificationId(schedule, reminderTime),
      title: title,
      body: body,
      scheduledDate: _nextDailyReminder(
        reminderTime,
      ).add(const Duration(days: 1)),
      notificationDetails: await _dailyNotificationDetails(
        includeActions: false,
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> showDueReminder(
    DueReminder reminder, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    await initialize();
    if (_resultForPermission(permissionStatus) != null) return;
    await _notificationsPlugin.show(
      id: _dueNotificationId(reminder),
      title: title,
      body: body,
      notificationDetails: await _dueNotificationDetails(),
      payload: reminder.id,
    );
  }

  @override
  Future<void> scheduleLaterReminder(DueReminder reminder) async {
    await initialize();
    final request = reminder.remindAgainLaterRequest;
    if (request == null) return;
    await _notificationsPlugin.zonedSchedule(
      id: _laterNotificationId(reminder),
      title: reminder.medicationName,
      body: reminder.dosageLabel.isEmpty
          ? 'Reminder from ${_formatHourMinute(reminder.scheduledAt)}'
          : '${reminder.dosageLabel} - ${_formatHourMinute(reminder.scheduledAt)}',
      scheduledDate: tz.TZDateTime.from(request.nextReminderAt, tz.local),
      notificationDetails: await _dueNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: reminder.id,
    );
  }

  @override
  Future<void> cancelDueReminder(DueReminder reminder) async {
    await initialize();
    await _notificationsPlugin.cancel(id: _dueNotificationId(reminder));
    await _notificationsPlugin.cancel(id: _laterNotificationId(reminder));
  }

  ReminderNotificationScheduleResult? _resultForPermission(
    SetupNotificationPermissionStatus status,
  ) {
    return switch (status) {
      SetupNotificationPermissionStatus.granted => null,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        const ReminderNotificationScheduleResult(
          ReminderNotificationScheduleStatus.deferredForPermission,
        ),
      SetupNotificationPermissionStatus.blocked =>
        const ReminderNotificationScheduleResult(
          ReminderNotificationScheduleStatus.blocked,
        ),
      SetupNotificationPermissionStatus.unavailable =>
        const ReminderNotificationScheduleResult(
          ReminderNotificationScheduleStatus.unavailable,
        ),
    };
  }

  int _notificationId(ReminderSchedule schedule, ReminderTime time) {
    return Object.hash(schedule.medicationId, time.hour, time.minute) &
        0x7fffffff;
  }

  int _dueNotificationId(DueReminder reminder) {
    return Object.hash('due', reminder.id) & 0x7fffffff;
  }

  int _laterNotificationId(DueReminder reminder) {
    return Object.hash('later', reminder.id) & 0x7fffffff;
  }

  String _formatHourMinute(DateTime time) {
    final minute = time.minute.toString().padLeft(2, '0');
    return '${time.hour}:$minute';
  }

  @visibleForTesting
  Future<NotificationDetails> dailyNotificationDetailsForTest({
    bool includeActions = true,
  }) {
    return _dailyNotificationDetails(includeActions: includeActions);
  }

  @visibleForTesting
  Future<NotificationDetails> dueNotificationDetailsForTest() {
    return _dueNotificationDetails();
  }

  Future<NotificationDetails> _dailyNotificationDetails({
    bool includeActions = true,
  }) async {
    final option = await _resolvedRingtoneOption();
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId('daily_medication_reminders', option),
        'Daily medication reminders',
        channelDescription: 'Daily medication reminder alerts',
        importance: Importance.high,
        priority: Priority.high,
        sound: _androidSound(option),
        actions: includeActions ? _androidActions : null,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: includeActions
            ? reminderNotificationCategoryId
            : null,
        sound: _iosSound(option),
      ),
    );
  }

  Future<NotificationDetails> _dueNotificationDetails() async {
    final option = await _resolvedRingtoneOption();
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId('due_medication_reminders', option),
        'Due medication reminders',
        channelDescription: 'Medication reminders that are due now',
        importance: Importance.high,
        priority: Priority.high,
        sound: _androidSound(option),
        actions: _androidActions,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: reminderNotificationCategoryId,
        sound: _iosSound(option),
      ),
    );
  }

  Future<RingtoneOption> _resolvedRingtoneOption() async {
    final preference = await _ringtoneRepository.loadPreference();
    return preference.resolvedOption;
  }

  String _channelId(String baseId, RingtoneOption option) {
    return option.isDefault ? baseId : '${baseId}_${option.id}';
  }

  AndroidNotificationSound? _androidSound(RingtoneOption option) {
    final resourceName = option.androidRawResourceName;
    if (option.isDefault || resourceName == null) return null;
    return RawResourceAndroidNotificationSound(resourceName);
  }

  String? _iosSound(RingtoneOption option) {
    if (option.isDefault) return null;
    return option.iosSoundFileName;
  }

  tz.TZDateTime _nextDailyReminder(ReminderTime time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

const _androidActions = [
  AndroidNotificationAction(reminderActionTakenId, 'Taken'),
  AndroidNotificationAction(reminderActionSkippedId, 'Skip'),
  AndroidNotificationAction(reminderActionLaterId, 'Remind later'),
];

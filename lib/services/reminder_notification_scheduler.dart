import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../features/medications/domain/reminder_schedule.dart';
import '../features/setup/domain/notification_permission_status.dart';

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

  Future<void> suppressTodayForTime(
    ReminderSchedule schedule,
    ReminderTime reminderTime, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  });
}

class LocalReminderNotificationScheduler
    implements ReminderNotificationScheduler {
  LocalReminderNotificationScheduler({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await _configureLocalTimeZone();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: darwin);
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
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_medication_reminders',
            'Daily medication reminders',
            channelDescription: 'Daily medication reminder alerts',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
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
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_medication_reminders',
          'Daily medication reminders',
          channelDescription: 'Daily medication reminder alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
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

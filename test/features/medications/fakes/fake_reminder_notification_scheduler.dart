import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/services/reminder_notification_scheduler.dart';

class FakeReminderNotificationScheduler
    implements ReminderNotificationScheduler {
  final List<ReminderSchedule> scheduled = [];
  final List<ReminderSchedule> cancelled = [];
  final List<ReminderSchedule> cancelledForMedication = [];
  final List<String> calls = [];
  final List<ReminderTime> suppressedTimes = [];
  final List<DueReminder> shownDueReminders = [];
  final List<DueReminder> laterReminders = [];
  final List<DueReminder> cancelledDueReminders = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<void> cancelForSchedule(ReminderSchedule schedule) async {
    calls.add('cancelForSchedule');
    cancelled.add(schedule);
  }

  @override
  Future<void> cancelForMedication(ReminderSchedule schedule) async {
    calls.add('cancelForMedication');
    cancelledForMedication.add(schedule);
    cancelled.add(schedule);
  }

  @override
  Future<void> cancelDueReminder(DueReminder reminder) async {
    calls.add('cancelDueReminder');
    cancelledDueReminders.add(reminder);
  }

  @override
  Future<void> cancelDueAndLaterForMedication(
    List<DueReminder> reminders,
  ) async {
    calls.add('cancelDueAndLaterForMedication');
    cancelledDueReminders.addAll(reminders);
  }

  @override
  Future<ReminderNotificationScheduleResult> schedule(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    calls.add('schedule');
    scheduled.add(schedule);
    final status = switch (permissionStatus) {
      SetupNotificationPermissionStatus.granted =>
        ReminderNotificationScheduleStatus.scheduled,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        ReminderNotificationScheduleStatus.deferredForPermission,
      SetupNotificationPermissionStatus.blocked =>
        ReminderNotificationScheduleStatus.blocked,
      SetupNotificationPermissionStatus.unavailable =>
        ReminderNotificationScheduleStatus.unavailable,
    };
    return ReminderNotificationScheduleResult(status);
  }

  @override
  Future<ReminderNotificationScheduleResult> refreshForMedication(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    calls.add('refreshForMedication');
    cancelled.add(schedule);
    return this.schedule(
      schedule,
      title: title,
      body: body,
      permissionStatus: permissionStatus,
    );
  }

  @override
  Future<void> suppressTodayForTime(
    ReminderSchedule schedule,
    ReminderTime reminderTime, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    calls.add('suppressTodayForTime');
    suppressedTimes.add(reminderTime);
  }

  @override
  Future<void> scheduleLaterReminder(DueReminder reminder) async {
    calls.add('scheduleLaterReminder');
    laterReminders.add(reminder);
  }

  @override
  Future<void> showDueReminder(
    DueReminder reminder, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    calls.add('showDueReminder');
    if (permissionStatus == SetupNotificationPermissionStatus.granted) {
      shownDueReminders.add(reminder);
    }
  }
}

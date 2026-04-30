import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/services/reminder_notification_scheduler.dart';

class FakeReminderNotificationScheduler
    implements ReminderNotificationScheduler {
  final List<ReminderSchedule> scheduled = [];
  final List<ReminderSchedule> cancelled = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<void> cancelForSchedule(ReminderSchedule schedule) async {
    cancelled.add(schedule);
  }

  @override
  Future<ReminderNotificationScheduleResult> schedule(
    ReminderSchedule schedule, {
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
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
}

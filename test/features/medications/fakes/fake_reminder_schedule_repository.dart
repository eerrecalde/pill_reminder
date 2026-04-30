import 'package:pill_reminder/features/medications/data/reminder_schedule_repository.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';

class FakeReminderScheduleRepository implements ReminderScheduleRepository {
  FakeReminderScheduleRepository([List<ReminderSchedule>? initialSchedules])
    : _schedules = [...?initialSchedules];

  final List<ReminderSchedule> _schedules;
  int saveCount = 0;

  @override
  Future<List<ReminderSchedule>> loadSchedules() async {
    return List.unmodifiable(_schedules);
  }

  @override
  Future<ReminderSchedule?> loadScheduleForMedication(
    String medicationId,
  ) async {
    for (final schedule in _schedules) {
      if (schedule.medicationId == medicationId) return schedule;
    }
    return null;
  }

  @override
  Future<ReminderSchedule> saveSchedule({
    required String medicationId,
    required List<ReminderTime> reminderTimes,
    DateTime? endDate,
    ReminderNotificationDeliveryState notificationDeliveryState =
        ReminderNotificationDeliveryState.permissionNeeded,
  }) async {
    saveCount += 1;
    final now = DateTime(2026, 4, 30, 8, saveCount);
    final existing = await loadScheduleForMedication(medicationId);
    final schedule = ReminderSchedule(
      id: existing?.id ?? 'schedule-$saveCount',
      medicationId: medicationId,
      reminderTimes: [...reminderTimes]..sort(),
      endDate: endDate,
      notificationDeliveryState: notificationDeliveryState,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    _schedules.removeWhere((item) => item.medicationId == medicationId);
    _schedules.add(schedule);
    return schedule;
  }

  @override
  Future<void> deleteSchedule(String medicationId) async {
    _schedules.removeWhere((item) => item.medicationId == medicationId);
  }
}

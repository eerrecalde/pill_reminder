import '../domain/reminder_schedule.dart';

abstract class ReminderScheduleRepository {
  Future<List<ReminderSchedule>> loadSchedules();

  Future<ReminderSchedule?> loadScheduleForMedication(String medicationId);

  Future<ReminderSchedule> saveSchedule({
    required String medicationId,
    required List<ReminderTime> reminderTimes,
    DateTime? endDate,
    ReminderNotificationDeliveryState notificationDeliveryState,
  });

  Future<void> deleteSchedule(String medicationId);
}

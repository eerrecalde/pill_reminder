import '../domain/daily_reminder_handling.dart';
import '../domain/reminder_schedule.dart';

abstract class DailyReminderHandlingRepository {
  Future<List<DailyReminderHandling>> loadForDate(DateTime localDate);

  Future<DailyReminderHandling> markHandled({
    required DateTime localDate,
    required String scheduleId,
    required String medicationId,
    required ReminderTime reminderTime,
    required DateTime handledAt,
  });
}

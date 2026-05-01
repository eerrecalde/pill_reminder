import '../domain/due_reminder.dart';
import '../domain/reminder_handling_preferences.dart';

abstract class DueReminderRepository {
  Future<List<DueReminder>> loadDueReminders();

  Future<List<DueReminder>> loadUnresolvedDueReminders();

  Future<DueReminder?> loadDueReminder(String id);

  Future<DueReminder?> loadDueReminderForOccurrence({
    required String medicationId,
    required DateTime scheduledAt,
  });

  Future<DueReminder> upsertDueReminder(DueReminder reminder);

  Future<void> deleteDueReminder(String id);

  Future<void> deleteDueRemindersForMedication(String medicationId);

  Future<void> deleteDueRemindersForSchedule(String scheduleId);

  Future<ReminderHandlingPreferences> loadPreferences();

  Future<void> savePreferences(ReminderHandlingPreferences preferences);
}

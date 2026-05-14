import '../../medications/domain/daily_reminder_handling.dart';
import '../../medications/domain/due_reminder.dart';
import '../../medications/domain/medication.dart';
import '../../medications/domain/medication_history.dart';
import '../../medications/domain/reminder_handling_preferences.dart';
import '../../medications/domain/reminder_schedule.dart';

class LocalReminderDataSnapshot {
  const LocalReminderDataSnapshot({
    required this.medications,
    required this.reminderSchedules,
    required this.dueReminders,
    required this.dailyReminderHandling,
    required this.medicationHistory,
    required this.reminderHandlingPreferences,
    required this.capturedAt,
  });

  final List<Medication> medications;
  final List<ReminderSchedule> reminderSchedules;
  final List<DueReminder> dueReminders;
  final List<DailyReminderHandling> dailyReminderHandling;
  final List<MedicationHistoryEntry> medicationHistory;
  final ReminderHandlingPreferences reminderHandlingPreferences;
  final DateTime capturedAt;

  bool get hasLocalReminderData {
    return medications.isNotEmpty ||
        reminderSchedules.isNotEmpty ||
        dueReminders.isNotEmpty ||
        dailyReminderHandling.isNotEmpty ||
        medicationHistory.isNotEmpty;
  }
}

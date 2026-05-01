import 'package:pill_reminder/features/medications/data/due_reminder_repository.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/medications/domain/reminder_handling_preferences.dart';

class FakeDueReminderRepository implements DueReminderRepository {
  FakeDueReminderRepository([List<DueReminder>? initialReminders])
    : _reminders = [...?initialReminders];

  final List<DueReminder> _reminders;
  ReminderHandlingPreferences preferences = const ReminderHandlingPreferences();

  @override
  Future<void> deleteDueReminder(String id) async {
    _reminders.removeWhere((reminder) => reminder.id == id);
  }

  @override
  Future<void> deleteDueRemindersForMedication(String medicationId) async {
    _reminders.removeWhere((reminder) => reminder.medicationId == medicationId);
  }

  @override
  Future<void> deleteDueRemindersForSchedule(String scheduleId) async {
    _reminders.removeWhere((reminder) => reminder.scheduleId == scheduleId);
  }

  @override
  Future<DueReminder?> loadDueReminder(String id) async {
    for (final reminder in _reminders) {
      if (reminder.id == id) return reminder;
    }
    return null;
  }

  @override
  Future<DueReminder?> loadDueReminderForOccurrence({
    required String medicationId,
    required DateTime scheduledAt,
  }) {
    return loadDueReminder(
      DueReminder.stableId(
        medicationId: medicationId,
        scheduledAt: scheduledAt,
      ),
    );
  }

  @override
  Future<List<DueReminder>> loadDueReminders() async {
    return List.unmodifiable(_reminders);
  }

  @override
  Future<List<DueReminder>> loadUnresolvedDueReminders() async {
    return _reminders
        .where((reminder) => !reminder.state.isFinal)
        .toList(growable: false);
  }

  @override
  Future<ReminderHandlingPreferences> loadPreferences() async => preferences;

  @override
  Future<void> savePreferences(ReminderHandlingPreferences preferences) async {
    this.preferences = preferences;
  }

  @override
  Future<DueReminder> upsertDueReminder(DueReminder reminder) async {
    final existing = await loadDueReminder(reminder.id);
    final saved = existing?.state.isFinal ?? false ? existing! : reminder;
    _reminders.removeWhere((item) => item.id == saved.id);
    _reminders.add(saved);
    return saved;
  }
}

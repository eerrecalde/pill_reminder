import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/due_reminder.dart';
import '../domain/reminder_handling_preferences.dart';
import 'due_reminder_repository.dart';

class LocalDueReminderRepository implements DueReminderRepository {
  LocalDueReminderRepository(this._preferences);

  static const _dueRemindersKey = 'medications.dueReminders.v1';
  static const _preferencesKey = 'medications.reminderHandlingPreferences.v1';

  final SharedPreferences _preferences;

  @override
  Future<List<DueReminder>> loadDueReminders() async {
    final rawRecords = _preferences.getStringList(_dueRemindersKey) ?? [];
    return rawRecords
        .map((record) => jsonDecode(record))
        .whereType<Map<String, Object?>>()
        .map(DueReminder.fromJson)
        .where((reminder) => reminder.id.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<List<DueReminder>> loadUnresolvedDueReminders() async {
    final reminders = await loadDueReminders();
    return reminders
        .where((reminder) => !reminder.state.isFinal)
        .toList(growable: false);
  }

  @override
  Future<DueReminder?> loadDueReminder(String id) async {
    final reminders = await loadDueReminders();
    for (final reminder in reminders) {
      if (reminder.id == id) return reminder;
    }
    return null;
  }

  @override
  Future<DueReminder?> loadDueReminderForOccurrence({
    required String medicationId,
    required DateTime scheduledAt,
  }) async {
    final id = DueReminder.stableId(
      medicationId: medicationId,
      scheduledAt: scheduledAt,
    );
    return loadDueReminder(id);
  }

  @override
  Future<DueReminder> upsertDueReminder(DueReminder reminder) async {
    final reminders = await loadDueReminders();
    final existing = reminders
        .where((item) => item.id == reminder.id)
        .firstOrNull;
    final saved = existing == null
        ? reminder
        : _mergeExisting(existing: existing, incoming: reminder);
    final updated = [
      for (final item in reminders)
        if (item.id != saved.id) item,
      saved,
    ];
    await _saveAll(updated);
    return saved;
  }

  DueReminder _mergeExisting({
    required DueReminder existing,
    required DueReminder incoming,
  }) {
    if (existing.state.isFinal) return existing;
    if (incoming.state == DueReminderState.unresolved) {
      return existing.copyWith(
        medicationName: incoming.medicationName,
        dosageLabel: incoming.dosageLabel,
        updatedAt: incoming.updatedAt,
      );
    }
    return incoming;
  }

  @override
  Future<void> deleteDueReminder(String id) async {
    final reminders = await loadDueReminders();
    await _saveAll(
      reminders.where((reminder) => reminder.id != id).toList(growable: false),
    );
  }

  @override
  Future<void> deleteDueRemindersForMedication(String medicationId) async {
    final reminders = await loadDueReminders();
    await _saveAll(
      reminders
          .where((reminder) => reminder.medicationId != medicationId)
          .toList(growable: false),
    );
  }

  @override
  Future<void> deleteDueRemindersForSchedule(String scheduleId) async {
    final reminders = await loadDueReminders();
    await _saveAll(
      reminders
          .where((reminder) => reminder.scheduleId != scheduleId)
          .toList(growable: false),
    );
  }

  @override
  Future<ReminderHandlingPreferences> loadPreferences() async {
    final raw = _preferences.getString(_preferencesKey);
    if (raw == null) return const ReminderHandlingPreferences();
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      return const ReminderHandlingPreferences();
    }
    return ReminderHandlingPreferences.fromJson(decoded);
  }

  @override
  Future<void> savePreferences(ReminderHandlingPreferences preferences) async {
    await _preferences.setString(
      _preferencesKey,
      jsonEncode(preferences.toJson()),
    );
  }

  Future<void> _saveAll(List<DueReminder> reminders) async {
    await _preferences.setStringList(
      _dueRemindersKey,
      reminders.map((reminder) => jsonEncode(reminder.toJson())).toList(),
    );
  }
}

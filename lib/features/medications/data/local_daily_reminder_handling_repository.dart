import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/daily_reminder_handling.dart';
import '../domain/reminder_schedule.dart';
import 'daily_reminder_handling_repository.dart';

class LocalDailyReminderHandlingRepository
    implements DailyReminderHandlingRepository {
  LocalDailyReminderHandlingRepository(this._preferences);

  static const _recordsKey = 'medications.dailyHandling.v1';

  final SharedPreferences _preferences;

  @override
  Future<List<DailyReminderHandling>> loadForDate(DateTime localDate) async {
    final targetDate = _dateOnly(localDate);
    final records = await _loadAll();
    return records
        .where((record) => _isSameDate(record.localDate, targetDate))
        .toList(growable: false);
  }

  @override
  Future<DailyReminderHandling> markHandled({
    required DateTime localDate,
    required String scheduleId,
    required String medicationId,
    required ReminderTime reminderTime,
    required DateTime handledAt,
  }) async {
    final dateOnly = _dateOnly(localDate);
    final id = DailyReminderHandling.buildId(
      localDate: dateOnly,
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: reminderTime,
    );
    final record = DailyReminderHandling(
      id: id,
      localDate: dateOnly,
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: reminderTime,
      handledAt: handledAt,
    );
    final records = await _loadAll();
    final updated = [
      for (final existing in records)
        if (existing.id != id) existing,
      record,
    ];
    await _saveAll(updated);
    return record;
  }

  Future<List<DailyReminderHandling>> _loadAll() async {
    final rawRecords = _preferences.getStringList(_recordsKey) ?? [];
    return rawRecords
        .map((record) => jsonDecode(record))
        .whereType<Map<String, Object?>>()
        .map(DailyReminderHandling.fromJson)
        .where((record) => record.id.isNotEmpty)
        .toList(growable: false);
  }

  Future<void> _saveAll(List<DailyReminderHandling> records) async {
    await _preferences.setStringList(
      _recordsKey,
      records.map((record) => jsonEncode(record.toJson())).toList(),
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

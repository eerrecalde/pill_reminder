import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/reminder_schedule.dart';
import 'reminder_schedule_repository.dart';

class LocalReminderScheduleRepository implements ReminderScheduleRepository {
  LocalReminderScheduleRepository(this._preferences);

  static const _schedulesKey = 'medications.reminderSchedules.v1';

  final SharedPreferences _preferences;

  @override
  Future<List<ReminderSchedule>> loadSchedules() async {
    final rawRecords = _preferences.getStringList(_schedulesKey) ?? [];
    return rawRecords
        .map((record) => jsonDecode(record))
        .whereType<Map<String, Object?>>()
        .map(ReminderSchedule.fromJson)
        .where((schedule) => schedule.id.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<ReminderSchedule?> loadScheduleForMedication(
    String medicationId,
  ) async {
    final schedules = await loadSchedules();
    for (final schedule in schedules) {
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
    final schedules = await loadSchedules();
    final existing = schedules
        .where((schedule) => schedule.medicationId == medicationId)
        .firstOrNull;
    final now = DateTime.now();
    final sortedTimes = [...reminderTimes]..sort();
    final saved = ReminderSchedule(
      id: existing?.id ?? 'schedule-${now.microsecondsSinceEpoch}',
      medicationId: medicationId,
      reminderTimes: sortedTimes,
      endDate: endDate,
      notificationDeliveryState: notificationDeliveryState,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final updated = [
      for (final schedule in schedules)
        if (schedule.medicationId != medicationId) schedule,
      saved,
    ];
    await _saveAll(updated);
    return saved;
  }

  @override
  Future<void> deleteSchedule(String medicationId) async {
    final schedules = await loadSchedules();
    await _saveAll(
      schedules
          .where((schedule) => schedule.medicationId != medicationId)
          .toList(growable: false),
    );
  }

  Future<void> _saveAll(List<ReminderSchedule> schedules) async {
    await _preferences.setStringList(
      _schedulesKey,
      schedules
          .map((schedule) => jsonEncode(schedule.toJson()))
          .toList(growable: false),
    );
  }
}

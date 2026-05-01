import 'package:pill_reminder/features/medications/domain/daily_reminder_handling.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';

import 'medication_test_fixtures.dart';
import 'reminder_schedule_test_fixtures.dart';

DateTime todayDashboardNow({int hour = 9, int minute = 0}) {
  return DateTime(2026, 5, 1, hour, minute);
}

DateTime todayDashboardDate() {
  return DateTime(2026, 5, 1);
}

Medication todayMedicationFixture({
  String id = 'med-1',
  String name = 'Aspirin',
  String dosageLabel = '1 tablet',
  MedicationStatus status = MedicationStatus.active,
}) {
  return medicationFixture(
    id: id,
    name: name,
    dosageLabel: dosageLabel,
    status: status,
  );
}

ReminderSchedule todayScheduleFixture({
  String id = 'schedule-1',
  String medicationId = 'med-1',
  List<ReminderTime>? reminderTimes,
  DateTime? endDate,
}) {
  return reminderScheduleFixture(
    id: id,
    medicationId: medicationId,
    reminderTimes: reminderTimes,
    endDate: endDate,
  );
}

DailyReminderHandling todayHandlingFixture({
  DateTime? localDate,
  String scheduleId = 'schedule-1',
  String medicationId = 'med-1',
  ReminderTime? reminderTime,
  DateTime? handledAt,
}) {
  final time = reminderTime ?? reminderTimeFixture(hour: 8);
  final date = localDate ?? todayDashboardDate();
  return DailyReminderHandling(
    id: DailyReminderHandling.buildId(
      localDate: date,
      scheduleId: scheduleId,
      medicationId: medicationId,
      reminderTime: time,
    ),
    localDate: date,
    scheduleId: scheduleId,
    medicationId: medicationId,
    reminderTime: time,
    handledAt: handledAt ?? DateTime(2026, 5, 1, 8, 5),
  );
}

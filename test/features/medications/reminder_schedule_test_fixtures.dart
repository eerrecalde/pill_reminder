import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';

import 'medication_test_fixtures.dart';

ReminderTime reminderTimeFixture({int hour = 8, int minute = 0}) {
  return ReminderTime(hour: hour, minute: minute);
}

ReminderSchedule reminderScheduleFixture({
  String id = 'schedule-1',
  String medicationId = 'med-1',
  List<ReminderTime>? reminderTimes,
  DateTime? endDate,
  ReminderNotificationDeliveryState notificationDeliveryState =
      ReminderNotificationDeliveryState.deliverable,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final timestamp = DateTime(2026, 4, 30, 9);
  return ReminderSchedule(
    id: id,
    medicationId: medicationId,
    reminderTimes: reminderTimes ?? [reminderTimeFixture()],
    endDate: endDate,
    notificationDeliveryState: notificationDeliveryState,
    createdAt: createdAt ?? timestamp,
    updatedAt: updatedAt ?? timestamp,
  );
}

Medication activeMedicationFixture({
  String id = 'med-1',
  String name = 'Aspirin',
}) {
  return medicationFixture(id: id, name: name);
}

Medication inactiveMedicationFixture({
  String id = 'med-2',
  String name = 'Paused medicine',
}) {
  return medicationFixture(
    id: id,
    name: name,
    status: MedicationStatus.inactive,
  );
}

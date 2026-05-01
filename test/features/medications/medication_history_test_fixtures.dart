import 'package:pill_reminder/features/medications/domain/medication_history.dart';

MedicationHistoryEntry medicationHistoryEntryFixture({
  String id = '2026-05-01|schedule-1|med-1|8:0',
  DateTime? scheduledAt,
  String scheduleId = 'schedule-1',
  String medicationId = 'med-1',
  String medicationName = 'Aspirin',
  String dosageLabel = '1 tablet',
  MedicationHistoryStatus status = MedicationHistoryStatus.taken,
  int? snoozeCount,
}) {
  final scheduled = scheduledAt ?? DateTime(2026, 5, 1, 8);
  final timestamp = DateTime(2026, 5, 1, 8, 5);
  return MedicationHistoryEntry(
    id: id,
    localDate: MedicationHistoryEntry.dateOnly(scheduled),
    scheduledAt: scheduled,
    scheduleId: scheduleId,
    medicationId: medicationId,
    medicationName: medicationName,
    dosageLabel: dosageLabel,
    status: status,
    statusUpdatedAt: timestamp,
    snoozeCount: snoozeCount,
    source: MedicationHistorySource.dueReminder,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

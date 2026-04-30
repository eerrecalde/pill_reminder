import 'package:pill_reminder/features/medications/domain/medication.dart';

Medication medicationFixture({
  String id = 'med-1',
  String name = 'Morning pill',
  String dosageLabel = '',
  String notes = '',
  MedicationStatus status = MedicationStatus.active,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final timestamp = DateTime(2026, 4, 29, 9);
  return Medication(
    id: id,
    name: name,
    dosageLabel: dosageLabel,
    notes: notes,
    status: status,
    createdAt: createdAt ?? timestamp,
    updatedAt: updatedAt ?? timestamp,
  );
}

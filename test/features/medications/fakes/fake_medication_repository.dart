import 'package:pill_reminder/features/medications/data/medication_repository.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';

class FakeMedicationRepository implements MedicationRepository {
  FakeMedicationRepository([List<Medication>? initialMedications])
    : _medications = [...?initialMedications];

  final List<Medication> _medications;

  int saveCount = 0;

  @override
  Future<List<Medication>> loadMedications() async {
    return List.unmodifiable(_medications);
  }

  @override
  Future<Medication> addMedication({
    required String name,
    String dosageLabel = '',
    String notes = '',
    MedicationStatus status = MedicationStatus.active,
  }) async {
    saveCount += 1;
    final now = DateTime(2026, 4, 29, 12, saveCount);
    final medication = Medication(
      id: 'fake-$saveCount',
      name: name.trim(),
      dosageLabel: dosageLabel.trim(),
      notes: notes.trim(),
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    _medications.add(medication);
    return medication;
  }
}

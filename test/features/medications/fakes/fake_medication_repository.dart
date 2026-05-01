import 'package:pill_reminder/features/medications/data/medication_repository.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';

class FakeMedicationRepository implements MedicationRepository {
  FakeMedicationRepository([List<Medication>? initialMedications])
    : _medications = [...?initialMedications];

  final List<Medication> _medications;

  int saveCount = 0;
  int updateCount = 0;
  int pauseCount = 0;
  int resumeCount = 0;
  int deleteCount = 0;

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

  @override
  Future<Medication> updateMedication(Medication medication) async {
    updateCount += 1;
    final existing = _medications
        .where((item) => item.id == medication.id)
        .firstOrNull;
    if (existing == null) throw StateError('Missing medication');
    final updated = medication.copyWith(
      createdAt: existing.createdAt,
      updatedAt: DateTime(2026, 4, 29, 13, updateCount),
    );
    _medications.removeWhere((item) => item.id == updated.id);
    _medications.add(updated);
    return updated;
  }

  @override
  Future<Medication> pauseMedication(String id, {DateTime? pausedAt}) async {
    pauseCount += 1;
    final existing = _medications.where((item) => item.id == id).firstOrNull;
    if (existing == null) throw StateError('Missing medication');
    final now = pausedAt ?? DateTime(2026, 4, 29, 14, pauseCount);
    final updated = existing.copyWith(
      status: MedicationStatus.paused,
      pausedAt: now,
      clearResumedAt: true,
      updatedAt: now,
    );
    _medications.removeWhere((item) => item.id == id);
    _medications.add(updated);
    return updated;
  }

  @override
  Future<Medication> resumeMedication(String id, {DateTime? resumedAt}) async {
    resumeCount += 1;
    final existing = _medications.where((item) => item.id == id).firstOrNull;
    if (existing == null) throw StateError('Missing medication');
    final now = resumedAt ?? DateTime(2026, 4, 29, 15, resumeCount);
    final updated = existing.copyWith(
      status: MedicationStatus.active,
      clearPausedAt: true,
      resumedAt: now,
      updatedAt: now,
    );
    _medications.removeWhere((item) => item.id == id);
    _medications.add(updated);
    return updated;
  }

  @override
  Future<void> deleteMedication(String id) async {
    deleteCount += 1;
    _medications.removeWhere((item) => item.id == id);
  }
}

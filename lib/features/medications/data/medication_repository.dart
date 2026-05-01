import '../domain/medication.dart';

abstract class MedicationRepository {
  Future<List<Medication>> loadMedications();

  Future<Medication> addMedication({
    required String name,
    String dosageLabel = '',
    String notes = '',
    MedicationStatus status = MedicationStatus.active,
  });

  Future<Medication> updateMedication(Medication medication);

  Future<Medication> pauseMedication(String id, {DateTime? pausedAt});

  Future<Medication> resumeMedication(String id, {DateTime? resumedAt});

  Future<void> deleteMedication(String id);
}

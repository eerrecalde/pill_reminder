import '../domain/medication.dart';

abstract class MedicationRepository {
  Future<List<Medication>> loadMedications();

  Future<Medication> addMedication({
    required String name,
    String dosageLabel = '',
    String notes = '',
    MedicationStatus status = MedicationStatus.active,
  });
}

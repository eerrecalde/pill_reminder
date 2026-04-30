import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/medication.dart';
import 'medication_repository.dart';

class LocalMedicationRepository implements MedicationRepository {
  LocalMedicationRepository(this._preferences);

  static const _medicationsKey = 'medications.records.v1';

  final SharedPreferences _preferences;

  @override
  Future<List<Medication>> loadMedications() async {
    final rawRecords = _preferences.getStringList(_medicationsKey) ?? [];
    return rawRecords
        .map((record) => jsonDecode(record))
        .whereType<Map<String, Object?>>()
        .map(Medication.fromJson)
        .where((medication) => medication.id.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<Medication> addMedication({
    required String name,
    String dosageLabel = '',
    String notes = '',
    MedicationStatus status = MedicationStatus.active,
  }) async {
    final medications = await loadMedications();
    final now = DateTime.now();
    final medication = Medication(
      id: 'med-${now.microsecondsSinceEpoch}',
      name: name.trim(),
      dosageLabel: dosageLabel.trim(),
      notes: notes.trim(),
      status: status,
      createdAt: now,
      updatedAt: now,
    );

    final updatedRecords = [
      ...medications,
      medication,
    ].map((record) => jsonEncode(record.toJson())).toList(growable: false);
    await _preferences.setStringList(_medicationsKey, updatedRecords);
    return medication;
  }
}

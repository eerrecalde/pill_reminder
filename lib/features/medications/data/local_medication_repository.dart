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

  @override
  Future<Medication> updateMedication(Medication medication) async {
    final medications = await loadMedications();
    final existing = medications
        .where((item) => item.id == medication.id)
        .firstOrNull;
    if (existing == null) {
      throw StateError('Medication ${medication.id} was not found.');
    }

    final updated = medication.copyWith(
      name: medication.name.trim(),
      dosageLabel: medication.dosageLabel.trim(),
      notes: medication.notes.trim(),
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    await _saveAll([
      for (final item in medications)
        if (item.id == updated.id) updated else item,
    ]);
    return updated;
  }

  @override
  Future<Medication> pauseMedication(String id, {DateTime? pausedAt}) async {
    final medications = await loadMedications();
    final existing = medications.where((item) => item.id == id).firstOrNull;
    if (existing == null) {
      throw StateError('Medication $id was not found.');
    }
    final now = pausedAt ?? DateTime.now();
    final updated = existing.copyWith(
      status: MedicationStatus.paused,
      pausedAt: now,
      clearResumedAt: true,
      updatedAt: now,
    );
    await _saveAll([
      for (final item in medications)
        if (item.id == id) updated else item,
    ]);
    return updated;
  }

  @override
  Future<Medication> resumeMedication(String id, {DateTime? resumedAt}) async {
    final medications = await loadMedications();
    final existing = medications.where((item) => item.id == id).firstOrNull;
    if (existing == null) {
      throw StateError('Medication $id was not found.');
    }
    final now = resumedAt ?? DateTime.now();
    final updated = existing.copyWith(
      status: MedicationStatus.active,
      clearPausedAt: true,
      resumedAt: now,
      updatedAt: now,
    );
    await _saveAll([
      for (final item in medications)
        if (item.id == id) updated else item,
    ]);
    return updated;
  }

  @override
  Future<void> deleteMedication(String id) async {
    final medications = await loadMedications();
    await _saveAll(
      medications.where((item) => item.id != id).toList(growable: false),
    );
  }

  Future<void> _saveAll(List<Medication> medications) async {
    await _preferences.setStringList(
      _medicationsKey,
      medications
          .map((record) => jsonEncode(record.toJson()))
          .toList(growable: false),
    );
  }
}

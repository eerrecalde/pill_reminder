import '../domain/medication_history.dart';

abstract interface class MedicationHistoryRepository {
  Future<List<MedicationHistoryEntry>> loadAll();

  Future<void> saveAll(List<MedicationHistoryEntry> entries);

  Future<void> deleteAll();

  Future<List<MedicationHistoryEntry>> loadEntries({
    required DateTime since,
    required DateTime until,
  });

  Future<MedicationHistoryEntry> upsertEntry(MedicationHistoryEntry entry);

  Future<void> pruneBefore(DateTime cutoffDate);
}

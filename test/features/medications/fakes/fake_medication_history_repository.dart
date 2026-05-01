import 'package:pill_reminder/features/medications/data/medication_history_repository.dart';
import 'package:pill_reminder/features/medications/domain/medication_history.dart';

class FakeMedicationHistoryRepository implements MedicationHistoryRepository {
  FakeMedicationHistoryRepository([List<MedicationHistoryEntry>? entries])
    : _entries = [...?entries];

  final List<MedicationHistoryEntry> _entries;

  List<MedicationHistoryEntry> get entries => List.unmodifiable(_entries);

  @override
  Future<List<MedicationHistoryEntry>> loadEntries({
    required DateTime since,
    required DateTime until,
  }) async {
    final start = MedicationHistoryEntry.dateOnly(since);
    final end = MedicationHistoryEntry.dateOnly(until);
    return _entries
        .where((entry) {
          return !entry.localDate.isBefore(start) &&
              !entry.localDate.isAfter(end);
        })
        .toList(growable: false);
  }

  @override
  Future<void> pruneBefore(DateTime cutoffDate) async {
    final cutoff = MedicationHistoryEntry.dateOnly(cutoffDate);
    _entries.removeWhere((entry) => entry.localDate.isBefore(cutoff));
  }

  @override
  Future<MedicationHistoryEntry> upsertEntry(
    MedicationHistoryEntry entry,
  ) async {
    final existing = _entries.where((item) => item.id == entry.id).firstOrNull;
    final saved = existing == null ? entry : existing.mergeWith(entry);
    _entries.removeWhere((item) => item.id == saved.id);
    _entries.add(saved);
    return saved;
  }
}

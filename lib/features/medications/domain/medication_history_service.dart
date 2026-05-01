import '../data/medication_history_repository.dart';
import 'medication_history.dart';

typedef MedicationHistoryClock = DateTime Function();

class MedicationHistoryService {
  MedicationHistoryService({
    required MedicationHistoryRepository repository,
    MedicationHistoryClock? clock,
  }) : _repository = repository,
       _clock = clock ?? DateTime.now;

  static const retention = Duration(days: 90);

  final MedicationHistoryRepository _repository;
  final MedicationHistoryClock _clock;

  Future<List<MedicationHistoryDayGroup>> loadDayGroups() async {
    final now = _clock();
    final today = MedicationHistoryEntry.dateOnly(now);
    final cutoff = today.subtract(retention);
    await _repository.pruneBefore(cutoff);
    final entries = await _repository.loadEntries(since: cutoff, until: today);
    final grouped = <DateTime, List<MedicationHistoryEntry>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.localDate, () => []).add(entry);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final day in days)
        MedicationHistoryDayGroup(
          localDate: day,
          entries: _sortWithinDay(grouped[day]!),
        ),
    ];
  }

  List<MedicationHistoryEntry> _sortWithinDay(
    List<MedicationHistoryEntry> entries,
  ) {
    return entries.toList()..sort((a, b) {
      final time = a.scheduledAt.compareTo(b.scheduledAt);
      if (time != 0) return time;
      return a.medicationName.compareTo(b.medicationName);
    });
  }
}

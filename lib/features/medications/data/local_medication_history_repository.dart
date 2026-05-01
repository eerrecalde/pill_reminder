import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/medication_history.dart';
import 'medication_history_repository.dart';

class LocalMedicationHistoryRepository implements MedicationHistoryRepository {
  LocalMedicationHistoryRepository(this._preferences);

  static const historyKey = 'medications.history.v1';
  static const retention = Duration(days: 90);

  final SharedPreferences _preferences;

  @override
  Future<List<MedicationHistoryEntry>> loadEntries({
    required DateTime since,
    required DateTime until,
  }) async {
    final entries = await _loadAll();
    final start = MedicationHistoryEntry.dateOnly(since);
    final end = MedicationHistoryEntry.dateOnly(until);
    final filtered = entries
        .where((entry) {
          return !entry.localDate.isBefore(start) &&
              !entry.localDate.isAfter(end);
        })
        .toList(growable: false);
    return _sortEntries(filtered);
  }

  @override
  Future<void> pruneBefore(DateTime cutoffDate) async {
    final cutoff = MedicationHistoryEntry.dateOnly(cutoffDate);
    final entries = await _loadAll();
    await _saveAll(
      entries
          .where((entry) => !entry.localDate.isBefore(cutoff))
          .toList(growable: false),
    );
  }

  @override
  Future<MedicationHistoryEntry> upsertEntry(
    MedicationHistoryEntry entry,
  ) async {
    final retentionCutoff = MedicationHistoryEntry.dateOnly(
      entry.updatedAt.subtract(retention),
    );
    final entries = await _loadAll();
    final existing = entries.where((item) => item.id == entry.id).firstOrNull;
    final saved = existing == null ? entry : existing.mergeWith(entry);
    final updated = [
      for (final item in entries)
        if (item.id != saved.id && !item.localDate.isBefore(retentionCutoff))
          item,
      if (!saved.localDate.isBefore(retentionCutoff)) saved,
    ];
    await _saveAll(updated);
    return saved;
  }

  Future<List<MedicationHistoryEntry>> _loadAll() async {
    final rawRecords = _preferences.getStringList(historyKey) ?? [];
    final entries = <MedicationHistoryEntry>[];
    for (final record in rawRecords) {
      try {
        final decoded = jsonDecode(record);
        if (decoded is! Map<String, Object?>) continue;
        final entry = MedicationHistoryEntry.fromJson(decoded);
        if (entry.isValid) entries.add(entry);
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }
    return _sortEntries(entries);
  }

  Future<void> _saveAll(List<MedicationHistoryEntry> entries) async {
    await _preferences.setStringList(
      historyKey,
      _sortEntries(entries).map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  List<MedicationHistoryEntry> _sortEntries(
    List<MedicationHistoryEntry> entries,
  ) {
    return entries.toList()..sort((a, b) {
      final day = b.localDate.compareTo(a.localDate);
      if (day != 0) return day;
      final time = a.scheduledAt.compareTo(b.scheduledAt);
      if (time != 0) return time;
      return a.medicationName.compareTo(b.medicationName);
    });
  }
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/data/local_medication_history_repository.dart';
import 'package:pill_reminder/features/medications/domain/medication_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'medication_history_test_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads valid JSON and ignores invalid records', () async {
    final entry = medicationHistoryEntryFixture();
    SharedPreferences.setMockInitialValues({
      LocalMedicationHistoryRepository.historyKey: [
        jsonEncode(entry.toJson()),
        'not json',
      ],
    });
    final repository = LocalMedicationHistoryRepository(
      await SharedPreferences.getInstance(),
    );

    final entries = await repository.loadEntries(
      since: DateTime(2026, 5, 1),
      until: DateTime(2026, 5, 1),
    );

    expect(entries, hasLength(1));
    expect(entries.single.medicationName, 'Aspirin');
  });

  test('upserts by stable id and preserves final status precedence', () async {
    final repository = LocalMedicationHistoryRepository(
      await SharedPreferences.getInstance(),
    );

    await repository.upsertEntry(
      medicationHistoryEntryFixture(status: MedicationHistoryStatus.snoozed),
    );
    await repository.upsertEntry(
      medicationHistoryEntryFixture(status: MedicationHistoryStatus.taken),
    );
    await repository.upsertEntry(
      medicationHistoryEntryFixture(status: MedicationHistoryStatus.snoozed),
    );

    final entries = await repository.loadEntries(
      since: DateTime(2026, 5, 1),
      until: DateTime(2026, 5, 1),
    );

    expect(entries, hasLength(1));
    expect(entries.single.status, MedicationHistoryStatus.taken);
  });

  test('pruneBefore removes entries outside retention window', () async {
    final repository = LocalMedicationHistoryRepository(
      await SharedPreferences.getInstance(),
    );
    await repository.upsertEntry(
      medicationHistoryEntryFixture(
        id: 'old',
        scheduledAt: DateTime(2026, 1, 1, 8),
      ),
    );
    await repository.upsertEntry(medicationHistoryEntryFixture());

    await repository.pruneBefore(DateTime(2026, 2, 1));
    final entries = await repository.loadEntries(
      since: DateTime(2026, 1, 1),
      until: DateTime(2026, 5, 1),
    );

    expect(entries.map((entry) => entry.id), isNot(contains('old')));
  });

  test('reloads saved history after a new repository instance', () async {
    final preferences = await SharedPreferences.getInstance();
    await LocalMedicationHistoryRepository(
      preferences,
    ).upsertEntry(medicationHistoryEntryFixture());

    final reloaded = LocalMedicationHistoryRepository(preferences);
    final entries = await reloaded.loadEntries(
      since: DateTime(2026, 5, 1),
      until: DateTime(2026, 5, 1),
    );

    expect(entries.single.medicationName, 'Aspirin');
  });
}

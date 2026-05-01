import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication_history.dart';
import 'package:pill_reminder/features/medications/domain/medication_history_service.dart';

import 'fakes/fake_medication_history_repository.dart';
import 'medication_history_test_fixtures.dart';

void main() {
  test('loads a rolling 90-day history grouped newest day first', () async {
    final repository = FakeMedicationHistoryRepository([
      medicationHistoryEntryFixture(
        id: 'old',
        scheduledAt: DateTime(2026, 1, 1, 8),
      ),
      medicationHistoryEntryFixture(
        id: 'today-b',
        medicationName: 'Vitamin D',
        scheduledAt: DateTime(2026, 5, 1, 9),
      ),
      medicationHistoryEntryFixture(
        id: 'today-a',
        medicationName: 'Aspirin',
        scheduledAt: DateTime(2026, 5, 1, 9),
      ),
      medicationHistoryEntryFixture(
        id: 'yesterday',
        scheduledAt: DateTime(2026, 4, 30, 8),
      ),
    ]);

    final groups = await MedicationHistoryService(
      repository: repository,
      clock: () => DateTime(2026, 5, 1, 12),
    ).loadDayGroups();

    expect(groups, hasLength(2));
    expect(groups.first.localDate, DateTime(2026, 5, 1));
    expect(groups.first.entries.map((entry) => entry.medicationName), [
      'Aspirin',
      'Vitamin D',
    ]);
    expect(repository.entries.any((entry) => entry.id == 'old'), isFalse);
  });

  test('final status replaces a snoozed display for same occurrence', () async {
    final repository = FakeMedicationHistoryRepository([
      medicationHistoryEntryFixture(
        status: MedicationHistoryStatus.snoozed,
        snoozeCount: 1,
      ),
    ]);

    await repository.upsertEntry(
      medicationHistoryEntryFixture(status: MedicationHistoryStatus.taken),
    );
    final groups = await MedicationHistoryService(
      repository: repository,
      clock: () => DateTime(2026, 5, 1, 12),
    ).loadDayGroups();

    expect(groups.single.entries.single.status, MedicationHistoryStatus.taken);
    expect(groups.single.entries.single.snoozeCount, 1);
  });

  test('loads 90 days of typical reminders under 500 ms', () async {
    final entries = <MedicationHistoryEntry>[];
    for (var dayOffset = 0; dayOffset < 90; dayOffset += 1) {
      for (var index = 0; index < 4; index += 1) {
        final scheduledAt = DateTime(
          2026,
          5,
          1,
        ).subtract(Duration(days: dayOffset)).add(Duration(hours: 8 + index));
        entries.add(
          medicationHistoryEntryFixture(
            id: 'day-$dayOffset-$index',
            scheduledAt: scheduledAt,
            medicationName: 'Medication $index',
          ),
        );
      }
    }
    final stopwatch = Stopwatch()..start();

    final groups = await MedicationHistoryService(
      repository: FakeMedicationHistoryRepository(entries),
      clock: () => DateTime(2026, 5, 1, 12),
    ).loadDayGroups();
    stopwatch.stop();

    expect(groups, hasLength(90));
    expect(stopwatch.elapsedMilliseconds, lessThan(500));
  });
}

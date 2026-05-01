import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/data/local_daily_reminder_handling_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reminder_schedule_test_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and loads current-day handling records', () async {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalDailyReminderHandlingRepository(preferences);
    final date = DateTime(2026, 5, 1);
    final time = reminderTimeFixture(hour: 8);

    final saved = await repository.markHandled(
      localDate: date,
      scheduleId: 'schedule-1',
      medicationId: 'med-1',
      reminderTime: time,
      handledAt: DateTime(2026, 5, 1, 8, 5),
    );

    final records = await repository.loadForDate(date);
    expect(records, hasLength(1));
    expect(records.single.id, saved.id);
    expect(records.single.reminderTime, time);
    expect(records.single.handledAt, DateTime(2026, 5, 1, 8, 5));
  });

  test('mark handled is idempotent for the same daily reminder', () async {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalDailyReminderHandlingRepository(preferences);
    final date = DateTime(2026, 5, 1);
    final time = reminderTimeFixture(hour: 8);

    await repository.markHandled(
      localDate: date,
      scheduleId: 'schedule-1',
      medicationId: 'med-1',
      reminderTime: time,
      handledAt: DateTime(2026, 5, 1, 8, 5),
    );
    await repository.markHandled(
      localDate: date,
      scheduleId: 'schedule-1',
      medicationId: 'med-1',
      reminderTime: time,
      handledAt: DateTime(2026, 5, 1, 8, 10),
    );

    final records = await repository.loadForDate(date);
    expect(records, hasLength(1));
    expect(records.single.handledAt, DateTime(2026, 5, 1, 8, 10));
  });

  test(
    'loads only records for the requested local date after reload',
    () async {
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalDailyReminderHandlingRepository(preferences);
      final time = reminderTimeFixture(hour: 8);

      await repository.markHandled(
        localDate: DateTime(2026, 5, 1),
        scheduleId: 'schedule-1',
        medicationId: 'med-1',
        reminderTime: time,
        handledAt: DateTime(2026, 5, 1, 8, 5),
      );
      await repository.markHandled(
        localDate: DateTime(2026, 5, 2),
        scheduleId: 'schedule-1',
        medicationId: 'med-1',
        reminderTime: time,
        handledAt: DateTime(2026, 5, 2, 8, 5),
      );

      final reloaded = LocalDailyReminderHandlingRepository(preferences);
      final records = await reloaded.loadForDate(DateTime(2026, 5, 1));

      expect(records, hasLength(1));
      expect(records.single.localDate, DateTime(2026, 5, 1));
    },
  );
}

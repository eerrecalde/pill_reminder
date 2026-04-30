import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/data/local_reminder_schedule_repository.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reminder_schedule_test_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves loads edits and deletes schedule by medication id', () async {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalReminderScheduleRepository(preferences);

    final saved = await repository.saveSchedule(
      medicationId: 'med-1',
      reminderTimes: [reminderTimeFixture(hour: 8)],
    );
    expect(saved.medicationId, 'med-1');
    expect((await repository.loadScheduleForMedication('med-1'))?.id, saved.id);

    final edited = await repository.saveSchedule(
      medicationId: 'med-1',
      reminderTimes: [reminderTimeFixture(hour: 20)],
      notificationDeliveryState: ReminderNotificationDeliveryState.deliverable,
    );
    expect(edited.id, saved.id);
    expect(edited.reminderTimes.single.hour, 20);
    expect(
      edited.notificationDeliveryState,
      ReminderNotificationDeliveryState.deliverable,
    );

    await repository.deleteSchedule('med-1');
    expect(await repository.loadScheduleForMedication('med-1'), isNull);
  });

  test('preserves schedule values after reload', () async {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalReminderScheduleRepository(preferences);
    final endDate = DateTime(2026, 5, 1);

    final saved = await repository.saveSchedule(
      medicationId: 'med-1',
      reminderTimes: [
        reminderTimeFixture(hour: 20),
        reminderTimeFixture(hour: 8),
      ],
      endDate: endDate,
    );
    final reloaded = await repository.loadScheduleForMedication('med-1');

    expect(reloaded, isNotNull);
    expect(reloaded!.id, saved.id);
    expect(reloaded.reminderTimes.map((time) => time.hour), [8, 20]);
    expect(reloaded.endDate, endDate);
    expect(reloaded.createdAt, saved.createdAt);
  });
}

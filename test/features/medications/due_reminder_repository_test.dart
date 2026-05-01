import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pill_reminder/features/medications/data/local_due_reminder_repository.dart';

import 'due_reminder_test_fixtures.dart';

void main() {
  test('creates, loads, reloads, and deletes due reminders', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalDueReminderRepository(preferences);
    final reminder = dueReminderFixture();

    await repository.upsertDueReminder(reminder);

    expect(await repository.loadDueReminder(reminder.id), isNotNull);
    expect(
      await repository.loadDueReminderForOccurrence(
        medicationId: reminder.medicationId,
        scheduledAt: reminder.scheduledAt,
      ),
      isNotNull,
    );

    final reloaded = LocalDueReminderRepository(preferences);
    expect(await reloaded.loadDueReminders(), hasLength(1));

    await reloaded.deleteDueRemindersForMedication(reminder.medicationId);
    expect(await reloaded.loadDueReminders(), isEmpty);
  });

  test('delete by schedule removes associated reminders', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalDueReminderRepository(preferences);
    await repository.upsertDueReminder(dueReminderFixture(scheduleId: 'a'));
    await repository.upsertDueReminder(
      dueReminderFixture(medicationId: 'med-2', scheduleId: 'b'),
    );

    await repository.deleteDueRemindersForSchedule('a');

    final remaining = await repository.loadDueReminders();
    expect(remaining, hasLength(1));
    expect(remaining.single.scheduleId, 'b');
  });

  test('duplicate creation attempts keep one reminder', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalDueReminderRepository(preferences);
    final reminder = dueReminderFixture();

    await repository.upsertDueReminder(reminder);
    await repository.upsertDueReminder(
      reminder.copyWith(medicationName: 'New'),
    );

    final reminders = await repository.loadDueReminders();
    expect(reminders, hasLength(1));
    expect(reminders.single.medicationName, 'New');
  });
}

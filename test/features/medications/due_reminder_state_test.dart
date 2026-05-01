import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';

import 'due_reminder_test_fixtures.dart';

void main() {
  test('stable id is unique by medication and scheduled occurrence', () {
    final first = DueReminder.stableId(
      medicationId: 'med-1',
      scheduledAt: DateTime(2026, 5, 1, 8),
    );
    final sameMinute = DueReminder.stableId(
      medicationId: 'med-1',
      scheduledAt: DateTime(2026, 5, 1, 8, 0, 30),
    );
    final differentTime = DueReminder.stableId(
      medicationId: 'med-1',
      scheduledAt: DateTime(2026, 5, 1, 9),
    );

    expect(first, sameMinute);
    expect(first, isNot(differentTime));
  });

  test('taken and skipped are final states', () {
    final reminder = dueReminderFixture();
    final taken = reminder.markTaken(
      at: DateTime(2026, 5, 1, 8, 2),
      source: ReminderActionSource.inApp,
    );
    final staleSkip = taken.markSkipped(
      at: DateTime(2026, 5, 1, 8, 3),
      source: ReminderActionSource.notification,
    );

    expect(taken.state, DueReminderState.taken);
    expect(staleSkip.state, DueReminderState.taken);
    expect(staleSkip.outcome?.outcomeType, ReminderActionType.taken);
  });

  test('remind again later uses one pending request', () {
    final reminder = dueReminderFixture();
    final first = reminder.remindAgainLater(
      requestedAt: DateTime(2026, 5, 1, 8, 1),
      intervalMinutes: 10,
      source: ReminderActionSource.inApp,
    );
    final second = first.remindAgainLater(
      requestedAt: DateTime(2026, 5, 1, 8, 5),
      intervalMinutes: 15,
      source: ReminderActionSource.notification,
    );

    expect(second.state, DueReminderState.remindAgainLater);
    expect(second.remindAgainLaterRequest?.intervalMinutes, 15);
    expect(second.remindAgainLaterRequest?.nextReminderAt.minute, 20);
  });
}

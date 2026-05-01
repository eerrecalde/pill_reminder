import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/medications/domain/medication_history.dart';
import 'package:pill_reminder/services/reminder_due_reconciler.dart';

import 'due_reminder_test_fixtures.dart';
import 'fakes/fake_due_reminder_repository.dart';
import 'fakes/fake_medication_history_repository.dart';
import 'fakes/fake_medication_repository.dart';
import 'fakes/fake_reminder_schedule_repository.dart';
import 'medication_test_fixtures.dart';
import 'reminder_schedule_test_fixtures.dart';

void main() {
  test(
    'creates one due reminder from an active saved schedule while offline',
    () async {
      final dueRepository = FakeDueReminderRepository();
      final reconciler = ReminderDueReconciler(
        medicationRepository: FakeMedicationRepository([
          medicationFixture(
            id: 'med-1',
            name: 'Aspirin',
            dosageLabel: '1 tablet',
          ),
        ]),
        scheduleRepository: FakeReminderScheduleRepository([
          reminderScheduleFixture(
            id: 'schedule-1',
            medicationId: 'med-1',
            reminderTimes: [reminderTimeFixture(hour: 8)],
          ),
        ]),
        dueReminderRepository: dueRepository,
      );

      await reconciler.reconcile(now: DateTime(2026, 5, 1, 8, 5));
      await reconciler.reconcile(now: DateTime(2026, 5, 1, 8, 6));

      final reminders = await dueRepository.loadDueReminders();
      expect(reminders, hasLength(1));
      expect(reminders.single.medicationName, 'Aspirin');
      expect(reminders.single.dosageLabel, '1 tablet');
    },
  );

  test('returns elapsed remind-again-later reminders to unresolved', () async {
    final reminder = dueReminderFixture().remindAgainLater(
      requestedAt: DateTime(2026, 5, 1, 8, 0),
      intervalMinutes: 10,
      source: ReminderActionSource.inApp,
    );
    final dueRepository = FakeDueReminderRepository([reminder]);
    final reconciler = ReminderDueReconciler(
      medicationRepository: FakeMedicationRepository(),
      scheduleRepository: FakeReminderScheduleRepository(),
      dueReminderRepository: dueRepository,
    );

    await reconciler.reconcile(now: DateTime(2026, 5, 1, 8, 11));

    final saved = await dueRepository.loadDueReminder(reminder.id);
    expect(saved?.state.name, 'unresolved');
  });

  test(
    'records unhandled reminders older than 60 minutes as missed once',
    () async {
      final reminder = dueReminderFixture(scheduledAt: DateTime(2026, 5, 1, 8));
      final dueRepository = FakeDueReminderRepository([reminder]);
      final historyRepository = FakeMedicationHistoryRepository();
      final reconciler = ReminderDueReconciler(
        medicationRepository: FakeMedicationRepository(),
        scheduleRepository: FakeReminderScheduleRepository(),
        dueReminderRepository: dueRepository,
        medicationHistoryRepository: historyRepository,
      );

      await reconciler.reconcile(now: DateTime(2026, 5, 1, 9));
      expect(historyRepository.entries, isEmpty);

      await reconciler.reconcile(now: DateTime(2026, 5, 1, 9, 1));
      await reconciler.reconcile(now: DateTime(2026, 5, 1, 9, 2));

      expect(historyRepository.entries, hasLength(1));
      expect(
        historyRepository.entries.single.status,
        MedicationHistoryStatus.missed,
      );
    },
  );
}

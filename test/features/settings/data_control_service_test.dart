import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/daily_reminder_handling.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/medication_history.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/settings/data/local_reminder_data_control_service.dart';
import 'package:pill_reminder/features/settings/domain/deletion_recovery_window.dart';

import '../medications/fakes/fake_daily_reminder_handling_repository.dart';
import '../medications/fakes/fake_due_reminder_repository.dart';
import '../medications/fakes/fake_medication_history_repository.dart';
import '../medications/fakes/fake_medication_repository.dart';
import '../medications/fakes/fake_reminder_notification_scheduler.dart';
import '../medications/fakes/fake_reminder_schedule_repository.dart';

void main() {
  test(
    'snapshots, deletes, cancels notifications, and restores local data',
    () async {
      var now = DateTime(2026, 5, 9, 10);
      final medication = _medication();
      final schedule = _schedule();
      final dueReminder = _dueReminder();
      final handling = _handling();
      final history = _history();
      final medicationRepository = FakeMedicationRepository([medication]);
      final scheduleRepository = FakeReminderScheduleRepository([schedule]);
      final dueReminderRepository = FakeDueReminderRepository([dueReminder]);
      final handlingRepository = FakeDailyReminderHandlingRepository([
        handling,
      ]);
      final historyRepository = FakeMedicationHistoryRepository([history]);
      final scheduler = FakeReminderNotificationScheduler();
      final service = LocalReminderDataControlService(
        medicationRepository: medicationRepository,
        reminderScheduleRepository: scheduleRepository,
        dueReminderRepository: dueReminderRepository,
        dailyReminderHandlingRepository: handlingRepository,
        medicationHistoryRepository: historyRepository,
        notificationScheduler: scheduler,
        now: () => now,
      );

      expect(await service.hasLocalReminderData(), isTrue);

      final window = await service.deleteLocalReminderData();

      expect(window.state, DeletionRecoveryWindowState.active);
      expect(await medicationRepository.loadAll(), isEmpty);
      expect(await scheduleRepository.loadAll(), isEmpty);
      expect(await dueReminderRepository.loadAll(), isEmpty);
      expect(await handlingRepository.loadAll(), isEmpty);
      expect(await historyRepository.loadAll(), isEmpty);
      expect(scheduler.cancelled, [schedule]);
      expect(scheduler.cancelledDueReminders, [dueReminder]);

      await service.restoreLocalReminderData();

      expect(await medicationRepository.loadAll(), [medication]);
      expect(await scheduleRepository.loadAll(), [schedule]);
      expect(await dueReminderRepository.loadAll(), [dueReminder]);
      expect(await handlingRepository.loadAll(), [handling]);
      expect(await historyRepository.loadAll(), [history]);

      await service.deleteLocalReminderData();
      now = now.add(const Duration(seconds: 31));

      expect(
        service.expireRecoveryWindow()?.state,
        DeletionRecoveryWindowState.expired,
      );
      expect(service.restoreLocalReminderData, throwsStateError);
    },
  );
}

Medication _medication() {
  final now = DateTime(2026, 5, 9, 8);
  return Medication(
    id: 'med-1',
    name: 'Morning pill',
    dosageLabel: '1 tablet',
    notes: '',
    status: MedicationStatus.active,
    createdAt: now,
    updatedAt: now,
  );
}

ReminderSchedule _schedule() {
  final now = DateTime(2026, 5, 9, 8);
  return ReminderSchedule(
    id: 'schedule-1',
    medicationId: 'med-1',
    reminderTimes: const [ReminderTime(hour: 8, minute: 30)],
    createdAt: now,
    updatedAt: now,
  );
}

DueReminder _dueReminder() {
  return DueReminder.create(
    medicationId: 'med-1',
    scheduleId: 'schedule-1',
    scheduledAt: DateTime(2026, 5, 9, 8, 30),
    medicationName: 'Morning pill',
    now: DateTime(2026, 5, 9, 8),
  );
}

DailyReminderHandling _handling() {
  return DailyReminderHandling(
    id: 'handling-1',
    localDate: DateTime(2026, 5, 9),
    scheduleId: 'schedule-1',
    medicationId: 'med-1',
    reminderTime: const ReminderTime(hour: 8, minute: 30),
    handledAt: DateTime(2026, 5, 9, 8, 40),
  );
}

MedicationHistoryEntry _history() {
  final now = DateTime(2026, 5, 9, 8, 40);
  return MedicationHistoryEntry(
    id: 'history-1',
    localDate: DateTime(2026, 5, 9),
    scheduledAt: DateTime(2026, 5, 9, 8, 30),
    scheduleId: 'schedule-1',
    medicationId: 'med-1',
    medicationName: 'Morning pill',
    status: MedicationHistoryStatus.taken,
    statusUpdatedAt: now,
    source: MedicationHistorySource.todayDashboard,
    createdAt: now,
    updatedAt: now,
  );
}

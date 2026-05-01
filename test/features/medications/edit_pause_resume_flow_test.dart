import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/due_reminder.dart';
import 'package:pill_reminder/features/medications/domain/medication_reminder_operations.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';

import 'due_reminder_test_fixtures.dart';
import 'fakes/fake_due_reminder_repository.dart';
import 'fakes/fake_medication_repository.dart';
import 'fakes/fake_reminder_notification_scheduler.dart';
import 'fakes/fake_reminder_schedule_repository.dart';
import 'medication_test_fixtures.dart';
import 'reminder_schedule_test_fixtures.dart';

void main() {
  MedicationReminderOperations operations({
    required FakeMedicationRepository medicationRepository,
    required FakeReminderScheduleRepository scheduleRepository,
    required FakeDueReminderRepository dueReminderRepository,
    required FakeReminderNotificationScheduler scheduler,
  }) {
    return MedicationReminderOperations(
      medicationRepository: medicationRepository,
      scheduleRepository: scheduleRepository,
      dueReminderRepository: dueReminderRepository,
      notificationScheduler: scheduler,
    );
  }

  test(
    'editing medication refreshes existing schedule notification copy',
    () async {
      final medication = medicationFixture();
      final schedule = reminderScheduleFixture();
      final medicationRepository = FakeMedicationRepository([medication]);
      final scheduleRepository = FakeReminderScheduleRepository([schedule]);
      final dueReminderRepository = FakeDueReminderRepository();
      final scheduler = FakeReminderNotificationScheduler();

      await operations(
        medicationRepository: medicationRepository,
        scheduleRepository: scheduleRepository,
        dueReminderRepository: dueReminderRepository,
        scheduler: scheduler,
      ).updateMedicationDetails(
        medication: medication.copyWith(name: 'Evening pill'),
        title: 'Evening pill',
        body: '1 tablet',
        permissionStatus: SetupNotificationPermissionStatus.granted,
      );

      final medications = await medicationRepository.loadMedications();
      expect(medications.single.name, 'Evening pill');
      expect(scheduler.calls, contains('refreshForMedication'));
      expect(scheduleRepository.replaceCount, 1);
    },
  );

  test(
    'schedule replacement cancels previous notifications before scheduling new ones',
    () async {
      final medication = medicationFixture();
      final previous = reminderScheduleFixture(
        reminderTimes: [reminderTimeFixture(hour: 8)],
      );
      final medicationRepository = FakeMedicationRepository([medication]);
      final scheduleRepository = FakeReminderScheduleRepository([previous]);
      final dueReminderRepository = FakeDueReminderRepository([
        dueReminderFixture(scheduleId: previous.id),
      ]);
      final scheduler = FakeReminderNotificationScheduler();

      await operations(
        medicationRepository: medicationRepository,
        scheduleRepository: scheduleRepository,
        dueReminderRepository: dueReminderRepository,
        scheduler: scheduler,
      ).replaceSchedule(
        medication: medication,
        reminderTimes: [reminderTimeFixture(hour: 10)],
        title: 'Aspirin',
        body: '1 tablet',
        permissionStatus: SetupNotificationPermissionStatus.granted,
      );

      expect(scheduler.calls.take(2), ['cancelForSchedule', 'schedule']);
      expect((await dueReminderRepository.loadDueReminders()), isEmpty);
      final saved = await scheduleRepository.loadScheduleForMedication(
        medication.id,
      );
      expect(saved!.reminderTimes, [const ReminderTime(hour: 10, minute: 0)]);
    },
  );

  test('pause cancels schedule, due, and later reminders', () async {
    final medication = medicationFixture();
    final schedule = reminderScheduleFixture();
    final due = dueReminderFixture();
    final later = dueReminderFixture(
      scheduledAt: DateTime(2026, 5, 1, 9),
      state: DueReminderState.remindAgainLater,
    );
    final medicationRepository = FakeMedicationRepository([medication]);
    final scheduleRepository = FakeReminderScheduleRepository([schedule]);
    final dueReminderRepository = FakeDueReminderRepository([due, later]);
    final scheduler = FakeReminderNotificationScheduler();

    await operations(
      medicationRepository: medicationRepository,
      scheduleRepository: scheduleRepository,
      dueReminderRepository: dueReminderRepository,
      scheduler: scheduler,
    ).pauseMedication(medication);

    final medications = await medicationRepository.loadMedications();
    expect(medications.single.isPaused, isTrue);
    expect(scheduler.cancelledForMedication, [schedule]);
    expect(scheduler.cancelledDueReminders, [due, later]);
    expect(await dueReminderRepository.loadDueReminders(), isEmpty);
  });

  test('delete medication removes schedule and reminder state', () async {
    final medication = medicationFixture();
    final schedule = reminderScheduleFixture();
    final due = dueReminderFixture();
    final medicationRepository = FakeMedicationRepository([medication]);
    final scheduleRepository = FakeReminderScheduleRepository([schedule]);
    final dueReminderRepository = FakeDueReminderRepository([due]);
    final scheduler = FakeReminderNotificationScheduler();

    await operations(
      medicationRepository: medicationRepository,
      scheduleRepository: scheduleRepository,
      dueReminderRepository: dueReminderRepository,
      scheduler: scheduler,
    ).deleteMedication(medication);

    expect(await medicationRepository.loadMedications(), isEmpty);
    expect(await scheduleRepository.loadSchedules(), isEmpty);
    expect(await dueReminderRepository.loadDueReminders(), isEmpty);
    expect(scheduler.cancelledForMedication, [schedule]);
    expect(scheduler.cancelledDueReminders, [due]);
  });
}

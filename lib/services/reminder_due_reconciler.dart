import '../features/medications/data/due_reminder_repository.dart';
import '../features/medications/data/medication_repository.dart';
import '../features/medications/data/reminder_schedule_repository.dart';
import '../features/medications/domain/due_reminder.dart';
import '../features/medications/domain/medication.dart';
import '../features/medications/domain/reminder_schedule.dart';

class ReminderDueReconciler {
  ReminderDueReconciler({
    required MedicationRepository medicationRepository,
    required ReminderScheduleRepository scheduleRepository,
    required DueReminderRepository dueReminderRepository,
  }) : _medicationRepository = medicationRepository,
       _scheduleRepository = scheduleRepository,
       _dueReminderRepository = dueReminderRepository;

  final MedicationRepository _medicationRepository;
  final ReminderScheduleRepository _scheduleRepository;
  final DueReminderRepository _dueReminderRepository;

  Future<List<DueReminder>> reconcile({DateTime? now}) async {
    final timestamp = now ?? DateTime.now();
    final medications = await _medicationRepository.loadMedications();
    final schedules = await _scheduleRepository.loadSchedules();
    final created = <DueReminder>[];

    for (final schedule in schedules) {
      final medication = _medicationForSchedule(medications, schedule);
      if (medication == null || !medication.isActive) continue;
      if (_scheduleEnded(schedule, timestamp)) continue;

      for (final occurrence in _dueOccurrences(schedule, timestamp)) {
        final reminder = DueReminder.create(
          medicationId: medication.id,
          scheduleId: schedule.id,
          scheduledAt: occurrence,
          medicationName: medication.name,
          dosageLabel: medication.dosageLabel,
          now: timestamp,
        );
        final saved = await _dueReminderRepository.upsertDueReminder(reminder);
        created.add(saved);
      }
    }

    await _returnDueSnoozes(timestamp);
    return created;
  }

  Medication? _medicationForSchedule(
    List<Medication> medications,
    ReminderSchedule schedule,
  ) {
    for (final medication in medications) {
      if (medication.id == schedule.medicationId) return medication;
    }
    return null;
  }

  bool _scheduleEnded(ReminderSchedule schedule, DateTime now) {
    final endDate = schedule.endDate;
    if (endDate == null) return false;
    final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59);
    return now.isAfter(endOfDay);
  }

  Iterable<DateTime> _dueOccurrences(ReminderSchedule schedule, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return schedule.reminderTimes
        .map((time) {
          return DateTime(
            today.year,
            today.month,
            today.day,
            time.hour,
            time.minute,
          );
        })
        .where((occurrence) => !occurrence.isAfter(now));
  }

  Future<void> _returnDueSnoozes(DateTime now) async {
    final reminders = await _dueReminderRepository.loadUnresolvedDueReminders();
    for (final reminder in reminders) {
      final request = reminder.remindAgainLaterRequest;
      if (request == null || request.nextReminderAt.isAfter(now)) continue;
      await _dueReminderRepository.upsertDueReminder(
        reminder.returnToUnresolved(at: now),
      );
    }
  }
}

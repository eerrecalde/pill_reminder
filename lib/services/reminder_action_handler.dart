import '../features/medications/data/medication_history_repository.dart';
import '../features/medications/data/due_reminder_repository.dart';
import '../features/medications/domain/due_reminder.dart';
import '../features/medications/domain/medication_history.dart';
import '../features/medications/domain/reminder_handling_preferences.dart';
import 'reminder_notification_scheduler.dart';

class ReminderActionResult {
  const ReminderActionResult({required this.reminder, required this.changed});

  final DueReminder reminder;
  final bool changed;
}

class ReminderActionHandler {
  ReminderActionHandler({
    required DueReminderRepository repository,
    required ReminderNotificationScheduler notificationScheduler,
    MedicationHistoryRepository? medicationHistoryRepository,
  }) : _repository = repository,
       _notificationScheduler = notificationScheduler,
       _medicationHistoryRepository = medicationHistoryRepository;

  final DueReminderRepository _repository;
  final ReminderNotificationScheduler _notificationScheduler;
  final MedicationHistoryRepository? _medicationHistoryRepository;

  Future<ReminderActionResult?> handle({
    required String dueReminderId,
    required ReminderActionType actionType,
    required ReminderActionSource source,
    DateTime? now,
  }) async {
    final reminder = await _repository.loadDueReminder(dueReminderId);
    if (reminder == null) return null;
    final timestamp = now ?? DateTime.now();
    final updated = switch (actionType) {
      ReminderActionType.taken => reminder.markTaken(
        at: timestamp,
        source: source,
      ),
      ReminderActionType.skipped => reminder.markSkipped(
        at: timestamp,
        source: source,
      ),
      ReminderActionType.remindAgainLater => await _remindAgainLater(
        reminder,
        timestamp,
        source,
      ),
    };

    final changed = updated != reminder;
    final saved = await _repository.upsertDueReminder(updated);
    if (actionType == ReminderActionType.remindAgainLater && !saved.isFinal) {
      await _notificationScheduler.scheduleLaterReminder(saved);
    } else {
      await _notificationScheduler.cancelDueReminder(saved);
    }
    await _recordHistory(saved, actionType, timestamp, source);
    return ReminderActionResult(reminder: saved, changed: changed);
  }

  Future<DueReminder> handleNotificationAction(
    NotificationActionRequest request,
  ) async {
    final result = await handle(
      dueReminderId: request.dueReminderId,
      actionType: request.actionType,
      source: ReminderActionSource.notification,
      now: request.receivedAt,
    );
    return result?.reminder ??
        DueReminder.create(
          medicationId: '',
          scheduleId: '',
          scheduledAt: request.receivedAt,
          medicationName: '',
          now: request.receivedAt,
        );
  }

  Future<DueReminder> _remindAgainLater(
    DueReminder reminder,
    DateTime timestamp,
    ReminderActionSource source,
  ) async {
    final preferences = await _repository.loadPreferences();
    final interval = preferences.remindAgainLaterIntervalMinutes <= 0
        ? ReminderHandlingPreferences.defaultRemindAgainLaterIntervalMinutes
        : preferences.remindAgainLaterIntervalMinutes;
    return reminder.remindAgainLater(
      requestedAt: timestamp,
      intervalMinutes: interval,
      source: source,
    );
  }

  Future<void> _recordHistory(
    DueReminder reminder,
    ReminderActionType actionType,
    DateTime timestamp,
    ReminderActionSource source,
  ) async {
    final repository = _medicationHistoryRepository;
    if (repository == null || reminder.medicationName.trim().isEmpty) return;
    final status = switch (actionType) {
      ReminderActionType.taken => MedicationHistoryStatus.taken,
      ReminderActionType.skipped => MedicationHistoryStatus.skipped,
      ReminderActionType.remindAgainLater => MedicationHistoryStatus.snoozed,
    };
    final request = reminder.remindAgainLaterRequest;
    final existing = await repository.loadEntries(
      since: reminder.scheduledAt,
      until: reminder.scheduledAt,
    );
    final existingEntry = existing
        .where(
          (entry) =>
              entry.id ==
              MedicationHistoryEntry.buildOccurrenceIdFromDateTime(
                scheduledAt: reminder.scheduledAt,
                scheduleId: reminder.scheduleId,
                medicationId: reminder.medicationId,
              ),
        )
        .firstOrNull;
    final snoozeCount = actionType == ReminderActionType.remindAgainLater
        ? (existingEntry?.snoozeCount ?? 0) + 1
        : existingEntry?.snoozeCount;
    await repository.upsertEntry(
      MedicationHistoryEntry(
        id: MedicationHistoryEntry.buildOccurrenceIdFromDateTime(
          scheduledAt: reminder.scheduledAt,
          scheduleId: reminder.scheduleId,
          medicationId: reminder.medicationId,
        ),
        localDate: MedicationHistoryEntry.dateOnly(reminder.scheduledAt),
        scheduledAt: reminder.scheduledAt,
        scheduleId: reminder.scheduleId,
        medicationId: reminder.medicationId,
        medicationName: reminder.medicationName,
        dosageLabel: reminder.dosageLabel,
        status: status,
        statusUpdatedAt: timestamp,
        snoozeCount: snoozeCount,
        lastSnoozedAt: actionType == ReminderActionType.remindAgainLater
            ? timestamp
            : existingEntry?.lastSnoozedAt,
        nextReminderAt:
            request?.nextReminderAt ?? existingEntry?.nextReminderAt,
        source: switch (source) {
          ReminderActionSource.notification ||
          ReminderActionSource.inApp => MedicationHistorySource.dueReminder,
          ReminderActionSource.reconciliation =>
            MedicationHistorySource.reconciliation,
        },
        createdAt: existingEntry?.createdAt ?? timestamp,
        updatedAt: timestamp,
      ),
    );
  }
}

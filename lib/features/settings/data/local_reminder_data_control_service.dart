import '../../medications/data/daily_reminder_handling_repository.dart';
import '../../medications/data/due_reminder_repository.dart';
import '../../medications/data/medication_history_repository.dart';
import '../../medications/data/medication_repository.dart';
import '../../medications/data/reminder_schedule_repository.dart';
import '../../../services/reminder_notification_scheduler.dart';
import '../domain/deletion_recovery_window.dart';
import '../domain/local_reminder_data_snapshot.dart';
import '../domain/reminder_data_control_service.dart';

class LocalReminderDataControlService implements ReminderDataControlService {
  LocalReminderDataControlService({
    required MedicationRepository medicationRepository,
    required ReminderScheduleRepository reminderScheduleRepository,
    required DueReminderRepository dueReminderRepository,
    required DailyReminderHandlingRepository dailyReminderHandlingRepository,
    required MedicationHistoryRepository medicationHistoryRepository,
    required ReminderNotificationScheduler notificationScheduler,
    DateTime Function()? now,
  }) : _medicationRepository = medicationRepository,
       _reminderScheduleRepository = reminderScheduleRepository,
       _dueReminderRepository = dueReminderRepository,
       _dailyReminderHandlingRepository = dailyReminderHandlingRepository,
       _medicationHistoryRepository = medicationHistoryRepository,
       _notificationScheduler = notificationScheduler,
       _now = now ?? DateTime.now;

  final MedicationRepository _medicationRepository;
  final ReminderScheduleRepository _reminderScheduleRepository;
  final DueReminderRepository _dueReminderRepository;
  final DailyReminderHandlingRepository _dailyReminderHandlingRepository;
  final MedicationHistoryRepository _medicationHistoryRepository;
  final ReminderNotificationScheduler _notificationScheduler;
  final DateTime Function() _now;

  DeletionRecoveryWindow? _recoveryWindow;

  @override
  DeletionRecoveryWindow? get recoveryWindow => _recoveryWindow;

  @override
  Future<bool> hasLocalReminderData() async {
    return (await snapshot()).hasLocalReminderData;
  }

  @override
  Future<LocalReminderDataSnapshot> snapshot() async {
    return LocalReminderDataSnapshot(
      medications: await _medicationRepository.loadAll(),
      reminderSchedules: await _reminderScheduleRepository.loadAll(),
      dueReminders: await _dueReminderRepository.loadAll(),
      dailyReminderHandling: await _dailyReminderHandlingRepository.loadAll(),
      medicationHistory: await _medicationHistoryRepository.loadAll(),
      reminderHandlingPreferences: await _dueReminderRepository
          .loadPreferences(),
      capturedAt: _now(),
    );
  }

  @override
  Future<DeletionRecoveryWindow> deleteLocalReminderData() async {
    final captured = await snapshot();
    if (!captured.hasLocalReminderData) {
      final window = DeletionRecoveryWindow.start(
        snapshot: captured,
        startedAt: _now(),
      ).markExpired();
      _recoveryWindow = window;
      return window;
    }

    try {
      await _notificationScheduler.cancelAllForSchedules(
        captured.reminderSchedules,
      );
      await _notificationScheduler.cancelDueAndLaterForMedication(
        captured.dueReminders,
      );
      await _medicationRepository.deleteAll();
      await _reminderScheduleRepository.deleteAll();
      await _dueReminderRepository.deleteAll();
      await _dailyReminderHandlingRepository.deleteAll();
      await _medicationHistoryRepository.deleteAll();
      final window = DeletionRecoveryWindow.start(
        snapshot: captured,
        startedAt: _now(),
      );
      _recoveryWindow = window;
      return window;
    } on Object {
      await _restoreSnapshot(captured);
      final failed = DeletionRecoveryWindow.start(
        snapshot: captured,
        startedAt: _now(),
      ).markFailed();
      _recoveryWindow = failed;
      rethrow;
    }
  }

  @override
  Future<DeletionRecoveryWindow> restoreLocalReminderData() async {
    final window = expireRecoveryWindow(now: _now()) ?? _recoveryWindow;
    if (window == null || !window.isActiveAt(_now())) {
      throw StateError('The recovery window has ended.');
    }

    try {
      await _restoreSnapshot(window.snapshot);
      final restored = window.markRestored();
      _recoveryWindow = restored;
      return restored;
    } on Object {
      final failed = window.markFailed();
      _recoveryWindow = failed;
      rethrow;
    }
  }

  @override
  DeletionRecoveryWindow? expireRecoveryWindow({DateTime? now}) {
    final window = _recoveryWindow;
    if (window == null) return null;
    if (window.state != DeletionRecoveryWindowState.active) return window;
    final currentTime = now ?? _now();
    if (window.isActiveAt(currentTime)) return window;
    final expired = window.markExpired();
    _recoveryWindow = expired;
    return expired;
  }

  Future<void> _restoreSnapshot(LocalReminderDataSnapshot snapshot) async {
    await _medicationRepository.saveAll(snapshot.medications);
    await _reminderScheduleRepository.saveAll(snapshot.reminderSchedules);
    await _dueReminderRepository.saveAll(snapshot.dueReminders);
    await _dailyReminderHandlingRepository.saveAll(
      snapshot.dailyReminderHandling,
    );
    await _medicationHistoryRepository.saveAll(snapshot.medicationHistory);
    await _dueReminderRepository.savePreferences(
      snapshot.reminderHandlingPreferences,
    );
  }
}

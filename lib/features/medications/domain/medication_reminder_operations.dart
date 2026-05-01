import '../../../services/reminder_notification_scheduler.dart';
import '../../setup/domain/notification_permission_status.dart';
import '../data/due_reminder_repository.dart';
import '../data/medication_repository.dart';
import '../data/reminder_schedule_repository.dart';
import 'medication.dart';
import 'reminder_schedule.dart';

enum MedicationReminderOperation {
  editMedication,
  editSchedule,
  pause,
  resume,
  deleteSchedule,
  deleteMedication,
}

enum MedicationReminderOperationStatus { success, permissionLimited }

class MedicationReminderOperationResult {
  const MedicationReminderOperationResult({
    required this.operation,
    required this.status,
    required this.medicationId,
    this.scheduleId,
  });

  final MedicationReminderOperation operation;
  final MedicationReminderOperationStatus status;
  final String medicationId;
  final String? scheduleId;
}

class MedicationReminderOperations {
  MedicationReminderOperations({
    required MedicationRepository medicationRepository,
    required ReminderScheduleRepository scheduleRepository,
    required DueReminderRepository dueReminderRepository,
    required ReminderNotificationScheduler notificationScheduler,
  }) : _medicationRepository = medicationRepository,
       _scheduleRepository = scheduleRepository,
       _dueReminderRepository = dueReminderRepository,
       _notificationScheduler = notificationScheduler;

  final MedicationRepository _medicationRepository;
  final ReminderScheduleRepository _scheduleRepository;
  final DueReminderRepository _dueReminderRepository;
  final ReminderNotificationScheduler _notificationScheduler;

  Future<MedicationReminderOperationResult> updateMedicationDetails({
    required Medication medication,
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    final updated = await _medicationRepository.updateMedication(medication);
    final schedule = await _scheduleRepository.loadScheduleForMedication(
      updated.id,
    );
    var status = MedicationReminderOperationStatus.success;
    if (schedule != null && updated.isActive) {
      final result = await _notificationScheduler.refreshForMedication(
        schedule,
        title: title,
        body: body,
        permissionStatus: permissionStatus,
      );
      await _scheduleRepository.replaceSchedule(
        medicationId: schedule.medicationId,
        reminderTimes: schedule.reminderTimes,
        endDate: schedule.endDate,
        notificationDeliveryState: result.deliveryState,
      );
      status = _operationStatusFor(result);
    } else if (schedule != null) {
      await _notificationScheduler.cancelForMedication(schedule);
      final dueReminders = await _dueReminderRepository
          .loadUnresolvedDueReminders();
      final matching = dueReminders
          .where((reminder) => reminder.medicationId == updated.id)
          .toList(growable: false);
      await _notificationScheduler.cancelDueAndLaterForMedication(matching);
      await _dueReminderRepository.deleteDueRemindersForMedication(updated.id);
    }
    return MedicationReminderOperationResult(
      operation: MedicationReminderOperation.editMedication,
      status: status,
      medicationId: updated.id,
      scheduleId: schedule?.id,
    );
  }

  Future<MedicationReminderOperationResult> replaceSchedule({
    required Medication medication,
    required List<ReminderTime> reminderTimes,
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
    DateTime? endDate,
  }) async {
    final previous = await _scheduleRepository.loadScheduleForMedication(
      medication.id,
    );
    if (previous != null) {
      await _notificationScheduler.cancelForSchedule(previous);
      await _dueReminderRepository.deleteDueRemindersForSchedule(previous.id);
    }
    final initial = await _scheduleRepository.replaceSchedule(
      medicationId: medication.id,
      reminderTimes: reminderTimes,
      endDate: endDate,
      notificationDeliveryState: _deliveryStateForPermission(permissionStatus),
    );
    final result = medication.isActive
        ? await _notificationScheduler.schedule(
            initial,
            title: title,
            body: body,
            permissionStatus: permissionStatus,
          )
        : const ReminderNotificationScheduleResult(
            ReminderNotificationScheduleStatus.deferredForPermission,
          );
    final saved = await _scheduleRepository.replaceSchedule(
      medicationId: medication.id,
      reminderTimes: initial.reminderTimes,
      endDate: initial.endDate,
      notificationDeliveryState: result.deliveryState,
    );
    return MedicationReminderOperationResult(
      operation: MedicationReminderOperation.editSchedule,
      status: _operationStatusFor(result),
      medicationId: medication.id,
      scheduleId: saved.id,
    );
  }

  Future<MedicationReminderOperationResult> pauseMedication(
    Medication medication,
  ) async {
    final schedule = await _scheduleRepository.loadScheduleForMedication(
      medication.id,
    );
    if (schedule != null) {
      await _notificationScheduler.cancelForMedication(schedule);
    }
    final dueReminders = await _dueReminderRepository
        .loadUnresolvedDueReminders();
    final matching = dueReminders
        .where((reminder) => reminder.medicationId == medication.id)
        .toList(growable: false);
    await _notificationScheduler.cancelDueAndLaterForMedication(matching);
    await _dueReminderRepository.deleteDueRemindersForMedication(medication.id);
    await _medicationRepository.pauseMedication(medication.id);
    return MedicationReminderOperationResult(
      operation: MedicationReminderOperation.pause,
      status: MedicationReminderOperationStatus.success,
      medicationId: medication.id,
      scheduleId: schedule?.id,
    );
  }

  Future<MedicationReminderOperationResult> resumeMedication({
    required Medication medication,
    required String title,
    required String body,
    required SetupNotificationPermissionStatus permissionStatus,
  }) async {
    final resumed = await _medicationRepository.resumeMedication(medication.id);
    final schedule = await _scheduleRepository.loadScheduleForMedication(
      resumed.id,
    );
    var status = MedicationReminderOperationStatus.success;
    if (schedule != null) {
      final result = await _notificationScheduler.refreshForMedication(
        schedule,
        title: title,
        body: body,
        permissionStatus: permissionStatus,
      );
      await _scheduleRepository.replaceSchedule(
        medicationId: schedule.medicationId,
        reminderTimes: schedule.reminderTimes,
        endDate: schedule.endDate,
        notificationDeliveryState: result.deliveryState,
      );
      status = _operationStatusFor(result);
    }
    return MedicationReminderOperationResult(
      operation: MedicationReminderOperation.resume,
      status: status,
      medicationId: resumed.id,
      scheduleId: schedule?.id,
    );
  }

  Future<MedicationReminderOperationResult> deleteSchedule(
    Medication medication,
  ) async {
    final schedule = await _scheduleRepository.loadScheduleForMedication(
      medication.id,
    );
    if (schedule != null) {
      await _notificationScheduler.cancelForSchedule(schedule);
      await _dueReminderRepository.deleteDueRemindersForSchedule(schedule.id);
    }
    await _scheduleRepository.deleteSchedule(medication.id);
    return MedicationReminderOperationResult(
      operation: MedicationReminderOperation.deleteSchedule,
      status: MedicationReminderOperationStatus.success,
      medicationId: medication.id,
      scheduleId: schedule?.id,
    );
  }

  Future<MedicationReminderOperationResult> deleteMedication(
    Medication medication,
  ) async {
    final schedule = await _scheduleRepository.loadScheduleForMedication(
      medication.id,
    );
    if (schedule != null) {
      await _notificationScheduler.cancelForMedication(schedule);
    }
    final dueReminders = await _dueReminderRepository
        .loadUnresolvedDueReminders();
    final matching = dueReminders
        .where((reminder) => reminder.medicationId == medication.id)
        .toList(growable: false);
    await _notificationScheduler.cancelDueAndLaterForMedication(matching);
    await _dueReminderRepository.deleteDueRemindersForMedication(medication.id);
    await _scheduleRepository.deleteSchedule(medication.id);
    await _medicationRepository.deleteMedication(medication.id);
    return MedicationReminderOperationResult(
      operation: MedicationReminderOperation.deleteMedication,
      status: MedicationReminderOperationStatus.success,
      medicationId: medication.id,
      scheduleId: schedule?.id,
    );
  }

  MedicationReminderOperationStatus _operationStatusFor(
    ReminderNotificationScheduleResult result,
  ) {
    return result.status == ReminderNotificationScheduleStatus.scheduled
        ? MedicationReminderOperationStatus.success
        : MedicationReminderOperationStatus.permissionLimited;
  }

  ReminderNotificationDeliveryState _deliveryStateForPermission(
    SetupNotificationPermissionStatus status,
  ) {
    return switch (status) {
      SetupNotificationPermissionStatus.granted =>
        ReminderNotificationDeliveryState.deliverable,
      SetupNotificationPermissionStatus.unknown ||
      SetupNotificationPermissionStatus.skipped ||
      SetupNotificationPermissionStatus.denied =>
        ReminderNotificationDeliveryState.permissionNeeded,
      SetupNotificationPermissionStatus.blocked =>
        ReminderNotificationDeliveryState.blocked,
      SetupNotificationPermissionStatus.unavailable =>
        ReminderNotificationDeliveryState.unavailable,
    };
  }
}

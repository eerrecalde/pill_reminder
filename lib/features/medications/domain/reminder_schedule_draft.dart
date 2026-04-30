import '../../setup/domain/notification_permission_status.dart';
import 'medication.dart';
import 'reminder_schedule.dart';
import 'reminder_schedule_validation.dart';

enum ReminderScheduleDraftOutcome { editing, cancelled, saved }

class ReminderScheduleDraft {
  const ReminderScheduleDraft({
    required this.medication,
    required this.selectedTimes,
    required this.notificationPermissionStatus,
    this.endDate,
    this.validationState = const ReminderScheduleValidationResult.valid(),
    this.outcome = ReminderScheduleDraftOutcome.editing,
  });

  final Medication medication;
  final List<ReminderTime> selectedTimes;
  final DateTime? endDate;
  final SetupNotificationPermissionStatus notificationPermissionStatus;
  final ReminderScheduleValidationResult validationState;
  final ReminderScheduleDraftOutcome outcome;

  List<ReminderTime> get sortedTimes {
    return [...selectedTimes]..sort();
  }

  ReminderScheduleDraft copyWith({
    Medication? medication,
    List<ReminderTime>? selectedTimes,
    DateTime? endDate,
    bool clearEndDate = false,
    SetupNotificationPermissionStatus? notificationPermissionStatus,
    ReminderScheduleValidationResult? validationState,
    ReminderScheduleDraftOutcome? outcome,
  }) {
    return ReminderScheduleDraft(
      medication: medication ?? this.medication,
      selectedTimes: selectedTimes ?? this.selectedTimes,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      notificationPermissionStatus:
          notificationPermissionStatus ?? this.notificationPermissionStatus,
      validationState: validationState ?? this.validationState,
      outcome: outcome ?? this.outcome,
    );
  }
}

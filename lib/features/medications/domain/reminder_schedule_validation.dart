import 'reminder_schedule.dart';
import 'reminder_schedule_draft.dart';

enum ReminderScheduleValidationIssue {
  inactiveMedication,
  missingTime,
  duplicateTime,
  tooManyTimes,
  invalidEndDate,
}

class ReminderScheduleValidationError {
  const ReminderScheduleValidationError(this.issue);

  final ReminderScheduleValidationIssue issue;
}

class ReminderScheduleValidationResult {
  const ReminderScheduleValidationResult._(this.errors);

  const ReminderScheduleValidationResult.valid() : errors = const [];

  const ReminderScheduleValidationResult.invalid(this.errors);

  final List<ReminderScheduleValidationError> errors;

  bool get isValid => errors.isEmpty;

  ReminderScheduleValidationError? get firstError {
    return errors.isEmpty ? null : errors.first;
  }

  bool hasIssue(ReminderScheduleValidationIssue issue) {
    return errors.any((error) => error.issue == issue);
  }
}

class ReminderScheduleValidation {
  static const maxDailyTimes = 4;

  static ReminderScheduleValidationResult validate(
    ReminderScheduleDraft draft, {
    DateTime? now,
  }) {
    final errors = <ReminderScheduleValidationError>[];
    final uniqueTimes = draft.selectedTimes.toSet();

    if (!draft.medication.isActive) {
      errors.add(
        const ReminderScheduleValidationError(
          ReminderScheduleValidationIssue.inactiveMedication,
        ),
      );
    }
    if (draft.selectedTimes.isEmpty) {
      errors.add(
        const ReminderScheduleValidationError(
          ReminderScheduleValidationIssue.missingTime,
        ),
      );
    }
    if (uniqueTimes.length != draft.selectedTimes.length) {
      errors.add(
        const ReminderScheduleValidationError(
          ReminderScheduleValidationIssue.duplicateTime,
        ),
      );
    }
    if (draft.selectedTimes.length > maxDailyTimes) {
      errors.add(
        const ReminderScheduleValidationError(
          ReminderScheduleValidationIssue.tooManyTimes,
        ),
      );
    }
    if (draft.endDate != null &&
        !_isEndDateValid(draft.endDate!, draft.selectedTimes, now: now)) {
      errors.add(
        const ReminderScheduleValidationError(
          ReminderScheduleValidationIssue.invalidEndDate,
        ),
      );
    }

    return ReminderScheduleValidationResult._(errors);
  }

  static List<ReminderTime> sortedUniqueTimes(List<ReminderTime> times) {
    return times.toSet().toList()..sort();
  }

  static bool _isEndDateValid(
    DateTime endDate,
    List<ReminderTime> times, {
    DateTime? now,
  }) {
    if (times.isEmpty) return true;
    final current = now ?? DateTime.now();
    final firstDate = _firstPossibleReminderDate(current, times);
    final endLocalDate = DateTime(endDate.year, endDate.month, endDate.day);
    return !endLocalDate.isBefore(firstDate);
  }

  static DateTime _firstPossibleReminderDate(
    DateTime now,
    List<ReminderTime> times,
  ) {
    final sorted = [...times]..sort();
    for (final time in sorted) {
      final candidate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      if (!candidate.isBefore(now)) {
        return DateTime(now.year, now.month, now.day);
      }
    }
    final tomorrow = now.add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
  }
}

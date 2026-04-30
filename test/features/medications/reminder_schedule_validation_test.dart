import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule_draft.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule_validation.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';

import 'reminder_schedule_test_fixtures.dart';

void main() {
  ReminderScheduleDraft draft({
    List<ReminderTime>? times,
    DateTime? endDate,
    bool inactive = false,
  }) {
    return ReminderScheduleDraft(
      medication: inactive
          ? inactiveMedicationFixture()
          : activeMedicationFixture(),
      selectedTimes: times ?? [reminderTimeFixture()],
      endDate: endDate,
      notificationPermissionStatus: SetupNotificationPermissionStatus.granted,
    );
  }

  test('accepts one to four unique daily times and sorts them', () {
    final times = [
      reminderTimeFixture(hour: 20),
      reminderTimeFixture(hour: 8),
      reminderTimeFixture(hour: 12),
      reminderTimeFixture(hour: 16),
    ];

    final result = ReminderScheduleValidation.validate(draft(times: times));
    final sorted = ReminderScheduleValidation.sortedUniqueTimes(times);

    expect(result.isValid, isTrue);
    expect(sorted.map((time) => time.hour), [8, 12, 16, 20]);
  });

  test('accepts indefinite default and valid optional end date', () {
    final indefinite = ReminderScheduleValidation.validate(draft());
    final withEndDate = ReminderScheduleValidation.validate(
      draft(endDate: DateTime(2026, 5, 1)),
      now: DateTime(2026, 4, 30, 7),
    );

    expect(indefinite.isValid, isTrue);
    expect(withEndDate.isValid, isTrue);
  });

  test('rejects missing duplicate and fifth reminder time', () {
    expect(
      ReminderScheduleValidation.validate(
        draft(times: const []),
      ).hasIssue(ReminderScheduleValidationIssue.missingTime),
      isTrue,
    );
    expect(
      ReminderScheduleValidation.validate(
        draft(
          times: [reminderTimeFixture(hour: 8), reminderTimeFixture(hour: 8)],
        ),
      ).hasIssue(ReminderScheduleValidationIssue.duplicateTime),
      isTrue,
    );
    expect(
      ReminderScheduleValidation.validate(
        draft(
          times: [
            reminderTimeFixture(hour: 6),
            reminderTimeFixture(hour: 8),
            reminderTimeFixture(hour: 12),
            reminderTimeFixture(hour: 18),
            reminderTimeFixture(hour: 22),
          ],
        ),
      ).hasIssue(ReminderScheduleValidationIssue.tooManyTimes),
      isTrue,
    );
  });

  test('rejects inactive medication and invalid end date', () {
    expect(
      ReminderScheduleValidation.validate(
        draft(inactive: true),
      ).hasIssue(ReminderScheduleValidationIssue.inactiveMedication),
      isTrue,
    );
    expect(
      ReminderScheduleValidation.validate(
        draft(
          times: [reminderTimeFixture(hour: 8)],
          endDate: DateTime(2026, 4, 30),
        ),
        now: DateTime(2026, 4, 30, 9),
      ).hasIssue(ReminderScheduleValidationIssue.invalidEndDate),
      isTrue,
    );
  });
}

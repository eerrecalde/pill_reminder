import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/reminder_handling_preferences.dart';

void main() {
  test('defaults remind again later to 10 minutes', () {
    const preferences = ReminderHandlingPreferences();

    expect(preferences.remindAgainLaterIntervalMinutes, 10);
  });

  test('stores changed app-wide interval', () {
    final updated = const ReminderHandlingPreferences().copyWith(
      remindAgainLaterIntervalMinutes: 30,
      updatedAt: DateTime(2026, 5, 1),
    );

    expect(updated.remindAgainLaterIntervalMinutes, 30);
    expect(updated.updatedAt, DateTime(2026, 5, 1));
  });
}

# Quickstart: Reminder Notification Handling

## Prerequisites

- Flutter SDK available.
- Dependencies installed with `flutter pub get`.
- A local medication and reminder schedule can be created from the existing
  medication and schedule flows.

## Automated Verification

Run the focused test suite while implementing:

```bash
flutter test test/features/medications/due_reminder_state_test.dart
flutter test test/features/medications/due_reminder_repository_test.dart
flutter test test/features/medications/reminder_action_handler_test.dart
flutter test test/features/medications/reminder_due_reconciler_test.dart
flutter test test/features/medications/reminder_handling_preferences_test.dart
flutter test test/features/medications/due_reminder_screen_test.dart
```

Run the full project checks before merge:

```bash
flutter test
flutter analyze
```

## Manual Verification

1. Create an active medication with a dosage label and a daily reminder schedule.
2. Wait for the reminder to become due with notification permission granted.
3. Confirm the local notification shows medication name, dosage label, and
   scheduled time.
4. Mark the reminder taken from the notification.
5. Open the app and confirm the reminder is shown as taken, not unresolved.
6. Repeat with a medication that has no dosage label and confirm no blank dosage
   placeholder appears.
7. Trigger another due reminder and choose skip from the app.
8. Confirm the final state is skipped and stale notification actions do not
   change it to taken.
9. Trigger another due reminder and choose remind again later.
10. Confirm the later reminder uses the app-wide interval and defaults to 10
    minutes when unchanged.
11. Choose remind again later multiple times and confirm there is only one
    pending later reminder for that due medication occurrence.
12. Disable notification permission, or revoke it in system settings so the app
    reports denied or blocked, let a reminder time pass, then open the app and
    confirm the due reminder can still be handled in-app.
13. Restart the app or device around a due time and confirm there is one
    consistent reminder state for the medication and scheduled time.
14. Enable notifications again and confirm future reminders resume without
    duplicating old due reminders.
15. On Android and iOS, confirm notification action buttons/categories appear
    where supported for taken, skip, and remind again later, and that each action
    updates the same in-app due reminder state.
16. Time the taken, skip, and remind-again-later actions from both notification
    and in-app paths; each primary action should be completed in under 30
    seconds by representative older adult or caregiver testers.

## Accessibility and Localization Checks

- Complete due reminder handling with large text enabled.
- Complete due reminder handling with a screen reader enabled.
- Confirm medication name, dosage label if present, scheduled time, state, and
  action labels are announced in a logical order.
- Confirm taken, skip, and remind-again-later controls remain reachable with
  large touch targets.
- Review English and Latin American Spanish strings for notification text,
  in-app state text, action labels, permission guidance, and time formatting.

## Privacy Checks

- Confirm due reminder state, outcomes, and remind-again-later preferences are
  stored locally.
- Delete a medication or remove a reminder schedule and confirm associated due
  reminder states, outcomes, and pending remind-again-later requests are removed
  locally.
- Confirm no account, sync, analytics, backup, sharing, or remote service is
  required to receive or handle due reminders.

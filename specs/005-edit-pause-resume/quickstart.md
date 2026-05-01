# Quickstart: Edit, Pause, Resume

## Prerequisites

- Flutter `3.41.8`
- Dart SDK compatible with `^3.11.5`
- Project dependencies fetched with `flutter pub get`
- iOS and Android devices or simulators for manual notification checks

## Implementation Notes

1. Extend the medication domain/repository to update saved medication details
   and persist medication-level paused state without changing stable ids.
2. Extend schedule edit behavior to load current times, validate drafts, show a
   review step, cancel previous notifications, save the replacement schedule,
   and schedule only updated future times.
3. Wire pause/resume actions to medication status, scheduler cancellation, due
   reminder cleanup, and future rescheduling from the next applicable time.
4. Wire delete schedule and delete medication confirmations to local repository
   deletion plus notification/due/later cleanup.
5. Add localized ARB strings for all edit, pause, resume, delete,
   confirmation, error, permission, status, and notification text.
6. Keep UI aligned with `docs/ux-design.md`: calm sentence-case copy, large
   readable text, generous spacing, clear cancel paths, large touch targets, and
   non-color-only status.

## Automated Verification

Run:

```sh
flutter test
flutter analyze
```

Focused test areas:
- `test/features/medications/medication_repository_test.dart`
- `test/features/medications/reminder_schedule_repository_test.dart`
- `test/features/medications/reminder_schedule_validation_test.dart`
- `test/features/medications/reminder_schedule_screen_test.dart`
- `test/features/medications/edit_medication_screen_test.dart`
- `test/features/medications/edit_pause_resume_flow_test.dart`
- `test/features/medications/reminder_notification_scheduler_test.dart`
- Existing due-reminder and reminder-reconciler tests for pause/delete cleanup

## Manual Verification

Medication edit:
- Create a medication with reminder times.
- Edit the medication name and dosage label.
- Confirm the list and future reminder copy use updated details.
- Confirm the schedule times did not change.
- Cancel an edit and confirm saved details remain unchanged.

Schedule edit:
- Edit an existing schedule.
- Confirm current times are preselected.
- Try no times, duplicate times, and more than 4 times; valid choices should
  remain selected after errors.
- Save changed times, restart the app, and confirm only updated future times are
  active.

Pause/resume:
- Pause a medication with an active schedule.
- Confirm the paused state is visible without relying on color.
- Let a scheduled time pass and confirm no notification appears for that
  medication.
- Resume and confirm the next future reminder is scheduled without backfilled
  missed notifications.

Deletion:
- Delete only a schedule, cancel at confirmation, and confirm nothing changed.
- Confirm schedule deletion, then verify the medication remains without reminder
  times and no stale future/due/later reminders appear.
- Delete a medication, cancel at confirmation, and confirm nothing changed.
- Confirm medication deletion, then verify medication, schedule, future
  notifications, due reminders, and remind-again-later requests are removed.

Permission/offline:
- Repeat edit, pause, resume, and delete flows while offline.
- Repeat schedule edit/resume with notifications skipped, denied, blocked, and
  unavailable where platform support allows.
- Confirm local saves still succeed and permission-limited messaging is clear.

Accessibility/localization:
- Complete primary flows with large text enabled.
- Complete confirmation and error states with a screen reader enabled.
- Review English and Latin American Spanish strings, dates, and times for all
  edit, pause, resume, delete, error, confirmation, and status copy.

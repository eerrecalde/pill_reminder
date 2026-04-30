# Quickstart: Reminder Schedule

## Prerequisites

- Existing setup feature and localization support available.
- Existing medication feature with saved active medications available.
- Device or simulator/emulator access for iOS and Android notification
  permission verification.

## Implementation Steps

1. Add reminder schedule domain objects under `lib/features/medications/domain/`.
2. Add schedule validation for active medication, one to four times, duplicate
   times, optional end date, and cancellation behavior.
3. Add `ReminderScheduleRepository` and local JSON implementation under
   `lib/features/medications/data/`.
4. Add `ReminderNotificationScheduler` under `lib/services/` to isolate platform
   notification scheduling from UI, backed by `flutter_local_notifications`.
5. Add the Material schedule flow under `lib/features/medications/presentation/`
   using `docs/ux-design.md` for tone, layout, touch targets, and accessibility.
6. Add English, Latin American Spanish, and fallback Spanish strings for schedule
   copy, validation, review summaries, date/time text, and notification guidance.
7. Wire saved active medications to the schedule flow and keep inactive
   medications blocked with clear guidance.

## Automated Verification

Run:

```bash
flutter test
```

Expected focused coverage:

1. Schedule validation accepts one to four unique daily times.
2. Schedule validation rejects no times, duplicate times, fifth time, inactive
   medication, and invalid end date.
3. Repository saves, loads, edits, deletes, and preserves schedule data after
   app restart simulation.
4. Widget flow completes one-time and four-time schedules from medication entry
   through review and save.
5. Widget flow preserves valid selections after validation errors.
6. Widget flow saves schedules while notifications are unavailable and shows
   calm delivery guidance.
7. Widget flow marks saved schedules deliverable after permission becomes
   available.
8. Large text and screen-reader tests cover time selectors, review summary,
   validation messages, permission state, save, and cancel.
9. Localization tests verify English and Latin American Spanish schedule copy and
   locale-aware date/time formatting.

## Manual Verification

1. On Android, create a schedule with notifications granted and confirm a local
   reminder can be scheduled for the selected time.
2. On Android, deny notification permission, save a schedule, then enable
   permission later and confirm the saved schedule becomes deliverable without
   recreation.
3. On iOS, repeat the granted and denied/reenabled permission paths.
4. With the device offline, create and review a one-time and four-time daily
   schedule.
5. Restart the app and confirm saved schedule times, optional end date, and
   delivery state remain understandable.
6. Enable large text and screen reader, then complete the schedule flow without
   clipped text, overlapping controls, or unlabeled actions.
7. Switch between English and Latin American Spanish and verify schedule
   summaries, dates, times, validation, and notification guidance are localized.

## Performance Checks

- Schedule flow opens within 1 second from a saved medication on a typical phone
  or tablet.
- Saving a normal local schedule completes without perceptible delay.
- No account lookup, analytics call, backup, sync, or remote request runs during
  schedule creation.
- Notification scheduling avoids polling and unnecessary background work.

## UX And Privacy Notes

- The implemented schedule flow follows `docs/ux-design.md`: calm language,
  one primary action per step, visible validation text, large touch targets,
  locale-aware date/time formatting, screen-reader labels, and large-text
  widget coverage. No deviations are currently documented.
- Schedule records are stored locally with the medication reminder schedule
  repository and retained until the user edits or deletes the medication's
  schedule.
- Deleting a schedule removes the local schedule record for that medication.
- The schedule flow does not add account creation, sharing, donation prompts,
  analytics, cloud backup, sync, or remote-service behavior.

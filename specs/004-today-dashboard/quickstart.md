# Quickstart: Today Dashboard

## Prerequisites

- Existing setup, medication entry, reminder schedule, localization, and local
  notification code available.
- Device or simulator/emulator access for iOS and Android notification
  suppression verification.

## Implementation Steps

1. Add dashboard domain objects under `lib/features/medications/domain/` for
   today reminder items, sections, snapshots, statuses, and daily handling
   records.
2. Add `DailyReminderHandlingRepository` and a local JSON implementation under
   `lib/features/medications/data/`.
3. Add `TodayDashboardService` to derive dashboard snapshots from medications,
   schedules, handling records, and a supplied clock.
4. Extend `ReminderNotificationScheduler` with a method that suppresses today's
   alert for a single schedule time while preserving future daily delivery.
5. Add `TodayDashboardScreen` and supporting widgets under
   `lib/features/medications/presentation/`.
6. Replace the post-setup landing content in `main.dart` with the dashboard, and
   keep add-medication, schedule-reminder, setup preferences, and notification
   banner paths reachable.
7. Add English, Latin American Spanish, and fallback Spanish strings for
   dashboard headings, statuses, empty states, actions, dates/times, tooltips,
   and semantic labels.

## Automated Verification

Run:

```bash
flutter test
```

Expected focused coverage:

1. Dashboard service derives due-now, upcoming, missed, and handled statuses at
   the scheduled time, 60-minute boundary, and after the boundary.
2. Dashboard service filters inactive medications and schedules ended before the
   current local date.
3. Dashboard service orders sections as due now, upcoming, missed, handled, and
   sorts items by time then medication name within each section.
4. Daily handling repository saves, loads, and idempotently updates current-day
   handled records after app restart simulation.
5. Marking due-now or upcoming reminders handled updates the dashboard
   immediately and persists the handled state.
6. Marking an upcoming reminder handled calls notification suppression for
   today's alert and does not delete the saved schedule.
7. Empty states cover no medications, no active medications, active medications
   without schedules, and clear-for-today states.
8. Widget tests cover large text, screen-reader semantics, high contrast-safe
   status text/icons, visible actions, and large touch targets.
9. Localization tests verify English and Latin American Spanish dashboard copy
   and locale-aware time/date formatting.

## Manual Verification

1. With setup complete and no medications, open the app and confirm the
   dashboard offers add medication in one tap.
2. Add an active medication without a reminder schedule and confirm the
   dashboard offers a schedule-reminder path.
3. Create reminders due in the past, within the last 60 minutes, later today,
   and already handled; confirm grouping, ordering, and labels.
4. Mark a due-now reminder handled and confirm it moves to handled immediately
   and remains handled after app restart.
5. Mark an upcoming reminder handled with notifications granted and confirm
   today's alert is suppressed while future reminders remain scheduled.
6. Deny or block notification permission and confirm the dashboard still shows
   local reminders and handled actions.
7. Leave the dashboard open across a due-time boundary, a 60-minute missed
   boundary, and local midnight; confirm sections refresh.
8. Enable large text, screen reader, and high contrast; confirm no clipped
   primary content, overlapping controls, unlabeled actions, or color-only
   status communication.
9. Switch between English and Latin American Spanish and verify headings,
   statuses, empty states, actions, dates, times, and semantics are localized.

## Performance Checks

- Dashboard shows locally saved content within 1 second after setup on a typical
  phone or tablet.
- Mark handled updates visible UI immediately after local persistence completes,
  without perceptible delay.
- Day/status refresh uses scheduled boundaries rather than frequent polling.
- No account lookup, analytics call, backup, sync, donation, sharing, or remote
  request runs when the dashboard opens or a reminder is marked handled.

## UX And Privacy Notes

- The dashboard follows `docs/ux-design.md`: calm language, readable spacing,
  visible status text, large touch targets, pressure-free empty states,
  screen-reader labels, and large-text resilient layout.
- Status can use color as reinforcement only; text and/or icons carry the
  meaning.
- Daily handling records are stored locally and used only to show today's
  handled state and suppress today's alert.
- The dashboard does not add account creation, sharing, donation prompts,
  analytics, cloud backup, sync, or remote-service behavior.

# Contract: Today Dashboard

This contract defines the user-visible dashboard states, local derivation rules,
repository behavior, and notification suppression behavior for the Flutter app.
It is a UI/state contract, not a network API.

## Entry Conditions

- After setup is complete, the app lands on the Today Dashboard.
- The dashboard is available offline and without an account.
- Medication management remains reachable from the dashboard through the add
  medication action and a manage/schedule reminders path.
- Notification permission denied, blocked, skipped, or unavailable states do not
  block the dashboard or hide locally saved reminder schedules.

## Dashboard Sections

- Due now, upcoming, missed, and handled sections are shown only when they
  contain items.
- Section priority is due now, upcoming, missed, handled.
- Items within each section are ordered by reminder time, then medication name.
- Due-now items must be visually and textually emphasized ahead of lower
  priority sections.
- Handled reminders remain visible for the current day.

## Status Rules

- Upcoming: unhandled reminder scheduled later today.
- Due now: unhandled reminder from scheduled local time through 60 minutes after
  scheduled local time.
- Missed: unhandled reminder more than 60 minutes after scheduled local time.
- Handled: reminder with a matching current-day handling record.
- Status must be shown with localized text and/or icon labels in addition to any
  color styling.
- Screen reader labels for each item include medication name, reminder time, and
  status.

## Empty And Clear States

- No saved medications: explain that no medications are saved yet and offer an
  add-medication action.
- Saved medications but none active: explain that no active medications are
  ready for reminders and offer a medication management path.
- Active medications but no reminder schedules: explain that no reminders are
  scheduled yet and offer a schedule-reminder action.
- No remaining unhandled reminders today, or all today reminders handled: state
  that the rest of today is clear without implying the user has no medications.

## Mark Handled Behavior

- Due-now and upcoming items expose a direct mark-handled action on the
  dashboard.
- Missed handling may be supported by the same action if implementation keeps
  the action consistent, but the spec only requires due-now and upcoming.
- Mark handled writes a local `DailyReminderHandling` record immediately.
- The dashboard updates the item to handled in the current view without
  requiring navigation or restart.
- Marking an upcoming item handled calls the notification scheduler to suppress
  today's alert for that schedule time while preserving future daily reminders.
- Mark handled is idempotent for the same local date, schedule, medication, and
  reminder time.

## Repository Contract

- `DailyReminderHandlingRepository` provides local load and mark-handled
  operations by local date.
- Records are stored as local JSON through `shared_preferences`, matching the
  existing medication and reminder schedule repository style.
- Repository APIs expose domain values, not Flutter widgets.
- Repository operations do not require internet, account state, analytics, or
  remote identifiers.

## Dashboard Service Contract

- `TodayDashboardService` accepts medication, schedule, and daily handling
  repositories plus a clock input for deterministic tests.
- Service output is a `TodayDashboardSnapshot` with ordered sections and a
  `nextRefreshAt` boundary.
- The service filters inactive medications and schedules whose end date is
  before the dashboard local date.
- The service derives all statuses using local time and the 60-minute due-now
  window.

## Notification Scheduler Contract

- `ReminderNotificationScheduler` remains the only boundary that talks to
  platform notification APIs.
- The scheduler exposes a method to suppress today's alert for one schedule time
  after an upcoming dashboard item is handled.
- Suppression must not delete the saved reminder schedule or block future daily
  alerts.
- If notifications are denied, blocked, skipped, or unavailable, suppression
  returns calmly without blocking local handled persistence.

## Accessibility And Localization

- All dashboard copy, section headings, statuses, dates, times, empty states,
  button labels, tooltips, and semantic labels use ARB localization resources.
- English and Latin American Spanish copy are required, with fallback Spanish
  kept in sync.
- Layout supports large text without clipped medication names, blocked actions,
  or overlapping controls.
- Buttons and tappable rows meet 48px minimum touch targets, with 56px preferred
  for primary actions.
- Focus indicators remain visible and reading order follows section order.
- High contrast and color-blind use remain understandable through text/icons.

## Privacy And Scope

- The dashboard must not introduce account creation, backup, sync, donation,
  sharing, analytics, ads, or remote-service prompts.
- The dashboard may show local notification delivery guidance, but it must not
  make reminders appear unavailable when only alerts are disabled.
- The first version covers the current local calendar day only.

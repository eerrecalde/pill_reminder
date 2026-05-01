# Research: Today Dashboard

## Dashboard Landing View

**Decision**: Replace the post-setup medication-list landing content with a
Today Dashboard while keeping medication management reachable from the dashboard.

**Rationale**: The feature requires the dashboard to be the main landing view
after setup. Existing `main.dart` already gates setup completion and then builds
the post-setup home, so this is the smallest integration point.

**Alternatives considered**: Adding the dashboard as a secondary tab or screen
was rejected because users would still need navigation to understand their day.

## Current-Day Reminder Derivation

**Decision**: Add a `TodayDashboardService` domain layer that loads medications,
schedules, and daily handling records, then returns grouped dashboard sections.

**Rationale**: Due-now, upcoming, missed, handled, ordering, inactive medication
filtering, end-date eligibility, and day-change behavior are domain rules that
need deterministic unit tests. Keeping them out of widgets preserves the
existing maintainable architecture principle.

**Alternatives considered**: Computing dashboard status directly inside
`TodayDashboardScreen` was rejected because it would make time-window and
persistence rules harder to test.

## Daily Handling State

**Decision**: Persist dashboard-handled reminders in a local
`DailyReminderHandlingRepository`, backed by `shared_preferences` JSON records.

**Rationale**: Handled reminders must survive app restart, remain visible for the
current day, and suppress today's alert when marked before the scheduled time.
The project already uses local JSON repositories for medication and schedule
data, so this follows the existing storage pattern without a new dependency.

**Alternatives considered**: Storing handled flags on `ReminderSchedule` was
rejected because handling is date-specific. In-memory widget state was rejected
because it would be lost on restart.

## Status Windows And Ordering

**Decision**: Treat an unhandled reminder as due now from scheduled local time
through 60 minutes after, missed after that window, upcoming before scheduled
time, and handled when a matching daily handling record exists for the local
date. Group order is due now, upcoming, missed, handled; items within each group
sort by reminder time and then medication name.

**Rationale**: The status windows and top-level group priority come from the
spec. Sorting by time inside each group keeps the day readable, while medication
name provides stable ordering for reminders at the same time.

**Alternatives considered**: Pure chronological ordering was rejected because it
would not emphasize due-now items before less urgent content. Hiding handled
items was rejected because the spec requires handled reminders to remain
visible.

## Notification Suppression

**Decision**: Extend `ReminderNotificationScheduler` with a method to suppress
today's alert for one schedule time after an upcoming reminder is marked
handled, while preserving future daily delivery.

**Rationale**: Existing notification scheduling lives behind a service boundary.
The dashboard should not manipulate platform notifications directly, but FR-022
requires the mark-handled action to affect today's alert.

**Alternatives considered**: Ignoring notification changes was rejected because
today's alert could still fire after the user handled it. Moving notification
logic into the dashboard widget was rejected because it would mix platform side
effects with UI state.

## Day-Change Refresh

**Decision**: Refresh dashboard grouping on load, after returning from add or
schedule flows, after marking handled, when app lifecycle resumes, and with a
timer scheduled for the next relevant boundary: next reminder time, next
60-minute expiry, or local midnight.

**Rationale**: The dashboard must update while open, but frequent polling would
waste battery. Boundary-based refresh keeps status accurate with minimal
background work.

**Alternatives considered**: Refreshing every minute was rejected as unnecessary
background work. Refreshing only on app resume was rejected because due-now and
missed status could become stale while the screen remains open.

## Accessibility And Localization

**Decision**: Use localized ARB strings for all dashboard copy and semantics,
locale-aware time/date formatting, visible status labels plus icons, 48px
minimum touch targets with 56px preferred actions, and large-text resilient
layouts.

**Rationale**: The constitution and feature spec require English and Latin
American Spanish localization, screen reader support, high contrast, large text,
and non-color-only status communication.

**Alternatives considered**: Color-only urgency styling and hard-coded strings
were rejected because they violate accessibility and localization requirements.

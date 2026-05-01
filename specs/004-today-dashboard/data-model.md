# Data Model: Today Dashboard

## TodayReminderItem

Represents one current-day reminder instance derived from a saved medication and
one reminder time on its saved schedule.

**Fields**

- `id`: Stable display identifier composed from local date, schedule id,
  medication id, and reminder time.
- `localDate`: Current local calendar date for this reminder instance.
- `medicationId`: Associated saved medication id.
- `medicationName`: User-entered medication name.
- `dosageLabel`: Optional saved dosage label for display when present.
- `scheduleId`: Associated saved reminder schedule id.
- `reminderTime`: Local `ReminderTime` for this instance.
- `scheduledDateTime`: Local date and time for today's reminder.
- `status`: `dueNow`, `upcoming`, `missed`, or `handled`.
- `handledAt`: Local timestamp when the user marked this instance handled, if
  present.
- `notificationDeliveryState`: Delivery state from the saved reminder schedule.
- `semanticsLabel`: Localized summary containing medication name, time, status,
  and available action.

**Validation Rules**

- Items are generated only for active medications with a saved reminder schedule
  that applies on `localDate`.
- A schedule with an `endDate` before `localDate` generates no dashboard items.
- A medication without a schedule generates no reminder items, but may affect
  empty-state wording.
- Status must never rely on color alone; each status has localized visible text
  and accessible semantics.
- Time text must use locale-aware formatting.

**State Transitions**

1. Upcoming -> handled when the user marks it handled before scheduled time.
2. Due now -> handled when the user marks it handled during the 60-minute due
   window.
3. Due now -> missed when more than 60 minutes have passed without handling.
4. Upcoming -> due now when local time reaches the scheduled time.
5. Handled stays handled until the local date changes.

## DashboardSection

Represents one visible group or empty/clear-day state on the dashboard.

**Fields**

- `type`: `dueNow`, `upcoming`, `missed`, `handled`, `noMedications`,
  `noActiveMedications`, `noSchedules`, or `clearForToday`.
- `title`: Localized visible heading.
- `description`: Optional localized supporting copy.
- `items`: Ordered `TodayReminderItem` values for reminder sections.
- `primaryAction`: Optional action: `addMedication`, `scheduleReminder`, or none.

**Validation Rules**

- Reminder sections appear in this order when non-empty: due now, upcoming,
  missed, handled.
- Items within each reminder section sort by `reminderTime`, then
  `medicationName`.
- Empty states are mutually exclusive and must not imply no medications exist
  when medications exist but schedules are missing or the day is clear.
- Empty-state actions must be reachable in no more than one tap from the
  dashboard.

## DailyReminderHandling

Represents the local record that one current-day reminder instance has already
been handled.

**Fields**

- `id`: Stable local identifier composed from local date, schedule id,
  medication id, and reminder time.
- `localDate`: Local calendar date handled.
- `scheduleId`: Associated saved reminder schedule id.
- `medicationId`: Associated saved medication id.
- `reminderTime`: Handled local reminder time.
- `handledAt`: Local timestamp for the user action.
- `source`: `todayDashboard` for records created by this feature.

**Validation Rules**

- One handling record may exist per local date, schedule, medication, and
  reminder time.
- Records are local-only and contain no account, sync, analytics, or remote
  identifiers.
- The dashboard reads only records matching the current local date.
- Old records may remain locally for short-term audit/debugging, but must not
  affect future dates.

**State Transitions**

1. No record -> mark handled -> saved `DailyReminderHandling`.
2. Duplicate mark handled -> keep the existing record or update `handledAt`
   idempotently without creating duplicate dashboard items.
3. Local date changes -> previous records no longer affect dashboard status.

## TodayDashboardSnapshot

Represents the complete derived dashboard state for rendering.

**Fields**

- `generatedAt`: Local timestamp used for status derivation.
- `localDate`: Local date represented by the snapshot.
- `sections`: Ordered dashboard sections.
- `nextRefreshAt`: Next local timestamp when the dashboard should refresh, if
  any before midnight.
- `notificationStatus`: Current notification permission/delivery status for
  banner messaging.

**Validation Rules**

- Snapshot generation must be deterministic for a supplied `generatedAt`.
- Snapshot generation must work offline and without account state.
- `nextRefreshAt` is the next reminder boundary, 60-minute due expiry, or local
  midnight, whichever is soonest.

## Relationships

- A `TodayReminderItem` is derived from one `Medication`, one
  `ReminderSchedule`, and one `ReminderTime`.
- A `DailyReminderHandling` record matches at most one `TodayReminderItem` for
  the current local date.
- A `TodayDashboardSnapshot` contains zero or more `DashboardSection` values.
- `ReminderNotificationScheduler` uses the same schedule/time identity to
  suppress today's alert when an upcoming item is marked handled.

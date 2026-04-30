# Data Model: Reminder Schedule

## ReminderSchedule

Represents one locally stored daily reminder schedule for a saved active
medication.

**Fields**

- `id`: Local stable identifier generated on save.
- `medicationId`: Local identifier of the associated saved medication.
- `reminderTimes`: Ordered list of one to four `ReminderTime` values.
- `endDate`: Optional local date when the daily schedule stops. Empty means the
  schedule continues indefinitely until edited or removed.
- `notificationDeliveryState`: Whether reminder alerts are currently deliverable
  for this schedule: `deliverable`, `permissionNeeded`, `blocked`, or
  `unavailable`.
- `createdAt`: Local timestamp when the schedule is first saved.
- `updatedAt`: Local timestamp when the schedule is last changed.

**Validation Rules**

- The associated medication must exist and be active before a schedule can be
  created or saved.
- `reminderTimes` must contain at least one time and at most four times.
- `reminderTimes` must not contain duplicate time-of-day values.
- `reminderTimes` are stored and reviewed in the order reminders will happen.
- `endDate`, when present, must be on or after the local date of the first
  possible reminder. The end date is inclusive for reminders on that local date.
- A missing `endDate` means the schedule repeats daily indefinitely until edited
  or removed.
- Schedule data must not include dosage safety advice, clinical recommendations,
  medication interaction warnings, refill tracking, or taken/not-taken state.

**State Transitions**

1. No schedule -> valid save for active medication -> `ReminderSchedule` saved.
2. Saved schedule -> edit times/end date -> updated `ReminderSchedule`.
3. Saved schedule with unavailable notifications -> permission enabled ->
   schedule becomes deliverable automatically.
4. Saved schedule -> user removes schedule -> no schedule for that medication.
5. Associated medication becomes inactive -> schedule must not be treated as
   deliverable until the medication is active again.

## ReminderTime

Represents one daily time-of-day selected by the user.

**Fields**

- `hour`: Local hour value for the reminder time.
- `minute`: Local minute value for the reminder time.
- `localizedDisplayText`: User-visible time text formatted for the active locale.
- `duplicateStatus`: Whether this time duplicates another selected time in the
  draft.
- `dailyLimitStatus`: Whether adding this time would exceed the four-time daily
  limit.

**Validation Rules**

- A time is unique by local hour and minute within the same medication schedule.
- Display text must be generated from locale-aware formatting rather than
  hard-coded English or Spanish strings.

## ReminderScheduleDraft

Represents in-progress schedule choices before save.

**Fields**

- `medication`: The selected saved medication.
- `selectedTimes`: Current ordered reminder times.
- `endDate`: Optional selected end date.
- `notificationPermissionStatus`: Current notification permission state.
- `validationState`: Validation messages for missing times, duplicate times,
  exceeding the daily limit, inactive medication, or invalid end date.
- `outcome`: `editing`, `cancelled`, or `saved`.

**Validation Rules**

- Validation failure must preserve valid selected times and optional end date.
- Cancel or leaving the flow creates or changes no saved schedule.
- Inactive medication validation must explain how to make the medication active
  without changing status inside the schedule flow.

## ScheduleReview

Represents the plain-language summary shown before saving.

**Fields**

- `medicationName`: User-entered medication name from the saved medication.
- `orderedReminderTimes`: Selected times in the order reminders will happen.
- `endDescription`: Either indefinite continuation text or the selected end date.
- `notificationMessage`: Whether reminder alerts can currently be delivered.
- `validationState`: Any blocking validation messages before save.

**Validation Rules**

- Summary must include the medication name, selected times, and end behavior.
- Summary must state when reminders cannot currently be delivered because of
  notification permission.
- Summary must remain readable with large text and screen-reader navigation.

## Relationships

- A `ReminderSchedule` belongs to one saved `Medication`.
- A medication has at most one v1 daily `ReminderSchedule`; editing replaces that
  schedule.
- A `ReminderScheduleDraft` becomes a `ReminderSchedule` only after validation
  and save.
- `NotificationPermissionStatus` influences delivery messaging and scheduling,
  but does not block local schedule persistence.

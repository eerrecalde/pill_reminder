# Data Model: Edit, Pause, Resume

## Medication

Represents a medication saved locally on the device.

Fields:
- `id`: Stable local identifier. Required and unique.
- `name`: User-visible medication name. Required, trimmed, localized only by
  user input.
- `dosageLabel`: Optional user-visible dosage label.
- `notes`: Optional local notes, if already supported by the medication model.
- `status`: `active`, `paused`, or existing inactive-compatible storage state.
  Paused means reminders are stopped until manual resume.
- `createdAt`: Local creation timestamp.
- `updatedAt`: Local last-updated timestamp.
- `pausedAt`: Local timestamp for the most recent pause, if paused.
- `resumedAt`: Local timestamp for the most recent manual resume, if resumed.

Relationships:
- Has zero or one saved `ReminderSchedule`.
- Has zero or more due-reminder records generated from its schedule.

Validation:
- Name remains required and must pass existing medication validation.
- Dosage label and notes preserve existing limits and valid values.
- Editing medication details must not mutate schedule times or end date.
- Paused medications remain editable and deletable.

State transitions:
- `active` -> `paused`: User confirms pause or taps pause action; future
  schedule notifications and pending due/later reminders are canceled.
- `paused` -> `active`: User resumes; future notifications are scheduled from
  the next applicable future time.
- `active|paused` -> deleted: User confirms medication deletion; medication,
  schedule, future notifications, pending due reminders, and later requests are
  removed.

## Reminder Schedule

Represents the daily reminder schedule for one medication.

Fields:
- `id`: Stable local identifier for the schedule.
- `medicationId`: Required link to `Medication.id`.
- `reminderTimes`: Sorted unique list of `ReminderTime`.
- `endDate`: Optional local date after which reminders stop.
- `notificationDeliveryState`: `deliverable`, `permissionNeeded`, `blocked`, or
  `unavailable`.
- `createdAt`: Local creation timestamp.
- `updatedAt`: Local last-updated timestamp.
- `deletedAt`: Not persisted for confirmed deletion in v1; confirmed deletion
  removes the schedule record.

Relationships:
- Belongs to exactly one medication.
- Produces future local notifications only while the medication is active and
  the schedule is present.

Validation:
- At least one reminder time is required when saving a schedule.
- Duplicate times are invalid.
- More than 4 daily reminder times is invalid.
- Optional end date must remain valid for the selected times.
- Existing valid selections must remain visible when validation fails.

State transitions:
- Saved -> edited: User reviews changed times/end date, then saves; old future
  notifications are canceled before or as part of saving the replacement.
- Saved -> paused-effective: Medication pause leaves the schedule stored but
  stops notifications.
- Saved -> deleted: User confirms schedule deletion; medication remains saved,
  schedule and associated future/pending reminder data are removed.

## Reminder Time

Represents one selected time of day.

Fields:
- `hour`: 0-23.
- `minute`: 0-59.
- `minutesSinceMidnight`: Derived sort and comparison value.
- `localizedDisplayText`: UI-only formatted text from locale/time settings.
- `validationStatus`: UI-only status for selected, duplicate, invalid, or over
  limit states.

Validation:
- Hour and minute must form a valid time of day.
- Duplicate hour/minute pairs are invalid.
- Times are normalized to sorted unique order when saved.

## Pause State

Represents temporary user-controlled stopping of all reminders for one
medication.

Fields:
- `medicationId`: Required link to medication.
- `isPaused`: Boolean derived from medication reminder status.
- `pausedAt`: Local timestamp when pause began.
- `resumedAt`: Local timestamp when manually resumed, if applicable.
- `statusLabelKey`: Localization key for the visible paused status.

Rules:
- Pause remains active until the user manually resumes or deletes the
  medication.
- Pause does not remove medication details or the saved schedule.
- Pause cancels pending schedule notifications, active due notifications, and
  remind-again-later notifications for that medication.
- Resume schedules only future notifications and does not backfill missed times.

## Due Reminder Cleanup Target

Represents reminder handling state affected by edit, pause, resume, and delete.

Fields:
- `medicationId`: Medication associated with due/later reminder state.
- `scheduleId`: Schedule that produced the due reminder, when available.
- `scheduledAt`: Original scheduled occurrence.
- `status`: Pending, taken, skipped, later requested, canceled, or equivalent
  existing state.
- `laterRequest`: Optional remind-again-later request and next reminder time.

Rules:
- Pause cancels pending due/later notifications for the medication.
- Schedule deletion cancels pending due/later notifications for that schedule.
- Medication deletion removes due/later state for that medication.
- Schedule edits cancel obsolete pending future occurrences without creating
  duplicates for the same medication and scheduled time.

## Deletion Confirmation

Represents the user-visible confirmation before destructive removal.

Fields:
- `itemType`: `schedule` or `medication`.
- `itemName`: Medication name and schedule summary where relevant.
- `consequenceTextKey`: Localization key describing what is removed.
- `remainingTextKey`: Localization key describing what remains.
- `finalWarningTextKey`: Localization key saying deletion is final after
  confirmation.
- `cancelActionKey`: Localization key for cancel action.
- `confirmActionKey`: Localization key for destructive confirm action.

Validation and accessibility:
- Confirmation must identify the medication by name.
- Schedule deletion confirmation must say the medication remains.
- Medication deletion confirmation must say medication and reminders are removed.
- Confirmation must be accessible by screen reader in title, summary,
  consequence, cancel, confirm order.
- Cancel leaves all saved data unchanged.

## Notification Permission Status

Represents whether local notifications can currently be delivered.

Values:
- `granted`: Future notifications can be scheduled.
- `skipped` or `denied`: The app can save changes, but delivery is deferred.
- `blocked`: User must change OS settings for delivery.
- `unavailable`: Device/platform cannot deliver notifications.

Rules:
- Permission state never blocks local edit, pause, resume, or delete changes.
- Permission explanations are user-visible when they affect future delivery.
- Saved delivery state is updated after schedule edit or resume attempts.

## Operation Result

Represents the outcome of a user action for UI feedback and tests.

Fields:
- `operation`: `editMedication`, `editSchedule`, `pause`, `resume`,
  `deleteSchedule`, or `deleteMedication`.
- `status`: `success`, `canceled`, `validationError`, or `permissionLimited`.
- `messageKey`: Localization key for success/error/status copy.
- `affectedMedicationId`: Medication id.
- `affectedScheduleId`: Optional schedule id.

Rules:
- Success messages are calm, plain language, and do not rely on color alone.
- Validation errors preserve valid choices.
- Canceled operations do not mutate saved data or notification state.

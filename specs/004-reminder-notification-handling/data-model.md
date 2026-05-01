# Data Model: Reminder Notification Handling

## DueReminder

Represents one locally tracked reminder occurrence for one medication at one
scheduled time.

**Fields**

- `id`: Stable local identifier derived from medication id and scheduled
  occurrence time.
- `medicationId`: Local identifier of the associated saved medication.
- `scheduleId`: Local identifier of the schedule that produced the reminder.
- `scheduledAt`: Local date and time when the medication reminder was originally
  due.
- `medicationName`: Medication name used for notification and in-app display.
- `dosageLabel`: Optional dosage label used for display when available.
- `state`: Current reminder state: `unresolved`, `taken`, `skipped`, or
  `remindAgainLater`.
- `createdAt`: Local timestamp when the due reminder was first recorded.
- `updatedAt`: Local timestamp when the due reminder last changed.
- `resolvedAt`: Local timestamp for taken or skipped outcomes; empty while
  unresolved or pending remind-again-later.
- `lastActionSource`: Whether the latest state change came from notification
  action, in-app action, or reconciliation.

**Validation Rules**

- `id` must be unique for the medication and scheduled occurrence time.
- A due reminder may have only one final state: `taken` or `skipped`.
- Once a due reminder is `taken`, it cannot later become `skipped`.
- Once a due reminder is `skipped`, it cannot later become `taken`.
- Repeated attempts to apply the same final outcome must keep one final state
  rather than creating a duplicate reminder.
- Missing dosage label must be represented as absent/empty and omitted from
  display copy.
- Due reminder data must remain local and must not include clinical advice,
  adherence scoring, caregiver sharing, account identifiers, or remote sync data.
- Due reminders associated with a deleted medication or removed reminder schedule
  must be deleted with their outcomes and pending remind-again-later requests.

**State Transitions**

1. No due reminder -> scheduled time reached or reconciled -> `unresolved`.
2. `unresolved` -> user marks taken -> `taken`.
3. `unresolved` -> user skips -> `skipped`.
4. `unresolved` -> user chooses remind again later -> `remindAgainLater`.
5. `remindAgainLater` -> later reminder becomes due -> `unresolved`.
6. `remindAgainLater` -> user marks taken -> `taken`.
7. `remindAgainLater` -> user skips -> `skipped`.
8. `taken` or `skipped` -> duplicate/stale action -> unchanged final state.

## ReminderOutcome

Represents the user's final response to a due reminder.

**Fields**

- `dueReminderId`: Associated due reminder id.
- `outcomeType`: `taken` or `skipped`.
- `actionTime`: Local timestamp when the user acted.
- `actionSource`: `notification` or `inApp`.

**Validation Rules**

- One due reminder can have at most one final outcome.
- Outcome action time must be recorded locally.
- Outcome history is local and must not be used for clinical advice or adherence
  scoring in this feature.

## RemindAgainLaterRequest

Represents a pending request to remind the user again for the same due reminder.

**Fields**

- `dueReminderId`: Associated due reminder id.
- `intervalMinutes`: App-wide configured interval used for this request.
- `requestedAt`: Local timestamp when the user chose remind again later.
- `nextReminderAt`: Local timestamp when the later reminder should be shown.
- `state`: `pending`, `returnedToUnresolved`, or `cancelledByFinalOutcome`.

**Validation Rules**

- Default `intervalMinutes` is 10 when the user has not changed the app-wide
  setting.
- Only one pending remind-again-later request may exist for a due reminder.
- Repeated remind-again-later actions replace or update the existing pending
  request rather than creating overlapping later reminders.
- A final taken or skipped outcome cancels any pending remind-again-later request
  for the same due reminder.
- Pending remind-again-later requests are deleted when their associated due
  reminder is deleted.

## ReminderHandlingPreferences

Represents app-wide reminder handling settings.

**Fields**

- `remindAgainLaterIntervalMinutes`: User-configurable app-wide interval for
  remind-again-later actions. Default is 10.
- `updatedAt`: Local timestamp when preferences last changed.

**Validation Rules**

- The interval must be expressed in whole minutes.
- The preference applies to all medications and schedules.
- Changing the preference affects future remind-again-later actions, not already
  completed taken or skipped outcomes.

## NotificationActionRequest

Represents an action received from a local notification.

**Fields**

- `dueReminderId`: Due reminder targeted by the notification action.
- `actionType`: `taken`, `skipped`, or `remindAgainLater`.
- `receivedAt`: Local timestamp when the app handled the action.

**Validation Rules**

- If the targeted due reminder no longer exists or is already final, the action
  must not create a contradictory new reminder.
- Notification action results must reconcile with the in-app reminder view.

## NotificationPermissionStatus

Represents whether local reminder notifications can currently be delivered.

**Fields**

- `status`: `granted`, `skipped`, `denied`, `blocked`, or `unavailable`.
- `checkedAt`: Local timestamp when the status was last evaluated.

**Validation Rules**

- Permission status affects notification delivery but does not block local due
  reminder state creation or in-app handling.
- When permission becomes available, future reminder delivery resumes without
  duplicating existing due reminder states.
- Operating-system permission revocation must be mapped to `denied` or `blocked`
  based on the platform-reported state; no separate stored `revoked` state is
  introduced.

## Relationships

- A `DueReminder` belongs to one saved active `Medication` and one
  `ReminderSchedule`.
- A `DueReminder` has zero or one final `ReminderOutcome`.
- A `DueReminder` has zero or one pending `RemindAgainLaterRequest`.
- Deleting a `Medication` or removing a `ReminderSchedule` deletes associated
  due reminders, outcomes, and pending remind-again-later requests.
- `ReminderHandlingPreferences` are app-wide and apply to all medications.
- `NotificationActionRequest` updates a `DueReminder` through the same action
  rules used by in-app actions.

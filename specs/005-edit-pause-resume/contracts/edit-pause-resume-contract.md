# Contract: Edit, Pause, Resume

## Scope

This contract defines expected behavior for the medication edit, schedule edit,
pause, resume, schedule deletion, and medication deletion flows. It covers UI
state, repository operations, notification side effects, accessibility,
localization, and verification boundaries for a local-first Flutter app.

## UI Flow Contract

### Medication Detail Edit

Preconditions:
- A saved medication exists.

Required behavior:
- Edit controls are discoverable from the medication list or medication detail
  context.
- The form opens with current medication name, dosage label, and supported
  editable fields prefilled.
- Saving validates medication details with existing validation rules.
- Saving medication details preserves any saved schedule unless the user enters
  the schedule edit flow.
- Canceling or leaving before save does not change medication, schedule, due
  reminder, or notification state.
- Success copy confirms the medication details were updated.

### Reminder Schedule Edit

Preconditions:
- A saved medication exists and has a saved schedule.

Required behavior:
- The schedule edit flow opens with existing reminder times and end date
  preselected.
- Users can add, change, and remove reminder times within the supported daily
  reminder limit.
- Invalid schedules with no times, duplicate times, too many times, or invalid
  end date are blocked with plain-language guidance.
- Valid choices remain selected when validation fails.
- A review step summarizes updated reminder times and continuation/end-date
  behavior before save.
- On save, obsolete future notifications are canceled or replaced and only the
  updated future schedule remains active.

### Pause and Resume

Preconditions:
- A saved medication exists. A schedule may or may not exist.

Required behavior:
- Pause applies to the medication and all reminders for that medication.
- Paused state is visible anywhere reminder status is shown and does not rely on
  color alone.
- Pause remains active until manual resume.
- Pause cancels future schedule notifications and pending due/remind-again-later
  notifications for the medication.
- Resume schedules future reminders from the next applicable future time when a
  schedule exists and permission allows.
- Resume does not backfill reminders for times that passed while paused.

### Delete Schedule

Preconditions:
- A saved medication exists with a saved schedule.

Required behavior:
- Confirmation states the schedule/reminder times will be removed and the
  medication will remain.
- Confirmation states deletion is final after confirmation.
- Canceling leaves the schedule and all reminder state unchanged.
- Confirming removes the schedule, future schedule notifications, pending due
  reminders, and pending remind-again-later notifications for that schedule.
- The medication remains saved and editable without reminder times.

### Delete Medication

Preconditions:
- A saved medication exists.

Required behavior:
- Confirmation states the medication and associated reminders will be removed.
- Confirmation states deletion is final after confirmation.
- Canceling leaves the medication, schedule, and reminder state unchanged.
- Confirming removes the medication, associated schedule, future notifications,
  pending due reminders, and pending remind-again-later notifications.
- No undo, archive, trash, or restore behavior is provided in v1.

## Repository Contract

Medication repository must support:
- Loading saved medications.
- Updating an existing medication without changing its stable id or created
  timestamp.
- Persisting medication reminder status (`active` or `paused`) and pause/resume
  timestamps or equivalent local state.
- Deleting a medication by id.

Reminder schedule repository must support:
- Loading a schedule by medication id.
- Replacing the schedule for a medication with sorted valid reminder times.
- Deleting a schedule for a medication.
- Preserving existing schedule id/created timestamp when editing the same
  medication schedule where practical.

Due reminder repository/reconciler must support:
- Finding pending due and remind-again-later records by medication id and, where
  needed, schedule id.
- Canceling/removing pending due/later state when a medication is paused,
  schedule is deleted, or medication is deleted.
- Avoiding creation of due reminders for paused or deleted medications.

All repository operations must be local, offline-capable, deterministic, and
survive app restart.

## Notification Scheduler Contract

Schedule edit:
- Cancel notifications for the previous saved schedule times before or during
  replacement.
- Schedule notifications for the updated saved schedule only when the medication
  is active and permission allows.
- Use stable notification ids that avoid duplicates for the same medication and
  reminder time.

Medication detail edit:
- Future notification title/body use updated medication details.
- Existing scheduled notifications are refreshed if their payload/title/body
  would otherwise retain stale medication details.

Pause:
- Cancel all future schedule notifications for the medication schedule.
- Cancel active due notifications and later notifications for the medication.

Resume:
- Schedule only future occurrences from the saved schedule.
- Do not create notifications for missed times while paused.

Delete:
- Schedule deletion cancels schedule, due, and later notifications tied to the
  medication schedule.
- Medication deletion cancels all schedule, due, and later notifications tied to
  the medication.

Permission:
- `granted` schedules notifications normally.
- `skipped`, `denied`, `blocked`, or `unavailable` still allow local saves and
  update visible delivery-state messaging.

## Accessibility Contract

All edit, pause, resume, delete, confirmation, error, and status states must:
- Preserve readable layouts with large text enabled.
- Use 48px minimum touch targets, with 56px preferred for primary actions.
- Provide visible focus states.
- Use logical focus and screen reader order.
- Announce medication name, schedule summary, action meaning, and consequences.
- Communicate paused, error, permission, and destructive states without relying
  only on color.
- Avoid hidden gestures and time-limited decisions.
- Keep cancel/secondary choices clear and pressure-free.

## Localization Contract

All user-visible strings must be provided through `lib/l10n/*.arb`, including:
- Edit medication labels, validation errors, cancel, save, and success states.
- Edit schedule labels, reminder-time summaries, review copy, validation
  errors, cancel, save, and success states.
- Pause and resume labels, status labels, confirmations, and success states.
- Delete schedule and delete medication confirmation copy.
- Permission-limited explanations after edit or resume.
- Notification title/body text affected by medication details.

Dates and times must use locale-aware formatting through the existing Flutter
localization/`intl` setup. English and Latin American Spanish must both be
available for review.

## Testing Contract

Automated tests must cover:
- Medication detail edit preserves schedule and updates future reminder text.
- Medication edit cancel leaves data unchanged.
- Schedule edit preselects current times and blocks invalid schedules.
- Schedule edit cancels old notifications and schedules only updated times.
- Pause cancels future schedule notifications and pending due/later reminders.
- Resume schedules from next future time without backfill duplicates.
- Delete schedule keeps medication and removes schedule/reminder state.
- Delete medication removes medication, schedule, due/later state, and
  notifications.
- Canceling deletion leaves data unchanged.
- Offline local persistence after app restart.
- Permission denied/blocked/unavailable messaging.
- Large text and screen reader semantics for confirmations and errors.
- English and Latin American Spanish localization coverage.

Manual verification must cover:
- iOS and Android platform notification replacement after schedule edit.
- iOS and Android cancellation after pause, schedule delete, and medication
  delete.
- Notification permission changes made outside the app.

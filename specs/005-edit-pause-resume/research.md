# Research: Edit, Pause, Resume

## Medication Editing Approach

Decision: Reuse the existing medication domain, validation, repository, and
presentation patterns to support editing existing medication records in place.
Medication detail edits update the saved medication name, dosage label, notes,
and `updatedAt` while preserving the existing schedule unless the user opens the
schedule edit flow.

Rationale: The app already stores medications locally through repository
interfaces and displays medication data throughout lists, schedules, due
reminders, and notifications. Updating the record in place keeps references
stable, avoids duplicate schedules, and ensures future reminders read the latest
medication details.

Alternatives considered: Creating a new medication and migrating the schedule
was rejected because it risks duplicate notifications and stale due reminders.
Adding a separate remote edit service was rejected because v1 is local-first and
account-free.

## Schedule Edit and Notification Replacement

Decision: Treat schedule edits as a replace operation for one medication:
validate the draft, cancel notifications for the previous saved schedule, save
the new normalized schedule, schedule future notifications for the new times
when permission allows, and persist the resulting delivery state.

Rationale: The existing `ReminderScheduleValidation.maxDailyTimes` limit,
repository, and scheduler already model one daily schedule per medication. A
replace flow makes old/new notification behavior deterministic and directly
addresses the duplicate-notification requirement.

Alternatives considered: Incrementally adding/removing only changed times was
rejected because it is more complex around end dates, permission states, and
near-due reminders. Letting startup reconciliation clean up old schedules was
rejected because users could receive stale notifications before reconciliation.

## Pause and Resume Semantics

Decision: Store pause as medication-level reminder state that remains active
until manual resume. Pausing cancels future schedule notifications and pending
due/remind-again-later notifications for that medication while preserving the
medication and saved schedule. Resuming schedules from the next future reminder
time without backfilling missed reminders.

Rationale: The clarified spec says pause applies to the medication and remains
active until the user resumes. Medication-level state is simplest for older
adults, matches the visible medication status, and avoids adding date/time
configuration.

Alternatives considered: Pausing individual reminder times was rejected because
it creates too many choices and a harder resume path. Automatic resume dates
were rejected because they are explicitly out of scope for v1.

## Delete Medication vs. Delete Schedule

Decision: Keep two distinct destructive flows. Deleting a schedule removes the
schedule and associated future/due/later reminder data while keeping the
medication. Deleting a medication removes the medication, schedule, due
reminders, remind-again-later requests, and future notifications. Both require a
localized confirmation that states consequences and that deletion is final.

Rationale: The spec requires users to understand what remains and what is
removed. Separate flows prevent accidental medication loss when the user only
wants to stop reminders.

Alternatives considered: A single delete action with a later choice was rejected
because it overloads one destructive flow. Undo/archive/trash was rejected
because confirmed deletion is final in v1.

## Due Reminder and Remind-Again-Later Cleanup

Decision: Extend existing due-reminder repository/reconciler behavior so pause,
schedule delete, and medication delete remove or cancel pending due reminders
and remind-again-later requests for the affected medication. Schedule edits close
or cancel due/later state only for obsolete future occurrences while preserving
already recorded outcomes.

Rationale: Reminder handling from feature 004 added due state and later
notifications. Edit/pause/delete must include those records or stale alerts can
appear even after the repeating schedule has been canceled.

Alternatives considered: Cleaning only repeating schedule notifications was
rejected because it leaves pending due/later notifications active. Deleting all
historical outcomes was rejected except when the medication itself is deleted,
because this feature changes future reminder behavior, not completed history.

## Permission and Offline Behavior

Decision: Save edit, pause, resume, and delete outcomes locally regardless of
notification permission or connectivity. Permission messaging updates the saved
delivery state and visible explanation when notifications are denied, blocked,
skipped, or unavailable.

Rationale: The app is offline-first and permission may change outside the app.
Local state must remain authoritative even when notifications cannot be shown.

Alternatives considered: Blocking edits until notification permission is granted
was rejected because it would prevent local correction and conflict with the
spec. Remote backup/sync was rejected because privacy and account-free use are
core constraints.

## UX, Accessibility, and Localization

Decision: Use existing Material components and `docs/ux-design.md` as the UX
baseline: sentence-case copy, large readable text, 48px minimum touch targets
with 56px preferred actions, calm confirmations, visible focus, logical reading
order, non-color-only status, and localization through ARB resources for English
and Latin American Spanish.

Rationale: The feature changes reminder behavior for older adults, so recovery
from mistakes and comprehension of destructive actions are release-critical.
Localization-ready copy and date/time formatting prevent hard-coded strings in
business logic.

Alternatives considered: Relying only on icon/color status was rejected for
accessibility. Hard-coded English confirmation strings were rejected because
the product already supports English and Latin American Spanish.

## Performance and Battery Behavior

Decision: Perform notification cancellation/replacement only when the user saves
or confirms an action, and use startup reconciliation only for consistency
checks. Do not add polling, continuous background processing, or new packages.

Rationale: Local schedules are small in v1, and existing platform notification
APIs can update pending notifications on demand. Avoiding background work
protects startup time and battery.

Alternatives considered: Periodic background cleanup was rejected because it
adds platform complexity and battery risk without improving the primary edit
flow. A new scheduling package was rejected because existing dependencies
already support the needed operations.

# Contract: Reminder Notification Handling

This contract defines user-visible states, repository behavior, notification
action behavior, and reconciliation behavior for due medication reminders. It is
a UI/state contract for the Flutter app, not a network API.

## Entry Conditions

- The app has saved medications and saved active daily reminder schedules.
- The experience works offline and without an account.
- A due reminder can be reached from a local notification or from inside the app.
- If notification permission is denied, blocked, revoked, or unavailable, the
  app still creates and shows local due reminder state when opened.

## Notification Content

- Notification title/body must identify the medication name and scheduled time.
- Dosage label appears when available.
- Missing dosage label is omitted without blank placeholders.
- Notification copy is localization-ready for English and Latin American Spanish.
- Notification data remains local to the device and is not sent to remote
  services.

## Reminder Actions

**Taken**

- Available from the notification when supported by the device and from the
  in-app due reminder view.
- Records a final `taken` outcome with local action time.
- Clears unresolved/pending status for that due reminder.
- Cancels any pending remind-again-later request for the same due reminder.

**Skip**

- Available from the notification when supported by the device and from the
  in-app due reminder view.
- Records a final `skipped` outcome with local action time.
- Clears unresolved/pending status for that due reminder.
- Cancels any pending remind-again-later request for the same due reminder.

**Remind Again Later**

- Available from the notification when supported by the device and from the
  in-app due reminder view.
- Uses one app-wide configurable interval.
- Defaults to 10 minutes when the user has not changed the setting.
- Keeps the due reminder pending until it returns to unresolved or is finalized.
- Prevents overlapping later reminders for the same due reminder.

## In-App Reminder View

- Shows medication name, scheduled time, dosage label when available, and current
  state in plain language.
- Provides taken, skip, and remind-again-later actions with large touch targets.
- Uses calm, non-blaming copy for unresolved or disabled-notification states.
- Shows one current state for each due reminder: unresolved, taken, skipped, or
  remind-again-later.
- Uses text and screen-reader announcements for state, not color alone.

## Idempotency and Conflict Rules

- A due reminder is unique by medication and scheduled occurrence time.
- Repeated creation attempts for the same medication and scheduled occurrence
  return or update the same due reminder.
- A due reminder cannot be both taken and skipped.
- Stale notification actions after a final outcome must leave the final outcome
  unchanged.
- Repeated remind-again-later actions must update or replace one pending request
  rather than scheduling overlapping reminders.
- Notification actions and in-app actions must use the same state transition
  rules.

## Offline, Restart, and Permission Recovery

- All due reminder states and outcomes persist locally.
- App startup or foreground reconciliation checks saved active schedules and
  creates missing due reminders for elapsed scheduled times without duplicates.
- Device offline state does not block reminder state creation or user actions.
- App or device restart preserves unresolved, taken, skipped, and
  remind-again-later states.
- If notification permission becomes available later, future local notification
  delivery resumes without recreating already due reminder states.

## Repository Contract

- `DueReminderRepository` provides local load, upsert, and update operations for
  due reminder records.
- Repository operations must support lookup by medication id and scheduled
  occurrence time.
- Repository implementation stores due reminder data locally as JSON.
- Repository interface must not expose UI widget types, account concepts,
  analytics concepts, or remote-service identifiers.

## Preference Contract

- Reminder handling preferences provide one app-wide
  `remindAgainLaterIntervalMinutes` value.
- Default value is 10.
- Preference persistence is local and account-free.
- Preference changes affect future remind-again-later requests.

## Notification Scheduler and Action Contract

- The notification scheduler can schedule the original due notification and a
  later reminder notification for a pending remind-again-later request.
- Notification payload/action data must contain enough local identity to resolve
  the target due reminder without remote lookup.
- Notification action handling must route through the shared reminder action
  handler used by the in-app view.
- Scheduler reports delivery as scheduled, deferred for permission, blocked, or
  unavailable.

## Accessibility and Localization

- Actions use clear labels and logical reading order.
- Touch targets are at least 48px with 56px preferred primary actions.
- Screen readers announce medication name, dosage label if present, scheduled
  time, current state, and available actions.
- Large text must not clip medication details or actions.
- Notification and in-app copy, status text, dates, and times must be ready for
  English and Latin American Spanish.
- Layout and tone follow `docs/ux-design.md`.

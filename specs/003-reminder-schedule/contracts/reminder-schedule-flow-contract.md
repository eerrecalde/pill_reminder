# Contract: Reminder Schedule Flow

This contract defines user-visible states, repository behavior, and notification
scheduling behavior for medication reminder schedules. It is a UI/state contract
for the Flutter app, not a network API.

## Entry Conditions

- The flow is reachable from a saved active medication.
- The flow is available offline and without an account.
- If the selected medication is inactive, the flow explains that reminders can
  only be scheduled for active medications and directs the user to make the
  medication active outside the schedule flow.
- Existing saved schedule, if present, is loaded locally for editing.

## Schedule Inputs

**Reminder Times**

- Required.
- Minimum one time and maximum four times per medication per day.
- Duplicate times are not allowed for the same medication schedule.
- Times are reviewed in the order reminders will happen.
- Adding a fifth time is blocked with plain-language guidance and preserves
  existing selections.

**Optional End Date**

- Optional.
- Empty means the daily reminders continue indefinitely until edited or removed.
- When present, the end date is shown in the review summary.
- An end date earlier than the first possible reminder blocks saving with a
  plain-language validation message.

## Review Behavior

- Review appears before save.
- Review includes medication name, all selected reminder times, indefinite or end
  date behavior, and notification delivery state.
- Review copy avoids technical recurrence language.
- Review remains usable with large text, screen readers, high contrast, and
  large touch targets.

## Save Behavior

- Valid schedules save a local schedule record with a stable local id, associated
  medication id, selected times, optional end date, created date, and updated
  date.
- Saving works offline and without account creation or sign-in.
- Save preserves the selected schedule after app restart.
- Cancel or leaving the flow creates or changes no saved schedule.
- Editing an existing v1 schedule replaces the medication's saved schedule.

## Notification Permission Behavior

- Granted notification permission means saved schedules are deliverable.
- Skipped, denied, blocked, or unavailable notification states do not block local
  schedule saving.
- When reminders cannot currently be delivered, the flow explains that the
  schedule is saved but alerts require notification permission.
- A saved schedule becomes deliverable automatically after notification
  permission is enabled later.
- Blocked or unavailable states provide calm recovery guidance without red
  warning styling or blame.

## Accessibility and Localization

- All controls have descriptive labels and logical reading order.
- Validation, selection, delivery state, and inactive-medication messages use
  text and semantics, not color alone.
- Primary actions use 56px preferred touch targets and visible focus states.
- Layout follows `docs/ux-design.md` spacing, calm tone, and pressure-free
  choices.
- Time and date display use localization-ready formatting for English and Latin
  American Spanish.

## Repository Contract

- `ReminderScheduleRepository` provides local load/save/delete operations for
  reminder schedule records by medication id.
- Repository implementation stores v1 schedule data locally as JSON.
- Repository interface must not expose UI types or require Firebase/account
  concepts.
- Future Firebase implementation may add remote identifiers internally without
  changing the schedule UI contract.

## Notification Scheduler Contract

- `ReminderNotificationScheduler` schedules, updates, and cancels local
  notifications for saved schedules.
- Scheduler accepts domain schedule data and localized notification text, not UI
  widget state.
- Scheduler reports whether notification delivery was scheduled, deferred for
  permission, blocked, or unavailable.
- Scheduler can re-evaluate saved schedules after notification permission changes
  so deliverable schedules do not need to be recreated.

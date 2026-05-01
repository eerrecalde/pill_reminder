# Research: Medication History

## Dedicated Local History Repository

**Decision**: Add a `MedicationHistoryRepository` with a SharedPreferences-backed `LocalMedicationHistoryRepository` to store normalized history records for scheduled reminder occurrences.

**Rationale**: Existing local stores are split by purpose. `DailyReminderHandling` only captures dashboard handled actions, while `DueReminder` captures notification/in-app taken, skipped, and snooze state for due reminders. A small history repository gives the history view a stable rolling 90-day source, preserves medication name and dosage snapshots, and keeps the model independent from future schedule or medication edits.

**Alternatives considered**: Derive all history only from current schedules and due reminders. Rejected because deleted or edited medications could lose context, and dashboard handled actions do not distinguish every required status. Add SQLite or another database. Rejected because current app storage is SharedPreferences and the 90-day scope is small enough for the existing local pattern.

## One Entry Per Scheduled Occurrence

**Decision**: Use a stable occurrence id based on local scheduled date, schedule id, medication id, and reminder time, then upsert history by that id.

**Rationale**: This matches the existing daily handling id shape and prevents duplicate rows when a snoozed reminder later becomes taken, skipped, or missed. It also keeps comparison by medication and time straightforward for each day.

**Alternatives considered**: Store every action as a separate timeline event. Rejected because the spec asks for easy scanning and explicitly warns against duplicate confusing snooze rows. Store only final outcomes. Rejected because currently snoozed reminders still need a user-visible status when no final outcome has happened.

## Status Precedence

**Decision**: Show final statuses `taken`, `skipped`, or `missed` ahead of snooze activity. Show `snoozed` only while snooze is the most understandable current outcome for that scheduled occurrence.

**Rationale**: The history should answer what happened to the scheduled reminder. A later taken or skipped action is clearer than preserving a prior snooze as a separate visible row.

**Alternatives considered**: Show both snoozed and final outcome. Rejected for scanability. Hide snooze history entirely. Rejected because snoozed is a required supported status.

## Missed Boundary

**Decision**: Mark an unhandled scheduled reminder as missed once `now` is more than 60 minutes after the scheduled local date/time.

**Rationale**: The spec explicitly aligns history with the current-day reminder experience, and `TodayDashboardService` already uses this boundary. The history service should reuse the same rule to avoid disagreement between today and history.

**Alternatives considered**: Mark missed immediately at scheduled time or at day end. Rejected because either would conflict with the clarified 60-minute rule and current dashboard behavior.

## Localization and Date Formatting

**Decision**: Use Flutter generated l10n strings for labels and empty states, and `intl` date/time formatting using the active locale for day headings and scheduled times.

**Rationale**: The app already uses generated `AppLocalizations` and ARB files for English and Spanish variants. Keeping labels out of business logic satisfies localization readiness and makes Latin American Spanish review possible.

**Alternatives considered**: Hard-code English strings in widgets or domain models. Rejected by the constitution and spec. Store localized labels in history records. Rejected because labels should render in the user's current language.

## Accessibility Presentation

**Decision**: Build rows with visible text status labels plus distinct icons/shapes, semantic labels that include day, medication, time, and status, and layouts that wrap long medication/dosage text before clipping status information.

**Rationale**: The primary users include older adults and caregivers, and the spec requires large text, screen readers, high contrast, and non-color-only indicators. Text-first labels avoid color dependence and keep the tone calm.

**Alternatives considered**: Use color-coded badges only. Rejected because color-only communication fails the accessibility requirement. Use a dense table. Rejected because it is brittle under large text and screen readers.

## Performance and Retention

**Decision**: Query and retain reviewable history for a rolling 90-day window, prune older records during history writes or explicit repository maintenance, and sort/group in memory.

**Rationale**: The scope is bounded and local; in-memory grouping is simple and testable. Pruning keeps storage size predictable without background polling.

**Alternatives considered**: Keep unlimited local history. Rejected because the requirement limits reviewable history to 90 days. Add scheduled background cleanup. Rejected because it adds battery and platform complexity without user value for v1.

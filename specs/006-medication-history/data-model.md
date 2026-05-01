# Data Model: Medication History

## MedicationHistoryEntry

Local record for one scheduled medication reminder occurrence.

**Fields**

- `id`: Stable occurrence id, built from local date, schedule id, medication id, and reminder time.
- `localDate`: Local calendar day for grouping.
- `scheduledAt`: Local scheduled date/time.
- `scheduleId`: Schedule id captured when the occurrence was created.
- `medicationId`: Medication id when available.
- `medicationName`: Medication display name captured at occurrence/outcome time.
- `dosageLabel`: Optional dosage label captured at occurrence/outcome time.
- `status`: `taken`, `skipped`, `missed`, or `snoozed`.
- `statusUpdatedAt`: Time the status became known.
- `snoozeCount`: Optional count of snooze requests summarized for the occurrence.
- `lastSnoozedAt`: Optional latest snooze request time.
- `nextReminderAt`: Optional next reminder time while snoozed.
- `source`: `todayDashboard`, `dueReminder`, or `reconciliation`.
- `createdAt`: Local creation timestamp.
- `updatedAt`: Local update timestamp.

**Validation**

- `id`, `localDate`, `scheduledAt`, `scheduleId`, `medicationName`, `status`, `createdAt`, and `updatedAt` are required.
- `medicationName` must be trimmed and non-empty for user-visible rows; if legacy data is incomplete, use localized fallback copy at presentation time rather than storing translated text.
- `dosageLabel` is trimmed and optional.
- `statusUpdatedAt` is required for `taken`, `skipped`, and `snoozed`; for computed `missed`, it may be the time the repository/service first records the missed state.
- Entries older than the rolling 90-day window are not shown and should be pruned from retained reviewable history.

**State Transitions**

- Scheduled occurrence with no action -> `missed` after more than 60 minutes past scheduled time.
- Scheduled occurrence -> `snoozed` when the user chooses remind again later.
- `snoozed` -> `taken` when the user marks the same occurrence taken.
- `snoozed` -> `skipped` when the user skips the same occurrence.
- `snoozed` -> `missed` when the snoozed reminder remains unresolved past the existing missed boundary.
- `taken`, `skipped`, and `missed` are final for v1 history display.

## MedicationHistoryDayGroup

User-facing grouping for one local calendar day.

**Fields**

- `localDate`: Date represented by the group.
- `entries`: Medication history entries for that day.

**Ordering**

- Day groups sort newest first.
- Entries within a day sort by scheduled time ascending, then medication name ascending.

## ReminderOutcomeStatus

User-visible status enum.

**Values**

- `taken`: Calm label such as "Taken"; final.
- `skipped`: Calm label such as "Skipped"; final.
- `missed`: Calm label such as "Missed"; final, not alarming or advisory.
- `snoozed`: Calm label such as "Snoozed"; non-final unless superseded by a final outcome.

**Presentation Rules**

- Labels are localized at render time.
- Every status uses text plus a non-color-only cue such as a Material icon and badge shape.
- Screen reader text includes status meaning in the same logical order as visible content.

## MedicationReferenceSnapshot

Medication details preserved for understandable older history.

**Fields**

- `medicationId`: Optional link to current medication when still present.
- `medicationName`: Captured display name.
- `dosageLabel`: Optional captured dosage label.

**Rules**

- Editing, pausing, resuming, or deleting the medication later must not rewrite historical display text.
- History rows do not expose controls for deleted medications.

## MedicationHistoryRepository

Persistence contract for local history.

**Operations**

- `loadEntries(since, until)`: Returns locally stored entries within the requested date range.
- `upsertEntry(entry)`: Creates or updates one occurrence by stable id.
- `pruneBefore(cutoffDate)`: Removes entries outside the rolling review window.

**Storage**

- SharedPreferences string-list JSON, versioned key such as `medications.history.v1`.
- JSON stores raw enum names and ISO timestamps, not localized labels.

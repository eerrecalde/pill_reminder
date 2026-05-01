# Contract: Medication History UI

## Navigation

- The main reminder experience exposes a clearly labeled history action from `TodayDashboardScreen` or the app bar area.
- Activating the action pushes `MedicationHistoryScreen`.
- The screen has standard back navigation and does not require account, network, sync, export, or setup.

## Screen Inputs

`MedicationHistoryScreen` receives:

- `MedicationHistoryRepository`
- Existing medication, schedule, daily handling, and due reminder repositories as needed by `MedicationHistoryService`
- Optional clock for deterministic tests

## Screen States

### Loading

- Shows a small progress indicator without blocking navigation.
- Does not announce clinical or alarming language.

### Empty

- Shows localized calm copy explaining that recent reminder activity will appear after reminders occur.
- Provides no scolding, adherence score, medical advice, sign-in, sync, sharing, or export prompt.

### Populated

- Shows day sections newest first for the rolling 90-day window.
- Each entry displays medication name, optional dosage label, scheduled time, and localized status.
- Entries within a day are ordered by scheduled time, then medication name.

### Error Recovery

- If local data cannot be parsed, invalid records are ignored where possible and the screen still renders valid history.
- If no valid history remains, use the empty state.

## Entry Semantics

Each row exposes one screen-reader label in this order:

1. Localized day heading or date
2. Medication name
3. Dosage label when present
4. Localized scheduled time
5. Localized status

Rows are informational only in v1 and do not edit past outcomes.

## Status Indicator Contract

- `taken`, `skipped`, `missed`, and `snoozed` each have localized text.
- Each status has a distinct icon or shape in addition to color.
- Color is secondary and must meet contrast requirements in the current theme.
- Status wording stays calm and non-judgmental.

## Layout and Accessibility

- Layout follows `docs/ux-design.md`: readable text, generous spacing, calm tone, no hidden gestures, and large touch targets for navigation.
- Text wraps under large text settings; medication names and dosage labels do not hide scheduled time or status.
- Day headings, row content, and back/history actions have logical focus order.
- The view remains usable with screen readers, large text, high contrast, and color vision differences.

## Localization

- User-visible strings are added to `app_en.arb`, `app_es.arb`, and `app_es_419.arb`.
- Date and time rendering uses the active locale via Flutter localization/`intl`, not hard-coded string formats.
- Domain models store stable enum values and timestamps only.

## Privacy

- No data leaves the device.
- The screen does not include account creation, remote sync, analytics, export, backup, sharing, caregiver invitation, or recommendation surfaces.

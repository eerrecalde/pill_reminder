# Quickstart: Medication History

## Implementation Path

1. Add `MedicationHistoryEntry`, `MedicationHistoryStatus`, day grouping, and repository interfaces under `lib/features/medications/domain` and `data`.
2. Implement `LocalMedicationHistoryRepository` with versioned SharedPreferences JSON storage and 90-day pruning.
3. Update reminder action and reconciliation paths so taken, skipped, snoozed, and missed outcomes upsert one history entry per scheduled occurrence with captured medication name and dosage label.
4. Add `MedicationHistoryService` to load the rolling 90-day window, normalize status precedence, and return newest-first day groups.
5. Build `MedicationHistoryScreen` and supporting row/status widgets using existing theme patterns, localized labels, and non-color-only indicators.
6. Add a history navigation action from the current reminder dashboard/app bar area and wire repositories through `main.dart`.
7. Add English and Latin American Spanish l10n entries for navigation, title, empty state, labels, and statuses.

## Verification

Run:

```bash
flutter gen-l10n
dart format lib test
flutter test
flutter analyze
```

Manual checks:

- Create scheduled medication activity across several days and confirm history groups newest day first.
- Mark reminders taken, skipped, snoozed, and missed; confirm each status appears once per scheduled occurrence.
- Snooze a reminder, then mark it taken or skipped; confirm the final status replaces the snoozed display row.
- Edit, pause, resume, and delete a medication after a recorded outcome; confirm history still shows the captured medication name and dosage label.
- Turn off network access; confirm history remains available with no account or sign-in prompt.
- Switch English and Spanish locales; confirm dates, times, labels, empty state, and statuses are localized.
- Enable large text and a screen reader; confirm rows do not clip or overlap, status does not rely only on color, and semantics announce day, medication, time, and status in order.

## Performance Check

- Seed at least 90 days of typical reminder entries and confirm the history screen opens and renders responsively.
- Verify no new polling, background cleanup loop, remote call, analytics call, or startup-heavy history work was added.

## Manual Verification Notes

- Open the app after setup and use the history icon in the Today app bar. Confirm the screen opens with normal back navigation and no account, sign-in, sync, export, backup, sharing, or analytics prompt.
- With no recorded activity, confirm the empty state says recent activity will appear after reminders are recorded and does not scold or provide medical advice.
- Record one taken item from Today, one skipped due reminder, one snoozed due reminder, and one missed reminder after the 60-minute boundary. Confirm each scheduled occurrence appears once.
- Snooze a reminder, then mark the same occurrence taken or skipped. Confirm the visible row shows the final status while preserving a single row for the occurrence.
- Edit, pause, resume, and delete a medication after recording history. Confirm existing history still shows the captured medication name and dosage label and exposes no row edit controls.
- Switch English and Latin American Spanish locales and reopen history. Confirm title, empty copy, status labels, day headings, and scheduled times are localized.
- Enable large text and screen reader. Confirm history rows wrap without overlap, status labels include both icon and text, and the row announcement order is day, medication, optional dose, time, status.

## Lightweight Usability Review Script

1. SC-001 open-history timing: Ask the participant to find recent reminder activity from the Today screen. Note whether they discover the history action and reach the screen without help.
2. SC-006 status wording feedback: Show taken, skipped, missed, and snoozed rows. Ask what each means and whether any wording feels blaming or alarming.
3. SC-009 scan a busy day: Show one day with eight entries across similar times. Ask which medications were recorded in the morning and whether the order and spacing are easy to scan.

# Quickstart: Settings and Privacy

## Implementation Notes

1. Keep the existing main app settings entry point and route it to the completed settings screen.
2. Reuse `SetupPreferencesRepository` and `SetupLanguage` for language changes.
3. Reuse `NotificationPermissionService` for notification status checks and opening device settings when appropriate.
4. Add a settings data-control service that coordinates existing medication, schedule, due reminder, daily handling, history, and notification scheduler interfaces.
5. Add all new user-visible strings and semantics labels to `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`, then run localization generation.
6. Follow `docs/ux-design.md`: calm tone, large readable text, generous spacing, no pressure, and one primary decision per destructive confirmation step.

## UX Baseline Review Notes

- Settings keeps the onboarding baseline: single-column layout, 24px horizontal padding, section spacing, readable Material text styles, icons paired with text, and 56px preferred primary/destructive actions.
- Copy avoids account, ad, tracking, backup, sync, sharing, analytics, donation, and remote-service prompts. The privacy section states local-only storage in plain language.
- Destructive local-data control uses one confirmation with a clear cancel path, then a short restore action. Remaining manual review should verify large text and screen-reader order on a device or simulator.

## Manual Notification Permission Checklist

- Android allowed: confirm settings reports reminder alerts are on.
- Android denied or blocked: confirm settings reports reminders may not alert and the device-settings action opens app settings.
- iOS allowed: confirm settings reports reminder alerts are on.
- iOS denied or restricted: confirm settings reports reminders may not alert and the device-settings action opens app settings.
- Unavailable/platform failure: confirm the unavailable copy appears and refresh remains available.

## Automated Verification

Run before handoff:

```bash
flutter gen-l10n
dart format lib test
flutter analyze
flutter test
```

Expected automated coverage:

- Settings entry shows language, accessibility, notifications, privacy, and local data control sections.
- English and Latin American Spanish language changes update visible settings copy and persist after reload.
- Notification states render allowed, denied/not allowed, blocked/restricted, and unavailable messages.
- Accessibility section explains device-level support and does not expose text-size or contrast toggles.
- Privacy section states local-only storage and no accounts, ads, tracking, or remote sharing.
- Delete flow does nothing on cancel or dismiss.
- Delete flow removes all local reminder data only after confirmation.
- No-data state avoids a primary destructive action.
- A successful delete exposes a 30-second recovery action.
- Recovery within 30 seconds restores the snapshot.
- Recovery after 30 seconds is unavailable and communicates expiration.
- Deletion failure leaves existing data available and reports that data was not deleted.
- Large text widget tests verify content remains reachable without clipped primary actions.

## Manual Verification

Use at least one Android or iOS simulator/device:

1. Open the app offline and confirm settings is reachable without sign-in or internet.
2. Switch language from English to `Español (Latinoamérica)`, close/reopen the app, and confirm the selected language remains active.
3. With notification permission allowed, open settings and confirm the allowed status is calm and accurate.
4. With notification permission denied or blocked in device settings, reopen settings and confirm the respectful next step appears.
5. Enable large text and a screen reader, then review settings from top to bottom for logical announcement order and reachable controls.
6. Create medication/reminder/history data, cancel the delete confirmation, and confirm data remains.
7. Confirm deletion, use recovery within 30 seconds, and confirm medication/reminder data returns.
8. Confirm deletion again, wait more than 30 seconds, and confirm recovery is no longer available after app restart.

## Performance Check

- Settings screen should render from local data without a blocking progress state for typical stored data.
- Notification status refresh should complete within 1 second when the platform responds.
- Delete and restore should complete within 2 seconds for typical single-user local data.
- The feature should add no background polling, remote requests, or startup-only work unrelated to settings state loading.

## Automated Performance Notes

- `flutter analyze` and `flutter test` pass with the settings service using only local repository calls.
- Settings does not add background polling or remote requests. Notification status checks run on screen entry and user refresh.
- Delete and restore are synchronous local repository operations in the app layer; final device timing still needs manual measurement with realistic local data.

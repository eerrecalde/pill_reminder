# Quickstart: Notification Ringtones

## Implementation Steps

1. Add bundled notification audio files:
   - Flutter preview assets under `assets/audio/notifications/`.
   - Android raw resources under `android/app/src/main/res/raw/`.
   - iOS runner bundle resources, referenced by filename.
2. Register Flutter preview assets in `pubspec.yaml` and add a lightweight audio preview dependency.
3. Create notification ringtone domain and repository types under `lib/features/notifications/`.
4. Add a ringtone preview player service that plays one short sample at a time and stops playback when another preview starts or the picker closes.
5. Extend `LocalReminderNotificationScheduler` to resolve the active ringtone and build `NotificationDetails` with platform sound fields for scheduled, due-now, and remind-later notifications.
6. Add a settings entry and `NotificationRingtonePickerScreen` using the existing settings visual patterns.
7. Add localized strings in `app_en.arb`, `app_es.arb`, and `app_es_419.arb` for option names, picker actions, preview labels, selected/unavailable states, permission/device-setting explanations, and save confirmation.
8. Add focused tests for preference resolution, fallback behavior, scheduler notification details, preview stop behavior, settings UI, localization coverage, and accessibility semantics.

## Automated Verification

Run:

```sh
flutter test
flutter analyze
```

Expected automated coverage:

- Repository loads missing preference as default.
- Repository resolves unknown saved id to default and exposes unavailable warning state.
- Saving an available ringtone persists the stable id.
- Scheduler applies selected ringtone sound to recurring, due-now, suppress-today, and remind-later notification details.
- Android channel ids vary by ringtone id for custom sounds.
- Picker shows selected state without relying on color alone.
- Previewing a second option stops the previous preview.
- Leaving the picker stops preview playback.
- Settings warning appears when the saved ringtone is unavailable.
- Notification permission denied/blocked copy still allows changing the ringtone while explaining sound limits.
- English, Spanish, and Latin American Spanish localization keys are present.

## Manual Verification

Android:

1. Install the app fresh.
2. Open settings and choose a custom ringtone.
3. Preview multiple options and verify only one plays at a time.
4. Trigger or schedule a medication reminder and confirm the chosen sound plays when notification sound playback is allowed.
5. Change to a different ringtone, schedule a future reminder, and verify the later notification uses the new sound.
6. Disable notification permission or enable focus/do-not-disturb and verify settings explains that device settings may prevent sound playback.
7. Restart the device or app and verify the saved preference remains selected.
8. Turn off network access and verify the saved ringtone preference remains selected and reminders still schedule without requiring internet.
9. Confirm the ringtone picker opens in under 500ms with local options and that preview playback starts within 250ms after tapping a preview button on a typical test device.
10. Confirm app startup does not perform network work and the feature does not add recurring background work beyond existing local notification scheduling.

iOS:

1. Repeat the selection, preview, save, and reminder-trigger checks on a physical or simulator target that supports notification sound verification.
2. Confirm default fallback sound plays if a selected custom file is unavailable.
3. Confirm the picker remains usable with large text and VoiceOver.
4. Restart the device or app, keep the device offline, and verify the saved ringtone preference remains selected.
5. Confirm the ringtone picker opens in under 500ms, preview playback starts within 250ms, and no startup network or recurring background work was added.

## Platform Asset Checklist

- Flutter preview files are bundled under `assets/audio/notifications/`.
- Android notification sound files are copied under `android/app/src/main/res/raw/` with lowercase resource names.
- iOS notification sound files are copied under `ios/Runner/` and included in the Runner target resources.
- Custom ringtone ids remain stable after release unless a migration is added.

## Notes

- Platform notification sound behavior cannot be fully proven by unit tests; keep manual verification in the release checklist.
- Do not add account, analytics, backup, cloud sync, advertising, donation, or user audio import behavior for this feature.

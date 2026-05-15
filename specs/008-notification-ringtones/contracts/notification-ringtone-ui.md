# Contract: Notification Ringtone Settings UI

## Entry Point

Location: existing settings screen under the reminder notification/settings area.

The entry point must show:

- Current ringtone display name.
- Notification sound setting label and short description.
- A button or list row that opens the ringtone picker.
- Device-setting limitation copy when notifications are denied, blocked, unavailable, or when explaining mute/focus/do-not-disturb behavior.

## Picker Behavior

The picker must:

- Display the curated bundled ringtone list, including the default reminder sound.
- Show the currently saved option on entry.
- Allow preview without changing the saved preference.
- Stop any active preview when a different preview starts.
- Stop preview when the picker is dismissed.
- Save only when the user confirms the selected option.
- Return the saved `RingtoneOption.id` to the settings screen or update through the repository.
- Show a localized success confirmation after saving.

## Fallback and Unavailable State

When the stored ringtone id is not available:

- The active notification sound resolves to default.
- Settings shows a localized warning that the previous sound is unavailable.
- The warning includes an action or clear prompt to choose another sound.
- The unavailable state is communicated through text and semantics, not color alone.

## Accessibility Contract

- Every ringtone row has a screen reader label containing display name, selected state, and unavailable state when applicable.
- Preview buttons have labels equivalent to "Preview {ringtone name}".
- Selected state uses both visible text/icon and semantic selected state.
- Minimum touch target is 48px, with 56px preferred for primary actions.
- Large text must not clip ringtone names, status labels, or save/cancel actions.
- Focus order follows title, warning/explanation, ringtone options, then save/cancel actions.
- No time-limited action is required to save a ringtone.

## Localization Contract

All user-visible text must be generated from localization resources:

- Settings entry title and description.
- Picker title.
- Ringtone option names.
- Preview action labels.
- Selected/current labels.
- Save/cancel actions.
- Save confirmation.
- Unavailable saved ringtone warning.
- Notification permission and device mute/focus/do-not-disturb explanation.

Required locales: English, Spanish, and Latin American Spanish.

## Privacy Contract

The flow must not:

- Request access to user files or media libraries.
- Browse system sounds.
- Upload or share audio or medication data.
- Add accounts, analytics, ads, backup, sync, donation prompts, or remote services.

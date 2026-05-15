# Research: Notification Ringtones

## Decision: Use a Curated App-Bundled Ringtone List

**Rationale**: The feature specification clarifies that only curated app-bundled sounds are required. Bundled options keep the flow simple for older adults, avoid device file permissions, work offline, and reduce privacy risk because the app never reads user audio files.

**Alternatives considered**: Device/system ringtone picker and user-uploaded files. Both were rejected because they add platform-specific permission, privacy, file-management, and accessibility complexity that the current user story does not require.

## Decision: Store One Global Ringtone Preference Locally

**Rationale**: The specification assumes one ringtone for all medication reminder notifications. A `shared_preferences` repository matches existing local-first storage patterns and is enough for a stable string id plus fallback metadata.

**Alternatives considered**: Per-medication ringtone preferences and database-backed storage. Per-medication sounds increase configuration burden and are out of scope. A database would add unnecessary infrastructure for one small local preference.

## Decision: Represent Ringtones with Stable IDs and Platform Asset Names

**Rationale**: Flutter preview assets, Android raw resources, and iOS bundled sound names have different lookup formats. A domain model with `id`, localized display-name key, Flutter preview asset path, Android raw resource name, iOS resource filename, and default/unavailable status keeps platform details out of the UI.

**Alternatives considered**: Store direct asset paths as the preference. Rejected because asset paths are brittle across platform packaging and make fallback validation harder.

## Decision: Add a Lightweight Asset Audio Player for Preview

**Rationale**: `flutter_local_notifications` handles notification delivery, not ergonomic in-app sample playback. A small preview service using an asset playback package lets users hear short samples without scheduling notifications or requesting notification permission.

**Alternatives considered**: Use local notification test alerts for preview or native platform channels. Test alerts would confuse saved notification behavior and may require permissions. Native channels duplicate cross-platform audio work and increase maintenance cost.

## Decision: Use `flutter_local_notifications` Custom Sound Fields for Delivery

**Rationale**: The installed `flutter_local_notifications` package supports `AndroidNotificationDetails.sound` with `RawResourceAndroidNotificationSound` and `DarwinNotificationDetails.sound` with a bundled sound filename. This fits the existing scheduler and keeps notification delivery in one service.

**Alternatives considered**: Introduce a separate native notification implementation. Rejected because the app already schedules reminders through `LocalReminderNotificationScheduler` and a second path would increase risk of duplicated or missed reminders.

## Decision: Use Per-Sound Android Channel IDs

**Rationale**: On Android 8.0 and newer, notification channel sound is tied to the channel and cannot be changed after channel creation. The scheduler must derive stable channel ids per ringtone, such as `daily_medication_reminders_chime`, so future notifications use the selected channel sound while existing channel settings remain deterministic.

**Alternatives considered**: Reuse the current `daily_medication_reminders` and `due_medication_reminders` channel ids. Rejected because sound changes would not reliably take effect after the channel exists.

## Decision: Fall Back to Default Sound When Validation Fails

**Rationale**: The reminder must still alert if a saved id no longer appears in the bundled option catalog. The repository or selection resolver returns the default ringtone and exposes an unavailable state so settings can explain that the previous sound is unavailable.

**Alternatives considered**: Clear the preference silently or block notifications. Silent clearing would hide useful recovery information. Blocking notifications violates reminder reliability.

## Decision: Explain Device-Level Sound Overrides in Settings

**Rationale**: Notification permission, mute/silent mode, focus/do-not-disturb, and OS channel settings can prevent the chosen ringtone from playing. The settings UI should save the choice but explain these limits in localized copy.

**Alternatives considered**: Attempt to bypass device settings. Rejected because it would violate user control and may require special platform entitlements or permissions.

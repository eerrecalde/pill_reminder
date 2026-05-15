# Data Model: Notification Ringtones

## Entity: Ringtone Option

Represents one curated app-bundled sound that can be selected and previewed.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `id` | `String` | Yes | Stable persisted id, e.g. `default`, `gentle_chime`. Must not change after release without migration. |
| `displayNameKey` | `String` | Yes | Localization lookup key for English and Latin American Spanish display name. |
| `previewAssetPath` | `String` | Yes for custom sounds | Flutter asset path used by the preview player. |
| `androidRawResourceName` | `String?` | Required for custom Android notification sounds | Raw resource name without extension from `android/app/src/main/res/raw/`. `null` means platform default sound. |
| `iosSoundFileName` | `String?` | Required for custom iOS notification sounds | Bundled resource filename with extension. `null` means platform default sound. |
| `isDefault` | `bool` | Yes | Exactly one option must be default. |
| `isAvailable` | `bool` | Yes | Derived from bundled catalog and asset availability, not user-editable. |

### Validation Rules

- Exactly one option is the default.
- Option ids are unique and contain only lowercase ASCII letters, digits, and underscores.
- Custom options must define preview, Android, and iOS sound asset references.
- Display names must be available through generated localizations for English, Spanish, and Latin American Spanish.
- Unavailable options are never offered as selectable save targets.

## Entity: Notification Ringtone Preference

Represents the user's active reminder notification sound choice.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `selectedRingtoneId` | `String?` | No | Stored in `shared_preferences`; `null` resolves to default. |
| `resolvedRingtoneId` | `String` | Yes | The available option actually used for scheduling. |
| `unavailableSavedRingtoneId` | `String?` | No | Present when the stored id cannot be resolved. Drives settings warning copy. |
| `updatedAt` | `DateTime?` | No | Optional metadata for tests/debugging; not user-visible. |

### Validation Rules

- Loading a missing preference resolves to the default ringtone.
- Loading an unknown or unavailable id resolves to the default ringtone and exposes `unavailableSavedRingtoneId`.
- Saving requires an available `Ringtone Option`.
- Clearing or deleting reminder data may reset the preference to default if implementation includes ringtone preference in local reminder data deletion.

### State Transitions

```text
No saved preference
  -> load -> Default selected

Default selected
  -> save available custom option -> Custom selected

Custom selected
  -> save another available option -> Custom selected
  -> save default option -> Default selected
  -> option removed/unavailable -> Fallback active with unavailable warning

Fallback active with unavailable warning
  -> save available option -> Selected with warning cleared
```

## Entity: Medication Reminder Notification

Represents an existing scheduled or immediate medication alert whose sound details must be built from the resolved ringtone preference.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `notificationId` | `int` | Yes | Existing generated id for scheduled, due, or later notifications. |
| `title` | `String` | Yes | Existing localized or medication-derived notification title. |
| `body` | `String` | Yes | Existing localized or medication-derived notification body. |
| `ringtoneOption` | `RingtoneOption` | Yes | Resolved option used when constructing `NotificationDetails`. |
| `permissionStatus` | `SetupNotificationPermissionStatus` | Yes | Existing gate for scheduling/delivery. |

### Validation Rules

- Scheduler must use the resolved default option if preference resolution reports an unavailable saved id.
- Android notification channel ids must include the ringtone id so channel sound changes are respected on Android 8.0+.
- Due-now, remind-later, suppressed-next-day, and recurring daily notifications must use the same resolved ringtone preference.
- If notification permission or device sound settings block playback, the preference remains saved and settings explain the limitation.

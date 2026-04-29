# Data Model: Setup Page

## SetupPreference

Represents first-run setup progress for the local device user.

**Fields**

- `isComplete`: Boolean. True after the user finishes the setup flow and reaches the main app.
- `currentStep`: One of `language`, `privacy`, `notifications`, `complete`. Used to resume setup after interruption.
- `createdAt`: Local timestamp when setup preferences are first created.
- `updatedAt`: Local timestamp when setup preferences last changed.

**Validation Rules**

- `isComplete` can become true only after a language is selected and the privacy explanation has been acknowledged.
- `currentStep` must always match the furthest known valid setup position.
- Setup completion must not depend on notification permission being granted.

**State Transitions**

1. No local record -> `language`
2. Language selected -> `privacy`
3. Privacy acknowledged -> `notifications`
4. Notification granted, skipped, denied, blocked, or unavailable -> `complete`
5. Completed setup remains complete unless the user explicitly resets or revisits setup preferences.

## LanguagePreference

Represents the selected app language for setup and subsequent app copy.

**Fields**

- `localeCode`: One of `en` or `es_419`.
- `displayName`: User-facing name, localized where shown.
- `selectedAt`: Local timestamp when the choice was made.

**Validation Rules**

- Only English and Latin American Spanish are valid for this feature.
- The selected language applies immediately to all following setup screens.
- English is used before a selection exists.

## PrivacyAcknowledgement

Represents that the user saw and continued past the device-privacy explanation.

**Fields**

- `acknowledged`: Boolean.
- `acknowledgedAt`: Local timestamp when the user continued.
- `copyVersion`: Short version string for the privacy copy shown to the user.

**Validation Rules**

- `acknowledged` must be true before setup can be marked complete.
- The acknowledgement records only setup state, not medication details.

## NotificationPermissionStatus

Represents whether reminders can currently be delivered.

**Allowed Values**

- `unknown`: Permission has not been checked or requested yet.
- `granted`: Reminders can be delivered.
- `skipped`: User chose not to enable reminders during setup.
- `denied`: User denied permission when asked.
- `blocked`: Permission is denied in a way that requires device settings recovery.
- `unavailable`: Device or platform cannot provide reminder notifications.

**Fields**

- `status`: One allowed value.
- `lastCheckedAt`: Local timestamp when permission status was last checked.
- `needsMainAppStatus`: Boolean derived from `status`; true for `skipped`, `denied`, `blocked`, and `unavailable`.

**Validation Rules**

- Setup can complete with any allowed value except `unknown`.
- `needsMainAppStatus` remains true until reminders can be delivered.
- Denied, blocked, skipped, and unavailable states must expose a non-blocking recovery path.

## Relationships

- `SetupPreference` owns one `LanguagePreference`, one `PrivacyAcknowledgement`, and one `NotificationPermissionStatus`.
- Future Firebase-backed user or medication data must not replace local setup completion as a prerequisite for offline use.
- Future remote identifiers, if added, must remain optional and must not be required for the setup flow.

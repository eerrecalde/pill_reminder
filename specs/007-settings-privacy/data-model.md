# Data Model: Settings and Privacy

## Settings Preference

Purpose: Stores the user's app-level setup/settings choices that affect settings behavior.

Fields:

- `language`: `SetupLanguage`, one of `english` or `spanishLatinAmerica`.
- `notificationStatus`: `SetupNotificationPermissionStatus`, last known permission state.
- `isComplete`, `currentStep`, `privacyAcknowledged`, `createdAt`, `updatedAt`: existing setup fields retained for compatibility.

Validation rules:

- Language must be one of the supported locales.
- Language changes must persist through app restart.
- Accessibility is not stored as a separate preference; settings explains device-level support.

Relationships:

- Used by `MaterialApp.locale` to render localized settings copy.
- Updated by settings language controls and notification status refresh.

## Notification Status

Purpose: Represents the current user-facing reminder alert permission state.

Fields:

- `status`: granted, denied, blocked/restricted, or unavailable.
- `checkedAt`: runtime-only timestamp if needed for display or test assertions.
- `nextStep`: localized explanation or action label based on status.

Validation rules:

- Granted must not show corrective warning language.
- Denied or blocked must explain the respectful next step without blocking app use.
- Unavailable must say the app cannot confirm status right now and can try again later.
- Status must be communicated with text, not color alone.

Relationships:

- Loaded from `NotificationPermissionService.checkStatus()`.
- May update `SetupPreferencesRepository.saveNotificationStatus()`.

## Privacy Explanation

Purpose: Localized content that describes the app's private, local-first behavior.

Fields:

- `localStorageExplanation`: medication and reminder data stays on this device.
- `noAccountExplanation`: no required account or sign-in.
- `noAdsTrackingExplanation`: no ads, tracking, or required consent prompts.
- `noRemoteSharingExplanation`: no backup, sync, sharing, analytics, donation, or remote service behavior introduced by this feature.

Validation rules:

- Copy must be plain language and avoid technical storage jargon.
- Copy must exist in English and Latin American Spanish.
- Copy must not imply cloud backup or recovery beyond the 30-second undo window.

## Local Reminder Data

Purpose: The sensitive local medication/reminder information controlled by the delete flow.

Fields:

- `medications`: medication names, dosage labels, notes, active/paused status.
- `reminderSchedules`: local reminder times, end dates, notification delivery state.
- `dueReminders`: generated due reminder state that has not been resolved.
- `dailyReminderHandling`: completed/skipped/snoozed handling state by local date.
- `medicationHistory`: retained medication history entries.
- `scheduledNotifications`: platform notification requests tied to local schedules.

Validation rules:

- Delete flow must remove medication records, schedules, due reminder state, handling state, and medication history.
- Delete flow must cancel related local notifications.
- If deletion fails, existing data must remain available and the UI must say data was not deleted.
- If no local reminder data exists, the settings UI must explain there is nothing to delete and avoid making destructive confirmation the primary action.

Relationships:

- Aggregated by `ReminderDataControlService`.
- Backed by existing medication repository interfaces and their local implementations.

## Deletion Confirmation

Purpose: A deliberate safety step before deleting local reminder data.

Fields:

- `summary`: localized text describing exactly what will be removed.
- `confirmAction`: localized destructive action label.
- `cancelAction`: localized safe exit label.
- `hasLocalData`: whether destructive confirmation should be available.

Validation rules:

- Confirmation must be shown before any data is removed.
- Cancel or dismiss must leave all local reminder data unchanged.
- The confirmation presents one primary destructive decision and one clear cancel path.
- Touch targets must be at least 48px, with 56px preferred for primary/cancel actions.

## Deletion Recovery Window

Purpose: Represents the 30-second period immediately after confirmed deletion when data can be restored.

Fields:

- `snapshot`: `LocalReminderDataSnapshot`, runtime-only copy of deleted data.
- `startedAt`: local timestamp when deletion completed.
- `expiresAt`: `startedAt + 30 seconds`.
- `state`: active, restored, expired, or failed.

Validation rules:

- Recovery option must be clearly labeled while active.
- Selecting recovery before `expiresAt` restores all captured local medication/reminder data and reschedules notifications where applicable.
- After `expiresAt`, recovery must no longer restore data and settings must communicate that the window has ended.
- Recovery snapshot must not survive app restart beyond the 30-second local recovery window.

Relationships:

- Created by `ReminderDataControlService.deleteLocalReminderData()`.
- Consumed by settings UI for snackbar/banner recovery action and completion state.

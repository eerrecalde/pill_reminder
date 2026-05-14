# Research: Settings and Privacy

## Local-First Settings Architecture

Decision: Extend the existing Flutter settings/preferences path with a `features/settings` slice and reuse established repositories instead of adding remote services or new persistence dependencies.

Rationale: The app already stores setup, medication, schedule, due reminder, handling, and history data locally through SharedPreferences-backed repositories. Keeping the feature on those interfaces preserves offline use, avoids account or tracking concerns, and keeps behavior testable.

Alternatives considered: Adding a dedicated database or secure storage layer was rejected because the current data volume is small and the feature does not require encryption-at-rest changes or relational queries. Adding cloud backup/export was rejected because the specification explicitly excludes backup, sync, sharing, accounts, and remote services.

## Language Selection

Decision: Use the existing `SetupLanguage`, `SetupPreferencesRepository.saveLanguage`, Flutter `MaterialApp.locale`, and ARB-generated localization files for English and Latin American Spanish.

Rationale: The app already persists setup language and rebuilds the app locale from setup state. Reusing this path ensures language changes survive app restarts and avoids a second preference source.

Alternatives considered: A separate settings preference model was rejected because it would duplicate existing setup state. Runtime string maps were rejected because they bypass Flutter localization and increase hard-coded copy risk.

## Notification Status

Decision: Show current permission state by calling `NotificationPermissionService.checkStatus()` and map results to calm user-facing states: allowed, not allowed/blocked, denied/not yet allowed, and temporarily unavailable.

Rationale: Platform permission state is inherently outside local repository state. The existing service already abstracts `permission_handler` and can be faked in widget tests.

Alternatives considered: Showing only the last stored setup status was rejected because it can become stale when users change permission outside the app. Prompting for permission automatically from settings was rejected because settings should provide a respectful next step without pressure.

## Accessibility Explanation

Decision: Provide an explanatory accessibility section rather than in-app text size or contrast toggles.

Rationale: The clarification states that accessibility support follows device settings. Flutter can respect system text scaling, screen reader semantics, focus order, and contrast-oriented color choices without adding duplicate controls.

Alternatives considered: Adding text-size and contrast toggles was rejected by FR-016. Linking users out to multiple OS accessibility screens was rejected for this feature because it adds platform-specific complexity and is not required by the spec.

## Local Data Deletion And Recovery

Decision: Add a `ReminderDataControlService` that snapshots all local medication/reminder data, cancels relevant scheduled notifications, deletes local repositories, and exposes a 30-second in-memory recovery window for immediate restore.

Rationale: The deletion scope crosses medication records, reminder schedules, due reminders, daily handling state, medication history, and scheduled notifications. A service keeps this workflow out of UI widgets and enables unit tests for cancel/delete/restore/error cases. The recovery window is short and immediate, so an in-memory snapshot avoids creating a longer-lived backup that would contradict deletion expectations.

Alternatives considered: Deleting each repository directly from the settings widget was rejected because it would mix UI and privacy-critical data handling. Persisting the undo snapshot to disk was rejected because the spec says recovery is only available for 30 seconds and deleted local-only data should remain deleted after the window ends. A second confirmation screen after deletion was rejected because the recovery action is the safe path and further prompts would add confusion.

## Localization And Copy

Decision: Add every new settings label, explanation, confirmation, button, status, snackbar/dialog message, and error state to `app_en.arb`, `app_es.arb`, and `app_es_419.arb`.

Rationale: The constitution requires localizable user-facing copy, and this feature makes language switching a primary flow. Keeping settings copy in ARB files supports screen reader announcements and future generated localization updates.

Alternatives considered: Hard-coded strings in widgets were rejected because they make language switching incomplete and harder to test.

## Testing Strategy

Decision: Use widget tests for settings flows and unit tests for data deletion/recovery service behavior, with manual verification for real platform notification permission states.

Rationale: The feature is mostly local UI and repository orchestration, which can be automated with fakes. Platform permission dialogs and OS settings behavior still need manual checks because they vary by platform and cannot be fully proven by Flutter unit tests.

Alternatives considered: Golden-only verification was rejected because the important risks are behavior, accessibility semantics, localization, and data integrity. Manual-only verification was rejected because destructive data flows need repeatable regression coverage.

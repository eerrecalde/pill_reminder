# Research: Setup Page

## Decision: Build the feature as a Flutter mobile setup flow for phones and tablets

**Rationale**: The repository is already a Flutter app with Material 3 theme support, Android/iOS platform folders, and a small `lib/` surface. A native Flutter flow keeps phone and tablet support in one code path and lets widget tests cover the user journeys.

**Alternatives considered**: Separate native Android/iOS setup screens were rejected because they duplicate accessibility, localization, and state behavior. A web-first flow was rejected because the target is phones and tablets.

## Decision: Use local setup preferences behind a repository interface

**Rationale**: The current feature only needs small preference values: setup completion, language, privacy acknowledgement, and notification permission status. A `SetupPreferencesRepository` interface keeps widgets independent of storage details and prepares for a later Firebase-backed implementation for users and medication data.

**Alternatives considered**: Direct `shared_preferences` calls from widgets were rejected because they couple UI to persistence. A database was rejected because this feature does not store medication schedules or relational data.

## Decision: Add `shared_preferences` for local setup preference persistence

**Rationale**: Setup state is small, local, and needed at app start. `shared_preferences` is appropriate for simple local preferences and avoids introducing a heavier local database before medication scheduling exists.

**Alternatives considered**: File storage was rejected because it adds parsing and migration overhead for simple flags. SQLite-style storage was rejected as premature for first-run setup preferences.

## Decision: Treat Firebase as a future repository implementation, not a dependency in this feature

**Rationale**: The specification requires offline, account-free setup and no remote service. The user wants a future Firebase upgrade path, so the plan records stable domain models and a repository boundary without adding Firebase packages, account flows, or remote sync now.

**Alternatives considered**: Adding Firebase immediately was rejected because it would conflict with account-free onboarding and introduce remote dependencies. Ignoring Firebase entirely was rejected because it would make later migration more disruptive.

## Decision: Model notification permission separately from reminder scheduling

**Rationale**: This feature asks users to enable reminders and explains permission-denied states, but medication schedule creation and reminder delivery are out of scope. A `NotificationPermissionService` can request/check permission now and later be used by the reminder scheduler.

**Alternatives considered**: Implementing full local notification scheduling here was rejected as out of scope. Storing only a user-selected "not now" flag was rejected because the app must distinguish granted, skipped, denied, blocked, and unavailable states.

## Decision: Use app localization resources for all setup copy

**Rationale**: The constitution requires English and Latin American Spanish readiness. ARB resources with `en` and `es_419` locale support keep user-visible copy out of business logic and make tests able to verify language switching.

**Alternatives considered**: Hard-coded maps inside widgets were rejected because they are harder to scale and test consistently. Deferring Spanish copy was rejected because language choice is part of the feature.

## Decision: Follow `ux-design.md` as the visual and interaction contract

**Rationale**: The UX guide defines the exact flow shape: one decision per screen, centered language selection, privacy reassurance, notification prompt, warm off-white background, soft green primary actions, and no alarming denied-permission language.

**Alternatives considered**: A single long setup page was rejected because it increases cognitive load. A modal-only permission explanation was rejected because it would make the flow feel less calm and less screen-reader predictable.

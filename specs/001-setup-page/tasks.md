# Tasks: Setup Page

**Input**: Design documents from `specs/001-setup-page/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required for setup persistence, localization, permissions, accessibility semantics, privacy copy, and regression coverage per the project constitution.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add project-level dependencies, platform permission setup, localization scaffolding, and feature directories.

- [ ] T001 Update Flutter dependencies for `shared_preferences`, `permission_handler`, and Flutter localization support in `pubspec.yaml`
- [ ] T002 Configure Flutter generated localization settings in `l10n.yaml`
- [ ] T003 [P] Add Android notification permission declaration for Android 13+ in `android/app/src/main/AndroidManifest.xml`
- [ ] T004 [P] Create or update iOS permission handler notification configuration in `ios/Podfile`
- [ ] T005 [P] Create setup feature directory structure in `lib/features/setup/`
- [ ] T006 [P] Create setup test directory structure in `test/features/setup/`
- [ ] T007 [P] Align warm setup palette and 56px button defaults with UX guidance in `lib/theme/app_theme.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core setup state, storage boundaries, localization files, and test doubles that all user stories depend on.

**CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T008 [P] Define supported setup languages and locale mapping in `lib/features/setup/domain/setup_language.dart`
- [ ] T009 [P] Define notification permission status enum and derived main-app status behavior in `lib/features/setup/domain/notification_permission_status.dart`
- [ ] T010 [P] Define setup step and setup state value objects in `lib/features/setup/domain/setup_state.dart`
- [ ] T011 Define `SetupPreferencesRepository` interface in `lib/features/setup/data/setup_preferences_repository.dart`
- [ ] T012 Define `NotificationPermissionService` interface in `lib/services/notification_permission_service.dart`
- [ ] T013 [P] Add English setup, setup-preferences, and reminder-status strings in `lib/l10n/app_en.arb`
- [ ] T014 [P] Add Latin American Spanish setup, setup-preferences, and reminder-status strings in `lib/l10n/app_es_419.arb`
- [ ] T015 [P] Add fake setup preferences repository for widget tests in `test/features/setup/fakes/fake_setup_preferences_repository.dart`
- [ ] T016 [P] Add fake notification permission service for widget tests in `test/features/setup/fakes/fake_notification_permission_service.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Complete First-Run Setup (Priority: P1) MVP

**Goal**: A first-time user can open the app, choose English or Latin American Spanish, proceed through the short setup path, and reach the main app with setup completion and selected language saved.

**Independent Test**: Launch with no local setup preferences, complete the setup path, confirm selected language is applied, confirm setup completion is saved, and confirm the setup flow does not repeat on next launch.

### Tests for User Story 1

- [ ] T017 [P] [US1] Add widget test for fresh install language selection and immediate locale switch in `test/features/setup/setup_flow_test.dart`
- [ ] T018 [P] [US1] Add widget test for changing mistaken language selection before setup completion in `test/features/setup/setup_flow_test.dart`
- [ ] T019 [P] [US1] Add widget test for completing setup and skipping repeated setup on next launch in `test/features/setup/setup_flow_test.dart`
- [ ] T020 [P] [US1] Add widget tests for resuming interrupted setup from saved privacy and notification steps in `test/features/setup/setup_flow_test.dart`
- [ ] T021 [P] [US1] Add repository persistence unit tests for setup completion, current step, and selected language in `test/features/setup/setup_preferences_repository_test.dart`

### Implementation for User Story 1

- [ ] T022 [US1] Implement local setup preference persistence using `shared_preferences` in `lib/features/setup/data/local_setup_preferences_repository.dart`
- [ ] T023 [US1] Implement setup flow controller, saved-step resume, and step navigation in `lib/features/setup/presentation/setup_flow.dart`
- [ ] T024 [US1] Implement language selection screen with full-width accessible language buttons and selected-language recovery in `lib/features/setup/presentation/language_selection_screen.dart`
- [ ] T025 [US1] Wire generated localizations and supported locales into the app root in `lib/main.dart`
- [ ] T026 [US1] Route app startup through setup or the main app based on local setup completion in `lib/main.dart`
- [ ] T027 [US1] Add a minimal main-app placeholder with setup preferences entry point in `lib/main.dart`
- [ ] T028 [US1] Implement post-setup language preference controls in `lib/features/setup/presentation/setup_preferences_screen.dart`

**Checkpoint**: User Story 1 is functional and testable as the MVP.

---

## Phase 4: User Story 2 - Understand Device Privacy (Priority: P2)

**Goal**: A new user sees calm, plain-language privacy reassurance before entering medication details and can continue only after the privacy explanation is shown.

**Independent Test**: Complete the privacy step and confirm the copy says medication reminders stay on this device, no account is required, no sharing is introduced, and screen-reader/large-text behavior remains usable.

### Tests for User Story 2

- [ ] T029 [P] [US2] Add widget test for privacy copy and no-account reassurance in `test/features/setup/setup_flow_test.dart`
- [ ] T030 [P] [US2] Add widget test for large text and semantic order on the privacy screen in `test/features/setup/setup_flow_test.dart`
- [ ] T031 [P] [US2] Add unit test for privacy acknowledgement persistence in `test/features/setup/setup_preferences_repository_test.dart`

### Implementation for User Story 2

- [ ] T032 [US2] Implement privacy acknowledgement fields in local persistence in `lib/features/setup/data/local_setup_preferences_repository.dart`
- [ ] T033 [US2] Implement privacy explanation screen using UX layout, soft illustration treatment, and sticky primary action in `lib/features/setup/presentation/privacy_explanation_screen.dart`
- [ ] T034 [US2] Integrate privacy acknowledgement into setup step progression in `lib/features/setup/presentation/setup_flow.dart`
- [ ] T035 [US2] Ensure English and Latin American Spanish privacy copy is consumed from localization resources in `lib/l10n/app_en.arb` and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 2 works independently and preserves User Story 1.

---

## Phase 5: User Story 3 - Enable or Decline Notifications (Priority: P3)

**Goal**: A new user can grant reminders, choose "Not now", or deny permission and still continue into the app with clear non-blocking recovery guidance when reminders cannot be delivered.

**Independent Test**: Run granted, skipped, denied, blocked, and unavailable notification states; confirm setup completes in all paths and the main app shows/removes the reminder status correctly.

### Tests for User Story 3

- [ ] T036 [P] [US3] Add widget test for granted notification path completing setup without reminder status in `test/features/setup/setup_flow_test.dart`
- [ ] T037 [P] [US3] Add widget test for skipped and denied notification paths showing non-blocking reminder status in `test/features/setup/reminder_status_banner_test.dart`
- [ ] T038 [P] [US3] Add widget test for post-setup notification guidance in setup preferences in `test/features/setup/reminder_status_banner_test.dart`
- [ ] T039 [P] [US3] Add unit tests for notification permission status persistence and `needsMainAppStatus` behavior in `test/features/setup/setup_preferences_repository_test.dart`
- [ ] T040 [US3] Add manual permission verification checklist for Android and iOS in `specs/001-setup-page/quickstart.md`

### Implementation for User Story 3

- [ ] T041 [US3] Implement `permission_handler` notification permission checks, request flow, and settings recovery in `lib/services/notification_permission_service.dart`
- [ ] T042 [US3] Implement notification permission screen with primary and secondary actions in `lib/features/setup/presentation/notification_permission_screen.dart`
- [ ] T043 [US3] Persist granted, skipped, denied, blocked, and unavailable notification states in `lib/features/setup/data/local_setup_preferences_repository.dart`
- [ ] T044 [US3] Integrate notification permission outcomes into setup completion in `lib/features/setup/presentation/setup_flow.dart`
- [ ] T045 [US3] Implement non-blocking main-app reminder status banner in `lib/features/setup/presentation/reminder_status_banner.dart`
- [ ] T046 [US3] Display reminder status banner from the main app when notifications are skipped, denied, blocked, or unavailable in `lib/main.dart`
- [ ] T047 [US3] Add post-setup notification status and recovery guidance to `lib/features/setup/presentation/setup_preferences_screen.dart`

**Checkpoint**: All user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify accessibility, localization, privacy, performance, and documentation across the full setup experience.

- [ ] T048 [P] Review setup UX against `specs/001-setup-page/ux-design.md`
- [ ] T049 [P] Review English and Latin American Spanish copy for all setup, setup-preferences, and reminder-status strings in `lib/l10n/app_en.arb` and `lib/l10n/app_es_419.arb`
- [ ] T050 [P] Add accessibility regression coverage for focus labels, large text, and non-color-only selected/status states in `test/features/setup/setup_flow_test.dart`
- [ ] T051 [P] Add privacy regression coverage proving setup introduces no account, sharing, analytics, backup, sync, donation, or remote service dependency in `test/features/setup/setup_flow_test.dart`
- [ ] T052 Verify first setup screen startup and setup transition responsiveness against the performance goals in `specs/001-setup-page/quickstart.md`
- [ ] T053 Run the full automated test suite for this feature from `test/features/setup/`
- [ ] T054 Update implementation notes and any manual verification results in `specs/001-setup-page/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion - MVP scope.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and integrates into the setup flow from User Story 1.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and integrates into the setup flow/main app from User Story 1.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational phase; no dependency on US2 or US3.
- **User Story 2 (P2)**: Can start after Foundational phase; integration is easiest after US1 setup flow exists.
- **User Story 3 (P3)**: Can start after Foundational phase; integration is easiest after US1 setup flow, main-app placeholder, and setup preferences entry point exist.

### Within Each User Story

- Tests should be written before implementation tasks in that story.
- Domain and repository behavior must exist before UI relies on it.
- Screens should be integrated into `setup_flow.dart` before app-root routing is considered complete.
- Story checkpoint should pass before moving to the next priority.

## Parallel Opportunities

- T003, T004, T005, T006, and T007 can run in parallel after dependency decisions are clear.
- T008, T009, T010, T013, T014, T015, and T016 can run in parallel during the Foundational phase.
- T017, T018, T019, T020, and T021 can run in parallel before US1 implementation.
- T029, T030, and T031 can run in parallel before US2 implementation.
- T036, T037, T038, and T039 can run in parallel before US3 implementation.
- T048, T049, T050, and T051 can run in parallel during Polish.

## Parallel Example: User Story 1

```bash
Task: "T017 [P] [US1] Add widget test for fresh install language selection and immediate locale switch in test/features/setup/setup_flow_test.dart"
Task: "T018 [P] [US1] Add widget test for changing mistaken language selection before setup completion in test/features/setup/setup_flow_test.dart"
Task: "T020 [P] [US1] Add widget tests for resuming interrupted setup from saved privacy and notification steps in test/features/setup/setup_flow_test.dart"
Task: "T021 [P] [US1] Add repository persistence unit tests for setup completion, current step, and selected language in test/features/setup/setup_preferences_repository_test.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T029 [P] [US2] Add widget test for privacy copy and no-account reassurance in test/features/setup/setup_flow_test.dart"
Task: "T030 [P] [US2] Add widget test for large text and semantic order on the privacy screen in test/features/setup/setup_flow_test.dart"
Task: "T031 [P] [US2] Add unit test for privacy acknowledgement persistence in test/features/setup/setup_preferences_repository_test.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T036 [P] [US3] Add widget test for granted notification path completing setup without reminder status in test/features/setup/setup_flow_test.dart"
Task: "T037 [P] [US3] Add widget test for skipped and denied notification paths showing non-blocking reminder status in test/features/setup/reminder_status_banner_test.dart"
Task: "T038 [P] [US3] Add widget test for post-setup notification guidance in setup preferences in test/features/setup/reminder_status_banner_test.dart"
Task: "T039 [P] [US3] Add unit tests for notification permission status persistence and needsMainAppStatus behavior in test/features/setup/setup_preferences_repository_test.dart"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate language choice, wrong-language recovery, interrupted setup resume, setup completion persistence, and first-run routing.

### Incremental Delivery

1. Deliver US1 for a usable first-run skeleton with language choice, setup persistence, resume behavior, and post-setup language preferences.
2. Add US2 for privacy reassurance and acknowledgement.
3. Add US3 for notification permission, denial recovery, post-setup notification guidance, and main-app reminder status.
4. Run Polish tasks before release.

### Notes

- Keep Firebase out of this feature implementation; preserve only the repository boundary for future migration.
- Keep medication scheduling and medication data entry out of scope.
- Platform notification behavior requires manual verification even when widget tests cover app state transitions.

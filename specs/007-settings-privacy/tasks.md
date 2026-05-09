# Tasks: Settings and Privacy

**Input**: Design documents from `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/specs/007-settings-privacy/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/settings-ui-contract.md, quickstart.md

**Tests**: Required for this feature because it affects reminder data, accessibility states, localization, permissions, persistence, privacy, and destructive recovery behavior. Platform notification permission behavior also requires manual verification where automation cannot prove OS behavior.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter app**: `lib/`, `test/` at repository root
- **Feature docs**: `specs/007-settings-privacy/`
- **Settings feature slice**: `lib/features/settings/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare the settings feature slice, test folders, and localization workflow.

- [ ] T001 Create settings feature directories in lib/features/settings/data/, lib/features/settings/domain/, lib/features/settings/presentation/, and test/features/settings/
- [ ] T002 [P] Create settings test fake directory in test/features/settings/fakes/
- [ ] T003 [P] Review existing UX baseline before implementation and record any feature-specific notes in specs/007-settings-privacy/quickstart.md
- [ ] T004 [P] Run flutter gen-l10n to confirm current localization generation succeeds for lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared contracts and repository capabilities that MUST be complete before any user story can be implemented.

**CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T005 [P] Define LocalReminderDataSnapshot entity with medications, reminderSchedules, dueReminders, dailyReminderHandling, medicationHistory, and capturedAt in lib/features/settings/domain/local_reminder_data_snapshot.dart
- [ ] T006 [P] Define DeletionRecoveryWindow entity with active/restored/expired/failed states and 30-second expiry helpers in lib/features/settings/domain/deletion_recovery_window.dart
- [ ] T007 [P] Define ReminderDataControlService abstract contract for hasLocalReminderData, snapshot, deleteLocalReminderData, restoreLocalReminderData, and expireRecoveryWindow in lib/features/settings/domain/reminder_data_control_service.dart
- [ ] T008 Add loadAll/saveAll/deleteAll methods needed for medication snapshot and restore to lib/features/medications/data/medication_repository.dart and lib/features/medications/data/local_medication_repository.dart
- [ ] T009 Add loadAll/saveAll/deleteAll methods needed for reminder schedule snapshot and restore to lib/features/medications/data/reminder_schedule_repository.dart and lib/features/medications/data/local_reminder_schedule_repository.dart
- [ ] T010 Add loadAll/saveAll/deleteAll methods needed for due reminder snapshot and restore to lib/features/medications/data/due_reminder_repository.dart and lib/features/medications/data/local_due_reminder_repository.dart
- [ ] T011 Add loadAll/saveAll/deleteAll methods needed for daily reminder handling snapshot and restore to lib/features/medications/data/daily_reminder_handling_repository.dart and lib/features/medications/data/local_daily_reminder_handling_repository.dart
- [ ] T012 Add loadAll/saveAll/deleteAll methods needed for medication history snapshot and restore to lib/features/medications/data/medication_history_repository.dart and lib/features/medications/data/local_medication_history_repository.dart
- [ ] T013 Update medication repository fakes with snapshot and restore helpers in test/features/medications/fakes/fake_medication_repository.dart, test/features/medications/fakes/fake_reminder_schedule_repository.dart, test/features/medications/fakes/fake_due_reminder_repository.dart, test/features/medications/fakes/fake_daily_reminder_handling_repository.dart, and test/features/medications/fakes/fake_medication_history_repository.dart
- [ ] T014 Add cancelAllForSchedules helper for data deletion workflows to lib/services/reminder_notification_scheduler.dart and test/features/medications/fakes/fake_reminder_notification_scheduler.dart
- [ ] T015 Add baseline settings localization keys for section titles, explanations, status labels, actions, semantic labels, errors, and recovery messages to lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Review Settings and Privacy Clearly (Priority: P1) MVP

**Goal**: A calm, accessible settings area shows language, device-based accessibility support, notification status, privacy, and local data control without accounts, ads, tracking, or technical language.

**Independent Test**: Open settings and confirm all required sections are visible, localized, accessible with large text and screen readers, and free of account/ad/tracking prompts.

### Tests for User Story 1

- [ ] T016 [P] [US1] Add settings screen section visibility and no-account/no-ads/no-tracking widget tests in test/features/settings/settings_screen_test.dart
- [ ] T017 [P] [US1] Add large-text reflow and semantics order widget tests for settings sections in test/features/settings/settings_screen_accessibility_test.dart
- [ ] T018 [P] [US1] Add settings entry-point widget test from the main app app bar in test/widget_test.dart

### Implementation for User Story 1

- [ ] T019 [P] [US1] Implement reusable accessible SettingsSection widget in lib/features/settings/presentation/settings_section.dart
- [ ] T020 [US1] Implement SettingsScreen scrollable layout with language, accessibility, notifications, privacy, and local data control sections in lib/features/settings/presentation/settings_screen.dart
- [ ] T021 [US1] Route the main app settings action to SettingsScreen while preserving setup state callbacks and repositories in lib/main.dart
- [ ] T022 [US1] Replace setup-preferences-only copy with settings-area titles, section copy, tooltips, and semantics in lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb
- [ ] T023 [US1] Run flutter gen-l10n and verify generated localizations update in lib/l10n/app_localizations.dart, lib/l10n/app_localizations_en.dart, and lib/l10n/app_localizations_es.dart

**Checkpoint**: User Story 1 is fully functional and testable independently.

---

## Phase 4: User Story 2 - Change Preferred Language (Priority: P1)

**Goal**: Users can switch between English and Latin American Spanish from settings, see settings copy update immediately, and keep the selected language after restart.

**Independent Test**: Change language in settings, confirm visible settings/navigation/confirmation copy updates, close and recreate the app, and confirm the selected language persists.

### Tests for User Story 2

- [ ] T024 [P] [US2] Add widget test for English to Español (Latinoamérica) settings language switch in test/features/settings/settings_language_test.dart
- [ ] T025 [P] [US2] Add widget test for Español (Latinoamérica) to English settings language switch in test/features/settings/settings_language_test.dart
- [ ] T026 [P] [US2] Add persistence test for selected language after app reload in test/features/settings/settings_language_test.dart

### Implementation for User Story 2

- [ ] T027 [US2] Implement SettingsScreen language segmented control using SetupLanguage and SetupPreferencesRepository.saveLanguage in lib/features/settings/presentation/settings_screen.dart
- [ ] T028 [US2] Ensure language changes call onLocaleChanged and onStateChanged without requiring app restart in lib/features/settings/presentation/settings_screen.dart
- [ ] T029 [US2] Update setup preferences compatibility or wrapper behavior so existing tests still pass in lib/features/setup/presentation/setup_preferences_screen.dart
- [ ] T030 [US2] Add localized language confirmation and selected-state semantics to lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb

**Checkpoint**: User Story 2 is fully functional and testable independently.

---

## Phase 5: User Story 3 - Check Notification Status (Priority: P2)

**Goal**: Settings shows accurate reminder notification permission status with calm text and a respectful next step for denied, blocked, or unavailable states.

**Independent Test**: View settings with allowed, denied/not allowed, blocked/restricted, and unavailable statuses and confirm text, actions, and stored state behave correctly.

### Tests for User Story 3

- [ ] T031 [P] [US3] Add notification allowed, denied, blocked, and unavailable rendering tests in test/features/settings/settings_notification_status_test.dart
- [ ] T032 [P] [US3] Add notification refresh and open-device-settings action tests using FakeNotificationPermissionService in test/features/settings/settings_notification_status_test.dart
- [ ] T033 [US3] Add manual verification checklist entries for Android/iOS notification permission states in specs/007-settings-privacy/quickstart.md

### Implementation for User Story 3

- [ ] T034 [US3] Implement notification status section that calls NotificationPermissionService.checkStatus on entry and refresh in lib/features/settings/presentation/settings_screen.dart
- [ ] T035 [US3] Persist refreshed notification status through SetupPreferencesRepository.saveNotificationStatus in lib/features/settings/presentation/settings_screen.dart
- [ ] T036 [US3] Add respectful device-settings action wiring through NotificationPermissionService.openNotificationSettings in lib/features/settings/presentation/settings_screen.dart
- [ ] T037 [US3] Add localized notification allowed, denied, blocked, unavailable, refresh, and device-settings copy to lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb

**Checkpoint**: User Story 3 is fully functional and testable independently.

---

## Phase 6: User Story 4 - Understand and Control Local Data (Priority: P2)

**Goal**: Users understand local-only medication/reminder storage, can cancel deletion safely, can confirm deletion deliberately, and can recover deleted local reminder data within 30 seconds.

**Independent Test**: Review privacy explanation, start deletion, cancel deletion, confirm deletion, recover within 30 seconds, and verify expired recovery and failure states.

### Tests for User Story 4

- [ ] T038 [P] [US4] Add unit tests for snapshot, hasLocalReminderData, delete, cancel-not-delete, restore, expire, and failure behavior in test/features/settings/data_control_service_test.dart
- [ ] T039 [P] [US4] Add widget tests for privacy explanation, no-data state, confirmation cancel, confirmed delete, recovery action, expired recovery, restart-during-recovery unavailable state, and failure messages in test/features/settings/settings_data_control_test.dart
- [ ] T040 [P] [US4] Add widget test proving destructive confirmation describes medications, schedules, due reminders, handling state, and history in test/features/settings/settings_data_control_test.dart

### Implementation for User Story 4

- [ ] T041 [US4] Implement LocalReminderDataControlService snapshot/delete/restore/expiry workflow in lib/features/settings/data/local_reminder_data_control_service.dart
- [ ] T042 [US4] Ensure LocalReminderDataControlService cancels scheduled notifications and due/later notifications during deletion in lib/features/settings/data/local_reminder_data_control_service.dart
- [ ] T043 [P] [US4] Implement DataDeletionConfirmationDialog with clear cancel and destructive confirm actions in lib/features/settings/presentation/data_deletion_confirmation_dialog.dart
- [ ] T044 [US4] Implement privacy explanation and local data control UI states in lib/features/settings/presentation/settings_screen.dart
- [ ] T045 [US4] Wire LocalReminderDataControlService into PillReminderApp and SettingsScreen from existing medication repositories and scheduler in lib/main.dart
- [ ] T046 [US4] Add localized privacy, delete confirmation, no-data, success, undo, expired, restore success, delete failure, and restore failure copy to lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb

**Checkpoint**: User Story 4 is fully functional and testable independently.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Validate the feature across localization, accessibility, privacy, performance, and regression surfaces.

- [ ] T047 [P] Run dart format on lib/ and test/ and fix formatting issues in lib/features/settings/ and test/features/settings/
- [ ] T048 Run flutter gen-l10n and verify no generated localization diffs are missing in lib/l10n/app_localizations.dart, lib/l10n/app_localizations_en.dart, and lib/l10n/app_localizations_es.dart
- [ ] T049 Run flutter analyze and fix analyzer issues in lib/ and test/
- [ ] T050 Run flutter test and fix failing tests in test/
- [ ] T051 [P] Complete manual notification permission, large text, screen reader, offline, restart, and 30-second recovery verification in specs/007-settings-privacy/quickstart.md
- [ ] T052 [P] Review settings copy against docs/ux-design.md and adjust ARB strings in lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb
- [ ] T053 [P] Review privacy behavior for no accounts, ads, tracking, backup, sync, sharing, analytics, donation, or remote services in specs/007-settings-privacy/quickstart.md
- [ ] T054 [P] Verify settings render, notification refresh, delete, and restore performance targets and record results in specs/007-settings-privacy/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Stories (Phase 3+)**: All depend on Foundational completion.
- **Polish (Phase 7)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - no dependency on other stories.
- **User Story 2 (P1)**: Can start after Foundational - integrates with the settings surface from US1 but remains testable by itself.
- **User Story 3 (P2)**: Can start after Foundational - integrates with the settings surface from US1 but remains testable by itself.
- **User Story 4 (P2)**: Can start after Foundational - integrates with the settings surface from US1 and foundational data-control contracts.

### Within Each User Story

- Tests should be written first and fail before implementation.
- Domain/data contracts before services.
- Services before UI integration.
- Localization keys before generated localization verification.
- Story complete before moving to the next priority unless working in parallel.

### Parallel Opportunities

- T002, T003, and T004 can run in parallel after T001.
- T005, T006, T007, and T015 can run in parallel.
- Repository interface updates T008 through T012 touch different files and can be split across developers.
- After Phase 2, US1, US2, US3, and US4 can be worked independently, with UI integration coordinated through lib/features/settings/presentation/settings_screen.dart.
- Test tasks marked [P] within each story can run in parallel with each other.
- T051 through T054 can run in parallel after automated verification tasks are stable.

---

## Parallel Example: User Story 1

```bash
Task: "T016 [P] [US1] Add settings screen section visibility and no-account/no-ads/no-tracking widget tests in test/features/settings/settings_screen_test.dart"
Task: "T017 [P] [US1] Add large-text reflow and semantics order widget tests for settings sections in test/features/settings/settings_screen_accessibility_test.dart"
Task: "T018 [P] [US1] Add settings entry-point widget test from the main app app bar in test/widget_test.dart"
```

---

## Parallel Example: User Story 2

```bash
Task: "T024 [P] [US2] Add widget test for English to Español (Latinoamérica) settings language switch in test/features/settings/settings_language_test.dart"
Task: "T025 [P] [US2] Add widget test for Español (Latinoamérica) to English settings language switch in test/features/settings/settings_language_test.dart"
Task: "T026 [P] [US2] Add persistence test for selected language after app reload in test/features/settings/settings_language_test.dart"
```

---

## Parallel Example: User Story 3

```bash
Task: "T031 [P] [US3] Add notification allowed, denied, blocked, and unavailable rendering tests in test/features/settings/settings_notification_status_test.dart"
Task: "T032 [P] [US3] Add notification refresh and open-device-settings action tests using FakeNotificationPermissionService in test/features/settings/settings_notification_status_test.dart"
```

---

## Parallel Example: User Story 4

```bash
Task: "T038 [P] [US4] Add unit tests for snapshot, hasLocalReminderData, delete, cancel-not-delete, restore, expire, and failure behavior in test/features/settings/data_control_service_test.dart"
Task: "T039 [P] [US4] Add widget tests for privacy explanation, no-data state, confirmation cancel, confirmed delete, recovery action, expired recovery, and failure messages in test/features/settings/settings_data_control_test.dart"
Task: "T040 [P] [US4] Add widget test proving destructive confirmation describes medications, schedules, due reminders, handling state, and history in test/features/settings/settings_data_control_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate settings is reachable, clear, accessible, localized, and free of account/ad/tracking prompts.

### Incremental Delivery

1. Complete Setup + Foundational.
2. Add User Story 1 and validate the settings surface.
3. Add User Story 2 and validate language switching and persistence.
4. Add User Story 3 and validate notification status states.
5. Add User Story 4 and validate local privacy, deletion, and recovery.
6. Complete Polish and cross-cutting checks.

### Parallel Team Strategy

1. Team completes Setup + Foundational together.
2. Once Foundational is done:
   - Developer A: US1 settings shell and accessibility.
   - Developer B: US2 language switching.
   - Developer C: US3 notification status.
   - Developer D: US4 data-control service and destructive flow.
3. Coordinate any concurrent edits to lib/features/settings/presentation/settings_screen.dart before final integration.

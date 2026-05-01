# Tasks: Reminder Notification Handling

**Input**: Design documents from `specs/004-reminder-notification-handling/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required for due reminders, medication data, notification actions,
persistence, permissions, accessibility states, localization, privacy, and
regressions per the project constitution.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the reminder handling file structure, fakes, and localization placeholders needed by all stories.

- [X] T001 Create due reminder data files in `lib/features/medications/data/due_reminder_repository.dart` and `lib/features/medications/data/local_due_reminder_repository.dart`
- [X] T002 [P] Create due reminder domain files in `lib/features/medications/domain/due_reminder.dart` and `lib/features/medications/domain/reminder_handling_preferences.dart`
- [X] T003 [P] Create reminder handling presentation files in `lib/features/medications/presentation/due_reminder_actions.dart`, `lib/features/medications/presentation/due_reminder_banner.dart`, `lib/features/medications/presentation/due_reminder_screen.dart`, and `lib/features/medications/presentation/reminder_handling_settings.dart`
- [X] T004 [P] Create reminder handling service files in `lib/services/reminder_action_handler.dart` and `lib/services/reminder_due_reconciler.dart`
- [X] T005 [P] Create reminder handling test files in `test/features/medications/due_reminder_state_test.dart`, `test/features/medications/due_reminder_repository_test.dart`, `test/features/medications/reminder_action_handler_test.dart`, `test/features/medications/reminder_due_reconciler_test.dart`, `test/features/medications/reminder_handling_preferences_test.dart`, and `test/features/medications/due_reminder_screen_test.dart`
- [X] T006 [P] Create reminder handling fake files in `test/features/medications/fakes/fake_due_reminder_repository.dart`, `test/features/medications/fakes/fake_reminder_action_handler.dart`, and `test/features/medications/fakes/fake_reminder_notification_scheduler.dart`
- [X] T007 [P] Add placeholder reminder handling localization keys in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared domain, persistence, preferences, scheduler hooks, and fixtures that MUST be complete before any user story can be implemented.

**CRITICAL**: No user story work can begin until this phase is complete.

- [X] T008 [P] Define `DueReminderState`, `ReminderActionType`, `ReminderActionSource`, and `DueReminder` with JSON serialization in `lib/features/medications/domain/due_reminder.dart`
- [X] T009 [P] Define `RemindAgainLaterRequest`, `ReminderOutcome`, and `NotificationActionRequest` value types in `lib/features/medications/domain/due_reminder.dart`
- [X] T010 [P] Define `ReminderHandlingPreferences` with a 10-minute default app-wide interval in `lib/features/medications/domain/reminder_handling_preferences.dart`
- [X] T011 Define `DueReminderRepository` load/upsert/update/lookup/delete contract by medication id, schedule id, and scheduled occurrence in `lib/features/medications/data/due_reminder_repository.dart`
- [X] T012 Implement local JSON due reminder repository skeleton with delete-by-medication and delete-by-schedule support using `shared_preferences` in `lib/features/medications/data/local_due_reminder_repository.dart`
- [X] T013 Add fake due reminder repository behavior for unit and widget tests in `test/features/medications/fakes/fake_due_reminder_repository.dart`
- [X] T014 [P] Add due reminder, medication, schedule, and notification action fixture builders in `test/features/medications/due_reminder_test_fixtures.dart`
- [X] T015 Extend `ReminderNotificationScheduler` with due-reminder notification/action payload concepts, Android/iOS action/category registration for taken/skip/remind-again-later, and later-reminder scheduling methods in `lib/services/reminder_notification_scheduler.dart`
- [X] T016 Register local due reminder repository and reminder handling dependencies in `lib/main.dart`
- [X] T017 Generate localization classes after adding reminder handling keys by running `flutter gen-l10n` for `lib/l10n/app_localizations*.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Receive a Due Reminder (Priority: P1) MVP

**Goal**: Users receive a local due medication reminder with medication name, scheduled time, and dosage label when available, even when offline.

**Independent Test**: Save an active medication with a schedule, let a reminder become due while offline, and confirm one local due reminder and notification copy with medication name, scheduled time, and optional dosage label.

### Tests for User Story 1

- [X] T018 [P] [US1] Add unit tests for due reminder id uniqueness by medication id and scheduled occurrence in `test/features/medications/due_reminder_state_test.dart`
- [X] T019 [P] [US1] Add repository tests for creating, loading, reloading, and deleting unresolved due reminders by medication id and schedule id in `test/features/medications/due_reminder_repository_test.dart`
- [X] T020 [P] [US1] Add scheduler tests for medication name, scheduled time, dosage label, and missing-dosage notification copy in `test/features/medications/reminder_notification_scheduler_test.dart`
- [X] T021 [US1] Add reconciler test for creating one due reminder from an active saved schedule while offline in `test/features/medications/reminder_due_reconciler_test.dart`
- [X] T022 [US1] Add widget test for opening an in-app due reminder with medication name, scheduled time, and optional dosage label in `test/features/medications/due_reminder_screen_test.dart`

### Implementation for User Story 1

- [X] T023 [US1] Implement due reminder id generation and unresolved state creation rules in `lib/features/medications/domain/due_reminder.dart`
- [X] T024 [US1] Implement local due reminder create/load/reload/delete behavior in `lib/features/medications/data/local_due_reminder_repository.dart`
- [X] T025 [US1] Implement due reminder reconciliation from active reminder schedules and medications in `lib/services/reminder_due_reconciler.dart`
- [X] T026 [US1] Update local notification scheduling to include due reminder identity, medication name, scheduled time, and optional dosage label in `lib/services/reminder_notification_scheduler.dart`
- [X] T027 [US1] Implement in-app due reminder screen display for medication name, scheduled time, optional dosage label, and unresolved state in `lib/features/medications/presentation/due_reminder_screen.dart`
- [X] T028 [US1] Add due reminder entry/banner for unresolved reminders in `lib/features/medications/presentation/due_reminder_banner.dart`
- [X] T029 [US1] Add English, Spanish, and Latin American Spanish strings for notification title/body, due reminder display, scheduled time, and missing dosage behavior in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 1 is functional and testable as the MVP.

---

## Phase 4: User Story 2 - Record What Happened (Priority: P1)

**Goal**: Users can mark a due reminder taken, skip it, or be reminded again later from notification actions or the app, with one clear final or pending state.

**Independent Test**: Trigger a due reminder, complete each action from notification and in-app paths, and confirm taken/skipped are final while remind-again-later uses the app-wide interval and avoids overlap.

### Tests for User Story 2

- [X] T030 [P] [US2] Add state transition tests for taken, skipped, and remind-again-later outcomes in `test/features/medications/due_reminder_state_test.dart`
- [X] T031 [P] [US2] Add preference tests for default 10-minute interval and changed app-wide interval in `test/features/medications/reminder_handling_preferences_test.dart`
- [X] T032 [P] [US2] Add action handler tests for in-app taken, skipped, and remind-again-later actions in `test/features/medications/reminder_action_handler_test.dart`
- [X] T033 [US2] Add notification action handler tests for taken, skipped, remind-again-later, platform action payload routing, and stale final-state actions in `test/features/medications/reminder_action_handler_test.dart`
- [X] T034 [US2] Add widget tests for due reminder action buttons and resulting state text in `test/features/medications/due_reminder_screen_test.dart`

### Implementation for User Story 2

- [X] T035 [US2] Implement final outcome and pending remind-again-later transition methods in `lib/features/medications/domain/due_reminder.dart`
- [X] T036 [US2] Implement local persistence for taken, skipped, and remind-again-later updates in `lib/features/medications/data/local_due_reminder_repository.dart`
- [X] T037 [US2] Implement app-wide reminder handling preference load/save behavior in `lib/features/medications/domain/reminder_handling_preferences.dart` and `lib/features/medications/data/local_due_reminder_repository.dart`
- [X] T038 [US2] Implement shared reminder action handler for notification and in-app actions in `lib/services/reminder_action_handler.dart`
- [X] T039 [US2] Implement Android/iOS notification action/category registration, payload routing hooks, and later-reminder scheduling/cancellation for remind-again-later requests in `lib/services/reminder_notification_scheduler.dart`
- [X] T040 [US2] Implement taken, skip, and remind-again-later controls in `lib/features/medications/presentation/due_reminder_actions.dart`
- [X] T041 [US2] Wire action controls and state refresh into `lib/features/medications/presentation/due_reminder_screen.dart`
- [X] T042 [US2] Add app-wide remind-again-later interval setting UI in `lib/features/medications/presentation/reminder_handling_settings.dart`
- [X] T043 [US2] Add English, Spanish, and Latin American Spanish strings for taken, skipped, remind again later, action timestamps, and interval settings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 2 works independently and preserves User Story 1.

---

## Phase 5: User Story 3 - Keep Reminder State Reliable (Priority: P2)

**Goal**: Due reminder state stays consistent without duplicates or contradictions when offline, restarted, or notification permission changes.

**Independent Test**: Trigger reminders around offline use, app restart, device restart, stale notification actions, repeated remind-again-later actions, and notification permission changes, then confirm one consistent state per medication and scheduled time.

### Tests for User Story 3

- [X] T044 [P] [US3] Add repository idempotency tests for duplicate due reminder creation attempts in `test/features/medications/due_reminder_repository_test.dart`
- [X] T045 [P] [US3] Add action handler tests for contradictory taken/skipped actions and stale notification actions in `test/features/medications/reminder_action_handler_test.dart`
- [X] T046 [P] [US3] Add remind-again-later overlap prevention tests in `test/features/medications/reminder_action_handler_test.dart`
- [X] T047 [US3] Add reconciler tests for app restart recovery and elapsed reminders when notifications were disabled in `test/features/medications/reminder_due_reconciler_test.dart`
- [X] T048 [US3] Add scheduler tests for permission skipped, denied, blocked, unavailable, operating-system revocation mapped to denied/blocked, and re-enabled future delivery states in `test/features/medications/reminder_notification_scheduler_test.dart`
- [X] T049 [US3] Add widget test for disabled notification guidance while preserving in-app taken/skip/remind-again-later actions in `test/features/medications/due_reminder_screen_test.dart`

### Implementation for User Story 3

- [X] T050 [US3] Enforce idempotent upsert by medication id and scheduled occurrence in `lib/features/medications/data/local_due_reminder_repository.dart`
- [X] T051 [US3] Enforce final-state conflict rules and stale action no-op behavior in `lib/services/reminder_action_handler.dart`
- [X] T052 [US3] Enforce single pending remind-again-later request per due reminder in `lib/services/reminder_action_handler.dart`
- [X] T053 [US3] Implement startup and foreground due reminder reconciliation in `lib/services/reminder_due_reconciler.dart`
- [X] T054 [US3] Integrate due reminder reconciliation with app startup in `lib/main.dart`
- [X] T055 [US3] Handle notification permission skipped, denied, blocked, unavailable, operating-system revocation mapped to denied/blocked, and re-enabled delivery states in `lib/services/reminder_notification_scheduler.dart`
- [X] T056 [US3] Show calm permission guidance for due reminders that cannot currently appear as notifications in `lib/features/medications/presentation/due_reminder_screen.dart`
- [X] T057 [US3] Add English, Spanish, and Latin American Spanish strings for permission-disabled guidance, stale action fallback, and restart recovery states in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 3 works independently and preserves previous stories.

---

## Phase 6: User Story 4 - Use an Accessible Reminder Experience (Priority: P3)

**Goal**: Users can understand and act on due reminders with large text, screen readers, large touch targets, calm copy, and English or Latin American Spanish formatting.

**Independent Test**: Complete due reminder handling with large text and screen reader settings in English and Latin American Spanish, confirming no clipped content, overlapping controls, unlabeled actions, or non-localized times.

### Tests for User Story 4

- [X] T058 [P] [US4] Add large-text widget tests for due reminder details and actions in `test/features/medications/due_reminder_screen_test.dart`
- [X] T059 [P] [US4] Add screen-reader semantics tests for medication name, dosage label, scheduled time, state, and actions in `test/features/medications/due_reminder_screen_test.dart`
- [X] T060 [US4] Add non-color-only state and permission guidance tests in `test/features/medications/due_reminder_screen_test.dart`
- [X] T061 [US4] Add localization widget tests for English and Latin American Spanish notification/in-app copy and time formatting in `test/features/medications/due_reminder_screen_test.dart`

### Implementation for User Story 4

- [X] T062 [US4] Apply `docs/ux-design.md` layout, calm tone, spacing, and 56px preferred primary actions in `lib/features/medications/presentation/due_reminder_screen.dart`
- [X] T063 [US4] Add semantic labels, focus behavior, and logical reading order to action controls in `lib/features/medications/presentation/due_reminder_actions.dart`
- [X] T064 [US4] Ensure large text does not clip reminder details, state text, permission guidance, or actions in `lib/features/medications/presentation/due_reminder_screen.dart`
- [X] T065 [US4] Ensure due reminder state and permission status are communicated by text and semantics, not color alone, in `lib/features/medications/presentation/due_reminder_banner.dart` and `lib/features/medications/presentation/due_reminder_screen.dart`
- [X] T066 [US4] Ensure locale-aware scheduled time and action time formatting in `lib/features/medications/presentation/due_reminder_screen.dart` and `lib/services/reminder_notification_scheduler.dart`
- [X] T067 [US4] Finalize English, Spanish, and Latin American Spanish reminder handling strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 4 works independently and all user stories are functional.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verify notification handling, accessibility, localization, privacy, local-first behavior, performance, and documentation across the full reminder handling experience.

- [ ] T068 [P] Review reminder handling UI against `docs/ux-design.md` and document manual findings in `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T069 [P] Review English, Spanish, and Latin American Spanish reminder handling strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`
- [X] T070 [P] Add or update accessibility regression coverage for large text, semantics, focus, touch targets, and non-color-only status in `test/features/medications/due_reminder_screen_test.dart`
- [ ] T071 Add manual Android notification delivery and action verification notes for taken, skipped, remind-again-later, permission disabled, and permission re-enabled paths in `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T072 Add manual iOS notification delivery and action verification notes for taken, skipped, remind-again-later, permission disabled, and permission re-enabled paths in `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T073 Verify offline due reminder handling, app restart recovery, stale notification actions, and repeated remind-again-later behavior manually using `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T074 Verify due reminder view opens within 1 second and startup reconciliation adds no more than 300ms for typical v1 data volumes using `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T075 Document local due reminder storage, retention, deletion, sharing, backup, analytics, donation, and remote-service behavior in `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T076 Verify medication deletion and schedule removal clear associated due reminders, outcomes, and pending remind-again-later requests using `specs/004-reminder-notification-handling/quickstart.md`
- [ ] T077 Verify representative users can mark taken, skip, or remind again later in under 30 seconds using `specs/004-reminder-notification-handling/quickstart.md`
- [X] T078 Run `flutter gen-l10n` from repository root for reminder handling localization files in `lib/l10n/`
- [X] T079 Run `dart format lib test` from repository root for `lib/` and `test/`
- [X] T080 Run `flutter analyze` from repository root for `lib/`, `test/`, and generated localization coverage
- [X] T081 Run full `flutter test` from repository root for all reminder handling, reminder schedule, medication, setup, and widget tests

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion - MVP scope.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and integrates with due reminder state from US1.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and is easiest after US1/US2 state transitions exist.
- **User Story 4 (Phase 6)**: Depends on Foundational completion and can be refined across US1-US3 UI surfaces.
- **Polish (Phase 7)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational phase; no dependency on other stories.
- **User Story 2 (P1)**: Can start after Foundational phase; easiest after US1 due reminder display and repository behavior exist.
- **User Story 3 (P2)**: Can start after Foundational phase; depends on the same domain rules as US1/US2 for full validation.
- **User Story 4 (P3)**: Can start after Foundational phase; easiest after US1-US3 UI states exist.

### Within Each User Story

- Required tests MUST be written and fail before implementation tasks in that story.
- Domain state must exist before repository and service behavior depends on it.
- Repository behavior must exist before action handling and reconciliation rely on it.
- Notification actions and in-app actions must route through the shared action handler.
- UI must use localized strings rather than hard-coded user-facing copy.
- Story checkpoint should pass before moving to the next priority.

## Parallel Opportunities

- T002, T003, T004, T005, T006, and T007 can run in parallel during Setup.
- T008, T009, T010, and T014 can run in parallel during Foundational.
- T018, T019, and T020 can run in parallel before US1 implementation.
- T030, T031, and T032 can run in parallel before US2 implementation.
- T044, T045, and T046 can run in parallel before US3 implementation.
- T058 and T059 can run in parallel before US4 implementation.
- T068, T069, and T070 can run in parallel during Polish.

## Parallel Example: User Story 1

```bash
Task: "T018 [P] [US1] Add unit tests for due reminder id uniqueness by medication id and scheduled occurrence in test/features/medications/due_reminder_state_test.dart"
Task: "T019 [P] [US1] Add repository tests for creating, loading, and reloading unresolved due reminders in test/features/medications/due_reminder_repository_test.dart"
Task: "T020 [P] [US1] Add scheduler tests for medication name, scheduled time, dosage label, and missing-dosage notification copy in test/features/medications/reminder_notification_scheduler_test.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T030 [P] [US2] Add state transition tests for taken, skipped, and remind-again-later outcomes in test/features/medications/due_reminder_state_test.dart"
Task: "T031 [P] [US2] Add preference tests for default 10-minute interval and changed app-wide interval in test/features/medications/reminder_handling_preferences_test.dart"
Task: "T032 [P] [US2] Add action handler tests for in-app taken, skipped, and remind-again-later actions in test/features/medications/reminder_action_handler_test.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T044 [P] [US3] Add repository idempotency tests for duplicate due reminder creation attempts in test/features/medications/due_reminder_repository_test.dart"
Task: "T045 [P] [US3] Add action handler tests for contradictory taken/skipped actions and stale notification actions in test/features/medications/reminder_action_handler_test.dart"
Task: "T046 [P] [US3] Add remind-again-later overlap prevention tests in test/features/medications/reminder_action_handler_test.dart"
```

## Parallel Example: User Story 4

```bash
Task: "T058 [P] [US4] Add large-text widget tests for due reminder details and actions in test/features/medications/due_reminder_screen_test.dart"
Task: "T059 [P] [US4] Add screen-reader semantics tests for medication name, dosage label, scheduled time, state, and actions in test/features/medications/due_reminder_screen_test.dart"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate active medication due reminder creation, notification copy, local persistence, offline handling, and missing-dosage behavior.

### Incremental Delivery

1. Deliver US1 for local due reminder creation and clear notification content.
2. Add US2 for taken, skipped, remind-again-later, and app-wide interval configuration.
3. Add US3 for offline/restart/permission recovery and idempotency hardening.
4. Add US4 for accessibility, UX baseline, and localization polish.
5. Run Polish tasks before release.

### Notes

- Keep Firebase, accounts, sync, backup, import/export, caregiver sharing, refill tracking, adherence analytics, and clinical advice out of this feature implementation.
- Keep per-medication snooze intervals and choose-each-time snooze duration choices out of scope.
- Keep platform notification behavior behind `ReminderNotificationScheduler`.
- Route notification actions and in-app actions through `ReminderActionHandler`.
- Follow `docs/ux-design.md` for calm copy, simple flow shape, spacing, large touch targets, focus, and pressure-free choices.

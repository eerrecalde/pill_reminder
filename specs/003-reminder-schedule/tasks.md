# Tasks: Reminder Schedule

**Input**: Design documents from `specs/003-reminder-schedule/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required for reminder scheduling, medication data, persistence,
permissions, accessibility states, localization, privacy, and regressions per
the project constitution.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add the scheduling dependency, feature files, test files, and localization placeholders needed by all stories.

- [ ] T001 Add `flutter_local_notifications` dependency and native notification scheduling setup in `pubspec.yaml`, `android/app/src/main/AndroidManifest.xml`, Android Gradle files, `ios/Runner/AppDelegate.swift`, and `ios/Runner/Info.plist`
- [ ] T002 Create reminder schedule data files in `lib/features/medications/data/reminder_schedule_repository.dart` and `lib/features/medications/data/local_reminder_schedule_repository.dart`
- [ ] T003 [P] Create reminder schedule domain files in `lib/features/medications/domain/reminder_schedule.dart`, `lib/features/medications/domain/reminder_schedule_draft.dart`, and `lib/features/medications/domain/reminder_schedule_validation.dart`
- [ ] T004 [P] Create reminder schedule presentation files in `lib/features/medications/presentation/reminder_schedule_screen.dart`, `lib/features/medications/presentation/reminder_schedule_review.dart`, and `lib/features/medications/presentation/reminder_time_selector.dart`
- [ ] T005 [P] Create notification scheduler service file in `lib/services/reminder_notification_scheduler.dart`
- [ ] T006 [P] Create reminder schedule test files in `test/features/medications/reminder_schedule_validation_test.dart`, `test/features/medications/reminder_schedule_repository_test.dart`, `test/features/medications/reminder_schedule_screen_test.dart`, and `test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T007 [P] Create reminder schedule fakes in `test/features/medications/fakes/fake_reminder_schedule_repository.dart` and `test/features/medications/fakes/fake_reminder_notification_scheduler.dart`
- [ ] T008 [P] Add reminder schedule localization placeholder keys in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared schedule domain, validation, repository, scheduler, and test fakes that MUST be complete before any user story can be implemented.

**CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T009 [P] Define `ReminderNotificationDeliveryState` values in `lib/features/medications/domain/reminder_schedule.dart`
- [ ] T010 Define `ReminderTime` and `ReminderSchedule` entities with JSON serialization in `lib/features/medications/domain/reminder_schedule.dart`
- [ ] T011 [P] Define `ReminderScheduleDraft` with selected medication, selected times, optional end date, permission status, validation state, and outcome in `lib/features/medications/domain/reminder_schedule_draft.dart`
- [ ] T012 [P] Implement validation result types for inactive medication, missing times, duplicate times, daily limit, and invalid end date in `lib/features/medications/domain/reminder_schedule_validation.dart`
- [ ] T013 Define `ReminderScheduleRepository` load/save/delete contract by medication id in `lib/features/medications/data/reminder_schedule_repository.dart`
- [ ] T014 Implement local JSON schedule repository skeleton using `shared_preferences` in `lib/features/medications/data/local_reminder_schedule_repository.dart`
- [ ] T015 Define `ReminderNotificationScheduler` interface and scheduling result states in `lib/services/reminder_notification_scheduler.dart`
- [ ] T016 Implement no-op/deferred scheduler behavior for unavailable permission states in `lib/services/reminder_notification_scheduler.dart`
- [ ] T017 [P] Add fake reminder schedule repository behavior for widget tests in `test/features/medications/fakes/fake_reminder_schedule_repository.dart`
- [ ] T018 [P] Add fake reminder notification scheduler for widget tests in `test/features/medications/fakes/fake_reminder_notification_scheduler.dart`
- [ ] T019 [P] Add schedule fixture builders for active medications, inactive medications, times, and schedules in `test/features/medications/reminder_schedule_test_fixtures.dart`
- [ ] T020 Wire generated localization after adding schedule keys by running `flutter gen-l10n` for `lib/l10n/app_localizations*.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Schedule Daily Reminder Times (Priority: P1) MVP

**Goal**: Users can create or edit one daily schedule for an active medication with one to four reminder times, optional end date, review, local save, and restart-safe persistence.

**Independent Test**: Choose an active medication, select one or more daily times, review indefinite or optional end-date behavior, save offline, and confirm the same schedule loads after app restart.

### Tests for User Story 1

- [ ] T021 [P] [US1] Add validation unit tests for one to four unique daily times and sorted review order in `test/features/medications/reminder_schedule_validation_test.dart`
- [ ] T022 [P] [US1] Add validation unit tests for indefinite default and valid optional end date in `test/features/medications/reminder_schedule_validation_test.dart`
- [ ] T023 [P] [US1] Add repository unit test for saving, loading, editing, and deleting a schedule by medication id in `test/features/medications/reminder_schedule_repository_test.dart`
- [ ] T024 [US1] Add repository unit test for preserving reminder times, optional end date, created date, and updated date after reload in `test/features/medications/reminder_schedule_repository_test.dart`
- [ ] T025 [P] [US1] Add widget test for opening schedule flow from an active medication in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T026 [US1] Add widget test for selecting one daily time, reviewing indefinite summary, saving, and showing saved schedule in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T027 [US1] Add widget tests for selecting four daily times with optional end date, sorted review summary, and canceling/leaving without creating or changing a saved schedule in `test/features/medications/reminder_schedule_screen_test.dart`

### Implementation for User Story 1

- [ ] T028 [US1] Implement schedule validation for active medication, one to four times, sorted times, indefinite default, and optional end date in `lib/features/medications/domain/reminder_schedule_validation.dart`
- [ ] T029 [US1] Implement local schedule save/load/edit/delete behavior in `lib/features/medications/data/local_reminder_schedule_repository.dart`
- [ ] T030 [US1] Implement reminder time selector UI with add/edit/remove controls and 56px preferred touch targets in `lib/features/medications/presentation/reminder_time_selector.dart`
- [ ] T031 [US1] Implement schedule review UI for medication name, ordered times, indefinite text, optional end date, and save/cancel actions in `lib/features/medications/presentation/reminder_schedule_review.dart`
- [ ] T032 [US1] Implement reminder schedule screen state flow for time selection, optional end date, review, save, edit existing schedule, and cancel in `lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T033 [US1] Wire active medication schedule entry from medication list in `lib/features/medications/presentation/medication_list_section.dart`
- [ ] T034 [US1] Register reminder schedule repository and scheduler dependencies in `lib/main.dart`
- [ ] T035 [US1] Add English, Spanish, and Latin American Spanish strings for schedule entry, time selection, optional end date, review, save, edit, delete, and cancel in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 1 is functional and testable as the MVP.

---

## Phase 4: User Story 2 - Understand Reminder Availability (Priority: P2)

**Goal**: Users understand whether reminder alerts can currently be delivered, can save schedules when notifications are unavailable, and saved schedules become deliverable automatically after permission is enabled.

**Independent Test**: Save schedules with granted, skipped, denied, blocked, and unavailable notification states, then enable permission and confirm saved schedules become deliverable without recreation.

### Tests for User Story 2

- [ ] T036 [P] [US2] Add scheduler unit tests for granted, permission-needed, blocked, and unavailable delivery states in `test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T037 [P] [US2] Add widget test for granted notification review message in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T038 [US2] Add widget test for skipped/denied/blocked/unavailable notification guidance while still allowing save in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T039 [US2] Add widget test for saved schedule becoming deliverable automatically after permission is enabled in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T040 [US2] Add privacy regression test proving no account, sync, backup, analytics, donation, sharing, or remote-service prompts appear in `test/features/medications/reminder_schedule_screen_test.dart`

### Implementation for User Story 2

- [ ] T041 [US2] Implement `flutter_local_notifications` initialization and local scheduling adapter behind `ReminderNotificationScheduler` in `lib/services/reminder_notification_scheduler.dart`
- [ ] T042 [US2] Connect `NotificationPermissionService` status checks to schedule review and save behavior in `lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T043 [US2] Show calm notification deliverability, permission-needed, blocked, and unavailable guidance in `lib/features/medications/presentation/reminder_schedule_review.dart`
- [ ] T044 [US2] Trigger scheduler re-evaluation for saved schedules after notification permission becomes granted in `lib/services/reminder_notification_scheduler.dart`
- [ ] T045 [US2] Persist notification delivery state updates with saved schedules in `lib/features/medications/data/local_reminder_schedule_repository.dart`
- [ ] T046 [US2] Add localized notification delivery and recovery strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 2 works independently and preserves User Story 1.

---

## Phase 5: User Story 3 - Recover From Incomplete or Invalid Choices (Priority: P2)

**Goal**: Users receive clear validation for missing times, duplicate times, fifth time, inactive medication, and invalid end date while valid selections remain intact.

**Independent Test**: Attempt each invalid schedule choice, confirm plain-language visible and screen-reader-readable feedback, correct the issue, and verify valid selections remain selected through review.

### Tests for User Story 3

- [ ] T047 [P] [US3] Add validation unit tests for missing reminder time and preserving valid selections in `test/features/medications/reminder_schedule_validation_test.dart`
- [ ] T048 [P] [US3] Add validation unit tests for duplicate reminder times and fifth reminder time in `test/features/medications/reminder_schedule_validation_test.dart`
- [ ] T049 [P] [US3] Add validation unit tests for inactive medication and invalid optional end date in `test/features/medications/reminder_schedule_validation_test.dart`
- [ ] T050 [US3] Add widget test for no-time validation preserving optional end date and selected medication in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T051 [US3] Add widget test for duplicate/fifth-time validation using text and semantics, not color alone in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T052 [US3] Add widget test for inactive medication guidance blocking schedule save in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T053 [US3] Add widget test for invalid end-date validation and correction in `test/features/medications/reminder_schedule_screen_test.dart`

### Implementation for User Story 3

- [ ] T054 [US3] Wire blocking validation into save and review transitions in `lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T055 [US3] Implement validation message display with semantic announcements in `lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T056 [US3] Implement duplicate and daily-limit feedback in `lib/features/medications/presentation/reminder_time_selector.dart`
- [ ] T057 [US3] Implement inactive medication guidance and route back to medication editing/list context in `lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T058 [US3] Implement invalid optional end-date feedback in `lib/features/medications/presentation/reminder_schedule_review.dart`
- [ ] T059 [US3] Add localized validation strings for missing time, duplicate time, fifth time, inactive medication, and invalid end date in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 3 works independently and preserves previous stories.

---

## Phase 6: User Story 4 - Use an Accessible, Calm Schedule Flow (Priority: P3)

**Goal**: Users can complete the schedule flow with large text, screen readers, large touch targets, visible focus, high contrast, and English or Latin American Spanish date/time formatting.

**Independent Test**: Complete the schedule flow with large text and screen-reader navigation in English and Latin American Spanish, confirming no clipped text, overlapping controls, unlabeled actions, or non-localized date/time output.

### Tests for User Story 4

- [ ] T060 [P] [US4] Add widget test for large text schedule flow with no clipped review controls in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T061 [P] [US4] Add widget test for screen-reader labels and logical order on time selector, review, validation, save, and cancel controls in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T062 [US4] Add widget test for non-color-only selection, validation, delivery state, and inactive medication messages in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T063 [US4] Add localization widget test for English and Latin American Spanish schedule summaries and date/time formatting in `test/features/medications/reminder_schedule_screen_test.dart`

### Implementation for User Story 4

- [ ] T064 [US4] Apply `docs/ux-design.md` layout, calm tone, spacing, and 56px preferred primary actions in `lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T065 [US4] Add semantic labels, focus behavior, and logical reading order to time controls in `lib/features/medications/presentation/reminder_time_selector.dart`
- [ ] T066 [US4] Add semantic labels, focus behavior, and logical reading order to review content and actions in `lib/features/medications/presentation/reminder_schedule_review.dart`
- [ ] T067 [US4] Ensure locale-aware time and date formatting for schedule summaries in `lib/features/medications/presentation/reminder_schedule_review.dart`
- [ ] T068 [US4] Finalize English, Spanish, and Latin American Spanish schedule strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 4 works independently and all user stories are functional.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verify notification scheduling, accessibility, localization, privacy, local-first behavior, performance, and documentation across the full reminder schedule experience.

- [ ] T069 [P] Review reminder schedule UI against `docs/ux-design.md` and document any deviations in `specs/003-reminder-schedule/quickstart.md`
- [ ] T070 [P] Review all reminder schedule English, Spanish, and Latin American Spanish strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`
- [ ] T071 [P] Add or update accessibility regression coverage for large text, focus labels, validation announcements, and non-color-only status in `test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T072 Add manual Android notification verification notes for granted and denied/reenabled paths in `specs/003-reminder-schedule/quickstart.md`
- [ ] T073 Add manual iOS notification verification notes for granted and denied/reenabled paths in `specs/003-reminder-schedule/quickstart.md`
- [ ] T074 Verify offline schedule save, app restart recovery, and four-time schedule review manually using `specs/003-reminder-schedule/quickstart.md`
- [ ] T075 Verify schedule flow opens within 1 second and save completes without perceptible delay using `specs/003-reminder-schedule/quickstart.md`
- [ ] T076 Document local schedule storage, retention, deletion, sharing, backup, analytics, donation, and remote-service behavior in `specs/003-reminder-schedule/quickstart.md`
- [ ] T077 Run `flutter gen-l10n` from repository root for schedule localization files in `lib/l10n/`
- [ ] T078 Run `dart format lib test` from repository root for `lib/` and `test/`
- [ ] T079 Run `flutter analyze` from repository root for `lib/`, `test/`, and generated localization coverage
- [ ] T080 Run full `flutter test` from repository root for all reminder schedule, medication, setup, and widget tests

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion - MVP scope.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and integrates with saved schedules from US1.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and can be developed alongside US2 after US1 screen scaffold exists.
- **User Story 4 (Phase 6)**: Depends on Foundational completion and can be refined across US1-US3 UI surfaces.
- **Polish (Phase 7)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational phase; no dependency on other stories.
- **User Story 2 (P2)**: Can start after Foundational phase; easiest after US1 save/review flow exists.
- **User Story 3 (P2)**: Can start after Foundational phase; easiest after US1 time selector and review flow exist.
- **User Story 4 (P3)**: Can start after Foundational phase; easiest after US1-US3 UI states exist.

### Within Each User Story

- Required tests MUST be written and fail before implementation tasks in that story.
- Domain validation and repository behavior must exist before UI relies on them.
- Notification scheduler side effects must stay behind `ReminderNotificationScheduler`.
- UI must use localized strings rather than hard-coded user-facing copy.
- Story checkpoint should pass before moving to the next priority.

## Parallel Opportunities

- T003, T004, T005, T006, T007, and T008 can run in parallel during Setup.
- T009, T011, T012, T017, T018, and T019 can run in parallel during Foundational.
- T021, T022, T023, and T025 can run in parallel before US1 implementation.
- T036 and T037 can run in parallel before US2 implementation.
- T047, T048, T049, and T050 can run in parallel before US3 implementation.
- T060 and T061 can run in parallel before US4 implementation.
- T069, T070, and T071 can run in parallel during Polish.

## Parallel Example: User Story 1

```bash
Task: "T021 [P] [US1] Add validation unit tests for one to four unique daily times and sorted review order in test/features/medications/reminder_schedule_validation_test.dart"
Task: "T022 [P] [US1] Add validation unit tests for indefinite default and valid optional end date in test/features/medications/reminder_schedule_validation_test.dart"
Task: "T023 [P] [US1] Add repository unit test for saving, loading, editing, and deleting a schedule by medication id in test/features/medications/reminder_schedule_repository_test.dart"
Task: "T025 [P] [US1] Add widget test for opening schedule flow from an active medication in test/features/medications/reminder_schedule_screen_test.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T036 [P] [US2] Add scheduler unit tests for granted, permission-needed, blocked, and unavailable delivery states in test/features/medications/reminder_notification_scheduler_test.dart"
Task: "T037 [P] [US2] Add widget test for granted notification review message in test/features/medications/reminder_schedule_screen_test.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T047 [P] [US3] Add validation unit tests for missing reminder time and preserving valid selections in test/features/medications/reminder_schedule_validation_test.dart"
Task: "T048 [P] [US3] Add validation unit tests for duplicate reminder times and fifth reminder time in test/features/medications/reminder_schedule_validation_test.dart"
Task: "T049 [P] [US3] Add validation unit tests for inactive medication and invalid optional end date in test/features/medications/reminder_schedule_validation_test.dart"
Task: "T050 [US3] Add widget test for no-time validation preserving optional end date and selected medication in test/features/medications/reminder_schedule_screen_test.dart"
```

## Parallel Example: User Story 4

```bash
Task: "T060 [P] [US4] Add widget test for large text schedule flow with no clipped review controls in test/features/medications/reminder_schedule_screen_test.dart"
Task: "T061 [P] [US4] Add widget test for screen-reader labels and logical order on time selector, review, validation, save, and cancel controls in test/features/medications/reminder_schedule_screen_test.dart"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate active medication schedule creation, review, local save, restart recovery, optional end date, and cancel behavior.

### Incremental Delivery

1. Deliver US1 for local daily schedule creation and review.
2. Add US2 for notification delivery state, unavailable-permission save, and automatic deliverability after permission enablement.
3. Add US3 for validation recovery and inactive medication blocking.
4. Add US4 for accessibility, UX baseline, and localization polish.
5. Run Polish tasks before release.

### Notes

- Keep Firebase, accounts, sync, backup, import/export, refill tracking, dose tracking, and clinical advice out of this feature implementation.
- Keep weekly, monthly, interval, as-needed, tapering, and start-date schedules out of scope.
- Keep notification platform behavior behind `ReminderNotificationScheduler`.
- Follow `docs/ux-design.md` for calm copy, simple flow shape, spacing, large touch targets, focus, and pressure-free choices.

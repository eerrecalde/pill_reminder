# Tasks: Today Dashboard

**Input**: Design documents from `/specs/004-today-dashboard/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Tests are required because this feature affects reminder behavior,
medication data, accessibility states, localization, permissions, persistence,
privacy, and notification suppression.

**Organization**: Tasks are grouped by user story to enable independent
implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel with other marked tasks in the same phase
- **[Story]**: User story label for story phases only
- All descriptions include exact file paths

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare shared test fixtures and localization files for dashboard work.

- [ ] T001 [P] Add dashboard fixture builders for medications, reminder schedules, and local dates in `test/features/medications/today_dashboard_test_fixtures.dart`
- [ ] T002 [P] Add a fake daily reminder handling repository scaffold in `test/features/medications/fakes/fake_daily_reminder_handling_repository.dart`
- [ ] T003 [P] Add dashboard localization key placeholders for English in `lib/l10n/app_en.arb`
- [ ] T004 [P] Add dashboard localization key placeholders for Spanish fallback in `lib/l10n/app_es.arb`
- [ ] T005 [P] Add dashboard localization key placeholders for Latin American Spanish in `lib/l10n/app_es_419.arb`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared domain, persistence, and notification contracts required before any dashboard story can be implemented.

**Critical**: No user story work can begin until this phase is complete.

- [ ] T006 Create daily handling domain model and JSON serialization in `lib/features/medications/domain/daily_reminder_handling.dart`
- [ ] T007 Create today dashboard domain types for item status, reminder item, section, action, and snapshot in `lib/features/medications/domain/today_dashboard.dart`
- [ ] T008 Create daily handling repository interface in `lib/features/medications/data/daily_reminder_handling_repository.dart`
- [ ] T009 Implement shared_preferences-backed daily handling repository in `lib/features/medications/data/local_daily_reminder_handling_repository.dart`
- [ ] T010 Add current-day alert suppression contract to the production reminder notification scheduler interface in `lib/services/reminder_notification_scheduler.dart`
- [ ] T011 Wire local and in-memory daily handling repositories into app construction dependencies in `lib/main.dart`
- [ ] T012 [P] Add daily handling repository persistence and idempotency tests in `test/features/medications/daily_reminder_handling_repository_test.dart`
- [ ] T013 [P] Add fake notification scheduler suppression tracking in `test/features/medications/fakes/fake_reminder_notification_scheduler.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - See Today's Medication Plan (Priority: P1) MVP

**Goal**: Show today's active scheduled reminders grouped as due now, upcoming,
missed, and handled, with direct handling for due/upcoming items.

**Independent Test**: Open the app with active medications and reminders due in
the past, near present, future, and handled today; verify grouping, ordering,
status labels, and direct handled behavior.

### Tests for User Story 1

- [ ] T014 [P] [US1] Add dashboard service tests for due-now, upcoming, missed, handled, end-date filtering, inactive filtering, ordering, and next refresh boundaries in `test/features/medications/today_dashboard_service_test.dart`
- [ ] T015 [P] [US1] Add dashboard widget tests for grouped sections, due-now emphasis, handled visibility, and mark-handled interaction in `test/features/medications/today_dashboard_screen_test.dart`
- [ ] T016 [P] [US1] Add notification suppression tests for marking upcoming reminders handled in `test/features/medications/reminder_notification_scheduler_test.dart`

### Implementation for User Story 1

- [ ] T017 [US1] Implement today dashboard derivation service with deterministic clock input in `lib/features/medications/domain/today_dashboard_service.dart`
- [ ] T018 [US1] Implement current-day alert suppression for one schedule time in `lib/services/reminder_notification_scheduler.dart`
- [ ] T019 [US1] Implement reusable reminder card with localized time, medication name, status label, and handled action in `lib/features/medications/presentation/today_reminder_card.dart`
- [ ] T020 [US1] Implement reusable dashboard section widget for due-now, upcoming, missed, and handled groups in `lib/features/medications/presentation/today_section.dart`
- [ ] T021 [US1] Implement Today Dashboard screen loading snapshots, refreshing at service boundaries, and marking due/upcoming reminders handled in `lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T022 [US1] Replace post-setup medication-list landing content with Today Dashboard while preserving setup preferences and notification banner access in `lib/main.dart`
- [ ] T023 [US1] Complete English dashboard strings for statuses, section headings, handled action, notification guidance, and semantics in `lib/l10n/app_en.arb`
- [ ] T024 [US1] Complete Spanish fallback dashboard strings for statuses, section headings, handled action, notification guidance, and semantics in `lib/l10n/app_es.arb`
- [ ] T025 [US1] Complete Latin American Spanish dashboard strings for statuses, section headings, handled action, notification guidance, and semantics in `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 1 is fully functional and independently testable.

---

## Phase 4: User Story 2 - Understand Empty And Partial Days (Priority: P2)

**Goal**: Explain empty and partial dashboard states and provide one-tap paths to
add medications or schedule reminders when relevant.

**Independent Test**: Open the app with no medications, medications but none
active, active medications without schedules, and no remaining reminders today;
verify the correct state and action appears.

### Tests for User Story 2

- [ ] T026 [P] [US2] Add dashboard service tests for no-medications, no-active-medications, no-schedules, and clear-for-today section selection in `test/features/medications/today_dashboard_service_test.dart`
- [ ] T027 [P] [US2] Add dashboard widget tests for empty-state copy and add/schedule/manage actions in `test/features/medications/today_dashboard_screen_test.dart`

### Implementation for User Story 2

- [ ] T028 [US2] Extend dashboard derivation service empty-state selection for no medications, no active medications, no schedules, and clear-for-today states in `lib/features/medications/domain/today_dashboard_service.dart`
- [ ] T029 [US2] Implement reusable empty-state widget with localized title, body, and primary action in `lib/features/medications/presentation/today_empty_state.dart`
- [ ] T030 [US2] Connect add-medication, schedule-reminder, and medication-management actions from empty states in `lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T031 [US2] Refresh dashboard data after returning from add-medication and schedule-reminder flows in `lib/main.dart`
- [ ] T032 [US2] Add localized empty-state and clear-for-today copy in `lib/l10n/app_en.arb`
- [ ] T033 [US2] Add localized empty-state and clear-for-today copy in `lib/l10n/app_es.arb`
- [ ] T034 [US2] Add localized empty-state and clear-for-today copy in `lib/l10n/app_es_419.arb`

**Checkpoint**: User Stories 1 and 2 both work independently.

---

## Phase 5: User Story 3 - Review Status Accessibly (Priority: P3)

**Goal**: Ensure dashboard status, layout, actions, and localized copy remain
usable with large text, screen readers, high contrast, and non-color-only cues.

**Independent Test**: Open the dashboard with due, upcoming, missed, and handled
reminders under large text, screen reader navigation, and high contrast; verify
status text/icons, labels, focus, order, and touch targets.

### Tests for User Story 3

- [ ] T035 [P] [US3] Add widget tests for non-color-only status text/icons and semantic labels containing medication name, time, and status in `test/features/medications/today_dashboard_screen_test.dart`
- [ ] T036 [US3] Add widget tests for large text layout, visible actions, and minimum touch target sizing in `test/features/medications/today_dashboard_screen_test.dart`
- [ ] T037 [US3] Add localization tests for English and Latin American Spanish dashboard dates, times, statuses, empty states, and actions in `test/features/medications/today_dashboard_screen_test.dart`

### Implementation for User Story 3

- [ ] T038 [US3] Harden reminder card semantics, focus order, status icons, and large-text layout in `lib/features/medications/presentation/today_reminder_card.dart`
- [ ] T039 [US3] Harden section headings, empty states, and dashboard reading order for screen readers and large text in `lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T040 [US3] Harden empty-state semantics, action labels, and 56px preferred touch targets in `lib/features/medications/presentation/today_empty_state.dart`
- [ ] T041 [US3] Confirm dashboard ARB key usage is wired through localized widget calls in `lib/features/medications/presentation/today_dashboard_screen.dart`

**Checkpoint**: All user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation, cleanup, and release-readiness checks across all dashboard stories.

- [ ] T042 [P] Run Flutter localization generation and review generated files in `lib/l10n/app_localizations.dart`
- [ ] T043 [P] Run Dart formatting across dashboard implementation and tests in `lib/features/medications/`
- [ ] T044 [P] Run Dart formatting across dashboard tests in `test/features/medications/`
- [ ] T045 Run `flutter analyze` and fix dashboard-related diagnostics in `lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T046 Run `flutter test` and fix dashboard-related failures in `test/features/medications/today_dashboard_screen_test.dart`
- [ ] T047 Perform manual quickstart verification for restart, offline use, notification denied/blocked states, upcoming reminder suppression, day-change refresh, large text, screen reader, high contrast, and localization using `specs/004-today-dashboard/quickstart.md`
- [ ] T048 Review Today Dashboard UI against `docs/ux-design.md` for calm tone, readable spacing, large touch targets, pressure-free choices, privacy-preserving language, and large-text layout in `lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T049 Review dashboard privacy scope to confirm no account, sync, backup, analytics, donation, sharing, or remote-service prompt was added in `lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T050 Review performance behavior for local render time, mark-handled responsiveness, and boundary-based refresh in `lib/features/medications/domain/today_dashboard_service.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion and is the MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational completion; integrates with dashboard shell from US1 for normal sequencing.
- **User Story 3 (Phase 5)**: Depends on dashboard UI from US1 and US2.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Start after Phase 2; delivers the first usable dashboard.
- **User Story 2 (P2)**: Start after Phase 2, but sequence after US1 unless multiple implementers coordinate dashboard screen edits.
- **User Story 3 (P3)**: Start after US1 and US2 UI exists; can run alongside final localization and test hardening.

### Within Each User Story

- Write story tests first and confirm they fail before implementation.
- Domain and repository changes before service logic.
- Service logic before UI widgets.
- UI widgets before main app integration.
- Localization strings before final widget assertions.

### Parallel Opportunities

- T001-T005 can run in parallel because they touch different fixture/localization files.
- T012 and T013 can run in parallel after T006-T010 define the contracts.
- T014-T016 can run in parallel because they target service, widget, and scheduler behavior.
- T023-T025 can run in parallel because they update separate ARB locale files.
- T026-T027 can run in parallel for US2 service and widget coverage.
- T032-T034 can run in parallel because they update separate ARB locale files.
- T035-T037 can run in parallel as distinct widget-test concerns in the same test file only if coordinated carefully.
- T042-T044 can run in parallel during polish when no one else is editing generated/localized or formatted files.

---

## Parallel Example: User Story 1

```bash
# Service and widget tests can be authored together before implementation:
Task: "T014 [US1] Add dashboard service tests in test/features/medications/today_dashboard_service_test.dart"
Task: "T015 [US1] Add dashboard widget tests in test/features/medications/today_dashboard_screen_test.dart"
Task: "T016 [US1] Add notification suppression tests in test/features/medications/reminder_notification_scheduler_test.dart"

# Locale files can be completed independently:
Task: "T023 [US1] Complete English dashboard strings in lib/l10n/app_en.arb"
Task: "T024 [US1] Complete Spanish fallback dashboard strings in lib/l10n/app_es.arb"
Task: "T025 [US1] Complete Latin American Spanish dashboard strings in lib/l10n/app_es_419.arb"
```

## Parallel Example: User Story 2

```bash
# Empty-state service and widget coverage can be written in parallel:
Task: "T026 [US2] Add empty-state service tests in test/features/medications/today_dashboard_service_test.dart"
Task: "T027 [US2] Add empty-state widget tests in test/features/medications/today_dashboard_screen_test.dart"

# Empty-state locale files can be updated independently:
Task: "T032 [US2] Add English empty-state copy in lib/l10n/app_en.arb"
Task: "T033 [US2] Add Spanish fallback empty-state copy in lib/l10n/app_es.arb"
Task: "T034 [US2] Add Latin American Spanish empty-state copy in lib/l10n/app_es_419.arb"
```

## Parallel Example: User Story 3

```bash
# Accessibility and localization tests can be divided by assertion area:
Task: "T035 [US3] Add semantic status tests in test/features/medications/today_dashboard_screen_test.dart"
Task: "T036 [US3] Add large-text and touch-target tests in test/features/medications/today_dashboard_screen_test.dart"
Task: "T037 [US3] Add localization tests in test/features/medications/today_dashboard_screen_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup tasks.
2. Complete Phase 2 foundational domain, repository, and scheduler contracts.
3. Complete Phase 3 User Story 1 tasks.
4. Stop and validate US1 independently with `flutter test` focused on dashboard service, dashboard screen, handling persistence, and notification suppression.
5. Demo the post-setup dashboard with due-now, upcoming, missed, and handled reminders.

### Incremental Delivery

1. Setup + Foundational -> shared dashboard infrastructure ready.
2. US1 -> daily reminder plan and mark-handled MVP.
3. US2 -> empty and partial-day guidance.
4. US3 -> accessibility, high contrast, large text, semantics, and localization hardening.
5. Polish -> full quickstart, privacy, performance, analyze, format, and test validation.

### Parallel Team Strategy

1. Complete setup and foundational contracts together.
2. Split US1 tests across service, widget, and scheduler behavior.
3. Split locale work by ARB file.
4. After the core dashboard shell exists, one implementer can own empty states while another owns accessibility/localization hardening.

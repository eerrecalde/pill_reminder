# Tasks: Medication History

**Input**: Design documents from `/specs/006-medication-history/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/medication-history-ui.md, quickstart.md

**Tests**: Required for this feature because it changes reminder outcomes, local persistence, privacy-sensitive medication data, localization, and accessibility states.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare feature files and test fixtures without changing behavior.

- [ ] T001 Create medication history source and test file placeholders matching the plan in lib/features/medications/domain/medication_history.dart, lib/features/medications/domain/medication_history_service.dart, lib/features/medications/data/medication_history_repository.dart, lib/features/medications/data/local_medication_history_repository.dart, lib/features/medications/presentation/medication_history_screen.dart, lib/features/medications/presentation/medication_history_day_section.dart, lib/features/medications/presentation/medication_history_status_label.dart, test/features/medications/medication_history_service_test.dart, test/features/medications/medication_history_repository_test.dart, test/features/medications/medication_history_screen_test.dart, and test/features/medications/fakes/fake_medication_history_repository.dart
- [ ] T002 [P] Review existing reminder action and due reconciliation integration points in lib/services/reminder_action_handler.dart, lib/services/reminder_due_reconciler.dart, lib/features/medications/presentation/today_dashboard_screen.dart, and lib/main.dart
- [ ] T003 [P] Review existing localization and accessibility patterns in lib/l10n/app_en.arb, lib/l10n/app_es.arb, lib/l10n/app_es_419.arb, lib/features/medications/presentation/today_reminder_card.dart, and docs/ux-design.md

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared medication history data contracts, repository persistence, and test fakes required by all stories.

**Critical**: No user story work can begin until this phase is complete.

- [ ] T004 [P] Implement MedicationHistoryStatus, MedicationHistorySource, MedicationHistoryEntry, MedicationHistoryDayGroup, stable occurrence id creation, JSON serialization, and status precedence helpers in lib/features/medications/domain/medication_history.dart
- [ ] T005 [P] Define MedicationHistoryRepository with loadEntries, upsertEntry, and pruneBefore operations in lib/features/medications/data/medication_history_repository.dart
- [ ] T006 [P] Add FakeMedicationHistoryRepository with in-memory load, upsert, and prune behavior for widget and service tests in test/features/medications/fakes/fake_medication_history_repository.dart
- [ ] T007 Write repository persistence tests for valid JSON loading, invalid record ignoring, upsert-by-stable-id, and pruneBefore retention in test/features/medications/medication_history_repository_test.dart
- [ ] T008 Implement SharedPreferences-backed LocalMedicationHistoryRepository using key medications.history.v1, raw enum names, ISO timestamps, invalid-record recovery, and deterministic ordering in lib/features/medications/data/local_medication_history_repository.dart
- [ ] T009 Wire MedicationHistoryRepository dependency through PillReminderApp constructor, fallback in-memory repository, _MainAppHome, ReminderActionHandler, ReminderDueReconciler, and TodayDashboardScreen integration points in lib/main.dart

**Checkpoint**: Shared history data and persistence contracts are ready.

---

## Phase 3: User Story 1 - Review Recent Medication Activity (Priority: P1) MVP

**Goal**: Users can open history and review recent scheduled medication activity grouped by day, newest first, with medication name, dosage, time, and status.

**Independent Test**: Seed several history entries across multiple days, open history, and confirm day grouping, entry ordering, row content, and calm empty state.

### Tests for User Story 1

- [ ] T010 [P] [US1] Add MedicationHistoryService tests for rolling 90-day loading, newest-first day grouping, scheduled-time then medication-name ordering, and empty results in test/features/medications/medication_history_service_test.dart
- [ ] T011 [P] [US1] Add MedicationHistoryScreen widget tests for loading, empty state, populated day sections, medication name, dosage label, scheduled time, and status visibility in test/features/medications/medication_history_screen_test.dart
- [ ] T012 [P] [US1] Add navigation widget test confirming the main reminder experience exposes and opens medication history from lib/main.dart or TodayDashboardScreen in test/features/medications/today_dashboard_screen_test.dart

### Implementation for User Story 1

- [ ] T013 [US1] Implement MedicationHistoryService loadDayGroups with 90-day window, repository pruning, day grouping, status precedence, and injectable clock in lib/features/medications/domain/medication_history_service.dart
- [ ] T014 [P] [US1] Implement MedicationHistoryStatusLabel with text plus distinct Material icons or shapes for taken, skipped, missed, and snoozed in lib/features/medications/presentation/medication_history_status_label.dart
- [ ] T015 [P] [US1] Implement MedicationHistoryDaySection with responsive day heading and ordered informational rows in lib/features/medications/presentation/medication_history_day_section.dart
- [ ] T016 [US1] Implement MedicationHistoryScreen loading, empty, populated, and invalid-data recovery states using MedicationHistoryService in lib/features/medications/presentation/medication_history_screen.dart
- [ ] T017 [US1] Add a localized history navigation action from the main reminder app bar or TodayDashboardScreen and push MedicationHistoryScreen with repositories in lib/main.dart and lib/features/medications/presentation/today_dashboard_screen.dart
- [ ] T018 [US1] Add English and Spanish l10n keys for history title, navigation tooltip/label, empty state, day heading accessibility text, and status labels in lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb

**Checkpoint**: User Story 1 is fully functional and independently testable.

---

## Phase 4: User Story 2 - Understand Each Status Without Judgment (Priority: P1)

**Goal**: Users can distinguish taken, skipped, missed, and snoozed through calm wording and non-color-only indicators.

**Independent Test**: Render entries for all four statuses and confirm labels, indicators, semantics, and wording do not rely on color or judgmental language.

### Tests for User Story 2

- [ ] T019 [P] [US2] Add status label widget tests for all four statuses, icons/shapes, localized text, and large-text wrapping in test/features/medications/medication_history_screen_test.dart
- [ ] T020 [P] [US2] Add semantic label widget tests confirming each history row announces day, medication, optional dosage, scheduled time, and status in order in test/features/medications/medication_history_screen_test.dart
- [ ] T021 [P] [US2] Add reminder action history tests for taken, skipped, snoozed, and snoozed-then-final status precedence in test/features/medications/reminder_action_handler_test.dart

### Implementation for User Story 2

- [ ] T022 [US2] Extend ReminderActionHandler to accept MedicationHistoryRepository and upsert taken, skipped, and snoozed entries with captured medication name, dosage label, scheduled time, snooze count, and source in lib/services/reminder_action_handler.dart
- [ ] T023 [US2] Update DueReminder domain conversion helpers if needed to expose scheduleId, medication snapshot, snooze metadata, and final status timestamps for history recording in lib/features/medications/domain/due_reminder.dart
- [ ] T024 [US2] Update MedicationHistoryService status precedence so final taken, skipped, or missed outcomes replace snoozed display for the same occurrence in lib/features/medications/domain/medication_history_service.dart
- [ ] T025 [US2] Refine MedicationHistoryStatusLabel colors, icons, shapes, contrast, and calm localized labels without clinical advice or alarming language in lib/features/medications/presentation/medication_history_status_label.dart and lib/l10n/app_en.arb
- [ ] T026 [US2] Add row Semantics wrapping in MedicationHistoryDaySection with a single logical label and informational-only behavior in lib/features/medications/presentation/medication_history_day_section.dart

**Checkpoint**: User Stories 1 and 2 work independently with all status meanings accessible.

---

## Phase 5: User Story 3 - Use History Offline and Privately (Priority: P2)

**Goal**: Users can view recent history offline without account, sync, analytics, sharing, export, or remote services.

**Independent Test**: Persist entries locally, restart the app/test harness, disable network assumptions, and confirm history remains available with no sign-in or remote prompt.

### Tests for User Story 3

- [ ] T027 [P] [US3] Add persistence restart test proving LocalMedicationHistoryRepository reloads saved history after a new SharedPreferences-backed instance in test/features/medications/medication_history_repository_test.dart
- [ ] T028 [P] [US3] Add privacy/offline widget test confirming history screen has no sign-in, sync, sharing, export, analytics, backup, caregiver invite, or internet prompt copy in test/features/medications/medication_history_screen_test.dart
- [ ] T029 [P] [US3] Add missed reconciliation tests for unhandled reminders older than 60 minutes and no duplicate confusing rows for existing occurrences in test/features/medications/reminder_due_reconciler_test.dart

### Implementation for User Story 3

- [ ] T030 [US3] Extend ReminderDueReconciler to accept MedicationHistoryRepository and upsert missed entries for unhandled scheduled reminders more than 60 minutes past scheduledAt in lib/services/reminder_due_reconciler.dart
- [ ] T031 [US3] Ensure today dashboard mark-handled path records a taken history entry with captured medication name and dosage when users mark current-day scheduled reminders handled in lib/features/medications/presentation/today_dashboard_screen.dart
- [ ] T032 [US3] Ensure history recording preserves captured medication name and dosage after edit, pause, resume, or delete without adding history row edit controls in lib/services/reminder_action_handler.dart, lib/services/reminder_due_reconciler.dart, and lib/features/medications/presentation/medication_history_day_section.dart
- [ ] T033 [US3] Remove or avoid any account, network, analytics, export, backup, sharing, sync, or caregiver invitation surfaces from the history screen in lib/features/medications/presentation/medication_history_screen.dart
- [ ] T034 [US3] Prune history older than the rolling 90-day window during repository upsert and service load paths in lib/features/medications/data/local_medication_history_repository.dart and lib/features/medications/domain/medication_history_service.dart

**Checkpoint**: User Story 3 is independently testable offline and private on device.

---

## Phase 6: User Story 4 - Review History Accessibly in Supported Languages (Priority: P2)

**Goal**: Users can review history with large text, screen readers, and localized English and Latin American Spanish labels, dates, and times.

**Independent Test**: Render the history screen in English and Latin American Spanish with large text and semantics enabled, confirming no clipped content, correct date/time formatting, and logical screen reader order.

### Tests for User Story 4

- [ ] T035 [P] [US4] Add localization widget tests for English, Spanish, and es_419 history title, empty state, status labels, day headings, and scheduled times in test/features/medications/medication_history_screen_test.dart
- [ ] T036 [P] [US4] Add large text widget tests for long medication names and dosage labels without clipped status, overlapping rows, or blocked navigation in test/features/medications/medication_history_screen_test.dart
- [ ] T037 [P] [US4] Add l10n generation regression check expectations for new history keys in lib/l10n/app_localizations_en.dart, lib/l10n/app_localizations_es.dart, and lib/l10n/app_localizations.dart

### Implementation for User Story 4

- [ ] T038 [US4] Format day headings and scheduled reminder times with intl using the active locale in lib/features/medications/presentation/medication_history_day_section.dart and lib/features/medications/presentation/medication_history_screen.dart
- [ ] T039 [US4] Update medication history layouts for large text, generous spacing, focus order, 48px minimum navigation targets, and wrapping content per docs/ux-design.md in lib/features/medications/presentation/medication_history_screen.dart, lib/features/medications/presentation/medication_history_day_section.dart, and lib/features/medications/presentation/medication_history_status_label.dart
- [ ] T040 [US4] Complete English, Spanish, and Latin American Spanish translations for all medication history strings in lib/l10n/app_en.arb, lib/l10n/app_es.arb, and lib/l10n/app_es_419.arb
- [ ] T041 [US4] Run flutter gen-l10n and update generated localization files in lib/l10n/app_localizations.dart, lib/l10n/app_localizations_en.dart, and lib/l10n/app_localizations_es.dart

**Checkpoint**: User Story 4 is independently testable with localization and accessibility settings.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final validation across behavior, accessibility, privacy, localization, performance, and documentation.

- [ ] T042 [P] Update manual verification notes for medication history in specs/006-medication-history/quickstart.md
- [ ] T043 [P] Add or update test fixtures for 90 days of typical reminders, same-time medications, long names, edited/deleted medication snapshots, and all statuses in test/features/medications/medication_history_test_fixtures.dart
- [ ] T044 Run dart format on changed Dart files under lib/ and test/
- [ ] T045 Run flutter gen-l10n, flutter test, and flutter analyze using pubspec.yaml from repository root
- [ ] T046 Perform manual quickstart verification for grouping, all statuses, snooze-final precedence, edited/deleted medication snapshots, offline availability, localization, screen reader order, large text, and no overlap using specs/006-medication-history/quickstart.md
- [ ] T047 Review medication history implementation against docs/ux-design.md for calm tone, readable text, pressure-free choices, non-clinical language, and no account friction
- [ ] T048 Verify performance with at least 90 days of typical reminder entries and keep history screen load under 500 ms in test/features/medications/medication_history_service_test.dart or test/features/medications/medication_history_screen_test.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup and blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational and is the MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational; integrates best after US1 UI/status widgets exist.
- **User Story 3 (Phase 5)**: Depends on Foundational; can run alongside US2 after repository and recording contracts exist.
- **User Story 4 (Phase 6)**: Depends on US1 presentation files and can run alongside later US2/US3 refinements once strings and widgets exist.
- **Polish (Phase 7)**: Depends on all desired stories being complete.

### User Story Dependencies

- **US1 Review Recent Medication Activity (P1)**: Start after Phase 2; no dependency on other stories.
- **US2 Understand Each Status Without Judgment (P1)**: Start after Phase 2; benefits from US1 status widgets and rows.
- **US3 Use History Offline and Privately (P2)**: Start after Phase 2; no dependency on US4.
- **US4 Review History Accessibly in Supported Languages (P2)**: Start after US1 widgets exist; no dependency on US3.

### Within Each User Story

- Write failing tests before implementation tasks in the same story.
- Implement domain models before services.
- Implement repositories before recording integrations.
- Implement services before UI rendering.
- Add localization keys before generated localization code.
- Validate each story independently before moving to the next priority.

---

## Parallel Opportunities

- T002 and T003 can run in parallel after T001.
- T004, T005, and T006 can run in parallel because they touch separate domain, repository interface, and fake files.
- T010, T011, and T012 can run in parallel for US1 tests.
- T014 and T015 can run in parallel once US1 test expectations are clear.
- T019, T020, and T021 can run in parallel for US2 tests.
- T027, T028, and T029 can run in parallel for US3 tests.
- T035, T036, and T037 can run in parallel for US4 tests.
- T042 and T043 can run in parallel during polish.

---

## Parallel Example: User Story 1

```bash
# Tests can be assigned together:
Task: "T010 [US1] Add MedicationHistoryService tests in test/features/medications/medication_history_service_test.dart"
Task: "T011 [US1] Add MedicationHistoryScreen widget tests in test/features/medications/medication_history_screen_test.dart"
Task: "T012 [US1] Add navigation widget test in test/features/medications/today_dashboard_screen_test.dart"

# UI pieces can be assigned together after service contracts are known:
Task: "T014 [US1] Implement MedicationHistoryStatusLabel in lib/features/medications/presentation/medication_history_status_label.dart"
Task: "T015 [US1] Implement MedicationHistoryDaySection in lib/features/medications/presentation/medication_history_day_section.dart"
```

---

## Parallel Example: User Story 2

```bash
Task: "T019 [US2] Add status label widget tests in test/features/medications/medication_history_screen_test.dart"
Task: "T020 [US2] Add semantic label widget tests in test/features/medications/medication_history_screen_test.dart"
Task: "T021 [US2] Add reminder action history tests in test/features/medications/reminder_action_handler_test.dart"
```

---

## Parallel Example: User Story 3

```bash
Task: "T027 [US3] Add persistence restart test in test/features/medications/medication_history_repository_test.dart"
Task: "T028 [US3] Add privacy/offline widget test in test/features/medications/medication_history_screen_test.dart"
Task: "T029 [US3] Add missed reconciliation tests in test/features/medications/reminder_due_reconciler_test.dart"
```

---

## Parallel Example: User Story 4

```bash
Task: "T035 [US4] Add localization widget tests in test/features/medications/medication_history_screen_test.dart"
Task: "T036 [US4] Add large text widget tests in test/features/medications/medication_history_screen_test.dart"
Task: "T037 [US4] Add l10n generation regression expectations for lib/l10n/app_localizations*.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup.
2. Complete Phase 2 foundational domain, repository, and fake infrastructure.
3. Complete Phase 3 User Story 1.
4. Stop and validate grouping, ordering, row content, navigation, and empty state independently.

### Incremental Delivery

1. Deliver US1 so history can be opened and scanned by day.
2. Deliver US2 so every status is calm, distinct, and accessible without relying on color.
3. Deliver US3 so history is recorded from reminder flows and remains local, private, offline, and retained for 90 days.
4. Deliver US4 so dates, times, labels, large text, and screen reader behavior are complete for English and Latin American Spanish.
5. Run polish validation and quickstart checks.

### Parallel Team Strategy

1. Complete Setup and Foundational together.
2. Assign UI/status work to one developer, recording/repository integration to another, and localization/accessibility tests to a third after Phase 2.
3. Integrate through MedicationHistoryRepository and MedicationHistoryService contracts, then run the full verification suite.

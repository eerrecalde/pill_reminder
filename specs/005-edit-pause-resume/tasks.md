# Tasks: Edit, Pause, Resume

**Input**: Design documents from `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/specs/005-edit-pause-resume/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/edit-pause-resume-contract.md, quickstart.md

**Tests**: Required for reminder reliability, persistence, accessibility states, localization, permission messaging, and deletion cleanup per the feature specification and contract.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested as an independent increment after the shared foundation is complete.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel because it touches different files and has no dependency on incomplete tasks
- **[Story]**: Which user story this task belongs to, required only inside user story phases
- Every task includes an exact file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the feature workspace and confirm the existing Flutter baseline before implementation.

- [ ] T001 Verify current Flutter and Dart versions match the implementation plan in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/pubspec.yaml`
- [ ] T002 [P] Review edit, pause, resume UX requirements from `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/docs/ux-design.md`
- [ ] T003 [P] Review generated localization files and ARB workflow for English and Latin American Spanish in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_en.arb`
- [ ] T004 [P] Review existing medication and reminder test fixtures before adding feature coverage in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/medication_test_fixtures.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared domain, repository, scheduler, and test support that all user stories depend on.

**Critical**: No user story work should begin until this phase is complete.

- [ ] T005 Add paused medication state, pausedAt, resumedAt, copyWith, JSON migration defaults, and isPaused helpers in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication.dart`
- [ ] T006 Extend MedicationRepository with update, pause, resume, and delete method contracts in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/data/medication_repository.dart`
- [ ] T007 Implement update, pause, resume, and delete persistence while preserving stable ids and createdAt in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/data/local_medication_repository.dart`
- [ ] T008 Extend ReminderScheduleRepository with replaceSchedule and delete-by-schedule cleanup semantics in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/data/reminder_schedule_repository.dart`
- [ ] T009 Implement id-preserving schedule replacement and deterministic deletion behavior in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/data/local_reminder_schedule_repository.dart`
- [ ] T010 Extend ReminderNotificationScheduler with refreshForMedication, cancelForMedication, and cancelDueAndLaterForMedication contracts in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/services/reminder_notification_scheduler.dart`
- [ ] T011 Extend fake medication repository with update, pause, resume, and delete call tracking in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/fakes/fake_medication_repository.dart`
- [ ] T012 Extend fake reminder schedule repository with replaceSchedule and delete call tracking in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/fakes/fake_reminder_schedule_repository.dart`
- [ ] T013 Extend fake notification scheduler with refresh, medication-wide cancellation, due cancellation, later cancellation, and ordering call tracking in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/fakes/fake_reminder_notification_scheduler.dart`
- [ ] T014 Extend fake due reminder repository with medication and schedule cleanup assertions for pending due and remind-again-later records in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/fakes/fake_due_reminder_repository.dart`
- [ ] T015 [P] Add medication paused-state repository tests for JSON migration, update preservation, pause/resume timestamps, and delete persistence in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/medication_repository_test.dart`
- [ ] T016 [P] Add schedule replacement repository tests for sorted unique times, id preservation, delivery state persistence, and deletion in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_schedule_repository_test.dart`
- [ ] T017 [P] Add notification scheduler idempotency and cancellation tests for medication-wide and schedule replacement operations in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T018 Add shared operation coordinator for edit, schedule replace, pause, resume, delete schedule, and delete medication side effects in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart`

**Checkpoint**: Domain state, repository operations, notification hooks, fakes, and shared operation orchestration are ready for user stories.

---

## Phase 3: User Story 1 - Edit Medication Details (Priority: P1) MVP

**Goal**: Users can edit saved medication details, cancel safely, preserve schedules, and ensure future reminder text uses updated details without duplicate notifications.

**Independent Test**: Save a medication with a reminder schedule, edit medication name and dosage label, verify list and future reminders use updated details, verify the schedule remains unchanged, and verify cancel leaves all data unchanged.

### Tests for User Story 1

- [ ] T019 [P] [US1] Add widget tests for prefilled medication edit form, save, cancel, and validation recovery in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_medication_screen_test.dart`
- [ ] T020 [P] [US1] Add operation tests proving medication detail edit preserves schedule and refreshes future reminder notification text without duplicate schedule calls in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`
- [ ] T021 [P] [US1] Add medication validation regression tests for edited name, dosage label, notes, and preserved valid field values in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/medication_validation_test.dart`

### Implementation for User Story 1

- [ ] T022 [US1] Add edit-mode initialization and save/cancel callbacks to the medication form in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T023 [US1] Add edit medication action, accessible labels, and stable widget keys to medication cards in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_list_section.dart`
- [ ] T024 [US1] Wire medication edit navigation and state refresh from the dashboard screen in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/today_dashboard_screen.dart`
- [ ] T025 [US1] Use MedicationReminderOperations to update medication details, preserve schedule data, refresh scheduled notification copy, and announce success in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart`
- [ ] T026 [US1] Add English medication edit labels, validation messages, cancel text, and success copy in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_en.arb`
- [ ] T027 [US1] Add Latin American Spanish medication edit labels, validation messages, cancel text, and success copy in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_es_419.arb`
- [ ] T028 [US1] Regenerate localization accessors for medication edit copy in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_localizations.dart`

**Checkpoint**: User Story 1 is independently functional and testable as the MVP.

---

## Phase 4: User Story 2 - Edit Reminder Times (Priority: P1)

**Goal**: Users can edit existing reminder times, review changes, save future-only schedule replacements, and avoid receiving old and new notifications together.

**Independent Test**: Edit a saved schedule, confirm existing times are preselected, replace times, save, restart app state, and verify only updated future reminder times remain active.

### Tests for User Story 2

- [ ] T029 [P] [US2] Add widget tests for schedule edit preselection, time add/change/remove, review summary, save, and cancel in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_schedule_screen_test.dart`
- [ ] T030 [P] [US2] Add validation tests for no times, duplicate times, too many times, invalid end date, and preserved valid selections in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_schedule_validation_test.dart`
- [ ] T031 [P] [US2] Add operation tests proving schedule edit cancels old notifications before scheduling new times and stores permission-limited delivery state in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`

### Implementation for User Story 2

- [ ] T032 [US2] Refactor schedule save flow to use replaceSchedule operation, cancel obsolete notifications, and persist final delivery state in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T033 [US2] Update schedule review copy and accessible summary for edited reminder times and end date behavior in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/reminder_schedule_review.dart`
- [ ] T034 [US2] Add edit schedule action and non-destructive cancel path for medications with existing schedules in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_list_section.dart`
- [ ] T035 [US2] Implement schedule replacement side effects and duplicate-prevention ordering in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart`
- [ ] T036 [US2] Add permission-limited schedule edit messages and review strings in English in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_en.arb`
- [ ] T037 [US2] Add permission-limited schedule edit messages and review strings in Latin American Spanish in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_es_419.arb`
- [ ] T038 [US2] Regenerate localization accessors for schedule edit copy in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_localizations.dart`

**Checkpoint**: User Stories 1 and 2 both work independently and meet the P1 edit requirements.

---

## Phase 5: User Story 3 - Pause and Resume Reminders (Priority: P2)

**Goal**: Users can pause all reminders for a medication, see a clear paused state, and manually resume future reminders from the next applicable time.

**Independent Test**: Pause a medication with an active schedule, verify future schedule and pending later reminders stop, verify paused status is visible without color alone, resume, and verify only future reminders are scheduled.

### Tests for User Story 3

- [ ] T039 [P] [US3] Add operation tests for pause canceling schedule notifications, due reminders, and remind-again-later requests in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`
- [ ] T040 [P] [US3] Add operation tests for resume scheduling only next future occurrences without backfilling missed times in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T041 [P] [US3] Add widget tests for visible paused state, resume action, disabled scheduling where appropriate, and screen reader semantics in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/today_dashboard_screen_test.dart`

### Implementation for User Story 3

- [ ] T042 [US3] Update medication status label to show active and paused states with text and icon semantics in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_status_label.dart`
- [ ] T043 [US3] Add pause and resume actions with large accessible touch targets to medication cards in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_list_section.dart`
- [ ] T044 [US3] Implement pause and resume operation ordering for medication status, schedule notifications, due reminders, and later reminders in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart`
- [ ] T045 [US3] Prevent due-reminder creation for paused medications during reconciliation in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/services/reminder_due_reconciler.dart`
- [ ] T046 [US3] Add English pause/resume labels, status copy, permission-limited resume messages, and success announcements in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_en.arb`
- [ ] T047 [US3] Add Latin American Spanish pause/resume labels, status copy, permission-limited resume messages, and success announcements in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_es_419.arb`
- [ ] T048 [US3] Regenerate localization accessors for pause and resume copy in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_localizations.dart`

**Checkpoint**: Pause and resume are independently testable without requiring deletion flows.

---

## Phase 6: User Story 4 - Delete Medication or Schedule Safely (Priority: P2)

**Goal**: Users can delete a schedule or medication only after clear confirmation, cancel safely, and remove all associated future and pending reminder data when confirmed.

**Independent Test**: Start schedule and medication deletion, cancel each confirmation, verify no data changed, then confirm each deletion and verify schedule/medication records, future notifications, due reminders, and later requests are removed as specified.

### Tests for User Story 4

- [ ] T049 [P] [US4] Add widget tests for schedule delete confirmation copy, cancel outcome, confirm outcome, and focus order in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`
- [ ] T050 [P] [US4] Add widget tests for medication delete confirmation copy, cancel outcome, confirm outcome, and final deletion messaging in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_medication_screen_test.dart`
- [ ] T051 [P] [US4] Add repository and operation tests for delete schedule keeping medication and delete medication removing schedule plus due/later state in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/medication_repository_test.dart`

### Implementation for User Story 4

- [ ] T052 [US4] Create reusable accessible destructive confirmation dialog for medication and schedule deletion in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_delete_confirmation_dialog.dart`
- [ ] T053 [US4] Add delete schedule action and confirmation wiring to the reminder schedule screen in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T054 [US4] Add delete medication action and confirmation wiring to medication edit or medication card controls in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_list_section.dart`
- [ ] T055 [US4] Implement delete schedule and delete medication operation ordering for repository deletion, scheduler cancellation, and due/later cleanup in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart`
- [ ] T056 [US4] Ensure due reminder repository cleanup supports schedule deletion and medication deletion without removing unrelated records in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/data/local_due_reminder_repository.dart`
- [ ] T057 [US4] Add English deletion confirmation, cancel, destructive action, success, and final-after-confirmation strings in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_en.arb`
- [ ] T058 [US4] Add Latin American Spanish deletion confirmation, cancel, destructive action, success, and final-after-confirmation strings in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_es_419.arb`
- [ ] T059 [US4] Regenerate localization accessors for deletion copy in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_localizations.dart`

**Checkpoint**: Deletion flows are independently testable and do not depend on accessibility polish beyond required confirmation semantics.

---

## Phase 7: User Story 5 - Use Accessible Recovery and Confirmation States (Priority: P3)

**Goal**: Edit, pause, resume, and delete flows remain clear with large text, screen readers, high contrast, localized English and Latin American Spanish copy, and correction-preserving errors.

**Independent Test**: Complete each flow with large text and screen reader settings in English and Latin American Spanish, verifying no clipped controls, blocked actions, hard-coded strings, or color-only states.

### Tests for User Story 5

- [ ] T060 [P] [US5] Add large text and semantics regression tests across edit, schedule edit, pause/resume, and delete states in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`
- [ ] T061 [P] [US5] Add localization coverage tests for English and Latin American Spanish edit, pause, resume, delete, error, status, and notification strings in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_localization_test.dart`
- [ ] T062 [P] [US5] Add permission state messaging tests for denied, blocked, skipped, unavailable, and granted states after edit or resume in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`

### Implementation for User Story 5

- [ ] T063 [US5] Audit and adjust edit, pause, resume, delete, confirmation, and error layouts for large text, 48px touch targets, visible focus, and logical reading order in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/medication_list_section.dart`
- [ ] T064 [US5] Replace any hard-coded user-visible notification action or reminder body text with localization-ready values in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/services/reminder_notification_scheduler.dart`
- [ ] T065 [US5] Ensure generated Spanish fallback and base Spanish localization remain consistent with Latin American Spanish strings in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_es.arb`
- [ ] T066 [US5] Add accessible announcements for validation errors, save success, pause, resume, delete cancellation, and delete confirmation outcomes in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/reminder_schedule_screen.dart`
- [ ] T067 [US5] Update status and permission messaging on the today dashboard for paused, deleted, and permission-limited medications in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/presentation/today_dashboard_screen.dart`

**Checkpoint**: Accessibility and localization requirements are covered across all user-facing flows.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final verification and quality checks across all stories.

- [ ] T068 [P] Run and fix full static analysis for this feature in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/analysis_options.yaml`
- [ ] T069 [P] Run and fix full Flutter test suite for this feature in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`
- [ ] T070 [P] Document manual iOS and Android notification replacement, cancellation, permission, offline, restart, screen reader, and large text results in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/specs/005-edit-pause-resume/quickstart.md`
- [ ] T071 [P] Verify edit, pause, resume, and delete operations persist locally and update in-app state within 1 second for typical v1 data volumes in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/edit_pause_resume_flow_test.dart`
- [ ] T072 [P] Verify notification replacement and cancellation complete without duplicate pending notifications for up to 4 daily reminder times in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T073 Verify startup reconciliation adds no more than 300ms for typical local reminder records and does not add polling or continuous background work in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/test/features/medications/reminder_due_reconciler_test.dart`
- [ ] T074 Review all user-facing edit, pause, resume, delete, confirmation, error, status, date, time, and notification strings for localization readiness in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/l10n/app_en.arb`
- [ ] T075 Review local-only privacy behavior to confirm no account, sync, backup, analytics, sharing, undo, archive, trash, restore, or clinical advice was introduced in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart`
- [ ] T076 Verify quickstart automated commands and focused manual scenarios still match the implemented feature in `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/specs/005-edit-pause-resume/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1: Setup** has no dependencies.
- **Phase 2: Foundational** depends on Phase 1 and blocks all user stories.
- **Phase 3: US1** depends on Phase 2 and is the MVP.
- **Phase 4: US2** depends on Phase 2 and may be built in parallel with US1 after shared operation APIs exist.
- **Phase 5: US3** depends on Phase 2 and can proceed after the medication paused state is available.
- **Phase 6: US4** depends on Phase 2 and can proceed after shared cleanup operation APIs exist.
- **Phase 7: US5** depends on the user-facing surfaces from US1-US4.
- **Phase 8: Polish** depends on the desired stories being complete.

### User Story Dependencies

- **US1 (P1)**: No dependency on other user stories after Phase 2.
- **US2 (P1)**: No dependency on US1 after Phase 2, but both share MedicationReminderOperations.
- **US3 (P2)**: No dependency on US1 or US2 after Phase 2, except shared status and scheduler contracts.
- **US4 (P2)**: No dependency on US1-US3 after Phase 2, except shared confirmation and cleanup patterns.
- **US5 (P3)**: Depends on US1-US4 UI and copy surfaces being present.

### Within Each User Story

- Tests should be written first and fail before implementation.
- Domain and operation rules should be implemented before UI wiring.
- Repository and scheduler side effects should be verified before manual notification checks.
- Localization keys should be added before generated localizations are regenerated.
- Each story should pass its independent test before moving to the next priority.

### Parallel Opportunities

- T002, T003, and T004 can run in parallel during setup.
- T015, T016, and T017 can run in parallel after repository and scheduler contracts are drafted.
- US1 tests T019, T020, and T021 can run in parallel.
- US2 tests T029, T030, and T031 can run in parallel.
- US3 tests T039, T040, and T041 can run in parallel.
- US4 tests T049, T050, and T051 can run in parallel.
- US5 tests T060, T061, and T062 can run in parallel.
- Final checks T068, T069, T070, T071, and T072 can run in parallel after implementation.

---

## Parallel Example: User Story 1

```bash
# Start independent US1 test work together:
Task: "T019 [P] [US1] Add widget tests for prefilled medication edit form, save, cancel, and validation recovery in test/features/medications/edit_medication_screen_test.dart"
Task: "T020 [P] [US1] Add operation tests proving medication detail edit preserves schedule and refreshes future reminder notification text without duplicate schedule calls in test/features/medications/edit_pause_resume_flow_test.dart"
Task: "T021 [P] [US1] Add medication validation regression tests for edited name, dosage label, notes, and preserved valid field values in test/features/medications/medication_validation_test.dart"
```

## Parallel Example: User Story 2

```bash
# Start independent US2 test work together:
Task: "T029 [P] [US2] Add widget tests for schedule edit preselection, time add/change/remove, review summary, save, and cancel in test/features/medications/reminder_schedule_screen_test.dart"
Task: "T030 [P] [US2] Add validation tests for no times, duplicate times, too many times, invalid end date, and preserved valid selections in test/features/medications/reminder_schedule_validation_test.dart"
Task: "T031 [P] [US2] Add operation tests proving schedule edit cancels old notifications before scheduling new times and stores permission-limited delivery state in test/features/medications/edit_pause_resume_flow_test.dart"
```

## Parallel Example: User Story 3

```bash
# Start independent US3 test work together:
Task: "T039 [P] [US3] Add operation tests for pause canceling schedule notifications, due reminders, and remind-again-later requests in test/features/medications/edit_pause_resume_flow_test.dart"
Task: "T040 [P] [US3] Add operation tests for resume scheduling only next future occurrences without backfilling missed times in test/features/medications/reminder_notification_scheduler_test.dart"
Task: "T041 [P] [US3] Add widget tests for visible paused state, resume action, disabled scheduling where appropriate, and screen reader semantics in test/features/medications/today_dashboard_screen_test.dart"
```

## Parallel Example: User Story 4

```bash
# Start independent US4 test work together:
Task: "T049 [P] [US4] Add widget tests for schedule delete confirmation copy, cancel outcome, confirm outcome, and focus order in test/features/medications/edit_pause_resume_flow_test.dart"
Task: "T050 [P] [US4] Add widget tests for medication delete confirmation copy, cancel outcome, confirm outcome, and final deletion messaging in test/features/medications/edit_medication_screen_test.dart"
Task: "T051 [P] [US4] Add repository and operation tests for delete schedule keeping medication and delete medication removing schedule plus due/later state in test/features/medications/medication_repository_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup.
2. Complete Phase 2 foundational contracts, persistence, scheduler hooks, fakes, and operation coordinator.
3. Complete Phase 3 US1 medication detail editing.
4. Stop and validate US1 independently with widget, operation, repository, notification refresh, localization, and accessibility checks.

### Incremental Delivery

1. Deliver US1 medication edit as MVP.
2. Deliver US2 schedule edit and notification replacement.
3. Deliver US3 pause/resume.
4. Deliver US4 safe deletion.
5. Deliver US5 accessibility and localization hardening across all completed flows.

### Parallel Team Strategy

After Phase 2, separate contributors can work on US1, US2, US3, and US4 in parallel because each story has independent tests and explicit file ownership. Coordinate changes to `/Users/emis/Documents/emi-projects/pill-reminder/pill_reminder/lib/features/medications/domain/medication_reminder_operations.dart` because all reminder side-effect flows converge there.

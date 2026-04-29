# Tasks: Add Medication

**Input**: Design documents from `specs/002-add-medication/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Required for medication data, persistence, validation, localization, accessibility, privacy, and regressions per the project constitution.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the medication feature module, test structure, and app entry integration points.

- [ ] T001 Create medication feature directory structure in `lib/features/medications/`
- [ ] T002 [P] Create medication test directory structure in `test/features/medications/`
- [ ] T003 [P] Add medication localization placeholders for English, Spanish, and Latin American Spanish in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`
- [ ] T004 [P] Add add-medication navigation entry placeholder from the main app in `lib/main.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core medication domain, repository boundary, local JSON storage, and shared test fakes.

**CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T005 [P] Define medication status enum and display metadata in `lib/features/medications/domain/medication.dart`
- [ ] T006 [P] Define medication entity with local id, name, dosage label, notes, status, created date, and updated date in `lib/features/medications/domain/medication.dart`
- [ ] T007 [P] Define medication entry draft and duplicate confirmation state in `lib/features/medications/domain/medication_entry_draft.dart`
- [ ] T008 [P] Implement medication validation result types and 80/80/500 field length rules in `lib/features/medications/domain/medication_validation.dart`
- [ ] T009 Define `MedicationRepository` interface for load/save operations in `lib/features/medications/data/medication_repository.dart`
- [ ] T010 Implement local JSON medication repository using existing local storage dependency in `lib/features/medications/data/local_medication_repository.dart`
- [ ] T011 [P] Add fake medication repository for widget tests in `test/features/medications/fakes/fake_medication_repository.dart`
- [ ] T012 [P] Add medication fixture builders for tests in `test/features/medications/medication_test_fixtures.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Add an Active Medication (Priority: P1) MVP

**Goal**: Users can save a local active medication with required name and optional dosage/notes, preserving user-entered wording without medical interpretation.

**Independent Test**: Open add-medication, enter a name plus optional details, save, and confirm an active saved medication appears locally without internet or account requirements.

### Tests for User Story 1

- [ ] T013 [P] [US1] Add validation unit test for active default and valid draft creation in `test/features/medications/medication_validation_test.dart`
- [ ] T014 [P] [US1] Add repository unit test for saving and reloading name-only active medication in `test/features/medications/medication_repository_test.dart`
- [ ] T015 [P] [US1] Add repository unit test for preserving name, dosage label, notes, status, and timestamps in `test/features/medications/medication_repository_test.dart`
- [ ] T016 [P] [US1] Add widget test for adding an active medication from the main app in `test/features/medications/add_medication_screen_test.dart`
- [ ] T017 [P] [US1] Add widget test for duplicate-name gentle confirmation and save-after-confirm behavior in `test/features/medications/add_medication_screen_test.dart`

### Implementation for User Story 1

- [ ] T018 [US1] Implement medication JSON serialization and deserialization in `lib/features/medications/domain/medication.dart`
- [ ] T019 [US1] Implement save/load behavior in `lib/features/medications/data/local_medication_repository.dart`
- [ ] T020 [US1] Implement add-medication form scaffold with name, dosage label, notes, active default, save, and cancel controls in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T021 [US1] Implement duplicate-name confirmation dialog with non-blocking plain-language copy in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T022 [US1] Implement medication list display using user-entered wording in `lib/features/medications/presentation/medication_list_section.dart`
- [ ] T023 [US1] Wire medication repository and add-medication navigation into the main app in `lib/main.dart`
- [ ] T024 [US1] Add English, Spanish, and Latin American Spanish strings for active add/save/list/duplicate flows in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 1 is functional and testable as the MVP.

---

## Phase 4: User Story 2 - Understand Privacy Before Saving (Priority: P2)

**Goal**: Users see clear privacy reassurance that medication information stays on the device and no account or internet is required.

**Independent Test**: Open the add-medication flow and confirm privacy copy is visible, localized, readable, and the flow works offline without account prompts.

### Tests for User Story 2

- [ ] T025 [P] [US2] Add widget test for visible on-device privacy copy in `test/features/medications/add_medication_screen_test.dart`
- [ ] T026 [P] [US2] Add widget test proving no account, sync, analytics, donation, or remote-service prompts appear in `test/features/medications/add_medication_screen_test.dart`
- [ ] T027 [P] [US2] Add localization widget test for English and Latin American Spanish privacy copy in `test/features/medications/add_medication_screen_test.dart`

### Implementation for User Story 2

- [ ] T028 [US2] Add privacy reassurance block to add-medication form in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T029 [US2] Add localized privacy and no-account copy in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`
- [ ] T030 [US2] Ensure local repository is the only medication persistence dependency used by add-medication flow in `lib/features/medications/data/local_medication_repository.dart`

**Checkpoint**: User Story 2 works independently and preserves User Story 1.

---

## Phase 5: User Story 3 - Save Medication as Inactive (Priority: P3)

**Goal**: Users can save a medication as inactive and see inactive status represented with text and accessible semantics, not color alone.

**Independent Test**: Select inactive, save, and confirm the saved medication displays inactive status using visible text and screen-reader-accessible wording.

### Tests for User Story 3

- [ ] T031 [P] [US3] Add validation unit test for selected inactive status in `test/features/medications/medication_validation_test.dart`
- [ ] T032 [P] [US3] Add repository unit test for persisting inactive status in `test/features/medications/medication_repository_test.dart`
- [ ] T033 [P] [US3] Add widget test for selecting inactive before save in `test/features/medications/add_medication_screen_test.dart`
- [ ] T034 [P] [US3] Add widget test for visible and semantic inactive status display in `test/features/medications/add_medication_screen_test.dart`

### Implementation for User Story 3

- [ ] T035 [US3] Implement active/inactive segmented control with active default in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T036 [US3] Implement medication status label with non-color-only text and semantics in `lib/features/medications/presentation/medication_status_label.dart`
- [ ] T037 [US3] Display inactive status in saved medication list in `lib/features/medications/presentation/medication_list_section.dart`
- [ ] T038 [US3] Add localized active and inactive status labels in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 3 works independently and preserves previous stories.

---

## Phase 6: User Story 4 - Recover From Entry Mistakes (Priority: P3)

**Goal**: Users receive plain validation feedback for missing or too-long fields and can correct issues without losing optional text.

**Independent Test**: Attempt to save invalid entries, confirm screen-reader-readable validation messages, correct the name, and verify optional dosage/notes remain intact.

### Tests for User Story 4

- [ ] T039 [P] [US4] Add unit tests for blank and whitespace-only medication name validation in `test/features/medications/medication_validation_test.dart`
- [ ] T040 [P] [US4] Add unit tests for medication name 80, dosage label 80, and notes 500 character limits in `test/features/medications/medication_validation_test.dart`
- [ ] T041 [P] [US4] Add widget test for missing-name validation preserving dosage and notes in `test/features/medications/add_medication_screen_test.dart`
- [ ] T042 [P] [US4] Add widget test for max-length validation messages using text and screen-reader semantics in `test/features/medications/add_medication_screen_test.dart`
- [ ] T043 [P] [US4] Add widget test for canceling add-medication without saving a record in `test/features/medications/add_medication_screen_test.dart`

### Implementation for User Story 4

- [ ] T044 [US4] Wire medication validation into add-medication save flow in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T045 [US4] Implement plain-language validation message presentation with semantics in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T046 [US4] Preserve dosage label and notes after validation failure in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T047 [US4] Implement cancel behavior that exits without repository save in `lib/features/medications/presentation/add_medication_screen.dart`
- [ ] T048 [US4] Add localized validation and cancel strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Story 4 works independently and all user stories are functional.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verify accessibility, localization, privacy, local-first behavior, performance, and documentation across the full add-medication experience.

- [ ] T049 [P] Review add-medication UI against `specs/002-add-medication/ux-design.md`
- [ ] T050 [P] Review all add-medication English, Spanish, and Latin American Spanish strings in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`
- [ ] T051 [P] Add accessibility regression coverage for large text, focus labels, validation announcements, and non-color-only status in `test/features/medications/add_medication_screen_test.dart`
- [ ] T052 [P] Add privacy regression coverage proving no Firebase, account, sync, backup, analytics, donation, sharing, or remote-service behavior in `test/features/medications/add_medication_screen_test.dart`
- [ ] T053 Verify offline save and phone/tablet layout manually using `specs/002-add-medication/quickstart.md`
- [ ] T054 Verify add-medication screen open and save responsiveness against `specs/002-add-medication/quickstart.md`
- [ ] T055 Run `flutter test test/features/medications/` and `flutter analyze lib/features/medications/` for `test/features/medications/` and `lib/features/medications/`
- [ ] T056 Update manual verification notes in `specs/002-add-medication/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion - blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion - MVP scope.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and integrates with the add-medication form.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and integrates with the add-medication form/list.
- **User Story 4 (Phase 6)**: Depends on Foundational completion and can be developed alongside US2/US3 after US1 form scaffold exists.
- **Polish (Phase 7)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational phase; no dependency on other stories.
- **User Story 2 (P2)**: Can start after Foundational phase; easiest after US1 form scaffold exists.
- **User Story 3 (P3)**: Can start after Foundational phase; easiest after US1 persistence and list display exist.
- **User Story 4 (P3)**: Can start after Foundational phase; easiest after US1 form scaffold exists.

### Within Each User Story

- Tests should be written before implementation tasks in that story.
- Domain validation and repository behavior must exist before UI relies on them.
- UI should use localized strings rather than hard-coded user-facing copy.
- Story checkpoint should pass before moving to the next priority.

## Parallel Opportunities

- T002, T003, and T004 can run in parallel during Setup.
- T005, T006, T007, T008, T011, and T012 can run in parallel during Foundational.
- T013 through T017 can run in parallel before US1 implementation.
- T025 through T027 can run in parallel before US2 implementation.
- T031 through T034 can run in parallel before US3 implementation.
- T039 through T043 can run in parallel before US4 implementation.
- T049 through T052 can run in parallel during Polish.

## Parallel Example: User Story 1

```bash
Task: "T013 [P] [US1] Add validation unit test for active default and valid draft creation in test/features/medications/medication_validation_test.dart"
Task: "T014 [P] [US1] Add repository unit test for saving and reloading name-only active medication in test/features/medications/medication_repository_test.dart"
Task: "T016 [P] [US1] Add widget test for adding an active medication from the main app in test/features/medications/add_medication_screen_test.dart"
Task: "T017 [P] [US1] Add widget test for duplicate-name gentle confirmation and save-after-confirm behavior in test/features/medications/add_medication_screen_test.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T025 [P] [US2] Add widget test for visible on-device privacy copy in test/features/medications/add_medication_screen_test.dart"
Task: "T026 [P] [US2] Add widget test proving no account, sync, analytics, donation, or remote-service prompts appear in test/features/medications/add_medication_screen_test.dart"
Task: "T027 [P] [US2] Add localization widget test for English and Latin American Spanish privacy copy in test/features/medications/add_medication_screen_test.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T031 [P] [US3] Add validation unit test for selected inactive status in test/features/medications/medication_validation_test.dart"
Task: "T032 [P] [US3] Add repository unit test for persisting inactive status in test/features/medications/medication_repository_test.dart"
Task: "T034 [P] [US3] Add widget test for visible and semantic inactive status display in test/features/medications/add_medication_screen_test.dart"
```

## Parallel Example: User Story 4

```bash
Task: "T039 [P] [US4] Add unit tests for blank and whitespace-only medication name validation in test/features/medications/medication_validation_test.dart"
Task: "T040 [P] [US4] Add unit tests for medication name 80, dosage label 80, and notes 500 character limits in test/features/medications/medication_validation_test.dart"
Task: "T043 [P] [US4] Add widget test for canceling add-medication without saving a record in test/features/medications/add_medication_screen_test.dart"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate active medication add, duplicate confirmation, local save, and saved list display.

### Incremental Delivery

1. Deliver US1 for local active medication creation.
2. Add US2 for privacy reassurance and no-account/offline confidence.
3. Add US3 for inactive medications and accessible status display.
4. Add US4 for validation recovery and cancel behavior.
5. Run Polish tasks before release.

### Notes

- Keep Firebase out of this feature implementation; preserve only the repository boundary for future migration.
- Keep medication scheduling, refill tracking, clinical safety checks, import/export, backup, sync, and account flows out of scope.
- Do not infer medical meaning from name, dosage label, notes, or status.

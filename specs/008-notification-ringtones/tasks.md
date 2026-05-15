# Tasks: Notification Ringtones

**Input**: Design documents from `/specs/008-notification-ringtones/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/notification-ringtone-ui.md, quickstart.md

**Tests**: Required for this feature because it affects reminder reliability, notification delivery details, persistence, accessibility states, localization, permissions, and privacy. Platform notification sound playback still requires manual Android/iOS verification.

**Organization**: Tasks are grouped by user story so each story can be implemented and tested independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel because it touches different files and has no dependency on incomplete tasks
- **[Story]**: User story label for story phases only
- Each task includes an exact file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add package, asset, and platform resource structure needed by all ringtone stories.

- [ ] T001 Add the lightweight preview playback dependency and register `assets/audio/notifications/` in `pubspec.yaml`
- [ ] T002 [P] Add finalized curated Flutter preview audio files in `assets/audio/notifications/`
- [ ] T003 [P] Create Android raw resource sound files for the curated catalog in `android/app/src/main/res/raw/`
- [ ] T004 [P] Add iOS bundled sound resources for the curated catalog under `ios/Runner/`
- [ ] T005 Document platform asset naming and manual sound packaging checks in `specs/008-notification-ringtones/quickstart.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core ringtone catalog, persistence, and localization scaffolding that MUST be complete before any user story implementation.

**CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T006 [P] Create `RingtoneOption` and `NotificationRingtonePreference` domain types with validation helpers in `lib/features/notifications/domain/notification_ringtone.dart`
- [ ] T007 [P] Create the bundled ringtone catalog with stable ids, display-name keys, preview assets, Android raw names, iOS filenames, and default option in `lib/features/notifications/domain/notification_ringtone_catalog.dart`
- [ ] T008 [P] Add unit tests for catalog invariants, stable id format, default uniqueness, and platform asset metadata in `test/features/notifications/notification_ringtone_catalog_test.dart`
- [ ] T009 Create the `NotificationRingtoneRepository` interface and shared preference key constants in `lib/features/notifications/data/notification_ringtone_repository.dart`
- [ ] T010 Implement `LocalNotificationRingtoneRepository` with missing, unknown, unavailable, save, and clear behavior in `lib/features/notifications/data/local_notification_ringtone_repository.dart`
- [ ] T011 [P] Add repository tests for default resolution, unknown-id fallback, unavailable warning state, and saving available options in `test/features/notifications/local_notification_ringtone_repository_test.dart`
- [ ] T012 [P] Add fake ringtone repository support for widget and scheduler tests in `test/features/notifications/fakes/fake_notification_ringtone_repository.dart`
- [ ] T013 [P] Add base ringtone localization keys for English in `lib/l10n/app_en.arb`
- [ ] T014 [P] Add base ringtone localization keys for Spanish in `lib/l10n/app_es.arb`
- [ ] T015 [P] Add base ringtone localization keys for Latin American Spanish in `lib/l10n/app_es_419.arb`
- [ ] T016 Regenerate Flutter localization outputs after ARB changes in `lib/l10n/app_localizations.dart`

**Checkpoint**: Ringtone catalog, persistence, fakes, and localization scaffolding are ready.

---

## Phase 3: User Story 1 - Choose a Reminder Ringtone (Priority: P1) MVP

**Goal**: Users can open notification sound settings, choose one bundled ringtone, save it locally, see the current choice, and have future medication notifications use that sound.

**Independent Test**: Select a ringtone in settings, schedule or trigger a medication reminder, and confirm notification details resolve to the saved sound.

### Tests for User Story 1

- [ ] T017 [P] [US1] Add widget tests for opening the notification ringtone picker, selecting an option, saving it, and showing the saved choice in `test/features/settings/notification_ringtone_picker_screen_test.dart`
- [ ] T018 [P] [US1] Add settings entry widget tests for current ringtone display and notification permission explanation in `test/features/settings/settings_screen_test.dart`
- [ ] T019 [P] [US1] Add scheduler tests proving daily scheduled reminders, due-now reminders, remind-later reminders, and suppress-today reschedules use the selected ringtone details in `test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T020 [P] [US1] Add localization coverage tests for ringtone picker and settings strings in `test/features/settings/notification_ringtone_localization_test.dart`

### Implementation for User Story 1

- [ ] T021 [P] [US1] Create `NotificationRingtonePickerScreen` with selectable bundled options, selected state, save, and cancel controls in `lib/features/settings/presentation/notification_ringtone_picker_screen.dart`
- [ ] T022 [US1] Integrate ringtone repository dependencies into `SettingsScreen` and add the notification sound row in `lib/features/settings/presentation/settings_screen.dart`
- [ ] T023 [US1] Wire `NotificationRingtonePickerScreen` navigation from the settings notification section in `lib/features/settings/presentation/settings_screen.dart`
- [ ] T024 [US1] Inject `LocalNotificationRingtoneRepository` into app construction and settings dependencies in `lib/main.dart`
- [ ] T025 [US1] Extend `LocalReminderNotificationScheduler` to accept a ringtone repository and resolve the active ringtone before building notification details in `lib/services/reminder_notification_scheduler.dart`
- [ ] T026 [US1] Replace hard-coded notification detail constants with ringtone-aware builders for daily, due-now, suppress-today, and remind-later flows in `lib/services/reminder_notification_scheduler.dart`
- [ ] T027 [US1] Add Android per-ringtone channel ids and `RawResourceAndroidNotificationSound` mapping in `lib/services/reminder_notification_scheduler.dart`
- [ ] T028 [US1] Add iOS `DarwinNotificationDetails.sound` mapping and category preservation in `lib/services/reminder_notification_scheduler.dart`
- [ ] T029 [US1] Update scheduler fakes to preserve existing medication tests after constructor and interface changes in `test/features/medications/fakes/fake_reminder_notification_scheduler.dart`
- [ ] T030 [US1] Add selected/current ringtone labels, save confirmation, and device-setting limitation copy to generated localization usage in `lib/features/settings/presentation/notification_ringtone_picker_screen.dart`

**Checkpoint**: User Story 1 is fully functional and independently testable as the MVP.

---

## Phase 4: User Story 2 - Preview Ringtones Before Saving (Priority: P2)

**Goal**: Users can hear a short sample before saving, previewing one ringtone at a time without changing the saved preference until confirmation.

**Independent Test**: Open the picker, preview multiple options, confirm the first preview stops when the second starts, dismiss the picker, and confirm preview playback stops without changing the saved ringtone.

### Tests for User Story 2

- [ ] T031 [P] [US2] Add preview service tests for play, stop, switching samples, and dispose behavior in `test/features/notifications/ringtone_preview_player_test.dart`
- [ ] T032 [P] [US2] Add picker widget tests for preview buttons, unsaved preview behavior, and stop-on-dismiss behavior in `test/features/settings/notification_ringtone_picker_screen_test.dart`

### Implementation for User Story 2

- [ ] T033 [P] [US2] Create `RingtonePreviewPlayer` abstraction and asset-player implementation in `lib/features/notifications/services/ringtone_preview_player.dart`
- [ ] T034 [P] [US2] Create fake preview player for widget tests in `test/features/notifications/fakes/fake_ringtone_preview_player.dart`
- [ ] T035 [US2] Inject `RingtonePreviewPlayer` into `NotificationRingtonePickerScreen` and add accessible preview controls in `lib/features/settings/presentation/notification_ringtone_picker_screen.dart`
- [ ] T036 [US2] Ensure preview playback stops when another option is previewed, when save/cancel is tapped, and when the picker is disposed in `lib/features/settings/presentation/notification_ringtone_picker_screen.dart`
- [ ] T037 [US2] Add preview action labels and preview status copy to all localization resources in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: User Stories 1 and 2 both work independently.

---

## Phase 5: User Story 3 - Recover When a Sound Cannot Be Used (Priority: P3)

**Goal**: If a saved ringtone is unavailable, reminders use the default sound and settings clearly explain that the previous choice needs replacement.

**Independent Test**: Simulate a saved unavailable ringtone id, trigger reminder detail resolution, and verify default sound fallback plus visible settings warning.

### Tests for User Story 3

- [ ] T038 [P] [US3] Add repository and resolver tests for unavailable saved ringtone warnings and warning clearing after save in `test/features/notifications/local_notification_ringtone_repository_test.dart`
- [ ] T039 [P] [US3] Add scheduler fallback tests proving unavailable selected ringtones resolve to default sound details in `test/features/medications/reminder_notification_scheduler_test.dart`
- [ ] T040 [P] [US3] Add settings and picker warning tests for unavailable saved ringtone copy, semantics, and choose-another prompt in `test/features/settings/notification_ringtone_picker_screen_test.dart`

### Implementation for User Story 3

- [ ] T041 [US3] Surface unavailable saved ringtone state from `LocalNotificationRingtoneRepository` to settings in `lib/features/notifications/data/local_notification_ringtone_repository.dart`
- [ ] T042 [US3] Render localized unavailable-ringtone warning and choose-another prompt in `lib/features/settings/presentation/settings_screen.dart`
- [ ] T043 [US3] Render unavailable state with visible text and semantics in `lib/features/settings/presentation/notification_ringtone_picker_screen.dart`
- [ ] T044 [US3] Ensure scheduler fallback uses the default ringtone option when preference resolution reports an unavailable saved id in `lib/services/reminder_notification_scheduler.dart`
- [ ] T045 [US3] Add unavailable warning copy to all localization resources in `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_es_419.arb`

**Checkpoint**: All user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation across accessibility, localization, privacy, performance, and platform notification behavior.

- [ ] T046 [P] Add large-text, screen reader label, selected-state, touch-target, and non-color-only accessibility checks for the ringtone picker in `test/features/settings/notification_ringtone_picker_screen_test.dart`
- [ ] T047 [P] Add privacy regression assertions that ringtone settings do not request file/media access, accounts, analytics, ads, backup, sync, or donation flows in `test/features/settings/settings_screen_test.dart`
- [ ] T048 [P] Add manual Android notification sound verification notes and results checklist in `specs/008-notification-ringtones/quickstart.md`
- [ ] T049 [P] Add manual iOS notification sound verification notes and results checklist in `specs/008-notification-ringtones/quickstart.md`
- [ ] T050 [P] Verify ringtone performance goals for picker open time under 500ms, preview start under 250ms, no startup network work, and no recurring background work in `specs/008-notification-ringtones/quickstart.md`
- [ ] T051 [P] Add restart and offline persistence manual verification for saved ringtone preference in `specs/008-notification-ringtones/quickstart.md`
- [ ] T052 Run `flutter gen-l10n` and verify generated localization files in `lib/l10n/app_localizations.dart`
- [ ] T053 Run `dart format` on changed Dart files under `lib/` and `test/`
- [ ] T054 Run `flutter analyze` and resolve feature-related diagnostics in `lib/` and `test/`
- [ ] T055 Run `flutter test` and resolve feature-related failures in `test/`
- [ ] T056 Review settings UX against `docs/ux-design.md` and adjust ringtone picker spacing, copy, and control sizes in `lib/features/settings/presentation/notification_ringtone_picker_screen.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion; MVP scope.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and integrates into the picker created by US1.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and integrates with repository, settings, picker, and scheduler behavior from US1.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational; no dependency on US2 or US3.
- **User Story 2 (P2)**: Can start after Foundational, but UI integration is simplest after T021 creates the picker.
- **User Story 3 (P3)**: Can start after Foundational, but scheduler and warning integration are simplest after US1 repository/settings wiring.

### Within Each User Story

- Tests are listed before implementation and should fail before implementation.
- Domain/catalog work precedes repository and UI integration.
- Repository and fake support precede widget and scheduler wiring.
- Scheduler builders must preserve existing notification actions and category identifiers.
- Localization keys must be added before relying on generated localization getters in UI code.

### Parallel Opportunities

- T002, T003, and T004 can run in parallel after T001 decisions are clear.
- T006, T007, T008, T012, T013, T014, and T015 can run in parallel during Foundational work.
- T017, T018, T019, and T020 can be written in parallel before US1 implementation.
- T021 can proceed in parallel with T025-T028 once repository contracts exist.
- T031 and T032 can be written in parallel for US2.
- T033 and T034 can be implemented in parallel for US2.
- T038, T039, and T040 can be written in parallel for US3.
- T046, T047, T048, and T049 can be handled in parallel during Polish.

---

## Parallel Example: User Story 1

```bash
# Launch US1 tests in parallel workstreams:
Task: "T017 [US1] Add picker save-flow widget tests in test/features/settings/notification_ringtone_picker_screen_test.dart"
Task: "T018 [US1] Add settings entry widget tests in test/features/settings/settings_screen_test.dart"
Task: "T019 [US1] Add scheduler selected-ringtone tests in test/features/medications/reminder_notification_scheduler_test.dart"
Task: "T020 [US1] Add localization coverage tests in test/features/settings/notification_ringtone_localization_test.dart"

# Launch non-overlapping US1 implementation work:
Task: "T021 [US1] Create picker UI in lib/features/settings/presentation/notification_ringtone_picker_screen.dart"
Task: "T025 [US1] Add ringtone resolution to lib/services/reminder_notification_scheduler.dart"
Task: "T029 [US1] Update scheduler fake in test/features/medications/fakes/fake_reminder_notification_scheduler.dart"
```

## Parallel Example: User Story 2

```bash
Task: "T031 [US2] Add preview service tests in test/features/notifications/ringtone_preview_player_test.dart"
Task: "T032 [US2] Add picker preview widget tests in test/features/settings/notification_ringtone_picker_screen_test.dart"
Task: "T033 [US2] Create preview player in lib/features/notifications/services/ringtone_preview_player.dart"
Task: "T034 [US2] Create fake preview player in test/features/notifications/fakes/fake_ringtone_preview_player.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T038 [US3] Add repository unavailable-warning tests in test/features/notifications/local_notification_ringtone_repository_test.dart"
Task: "T039 [US3] Add scheduler fallback tests in test/features/medications/reminder_notification_scheduler_test.dart"
Task: "T040 [US3] Add settings warning tests in test/features/settings/notification_ringtone_picker_screen_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 setup for dependencies and platform asset locations.
2. Complete Phase 2 foundational catalog, repository, fakes, and localization scaffolding.
3. Complete Phase 3 User Story 1.
4. Stop and validate US1 with `flutter test test/features/settings/notification_ringtone_picker_screen_test.dart test/features/medications/reminder_notification_scheduler_test.dart`.
5. Manually verify one Android or iOS notification uses the selected ringtone when device sound playback is allowed.

### Incremental Delivery

1. Setup + Foundational: ringtone metadata, persistence, and localization baseline.
2. US1: save a ringtone and apply it to future reminders.
3. US2: preview before saving.
4. US3: unavailable-sound fallback and user recovery.
5. Polish: accessibility, privacy, localization, full test suite, and manual platform verification.

### Parallel Team Strategy

1. One developer owns platform assets and `pubspec.yaml`.
2. One developer owns domain/repository/fakes under `lib/features/notifications/` and `test/features/notifications/`.
3. One developer owns settings UI under `lib/features/settings/presentation/` and `test/features/settings/`.
4. One developer owns scheduler integration under `lib/services/reminder_notification_scheduler.dart` and `test/features/medications/reminder_notification_scheduler_test.dart`.

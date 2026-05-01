# Implementation Plan: Edit, Pause, Resume

**Branch**: `006-edit-pause-resume` | **Date**: 2026-05-01 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/005-edit-pause-resume/spec.md`

## Summary

Add simple, local-first controls for editing medication details, editing daily
reminder schedules, pausing/resuming all reminders for one medication, and
deleting a medication or schedule after clear confirmation. The implementation
extends the existing Flutter medication feature, repositories, due-reminder
state, and local notification scheduler so saved changes atomically replace
future reminders, cancel obsolete scheduled/due/later notifications, survive app
restart, and remain accessible/localizable for older adults in English and Latin
American Spanish.

## Technical Context

**Language/Version**: Flutter `3.41.8`, Dart SDK `^3.11.5`, Flutter Material 3  
**Primary Dependencies**: Flutter SDK, existing localization setup, existing
`shared_preferences`, `permission_handler`, `flutter_local_notifications`,
`flutter_timezone`, `timezone`, and `intl`; no new third-party dependency  
**Storage**: Local JSON medication, reminder schedule, due-reminder, and
remind-again-later records persisted through existing repository interfaces;
pause state stored locally with the medication or medication reminder status;
confirmed deletions remove local records and associated pending reminder data  
**Testing**: `flutter test`, unit tests for medication/schedule update rules,
pause/resume state transitions, deletion cleanup, idempotent notification
replacement, and validation; widget tests for edit, review, confirmation, error,
large text, screen reader semantics, and localization; manual iOS/Android
notification cancellation/rescheduling verification  
**Target Platform**: iOS and Android phones and tablets  
**Project Type**: Mobile app  
**Performance Goals**: Edit, pause, resume, and delete actions persist locally
and update in-app state within 1 second for typical v1 data volumes; notification
replacement/cancellation completes without perceptible delay for up to the
supported daily reminder limit; startup reconciliation adds no more than 300ms
for typical local records; no polling or continuous background work  
**Constraints**: Follow `docs/ux-design.md`; account-free, offline-capable,
private on-device data; one clear decision per confirmation where practical;
large text, screen readers, high contrast, 48px minimum touch targets with 56px
preferred actions, visible focus, logical reading order, non-color-only status;
English and Latin American Spanish strings, dates, and times; no clinical
advice, sync, backup, analytics, caregiver sharing, undo, archive, trash, or
restore in v1  
**Scale/Scope**: Existing single-device local reminders; saved medications with
one simple daily reminder schedule, optional end date, due-reminder state, and
remind-again-later request; schedule edits respect the existing maximum of 4
daily times; automatic resume dates and editing reminder outcome history are out
of scope

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - Flows are bounded to edit details, edit
  schedule, pause/resume, and confirmed deletion. Pause is manual until resume,
  avoiding date/time pause configuration in v1.
- **Setup/onboarding UX baseline**: PASS - This is not onboarding, but all
  user-facing flows follow `docs/ux-design.md` for calm tone, readable screens,
  generous spacing, pressure-free choices, and one decision per screen where
  practical.
- **Accessibility for older adults**: PASS - Large text, screen reader labels,
  contrast, touch targets, visible focus, logical reading order, non-color-only
  paused/destructive states, and correction-preserving errors are planned.
- **Reliable local-first reminders**: PASS - All changes save locally, work
  offline/account-free, replace/cancel future notifications deterministically,
  cancel due/later reminders when needed, and survive app/device restart.
- **Privacy and user control**: PASS - Medication names, dosage labels,
  schedules, pause state, deletion outcomes, and reminder state remain on
  device; no account, sync, backup, analytics, sharing, or remote service is
  added.
- **Maintainable architecture**: PASS - Domain rules, repositories, notification
  scheduling/cancellation, due-reminder cleanup, permission messaging, and
  presentation remain separated behind existing feature/service boundaries.
- **Testing gate**: PASS - Automated tests cover validation, persistence,
  idempotency, pause/resume, deletion cleanup, permissions, accessibility,
  localization, and restart recovery; manual checks cover platform notification
  replacement and cancellation.
- **Consistent, localizable experience**: PASS - All visible text, status labels,
  confirmation copy, errors, schedule summaries, notification text, dates, and
  times are planned for English and Latin American Spanish localization.
- **Measured performance**: PASS - Action latency, notification update latency,
  startup reconciliation, and no continuous background work are explicitly
  constrained.

## Project Structure

### Documentation (this feature)

```text
specs/005-edit-pause-resume/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── edit-pause-resume-contract.md
└── spec.md
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── medications/
│       ├── data/
│       │   ├── due_reminder_repository.dart
│       │   ├── local_due_reminder_repository.dart
│       │   ├── local_medication_repository.dart
│       │   ├── local_reminder_schedule_repository.dart
│       │   ├── medication_repository.dart
│       │   └── reminder_schedule_repository.dart
│       ├── domain/
│       │   ├── medication.dart
│       │   ├── medication_entry_draft.dart
│       │   ├── medication_validation.dart
│       │   ├── reminder_schedule.dart
│       │   ├── reminder_schedule_draft.dart
│       │   └── reminder_schedule_validation.dart
│       └── presentation/
│           ├── add_medication_screen.dart
│           ├── medication_list_section.dart
│           ├── medication_status_label.dart
│           ├── reminder_schedule_review.dart
│           ├── reminder_schedule_screen.dart
│           └── reminder_time_selector.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
├── services/
│   ├── notification_permission_service.dart
│   ├── reminder_due_reconciler.dart
│   └── reminder_notification_scheduler.dart
└── main.dart

test/
└── features/
    └── medications/
        ├── medication_repository_test.dart
        ├── medication_validation_test.dart
        ├── reminder_schedule_repository_test.dart
        ├── reminder_schedule_screen_test.dart
        ├── reminder_schedule_validation_test.dart
        ├── edit_medication_screen_test.dart
        ├── edit_pause_resume_flow_test.dart
        ├── reminder_notification_scheduler_test.dart
        └── fakes/
            ├── fake_due_reminder_repository.dart
            ├── fake_medication_repository.dart
            ├── fake_reminder_notification_scheduler.dart
            └── fake_reminder_schedule_repository.dart
```

**Structure Decision**: Extend `lib/features/medications/` because editing,
pausing, resuming, and deleting operate on saved medication and schedule records
already owned by that feature. Keep notification cancellation/replacement in
`lib/services/reminder_notification_scheduler.dart` and due/later cleanup behind
the existing due-reminder repository/reconciler boundaries so platform side
effects stay separate from domain state and widgets.

## Complexity Tracking

No constitution violations.

## Design Justifications

| Added Design Choice | Why Needed | Simpler Alternative Rejected Because |
|---------------------|------------|-------------------------------------|
| Medication-level pause state | The spec requires pausing all reminders for a medication until manual resume while preserving medication and schedule data | Deleting or disabling individual reminder times would lose the saved routine and make resume harder |
| Atomic reminder replacement flow | Schedule edits, pause/resume, and delete must remove obsolete future notifications and prevent duplicates | Saving data first and relying on later reconciliation alone could leave old notifications active |
| Shared confirmation component/copy contract | Schedule deletion and medication deletion need clear, accessible, localized consequences | Browser/OS default dialogs would not reliably provide screen reader order, localization, or calm older-adult copy |
| Due/later cleanup on pause and delete | Pending due reminders and remind-again-later requests must stop when the medication or schedule no longer produces reminders | Canceling only repeating schedule notifications would allow stale due/later alerts |

## Phase 0: Research Summary

Research decisions are documented in [research.md](./research.md). All planning
choices are resolved with existing Flutter, local persistence, notification
scheduler, due-reminder cleanup, and UX/accessibility patterns already present
in the project.

## Phase 1: Design Summary

- Medication, schedule, pause state, deletion confirmation, notification
  permission, and cleanup entities are documented in
  [data-model.md](./data-model.md).
- UI, repository, scheduler, localization, accessibility, and testing contracts
  are documented in
  [contracts/edit-pause-resume-contract.md](./contracts/edit-pause-resume-contract.md).
- Developer and manual verification guidance is documented in
  [quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - Design keeps pause manual, uses
  existing edit screens/patterns, and separates medication deletion from
  schedule deletion with clear confirmation copy.
- **Setup/onboarding UX baseline**: PASS - User-facing controls follow
  `docs/ux-design.md` for calm sentence-case copy, readable text, generous
  spacing, large actions, and pressure-free cancel paths.
- **Accessibility for older adults**: PASS - Contract requires semantics,
  focus order, large text behavior, high contrast, large touch targets,
  correction-preserving validation, and non-color-only paused/destructive states.
- **Reliable local-first reminders**: PASS - Data model and contracts require
  local persistence, deterministic cancel/reschedule order, due/later cleanup,
  restart recovery, and duplicate prevention.
- **Privacy and user control**: PASS - Data remains local and confirmed deletion
  removes medication/schedule/reminder records without adding sync, backup,
  analytics, sharing, undo, archive, or restore.
- **Maintainable architecture**: PASS - Design uses existing medication domain,
  repository, l10n, notification scheduler, due-reminder, and presentation
  boundaries with no new package or architectural layer.
- **Testing gate**: PASS - Quickstart and contract identify automated unit and
  widget tests plus manual iOS/Android notification cancellation/rescheduling
  checks.
- **Consistent, localizable experience**: PASS - Contract requires ARB entries
  and localized date/time formatting for all edit, pause, resume, delete,
  confirmation, error, status, and notification strings.
- **Measured performance**: PASS - Action latency, notification updates, startup
  reconciliation, and background work constraints remain explicit.

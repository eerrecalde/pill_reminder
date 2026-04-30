# Implementation Plan: Reminder Schedule

**Branch**: `003-reminder-schedule` | **Date**: 2026-04-30 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/003-reminder-schedule/spec.md`

## Summary

Build a calm, accessible Flutter Material reminder schedule flow for saved active
medications. Users can choose one to four daily reminder times, optionally choose
an end date, review a localized plain-language summary, and save the schedule
locally without an account or internet connection. The flow follows
`docs/ux-design.md`, keeps inactive medication activation outside scheduling,
and uses repository and notification-scheduler boundaries so persistence,
validation, notification delivery, and presentation remain testable.

## Technical Context

**Language/Version**: Flutter `3.41.8`, Dart SDK `^3.11.5`, Flutter Material 3  
**Primary Dependencies**: Flutter SDK, existing localization setup, existing
`shared_preferences` and `permission_handler`; planned
`flutter_local_notifications` dependency behind a scheduler interface  
**Storage**: Local JSON reminder schedule records persisted behind a
`ReminderScheduleRepository` interface; medication records remain loaded through
the existing `MedicationRepository`; no Firebase dependency in v1  
**Testing**: `flutter test`, unit tests for schedule validation/repository rules,
widget tests for schedule creation/review/permission/accessibility/localization
flows, manual iOS/Android notification scheduling verification  
**Target Platform**: iOS and Android phones and tablets  
**Project Type**: Mobile app  
**Performance Goals**: Schedule flow opens within 1 second from a medication on
a typical phone/tablet; save completes without perceptible delay for normal
local schedule lists; notification scheduling avoids unnecessary background work  
**Constraints**: Flutter Material design, `docs/ux-design.md` UX baseline,
offline-capable, account-free, local-first, one to four daily times, optional end
date, inactive medications blocked from scheduling, large text, screen readers,
large touch targets, English and Latin American Spanish date/time formatting  
**Scale/Scope**: Single-device local schedules for v1; one daily reminder
schedule per active medication; weekly/monthly/interval/as-needed schedules,
start dates, refill tracking, dose tracking, clinical advice, accounts, sync,
backup, import/export, and Firebase are out of scope

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - Flow is bounded to one medication, one
  to four daily times, an optional end date, review, and save. Complex recurrence
  rules and activation inside the schedule flow are out of scope.
- **Setup/onboarding UX baseline**: PASS - Although this is not first-run setup,
  the user-facing flow follows `docs/ux-design.md` for calm tone, one decision
  per screen where practical, 56px preferred primary actions, readable spacing,
  and pressure-free choices.
- **Accessibility for older adults**: PASS - Plan includes large text,
  screen-reader labels, large touch targets, visible focus, non-color-only
  validation/status, and large-text review checks.
- **Reliable local-first reminders**: PASS - Schedules save locally, survive app
  restart, work offline, and use a notification scheduler boundary for platform
  delivery and permission edge cases.
- **Privacy and user control**: PASS - No account, sync, analytics, backup,
  sharing, donation, or remote service is introduced.
- **Maintainable architecture**: PASS - Schedule validation, persistence,
  notification scheduling, permission state, and UI are separated behind small
  domain/repository/scheduler boundaries.
- **Testing gate**: PASS - Automated tests cover validation, persistence,
  permission states, accessibility, localization, and restart behavior; manual
  verification covers platform notification delivery.
- **Consistent, localizable experience**: PASS - Schedule copy, validation,
  review summaries, dates, times, and notification guidance are planned for
  English and Latin American Spanish.
- **Measured performance**: PASS - Flow open/save responsiveness and background
  notification work constraints are defined.

## Project Structure

### Documentation (this feature)

```text
specs/003-reminder-schedule/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── reminder-schedule-flow-contract.md
├── checklists/
│   └── requirements.md
└── spec.md
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── medications/
│       ├── data/
│       │   ├── local_medication_repository.dart
│       │   ├── local_reminder_schedule_repository.dart
│       │   ├── medication_repository.dart
│       │   └── reminder_schedule_repository.dart
│       ├── domain/
│       │   ├── medication.dart
│       │   ├── reminder_schedule.dart
│       │   ├── reminder_schedule_draft.dart
│       │   └── reminder_schedule_validation.dart
│       └── presentation/
│           ├── medication_list_section.dart
│           ├── reminder_schedule_screen.dart
│           ├── reminder_schedule_review.dart
│           └── reminder_time_selector.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
├── services/
│   ├── notification_permission_service.dart
│   └── reminder_notification_scheduler.dart
└── main.dart

test/
└── features/
    └── medications/
        ├── fakes/
        │   └── fake_reminder_schedule_repository.dart
        ├── reminder_schedule_repository_test.dart
        ├── reminder_schedule_screen_test.dart
        └── reminder_schedule_validation_test.dart
```

**Structure Decision**: Extend the existing `lib/features/medications/` module
because schedules belong to saved medications and depend on medication active
status. Add a separate reminder schedule repository and notification scheduler
service so local persistence, platform notification delivery, and presentation
can be tested independently without introducing account, sync, or Firebase
concepts.

## Complexity Tracking

No constitution violations.

## Design Justifications

| Added Design Choice | Why Needed | Simpler Alternative Rejected Because |
|---------------------|------------|-------------------------------------|
| Reminder schedule repository interface | Schedules must survive restart now and may later move to a different persistence layer | Direct storage calls from widgets would couple UI to persistence and make future migration harder |
| Notification scheduler service boundary | Platform notification scheduling and permission behavior need manual and automated test seams | Scheduling directly from widgets would mix platform side effects with UI validation |
| `flutter_local_notifications` dependency | The package supports scheduled local notifications across Android and iOS and is compatible with the current Flutter SDK | Hand-rolled platform channels would add more maintenance risk for v1 |
| Optional end date | User requested simple default indefinite behavior with optional stopping | Required end dates add friction; full date-range recurrence adds v1 complexity |

## Phase 0: Research Summary

Research decisions are documented in [research.md](./research.md). All planning
choices are resolved with conservative Flutter Material defaults aligned to the
constitution, existing medication feature structure, and `docs/ux-design.md`.

## Phase 1: Design Summary

- Reminder schedule entities, validation rules, and state transitions are
  documented in [data-model.md](./data-model.md).
- UI, repository, and notification scheduler contracts are documented in
  [contracts/reminder-schedule-flow-contract.md](./contracts/reminder-schedule-flow-contract.md).
- Developer and manual verification guidance is documented in
  [quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - Design keeps schedule creation to active
  medication, time selection, optional end date, review, and save.
- **Setup/onboarding UX baseline**: PASS - Contract requires `docs/ux-design.md`
  tone, touch targets, spacing, focus, and pressure-free choices for the
  user-facing schedule flow.
- **Accessibility for older adults**: PASS - Contract includes semantics,
  logical reading order, large text, touch targets, validation announcement, and
  non-color-only status.
- **Reliable local-first reminders**: PASS - Data model covers local persistence,
  restart recovery, deterministic daily times, permission states, and scheduler
  recovery after permission enablement.
- **Privacy and user control**: PASS - Data remains on device and no remote
  dependency is added.
- **Maintainable architecture**: PASS - Feature module separates domain
  validation, repository persistence, notification scheduling, and presentation.
- **Testing gate**: PASS - Quickstart and contract identify automated and manual
  checks including platform notification delivery.
- **Consistent, localizable experience**: PASS - Localization resources and
  date/time formatting are part of the implementation plan.
- **Measured performance**: PASS - Opening, saving, and notification scheduling
  are local operations with measurable responsiveness goals.

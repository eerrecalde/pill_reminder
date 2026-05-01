# Implementation Plan: Reminder Notification Handling

**Branch**: `005-reminder-notification-handling` | **Date**: 2026-05-01 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/004-reminder-notification-handling/spec.md`

## Summary

Build a local-first Flutter Material reminder handling experience for due
medication reminders. When a saved active medication schedule reaches a due time,
the app creates one local due-reminder state, shows a clear local notification
when permission allows, and lets the user mark the reminder taken, skip it, or be
reminded again later from the notification or in-app view. The design extends the
existing medication schedule repository and notification scheduler boundaries,
adds local due-reminder persistence and an app-wide configurable remind-again
interval defaulting to 10 minutes, and follows `docs/ux-design.md` for calm,
accessible, private medication handling.

## Technical Context

**Language/Version**: Flutter `3.41.8`, Dart SDK `^3.11.5`, Flutter Material 3  
**Primary Dependencies**: Flutter SDK, existing localization setup, existing
`shared_preferences`, `permission_handler`, `flutter_local_notifications`,
`flutter_timezone`, and `timezone` dependencies  
**Storage**: Local JSON due-reminder records and app-wide reminder handling
preferences persisted behind repository interfaces; medication and schedule
records remain loaded through existing medication/schedule repositories; no
Firebase dependency in v1  
**Testing**: `flutter test`, unit tests for due-reminder state transitions,
repositories, idempotency, permission recovery, and remind-again interval rules;
widget tests for due-reminder handling, accessibility, localization, and disabled
notification states; manual iOS/Android notification action verification  
**Target Platform**: iOS and Android phones and tablets  
**Project Type**: Mobile app  
**Performance Goals**: In-app due-reminder view opens within 1 second from a
notification or medication list on a typical phone/tablet; notification action
handling completes without perceptible delay for normal local reminder lists; app
startup reconciliation for due reminders adds no more than 300ms for typical v1
data volumes; no polling or continuous background work  
**Constraints**: Flutter Material design, `docs/ux-design.md` UX baseline,
offline-capable, account-free, local-first, private on-device medication data,
one app-wide configurable remind-again interval defaulting to 10 minutes,
idempotent reminder states, screen readers, large text, large touch targets,
English and Latin American Spanish notification/action/date/time copy  
**Scale/Scope**: Single-device local reminders for v1; due-reminder state for
saved active daily schedules; multiple medications may become due at nearby
times; custom per-medication snooze intervals, adherence analytics, clinical
advice, caregiver sharing, accounts, sync, backup, import/export, and Firebase
are out of scope

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - Primary handling is bounded to three
  plain actions: taken, skip, and remind again later. The added app-wide setting
  is user-requested, defaults to 10 minutes, and avoids per-medication or
  per-action complexity.
- **Setup/onboarding UX baseline**: PASS - This is not onboarding, but the
  user-facing reminder handling experience follows `docs/ux-design.md` for calm
  tone, large readable text, clear actions, generous spacing, and pressure-free
  choices.
- **Accessibility for older adults**: PASS - Plan includes large text,
  screen-reader labels, logical reading order, large touch targets, visible
  focus, and non-color-only reminder states and validation.
- **Reliable local-first reminders**: PASS - Due-reminder state is local,
  idempotent, recoverable after app/device restart, works offline, and handles
  permission changes through scheduler/reconciliation boundaries.
- **Privacy and user control**: PASS - Medication names, dosage labels,
  schedules, due states, and outcomes remain on device; no account, sync,
  analytics, backup, sharing, or remote service is added.
- **Maintainable architecture**: PASS - Domain state, local persistence,
  notification scheduling/action handling, permission recovery, preferences, and
  presentation remain separated and testable.
- **Testing gate**: PASS - Automated tests cover state transitions,
  persistence, idempotency, permission states, accessibility, localization, and
  restart recovery; manual verification covers platform notification delivery
  and actions.
- **Consistent, localizable experience**: PASS - Notification text, action
  labels, reminder states, dosage labels, dates, and times are planned for
  English and Latin American Spanish.
- **Measured performance**: PASS - In-app open time, local action completion,
  startup reconciliation, and no continuous background work are defined.

## Project Structure

### Documentation (this feature)

```text
specs/004-reminder-notification-handling/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── reminder-notification-handling-contract.md
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
│       │   ├── due_reminder_repository.dart
│       │   ├── local_due_reminder_repository.dart
│       │   ├── local_reminder_schedule_repository.dart
│       │   ├── medication_repository.dart
│       │   └── reminder_schedule_repository.dart
│       ├── domain/
│       │   ├── due_reminder.dart
│       │   ├── medication.dart
│       │   ├── reminder_handling_preferences.dart
│       │   └── reminder_schedule.dart
│       └── presentation/
│           ├── due_reminder_actions.dart
│           ├── due_reminder_banner.dart
│           ├── due_reminder_screen.dart
│           └── reminder_handling_settings.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
├── services/
│   ├── notification_permission_service.dart
│   ├── reminder_action_handler.dart
│   ├── reminder_due_reconciler.dart
│   └── reminder_notification_scheduler.dart
└── main.dart

test/
└── features/
    └── medications/
        ├── due_reminder_repository_test.dart
        ├── due_reminder_state_test.dart
        ├── due_reminder_screen_test.dart
        ├── reminder_action_handler_test.dart
        ├── reminder_due_reconciler_test.dart
        ├── reminder_handling_preferences_test.dart
        ├── reminder_notification_scheduler_test.dart
        └── fakes/
            ├── fake_due_reminder_repository.dart
            └── fake_reminder_notification_scheduler.dart
```

**Structure Decision**: Extend `lib/features/medications/` because due reminders
belong to saved medication schedules and must show medication name/dosage data.
Keep notification action handling and due reconciliation in `lib/services/` so
platform notification side effects remain separate from local domain state and
widget presentation.

## Complexity Tracking

No constitution violations.

## Design Justifications

| Added Design Choice | Why Needed | Simpler Alternative Rejected Because |
|---------------------|------------|-------------------------------------|
| Due reminder repository | Due states and outcomes must survive offline use, notification actions, and app/device restart | Keeping due state only in memory would lose outcomes and make duplicate prevention unreliable |
| Reminder action handler service | Notification actions and in-app actions must update the same state idempotently | Handling notification and in-app actions separately risks contradictory taken/skipped states |
| Due reminder reconciler | Missed notification delivery and restarts must create due states when schedules have elapsed | Depending only on delivered notification callbacks would miss due states when permission is disabled or the app restarts |
| App-wide reminder handling preferences | User requested configurable remind-again later behavior with a 10-minute default | Per-medication or per-action intervals add more choices and harder testing for v1 |

## Phase 0: Research Summary

Research decisions are documented in [research.md](./research.md). All planning
choices are resolved with existing Flutter, local persistence, notification
scheduler, and UX/accessibility patterns already present in the project.

## Phase 1: Design Summary

- Due reminder entities, outcomes, preferences, validation rules, and state
  transitions are documented in [data-model.md](./data-model.md).
- Notification, repository, reconciliation, and UI/state contracts are
  documented in [contracts/reminder-notification-handling-contract.md](./contracts/reminder-notification-handling-contract.md).
- Developer and manual verification guidance is documented in
  [quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - Design keeps due handling to taken,
  skip, and remind again later; configuration is one app-wide setting with a
  10-minute default and no per-medication branching.
- **Setup/onboarding UX baseline**: PASS - Contract requires `docs/ux-design.md`
  tone, touch targets, spacing, focus, and pressure-free choices for the
  user-facing reminder handling experience.
- **Accessibility for older adults**: PASS - Contract includes semantics,
  logical reading order, large text behavior, touch targets, state
  announcements, and non-color-only status.
- **Reliable local-first reminders**: PASS - Data model covers local
  idempotency, restart recovery, offline outcomes, permission changes, and
  remind-again-later overlap prevention.
- **Privacy and user control**: PASS - Data remains on device and no remote
  dependency, analytics, backup, account, sync, or sharing behavior is added.
- **Maintainable architecture**: PASS - Design separates domain state,
  repositories, preferences, notification scheduler, action handler,
  reconciliation, and presentation.
- **Testing gate**: PASS - Quickstart and contract identify automated tests plus
  manual iOS/Android checks for notification delivery and actions.
- **Consistent, localizable experience**: PASS - Localization resources and
  date/time formatting are part of the implementation plan.
- **Measured performance**: PASS - Due view, action handling, startup
  reconciliation, and background work constraints are explicit.

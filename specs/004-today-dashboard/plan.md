# Implementation Plan: Today Dashboard

**Branch**: `004-today-dashboard` | **Date**: 2026-04-30 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/004-today-dashboard/spec.md`

## Summary

Build a local-first Flutter Material today dashboard as the post-setup landing
view. The dashboard derives current-day reminder instances from saved active
medications and reminder schedules, groups them as due now, upcoming, missed,
and handled, and lets users mark due or upcoming reminders as handled directly
from the dashboard. The design adds a small local daily handling repository and
extends the notification scheduler boundary so marking an upcoming reminder
handled suppresses today's alert without introducing accounts, sync, analytics,
or remote services.

## Technical Context

**Language/Version**: Flutter `3.41.8`, Dart SDK `^3.11.5`, Flutter Material 3  
**Primary Dependencies**: Flutter SDK, existing localization setup, `intl`,
`shared_preferences`, `permission_handler`, `flutter_local_notifications`,
`flutter_timezone`, and `timezone`; no new package planned  
**Storage**: Existing local medication and reminder schedule JSON records plus a
new local daily handling JSON store keyed by local date, schedule, medication,
and reminder time  
**Testing**: `flutter test`, unit tests for status derivation, ordering,
handling persistence, and notification suppression; widget tests for dashboard
states, accessibility semantics, large text, and localization; manual
iOS/Android notification verification  
**Target Platform**: iOS and Android phones and tablets  
**Project Type**: Mobile app  
**Performance Goals**: Today dashboard renders locally saved content within 1
second after setup on a typical phone/tablet; marking handled updates visible UI
immediately; day-change refresh avoids polling more frequently than needed  
**Constraints**: Flutter Material design, `docs/ux-design.md` UX baseline,
offline-capable, account-free, local-first, current-day scope only, 60-minute
due-now window, missed after 60 minutes, non-color-only status, large text,
screen readers, high contrast, 48px minimum and 56px preferred touch targets,
English and Latin American Spanish localized copy  
**Scale/Scope**: Single-device local schedules for v1; dashboard covers today's
active scheduled reminders, empty states, and direct handling. Multi-day
calendar, history, dose tracking, clinical advice, accounts, sync, backup,
analytics, donation, sharing, and remote services are out of scope.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - The landing view summarizes today,
  provides one direct handled action where relevant, and keeps add/schedule
  paths reachable without adding new setup steps or advanced filters.
- **Setup/onboarding UX baseline**: PASS - The user-facing dashboard follows
  `docs/ux-design.md` for calm tone, readable spacing, large touch targets,
  visible focus, and pressure-free empty states.
- **Accessibility for older adults**: PASS - Plan covers large text, screen
  reader labels, logical reading order, high contrast, large touch targets, and
  non-color-only status text/icons for every dashboard status.
- **Reliable local-first reminders**: PASS - Dashboard data, handled state, and
  notification suppression are local, deterministic, offline-capable, and
  recover after restart.
- **Privacy and user control**: PASS - No account, sync, analytics, backup,
  sharing, donation, or remote service is introduced.
- **Maintainable architecture**: PASS - Status derivation, daily handling
  persistence, notification scheduling, and UI remain separated behind small
  domain/repository/service boundaries.
- **Testing gate**: PASS - Automated and manual checks cover time windows,
  ordering, persistence, permission states, notification suppression,
  accessibility, localization, and privacy behavior.
- **Consistent, localizable experience**: PASS - Headings, statuses, dates,
  times, empty states, actions, and semantics are planned for English and Latin
  American Spanish with locale-aware formatting.
- **Measured performance**: PASS - Local render/update targets are defined, and
  day-change refresh avoids battery-heavy background polling.

## Project Structure

### Documentation (this feature)

```text
specs/004-today-dashboard/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── today-dashboard-contract.md
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
│       │   ├── daily_reminder_handling_repository.dart
│       │   ├── local_daily_reminder_handling_repository.dart
│       │   ├── local_medication_repository.dart
│       │   ├── local_reminder_schedule_repository.dart
│       │   ├── medication_repository.dart
│       │   └── reminder_schedule_repository.dart
│       ├── domain/
│       │   ├── daily_reminder_handling.dart
│       │   ├── medication.dart
│       │   ├── reminder_schedule.dart
│       │   ├── today_dashboard.dart
│       │   └── today_dashboard_service.dart
│       └── presentation/
│           ├── add_medication_screen.dart
│           ├── medication_list_section.dart
│           ├── reminder_schedule_screen.dart
│           ├── today_dashboard_screen.dart
│           ├── today_empty_state.dart
│           ├── today_reminder_card.dart
│           └── today_section.dart
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
        │   ├── fake_daily_reminder_handling_repository.dart
        │   └── fake_reminder_notification_scheduler.dart
        ├── daily_reminder_handling_repository_test.dart
        ├── today_dashboard_screen_test.dart
        └── today_dashboard_service_test.dart
```

**Structure Decision**: Extend the existing `lib/features/medications/` module
because the dashboard is derived from saved medications and their reminder
schedules. Add dashboard-specific domain/service objects and a daily handling
repository so status computation and persistence are testable outside widgets.
Keep notification side effects in `lib/services/reminder_notification_scheduler.dart`.

## Complexity Tracking

No constitution violations.

## Design Justifications

| Added Design Choice | Why Needed | Simpler Alternative Rejected Because |
|---------------------|------------|-------------------------------------|
| Daily handling repository | Handled state must survive restart, remain local, and suppress today's alert for upcoming reminders | Widget-only state would lose handled reminders on restart and could not safely affect notifications |
| Dashboard derivation service | Due/upcoming/missed/handled grouping has time-window and ordering rules that need deterministic tests | Computing status directly in widgets would mix UI with reminder safety rules |
| Notification suppression method | Marking an upcoming reminder handled must suppress today's alert while keeping future reminders | Leaving the existing recurring notification untouched would violate FR-022 |
| Current-day refresh timer | Dashboard must update when status windows or the calendar day changes while open | Refreshing only on app restart would leave stale due/missed states |

## Phase 0: Research Summary

Research decisions are documented in [research.md](./research.md). All technical
unknowns are resolved using the existing Flutter architecture, local repository
patterns, notification scheduler boundary, localization setup, and
`docs/ux-design.md`.

## Phase 1: Design Summary

- Dashboard entities, fields, relationships, validation rules, and state
  transitions are documented in [data-model.md](./data-model.md).
- UI, repository, derivation service, and notification-suppression contracts are
  documented in [contracts/today-dashboard-contract.md](./contracts/today-dashboard-contract.md).
- Developer and manual verification guidance is documented in
  [quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - The design keeps one landing dashboard,
  direct handled actions, and clear empty-state actions without new
  configuration.
- **Setup/onboarding UX baseline**: PASS - Dashboard components follow
  `docs/ux-design.md` for calm copy, spacing, touch targets, focus, and
  pressure-free choices.
- **Accessibility for older adults**: PASS - Contract requires status text or
  icons, semantics, logical reading order, large text, high contrast, visible
  focus, and accessible handled actions.
- **Reliable local-first reminders**: PASS - Data derives from local repositories
  and daily handling persists locally; notification suppression is handled
  through the existing local scheduler service.
- **Privacy and user control**: PASS - No remote service or data sharing is
  added.
- **Maintainable architecture**: PASS - Domain derivation, persistence,
  notification side effects, and presentation remain independently testable.
- **Testing gate**: PASS - Quickstart and contract identify automated and manual
  checks for time windows, persistence, notifications, accessibility,
  localization, and privacy.
- **Consistent, localizable experience**: PASS - Dashboard strings and date/time
  displays are localized through ARB resources and locale-aware formatting.
- **Measured performance**: PASS - Dashboard rendering, handled updates, and
  refresh scheduling are bounded to local operations with measurable targets.

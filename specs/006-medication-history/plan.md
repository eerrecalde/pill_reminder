# Implementation Plan: Medication History

**Branch**: `007-medication-history` | **Date**: 2026-05-01 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/006-medication-history/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Add a local medication history view reachable from the current reminder experience. The feature will read recent reminder occurrences from local medication, schedule, daily handling, and due reminder state, normalize each occurrence into a single history entry, group entries by local day for a rolling 90-day window, and present calm localized status labels for taken, skipped, missed, and snoozed outcomes with text plus icon/shape indicators. The implementation stays within the existing Flutter feature structure and SharedPreferences-backed repositories.

## Technical Context

**Language/Version**: Dart SDK ^3.11.5 with Flutter  
**Primary Dependencies**: Flutter Material, flutter_localizations, intl, shared_preferences, existing notification/reminder services  
**Storage**: Local SharedPreferences JSON/string-list repositories already used by medications, schedules, due reminders, daily reminder handling, and setup preferences  
**Testing**: flutter_test via `flutter test`; targeted domain, repository, widget, l10n, and accessibility-oriented widget tests  
**Target Platform**: Flutter mobile app, with existing iOS/Android/web/desktop project scaffolding; primary reminder behavior is mobile-local  
**Project Type**: Single Flutter application  
**Performance Goals**: Load a 90-day history with typical medication schedules in under 500 ms in widget/domain tests; avoid startup work beyond existing reconciliation; no polling or background history processing  
**Constraints**: Offline and account-free; medication data remains on device; large text and screen reader support; non-color-only status indicators; localization-ready English and Latin American Spanish copy; 60-minute missed boundary; no clinical advice, scores, sharing, sync, export, backup, analytics, or editing past outcomes in v1  
**Scale/Scope**: One new user-facing history screen plus supporting domain/repository helpers, l10n strings, and tests; rolling 90-day review window; one history row per scheduled medication reminder occurrence

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS. History is reachable from the existing reminder dashboard with no setup, account, filters, scoring, or editing controls.
- **Setup/onboarding UX baseline**: N/A. This feature does not add setup or onboarding screens; the history view still follows `docs/ux-design.md` tone, spacing, readability, and pressure-free guidance.
- **Accessibility for older adults**: PASS. The plan requires large text-safe grouping, semantic labels, logical reading order, visible navigation targets, and text plus icon/shape status indicators.
- **Reliable local-first reminders**: PASS. The feature reads and records local reminder state only, preserves the existing 60-minute missed rule, and does not add remote services.
- **Privacy and user control**: PASS. No account, sync, export, analytics, backup, or sharing is introduced; history remains in local device storage.
- **Maintainable architecture**: PASS. Domain history assembly, repository persistence, notification/reminder state, and UI presentation remain separated and testable.
- **Testing gate**: PASS. Required tests cover history entry creation/normalization, 90-day retention, missed boundary, snooze/final outcome behavior, snapshots after medication edits/deletion, localization, and accessible widget rendering.
- **Consistent, localizable experience**: PASS. User-visible labels, empty state, dates, times, and status copy must use Flutter l10n and `intl` formatting for English and Latin American Spanish.
- **Measured performance**: PASS. The feature avoids new dependencies and background work; history loading is bounded to 90 days and measured in domain/widget tests.

## Project Structure

### Documentation (this feature)

```text
specs/006-medication-history/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── medication-history-ui.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── features/
│   └── medications/
│       ├── data/
│       │   ├── medication_history_repository.dart
│       │   └── local_medication_history_repository.dart
│       ├── domain/
│       │   ├── medication_history.dart
│       │   └── medication_history_service.dart
│       └── presentation/
│           ├── medication_history_screen.dart
│           ├── medication_history_day_section.dart
│           └── medication_history_status_label.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
└── services/
    ├── reminder_action_handler.dart
    └── reminder_due_reconciler.dart

test/
├── features/
│   └── medications/
│       ├── medication_history_service_test.dart
│       ├── medication_history_repository_test.dart
│       ├── medication_history_screen_test.dart
│       └── fakes/
│           └── fake_medication_history_repository.dart
└── widget_test.dart
```

**Structure Decision**: Use the existing single Flutter app layout under `lib/features/medications/{domain,data,presentation}`. Add history-specific domain/service/repository files because the current `DailyReminderHandling` model only records dashboard "handled" actions and does not preserve distinct taken/skipped/missed/snoozed outcomes or medication snapshots across edits/deletion. Wire the screen from `lib/main.dart` and reuse existing app theme and l10n patterns.

## Complexity Tracking

No constitution violations.

## Phase 0 Research

Completed in [research.md](./research.md). Key decisions:

- Store reviewable history locally in a dedicated SharedPreferences-backed medication history repository.
- Normalize one entry per scheduled reminder occurrence with final outcomes preferred over snooze activity.
- Use captured medication display name and dosage label at occurrence/outcome time.
- Present history as newest-first local day sections using localized date/time formatting.

## Phase 1 Design

Completed artifacts:

- [data-model.md](./data-model.md)
- [contracts/medication-history-ui.md](./contracts/medication-history-ui.md)
- [quickstart.md](./quickstart.md)

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS. The UI contract adds one dashboard entry point and one review screen.
- **Setup/onboarding UX baseline**: N/A. No setup or onboarding changes.
- **Accessibility for older adults**: PASS. Data model and UI contract include semantics, non-color indicators, large text behavior, and empty state requirements.
- **Reliable local-first reminders**: PASS. Contracts use local repositories and existing reminder reconciliation/action flows only.
- **Privacy and user control**: PASS. No remote interface or account flow is introduced.
- **Maintainable architecture**: PASS. History recording, query normalization, and presentation have explicit boundaries and focused tests.
- **Testing gate**: PASS. Quickstart identifies automated and manual verification paths.
- **Consistent, localizable experience**: PASS. UI contract requires ARB-backed strings and `intl` date/time formatting.
- **Measured performance**: PASS. 90-day query and render expectations are bounded and testable without new background work.

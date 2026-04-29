# Implementation Plan: Setup Page

**Branch**: `001-setup-page` | **Date**: 2026-04-29 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/001-setup-page/spec.md`

## Summary

Build a first-run setup flow for the Flutter pill reminder app on phones and tablets. The flow will use the UX guidance in [ux-design.md](./ux-design.md): one calm decision per screen, large readable text, full-width 56px minimum actions, warm styling, and no account friction. Setup preferences will be saved locally through a small storage abstraction so the app stays offline and account-free now while leaving a clear migration path to Firebase-backed user and medication data later.

## Technical Context

**Language/Version**: Dart SDK `^3.11.5`, Flutter Material 3  
**Primary Dependencies**: Flutter SDK, `cupertino_icons`; planned additions: `shared_preferences` for local setup preferences and a notification-permission capability through the app notification service  
**Storage**: Local device preferences for setup completion, selected language, privacy acknowledgement, and notification permission status; storage access wrapped behind a repository interface to allow a future Firebase-backed implementation  
**Testing**: `flutter test`, widget tests for setup flow and accessibility semantics, repository unit tests for local preference persistence, manual notification permission verification on Android and iOS devices/simulators  
**Target Platform**: iOS and Android phones and tablets  
**Project Type**: Mobile app  
**Performance Goals**: First setup screen visible within 1 second after app start on typical devices; setup step transitions complete without perceptible delay; no background polling or remote calls during setup  
**Constraints**: Offline-capable, account-free core use, no medication data sharing, large text, screen reader support, high contrast, large touch targets, localizable English and Latin American Spanish copy  
**Scale/Scope**: One first-run setup flow with three primary screens plus a non-blocking main-app reminder status when notifications are unavailable; one local setup preference record per device user

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - Three primary setup decisions only: language, privacy acknowledgement, notification choice. The main-app notification status is non-blocking.
- **Accessibility for older adults**: PASS - UX plan requires large text, screen reader labels, high contrast, focus indicators, 56px minimum actions, and non-color-only status.
- **Reliable local-first reminders**: PASS - Setup works offline and records notification permission state locally. Reminder scheduling remains outside this feature, with manual permission verification planned.
- **Privacy and user control**: PASS - No account, analytics, sharing, backup, sync, donation, or remote dependency is introduced. Firebase is treated as a future optional backend behind an abstraction, not part of this release.
- **Maintainable architecture**: PASS - UI, setup state, local persistence, and notification permission checks are separated. Repository abstraction is justified by explicit future Firebase migration need.
- **Testing gate**: PASS - Automated widget/unit tests and manual platform notification checks are identified.
- **Consistent, localizable experience**: PASS - All setup copy and permission states are planned as localizable English and Latin American Spanish content.
- **Measured performance**: PASS - Startup/setup responsiveness goals are defined, and no polling or background work is introduced.

## Project Structure

### Documentation (this feature)

```text
specs/001-setup-page/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── ux-design.md
├── contracts/
│   └── setup-flow-contract.md
├── checklists/
│   └── requirements.md
└── spec.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── features/
│   └── setup/
│       ├── data/
│       │   ├── setup_preferences_repository.dart
│       │   └── local_setup_preferences_repository.dart
│       ├── domain/
│       │   ├── setup_language.dart
│       │   ├── setup_state.dart
│       │   └── notification_permission_status.dart
│       └── presentation/
│           ├── setup_flow.dart
│           ├── language_selection_screen.dart
│           ├── privacy_explanation_screen.dart
│           ├── notification_permission_screen.dart
│           └── reminder_status_banner.dart
├── l10n/
│   ├── app_en.arb
│   └── app_es_419.arb
└── services/
    └── notification_permission_service.dart

test/
├── features/
│   └── setup/
│       ├── setup_flow_test.dart
│       ├── setup_preferences_repository_test.dart
│       └── reminder_status_banner_test.dart
└── widget_test.dart
```

**Structure Decision**: Use a feature-oriented Flutter structure under `lib/features/setup/` so setup UI, state, and persistence can be tested independently. Keep the local repository implementation small, but define a repository interface now because the user explicitly wants local storage with a future Firebase upgrade path for users and medication data.

## Complexity Tracking

No constitution violations.

## Design Justifications

| Added Design Choice | Why Needed | Simpler Alternative Rejected Because |
|---------------------|------------|-------------------------------------|
| Repository abstraction for setup preferences | The feature must use local storage now while preserving a future Firebase upgrade path for user and medication data | Direct `shared_preferences` calls from widgets would be simpler today but would mix UI with persistence and make Firebase migration harder |

## Phase 0: Research Summary

Research decisions are documented in [research.md](./research.md). All planning unknowns are resolved with conservative Flutter choices aligned to the constitution and UX guide.

## Phase 1: Design Summary

- Data entities and state transitions are documented in [data-model.md](./data-model.md).
- UI and state contracts are documented in [contracts/setup-flow-contract.md](./contracts/setup-flow-contract.md).
- Manual verification and developer startup steps are documented in [quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - Design preserves three setup screens and one non-blocking reminder status.
- **Accessibility for older adults**: PASS - Contracts include semantics, focus, contrast, large text, and touch target requirements.
- **Reliable local-first reminders**: PASS - Local preference persistence and notification status recovery are explicit.
- **Privacy and user control**: PASS - No remote service or account is part of this feature; future Firebase support remains behind an interface.
- **Maintainable architecture**: PASS - Feature modules separate presentation, domain state, persistence, and notification permission integration.
- **Testing gate**: PASS - Quickstart and contracts identify required widget, unit, localization, accessibility, and manual permission checks.
- **Consistent, localizable experience**: PASS - ARB localization files and locale codes are planned for English and Latin American Spanish.
- **Measured performance**: PASS - Setup path has measurable startup and interaction goals with no polling or remote calls.

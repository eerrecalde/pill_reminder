# Implementation Plan: Settings and Privacy

**Branch**: `007-settings-privacy` | **Date**: 2026-05-09 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/007-settings-privacy/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Create a calm, accessible settings area for language, device-based accessibility explanation, notification status, privacy explanation, and local data control. The implementation extends the existing Flutter setup/preferences screen into a settings feature, reuses local SharedPreferences-backed repositories and the current notification permission service, adds a local reminder data control service for snapshot/delete/30-second undo restore, and keeps all copy localization-ready for English and Latin American Spanish.

## Technical Context

**Language/Version**: Dart SDK ^3.11.5 with Flutter  
**Primary Dependencies**: Flutter Material, flutter_localizations, intl, shared_preferences, permission_handler, flutter_local_notifications, timezone/flutter_timezone  
**Storage**: Local device storage via SharedPreferences-backed repositories for setup preferences, medications, reminder schedules, due reminders, daily handling state, and medication history  
**Testing**: flutter_test widget/unit tests; manual notification permission verification on device/emulator  
**Target Platform**: Flutter mobile app for Android/iOS-class devices, using platform notification permissions and local notifications  
**Project Type**: Mobile app  
**Performance Goals**: Settings opens within 500ms for typical stored local data on a supported device; notification status refresh completes within 1 second when the platform responds; delete/restore local data completes within 2 seconds for typical single-user reminder data; no new background polling or startup-heavy work  
**Constraints**: Offline-capable, account-free, no ads/tracking/remote services, large text and screen reader support, 48px minimum touch targets with 56px preferred destructive/primary actions, one primary decision per destructive confirmation step, localization-ready English and Latin American Spanish copy  
**Scale/Scope**: Single-user local app settings surface covering the existing setup preferences plus local medication/reminder repositories and medication history

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - one settings entry opens clearly labeled sections; destructive deletion uses a separate confirmation and a single recovery affordance.
- **Setup/onboarding UX baseline**: PASS - settings extends the same calm tone, spacing, readable text, pressure-free choices, and privacy posture from `docs/ux-design.md`.
- **Accessibility for older adults**: PASS - plan covers large text reflow, screen reader order/labels, readable contrast, visible focus, non-color-only statuses, and safe error recovery.
- **Reliable local-first reminders**: PASS - reminder data stays local/offline; deletion cancels related local notification schedules and due reminders deterministically.
- **Privacy and user control**: PASS - no account, ads, analytics, backup, sync, sharing, donation, or remote service behavior is added.
- **Maintainable architecture**: PASS - UI remains presentation-only; data control logic is isolated in a service using existing repository interfaces.
- **Testing gate**: PASS - automated tests cover localization persistence, status states, delete/cancel/undo/no-data/error flows, and manual verification covers platform notification permission behavior.
- **Consistent, localizable experience**: PASS - all new user-visible text belongs in ARB localization files for English and Latin American Spanish.
- **Measured performance**: PASS - no new dependencies or background work; local operations have explicit responsiveness targets.

## Project Structure

### Documentation (this feature)

```text
specs/007-settings-privacy/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── settings-ui-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
├── services/
│   └── notification_permission_service.dart
├── features/
│   ├── setup/
│   │   ├── data/
│   │   │   ├── local_setup_preferences_repository.dart
│   │   │   └── setup_preferences_repository.dart
│   │   ├── domain/
│   │   │   ├── notification_permission_status.dart
│   │   │   ├── setup_language.dart
│   │   │   └── setup_state.dart
│   │   └── presentation/
│   │       └── setup_preferences_screen.dart
│   ├── medications/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/
│       ├── data/
│       │   └── local_reminder_data_control_service.dart
│       ├── domain/
│       │   ├── deletion_recovery_window.dart
│       │   ├── local_reminder_data_snapshot.dart
│       │   └── reminder_data_control_service.dart
│       └── presentation/
│           ├── data_deletion_confirmation_dialog.dart
│           └── settings_screen.dart

test/
├── features/
│   ├── setup/
│   ├── medications/
│   └── settings/
│       ├── data_control_service_test.dart
│       └── settings_screen_test.dart
└── widget_test.dart
```

**Structure Decision**: Add a `features/settings` slice for settings-specific domain/data/presentation concerns while reusing existing `features/setup` language/notification models and existing medication repositories. The current `SetupPreferencesScreen` can be replaced by, renamed into, or wrapped by `SettingsScreen`; the implementation should choose the smallest edit that preserves existing navigation from `main.dart`.

## Complexity Tracking

No constitution violations. The only new feature slice is justified because local data deletion/recovery spans multiple medication repositories and should stay separate from setup onboarding.

## Phase 0: Research

See [research.md](./research.md). Decisions resolved:

- Keep settings local-first and dependency-free beyond current packages.
- Persist language through the existing setup preference repository and Flutter locale state.
- Check notification status through `NotificationPermissionService`.
- Implement destructive data control as a local snapshot/delete/restore service with a 30-second in-memory recovery window.
- Localize all user-facing copy in ARB files.

## Phase 1: Design And Contracts

See [data-model.md](./data-model.md), [quickstart.md](./quickstart.md), and [contracts/settings-ui-contract.md](./contracts/settings-ui-contract.md).

### Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - contracts keep the settings screen grouped and push deletion into a deliberate confirmation.
- **Setup/onboarding UX baseline**: PASS - quickstart requires verification against `docs/ux-design.md`.
- **Accessibility for older adults**: PASS - data model and UI contract define labels, reading order, text reflow, status text, and recovery/error states.
- **Reliable local-first reminders**: PASS - deletion scope includes medication records, schedules, due reminders, daily handling state, history, and local notification cancellation.
- **Privacy and user control**: PASS - privacy explanation and data control document that no remote or account behavior is introduced.
- **Maintainable architecture**: PASS - repository-facing data service is testable independently from UI.
- **Testing gate**: PASS - quickstart lists automated and manual checks required before implementation is accepted.
- **Consistent, localizable experience**: PASS - contracts require English and Latin American Spanish strings for every visible state.
- **Measured performance**: PASS - quickstart includes timing checks and confirms no background polling.

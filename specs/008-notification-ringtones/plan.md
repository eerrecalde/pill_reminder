# Implementation Plan: Notification Ringtones

**Branch**: `009-notification-ringtones` | **Date**: 2026-05-15 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/008-notification-ringtones/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Add a settings-based ringtone picker for medication reminder notifications using a curated list of app-bundled sounds. The selected sound is stored locally, previewed in-app before saving, and applied to future scheduled, due-now, and remind-later medication notifications through `flutter_local_notifications`, with default-sound fallback when a saved option is unavailable or platform settings block custom sound playback.

## Technical Context

**Language/Version**: Dart SDK `^3.11.5`, Flutter app  
**Primary Dependencies**: Flutter Material, `flutter_local_notifications ^21.0.0`, `shared_preferences ^2.5.3`, `permission_handler ^12.0.1`, `timezone ^0.11.0`, `flutter_timezone ^5.0.1`, `flutter_localizations`; add `audioplayers` or equivalent lightweight asset playback package for in-app preview only  
**Storage**: `shared_preferences` for local ringtone preference; bundled sound files in `assets/audio/notifications/`, `android/app/src/main/res/raw/`, and iOS runner bundle resources  
**Testing**: `flutter test`, widget tests under `test/features/settings/`, unit tests for ringtone domain/repository/scheduler details, manual iOS/Android notification sound verification  
**Target Platform**: Flutter mobile app targeting Android and iOS  
**Project Type**: Mobile app  
**Performance Goals**: Settings picker opens in under 500ms with local options; preview starts within 250ms after tap on typical devices; no startup network work; no recurring background work; notification scheduling remains responsive for existing medication flows  
**Constraints**: Account-free, offline-capable, local-first, privacy-preserving; app-bundled curated sounds only; notification permission, mute, focus, and do-not-disturb settings may override audible playback; Android notification channel sound is immutable after channel creation, so selected sounds require stable per-sound channel ids  
**Scale/Scope**: One global ringtone preference for all medication reminder notifications; small curated option set including default; settings UI, local persistence, notification detail construction, platform audio assets, localization, accessibility, and tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS. One settings entry opens one picker for a single global reminder sound; custom file browsing and per-medication sounds are out of scope.
- **Setup/onboarding UX baseline**: PASS. This is a settings flow, not onboarding, but it follows the same calm, single-decision, large-target guidance from `docs/ux-design.md`.
- **Accessibility for older adults**: PASS. Picker contract covers large text, screen reader labels, 48px+ targets, non-color selected/unavailable states, and clear permission/device-setting explanations.
- **Reliable local-first reminders**: PASS. Preference and sound files are local; no account or internet is needed; scheduler falls back to the default notification sound.
- **Privacy and user control**: PASS. No sharing, analytics, accounts, backup, remote service, or user audio import is introduced.
- **Maintainable architecture**: PASS. Ringtone domain objects, repository, preview service, scheduler sound details, and settings UI remain separate and testable.
- **Testing gate**: PASS. Automated domain, repository, widget, localization, and scheduler-detail tests are identified; platform notification sound playback remains a manual verification item.
- **Consistent, localizable experience**: PASS. All user-facing picker, warning, device-setting, preview, and unavailable-sound copy will be added to English and Latin American Spanish localization resources.
- **Measured performance**: PASS. Uses a small bundled list, local storage, no polling, and no startup network or background work.

## Project Structure

### Documentation (this feature)

```text
specs/008-notification-ringtones/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── notification-ringtone-ui.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── features/
│   ├── settings/
│   │   └── presentation/
│   │       ├── settings_screen.dart
│   │       └── notification_ringtone_picker_screen.dart
│   └── notifications/
│       ├── data/
│       │   └── local_notification_ringtone_repository.dart
│       ├── domain/
│       │   └── notification_ringtone.dart
│       └── services/
│           └── ringtone_preview_player.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
└── services/
    └── reminder_notification_scheduler.dart

assets/
└── audio/
    └── notifications/

android/app/src/main/res/raw/
ios/Runner/

test/
├── features/
│   ├── notifications/
│   └── settings/
└── services/
```

**Structure Decision**: Use the existing single Flutter app structure. Add notification-ringtone domain, persistence, and preview services under a small `lib/features/notifications/` area because the behavior is shared by settings UI and scheduler delivery. Keep the settings entry and picker under `lib/features/settings/presentation/`. Extend the existing scheduler rather than adding a second notification scheduling abstraction.

## Complexity Tracking

No constitution gate violations.

## Phase 0 Research Summary

See [research.md](research.md).

## Phase 1 Design Summary

See [data-model.md](data-model.md), [quickstart.md](quickstart.md), and [contracts/notification-ringtone-ui.md](contracts/notification-ringtone-ui.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS. Design remains one global preference with preview and save; no custom audio browser or per-reminder branching.
- **Setup/onboarding UX baseline**: PASS. Picker uses existing settings section patterns and `docs/ux-design.md` accessibility/spacing principles.
- **Accessibility for older adults**: PASS. Contract specifies semantics, large text behavior, touch targets, and non-color state communication.
- **Reliable local-first reminders**: PASS. Data model stores stable local ids, validates against bundled options, and defaults safely.
- **Privacy and user control**: PASS. No remote data, imported audio, analytics, accounts, or backup behavior.
- **Maintainable architecture**: PASS. Artifacts define small domain/repository/player/scheduler contracts with focused tests.
- **Testing gate**: PASS. Quickstart lists automated and manual checks, including platform notification sound verification.
- **Consistent, localizable experience**: PASS. All copy is localization-ready for English and Latin American Spanish.
- **Measured performance**: PASS. Small local assets and no background/polling work keep the feature within measured goals.
